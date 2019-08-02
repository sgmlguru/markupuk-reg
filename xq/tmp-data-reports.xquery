xquery version "3.1";

import module namespace muk="http://www.sgmlguru.org/ns/muk" at "/db/apps/MUK-reg/modules/muk-functions.xqm";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare option exist:serialize "method=xhtml media-type=text/html omit-xml-declaration=yes indent=yes";

let $login := xmldb:login('/db','USER','PASSWORD')

let $muk-data := $muk:config//data-uri

let $tmp := collection(concat($muk-data,'/',$muk:config//collections/sub/tmp/text()))
let $data := collection(concat($muk-data,'/',$muk:config//collections/sub/data/text()))

let $transactions := collection(concat($muk-data,'/',$muk:config//collections/sub/transactions/text()))
let $pdf := collection(concat($muk-data,'/',$muk:config//collections/sub/pdf/text()))

let $tmp-users := ($tmp//person)
let $data-users := ($data//person)

let $xml := <root base-uri="{$muk-data}">
    <tmp>
        {
    for $user in ($tmp-users)
        order by number($user/@uid)
        return 
            <item uri="{base-uri($user)}"> 
                <string>UID {string($user/@uid)},&#x20;{$user/name},&#x20;{$user/type},&#x20;{$user/email},&#x20;{$user/date},&#x20;{base-uri($user)}</string>
                <value>{string($user/@uid)}</value>
            </item>
        
    }
    </tmp>
    <data>
        {
    for $user in ($data-users)
        let $amount := muk:getPrice(<data>{$user}</data>)
        let $vat := muk:payVat(<data>{$user}</data>)
        order by number($user/@uid)
        return 
            <item uri="{base-uri($user)}" amount="{$amount}" vat="{$vat}" vat-number="{$user//vat-number}" preconf="{$user//preconf}" dietary="{$user//dietary}">
                <string>UID {string($user/@uid)},&#x20;{$user/name},&#x20;{$user/type},&#x20;{$user/discount},&#x20;{$user/email},&#x20;{$user/date},&#x20;{base-uri($user)}</string>
                <value>{string($user/@uid)}</value>
            </item>
        
    }
    </data>
    
</root>

let $xml-stored := xmldb:store('/db/MUK-data','raw-data.xml',$xml)

return
    transform:transform($xml,doc('/db/apps/MUK-reg/xsl/tmp-data.xsl'),())