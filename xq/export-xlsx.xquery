xquery version "3.1";

declare namespace r = "http://schemas.openxmlformats.org/officeDocument/2006/relationships";

let $xsl-sheetData := '/db/apps/MUK-reg/xsl/sheetData.xsl'

let $raw-data := '/db/MUK-data/raw-data.xml'

let $workbook := <workbook>
	<sheets>
		<sheet name="MUK Data Folder" sheetId="1" r:id="rId1"/>
	</sheets>
</workbook>

return $xsl-sheetData