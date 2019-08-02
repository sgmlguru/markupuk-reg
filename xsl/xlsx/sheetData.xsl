<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Convert to sheet data -->
    
    <xsl:output method="xml" indent="yes"/>
    
    
    <!-- Produces xl/worksheets/sheet1.xml -->
    <xsl:template match="/root">
        <worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
            xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
            xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006">
            <sheetData>
                <xsl:apply-templates select="data"/>
            </sheetData>
        </worksheet>
    </xsl:template>
    
    
    <xsl:template match="data">
        <row>
            <c t="inlineStr">
                <is>
                    <t>UID</t>
                </is>
            </c>
            <c t="inlineStr">
                <is>
                    <t>Name</t>
                </is>
            </c>
            <c t="inlineStr">
                <is>
                    <t>Registration type</t>
                </is>
            </c>
            <c t="inlineStr">
                <is>
                    <t>Discount</t>
                </is>
            </c>
            <c t="inlineStr">
                <is>
                    <t>Amount (GBP)</t>
                </is>
            </c>
            <c t="inlineStr">
                <is>
                    <t>VAT</t>
                </is>
            </c>
            <c t="inlineStr">
                <is>
                    <t>Email</t>
                </is>
            </c>
            <c t="inlineStr">
                <is>
                    <t>Preconf</t>
                </is>
            </c>
            <c t="inlineStr">
                <is>
                    <t>Dietary</t>
                </is>
            </c>
        </row>
        <xsl:apply-templates select="item"/>
    </xsl:template>
    
    
    <xsl:template match="item">
        <row>
            <xsl:apply-templates select="string/text()[1]"/>
            <xsl:apply-templates select="string/name"/>
            <xsl:apply-templates select="string/type"/>
            <xsl:apply-templates select="string/discount"/>
            <xsl:apply-templates select="@amount"/>
            <xsl:apply-templates select="@vat"/>
            <xsl:apply-templates select="string/email"/>
            <xsl:apply-templates select="@preconf"/>
            <xsl:apply-templates select="@dietary"/>
        </row>
    </xsl:template>
    
    
    <xsl:template match="text()[not(preceding-sibling::text()) and parent::string]">
        <c t="inlineStr">
            <is>
                <t>
                    <xsl:value-of select="substring-after(substring-before(.,','),'UID ')"/>
                </t>
            </is>
        </c>
    </xsl:template>
    
    
    <xsl:template match="name | type | discount | @amount | email | @vat | @preconf | @dietary">
        <c t="inlineStr">
            <is>
                <t>
                    <xsl:value-of select="."/>
                </t>
            </is>
        </c>
    </xsl:template>
    
    
</xsl:stylesheet>