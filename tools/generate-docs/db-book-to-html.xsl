<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://docbook.org/ns/docbook" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0" xmlns="http://www.w3.org/1999/xhtml">
  
  <xsl:output method="xhtml" doctype-public="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    encoding="UTF-8"/>
  <xsl:param name="output-folder"/>
  
  <xsl:variable name="folder"
    select="substring-before(subsequence(reverse(tokenize(base-uri(.), '/')), 1, 1), '.xml')"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="book">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"
      xmlns:url="http://www.oecd.org/ns/schema" url:base="{$output-folder}">
      <head>
        <link href="../resources/stylesheets/style.css" media="screen" rel="stylesheet" type="text/css"/>
        <title>
          <xsl:value-of select="info/title"/>
        </title>
      </head>
      <body>
        <div id="header">
          <h1>
            <xsl:value-of select="info/title"/>
          </h1>
          <div id="menu"> </div>
        </div>
        <div id="content">
          <div id="left">
            <xsl:apply-templates select="info"/>
            <ul>
              <xsl:apply-templates select="chapter | article"/>
            </ul>
          </div>
          <div id="right"> </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="info">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="book/info/title">
    <h2>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>

  <xsl:template match="chapter | article">
    <li>
      <xsl:apply-templates select="info"/>
      <ul>
        <xsl:apply-templates select="sect1"/>
      </ul>
    </li>
  </xsl:template>

  <xsl:template match="chapter/info/title | article/info/title">
    <span style="font-weight:bold;">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="sect1">
    <li>
      <xsl:apply-templates select="info"/>
    </li>
  </xsl:template>

  <xsl:template match="sect1/info/title">
    <a href="{replace(replace(., ' ', '_'), ':', '_')}.xhtml">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="*"/>

</xsl:stylesheet>
