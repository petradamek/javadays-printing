<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:dok="http://www.bilysklep.cz/doklady"
                xmlns:x="http://www.bilysklep.cz/localStylesheetExtensions"
                xmlns:fox="http://xmlgraphics.apache.org/fop/extensions">

    <xsl:import href="functions.xsl"/>
    <xsl:import href="pokladniDoklad.xsl"/>
    <xsl:import href="settings.xsl"/>

    <xsl:output method="xml"/>

    <xsl:param name="debug" select="false()"/>

    <xsl:template match="/">

        <fo:root font-family="Arial, Helvetica, sans-serif" font-size="10pt"
                 language="cs" hyphenate="true">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="pageMaster" page-height="210mm"
                                       page-width="148mm" margin="0">
                    <fo:region-body/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <xsl:apply-templates/>
        </fo:root>
    </xsl:template>

    <xsl:template match="dok:prijmovyPokladniDoklad|dok:vydajovyPokladniDoklad">
        <fo:page-sequence master-reference="pageMaster" force-page-count="no-force">
            <fo:flow flow-name="xsl-region-body">
                <fo:block-container height="105mm" width="148mm" top="0mm"
                                    background-color="#FCF2D1" position="absolute">
                    <xsl:call-template name="pokladniDoklad" />
                </fo:block-container>
                <fo:block-container height="105mm" width="148mm" top="105mm"
                                    border-top="0.25pt dotted black"
                                    background-color="#FCF2D1" position="absolute">
                    <xsl:call-template name="pokladniDoklad"/>
                </fo:block-container>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

</xsl:stylesheet>
