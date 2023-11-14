<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:decimal-format decimal-separator=","
                        grouping-separator=" "/>

    <xsl:variable name="debug-border">
        <xsl:if test="$debug">0.5pt solid red</xsl:if>
    </xsl:variable>

    <xsl:variable name="currencies">
        <currency code="CZK">
            <symbol>Kč</symbol>
            <text>KorunČeských</text>
        </currency>
        <currency code="EUR">
            <symbol>€</symbol>
            <text>Euro</text>
        </currency>
    </xsl:variable>

    <xsl:variable name="documentTypes">
        <documentType name="prijmovyPokladniDoklad">
            <title>Příjmový pokladní doklad</title>
            <druhaStrana>Přijato od</druhaStrana>
        </documentType>
        <documentType name="vydajovyPokladniDoklad">
            <title>Výdajový pokladní doklad</title>
            <druhaStrana>Vyplaceno (komu)</druhaStrana>
        </documentType>
    </xsl:variable>

    <xsl:variable name="editable-field-border">0.5pt dotted black</xsl:variable>
    <xsl:variable name="editable-field-background">white</xsl:variable>
    <xsl:variable name="price-field-background">#D3D3D3</xsl:variable>

</xsl:stylesheet>
