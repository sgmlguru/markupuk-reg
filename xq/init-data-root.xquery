xquery version "3.1";

import module namespace muk="http://www.sgmlguru.org/ns/muk" at "/db/apps/MUK-reg/modules/muk-functions.xqm";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace exist="http://exist.sourceforge.net/NS/exist";

let $login := xmldb:login('/db','USER','PASSWORD')
let $data-root := request:get-data()

return muk:createCollections($data-root//text())


