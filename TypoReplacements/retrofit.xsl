<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:e="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:x="urn:schemas-microsoft-com:office:excel"
    xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:html="http://www.w3.org/TR/REC-html40" exclude-result-prefixes="xs o x dt ss html xsl"
    version="2.0">
    <xsl:output indent="yes"/>
    <xsl:template match="/">
        <section lang="all">
            <title>Legacy ITN</title>
            <xsl:apply-templates select="//e:Worksheet"/>
        </section>
    </xsl:template>
    <xsl:template match="e:Worksheet[@ss:Name='Typo-French' or @ss:Name='Typo-English']">
        <section lang="all">
            <title><xsl:value-of select="@ss:Name"></xsl:value-of></title>

            <xsl:apply-templates select="e:Table/e:Row"/>
        </section>
    </xsl:template>

    <xsl:template match="e:Worksheet"> </xsl:template>

    <xsl:template match="e:Row">
        <xsl:choose>
            <xsl:when test="string-length(e:Cell[7]/e:Data) > 40">
                <alert>
                    <patternToSearch><xsl:apply-templates select="e:Cell[6]/e:Data"/></patternToSearch>
                    <comment>
                        <textLang>
                            <xsl:attribute name="lang">
                                <xsl:choose>
                                    <xsl:when test="ancestor::e:Worksheet[@ss:Name='Typo-French']"
                                        >fr</xsl:when>
                                    <xsl:otherwise>en</xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:apply-templates select="e:Cell[7]/e:Data"/>
                        </textLang>
                    </comment>
                    
                    
                </alert>
            </xsl:when>
            <xsl:otherwise>
                <replacement>
                    <patternToSearch>
                        <xsl:apply-templates select="e:Cell[6]/e:Data"/>
                    </patternToSearch>
                    <replacementPattern>
                        <xsl:apply-templates select="e:Cell[7]/e:Data"/>
                    </replacementPattern>
                    <implementedIn>
                        <xsl:attribute name="group">
                            <xsl:apply-templates select="e:Cell[4]/e:Data"/>
                        </xsl:attribute>
                        <xsl:attribute name="type">
                            <xsl:apply-templates select="e:Cell[5]/e:Data"/>
                        </xsl:attribute>
                    </implementedIn>
                </replacement>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
</xsl:stylesheet>
