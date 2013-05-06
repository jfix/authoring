<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:e="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:x="urn:schemas-microsoft-com:office:excel"
    xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:output indent="no"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="contextColor" select="'#50A524'"/>
    <xsl:variable name="spaceColor" select="'#F18E00'"/>
    <xsl:variable name="patternColor" select="'#00A6EA'"/>
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Règles typographiques</title>
                <style type="">
                    body{
                        font:75% arial, verdana, sans-serif;
                    }
                    h1,
                    h2,
                    h3,
                    h4{
                        font-family:arial, verdana, sans-serif;
                        color:#034a91;
                        line-height:1.0;
                        margin-bottom:8px;
                        font-size:2em;
                        padding-bottom:2px;
                    }
                    h3,
                    h4{
                        font-size:1.7em;
                        padding-left:20px;
                        padding-top:2px;
                        margin-top:2px;
                        line-height:1em;
                    }
                    h3{
                        font-weight:bold;
                    }
                    h4{
                        font-weight:normal;
                    }
                .pattern {
font-size: 80%;                }</style>
            </head>
            <body>
                <h1>Règles typographiques</h1>
                <h4>Table des matières</h4>
                <ul>
                    <xsl:apply-templates mode="toc"/>
                </ul>

                <xsl:apply-templates/>
            </body>
        </html>

    </xsl:template>
    <xsl:template match="section" mode="toc">
        <li xmlns="http://www.w3.org/1999/xhtml">
            <a href="#r{generate-id()}">
                <xsl:apply-templates select="title" mode="toc"/>
            </a>
            <xsl:if test="section">
                <ul>
                    <xsl:apply-templates select="./section" mode="toc"/>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>



    <xsl:template match="section/title">
        <xsl:element name="h{count(ancestor-or-self::section)+2}">
            <a name="r{generate-id(parent::*)}" xmlns="http://www.w3.org/1999/xhtml"/>
            <xsl:apply-templates/>
        </xsl:element>

    </xsl:template>

    <xsl:template match="rules">
        <div class="rules" xmlns="http://www.w3.org/1999/xhtml">
            <table width="100%">
                <tr>
                    <th width="10%">Lang.</th>
                    <th width="30%">Pattern/replacement</th>
                    <th width="40%">Commentaires</th>
                    <th width="20%">Contexte</th>
                </tr>
                <xsl:apply-templates/>
            </table>
        </div>
    </xsl:template>
    <xsl:template match="replacement">

        <tr class="replacement" xmlns="http://www.w3.org/1999/xhtml">
            <td>
                <xsl:value-of select="@targetLanguage"/>
            </td>
            <td class="pattern">
                <table width="100%">
                    <tr>
                        <td width="45%" class="pattern">
                            <xsl:apply-templates select=".//patternToSearch"/>
                        </td>
                        <td width="10%" class="pattern">
                            <xsl:text>→</xsl:text>
                        </td>
                        <td width="45%" class="pattern">
                            <xsl:apply-templates select=".//replacementPattern"/>
                        </td>
                    </tr>
                </table>
            </td>
            <td>
                <xsl:apply-templates select=".//comment"/>
            </td>
            <td>
                <xsl:apply-templates select=".//context"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="alert">
        <xsl:param name="lang" tunnel="yes"/>
        <tr class="alert" xmlns="http://www.w3.org/1999/xhtml">
            <td>
                <xsl:value-of select="@targetLanguage"/>
            </td>
            <td class="pattern">
                <xsl:apply-templates select=".//patternToSearch"/>

            </td>
            <td>
                <xsl:apply-templates select=".//comment"/>

            </td>
        </tr>

    </xsl:template>
    <xsl:template match="pattern">
        <em xmlns="http://www.w3.org/1999/xhtml">
            <font color="{$patternColor}">
                <xsl:value-of select="concat('&lt;',@value,'&gt;')"/>
            </font>
        </em>
    </xsl:template>
    <xsl:template match="character">
        <span class="character"><em>
            <font color="{$patternColor}">
                <xsl:text>&lt;</xsl:text>
            </font>
        </em>
        <font color="black">
            <xsl:value-of select="@value"/>
        </font>
        <em>
            <font color="{$patternColor}">
                <xsl:text>&gt;</xsl:text>
            </font>
        </em></span>
    </xsl:template>
    <xsl:template match="entity">
        <xsl:value-of select="concat('&amp;',@value,';')"/>
    </xsl:template>
    <xsl:template match="space">
        <font color="{$spaceColor}" xmlns="http://www.w3.org/1999/xhtml">
            <xsl:value-of select="'•'"/>
        </font>
    </xsl:template>



    <xsl:template match="context">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="notInElement">
        <font color="{$contextColor}" xmlns="http://www.w3.org/1999/xhtml">
            <xsl:value-of select="concat(' ( not in ',.,')')"/>
        </font>
    </xsl:template>
    <xsl:template match="inElement">
        <font color="{$contextColor}" xmlns="http://www.w3.org/1999/xhtml">
            <xsl:value-of select="concat(' ( only in ',.,')')"/>
        </font>
    </xsl:template>
    <xsl:template match="freeContext">
        <font color="{$contextColor}" xmlns="http://www.w3.org/1999/xhtml">
            <xsl:variable name="content"><xsl:apply-templates></xsl:apply-templates></xsl:variable>
            <xsl:value-of select="concat(' (',$content,')')"/>
        </font>
    </xsl:template>
    <xsl:template match="conditionalReplacementPattern">
        <xsl:variable name="context">
            <xsl:apply-templates select="context/*"/>
        </xsl:variable>
        <xsl:variable name="replacement">
            <xsl:apply-templates select="replacementPattern"/>
        </xsl:variable>
        <xsl:value-of select="concat(' [si ',$context,' alors ',$replacement,']')"/>
    </xsl:template>
</xsl:stylesheet>
