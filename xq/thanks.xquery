xquery version "3.1";

import module namespace muk="http://www.sgmlguru.org/ns/muk" at "/db/apps/MUK-reg/modules/muk-functions.xqm";
import module namespace pay="http://markupuk.org/registration/pay" at "/db/apps/MUK-reg/modules/muk-paypal.xqm";
import module namespace jsjson = "http://johnsnelson/json" at "/db/apps/dashboard/plugins/userManager/jsjson.xqm";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare option exist:serialize "method=xhtml media-type=text/html";

let $login := xmldb:login('/db','USER','PASSWORD')

let $tmp-file := request:get-parameter('tmp-file','')

let $delegate-paid := if (muk:insertTransactionDetails($tmp-file) = $tmp-file) then ('Completed') else ()

(: Provides the URI to the paid delegate XML data :)
let $paid := muk:delegatePaid($tmp-file,$delegate-paid)
let $person := doc($paid)

let $email := muk:generateEmail($person)


let $html := <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      
    </head>
    
    <body>
    
    <h1>Thank you!</h1>
    <p>We've registered your payment and sent a confirmation email with an invoice to {if (doc($tmp-file)//att/email) then (doc($tmp-file)//att/email) else (doc($tmp-file)//person[1]/email)}.</p>
    <p>We look forward to seeing you in June!</p>
    <br/>
    <p>Geert, Tom, Ari, Andrew, and Rebecca.</p>
    <br/>
    <p><a href="https://markupuk.org">Markup UK 2019</a></p>

</body>

</html>

return $html
