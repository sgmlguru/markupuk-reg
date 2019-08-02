xquery version "3.1";

import module namespace muk="http://www.sgmlguru.org/ns/muk" at "/db/apps/MUK-reg/modules/muk-functions.xqm";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace exist="http://exist.sourceforge.net/NS/exist";

let $login := xmldb:login('/db','USER','PASSWORD')
let $config := request:get-data()

let $config := muk:updateDataUri($config//current/text(),$config//data-uri/text())

return $config


