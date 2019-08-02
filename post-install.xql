xquery version "3.1";

import module namespace muk="http://www.sgmlguru.org/ns/muk" at "/db/apps/MUK-reg/modules/muk-functions.xqm";
import module namespace sm="http://exist-db.org/xquery/securitymanager";


let $group := if (sm:group-exists('delegates')) then () else (sm:create-group('delegates','Group for delegate registration'))
let $user := if (sm:user-exists('delegate')) then () else (sm:create-account('delegate','MUKDelegate2019',('guest','delegates'),'delegate','User for delegate registration'))

let $path := 'xmldb:exist:///db/apps/MUK-reg/'
let $files := ('registration-form.xhtml','controller.xql','xsl/invoice.xsl','xsl/summary.xsl','modules/muk-functions.xqm','modules/muk-paypal.xqm','index.html','xq/cancel.xquery','xq/init-data-root.xquery','xq/register.xquery','xq/thanks.xquery','xq/update-data-uri.xquery','xq/update-domain.xquery','xq/update-pricing.xquery')

for $file in $files
let $uri := xs:anyURI(concat($path,$file)) 
return (
    sm:chown($uri, "admin"),
    sm:chgrp($uri, "delegates"),
    sm:chmod($uri, "rwxrwxr-x")
)

