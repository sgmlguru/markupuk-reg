<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:output indent="yes" method="xhtml"/>
    
    <xsl:param name="amount"/>
    
    <xsl:template match="/">
        <div class="summary">
            <h3>You've provided the following information:</h3>
            
            <xsl:apply-templates select="//person"/>
        </div>
    </xsl:template>
    
    
    <xsl:template match="person">
        <blockquote>
            <xsl:apply-templates/>
        </blockquote>
    </xsl:template>
    
    
    <xsl:template match="name">
        <p>
            <xsl:text>Name: </xsl:text>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
    <xsl:template match="affiliation">
        <p>
            <xsl:text>Affiliation: </xsl:text>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
    <xsl:template match="type">
        <p>
            <xsl:text>Registration type: </xsl:text>
            <xsl:apply-templates/>
            
            <xsl:text> £</xsl:text>
            <xsl:value-of select="$amount"/>
            <xsl:choose>
                <xsl:when test="//country/text() = 'United Kingdom'">
                    <xsl:text> (incl VAT)</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> (excl VAT)</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
        </p>
    </xsl:template>
    
    
    <xsl:template match="vat-number">
        <xsl:if test=".!=''">
            <p>
                <xsl:text>VAT number: </xsl:text>
                <xsl:value-of select="."/>
            </p>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template match="preconf">
        <p>
            <xsl:text>Preconference: </xsl:text>
            <xsl:if test=".='true'">
                <xsl:text>Will attend.</xsl:text>
            </xsl:if>
        </p>
        
    </xsl:template>
    
    
    <xsl:template match="discount">
        <xsl:if test="normalize-space(discount)!=''">
            <p>
                <xsl:text>Discount code: </xsl:text>
                <xsl:apply-templates/>
            </p>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template match="email">
        <p>
            <xsl:text>Email: </xsl:text>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
    <xsl:template match="mailing-list">
        <p>
            <xsl:text>Mailing List Opt-in: </xsl:text>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
    <xsl:template match="dietary">
        <p>
            <xsl:text>Dietary requirements: </xsl:text>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
    <xsl:template match="invoice | address | custvat | reverse-charge | eu | att"/>
    
</xsl:stylesheet>