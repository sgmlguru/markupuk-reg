<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fun="fun" exclude-result-prefixes="xs fun" version="2.0">

    <!-- From calling XQuery -->
    <xsl:param name="amount" select="336"/>

    <!-- VAT -->
    <xsl:param name="vat" select="true()" as="xs:boolean"/>

    <!-- Discount string -->
    <xsl:param name="discount" select="//person[1]//discount/text()"/>

    <!-- Registration type -->
    <xsl:param name="reg-type" select="//person[1]//type/text()"/>


    <!--<xsl:param name="data">
        <xsl:copy-of select="/*"/>
    </xsl:param>-->

    <!-- Font colours as in logo -->
    <xsl:param name="color-muk-logo-blue" select="'#3B4063'"/>
    <xsl:param name="color-muk-logo-lblue" select="'#7D8CA3'"/>
    <xsl:param name="color-muk-logo-red" select="'#CA4D5E'"/>

    <!-- ======================== -->
    <!-- Page geometry parameters -->
    <!-- ======================== -->

    <xsl:param name="double.sided" select="'0'"/>
    <xsl:param name="paper.type" select="'A4'"/>

    <xsl:param name="page.width">
        <xsl:choose>
            <xsl:when test="$paper.type = 'A4'">210mm</xsl:when>
            <xsl:when test="$paper.type = 'A5'">148mm</xsl:when>
            <xsl:otherwise>210mm</xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:param name="page.height">
        <xsl:choose>
            <xsl:when test="$paper.type = 'A4'">297mm</xsl:when>
            <xsl:when test="$paper.type = 'A5'">210mm</xsl:when>
            <xsl:otherwise>297mm</xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:param name="page.margin.bottom">
        <xsl:if test="$paper.type = 'A4'">7mm</xsl:if>
        <xsl:if test="$paper.type = 'A5'">7.5mm</xsl:if>
    </xsl:param>

    <xsl:param name="page.margin.top">
        <xsl:if test="$paper.type = 'A4'">10mm</xsl:if>
        <xsl:if test="$paper.type = 'A5'">10mm</xsl:if>
    </xsl:param>

    <xsl:param name="page.margin.inner">
        <xsl:choose>
            <xsl:when test="not($double.sided = '0') and $paper.type = 'A4'">10mm</xsl:when>
            <xsl:when test="not($double.sided = '0') and $paper.type = 'A5'">10mm</xsl:when>
            <xsl:otherwise>10mm</xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:param name="page.margin.outer">
        <xsl:choose>
            <xsl:when test="not($double.sided = '0') and $paper.type = 'A4'">10mm</xsl:when>
            <xsl:when test="not($double.sided = '0') and $paper.type = 'A5'">10mm</xsl:when>
            <xsl:otherwise>10mm</xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:param name="body.margin.inner">
        <xsl:choose>
            <xsl:when test="not($double.sided = '0') and $paper.type = 'A4'">10mm</xsl:when>
            <xsl:when test="not($double.sided = '0') and $paper.type = 'A5'">10mm</xsl:when>
            <xsl:otherwise>10mm</xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:param name="body.margin.outer">
        <xsl:choose>
            <xsl:when test="not($double.sided = '0') and $paper.type = 'A4'">10mm</xsl:when>
            <xsl:when test="not($double.sided = '0') and $paper.type = 'A5'">10mm</xsl:when>
            <xsl:otherwise>10mm</xsl:otherwise>
        </xsl:choose>
    </xsl:param>


    <xsl:param name="body.margin.bottom">
        <xsl:if test="$paper.type = 'A4'">12mm</xsl:if>
        <xsl:if test="$paper.type = 'A5'">9.5mm</xsl:if>
    </xsl:param>

    <xsl:param name="body.margin.top">
        <xsl:if test="$paper.type = 'A4'">20mm</xsl:if>
        <xsl:if test="$paper.type = 'A5'">20mm</xsl:if>
    </xsl:param>


    <xsl:param name="region.before.extent">
        <xsl:if test="$paper.type = 'A4'">15mm</xsl:if>
        <xsl:if test="$paper.type = 'A5'">15mm</xsl:if>
    </xsl:param>

    <xsl:param name="region.after.extent">
        <xsl:if test="$paper.type = 'A4'">5mm</xsl:if>
        <xsl:if test="$paper.type = 'A5'">2.5mm</xsl:if>
    </xsl:param>



    <!-- ======================== -->
    <!-- Page geometry -->
    <!-- ======================== -->

    <!-- Even (left-hand) pages -->
    <xsl:attribute-set name="left-page">
        <xsl:attribute name="page-height">
            <xsl:value-of select="$page.height"/>
        </xsl:attribute>
        <xsl:attribute name="page-width">
            <xsl:value-of select="$page.width"/>
        </xsl:attribute>
        <xsl:attribute name="margin-top">
            <xsl:value-of select="$page.margin.top"/>
        </xsl:attribute>
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$page.margin.bottom"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$page.margin.outer"/>
        </xsl:attribute>
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$page.margin.inner"/>
        </xsl:attribute>
    </xsl:attribute-set>


    <!-- Odd (right-hand) pages -->
    <xsl:attribute-set name="right-page">
        <xsl:attribute name="page-height">
            <xsl:value-of select="$page.height"/>
        </xsl:attribute>
        <xsl:attribute name="page-width">
            <xsl:value-of select="$page.width"/>
        </xsl:attribute>
        <xsl:attribute name="margin-top">
            <xsl:value-of select="$page.margin.top"/>
        </xsl:attribute>
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$page.margin.bottom"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$page.margin.inner"/>
        </xsl:attribute>
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$page.margin.outer"/>
        </xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="region-body-left">
        <xsl:attribute name="margin-top">
            <xsl:value-of select="$body.margin.top"/>
        </xsl:attribute>
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$body.margin.bottom"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$body.margin.outer"/>
        </xsl:attribute>
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$body.margin.inner"/>
        </xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="region-body-right">
        <xsl:attribute name="margin-top">
            <xsl:value-of select="$body.margin.top"/>
        </xsl:attribute>
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$body.margin.bottom"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$body.margin.inner"/>
        </xsl:attribute>
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$body.margin.outer"/>
        </xsl:attribute>
    </xsl:attribute-set>


    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <!-- Body pages -->
                <fo:simple-page-master master-name="left-page" xsl:use-attribute-sets="left-page">
                    <fo:region-body xsl:use-attribute-sets="region-body-left"> </fo:region-body>
                    <fo:region-before region-name="xsl-region-before-left" extent="{$region.before.extent}"/>
                    <fo:region-after extent="{$region.after.extent}" region-name="xsl-region-after-left"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="right-page" xsl:use-attribute-sets="right-page">
                    <fo:region-body xsl:use-attribute-sets="region-body-right"> </fo:region-body>
                    <fo:region-before region-name="xsl-region-before-right" extent="{$region.before.extent}"/>
                    <fo:region-after extent="{$region.after.extent}" region-name="xsl-region-after-right"/>
                </fo:simple-page-master>

                <fo:page-sequence-master master-name="contents">
                    <fo:repeatable-page-master-alternatives>
                        <fo:conditional-page-master-reference master-reference="right-page" odd-or-even="odd"/>
                        <!-- Removed to get a blank last page if necessary -->
                        <!-- blank-or-not-blank="not-blank"/-->
                        <fo:conditional-page-master-reference master-reference="left-page" odd-or-even="even"/>
                        <!-- blank-or-not-blank="not-blank"/-->
                    </fo:repeatable-page-master-alternatives>
                </fo:page-sequence-master>

            </fo:layout-master-set>

            <fo:page-sequence master-reference="contents">
                <fo:flow flow-name="xsl-region-body">
                    <xsl:call-template name="contents"/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>


    <xsl:function name="fun:header-cell">
        <xsl:param name="str" as="xs:string"/>
        <xsl:param name="align" as="xs:string"/>
        <fo:table-cell padding-before="20pt">
            <fo:block color="{$color-muk-logo-red}" font-weight="bold" font-size="14pt" text-align="{$align}" font-style="italic" margin-bottom="2mm">
                <xsl:value-of select="$str"/>
            </fo:block>
        </fo:table-cell>
    </xsl:function>

    <xsl:function name="fun:empty-cell">
        <xsl:param name="context" as="node()"/>
        <fo:table-cell>
            <fo:block/>
        </fo:table-cell>
    </xsl:function>

    <xsl:template name="contents">
        
        <!-- Number of delegates -->
        <xsl:variable name="number-of-persons" select="count(data/person)"/>
        
        <fo:table width="100%">
            <fo:table-column column-width="80mm"/>
            <fo:table-column column-width="10mm"/>
            <fo:table-column column-width="88mm"/>
            <fo:table-body>

                <!-- logo + -->
                <fo:table-row>
                    <!-- MUK logo, left-justified -->
                    <fo:table-cell>
                        <fo:block margin-bottom="18mm" margin-left="-15mm" margin-top="-10mm" text-align="left">
                            <!--<fo:external-graphic content-width="120mm" src="https://exist.sgmlguru.org/exist/rest/db/apps/MUK-reg/xsl/MarkupUK.svg"/>-->
                            <!--<fo:external-graphic content-width="120mm" src="MarkupUK.svg"/>-->
                            <fo:external-graphic content-width="120mm" src="{$logo-data-uri}"/>
                            <!--<fo:instream-foreign-object content-width="120mm">
                                <xsl:copy-of select="$logo"/>
                            </fo:instream-foreign-object>-->
                        </fo:block>
                    </fo:table-cell>

                    <xsl:copy-of select="fun:empty-cell(.)"/>

                    <!-- Date, right-justified -->
                    <fo:table-cell>
                        <fo:block text-align="right" font-size="16pt" color="{$color-muk-logo-blue}">
                            <xsl:text>June 7 - 9, 2019</xsl:text>
                        </fo:block>
                        <fo:block text-align="right" font-size="12pt" color="{$color-muk-logo-lblue}">
                            <xsl:text>King's College London</xsl:text>
                        </fo:block>
                        <fo:block text-align="right" font-style="italic" font-size="12pt" color="{$color-muk-logo-blue}">
                            <xsl:text>markupuk.org</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <!-- Invoice details -->
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block font-size="32pt">Invoice</fo:block>
                    </fo:table-cell>

                    <xsl:copy-of select="fun:empty-cell(.)"/>

                    <!-- Invoice number and date -->
                    <fo:table-cell>
                        <fo:block font-size="12pt" margin-left="30mm">
                            <xsl:text>Number: </xsl:text>
                            <!-- Number -->
                            <xsl:apply-templates select="data/person[1]/invoice"/>
                        </fo:block>
                        <fo:block font-size="12pt" margin-left="30mm">
                            <xsl:text>Date: </xsl:text>
                            <!-- Date -->
                            <xsl:apply-templates select="data/person[1]/date"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <!-- Name, address, etc -->
                <fo:table-row>
                    <fo:table-cell number-columns-spanned="3">
                        <fo:block padding-before="22pt">
                            
                            <!-- Attention, if present -->
                            <xsl:choose>
                                <xsl:when test="data/att">
                                    <!-- name -->
                                    <fo:block font-size="11pt">
                                        <xsl:apply-templates select="data/att/name"/>
                                    </fo:block>
                                    <xsl:apply-templates select="data/att/affiliation"/>
                                    
                                    <fo:block font-size="10pt" margin-top="4pt">
                                        <xsl:apply-templates select="data/att/address"/>
                                    </fo:block>
                                    
                                    <fo:block font-size="10pt">
                                        <xsl:apply-templates select="data/att/email"/>
                                        
                                        <xsl:if test="data/att/vat-number!=''">
                                            <xsl:apply-templates select="data/att/vat-number"/>
                                        </xsl:if>
                                    </fo:block>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- name -->
                                    <fo:block font-size="11pt">
                                        <xsl:apply-templates select="data/person[1]/name"/>
                                    </fo:block>
                                    <xsl:apply-templates select="data/person[1]/affiliation"/>
                                    
                                    <fo:block font-size="10pt" margin-top="4pt">
                                        <xsl:apply-templates select="data/person[1]/address"/>
                                    </fo:block>
                                    
                                    <fo:block font-size="10pt">
                                        <xsl:apply-templates select="data/person[1]/email"/>
                                        
                                        <xsl:if test="data/person[1]/vat-number!=''">
                                            <xsl:apply-templates select="data/person[1]/vat-number"/>
                                        </xsl:if>
                                    </fo:block>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <!-- Description -->
                <fo:table-row>
                    <xsl:copy-of select="fun:header-cell('Description', 'left')"/>
                    <xsl:copy-of select="fun:empty-cell(.)"/>
                    <xsl:copy-of select="fun:header-cell('Amount (GBP)', 'right')"/>
                </fo:table-row>

                <!-- Type, amount -->
                <fo:table-row>
                    <fo:table-cell>
                        <fo:block padding-before="6pt" font-size="13pt">
                            <xsl:text>Conference registration</xsl:text>
                        </fo:block>
                        <fo:block padding-before="2pt" font-size="10pt">
                            <xsl:value-of select="$number-of-persons"/>
                            <xsl:text> full pass(es) - </xsl:text>
                            <xsl:value-of select="$reg-type"/>
                            
                            <xsl:if test="//person[2] or (//att and //person)">
                                <xsl:text>: </xsl:text>
                                <xsl:for-each select="data/person/name">
                                    <fo:inline font-size="10pt">
                                        <xsl:value-of select="."/>
                                    </fo:inline>
                                    <xsl:if test="not(position()=last())">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:if>
                        </fo:block>
                        
                        <xsl:if test="normalize-space($discount)">
                            <fo:block padding-before="2pt" font-size="10pt">
                                <xsl:text>discount code: </xsl:text>
                                <xsl:value-of select="$discount"/>
                            </fo:block>
                        </xsl:if>
                    </fo:table-cell>

                    <xsl:copy-of select="fun:empty-cell(.)"/>

                    <fo:table-cell>
                        <fo:block padding-before="6pt" text-align="right">
                            <!-- Actual amount -->
                            <xsl:text>Per unit excl. VAT </xsl:text>
                            <xsl:text>£</xsl:text>
                            <xsl:value-of
                                select="if ($vat = true())
                                        then (format-number($amount div 1.2,'0.00')) 
                                        else (format-number($amount,'0.00'))"/>
                        </fo:block>

                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell number-columns-spanned="3">
                        <fo:block>
                            <fo:table>
                                <fo:table-column column-width="120mm"/>
                                <fo:table-column column-width="38mm"/>
                                <fo:table-column column-width="20mm"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <xsl:copy-of select="fun:empty-cell(.)"/>
                                        <fo:table-cell>
                                            <fo:block padding-before="6pt" font-size="10pt">
                                                    <xsl:text>Total excl. VAT </xsl:text>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block padding-before="6pt" text-align="right" font-size="13pt">
                                                <xsl:text>£</xsl:text>
                                                <xsl:value-of
                                                    select="if ($vat=true()) then (format-number($amount*$number-of-persons div 1.2,'0.00')) else (format-number($amount*$number-of-persons,'0.00'))"/>
                                            </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                    <xsl:choose>
                                        <xsl:when test="$vat">
                                            <fo:table-row>
                                                <xsl:copy-of select="fun:empty-cell(.)"/>
                                                <fo:table-cell>
                                                    <fo:block padding-before="6pt" font-size="10pt">
                                                        <xsl:text>VAT payable at 20% </xsl:text>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block padding-before="6pt" text-align="right" font-size="13pt">
                                                        <xsl:text>£</xsl:text>
                                                        <xsl:value-of
                                                            select="format-number($amount*$number-of-persons - ($amount*$number-of-persons div 1.2),'0.00')"/>
                                                    </fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                            <fo:table-row>
                                                <xsl:copy-of select="fun:empty-cell(.)"/>
                                                <fo:table-cell>
                                                    <fo:block padding-before="6pt" font-size="10pt">
                                                        <xsl:text>Total incl. VAT </xsl:text>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block padding-before="6pt" text-align="right" font-size="13pt">
                                                        <xsl:text>£</xsl:text>
                                                        <xsl:value-of select="format-number($amount*$number-of-persons,'0.00')"/>
                                                    </fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <fo:table-row>
                                                <xsl:copy-of select="fun:empty-cell(.)"/>
                                                 <fo:table-cell number-columns-spanned="2">
                                                     <fo:block padding-before="6pt" font-size="7pt" text-align="right">
                                                         <xsl:text>Reverse charge, article 44 and 196</xsl:text>
                                                     </fo:block>
                                                     <fo:block font-size="7pt" text-align="right">
                                                         <xsl:text>in Directive 2006/112/EEC (general rule).</xsl:text>
                                                     </fo:block>
                                                 </fo:table-cell>
                                            </fo:table-row>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <!-- Payment details heading -->
                <fo:table-row>
                    <xsl:copy-of select="fun:header-cell('Payment Details', 'left')"/>
                    <xsl:copy-of select="fun:empty-cell(.)"/>
                    <xsl:copy-of select="fun:empty-cell(.)"/>
                </fo:table-row>

                <!-- Actual payment details -->
                <fo:table-row>
                    <fo:table-cell number-columns-spanned="3">
                        <fo:block font-size="12pt" padding-before="4pt">
                            <xsl:text>MARKUP UK CONFERENCES LTD</xsl:text>
                        </fo:block>
                        <fo:block font-size="11pt" padding-before="4pt">
                            <xsl:text>Account number: 71753339</xsl:text>
                        </fo:block>
                        <fo:block font-size="11pt" padding-before="2pt">
                            <xsl:text>Sort code: 40-21-15</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <!-- Company details heading -->
                <fo:table-row>
                    <xsl:copy-of select="fun:header-cell('Company Details', 'left')"/>
                    <xsl:copy-of select="fun:empty-cell(.)"/>
                    <xsl:copy-of select="fun:empty-cell(.)"/>
                </fo:table-row>

                <!-- Actual Company details -->
                <fo:table-row>
                    <fo:table-cell number-columns-spanned="3">
                        <fo:block padding-before="4pt" font-size="11pt">
                            <xsl:text>24, Trimworth Road</xsl:text>
                        </fo:block>
                        <fo:block font-size="11pt" padding-before="2pt">
                            <xsl:text>Folkestone, United Kingdom, CT19 4EL</xsl:text>
                        </fo:block>
                        <fo:block font-size="11pt" padding-before="4pt">
                            <xsl:text>Company Registration No: 11623628</xsl:text>
                        </fo:block>
                        <fo:block font-size="11pt" padding-before="2pt">
                            <xsl:text>VAT Registration No: GB 316 5241 25</xsl:text>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

                <!-- Queries -->
                <fo:table-row>
                    <fo:table-cell number-columns-spanned="3">
                        <fo:block padding-before="20pt" font-size="14pt">
                            <xsl:text>Please direct any queries by email to </xsl:text>
                            <fo:inline color="{$color-muk-logo-blue}" font-style="italic">
                                <xsl:text>info@markupuk.org</xsl:text>
                            </fo:inline>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>

            </fo:table-body>
        </fo:table>
    </xsl:template>


    <xsl:template match="data/person">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>


    <xsl:template match="name">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>


    <xsl:template match="address">
        <xsl:apply-templates select="line1 | line2"/>
        <fo:block>
            <xsl:value-of select="postcode"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="city"/>
        </fo:block>
        <fo:block>
            <xsl:apply-templates select="country"/>
        </fo:block>
    </xsl:template>


    <xsl:template match="line1 | line2">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>


    <xsl:template match="country">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>


    <xsl:template match="affiliation">
        <fo:block font-size="11pt">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>


    <xsl:template match="vat-number">
        <fo:block padding-before="8pt">Customer VAT: <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    

    <xsl:template match="dietary"/>
    
    
    <xsl:template match="reverse-charge"/>


    <xsl:template match="other"/>


    <xsl:template match="email">
        <fo:block margin-top="4pt">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>


    <xsl:template match="type"/>


    <xsl:template match="invoice">
        <xsl:apply-templates/>
    </xsl:template>



    <xsl:template match="date">
        <xsl:value-of select="substring-before(., 'T')"/>
    </xsl:template>

    <!--<xsl:variable name="logo" as="element()">
        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Layer_1" x="0px" y="0px" height="100%" viewBox="32 200 1640 400" style="enable-background:new 0 0 1606 400;" xml:space="preserve">
         <style type="text/css">
            <![CDATA[   .st0 {fill: #3B4063;}
                        .st1 {fill: #7D8CA3;}
                        .st2 {fill: #CA4D5E;}]]>
        </style>
        <g>
        	<g>
        		<path class="st0" d="M741,331.2l-16.7,87.4l-1.3,10.2h-0.5l-1.3-10.2l-16.6-87.4h-34.3v191.2h26V394.1h1.6l1,8.1l18,120.2h12    l17.9-120.2l1-8.1h1.6v128.2h26V331.2H741z"/>
        		<path class="st0" d="M862.2,497.7v-87.4c0-9.4-3.6-17.4-9.6-23.1s-13.8-9.1-22.4-9.1c-10.1,0-19,4.2-25.2,11.2    c-6.2,7-10.1,16.4-10.1,26.8v6h26.3v-6.8c0-2.3,0.3-4.7,0.5-6.8c0.8-4.2,2.6-7.5,7-7.5c3.4,0,5.5,1.8,6.5,4.4    c0.8,2.6,0.8,6.2,0.8,8.6v15.6c-1,2.9-6,5.2-12.5,8.6s-14.3,8.3-20.6,16.1c-6.2,7.8-10.9,19.2-10.9,35.1c0,14.8,3.6,23.7,8.1,28.6    c4.2,5.2,9.6,6.5,13,6.5c5.2,0,10.2-2.1,13.8-4.9c3.6-2.9,6-6.3,7.3-8.6h1.8c0,1.8,0,8.6,2.3,11.5h25.8    C863,516.1,862.2,510.4,862.2,497.7z M836,490.1c0,4.9-4.9,8.6-10.9,8.6c-3.1,0-4.9-2.3-6-5.5c-1-2.9-1.3-6-1.3-7.8    c0-13.5,5.5-26.3,18.2-31.7V490.1z"/>
        		<path class="st0" d="M911.9,385.6c-4.2,4.2-6,8.6-6.2,10.4v-15.9h-26.3v142.3h26.3v-98.9c0-4.4,0.8-8.8,5.7-13    c4.2-3.9,9.1-4.4,13.3-4.4c2.3,0,4.9,0.3,7.3,1.1V378C922.3,378,916.1,381.7,911.9,385.6z"/>
        		<path class="st0" d="M990,426.4l19-46.3h-23.7l-12.7,37.2L971,422h-1.3v-90.8h-26.3v191.2h26.3v-49.2l3.4-8.3l0.8-2.1h1.3l0.5,2.1    l13,57.5h25.2L990,426.4z"/>
        		<path class="st0" d="M1065.4,380.1v112.1c-0.8,1.3-1.6,2.6-2.4,3.4c-1.8,1.8-3.4,3.4-6.2,3.4c-3.1,0-6.3-0.8-6.3-6.2V380.1h-26.3    v116.5c0,6,1.6,13,4.7,18.2c3.1,5.4,8.1,9.6,15.1,9.6c2.3,0,4.7-0.8,7-2.1c4.7-2.6,8.3-6.3,11.4-9.4c1.3-1.3,2.3-2.3,2.9-2.6v12    h26.3V380.1H1065.4z"/>
        		<path class="st0" d="M1175.2,387.4c-3.4-5.2-8.3-9.4-15.6-9.4c-2.3,0-4.9,0.5-7.3,1.8c-5.2,2.3-9.1,5.5-13.5,9.6v-9.4h-26.3v191.2    h26.3V513c2.3,2.1,4.4,3.9,6.8,5.7c3.9,2.9,9.1,5.7,14.1,5.7c7.3,0,12.2-4.2,15.6-9.6c3.1-5.2,4.7-12.2,4.7-18.2v-90.8    C1179.9,399.9,1178.3,392.8,1175.2,387.4z M1153.6,491.2c0,4.9-3.1,8.6-7,8.6c-3.9,0-7.8-4.4-7.8-8.6v-79.9c0-4.9,3.9-8.6,7.8-8.6    c3.9,0,7,3.6,7,8.6V491.2z"/>
        		<path class="st2" d="M1286.2,331.2v151.9c0,2.9-0.3,5.2-1,7c-1,3.9-3.4,7-8.3,7c-2.3,0-4.2-0.8-5.5-2.1c-2.6-2.9-3.9-6.5-3.9-12    V331.2h-28.1v151.9c0.3,7.8,1.8,14.8,4.7,20.8c2.3,5.2,5.7,10.1,10.9,14c5.2,4.2,12.5,6.5,21.9,6.5c9.4,0,16.4-2.3,21.6-6.5    c5.2-3.9,8.8-8.9,11.2-14c2.9-6,4.4-13,4.7-20.8V331.2H1286.2z"/>
        		<path class="st2" d="M1390.3,394.1l25.8-63h-27.3l-23.4,63.7l-1.3,3.1h-1v-66.8h-28.1v191.2h28.1v-67.6l6.5-15.6l1.6-3.9h0.8    l0.8,3.9l19.5,83.2h27.3L1390.3,394.1z"/>
        	</g>
        	<rect x="620.1" y="289" class="st1" width="4.4" height="275.5"/>
        	<g>
        		<path class="st1" d="M303.4,349.2l-0.3,0c0,0,0,0,0.1-0.1C303.2,349.1,303.3,349.1,303.4,349.2z"/>
        		<g>
        			<g>
        				<path class="st1" d="M360.5,341.9l-2.3,0.1c-0.1,0.3-0.2,0.5-0.2,0.8l0,0c-0.3,0.8-0.7,1.6-1.1,2.4c-0.1,0.2-0.2,0.4-0.3,0.6      c0,0.1-0.1,0.1-0.1,0.2c-1.3,1.8-3,3.6-5.2,5.2c-0.3,0.8-0.6,1.7-1,2.5c0,0.1,0,0.1-0.1,0.2c-0.2,0.3-0.3,0.7-0.5,1v0      c-0.1,0.1-0.1,0.2-0.2,0.3c0,0.1-0.1,0.1-0.1,0.2c-0.1,0.2-0.3,0.5-0.4,0.7v0c0.7-0.3,1.3-0.6,1.9-1c0.3-0.2,0.6-0.3,0.8-0.5      c0.2-0.1,0.4-0.2,0.6-0.4c1.9-1.2,3.6-2.5,4.9-4c2.3-2.5,3.5-5.3,3.5-8.3C360.5,342,360.5,341.9,360.5,341.9z M355.8,332.6      c1.3,1.6,2.2,3.3,2.5,5.2c0,0.2,0.1,0.5,0.1,0.7l0,0.1l-1.8,0.1l-4.4,0.2c0,0,0,0.1,0,0.1l7.7-0.3      C359.3,336.5,357.8,334.5,355.8,332.6z M349.1,342.4l-1.5,0.1c0,0.2-0.1,0.4-0.1,0.6v0c-0.1,0.4-0.2,0.9-0.3,1.3      c-0.2,0.6-0.4,1.2-0.6,1.8c-1.6,3.8-4.6,7.2-8.5,9.6c-0.3,1.1-0.7,2.1-1.1,3c1.2-0.5,2.3-1,3.3-1.6c0.4-0.2,0.7-0.4,1-0.6      c0.5-0.3,0.9-0.6,1.3-1c0,0,0,0,0,0c0,0,0.1,0,0.1-0.1c0,0,0,0,0,0c0,0,0,0,0,0l0,0c0,0,0.1,0,0.1-0.1c0.1-0.1,0.1-0.1,0.2-0.2      c0,0,0,0,0,0c1.2-1,2.3-2.1,3.2-3.4c1.1-1.6,2-3.4,2.4-5.3c0.3-1.3,0.5-2.6,0.5-4C349.1,342.5,349.1,342.4,349.1,342.4z       M345.5,332.4c0.1,0.1,0.2,0.3,0.3,0.4c0.3,0.4,0.5,0.8,0.7,1.3c0.1,0.4,0.3,0.7,0.4,1c0.2,0.6,0.4,1.3,0.6,1.9      c0.2,0.6,0.3,1.3,0.3,2l0,0.1l-8,0.4l5.1-0.2l1.9-0.1l2-0.1C348.2,336.8,347,334.5,345.5,332.4z M337.7,342.9l-0.7,0      c0,1.1-0.2,2.3-0.3,3.3c0,0.1,0,0.2-0.1,0.3c-0.3,1.4-0.6,2.8-1.1,4.1c-0.2,0.7-0.5,1.4-0.8,2c-1.7,3.5-4.1,6-7,6.6      c-0.1,0-0.2,0-0.2,0c-0.4,0-0.8,0.1-1.1,0.1c-0.2,0-0.5,0-0.7,0l0,0c-0.1,0-0.1,0-0.2,0c-1.4-0.2-2.8-0.9-4.1-2.1      c1.7,1.8,3.7,2.9,5.7,3.1c0.1,0,0.2,0,0.3,0c0.4,0,0.8,0,1.2,0c0.3,0,0.5-0.1,0.7-0.1h0c0,0,0,0,0,0c0,0,0.1,0,0.2-0.1      c1.5-0.4,2.9-1.3,4.1-2.7c0.8-0.9,1.5-2,2.1-3.3c0.2-0.3,0.3-0.7,0.4-1c0-0.1,0-0.1,0.1-0.2c0.1-0.3,0.3-0.7,0.4-1      c0.4-1.4,0.7-2.9,1-4.5c0.2-1.4,0.2-2.9,0.2-4.5L337.7,342.9z M334.7,330.6c0.5,1,0.9,2.1,1.2,3.3c0.3,1,0.6,2.1,0.7,3.3      c0.2,0.8,0.3,1.7,0.3,2.5l0.5,0C337,336.4,336,333.3,334.7,330.6z M335,324.9C335,325,335,325,335,324.9      c0.3,0.2,0.6,0.2,0.8,0.3C335.5,325.1,335.2,325,335,324.9z M325.9,323.2l-0.3,0l-1.2,0c-2.7,0.3-5.1,2.3-6.7,5.4      c-0.9,1.6-1.5,3.6-1.9,5.8c-0.2,1.1-0.4,2.3-0.4,3.6c-0.1,0.9-0.1,1.8,0,2.7l0.7,0c0.2-4.2,1.3-8.1,2.9-11      c1.6-2.9,3.8-4.8,6.3-5.4l0.2,0l1.1-0.1c1.9,0,3.7,0.9,5.2,2.5C330.1,324.7,328.1,323.5,325.9,323.2z M318,358.6      c-0.3-0.1-0.7-0.2-1-0.3C317.4,358.5,317.7,358.6,318,358.6C318.1,358.7,318,358.7,318,358.6z M316.7,348.2      c-0.3-1.3-0.5-2.7-0.6-4.2l0-0.1l-0.6,0c0.2,1.3,0.4,2.5,0.7,3.6c0,0.1,0.1,0.2,0.1,0.3c0.4,1.5,0.9,2.9,1.5,4.2      c0,0.1,0,0.1,0.1,0.2C317.5,351,317.1,349.7,316.7,348.2z M306.8,331.9c-0.6,0.8-1.1,1.6-1.5,2.5c-0.2,0.4-0.4,0.9-0.6,1.4      c-0.1,0.4-0.2,0.8-0.3,1.1c-0.2,0.6-0.3,1.1-0.3,1.7c0,0.1,0,0.3-0.1,0.4c-0.1,0.7-0.1,1.4-0.1,2.1l0,0.2l1.5-0.1      c0.4-2.5,1.3-4.9,2.8-7c1.2-1.8,2.7-3.4,4.5-4.8c0.7-0.5,1.4-1,2.2-1.5c0.1-0.2,0.1-0.4,0.2-0.5c0.1-0.2,0.1-0.4,0.2-0.6      c0.2-0.7,0.5-1.3,0.7-1.8C312.1,326.4,308.9,328.8,306.8,331.9z M313.8,344l-9.6,0.4c0.1,0.3,0.2,0.6,0.3,0.9v0      c0.1,0.5,0.3,0.9,0.5,1.3c0.2,0.6,0.5,1.2,0.8,1.8c0.5,1,1.1,1.9,1.8,2.7c-0.6-0.9-1.1-1.9-1.4-2.9c-0.4-1.2-0.7-2.4-0.8-3.7      c0,0,0-0.1,0-0.1L313.8,344L313.8,344z M299.9,330.1c-0.8,0.6-1.6,1.1-2.3,1.8c-0.2,0.2-0.4,0.3-0.6,0.5      c-0.2,0.2-0.4,0.4-0.6,0.7c-2.2,2.3-3.6,5-3.8,7.8c0,0.3,0,0.5,0,0.8v0.2l1.9-0.1l0.5,0c0.9-3.3,3.3-6.5,6.9-9.2      c0.2-0.6,0.4-1.2,0.7-1.7c0.5-1.1,1.1-2.2,1.7-3.2C302.7,328.3,301.2,329.2,299.9,330.1z M300.7,344.7      C300.7,344.7,300.7,344.7,300.7,344.7C300.7,344.6,300.7,344.6,300.7,344.7c0-0.1,0-0.1,0-0.1l-0.2,0l-0.6,0l-0.3,0l-1,0.1      l-0.3,0l-1.8,0.1h0l0,0c0,0,0,0,0,0.1c-0.1,0-0.2,0-0.3,0h0l-3.1,0.2c0,0.1,0.1,0.2,0.1,0.3c0.1,0.3,0.2,0.6,0.3,0.9l0,0      c0.3,0.8,0.8,1.5,1.3,2.2c0,0.1,0.1,0.1,0.1,0.2c0.1,0.2,0.3,0.4,0.4,0.6c0.1,0.1,0.1,0.1,0.2,0.2c0.6,0.7,1.2,1.3,1.9,1.9      c-0.9-1.1-1.6-2.2-2.1-3.4c-0.3-0.9-0.5-1.8-0.6-2.7c0,0,0-0.1,0-0.1l3.5-0.2L300.7,344.7z"/>
        				<path class="st1" d="M534.3,512.7c-1.7,5.6-5.9,10.9-12,15.4c-0.6,1.8-1.4,3.5-2.2,5.2c-0.5,0.9-1,1.8-1.5,2.7c0,0,0,0,0,0v0      c-0.3,0.5-0.6,0.9-0.8,1.4c-0.4,0.6-0.8,1.1-1.2,1.7c0.8-0.3,1.6-0.7,2.4-1h0c0.8-0.4,1.6-0.8,2.4-1.2c1.6-0.8,3-1.7,4.4-2.5      c8.9-5.6,14.3-13,14.6-21.3c0-0.1,0-0.2,0-0.3H534.3z M539.7,506.6c-1.7-5.9-5.9-11.5-12.1-16.3c-3.5-2.7-7.6-5.2-12.3-7.4      c0.3,0.4,0.6,0.8,0.9,1.2c1.3,0.6,2.5,1.3,3.6,1.9c0.8,0.5,1.5,0.9,2.3,1.4c1.8,1.1,3.3,2.4,4.8,3.7c0.7,0.6,1.3,1.3,2,1.9      c3.7,4,5.9,8.6,6.1,13.6v0.1H539.7z M518.5,512.7h-4.1c-0.4,2.3-1.2,4.4-2.1,6.5c-1.4,3.2-3.5,6.2-5.9,8.9c0,0,0,0,0,0      c-0.9,1-1.8,1.9-2.8,2.8c-2.2,1.9-4.5,3.7-7.1,5.2c-0.1,0.3-0.2,0.6-0.3,0.9c-0.1,0.3-0.2,0.6-0.3,1c0,0,0,0.1,0,0.1      c0,0,0,0,0,0c-0.6,1.8-1.3,3.4-2.1,5c0.9-0.3,1.7-0.6,2.5-0.9c1.9-0.8,3.8-1.7,5.5-2.7c0.5-0.3,0.9-0.5,1.4-0.8      c0.6-0.4,1.3-0.9,1.9-1.3c1.3-0.9,2.5-1.9,3.7-3c0.3-0.3,0.5-0.5,0.8-0.8c0.1-0.1,0.2-0.2,0.3-0.3c0.3-0.4,0.7-0.7,1-1.1      c0.1-0.1,0.2-0.2,0.3-0.3c0.3-0.3,0.6-0.7,0.8-1c0.2-0.3,0.4-0.6,0.7-0.9c1.1-1.5,2-3,2.8-4.7c0.2-0.4,0.4-0.9,0.6-1.3v0      c0.1-0.1,0.1-0.2,0.2-0.3c1.4-3.3,2.1-6.8,2.2-10.5C518.5,512.9,518.5,512.8,518.5,512.7z M518,506.6c-0.3-1.6-0.7-3.2-1.3-4.8      v0c0,0,0,0,0,0c-2.4-6.7-7-12.7-13-17.4c0,0,0,0,0,0h0l0,0c-0.8-0.6-1.6-1.2-2.4-1.8c0,0-0.1,0-0.1-0.1c0,0-0.1,0-0.1-0.1      c-0.8-0.5-1.5-1-2.3-1.5c-0.1,0-0.1-0.1-0.2-0.1c-0.1,0-0.1-0.1-0.2-0.1c-0.8-0.5-1.6-0.9-2.4-1.3c-0.1-0.1-0.3-0.1-0.4-0.2      c-0.9-0.5-1.8-0.9-2.8-1.3c0.2,0.5,0.5,1,0.7,1.5c0,0,0,0,0,0c1.3,0.5,2.6,1,3.8,1.6c2.1,1.1,4.1,2.3,5.9,3.7      c3.4,2.6,6.2,5.8,8.2,9.4c1.7,3,2.8,6.3,3.2,9.9c0,0.3,0.1,0.6,0.1,0.8v0c0.1,0.6,0.1,1.2,0.1,1.7v0.1H518z M494.5,512.7      c-0.6,6.6-2.4,12.7-5,17.7c-0.1,0.2-0.2,0.3-0.2,0.4c-2.3,4.2-5.2,7.6-8.4,9.6c-0.5,0.3-1,0.6-1.6,0.9c-1.2,0.6-2.5,1-3.8,1.2      c-0.1,0-0.3,0.1-0.4,0.1h0c-0.3,0-0.6,0-0.9,0h0c-0.4,0-0.8,0-1.3,0c-5.8-0.4-12-7.4-15.2-14.7c0,0,1.1,3.7,1.6,4.3c0,0,0,0,0,0      c2.5,4.8,5.8,8.7,9.4,11c1.8,1.2,3.8,2,5.8,2.3c0.2,0,0.3,0,0.5,0.1h0c0.1,0,0.2,0,0.3,0c0.3,0,0.5,0,0.7,0h0c0.5,0,0.9,0,1.4,0      c7.5-0.5,13.8-7.5,17-18c0,0,0,0,0,0c0-0.1,0.1-0.2,0.1-0.3c0.2-0.8,0.5-1.6,0.7-2.5c0,0,0-0.1,0-0.1v0l0,0c0,0,0,0,0,0      c0,0,0,0,0,0c0.1-0.3,0.1-0.6,0.2-1c0,0,0,0,0-0.1c0-0.1,0-0.2,0.1-0.3c0-0.1,0-0.1,0-0.2c0-0.3,0.1-0.5,0.1-0.8c0,0,0,0,0-0.1      c0-0.1,0-0.2,0-0.3c0.1-0.4,0.2-0.9,0.2-1.4c0.1-0.3,0.1-0.6,0.1-0.9c0.1-0.8,0.2-1.7,0.3-2.5c0-0.3,0-0.6,0.1-0.9v0      c0,0,0,0,0,0c0-0.1,0-0.2,0-0.3c0-0.4,0-0.8,0.1-1.2c0-0.5,0-1,0-1.5v-0.3H494.5z M496.1,504.7c-1.7-14.1-8.4-25.9-16.8-29.8      c-0.1,0-0.2-0.1-0.3-0.1c-1.1-0.5-2.3-0.9-3.5-1.1c-0.2,0-0.3,0-0.5,0c-0.8,0-1.6,0-2.4-0.1c-5.3,0.3-10,4-13.4,9.9      c-1.4,2.3-2.5,5-3.4,7.9c-1.4,4.5-2.2,9.6-2.3,15.1h1.9c0-0.5,0.1-1,0.2-1.5c1.6-12.9,7.7-23.8,15.4-27.3c0.1,0,0.2-0.1,0.3-0.1      c1-0.4,2.1-0.8,3.2-0.9c0.1,0,0.3,0,0.4,0h0c0.7,0,1.5,0,2.2-0.1c4.9,0.3,9.2,3.7,12.3,9c1.2,2.1,2.3,4.6,3.1,7.3      c1.3,4.1,2,8.7,2.1,13.6h1.7C496.2,506,496.2,505.4,496.1,504.7z M457.2,541.3c-0.2-0.5-0.5-0.9-0.7-1.4c-0.4-0.1-0.7-0.3-1-0.4      c-2.3-0.9-4.4-2-6.3-3.3c-1.8-1.2-3.6-2.5-5.1-4c-2.9-2.8-5.2-6-6.8-9.6v0c-0.1-0.1-0.1-0.2-0.2-0.3c-1.2-3-2-6.2-2-9.6v0H432      c0.5,2.5,1.3,5,2.4,7.4c0.6,1.4,1.4,2.8,2.2,4.1c0.2,0.3,0.4,0.6,0.6,0.9c0,0,0,0,0.1,0.1c0.5,0.8,1.1,1.5,1.6,2.3      c0.3,0.3,0.6,0.7,0.8,1c0.1,0.1,0.2,0.2,0.3,0.4c0.3,0.3,0.5,0.6,0.8,0.9c0,0,0,0,0,0c0,0,0,0,0,0c0.4,0.4,0.8,0.8,1.2,1.3      c0.6,0.6,1.2,1.2,1.8,1.7c1.3,1.2,2.8,2.4,4.3,3.4C450.9,538.3,454,540,457.2,541.3C457.3,541.4,457.2,541.4,457.2,541.3z       M455.3,512.7L455.3,512.7l-0.7,0c0.3,1,0.1,5.3,0.4,6.3C455,519.1,455.4,513.2,455.3,512.7z M450.7,478.5      c-2.3,1.2-4.5,2.5-6.5,4h0c-0.4,0.3-0.8,0.6-1.1,0.9c-0.2,0.2-0.4,0.3-0.6,0.5l0,0c-0.2,0.1-0.4,0.3-0.5,0.5      c-0.6,0.5-1.1,1-1.6,1.5c-0.4,0.4-0.7,0.8-1.1,1.2c-0.2,0.2-0.4,0.4-0.5,0.6c-0.1,0.2-0.3,0.3-0.4,0.5c-0.1,0.2-0.3,0.3-0.4,0.5      c-0.5,0.6-0.9,1.2-1.3,1.8c-0.1,0.1-0.2,0.2-0.2,0.3c-0.4,0.6-0.8,1.2-1.1,1.8c0,0,0,0.1,0,0.1c-0.9,1.6-1.6,3.3-2.2,5      c-0.7,2.1-1.2,4.4-1.4,6.7v0c0,0.3,0,0.5,0,0.8c0,0.4-0.1,0.8-0.1,1.1c0,0.1,0,0.2,0,0.3h4.1c0.3-1.4,0.6-2.8,1.1-4.2v0      c2.2-6.1,6.4-11.7,12-16c0,0,0,0,0,0c1.5-1.2,3.1-2.3,4.8-3.3c0.8-2.5,1.7-4.8,2.7-7C454.3,476.8,452.5,477.6,450.7,478.5z       M433.8,535.2c-0.5-0.2-0.9-0.4-1.3-0.6c-1.4-0.7-2.8-1.5-4.1-2.3c-8.1-5.2-13.1-11.9-13.4-19.5v0h-4.8      c2.3,8.3,9.7,15.8,20.4,21.6c1.3,0.7,2.7,1.4,4.1,2.1C434.4,536,434.1,535.6,433.8,535.2z M431.3,481.3c-0.7,0.3-1.3,0.6-2,1      c-0.2,0.1-0.4,0.2-0.7,0.3c-0.9,0.4-1.7,0.9-2.5,1.3c-0.9,0.5-1.7,1-2.5,1.5c-2.8,1.8-5.3,3.9-7.3,6.1      c-4.1,4.4-6.5,9.4-6.7,14.8c0,0.1,0,0.2,0,0.3h6.1c1.6-5.3,5.5-10.4,11.1-14.7c0.3-0.2,0.6-0.5,1-0.7c0,0,0,0,0,0      c0.1-0.2,0.1-0.4,0.2-0.6c0.2-0.5,0.4-1,0.6-1.5c0.1-0.2,0.1-0.4,0.2-0.5s0.2-0.3,0.2-0.5c0.2-0.4,0.4-0.9,0.6-1.3      c0.1-0.2,0.2-0.4,0.3-0.6c0.1-0.2,0.2-0.4,0.3-0.6c0.2-0.4,0.4-0.7,0.6-1.1c0.1-0.2,0.2-0.4,0.3-0.7c0.2-0.3,0.3-0.6,0.5-0.8      c0-0.1,0.1-0.2,0.1-0.2c0,0,0,0,0-0.1c0.2-0.3,0.3-0.5,0.5-0.7c0.1-0.2,0.2-0.3,0.3-0.5c0.3-0.4,0.6-0.8,0.8-1.2      C432.7,480.6,432,480.9,431.3,481.3z"/>
        				<path class="st1" d="M386.8,375.2c-0.4,0.2-0.8,0.3-1.2,0.5c0,0,0,0,0,0c-1.2,0.6-2.3,1.2-3.4,1.8c-0.5,0.3-1,0.6-1.5,1      c-2.7,1.8-5,3.8-6.7,6.1c-1.6,2.1-2.6,4.3-3.1,6.6c0,0.1,0,0.3-0.1,0.4c0,0.2-0.1,0.4-0.1,0.7c0,0.1,0,0.2,0,0.4      c0,0.3-0.1,0.6-0.1,0.9v0.2h5.1c1.1-3.7,3.8-7.2,7.7-10.3c0.3-0.9,0.6-1.9,1-2.8c0.5-1.3,1.2-2.5,1.9-3.7      c0.1-0.2,0.2-0.4,0.4-0.6c0.1-0.1,0.2-0.3,0.3-0.4c0.1-0.1,0.1-0.2,0.2-0.2c0-0.1,0.1-0.1,0.1-0.2c0-0.1,0.1-0.1,0.2-0.2      c0.1-0.1,0.1-0.2,0.2-0.3c0.1-0.1,0.2-0.2,0.2-0.3C387.5,374.9,387.2,375.1,386.8,375.2z M387.9,414      C387.8,413.9,387.8,413.9,387.9,414c-0.1-0.2-0.2-0.3-0.3-0.4l-0.1,0c-1.3-0.7-2.6-1.4-3.7-2.2c-1.5-1-2.8-2.1-3.9-3.2      c-2.8-2.9-4.5-6.3-4.6-9.9h-4.1v0c0.1,0.3,0.2,0.6,0.3,0.9c0.1,0.2,0.1,0.4,0.2,0.6c0,0.1,0.1,0.2,0.1,0.3      c0.2,0.6,0.5,1.1,0.8,1.7c0.1,0.2,0.2,0.4,0.3,0.6c0.1,0.2,0.2,0.4,0.3,0.6c0.1,0.1,0.2,0.3,0.3,0.4c0,0,0,0,0,0.1      c0.1,0.1,0.2,0.3,0.3,0.4c0.1,0.1,0.2,0.3,0.3,0.4c0.1,0.1,0.1,0.2,0.2,0.3s0.1,0.2,0.2,0.3c0,0,0.1,0.1,0.1,0.1      c0.1,0.1,0.1,0.1,0.2,0.2c0.1,0.2,0.3,0.3,0.4,0.5c0.1,0.2,0.3,0.4,0.5,0.5c0.1,0.1,0.2,0.3,0.4,0.4c0,0,0,0,0,0      c0.4,0.4,0.8,0.8,1.2,1.2c0.2,0.2,0.4,0.3,0.6,0.5c0.2,0.2,0.3,0.3,0.5,0.5c0.4,0.3,0.7,0.6,1.1,0.9c0.1,0.1,0.2,0.2,0.3,0.3      c0.3,0.2,0.5,0.4,0.8,0.6c0.1,0.1,0.3,0.2,0.4,0.3c0.3,0.2,0.6,0.5,0.9,0.7c0.1,0.1,0.2,0.1,0.2,0.2c0.4,0.3,0.8,0.6,1.3,0.8h0      c0.6,0.4,1.3,0.8,1.9,1.2c0.4,0.2,0.8,0.4,1.2,0.7c0.4,0.2,0.9,0.4,1.3,0.6c0.3,0.2,0.7,0.3,1,0.5      C388.5,414.8,388.2,414.4,387.9,414z M403,374.9c0.1-0.4,0.3-0.7,0.4-1.1c0.3-0.7,0.6-1.4,0.9-2.1c-0.8,0.3-1.6,0.5-2.3,0.9      c-0.6,0.3-1.2,0.5-1.8,0.8c-0.1,0-0.1,0.1-0.2,0.1c-0.4,0.2-0.9,0.4-1.3,0.7c-0.3,0.2-0.7,0.4-1,0.6c0,0-0.1,0.1-0.1,0.1      c0,0-0.1,0-0.1,0.1c-0.1,0.1-0.3,0.2-0.4,0.3c-0.5,0.3-0.9,0.6-1.4,1c-2.2,1.7-4.1,3.7-5.6,5.9c-0.3,0.5-0.6,0.9-0.9,1.4      c-1.7,3-2.7,6.3-2.8,9.9c0,0.1,0,0.2,0,0.2h3.4c1.3-6.6,5.9-12.5,12.4-16.4c0.1-0.2,0.1-0.5,0.2-0.7c0-0.2,0.1-0.4,0.2-0.6      c0.4-0.3,0.7-0.5,1.1-0.8C403.5,375.2,403.3,375,403,374.9L403,374.9z M404.3,417.3c-0.1,0-0.1,0-0.2-0.1      c-1.7-0.7-3.3-1.5-4.7-2.4c-1.7-1.1-3.2-2.3-4.5-3.8c-0.1-0.1-0.2-0.2-0.3-0.3c-0.2-0.2-0.4-0.5-0.6-0.7      c-2.7-3.3-4.3-7.3-4.5-11.7c0-0.1,0-0.1,0-0.2h-2.8c1.2,6.6,5.4,12.7,11.5,16.9c0,0,0,0,0,0c0.7,0.5,1.4,1,2.2,1.4      c0,0,0,0,0.1,0c1.4,0.9,2.9,1.6,4.5,2.3C404.8,418.4,404.6,417.8,404.3,417.3z M430.9,383.3c-2.7-7.2-7.3-12.4-12.6-13.2      c-0.1,0-0.2,0-0.3-0.1h0c-0.6,0-1.2,0-1.7-0.1c-1.3,0.1-2.5,0.4-3.6,1c-2.2,1.1-4.2,3.1-5.8,5.7c-0.1,0.1-0.2,0.3-0.3,0.4      c-0.3,0.5-0.6,1.1-0.9,1.7c-0.4,0.8-0.7,1.6-1,2.4c0,0.1,0,0.1,0,0.2c-1.2,3.2-1.9,7-2.1,11.1c0,0.4,0,0.8,0,1.3h1.6      c0.3-3.3,1.1-6.4,2.1-9.2c2.5-6.5,6.6-11.2,11.4-11.9c0.1,0,0.2,0,0.3,0h0c0.5,0,1,0,1.5,0c1.1,0.1,2.2,0.4,3.3,0.9      c2,1,3.8,2.8,5.2,5.2c0.1,0.1,0.2,0.2,0.2,0.4c0.3,0.5,0.6,1,0.8,1.5c0.3,0.7,0.6,1.4,0.9,2.1c0,0.1,0,0.1,0,0.1      c1.1,2.9,1.8,6.3,1.9,10.1c0,0.3,0,0.6,0,0.9h1.4C432.9,390,432.1,386.4,430.9,383.3z M431.8,398.1c-1.1,11-6.7,20.1-13.5,21.2      c-0.1,0-0.2,0-0.3,0h0c-0.5,0-1,0-1.5,0c-3.4-0.2-6.4-2.4-8.6-6c-1-1.6-1.8-3.4-2.4-5.4c-0.7-2-1.1-4.3-1.3-6.6      c0-0.1,0-0.2,0-0.2v0c0-0.1,0-0.1,0-0.2c-0.1-0.9-0.1-1.8-0.1-2.7h-1.4c1.1,12.3,7.4,22.5,15,23.7c0.1,0,0.2,0,0.3,0h0      c0.6,0,1.1,0,1.7,0c3.7-0.2,7-2.7,9.5-6.7c1.1-1.8,2-3.8,2.7-6c0.7-2.2,1.2-4.7,1.4-7.4c0-0.1,0-0.2,0-0.2v0c0-0.1,0-0.1,0-0.2      c0.1-1,0.2-2,0.2-3v-0.2H431.8z M430.7,373c0.3,0.5,0.5,1.1,0.7,1.6c0.3,0.1,0.5,0.2,0.7,0.3c0.5,0.2,1.1,0.5,1.6,0.8      c0.4,0.2,0.9,0.5,1.3,0.7c0.3,0.2,0.6,0.4,0.9,0.6c0,0,0.1,0,0.1,0.1c0,0,0.1,0.1,0.1,0.1c0.1,0.1,0.3,0.2,0.4,0.3      c0.4,0.3,0.8,0.6,1.2,0.9c2,1.5,3.7,3.3,5,5.3c0.3,0.4,0.6,0.8,0.8,1.3c1.5,2.7,2.4,5.7,2.5,8.9h2.8      C447.3,384.9,440.3,377.1,430.7,373z M445.9,398.1c-1.2,5.9-4.9,11.3-10.3,15.1c-0.6,0.5-1.3,0.9-2,1.3      c-0.4,1.4-0.8,2.7-1.3,3.9c-0.2,0.6-0.5,1.1-0.8,1.7c0.6-0.2,1.2-0.4,1.7-0.6c1.9-0.7,3.6-1.6,5.2-2.7c1.9-1.2,3.6-2.6,5-4.2      c0.1-0.1,0.2-0.2,0.3-0.3c0.2-0.3,0.5-0.5,0.7-0.8c3-3.7,4.8-8.1,5-12.9c0-0.1,0-0.2,0-0.2c0-0.1,0-0.1,0-0.2H445.9z M447,376.6      c0.4,0.6,0.8,1.1,1.2,1.7c0.6,0.3,1.2,0.7,1.8,1c0.5,0.3,0.9,0.6,1.4,0.9c2.5,1.6,4.5,3.5,6,5.5c1.4,1.9,2.4,3.8,2.8,6      c0.1,0.7,0.2,1.3,0.3,2.1h4.1C462.8,387,456.3,381,447,376.6z M460,398.1c-0.1,0.2-0.1,0.4-0.2,0.6c-1.2,3.5-3.8,6.8-7.5,9.7      c-0.6,1.9-1.4,3.8-2.4,5.5c-0.4,0.7-0.8,1.4-1.2,2c-0.2,0.3-0.4,0.6-0.6,0.9c-0.1,0.1-0.1,0.2-0.2,0.3c0.5-0.2,1-0.4,1.4-0.6      c0.4-0.2,0.9-0.4,1.3-0.6c0.3-0.1,0.6-0.3,0.9-0.4c0,0,0,0,0,0c0.7-0.4,1.4-0.7,2.1-1.1c0,0,0,0,0,0c0.7-0.4,1.4-0.8,2-1.3      c1.6-1.1,3.1-2.3,4.3-3.6c3.2-3.3,5-7,5.2-11c0-0.1,0-0.1,0-0.2H460z"/>
        			</g>
        			<path class="st0" d="M403.8,375.3c-0.4,0.3-0.8,0.5-1.1,0.8v0c0.1-0.3,0.2-0.5,0.3-0.8c0-0.1,0.1-0.2,0.1-0.3     C403.3,375,403.5,375.2,403.8,375.3z"/>
        			<path class="st0" d="M419.5,397.9h12.2c0,0.1,0,0.1,0,0.2h-11.9C419.7,398.1,419.6,398,419.5,397.9z"/>
        			<path class="st0" d="M431.8,393.7c0,0.1,0,0.1,0,0.2h-17.5c-0.1-0.1-0.2-0.1-0.3-0.2H431.8z"/>
        			<path class="st0" d="M438.8,398.1h-4.9c0-0.1,0-0.1,0-0.2h4.6C438.7,398,438.8,398.1,438.8,398.1z"/>
        			<path class="st0" d="M494.6,506.6h-39.1c0,0.1,0,0.2,0,0.3h39.2C494.6,506.8,494.6,506.7,494.6,506.6z M455.3,512.5v0.3h39.1v0     c0-0.1,0-0.2,0-0.2H455.3z M403,374.9c0,0.1-0.1,0.2-0.1,0.3c-0.1,0.3-0.2,0.5-0.3,0.8v0c0.4-0.3,0.7-0.5,1.1-0.8     C403.5,375.2,403.3,375,403,374.9z M438.6,397.9H434c0,0.1,0,0.1,0,0.2h4.9C438.8,398.1,438.7,398,438.6,397.9z M431.8,393.7     C431.8,393.7,431.8,393.7,431.8,393.7l-27.8,0c0,0.1,0,0.1,0,0.2h27.8C431.8,393.9,431.8,393.8,431.8,393.7z M403.9,397.9v0.2     h27.8v0c0-0.1,0-0.1,0-0.2H403.9z M344.1,330.7c-2.1-2.4-5-4.3-8.4-5.4c4,1.6,7.3,4.1,9.7,7.2     C345.1,331.8,344.6,331.2,344.1,330.7z M339.2,339.7c-0.6-5.7-2.1-10.8-4.2-14.6c-0.1,0-0.1,0-0.2-0.1c0.4,0.7,0.7,1.4,1.1,2.2     c0.8,1.8,1.4,3.8,1.8,6c0.2,1,0.4,2.1,0.5,3.3c0.1,0.8,0.2,1.6,0.2,2.4c0,0.1,0,0.3,0,0.4v0.4L339.2,339.7z M325.1,343.4     l-4.6,0.2l-4.4,0.2v0l12.1-0.5l4.8-0.2l4-0.2c0-0.1,0-0.1,0-0.2L325.1,343.4z M333.1,339.9l-0.9,0l-16.1,0.8c0,0,0,0.1,0,0.2     l4.2-0.2l0.8-0.1l10.1-0.5l5.8-0.3v0L333.1,339.9z M333.5,328.7c-0.5-0.7-1-1.4-1.5-1.9c0.4,0.5,0.8,1,1.2,1.5     c0.5,0.7,1,1.5,1.5,2.4C334.3,329.9,333.9,329.3,333.5,328.7z M319,354.1c-0.4-0.6-0.7-1.2-1-1.8c0.2,0.4,0.4,0.8,0.5,1.1     c0.1,0.3,0.3,0.6,0.5,0.9c0.6,1.1,1.4,2,2.1,2.7C320.4,356.2,319.7,355.3,319,354.1z M317,356c0-0.1-0.1-0.2-0.1-0.3     c-0.2-0.4-0.3-0.9-0.5-1.4c0,0,0,0,0,0c-0.1-0.1-0.1-0.3-0.1-0.4c0-0.1-0.1-0.2-0.1-0.3c-0.4-1.4-0.8-2.9-1-4.4     c-0.3-1.6-0.5-3.2-0.6-4.8l0-0.4l-0.7,0c0.1,1.1,0.3,2.1,0.4,3.1c0,0.1,0,0.2,0.1,0.3c0.2,1.3,0.5,2.6,0.8,3.8     c0.1,0.3,0.2,0.6,0.3,0.9c0.7,2.4,1.6,4.6,2.7,6.5c0.1,0,0.1,0,0.2,0.1C317.8,357.8,317.4,356.9,317,356z M307.6,351.2     c0.4,0.6,0.9,1.3,1.4,1.8c1,1.1,2.1,2,3.3,2.9c0,0,0.1,0,0.1,0.1c0,0,0.1,0.1,0.1,0.1c0,0,0,0,0.1,0.1c0,0,0.1,0,0.1,0.1     c0.4,0.3,0.9,0.6,1.3,0.8h0c0.3,0.2,0.7,0.3,1,0.5c0.6,0.3,1.3,0.6,2,0.8C313.2,356.7,309.9,354.2,307.6,351.2z"/>
        			<path class="st0" d="M550.4,509.7c-0.1-1-0.2-2-0.4-3c-1.6-9-6.8-17.3-15-24.2c0,0,0,0,0,0c-7.9-6.7-18.5-12.1-31-15.6     c-3.1-0.9-6.4-1.7-9.8-2.3c0,0,0,0,0,0h0c-0.2-0.3-0.3-0.6-0.5-0.9c-2.1-3.6-3.9-7.4-6.2-10.9l-6.9-10.4     c-4.9-6.9-10.2-13.4-15.8-19.7c-0.4-0.4-0.7-0.8-1.1-1.2c-0.9-0.9-1.7-1.9-2.6-2.8c1.4-1.1,2.7-2.3,3.9-3.5     c4.5-4.7,7-10.4,7.2-16.4c0-0.2,0-0.4,0-0.6c0-0.8,0-2.2,0-2.2c-0.1-0.7-0.1-1.5-0.3-2.2c-2.9-17.1-24.4-30.4-52.8-31.9     c-0.4,0-0.9-0.1-1.3-0.1h0c-0.4,0-0.7-0.1-1.1-0.1c-0.1,0-0.3,0-0.4,0h-0.1c-0.3,0-0.5,0-0.7,0h-1.2c-5.5,0-10.8,0.5-15.8,1.4     c-2.2,0.4-4.3,0.9-6.3,1.5c-1.6,0.4-3.1,0.9-4.6,1.5c-0.5,0.2-1,0.4-1.6,0.6c0,0-0.1,0-0.1,0h0c-7.7-3.4-15.6-6.5-23.5-9.1     c-1.3-0.4-2.6-0.9-3.8-1.3l0,0c1.3-1.1,2.4-2.4,3.3-3.6c2.4-3.2,3.6-6.8,3.6-10.6c0-0.1,0-0.3,0-0.4c0-0.5-0.1-1.6-0.1-1.6     c-0.1-0.5-0.2-1-0.3-1.6c-0.8-3.7-2.9-7.1-5.9-10.1c-1.1-1.1-2.4-2.1-3.7-3.1c-1.8-1.2-3.7-2.4-5.9-3.3c-0.1-0.1-0.3-0.1-0.4-0.2     c-6.4-2.9-14.3-4.5-23-4.6c-0.3,0-0.6,0-1,0c0,0,0,0,0,0c-0.3,0-0.5,0-0.8,0c-0.1,0-0.2,0-0.3,0h-0.1c-0.2,0-0.3,0-0.5,0     c-0.1,0-0.2,0-0.3,0c-0.2,0-0.4,0-0.5,0c-9.1,0.4-17.6,2.7-24,6.5c-2.3,1.3-4.3,2.9-5.9,4.5c-0.5,0.5-1,1-1.4,1.6     c-0.1,0.1-0.1,0.1-0.1,0.2c-0.1,0.2-0.3,0.3-0.4,0.5c-1.9,2.5-3.1,5.2-3.5,8.1c-0.2,0.9-0.2,1.7-0.2,2.6l0,0.2c0,0.1,0,0.2,0,0.4     c0,0,0,0,0,0c-1.1-0.1-2.2-0.2-3.2-0.3c-5.4-0.4-10.8-0.6-16.2-0.6c5.4,0.4,10.9,1,16.2,1.7c1.1,0.2,2.2,0.3,3.3,0.5v0     c0,0,0,0,0,0l0,0.3l-0.1,0c0,0.1,0,0.3,0.1,0.4c0.1,0.4,0.1,0.8,0.2,1.1v0c0.6,2.5,1.7,4.9,3.4,7.1c0,0.1,0.1,0.1,0.1,0.2     c0.1,0.2,0.3,0.4,0.4,0.6c0.2,0.3,0.4,0.5,0.7,0.8c-0.2-0.1-0.4-0.1-0.6-0.2c-2.5-0.7-5-1.4-7.5-2.1c-8.9-2.4-17.9-4.3-27-6     c-2.3-0.4-4.5-0.8-6.8-1.1c-13.6-2.1-27.4-3.4-41.1-3.5c13.1,0.9,26,3,38.8,5.8c2.8,0.6,5.6,1.3,8.4,1.9c9,2.3,18,4.9,26.7,7.8     c3.1,1.1,6.2,2.2,9.3,3.3c2.8,1,5.5,2.1,8.2,3.3c0.3,0.1,0.7,0.3,1,0.4c2.9,1.2,5.8,2.5,8.7,3.8c6.5,2.9,12.8,6.1,19,9.6     c12.4,6.9,24.1,14.7,34.9,23.6c0,0,0,0,0,0c0,0,0,0,0,0c2.2,7.6,8.1,14.4,16.7,19.5c2.2,1.3,4.7,2.6,7.3,3.7c0,0,0,0,0,0     c0,0,0,0,0,0c0.3,0.4,0.7,0.8,1,1.1c3.5,4.1,6.9,8.3,10,12.7c3.2,4.4,6.3,9,9.1,13.6l5.7,10c1.8,3.4,3.3,6.9,5,10.4     c0.4,0.8,0.7,1.5,1.1,2.3c0.1,0.2,0.2,0.4,0.2,0.5c0,0,0,0,0,0c0,0,0,0,0,0c-0.5,0.3-1,0.6-1.4,0.9c-2.6,1.7-5,3.5-7.1,5.4     c-7.6,7-11.9,15.6-12.3,25c0,0.3,0,0.6,0,0.8c0,1,0,2,0.1,3h-0.1c0.1,1,0.2,2,0.4,3.1c2.6,14.9,15.4,27.8,34.3,35.8     c1.3,0.5,2.6,1.1,4,1.6h0c0,0,0,0,0,0c0.1,1.8,0.3,3.6,0.4,5.4c0.6,9.5,0.7,19,0.3,28.5h26.1c-0.3-8.1-0.8-16.2-1.7-24.2     c-0.1-1.3-0.3-2.5-0.4-3.8c0,0,0,0,0,0c0,0,0,0,0,0c0.7,0.1,1.4,0.2,2.1,0.3c1.7,0.2,3.5,0.4,5.2,0.5c0.9,0.1,1.8,0.1,2.7,0.2     c0.6,0,1.2,0.1,1.8,0.1c0,0,0,0,0,0c0.2,0,0.4,0,0.5,0.1c0.3,0.1,0.7,0.1,1,0.1c0.2,0,0.4,0,0.5,0h0.1c0.3,0,0.7,0,1,0     c0.2,0,0.4,0,0.6,0c0.4,0,0.7,0,1,0c6,0,12-0.4,17.6-1.3h0c0.3,4.3,0.4,8.6,0.5,13c0.1,5.1,0,10.2-0.1,15.2h26.1     c-0.4-11.5-1.4-23.1-3-34.6l0,0c0,0,0,0,0,0c1.4-0.6,2.7-1.2,4-1.8c0.6-0.3,1.1-0.6,1.7-0.9c0.4-0.2,0.8-0.4,1.2-0.6     c13.7-7.7,21.6-18.7,22.6-31.3c0-0.4,0.1-0.7,0.1-1.1v-0.1c0-0.3,0-0.6,0-0.8C550.4,511.7,550.4,509.7,550.4,509.7z M527.6,490.3     c6.2,4.8,10.5,10.4,12.1,16.3h-14.9c-0.4-3.7-1.3-7.3-2.5-10.8c0,0,0,0,0,0c-1.5-4.2-3.6-8.1-6.2-11.7c-0.3-0.4-0.6-0.8-0.9-1.2     C520,485.1,524.1,487.6,527.6,490.3z M516.7,501.8C516.7,501.8,516.8,501.8,516.7,501.8L516.7,501.8c0.6,1.6,1,3.2,1.3,4.9h-6.5     c0,0,0,0,0,0h-11.9c-0.1-1.2-0.2-2.5-0.3-3.7c0-0.2,0-0.4-0.1-0.6c-0.1-0.9-0.2-1.7-0.3-2.5c0-0.2-0.1-0.5-0.1-0.7     c-0.1-0.4-0.1-0.9-0.2-1.3c0-0.1,0-0.2-0.1-0.3c-0.1-0.4-0.1-0.7-0.2-1.1c0-0.1,0-0.3-0.1-0.4c-0.1-0.4-0.1-0.8-0.2-1.2     c-0.2-0.8-0.3-1.6-0.5-2.4c-0.6-2.5-1.2-4.9-2-7.2c-0.1-0.3-0.2-0.7-0.3-1c0-0.1-0.1-0.2-0.1-0.4c-0.5-1.4-1-2.7-1.6-3.9     c-0.1-0.1-0.1-0.3-0.2-0.4c0,0,0,0,0,0c-0.2-0.5-0.5-1-0.7-1.5c1,0.4,1.9,0.8,2.8,1.3c0.1,0.1,0.3,0.1,0.4,0.2     c0.8,0.4,1.6,0.8,2.4,1.3c0.1,0,0.1,0.1,0.2,0.1c0.1,0,0.1,0.1,0.2,0.1c0.8,0.5,1.6,1,2.4,1.5c0,0,0.1,0.1,0.1,0.1     c0,0,0.1,0,0.1,0.1c0.8,0.6,1.6,1.2,2.4,1.8l0,0h0c0,0,0,0,0,0C509.8,489.1,514.4,495.1,516.7,501.8z M443.8,532.9     c-0.6-0.6-1.2-1.1-1.8-1.7c-0.4-0.4-0.8-0.8-1.2-1.3c0,0,0,0,0,0c0,0,0,0,0,0c-0.3-0.3-0.5-0.6-0.8-0.9c-0.1-0.1-0.2-0.2-0.3-0.4     c-0.3-0.3-0.6-0.7-0.9-1c-0.6-0.7-1.1-1.5-1.6-2.3c0,0,0-0.1-0.1-0.1c-0.2-0.3-0.4-0.6-0.6-0.9c-0.8-1.3-1.6-2.7-2.2-4.1     c0,0,0,0,0,0c0,0,0,0,0,0c-1.1-2.4-1.9-4.9-2.4-7.4h18.4c0,0,0,0.1,0,0.1c0.1,1.1,0.2,2.2,0.3,3.3c0,0.4,0.1,0.8,0.1,1.2     c0,0.2,0,0.3,0,0.5c0,0.4,0.1,0.8,0.1,1.3c0.1,0.5,0.1,0.9,0.2,1.4c0,0.3,0.1,0.6,0.1,0.8c0,0.3,0.1,0.6,0.1,0.9     c0.1,0.4,0.1,0.8,0.2,1.2c0.1,0.3,0.1,0.7,0.2,1c0,0,0,0.1,0,0.1c0.1,0.3,0.1,0.6,0.2,0.9c0.1,0.4,0.1,0.8,0.2,1.1     c0.3,1.2,0.6,2.4,0.9,3.6c0.1,0.6,0.3,1.1,0.5,1.7c0.2,0.6,0.3,1.1,0.5,1.7c0.1,0.4,0.3,0.9,0.4,1.3c0.1,0.3,0.2,0.6,0.3,0.8     c0.1,0.4,0.3,0.8,0.4,1.1c0.1,0.3,0.2,0.5,0.3,0.8c0.1,0.2,0.1,0.3,0.2,0.5c0.1,0.3,0.2,0.6,0.4,0.8c0.1,0.3,0.3,0.7,0.4,1     c0.2,0.5,0.5,1,0.7,1.4c0,0,0,0.1,0,0.1c-3.3-1.4-6.4-3.1-9.2-5.1C446.6,535.2,445.2,534.1,443.8,532.9z M435.3,492.7     C435.3,492.7,435.3,492.7,435.3,492.7c0.4-0.7,0.8-1.3,1.2-1.9c0.1-0.1,0.1-0.2,0.2-0.3c0.4-0.6,0.8-1.2,1.3-1.8     c0.1-0.2,0.3-0.3,0.4-0.5c0.1-0.2,0.3-0.3,0.4-0.5c0.2-0.2,0.4-0.4,0.5-0.6c0.4-0.4,0.7-0.8,1.1-1.2c0.5-0.5,1.1-1.1,1.6-1.5     c0.2-0.2,0.4-0.3,0.5-0.5l0,0c0.2-0.2,0.4-0.3,0.6-0.5c0.4-0.3,0.7-0.6,1.1-0.9c0,0,0,0,0,0c0,0,0,0,0,0c2-1.5,4.1-2.9,6.5-4     c1.8-0.9,3.6-1.7,5.5-2.3c-1,2.1-1.9,4.5-2.7,7c-0.1,0.4-0.2,0.8-0.4,1.2c-1.3,4.6-2.2,9.7-2.6,15.1c0,0.3,0,0.6-0.1,0.8     c-0.1,1.8-0.2,3.6-0.2,5.4c0,0.3,0,0.6,0,0.8h-18.8c0-0.1,0-0.2,0-0.3c0-0.4,0-0.8,0.1-1.1c0-0.3,0-0.5,0.1-0.8v0     c0.2-2.3,0.7-4.5,1.4-6.7C433.6,496,434.4,494.3,435.3,492.7z M453.6,506.6c0.1-5.5,0.9-10.6,2.3-15.2c0.9-2.9,2.1-5.6,3.4-7.9     c3.4-5.9,8.1-9.5,13.4-9.9c0.8,0,1.6,0,2.4,0.1c0.2,0,0.3,0,0.4,0.1c1.2,0.2,2.4,0.5,3.5,1c0.1,0,0.2,0.1,0.3,0.1     c8.4,3.8,15,15.6,16.8,29.7c0.1,0.6,0.2,1.3,0.2,1.9H490c0,0,0,0,0,0H453.6z M467.4,451.8L467.4,451.8l5.4,9.5     c0.2,0.3,0.4,0.7,0.5,1c0,0,0,0,0,0c-0.1,0-0.2,0-0.3,0h-0.1c-0.3,0-0.7,0-1,0c-0.2,0-0.4,0-0.6,0c-0.1,0-0.3,0-0.4,0     c-0.2,0-0.4,0-0.6,0c-9,0-17.7,1-25.7,2.8c-2.6,0.6-5.1,1.3-7.5,2c0,0,0,0,0,0c0,0,0,0,0,0c-0.6-1.2-1.3-2.3-1.9-3.5     c-1.6-2.8-3.1-5.7-4.8-8.6v0L467.4,451.8z M398.3,415.1C398.3,415.1,398.3,415.1,398.3,415.1     C398.3,415.1,398.3,415.1,398.3,415.1c-6.1-4.3-10.3-10.3-11.5-17h13.3c0.2,4.2,0.8,8.2,1.8,11.8c0.7,2.6,1.5,5.1,2.5,7.3     c0.2,0.5,0.5,1.1,0.7,1.6c-1.6-0.7-3.1-1.4-4.5-2.3c0,0,0,0-0.1,0C399.8,416.1,399,415.6,398.3,415.1z M386.5,414.1     c-0.4-0.2-0.8-0.4-1.2-0.7c-0.7-0.4-1.3-0.8-1.9-1.2h0c-0.4-0.3-0.9-0.6-1.3-0.8c-0.1-0.1-0.2-0.1-0.2-0.2     c-0.3-0.2-0.6-0.4-0.9-0.7c-0.1-0.1-0.3-0.2-0.4-0.3c-0.3-0.2-0.5-0.4-0.8-0.6c-0.1-0.1-0.2-0.2-0.3-0.3     c-0.4-0.3-0.7-0.6-1.1-0.9c-0.2-0.1-0.3-0.3-0.5-0.4c-0.2-0.2-0.4-0.3-0.6-0.5c-0.4-0.4-0.8-0.8-1.2-1.2c0,0,0,0,0,0     c-0.1-0.1-0.3-0.3-0.4-0.4c-0.2-0.2-0.3-0.4-0.5-0.5s-0.3-0.4-0.4-0.5c-0.1-0.1-0.1-0.1-0.1-0.2c0,0-0.1-0.1-0.1-0.1     c-0.1-0.1-0.1-0.2-0.2-0.3c-0.1-0.1-0.1-0.2-0.2-0.2c-0.1-0.1-0.2-0.3-0.3-0.4c-0.1-0.1-0.2-0.3-0.3-0.4c0,0,0,0,0-0.1     c-0.1-0.1-0.2-0.3-0.3-0.4c-0.1-0.2-0.2-0.4-0.3-0.6c-0.1-0.2-0.2-0.4-0.3-0.6c-0.3-0.5-0.6-1.1-0.8-1.7     c-0.1-0.1-0.1-0.2-0.1-0.3c-0.1-0.2-0.2-0.4-0.2-0.6c-0.1-0.3-0.2-0.6-0.3-0.9v0h10.7c0.1,1.2,0.3,2.4,0.6,3.6c0,0,0,0,0,0     c0,0,0,0,0,0c0.4,1.9,1,3.8,1.7,5.5c0.1,0.1,0.1,0.3,0.2,0.4c0.1,0.3,0.2,0.5,0.3,0.8c0.7,1.6,1.6,3.2,2.6,4.7     c0.1,0.1,0.1,0.2,0.2,0.3c0,0.1,0.1,0.1,0.1,0.2c0.1,0.1,0.1,0.2,0.2,0.3c0,0,0,0,0,0.1c0.3,0.4,0.6,0.9,0.9,1.3     c-0.4-0.2-0.7-0.3-1-0.5C387.3,414.5,386.9,414.3,386.5,414.1z M380.7,378.5c0.5-0.3,1-0.7,1.5-1c1.1-0.6,2.2-1.2,3.4-1.8     c0,0,0,0,0,0c0,0,0,0,0,0c0.4-0.2,0.8-0.4,1.2-0.5c0.3-0.2,0.7-0.3,1-0.5c-0.1,0.1-0.1,0.2-0.2,0.3c-0.1,0.1-0.1,0.2-0.2,0.3     c0,0.1-0.1,0.1-0.1,0.2c0,0.1-0.1,0.1-0.1,0.2c-0.1,0.1-0.1,0.2-0.1,0.2c-0.1,0.1-0.2,0.3-0.3,0.4c0,0,0,0,0,0l0,0     c-0.1,0.2-0.3,0.4-0.4,0.6c-0.7,1.2-1.4,2.4-1.9,3.7c-0.4,0.9-0.7,1.8-1,2.7c-0.8,2.4-1.3,4.9-1.6,7.4c-0.1,1-0.2,1.9-0.2,2.9     h-11.1v-0.2c0-0.3,0-0.6,0.1-0.9c0-0.1,0-0.2,0-0.4c0-0.2,0.1-0.4,0.1-0.6c0-0.1,0-0.3,0.1-0.4c0.5-2.4,1.5-4.6,3.1-6.6     C375.7,382.3,378,380.3,380.7,378.5z M402.5,398.1h30.9v0.2c0,1-0.1,2.1-0.2,3c0,0.1,0,0.1,0,0.2v0c0,0.1,0,0.2,0,0.2     c-0.2,2.7-0.7,5.1-1.4,7.4c-0.7,2.2-1.6,4.3-2.7,6c-2.4,4-5.8,6.5-9.5,6.7c-0.6,0-1.1,0-1.7,0h0c-0.1,0-0.2,0-0.3-0.1     C409.9,420.6,403.7,410.4,402.5,398.1z M432.2,418.4c0.5-1.2,1-2.5,1.3-3.9c0.3-0.8,0.5-1.7,0.7-2.6c0.6-2.5,1-5.1,1.2-7.8     c0-0.2,0-0.4,0.1-0.5v-0.1c0.1-1.5,0.2-3.1,0.2-4.8c0-0.2,0-0.4,0-0.6h13.6c0,0.1,0,0.1,0,0.2c0,0.1,0,0.2,0,0.2     c-0.2,4.9-2,9.3-5,12.9c-0.2,0.3-0.5,0.6-0.7,0.8c-0.1,0.1-0.2,0.2-0.3,0.3c-1.5,1.6-3.1,3-5,4.2c-1.6,1.1-3.3,2-5.2,2.7     c-0.6,0.2-1.1,0.4-1.7,0.6C431.7,419.6,431.9,419,432.2,418.4z M465.1,398.4c-0.2,4-2,7.8-5.2,11c-1.2,1.3-2.7,2.5-4.3,3.6     c-0.6,0.4-1.3,0.9-2,1.3c0,0,0,0,0,0c-0.7,0.4-1.4,0.8-2.1,1.1c0,0,0,0,0,0c-0.3,0.2-0.6,0.3-0.9,0.4c-0.4,0.2-0.9,0.4-1.3,0.6     c-0.5,0.2-0.9,0.4-1.4,0.6c0.1-0.1,0.1-0.2,0.2-0.3c0.2-0.3,0.4-0.6,0.6-0.9c0.4-0.6,0.8-1.3,1.2-2c1-1.7,1.7-3.6,2.4-5.5     c0.6-1.8,1-3.7,1.3-5.6c0.3-1.5,0.4-3.1,0.4-4.7h11.1C465.2,398.2,465.1,398.3,465.1,398.4z M464.7,393.7h-10.7     c-0.6-5.6-2.6-10.9-5.7-15.4c-0.4-0.6-0.8-1.1-1.2-1.7C456.3,381,462.8,387,464.7,393.7z M449,393.7h-13.3     c-0.2-2.6-0.4-5.1-0.8-7.5c-0.8-4.3-1.9-8.3-3.4-11.7c-0.2-0.5-0.5-1.1-0.7-1.6C440.3,377.1,447.3,384.9,449,393.7z M404.6,381.2     c0.3-0.8,0.7-1.6,1-2.4c0.3-0.6,0.6-1.2,0.9-1.7c0.1-0.1,0.2-0.3,0.3-0.4c1.6-2.6,3.6-4.6,5.8-5.7c1.2-0.6,2.4-0.9,3.6-1     c0.6,0,1.1,0,1.7,0.1h0c0.1,0,0.2,0,0.3,0c5.3,0.8,9.9,6,12.7,13.2c1.2,3.2,2,6.7,2.4,10.5h-30.8c0-0.4,0-0.8,0-1.3     c0.2-4.1,0.9-7.9,2.1-11.1C404.6,381.3,404.6,381.2,404.6,381.2z M402.1,372.6c0.8-0.3,1.5-0.6,2.3-0.9c-0.3,0.7-0.6,1.4-0.9,2.1     c-0.1,0.4-0.3,0.7-0.4,1.1c0,0.1-0.1,0.2-0.1,0.3c-0.1,0.3-0.2,0.5-0.3,0.8c-0.1,0.2-0.1,0.4-0.2,0.6c-0.1,0.2-0.1,0.5-0.2,0.7     c-0.1,0.4-0.3,0.8-0.4,1.3c-0.1,0.3-0.2,0.7-0.2,1c-0.8,3.4-1.3,7.2-1.5,11.2v0c0,0.8-0.1,1.5-0.1,2.3v0.6h-13.6     c0-0.1,0-0.1,0-0.2c0.1-3.6,1.1-6.9,2.7-9.9c0.3-0.5,0.6-1,0.9-1.4c1.5-2.2,3.4-4.2,5.6-5.9c0.4-0.4,0.9-0.7,1.4-1     c0.1-0.1,0.3-0.2,0.4-0.3c0,0,0.1,0,0.1-0.1c0,0,0.1-0.1,0.1-0.1c0.3-0.2,0.7-0.4,1-0.6c0.4-0.2,0.8-0.5,1.3-0.7     c0.1,0,0.1-0.1,0.2-0.1C400.8,373.1,401.4,372.9,402.1,372.6z M296.2,344.8L296.2,344.8L296.2,344.8c0.1,0,0.2,0,0.3,0.1     c0,0,0,0,0-0.1c0,0,0,0,0,0l0,0l1.8-0.1l0.3,0l1-0.1l0.4,0l0.6,0l0.2,0c0,0,0,0,0,0c0,0,0,0,0,0c0,0,0,0,0,0.1c0,0,0,0,0,0     c0.1,0.9,0.3,1.7,0.6,2.5v0c0.7,2.6,1.9,5,3.4,7.3c0.5,0.7,1,1.4,1.6,2.1c0,0,0,0-0.1,0c0,0,0,0,0,0c-3.5-1.5-6.5-3.3-8.8-5.4     c-0.7-0.6-1.3-1.3-1.9-1.9c-0.1-0.1-0.1-0.1-0.1-0.2c-0.1-0.2-0.3-0.4-0.4-0.6c0-0.1-0.1-0.1-0.1-0.2c-0.5-0.7-1-1.5-1.3-2.2l0,0     c-0.1-0.3-0.3-0.5-0.4-0.9c-0.1-0.1-0.1-0.2-0.1-0.3L296.2,344.8z M314.2,347.1c0,0.1,0,0.2,0.1,0.3c0.2,1.3,0.5,2.6,0.8,3.8     c0.1,0.3,0.2,0.6,0.3,0.9c0.7,2.4,1.6,4.6,2.6,6.5c0,0,0,0.1,0.1,0.1c-0.3-0.1-0.7-0.3-1-0.4h0c-3.9-1.6-7.1-4.1-9.4-7.1     c-0.7-0.9-1.3-1.8-1.8-2.7c-0.3-0.6-0.6-1.2-0.8-1.8c-0.2-0.4-0.3-0.9-0.5-1.3v0c-0.1-0.3-0.2-0.6-0.3-0.9l9.6-0.4v0     C313.9,345.1,314.1,346.1,314.2,347.1z M321.4,357.3c0-0.1-0.1-0.1-0.1-0.2c-0.8-0.9-1.5-1.8-2.2-3c-0.3-0.6-0.7-1.2-1-1.8     c0,0,0,0,0-0.1c0-0.1-0.1-0.1-0.1-0.2c-0.6-1.3-1.1-2.7-1.6-4.2c0-0.1-0.1-0.2-0.1-0.4c-0.3-1.2-0.6-2.4-0.7-3.6l0.6,0l12.1-0.5     l4.8-0.2l3.9-0.2l0.7,0l0,0.2c0.1,1.6,0,3.1-0.2,4.5c-0.2,1.6-0.5,3.1-1,4.5c-0.1,0.4-0.2,0.7-0.4,1c0,0.1-0.1,0.1-0.1,0.2     c-0.1,0.3-0.3,0.7-0.4,1c-0.6,1.2-1.3,2.4-2.1,3.2c-1.2,1.4-2.6,2.3-4.1,2.7c-0.1,0-0.1,0-0.2,0.1c0,0,0,0,0,0h0     c-0.3,0.1-0.5,0.1-0.7,0.1c-0.4,0-0.8,0-1.2,0c-0.1,0-0.2,0-0.3,0C325,360.2,323.1,359.1,321.4,357.3z M338.1,355.7     c0-0.1,0.1-0.2,0.1-0.3c0.1-0.5,0.3-1,0.4-1.5c0-0.1,0-0.2,0.1-0.2c0-0.1,0-0.2,0.1-0.2c0-0.1,0-0.2,0.1-0.3     c0.2-1.1,0.4-2.2,0.5-3.3c0.1-0.5,0.1-1,0.1-1.5c0.1-1.7,0.2-3.4,0.1-5.2l0-0.4l0.3,0l6.5-0.3l1.5-0.1l1.5-0.1c0,0.1,0,0.1,0,0.2     c0,1.4-0.1,2.7-0.5,4c-0.5,1.9-1.3,3.7-2.4,5.3c-0.9,1.2-1.9,2.4-3.2,3.4c0,0,0,0,0,0c-0.1,0.1-0.1,0.1-0.2,0.2c0,0,0,0-0.1,0.1     c0,0,0,0,0,0c0,0,0,0,0,0c0,0,0,0,0,0c0,0-0.1,0-0.1,0.1c0,0,0,0,0,0c-0.4,0.3-0.9,0.7-1.3,1h0c-0.3,0.2-0.6,0.4-1,0.6     c-1,0.6-2.1,1.2-3.3,1.6C337.4,357.8,337.8,356.8,338.1,355.7z M360.5,342c0,3-1.2,5.8-3.5,8.3c-1.3,1.5-3,2.8-4.9,4     c-0.2,0.1-0.4,0.3-0.6,0.4c-0.3,0.2-0.5,0.3-0.8,0.5c-0.6,0.3-1.3,0.7-1.9,1v0c0.2-0.2,0.3-0.5,0.4-0.7c0-0.1,0.1-0.1,0.1-0.2     c0.1-0.1,0.1-0.2,0.2-0.3c0,0,0,0,0,0c0.2-0.3,0.4-0.7,0.5-1c0-0.1,0.1-0.1,0.1-0.1c0.4-0.8,0.7-1.6,1-2.5c0.4-1,0.6-2.1,0.9-3.2     c0.4-1.9,0.6-3.8,0.5-5.8l5.6-0.3l2.4-0.1C360.5,341.9,360.5,342,360.5,342z M355.7,332.4c0.1,0,0.1,0.1,0.2,0.2     c2,1.8,3.4,3.9,4.1,6.1l-7.7,0.3c0,0,0-0.1,0-0.1c-0.1-0.8-0.3-1.6-0.5-2.4c-1-3.6-2.7-6.8-5-9.6     C350.3,328.5,353.4,330.3,355.7,332.4z M335.7,325.3c4,1.6,7.3,4.1,9.7,7.2c1.6,2,2.7,4.3,3.3,6.8l-2,0.1l-1.9,0.1l-5.1,0.2     l-0.5,0c-0.6-5.7-2.1-10.8-4.2-14.6c0,0,0-0.1-0.1-0.1C335.2,325,335.5,325.1,335.7,325.3z M324.5,323.2l1.2,0l0.2,0     c2.2,0.2,4.2,1.5,6,3.4c0,0,0.1,0.1,0.1,0.1c0.4,0.5,0.8,1,1.2,1.5c0.5,0.7,1,1.5,1.5,2.4c0,0,0,0,0,0c1.3,2.6,2.4,5.7,2.8,9.1     l-0.5,0l-3.9,0.2l-0.9,0l-10.7,0.5l-5.4,0.3l-0.7,0c0-0.9,0-1.8,0-2.7c0.1-1.3,0.2-2.4,0.4-3.6c0.4-2.2,1.1-4.2,1.9-5.8     C319.4,325.5,321.7,323.5,324.5,323.2z M304.7,335.8c0.2-0.5,0.3-0.9,0.6-1.4c0.4-0.9,0.9-1.7,1.5-2.5c2.1-3.1,5.3-5.5,9.2-7     c-0.3,0.6-0.5,1.2-0.7,1.8c-0.1,0.2-0.1,0.4-0.2,0.6c-0.1,0.2-0.1,0.4-0.2,0.5c-0.5,1.8-0.9,3.8-1.1,6c-0.1,1.1-0.2,2.3-0.2,3.5     c0,0.8,0,1.7,0,2.5c0,0.1,0,0.3,0,0.5l0,0.4l-8.2,0.4l-1.5,0.1l0-0.2c0-0.7,0-1.4,0.1-2.1c0-0.1,0-0.3,0.1-0.4     c0.1-0.6,0.2-1.1,0.3-1.7C304.5,336.5,304.6,336.2,304.7,335.8z M292.5,341.6c0-0.3,0-0.5,0-0.8c0.2-2.8,1.5-5.5,3.8-7.8     c0.2-0.2,0.4-0.4,0.6-0.7c0.2-0.2,0.4-0.4,0.6-0.5c0.7-0.6,1.5-1.2,2.3-1.8c1.3-0.9,2.8-1.7,4.4-2.5c-0.7,1-1.2,2.1-1.7,3.2     c-0.3,0.6-0.5,1.1-0.7,1.7c-0.1,0.2-0.2,0.4-0.2,0.6c-0.1,0.4-0.2,0.7-0.3,1.1c-0.1,0.3-0.2,0.7-0.2,1c-0.4,2-0.6,4.1-0.6,6.1     l-5.5,0.3l-0.5,0l-1.9,0.1V341.6z M335.5,370.4c-2.9-1.4-5.9-2.8-8.9-4.1h0.1c0.3,0,0.6,0,0.9,0h0c0.3,0,0.6,0,0.8,0     c0.1,0,0.2,0,0.3,0h0.1c0.2,0,0.3,0,0.5,0c0.1,0,0.2,0,0.3,0c0.2,0,0.4,0,0.5,0c2.5-0.1,4.9-0.4,7.2-0.7c3.5-0.6,6.8-1.4,9.8-2.5     c0.5-0.2,0.9-0.3,1.4-0.5c1.1-0.4,2.2-0.9,3.2-1.4c0.3-0.1,0.6-0.3,0.8-0.4c0,0,0,0,0,0c2.6,1,5.2,2,7.8,3.1     c3.3,1.4,6.5,2.8,9.7,4.3l-33.6,3C336.2,370.7,335.8,370.6,335.5,370.4z M346.2,375.9l28.2-2.5l0,0c-0.3,0.2-0.6,0.5-0.9,0.7l0,0     c-0.1,0.1-0.2,0.1-0.3,0.2c-2.1,1.8-3.8,3.7-5.3,5.8c-1.4,2-2.5,4.2-3.2,6.4c0,0.1-0.1,0.2-0.1,0.3c0,0,0,0,0,0     c-4.7-3.1-9.4-6-14.3-8.7C349,377.4,347.6,376.6,346.2,375.9z M412.3,429.7C412.3,429.7,412.3,429.7,412.3,429.7L412.3,429.7     c1.4,0.1,2.8,0.2,4.2,0.3c0.4,0,0.9,0,1.3,0c0,0,0,0,0,0c0.2,0,0.3,0,0.4,0c0.2,0,0.4,0,0.7,0c0.1,0,0.3,0,0.4,0h0.1     c0.2,0,0.5,0,0.7,0c0.1,0,0.3,0,0.5,0c0.2,0,0.5,0,0.7,0c6.7,0,13.2-0.8,19.2-2.2c0.9-0.2,1.8-0.4,2.7-0.7h0c1-0.3,2-0.6,3-0.9     c0.7-0.3,1.5-0.5,2.2-0.8h0c0,0,0,0,0,0c0.5,0.5,0.9,1.1,1.4,1.7h0c0.2,0.2,0.4,0.5,0.6,0.7c3.4,4.1,6.6,8.3,9.6,12.6     c0,0,0,0,0,0l-37,3.3l0,0l-1-1.5c-0.3-0.4-0.6-0.9-1-1.3C418.3,437.1,415.4,433.4,412.3,429.7z M409.6,506.3     c0.2-5.4,2.6-10.4,6.7-14.8c2-2.2,4.5-4.2,7.4-6.1c0.8-0.5,1.6-1,2.5-1.5c0.8-0.5,1.7-0.9,2.5-1.3c0.2-0.1,0.4-0.2,0.7-0.3     c0.7-0.3,1.3-0.6,2-1c0.7-0.3,1.4-0.6,2.2-1c-0.3,0.4-0.6,0.8-0.8,1.2c-0.1,0.2-0.2,0.3-0.3,0.5c-0.2,0.2-0.3,0.5-0.5,0.7     c0,0,0,0,0,0.1c0,0.1-0.1,0.1-0.1,0.2c-0.2,0.3-0.4,0.6-0.5,0.8c-0.1,0.2-0.2,0.4-0.3,0.7c-0.2,0.4-0.4,0.7-0.6,1.1     c-0.1,0.2-0.2,0.4-0.3,0.6c-0.1,0.2-0.2,0.4-0.3,0.6c-0.2,0.4-0.4,0.9-0.6,1.3c-0.1,0.2-0.2,0.3-0.2,0.5     c-0.1,0.2-0.1,0.3-0.2,0.5c-0.2,0.5-0.4,1-0.6,1.5c-0.1,0.2-0.1,0.4-0.2,0.6c0,0,0,0,0,0c-0.1,0.3-0.2,0.7-0.4,1.1     c0,0.1-0.1,0.2-0.1,0.2c0,0,0,0,0,0c-0.1,0.3-0.2,0.5-0.2,0.8c-1.3,4.3-2,8.8-2.2,13.4h-15.3     C409.6,506.5,409.6,506.4,409.6,506.3z M430.6,534.3c-10.7-5.8-18.1-13.4-20.4-21.6h14.9c0.9,8.3,4,15.9,8.7,22.5     c0.3,0.4,0.6,0.8,0.9,1.2C433.3,535.7,431.9,535.1,430.6,534.3z M477.3,545.6c-0.4,0-0.9,0-1.4,0h0c-0.2,0-0.5,0-0.7,0     c-0.1,0-0.2,0-0.3,0h0c-0.2,0-0.3,0-0.4-0.1c-2-0.3-4-1.1-5.9-2.3c-3.6-2.3-6.9-6.1-9.4-11c0,0,0,0,0,0     c-5.1-14.9-4.3-18.5-4.6-19.5h41.8v0.3c0,0.5,0,1,0,1.6c0,0.4,0,0.8-0.1,1.2c0,0.1,0,0.2,0,0.3c0,0,0,0,0,0c0,0,0,0,0,0     c0,0.3,0,0.6-0.1,0.9c-0.1,0.9-0.2,1.7-0.3,2.5c0,0.3-0.1,0.6-0.1,0.9c-0.1,0.5-0.1,0.9-0.2,1.4c0,0.1,0,0.2,0,0.2c0,0,0,0,0,0.1     c0,0.3-0.1,0.5-0.1,0.8c0,0.1,0,0.1,0,0.2c0,0.1,0,0.2-0.1,0.3c0,0,0,0,0,0.1c-0.1,0.3-0.1,0.6-0.2,1c0,0,0,0,0,0c0,0,0,0,0,0     l0,0v0c0,0,0,0.1,0,0.1c-0.2,0.9-0.4,1.7-0.7,2.5c0,0.1-0.1,0.2-0.1,0.3c0,0,0,0,0,0C491.2,538.1,484.8,545.2,477.3,545.6z      M493.7,543.2c0.8-1.6,1.4-3.2,2.1-5c0,0,0,0,0,0c0,0,0-0.1,0-0.1c0.1-0.3,0.2-0.6,0.3-1c0.1-0.3,0.2-0.6,0.3-0.9     c0,0,0-0.1,0-0.1c0.1-0.3,0.1-0.5,0.2-0.8c0.1-0.4,0.2-0.8,0.3-1.2c0.1-0.5,0.3-1,0.4-1.6c0-0.2,0.1-0.4,0.1-0.6c0,0,0-0.1,0-0.1     c0.2-0.7,0.3-1.4,0.5-2.1c0.2-0.7,0.3-1.5,0.4-2.3s0.3-1.6,0.4-2.3s0.2-1.6,0.3-2.4c0-0.3,0.1-0.6,0.1-0.9c0-0.1,0-0.2,0-0.4     c0-0.4,0.1-0.8,0.1-1.2l0-0.1v-0.1c0-0.1,0-0.2,0-0.3c0-0.2,0-0.5,0-0.7c0-0.1,0-0.1,0-0.2c0-0.2,0-0.3,0-0.5c0-0.1,0-0.2,0-0.4     c0-0.2,0-0.4,0-0.5c0-0.6,0.1-1.2,0.1-1.8c0-0.7,0-1.4,0.1-2.1c0-0.3,0-0.5,0-0.8h18.8c0,0.1,0,0.2,0,0.3     c-0.1,3.7-0.9,7.2-2.2,10.5c0,0.1-0.1,0.2-0.2,0.3v0c-0.2,0.4-0.4,0.9-0.6,1.3c-0.8,1.6-1.7,3.2-2.8,4.7     c-0.2,0.3-0.4,0.6-0.7,0.9c-0.3,0.3-0.5,0.7-0.8,1c-0.1,0.1-0.2,0.2-0.3,0.3c-0.3,0.4-0.7,0.8-1,1.1c-0.1,0.1-0.2,0.2-0.3,0.3     c-0.3,0.3-0.5,0.5-0.8,0.8h0c-1.1,1.1-2.4,2.1-3.7,3c-0.6,0.4-1.2,0.9-1.9,1.3c-0.4,0.3-0.9,0.6-1.4,0.8c-1.7,1-3.6,1.9-5.5,2.7     C495.4,542.6,494.6,542.9,493.7,543.2z M540.4,513c-0.3,8.3-5.8,15.6-14.6,21.3c-1.4,0.9-2.9,1.7-4.4,2.5     c-0.8,0.4-1.6,0.8-2.4,1.2c0,0,0,0,0,0c0,0,0,0,0,0c-0.8,0.4-1.6,0.7-2.4,1c0.4-0.5,0.8-1.1,1.2-1.7c0.3-0.4,0.6-0.9,0.8-1.4     c0,0,0,0,0,0c0,0,0,0,0,0c0,0,0,0,0,0c0.5-0.9,1-1.8,1.5-2.7c0.8-1.7,1.6-3.4,2.2-5.2c0.5-1.5,1-3,1.4-4.6     c0.9-3.5,1.4-7.2,1.5-10.8h15.3C540.4,512.8,540.4,512.9,540.4,513z"/>
        		</g>
        		<g>
        			<path class="st2" d="M389.8,289.4L389.8,289.4l-29.4,29.4c0,0,0,0-0.1,0c0,0,0,0,0,0c-1.9-1.4-4-2.6-6.2-3.6     c-0.3-0.2-0.7-0.3-1-0.5c0,0-0.1,0-0.1-0.1c0,0-0.1,0-0.1,0c-0.1,0-0.2-0.1-0.2-0.1c-0.1,0-0.1,0-0.2-0.1c-2.5-1.1-5.2-2-8-2.8     l58-58l11.5,11.5L389.8,289.4z"/>
        			<path class="st2" d="M569.6,432.7L532,470.3c-4.6-2.9-9.8-5.5-15.4-7.7l35.8-35.8L405.9,280.3l11.6-11.6l152.1,152.1     C572.9,424.1,572.9,429.4,569.6,432.7z"/>
        			<path class="st2" d="M398.9,573.2l-11.6,11.6L235.3,432.7c-3.3-3.3-3.3-8.6,0-11.8l53.6-53.6c0,0,0,0,0,0     c2.9,1.1,5.8,2.2,8.7,3.4c0.1,0,0.2,0.1,0.3,0.1c0.2,0.1,0.4,0.2,0.6,0.2c0,0,0.1,0,0.1,0.1c2.1,0.8,4.2,1.8,6.7,2.9l-52.8,52.8     L398.9,573.2z"/>
        			<path class="st2" d="M431.2,571.1l-28.8,28.8l-11.6-11.6l35-34.9c1.6,0.8,3.2,1.5,4.9,2.2c0,0,0,0,0,0     C431,560.6,431.2,565.8,431.2,571.1z"/>
        		</g>
        	</g>
        </g>
        </svg>
    </xsl:variable>
    -->
    <xsl:variable name="logo-data-uri">
        <xsl:text>url('data:image/png;base64,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')</xsl:text>
    </xsl:variable>


</xsl:stylesheet>