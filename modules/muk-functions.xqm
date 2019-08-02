xquery version "3.1";

module namespace muk = "http://www.sgmlguru.org/ns/muk";
import module namespace sm="http://exist-db.org/xquery/securitymanager";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare namespace util="http://exist-db.org/xquery/util";

(: The app config file :)
declare variable $muk:config := doc('/db/apps/MUK-reg/resources/xml/config.xml');

(: Run environment - sandbox or live :)
declare variable $muk:env := tokenize($muk:config//data-uri,'/')[last()];

(: Markup UK official email :)
declare variable $muk:business-email := $muk:config//business/email/text();

(: Where the registration data for paid delegates lives :)
declare variable $muk:data-collection-uri := concat($muk:config//data-uri/text(),'/',$muk:config//collections//data/text());

(: Where the transactions live :)
declare variable $muk:transactions-collection-uri := concat($muk:config//data-uri/text(),'/',$muk:config//collections//transactions/text());



(: Get a delegate's registration data based on the person's UID :)

declare function muk:getData($uid as xs:string) {
    let $data-collection := collection($muk:data-collection-uri)
    return $data-collection//person[@uid=$uid]
};


(: Generate the invoice based on the delegate's registered info :)

declare function muk:generateInvoice($data as item()) {
    let $xsl := $muk:config//stylesheets/fo/text()
    
    (: Get path where to save PDFs :)
    let $path := concat($muk:config//data-uri/text(),'/pdf')
    
    (: Get amount - delegate data only contains reg type and discount :)
    let $amount := muk:getPrice($data)
    
    let $payVAT := muk:payVat($data)
    
    (: Use the timestam in $data to name the PDF :)
    let $dateTimeString := translate(string($data//person[1]//date/text()),'-+:.','')
    let $save := concat(translate($data//person[1]//name/text(),' ',''),'-',$dateTimeString,'.pdf')
    
    (: Generate PDF :)
    let $pdf := xslfo:render(transform:transform($data,doc($xsl),<parameters><param name="amount" value="{$amount}"/><param name="vat" value="{$payVAT}"/></parameters>),'application/pdf',())
    
    return xmldb:store($path,$save,$pdf)
};


(: Check the number of registrations; used for generating the invoice number in muk:register() :)

declare function muk:numberOfRegistrations($path as xs:string) {
    let $count := count(collection($path)//person[1][@uid])
    return <data>{$count}</data>
};


(: When the delegate hits Register, this saves the registration data in an XML file and saves it to tmp :)

declare function muk:register($data as item()) {
    (: This is the tmp collection for delegates who have registered but not yet paid :)
    let $tmp-path := concat($muk:config//data-uri/text(),'/',$muk:config//collections//tmp/text())
    
    (: The UID is just a count of delegates in ${ENV}/tmp :)
    let $uid := muk:numberOfRegistrations($tmp-path) + 1
    
    (: Get the date and time to insert into XML and to name the temp file :)
    let $timeDateStamp := string(current-dateTime())
    
    (: Temp filename for XML with datetime string minus offending characters :)
    let $save := concat(translate($data//person[1]//name/text(),' ',''),'-',translate($timeDateStamp,'-+:.',''),'-','tmp.xml')
    
    (: Save the temp XML in the ${ENV}/tmp collection :)
    let $tmp-file := xmldb:store(concat($muk:config//data-uri/text(),'/',$muk:config//collections//tmp/text()),$save,$data)
    
    (: Insert the datetime string into XML :)
    let $date-insert := update insert <date>{$timeDateStamp}</date> into doc($tmp-file)//person[1]
    
    (: The UID is just a counter for temp delegates :)
    let $insert-uid := update insert attribute uid {$uid} into doc($tmp-file)//person[1]
    
    (: Temp delegates have not paid yet :)
    let $insert-paid := update insert attribute paid {'no'} into doc($tmp-file)//person[1]
    
    return $tmp-file
};


(: Get price for the delegate's registration type :)

declare function muk:getPrice($data as item()) {
    (: Registration type, i.e. early-bir, full... :)
    let $type := $data//person[1]//type/text()
    
    (: EU citizens and UK companies pay VAT, others don't; true or false :)
    let $pay-vat := muk:payVat($data)
    
    (: Check if the discount string is valid :)
    let $discount := if (matches(concat(' ',string-join($muk:config//discount/label,' '),' '),concat(' ',$data//person[1]/discount/text(),' ')))
                        then ($data//person[1]/discount)
                        else ()
    
    (: If a valid discount string was used, use the discount rates instead :)
    let $use-discount := if ($discount!='' and $muk:config//discount/label=$discount)
                         then true()
                         else (false())
    
    (: Calculate the actual rate based on the above :)
    let $amount := if ($use-discount=true() and $pay-vat=true()) 
                   then ($muk:config//discount[label=$discount]/@inc)
                   else if ($use-discount=true() and $pay-vat=false())
                   then ($muk:config//discount[label=$discount]/@exc)
                   else if ($use-discount=false() and $pay-vat=true())
                   then ($muk:config//type[value=$type]/@inc)
                   else ($muk:config//type[value=$type]/@exc)
    
    return number($amount)
};


(: Should delegate pay VAT? true or false :)

declare function muk:payVat ($data as item()) {
    (: EU country, true or false :)
    let $eu := if ($data//person[1]//eu='true') then ('true') else ('false')
    
    return if ($data//person[1]//country = 'United Kingdom')
            then (true())
            else if ($eu='false')
            then (false())
            else if ($data//person[1]//reverse-charge='true' and $eu ='true')
            then (false())
            else if ($data//person[1]//reverse-charge='false' or $data//person[1]//reverse-charge='' and $eu ='true')
            then (true())
            else (false())
};


(: Generate a HTML summary of the registered person's info; to be displayed with the Paypal button :)

declare function muk:generateSummary($data as item()) {
    let $xsl := $muk:config//stylesheets/summary/text()
    
    (: Get the right amount - $data only includes reg type and discount :)
    let $amount := muk:getPrice($data)
    let $params := <parameters><param name="amount" value="{$amount}"/></parameters>
    
    return transform:transform($data,doc($xsl),$params)
};


(: Generate the invoice and send a confirmation email; $data is the person who registered :)

declare function muk:generateEmail($data as item()) {
    
    (: Generate the PDF from the delegate XML and return the URI :)
    let $pdf-uri := muk:generateInvoice($data)
    
    (: The PDF filename for the attachment :)
    let $filename := tokenize($pdf-uri,'/')[last()]
    
    (: Do email session :)
    let $mail-handle := mail:get-mail-session
  (
    <properties>
      <property name="mail.smtp.user" value="ari@markupuk.org"/>
      <property name="mail.smtp.password" value="Favorit70"/>
      <property name="mail.smtp.host" value="smtp.minotaur.net.uk"/>
      <property name="mail.smtp.port" value="465"/>
      <property name="mail.smtp.auth" value="false"/>
      <property name="mail.smtp.ssl.enable" value="true"/>
      <property name="mail.smtp.allow8bitmime" value="true"/>
    </properties>
  )

    let $year := '2019'
    
    (: The delegate's email address, or the payer's if the att markup is in place :)
    let $address := if ($data//att/email) then ($data//att/email/text()) else ($data//person[1]/email/text())
    
    
    (: The email itself :)
    let $email := <mail> <from>{$muk:business-email}</from> <reply-to>{$muk:business-email}</reply-to> <to>{$address}</to> <cc/> <bcc>{$muk:business-email}</bcc> <subject>Registration for Markup UK {$year}</subject> <message> <text>Dear {if ($data//att/name) then ($data//att/name/text()) else ($data//person[1]/name/text())},
    
    Thank you very much for registering for Markup UK {$year}! Your invoice is attached.
    {if ($data//person[1]/dietary!='') then (concat('
    We have registered the following dietary requirements: ',$data//person[1]/dietary,'
    ')) else ()}
    
    We look forward to seeing you in June!
    
    Geert, Tom, Ari, Andrew, Rebecca and Bethan</text>  </message> <attachment filename="{$filename}" mimetype="application/pdf">{util:binary-doc($pdf-uri)}</attachment> </mail>
    
    
    (: Send the email :)
    let $send := mail:send-email($mail-handle,$email)

    return $send
};


(: When we receive payment confirmation from Paypal, we save the tmp XML file in the data collection and set //person/@paid='yes' :)
(: $tmp-file is the URI to the tmp registration XML, $payment_status is the status of the payment returned by Paypal and must be 'Completed' :)

declare function muk:delegatePaid($tmp-file as xs:anyURI, $payment_status as xs:string) {
    let $data := doc($tmp-file)
    
    (: This time, we need to look at delegates who've paid :)
    let $data-path := concat($muk:config//data-uri/text(),'/',$muk:config//collections//data/text())
    
    (: Count only paid delegates, base invoice number on them :)
    let $invoice-number :=  muk:numberOfRegistrations($data-path) + 1
    
    (: Invoice number :)
    let $invoice-number-insert := update insert <invoice>{concat($muk:config//prefixes/invoice/text(),$invoice-number)}</invoice> into doc($tmp-file)//person[1]
    
    let $insert-paid := if ($payment_status='Completed')
                        then (update insert attribute paid {'yes'} into doc($tmp-file)//person)[1]
                        else ()
    
    return if ($payment_status='Completed')
           then (xmldb:store(concat($muk:config//data-uri/text(),'/',$muk:config//collections//data/text()),
                             replace(tokenize($tmp-file,'/')[last()],'-tmp',''),
                             $data))
           else ()
};


(: Create and prep the MUK-data collections :)

declare function muk:createCollections($base) {
    
    (: Add the data base URI to the config :)
    let $config-data-root := if ($muk:config//data-root)
                                    then (update replace $muk:config//data-root with <data-root>{$base}</data-root>)
                                    else (update insert <data-root>{$base}</data-root> following $muk:config//domain)
    
    (: Create the MUK data root collection :)
    let $data-root := xmldb:create-collection($base,$muk:config//collections/root/text())
    
    (: Create the sandbox and live collections :)
    let $sandbox := xmldb:create-collection($data-root,$muk:config//collections/sandbox/text())
    let $live := xmldb:create-collection($data-root,$muk:config//collections/live/text())
    
    (: Create the required data subcollections :)
    let $subs := for $coll in ($sandbox,$live)
                    return
                        for $s in $muk:config//sub/*
                            return (
                                let $uri := xmldb:create-collection($coll,$s/text())
                                return (
                                    sm:chown($uri, "admin"),
                                    sm:chgrp($uri, "delegates"),
                                    sm:chmod($uri, "rwxrwxrwx")
                                )
                            )
    return $data-root
};


(: Update config data URI (environment sandbox/live) :)

declare function muk:updateDataUri($env,$data-uri) {
    let $env := update replace $muk:config//current with <current>{$env}</current>
    let $update := update replace $muk:config//data-uri with <data-uri>{$data-uri}</data-uri>
    return $update
};


(: Update config eXist-DB domain :)

declare function muk:updateDomain($domain) {
    let $update := update replace $muk:config//domain with <domain>{$domain}</domain>
    return $update
};


(: Update config pricing :)

declare function muk:updatePricing($pricing) {
    let $update := update replace $muk:config//pricing with $pricing
    return $update
};



(: When payment is complete, we need to insert the transaction timestamp and orderID into the delegate's tmp XML :)

declare function muk:insertTransactionDetails($tmp-file as xs:string){
    let $person := doc($tmp-file)
    let $uid := string($person//person[1]/@uid)
    let $transaction-details := doc(concat($muk:transactions-collection-uri,'/uid-',$uid,'.xml'))
    let $update := update insert attribute orderID {string($transaction-details//@orderID)} into $person//person[1]
    let $tstamp := update insert attribute tstamp {string($transaction-details//@tstamp)} into $person//person[1]
    
    return $tmp-file
};

