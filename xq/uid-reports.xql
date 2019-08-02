xquery version "3.1";

import module namespace muk="http://www.sgmlguru.org/ns/muk" at "/db/apps/MUK-reg/modules/muk-functions.xqm";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare option exist:serialize "method=xml media-type=text/xml indent=no";

let $login := xmldb:login('/db','USER','PASSWORD')

(: let $filter := request:get-parameter('filter', '') :)

let $muk-data := $muk:config//data-uri

let $tmp := collection(concat($muk-data,'/',$muk:config//collections/sub/tmp/text()))
let $data := collection(concat($muk-data,'/',$muk:config//collections/sub/data/text()))
let $transactions := collection(concat($muk-data,'/',$muk:config//collections/sub/transactions/text()))
let $pdf := collection(concat($muk-data,'/',$muk:config//collections/sub/pdf/text()))

let $users := ($tmp//person,$data//person)

return <data base-uri="{$muk-data}">
    {
    for $user in ($users)
    order by number($user/@uid)
    return 
        <item uri="{base-uri($user)}"> 
            <string>UID {string($user/@uid)},&#x20;{$user/name},&#x20;{$user/type},&#x20;{$user/email},&#x20;{base-uri($user)}</string>
            <value>{string($user/@uid)}</value>
        </item>
        
    }
</data>