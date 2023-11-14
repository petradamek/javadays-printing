<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:dok="http://www.bilysklep.cz/doklady"
                xmlns:x="http://www.bilysklep.cz/localStylesheetExtensions"
                xmlns:fox="http://xmlgraphics.apache.org/fop/extensions">

    <xsl:import href="functions.xsl"/>

    <xsl:template name="pokladniDoklad">
        <xsl:variable name="currency" select="$currencies/currency[@code=current()/dok:cena/dok:mena]"/>
        <xsl:variable name="documentType" select="$documentTypes/documentType[@name=current()/local-name()]"/>

        <!--********************************************************
        * Header line                                              *
        *********************************************************-->
        <fo:block-container border="{$debug-border}" start-indent="0" end-indent="0"
                            left="10mm" top="10mm" position="absolute"
                            width="128mm" height="5mm">

            <fo:block-container position="absolute" left="61mm" width="26mm" height="5mm"
                                background-color="{$editable-field-background}"
                                border-bottom="{$editable-field-border}">
                <fo:block/>
            </fo:block-container>

            <fo:block-container position="absolute" left="102mm" width="26mm" height="5mm"
                                background-color="{$editable-field-background}"
                                border-bottom="{$editable-field-border}">
                <fo:block/>
            </fo:block-container>

            <fo:block>
                <fo:inline-container width="61mm">
                    <fo:block>
                        <fo:inline font-size="14pt">
                            <xsl:value-of select="$documentType/title"/>
                        </fo:inline>
                        č.
                    </fo:block>
                </fo:inline-container>
                <fo:inline-container width="26mm">
                    <fo:block text-align="center">
                        <xsl:value-of select="dok:cislo"/>
                    </fo:block>
                </fo:inline-container>
                <fo:inline-container width="15mm">
                    <fo:block text-align="center">
                        ze dne
                    </fo:block>
                </fo:inline-container>
                <fo:inline-container width="26mm">
                    <fo:block text-align="right" margin-right="1em">
                        <xsl:value-of select="format-date(dok:datum, '[D]. [M]. [Y]')"/>
                    </fo:block>
                </fo:inline-container>
            </fo:block>
        </fo:block-container>

        <!--********************************************************
        * Issuer                                                   *
        *********************************************************-->
        <fo:block-container start-indent="0" end-indent="0"
                            left="10mm" top="16mm" position="absolute"
                            width="64mm" height="28mm"
                            fox:border-radius="5pt" border="0.5pt solid black"
                            background-color="{$editable-field-background}">
            <fo:block-container left="2mm" top="2mm" position="absolute">
                <fo:block>
                    <xsl:value-of select="dok:dokladVystavil/dok:jmeno"/>
                </fo:block>
                <fo:block>
                    <xsl:value-of select="x:commaToBreak(dok:dokladVystavil/dok:adresa)"/>
                </fo:block>
            </fo:block-container>
            <fo:block-container left="2mm" top="23mm" position="absolute">
                <fo:table>
                    <fo:table-body>
                        <fo:table-row>
                            <xsl:if test="dok:dokladVystavil/dok:ic">
                                <fo:table-cell>
                                    <fo:block>
                                        IČ:
                                        <xsl:value-of select="dok:dokladVystavil/dok:ic"/>
                                    </fo:block>
                                </fo:table-cell>
                            </xsl:if>
                            <xsl:if test="dok:dokladVystavil/dok:dic">
                                <fo:table-cell>
                                    <fo:block>
                                        DIČ:
                                        <xsl:value-of select="dok:dokladVystavil/dok:dic"/>
                                    </fo:block>
                                </fo:table-cell>
                            </xsl:if>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:block-container>
        </fo:block-container>

        <!--********************************************************
        * Price                                     *
        *********************************************************-->
        <xsl:if test="dok:cena/dok:bezDph">
            <fo:block-container border="{$debug-border}" start-indent="0" end-indent="0"
                                left="78mm" top="20mm" position="absolute"
                                width="60mm" height="6mm"
                                display-align="center">

                <fo:block-container left="0" top="0" position="absolute" width="24mm" height="6mm">
                    <fo:block text-align="right">Cena bez DPH</fo:block>
                </fo:block-container>

                <fo:block-container left="26mm" top="0mm" height="6mm" position="absolute"
                                    background-color="{$price-field-background}">
                    <fo:block text-align="right" margin-right="1em">
                        <xsl:value-of select="format-number(dok:cena/dok:bezDph,'# ##0')"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$currency/symbol"/>
                    </fo:block>
                </fo:block-container>
            </fo:block-container>
        </xsl:if>

        <xsl:if test="dok:cena/dok:dph">
            <fo:block-container border="{$debug-border}" start-indent="0" end-indent="0"
                                left="78mm" top="28mm" position="absolute"
                                width="60mm" height="6mm"
                                display-align="center">

                <fo:block-container left="0" top="0" position="absolute" width="24mm" height="6mm">
                    <fo:block text-align="right">
                        <xsl:if test="dok:cena/dok:dphSazba">
                            <xsl:value-of select="dok:cena/dok:dphSazba"/>
                            %
                        </xsl:if>
                        DPH
                    </fo:block>
                </fo:block-container>

                <fo:block-container left="26mm" top="0mm" height="6mm" position="absolute"
                                    background-color="{$price-field-background}">
                    <fo:block text-align="right" margin-right="1em">
                        <xsl:value-of select="format-number(dok:cena/dok:dph, '# ##0')"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$currency/symbol"/>
                    </fo:block>
                </fo:block-container>
            </fo:block-container>
        </xsl:if>

        <fo:block-container border="{$debug-border}" start-indent="0" end-indent="0"
                            left="78mm" top="36mm" position="absolute"
                            width="60mm" height="6mm"
                            display-align="center">

            <fo:block-container left="0" top="0" position="absolute" width="24mm" height="6mm">
                <fo:block text-align="right">Celkem</fo:block>
            </fo:block-container>

            <fo:block-container left="26mm" top="0mm" height="6mm" position="absolute"
                                background-color="{$price-field-background}"
                                border="solid blact 0.5pt">
                <fo:block text-align="right" margin-right="1em">
                    <xsl:value-of select="format-number(dok:cena/dok:vcetneDph, '# ##0')"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$currency/symbol"/>
                </fo:block>
            </fo:block-container>
        </fo:block-container>

        <!--********************************************************
        * Price by words                                           *
        *********************************************************-->
        <fo:block-container border="{$debug-border}" start-indent="0" end-indent="0"
                            left="10mm" top="46mm" position="absolute"
                            width="128mm" height="6mm"
                            display-align="center">

            <fo:block-container left="0" top="0" position="absolute" width="18mm" height="6mm">
                <fo:block text-align="left">Slovy</fo:block>
            </fo:block-container>

            <fo:block-container left="20mm" height="6mm" position="absolute"
                                background-color="{$price-field-background}">
                <fo:block text-align="left" margin-left="1mm" margin-right="1mm" text-align-last="justify">
                    <xsl:value-of select="x:toWord(dok:cena/dok:vcetneDph)"/>
                    <xsl:value-of select="$currency/text"/>
                    <fo:leader leader-pattern="use-content">~</fo:leader>
                </fo:block>
            </fo:block-container>
        </fo:block-container>

        <!--********************************************************
        * Other party                                              *
        *********************************************************-->
        <fo:block-container border="{$debug-border}" start-indent="0" end-indent="0"
                            left="10mm" top="54mm" position="absolute"
                            width="128mm" height="12mm">

            <fo:block-container left="0" top="0" position="absolute"
                                width="18mm" height="10mm">
                <fo:block text-align="left" margin-top="1mm">
                    <xsl:value-of select="$documentType/druhaStrana"/>
                </fo:block>
            </fo:block-container>

            <fo:block-container left="20mm" top="0mm" position="absolute"
                                height="10mm"
                                background-color="{$editable-field-background}">
                <fo:block text-align="left" margin-left="1mm" margin-right="1mm" margin-top="1mm">
                    <fo:block>
                        <xsl:value-of select="dok:druhaStrana/dok:jmeno"/>
                        <xsl:if test="dok:druhaStrana/dok:adresa">
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="dok:druhaStrana/dok:adresa"/>
                        </xsl:if>
                        <xsl:if test="dok:druhaStrana/dok:ic">
                            <xsl:text>, IČ:&#160;</xsl:text>
                            <xsl:value-of select="dok:druhaStrana/dok:ic"/>
                        </xsl:if>
                        <xsl:if test="dok:druhaStrana/dok:dic">
                            <xsl:text>, DIČ:&#160;</xsl:text>
                            <xsl:value-of select="dok:druhaStrana/dok:dic"/>
                        </xsl:if>
                    </fo:block>
                </fo:block>
            </fo:block-container>
        </fo:block-container>

        <!--********************************************************
        * Reason                                                   *
        *********************************************************-->
        <fo:block-container border="{$debug-border}" start-indent="0" end-indent="0"
                            left="10mm" top="66mm" position="absolute"
                            width="128mm" height="10mm">

            <fo:block-container left="0" top="0" position="absolute"
                                width="18mm" height="10mm">
                <fo:block text-align="left" margin-top="1mm">
                    Účel platby
                </fo:block>
            </fo:block-container>

            <fo:block-container left="20mm" top="0mm" position="absolute"
                                height="10mm"
                                background-color="{$editable-field-background}">
                <fo:block text-align="left" margin-left="1mm" margin-right="1mm" margin-top="1mm">
                    <fo:block>
                        <xsl:value-of select="dok:ucel"/>
                    </fo:block>
                </fo:block>
            </fo:block-container>
        </fo:block-container>

        <!--********************************************************
        * Signatures                                               *
        *********************************************************-->
        <fo:block-container start-indent="0" end-indent="0"
                            left="0mm" top="95mm" position="absolute" height="6mm">
            <fo:block-container
                    left="17mm" top="0mm" position="absolute"
                    width="40mm" height="6mm"
                    border-top="0.5pt dotted black">
                <fo:block text-align="center">
                    Vydal
                </fo:block>
            </fo:block-container>
            <fo:block-container
                    left="91mm" top="0mm" position="absolute"
                    width="40mm" height="6mm"
                    border-top="0.5pt dotted black">
                <fo:block text-align="center">
                    Přijal
                </fo:block>
            </fo:block-container>
        </fo:block-container>
    </xsl:template>

</xsl:stylesheet>
