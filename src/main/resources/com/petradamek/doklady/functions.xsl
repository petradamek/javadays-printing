<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:x="http://www.bilysklep.cz/localStylesheetExtensions"
                xmlns:xi="http://www.bilysklep.cz/localStylesheetExtensions/internal"
>

    <xsl:function name="x:toWord" as="xsd:string">
        <xsl:param name="number" as="xsd:decimal"/>
        <xsl:value-of select="x:toWord(xsd:integer($number), '', 'F')"/>
    </xsl:function>

    <xsl:function name="x:toWord" as="xsd:string">
        <xsl:param name="number" as="xsd:integer"/>
        <xsl:param name="wordSeparator" as="xsd:string"/>
        <xsl:param name="gender" as="xsd:string"/>
        <xsl:choose>
            <xsl:when test="$number lt 0">
                <xsl:value-of select="concat('Mínus', $wordSeparator, xi:toWord(-$number, $wordSeparator, $gender))"/>
            </xsl:when>
            <xsl:when test="$number = 0">Nula</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="xi:toWord($number, $wordSeparator, $gender)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="xi:toWord" as="xsd:string">
        <xsl:param name="number" as="xsd:integer"/>
        <xsl:param name="wordSeparator" as="xsd:string"/>
        <xsl:param name="gender" as="xsd:string"/>
        <xsl:variable name="defaultGender" select="''"/>
        <xsl:choose>
            <xsl:when test="$number = 0">
                <xsl:text/>
            </xsl:when>
            <xsl:when test="$number lt 10">
                <xsl:value-of select="xi:digitToWord($number mod 10, $gender)"/>
            </xsl:when>
            <xsl:when test="$number = 10">Deset</xsl:when>
            <xsl:when test="$number = 11">Jedenáct</xsl:when>
            <xsl:when test="$number = 12">Dvanáct</xsl:when>
            <xsl:when test="$number = 14">Čtrnáct</xsl:when>
            <xsl:when test="$number = 15">Patnáct</xsl:when>
            <xsl:when test="$number = 19">Devatenáct</xsl:when>
            <xsl:when test="$number lt 20">
                <xsl:value-of select="concat(xi:digitToWord($number mod 10, 'M'),'náct')"/>
            </xsl:when>
            <xsl:when test="$number lt 100">
                <xsl:value-of select="concat(
                    xi:tensToWord($number idiv 10),
                    $wordSeparator,
                    xi:digitToWord($number mod 10, $defaultGender)
                )"/>
            </xsl:when>
            <xsl:when test="$number lt 1000">
                <xsl:value-of select="concat(
                    xi:hundredsToWord($number idiv 100),
                    $wordSeparator,
                    xi:toWord($number mod 100, $wordSeparator, $defaultGender)
                )"/>
            </xsl:when>
            <xsl:when test="$number lt 1000000">
                <xsl:value-of select="concat(
                    xi:thousandToWord($number idiv 1000, $wordSeparator),
                    $wordSeparator,
                    xi:toWord($number mod 1000, $wordSeparator, $defaultGender)
                )"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    Value is too big: <xsl:value-of select="$number"/>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>

    <xsl:function name="xi:digitToWord" as="xsd:string">
        <xsl:param name="digit" as="xsd:integer"/>
        <xsl:param name="gender" as="xsd:string"/>
        <xsl:variable name="defaultGender" select="''"/>
        <xsl:if test="$gender != 'F' and $gender != 'M' and $gender != 'N' and $gender != ''">
            <xsl:message terminate="yes">
                Invalid gender:
                <xsl:value-of select="$gender"/>
            </xsl:message>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="$digit = 0">
                <xsl:text/>
            </xsl:when>
            <xsl:when test="$digit = 1 and $gender = 'M'">Jeden</xsl:when>
            <xsl:when test="$digit = 1 and ($gender = 'F' or $gender = '')">Jedna</xsl:when>
            <xsl:when test="$digit = 1 and $gender = 'N'">Jedno</xsl:when>
            <xsl:when test="$digit = 2 and ($gender = 'M' or $gender = '')">Dva</xsl:when>
            <xsl:when test="$digit = 2">Dvě</xsl:when>
            <xsl:when test="$digit = 3">Tři</xsl:when>
            <xsl:when test="$digit = 4">Čtyři</xsl:when>
            <xsl:when test="$digit = 5">Pět</xsl:when>
            <xsl:when test="$digit = 6">Šest</xsl:when>
            <xsl:when test="$digit = 7">Sedm</xsl:when>
            <xsl:when test="$digit = 8">Osm</xsl:when>
            <xsl:when test="$digit = 9">Devět</xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    Invalid digit value (must be 0..9):
                    <xsl:value-of select="$digit"/>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="xi:tensToWord" as="xsd:string">
        <xsl:param name="tens" as="xsd:integer"/>
        <xsl:choose>
            <xsl:when test="$tens ge 2 and $tens le 4">
                <xsl:value-of select="concat(xi:digitToWord($tens, 'M'), 'cet')"/>
            </xsl:when>
            <xsl:when test="$tens = 5">Padesát</xsl:when>
            <xsl:when test="$tens = 6">Šedesát</xsl:when>
            <xsl:when test="$tens = 7">Sedmdesát</xsl:when>
            <xsl:when test="$tens = 8">Osmdesát</xsl:when>
            <xsl:when test="$tens = 9">Devadesát</xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    Invalid tens value (must be 2..9):
                    <xsl:value-of select="$tens"/>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="xi:hundredsToWord" as="xsd:string">
        <xsl:param name="hundreds" as="xsd:integer"/>
        <xsl:choose>
            <xsl:when test="$hundreds = 1">Sto</xsl:when>
            <xsl:when test="$hundreds = 2">Dvěstě</xsl:when>
            <xsl:when test="$hundreds = 3">Třista</xsl:when>
            <xsl:when test="$hundreds = 4">Čtyřista</xsl:when>
            <xsl:when test="$hundreds ge 5 and $hundreds le 9">
                <xsl:value-of select="concat(xi:digitToWord($hundreds, 'M'), 'set')"/>
            </xsl:when>
            <xsl:when test="$hundreds = 9">Devadesát</xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    Invalid hundreds value (must be 1..9):
                    <xsl:value-of select="$hundreds"/>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="xi:thousandToWord" as="xsd:string">
        <xsl:param name="thousand" as="xsd:integer"/>
        <xsl:param name="wordSeparator" as="xsd:string"/>
        <xsl:choose>
            <xsl:when test="$thousand = 1">Tisíc</xsl:when>
            <xsl:when test="$thousand ge 2 and $thousand le 4">
                <xsl:value-of select="concat(
                    xi:toWord($thousand, $wordSeparator, 'M'),
                    $wordSeparator,
                    'Tisíce'
                )"/>
            </xsl:when>
            <xsl:when test="$thousand ge 5 and $thousand le 999">
                <xsl:value-of select="concat(
                    xi:toWord($thousand, $wordSeparator, 'M'),
                    $wordSeparator,
                    'Tisíc'
                )"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    Invalid thousand value (must be 1..999):
                    <xsl:value-of select="$thousand"/>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="x:commaToBreak">
        <xsl:param name="in" as="xsd:string"/>
        <xsl:analyze-string select="$in" regex=",\s*">
            <xsl:matching-substring>&#x2028;</xsl:matching-substring>
            <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>

</xsl:stylesheet>
