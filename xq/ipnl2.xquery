xquery version "3.1";

import module namespace muk = "http://www.sgmlguru.org/ns/muk" at "/db/apps/MUK-reg/modules/muk-functions.xqm";
import module namespace ipnl2 = "http://markupuk.org/registration/ipn-listener2" at '/db/apps/MUK-reg/modules/ipn2-listener.xqm';

declare namespace request="http://exist-db.org/xquery/request";
declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare namespace httpclient="http://exist-db.org/xquery/httpclient";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";

let $login := xmldb:login('/db','USER','PASSWORD')

let $params := <data>{for $p in request:get-parameter-names()
                    return <param name="{$p}" value="{xmldb:decode(request:get-parameter($p,'unknown'))}"></param>
                    }</data>

let $store := xmldb:store($muk:transactions-collection-uri,concat('uid-',$params//param[@name='custom']/@value,'.xml'),$params)

let $string := for $pair in $params//param
                    return concat($pair/@name,'=',$pair/@value)

let $decoded-string := <data>{string-join($string,'&amp;')}</data>


let $all := ipnl2:listener($decoded-string//text())



return $params