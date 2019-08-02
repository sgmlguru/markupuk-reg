<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:variable name="all" select="/root"/>
    
    <xsl:template match="/root">
        <html>
            <head>
                <!-- Favicon -->
                <link rel="icon" type="image/png" href="/db/apps/MUK-reg/resources/img/MUK-Logo.png"/>
                
                <title>Report</title>
            </head>
            <body>
                <div class="tmp">
                    <h2>Temp Folder - Not Yet Registered</h2>
                    <xsl:apply-templates select="tmp"/>
                </div>
                <div class="data">
                    <h2>Data Folder - Registered</h2>
                    <xsl:apply-templates select="data"/>
                </div>
            </body>
        </html>
    </xsl:template>
    
    
    <xsl:template match="tmp">
        <div class="person">
            <table>
                <tbody>
                    <xsl:apply-templates select="item"/>
                </tbody>
            </table>
        </div>
    </xsl:template>
    
    
    <xsl:template match="data">
        <div class="person">
            <table>
                <thead>
                    <tr>
                        <td>UID -Name</td>
                        <td>Reg type</td>
                        <td>Amount</td>
                        <td>VAT</td>
                        <td>Preconference</td>
                        <td>Dietary</td>
                        <td>Email</td>
                        <td>Date registered</td>
                    </tr>
                </thead>
                <tbody>
                    <xsl:apply-templates select="item"/>
                </tbody>
            </table>
        </div>
    </xsl:template>
    
    
    <xsl:template match="item">
        <xsl:variable name="val" select="value"/>
        <tr>
            <!-- Check if delegate actually registered -->
            <xsl:variable name="good">
                <xsl:choose>
                    <xsl:when test="parent::data">
                        <xsl:if test="../../tmp/item/value[.=$val]">OK</xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="../../data/item/value[.=$val]">OK</xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="$good='OK'">
                <xsl:attribute name="style" select="'background-color: #92f98e;'"/>
            </xsl:if>
            <xsl:apply-templates select="string | value"/>
        </tr>
    </xsl:template>
    
    
    <xsl:template match="string">
        <xsl:apply-templates select="name"/>
        <xsl:apply-templates select="type"/>
        <xsl:apply-templates select="ancestor::item/@amount" mode="extra"/>
        <xsl:apply-templates select="ancestor::item/@vat" mode="extra"/>
        <xsl:apply-templates select="ancestor::item/@preconf" mode="extra"/>
        <xsl:apply-templates select="ancestor::item/@dietary" mode="extra"/>
        <xsl:apply-templates select="email"/>
        <xsl:apply-templates select="date"/>
    </xsl:template>
    
    
    <xsl:template match="name | email | type | date">
        <td>
            <xsl:if test="self::name">
                <xsl:value-of select="substring-before(preceding-sibling::text(),',')"/>
                <xsl:text> </xsl:text>
            </xsl:if>
            
            <xsl:apply-templates/>
        </td>
    </xsl:template>
    
    
    <xsl:template match="item/@amount | item/@vat | item/@preconf | item/@dietary" mode="extra">
        <td>
            <xsl:value-of select="."/>
        </td>
    </xsl:template>
    
    
    <xsl:template match="value"></xsl:template>
    
</xsl:stylesheet>