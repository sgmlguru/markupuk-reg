xquery version "3.1";

module namespace pay = "http://markupuk.org/registration/pay";

import module namespace muk="http://www.sgmlguru.org/ns/muk" at "/db/apps/MUK-reg/modules/muk-functions.xqm";
import module namespace jsjson = "http://johnsnelson/json" at "/db/apps/dashboard/plugins/userManager/jsjson.xqm";

declare namespace err = "http://www.w3.org/2005/xqt-errors";
declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace http = "http://expath.org/ns/http-client";

(: Indicates if the sandbox endpoint is used :)
declare variable $pay:use-sandbox := true();

(: Production Postback URL :)
declare variable $pay:verify-uri := "https://ipnpb.paypal.com/cgi-bin/webscr";

(: Sandbox Postback URL :)
declare variable $pay:sandbox_verify_uri := "https://ipnpb.sandbox.paypal.com/cgi-bin/webscr";

(: Response from PayPal indicating validation was successful :)
declare variable $pay:valid := "VERIFIED";

(: Response from PayPal indicating validation failed :)
declare variable $pay:invalid := "INVALID";



(: Paypal oauth API :)
declare variable $pay:oauth_api := 'https://api.sandbox.paypal.com/v1/oauth2/token/';

(: Paypal authorisation API :)
declare variable $pay:authorization_api := 'https://api.sandbox.paypal.com/v2/payments/authorizations/';

(:declare variable $pay:basicAuth := util:base64-encode(concat($pay:client-id,':',$pay:secret));:)


declare
    %rest:POST("{$body}")
    %rest:path("/paypal-transaction-complete")
function pay:listener($body) {
    
    let $json := fn:parse-json(util:base64-decode($body))

    return
    xmldb:store($muk:transactions-collection-uri,concat('uid-',$json?custom,'.xml'),
    <transaction tstamp='{current-dateTime()}' 
        orderID='{$json?orderID}'
        userID='{$json?custom}'/>),
    pay:all-good()

    
};

declare function pay:all-good(){
    (: Reply with an empty 200 response to indicate to paypal the IPN was received correctly. :)
        (
            <rest:response>
                 <http:response status="200" reason="OK"/>
            </rest:response>,
            ""
        )
};