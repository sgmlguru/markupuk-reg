xquery version "3.1";

import module namespace muk="http://www.sgmlguru.org/ns/muk" at "/db/apps/MUK-reg/modules/muk-functions.xqm";
import module namespace pay="http://markupuk.org/registration/pay" at "/db/apps/MUK-reg/modules/muk-paypal.xqm";
import module namespace jsjson = "http://johnsnelson/json" at "/db/apps/dashboard/plugins/userManager/jsjson.xqm";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare option exist:serialize "method=xhtml media-type=text/html";

let $login := xmldb:login('/db','USER','PASSWORD')

let $person := request:get-data()
let $type := $person//type/text()
let $registered := muk:register($person)
let $summary := doc($registered)
let $amount := muk:getPrice($person)
let $uid := doc($registered)//person/@uid

let $clientid := if ($muk:config//current='sandbox')
                  then (string($muk:config//client-id/sandbox))
                  else (string($muk:config//client-id/live))

let $url := if ($type = 'speaker') 
            then (concat($muk:config//domain/text(),'/exist/rest/db/apps/MUK-reg/xq/thanks.xquery?tmp-file=',$registered))
            else (concat('https://www.paypal.com/sdk/js?client-id=',$clientid,'&amp;currency=GBP&amp;intent=capture&amp;commit=true'))

let $html := <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <script
        src="{$url}">
      </script>
      
      
<script>
    
  paypal.Buttons({{
    createOrder: function(data, actions) {{
      return actions.order.create({{
        purchase_units: [{{
          amount: {{
            value: '{$amount}'
          }}
        }}]
      }});
    }},
    onApprove: function(data, actions) {{
      return actions.order.capture().then(function(details) {{
        // alert('Transaction completed by ' + details.payer.name.given_name);
        
        actions.redirect('{$muk:config//domain/text()}/exist/rest/db/apps/MUK-reg/xq/thanks.xquery?tmp-file={$registered}');
        // Call your server to save the transaction
        return fetch('{$muk:config//domain/text()}/exist/restxq/paypal-transaction-complete', {{
          method: 'post',
          body: JSON.stringify({{
            orderID: data.orderID,
            custom: {string($uid)}
          }})
        }});
      }});
    }},
    

  onCancel: function(data, actions) {{
    actions.redirect('{$muk:config//domain/text()}/exist/rest/db/apps/MUK-reg/xq/cancel.xquery');
    }}
  }}).render('#paypal-button-container');
  
</script>


    </head>
    
    <body>
    <div class="summary">{muk:generateSummary($summary)}</div>
    
  <div id="paypal-button-container"></div>

</body>

</html>

return $html
