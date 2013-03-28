<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oecd.org/ns/schema/xdocs"
  xmlns:saxon="http://saxon.sf.net/" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  extension-element-prefixes="saxon" exclude-result-prefixes="sch">
  
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xs:choice">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:for-each select="*">
        <xsl:sort select="@name"/>
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
