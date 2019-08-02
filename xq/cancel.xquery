xquery version "3.1";

import module namespace muk="http://www.sgmlguru.org/ns/muk" at "/db/apps/MUK-reg/modules/muk-functions.xqm";
import module namespace pay="http://markupuk.org/registration/pay" at "/db/apps/MUK-reg/modules/muk-paypal.xqm";
import module namespace jsjson = "http://johnsnelson/json" at "/db/apps/dashboard/plugins/userManager/jsjson.xqm";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare option exist:serialize "method=xhtml media-type=text/html";

let $login := xmldb:login('/db','USER','PASSWORD')

let $html := <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      
    </head>
    
    <body>
    
    <h1>Did you hit the wrong button?</h1>
    <p><a href="{$muk:config//domain/text()}/exist/rest/db/apps/MUK-reg/registration-form.xhtml">Three days of markup bliss in London in June</a> is only a few clicks away.</p>
    <br/>
    <p>Geert, Tom, Ari, Andrew, and Rebecca</p>

</body>

</html>

return $html
