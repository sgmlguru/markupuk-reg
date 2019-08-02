xquery version "3.1";

module namespace ipnl2 = "http://markupuk.org/registration/ipn-listener2";

declare namespace err = "http://www.w3.org/2005/xqt-errors";
declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace http = "http://expath.org/ns/http-client";

(: Indicates if the sandbox endpoint is used :)
declare variable $ipnl2:use-sandbox := true();

(: Production Postback URL :)
declare variable $ipnl2:verify-uri := "https://ipnpb.paypal.com/cgi-bin/webscr";

(: Sandbox Postback URL :)
declare variable $ipnl2:sandbox_verify_uri := "https://ipnpb.sandbox.paypal.com/cgi-bin/webscr";

(: Response from PayPal indicating validation was successful :)
declare variable $ipnl2:valid := "VERIFIED";

(: Response from PayPal indicating validation failed :)
declare variable $ipnl2:invalid := "INVALID";



(: This is the listener :)
declare function ipnl2:listener($body) {
    let $s := xmldb:store-as-binary('/db/MUK-data/sandbox','debug1.xml',$body)
    let $verified := ipnl2:verify-ipn($body)
    let $_ :=
        if ($verified)
        then (xmldb:store-as-binary('/db/MUK-data/sandbox','debug2.xml',$body))
            (:
             : Process IPN
             : A list of variables is available here:
             : https://developer.paypal.com/webapps/developer/docs/classic/ipn/integration-guide/IPNandPDTVariables/
             :)
        else ()
    
    return

        (: Reply with an empty 200 response to indicate to paypal the IPN was received correctly. :)
        (
            <rest:response>
                 <http:response status="200" reason="OK"/>
            </rest:response>,
            ""
        )
};


(: Verify the IPN :)
declare
    %private
function ipnl2:verify-ipn($body) as xs:boolean {

    if (empty($body))
    then
        fn:error((), "Missing POST Data")
    else
        
        (: TODO do we need to Base64 decode $body first? e.g.

            let $body := util:base64-decode($body)
            return
        :)
        (:let $body := util:base64-decode($body):)
        
        let $my-post := ipnl2:parse-ipn-from-body($body)


       (: NOTE: ALL the IPN data is now in  $my-post - you probably want to do something with it, like store it in the DB etc?
            See - https://developer.paypal.com/docs/classic/ipn/integration-guide/IPNIntro/#ipn-overview
       :)
       

        (: Build the body of the verification post request, adding the _notify-validate command. :)
        let $req := "cmd=_notify-validate"  || "&amp;" || ipnl2:serialize-ipn-for-body($my-post)
        
        let $debug := xmldb:store-as-binary('/db/MUK-data/sandbox','debug-verify.xml',$req)
        
        (: Post the data back to PayPal, using EXPath HTTP Client. Throw exceptions if errors occur. :)
        let $res := http:send-request(
            <http:request http-version="1.1" method="POST">
                <http:header name="User-Agent" value="PHP-IPN-Verification-Script"/>
                <http:header name="Connection" value="Close"/>
            </http:request>,
            ipnl2:get-paypal-uri(),
            $req
        )
        
        return
        
            if ($res[1]/@status ne "200")
            then
                fn:error((), "PayPal responded with http code" || $res[1]/@status)
            else
            
                (: Check if PayPal verifies the IPN data, and if so, return true. :)
            
                if ($res[2] eq $ipnl2:valid)
                then
                    true()
                else
                    false()
};


(:~
 : Parses an IPN from a HTTP Request Body into an XDM array
 : 
 : Each entry in the array is a sequence of two values, the first is a key, the second is the value
 :
 :)
declare
    %private
function ipnl2:parse-ipn-from-body($body) as array(*) {
    let $raw-post-array := array { fn:tokenize($body, "&amp;") }
    return
        let $my-post :=
            array:for-each($raw-post-array, function($keyval) {
                let $keyval := fn:tokenize($keyval, "=")
                return
                    if (count($keyval) eq 2)
                    then
                        let $keyval :=
                            (: Since we do not want the plus in the datetime string to be encoded to a space, we manually encode it. :)
                            if ($keyval[1] eq "payment_date")
                            then
                                if (ipnl2:substr-count($keyval[2], "\+") eq 1)
                                then
                                    ($keyval[1], replace($keyval[2], "\+", "%2B"))
                                else
                                    $keyval
                            else
                                $keyval
                        return
                            ($keyval[1], xmldb:decode($keyval[2]))
                    else
                        ()
            })
        return
            $my-post
};

declare
    %private
function ipnl2:serialize-ipn-for-body($my-post as array(*)) as xs:string? {
    array:fold-left(
        array:for-each($my-post, function($keyval) {
            let $key := $keyval[1]
            let $value := xmldb:encode-uri($keyval[2])
            return
                $key || "=" || $value
        }),
        (),
        function($a, $b) {
            if ($a) then
                $a || "&amp;" || $b
            else
                $b
        }
    )
};

declare
    %private
function ipnl2:get-paypal-uri() {
    if ($ipnl2:use-sandbox)
    then
        $ipnl2:sandbox_verify_uri
    else
        $ipnl2:verify-uri
};

declare
    %private
function ipnl2:substr-count($str as xs:string, $pattern as xs:string) as xs:integer {
    count(analyze-string($str, $pattern)//fn:match)
};
