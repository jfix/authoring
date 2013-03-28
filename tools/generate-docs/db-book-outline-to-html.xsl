<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://docbook.org/ns/docbook" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0" xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="xhtml" doctype-public="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    encoding="UTF-8"/>
  <xsl:param name="output-folder"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="book">
    <div class="box">
      <xsl:apply-templates select="info"/>
      <xsl:apply-templates select="chapter | article"/>
    </div>
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
    <xsl:apply-templates select="info"/>
    <ul>
      <xsl:apply-templates select="sect1"/>
    </ul>
  </xsl:template>

  <xsl:template match="chapter/info/title | article/info/title">
    <h5>
      <xsl:apply-templates/>
    </h5>
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
