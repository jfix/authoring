<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0">
  
  <xsl:key name="schemas" match="schema-ids/element" use="@id"/>
  <xsl:key name="elements-by-schema" match="schema-ids/element" use="schema/@name"/>
  <xsl:key name="elements-by-id" match="doc/element" use="@id"/>
  <xsl:key name="elements-by-name" match="doc/element" use="@name"/>
  <xsl:key name="elements-by-type-id" match="children/element" use="@type-id"/>
  <xsl:key name="type-equivalents" match="type-equivalents/type" use="@id"/>
  <xsl:key name="equivalent-types" match="type-equivalents/type" use="equivalent/@id"/>
  <xsl:key name="doc-elements-by-type-id" match="doc/element" use="type/@id"/>
  <xsl:key name="targets" match="target" use="@element"/>

  <!-- Performs final stages of transformation to collate information about parent elements and schemas and integrate at element level -->

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="schemas-with-references">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="docs">
    <docs>
      <xsl:apply-templates/>
    </docs>
  </xsl:template>

  <xsl:template match="doc">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="doc/element">
    <xsl:variable name="type" select="@type"/>
    <xsl:variable name="id" select="@id"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="type-id" select="type/@id"/>
      <schemas>
        <xsl:for-each select="key('schemas', @id)/schema">
          <schema name="{@name}"/>
        </xsl:for-each>
      </schemas>
      <xsl:call-template name="getParents"/>
      <xsl:apply-templates/>
      <references>
        <xsl:for-each-group select="key('targets', @name)/*" group-by="@id">
          <xsl:copy-of select="."/>
        </xsl:for-each-group>
        <!--
        <xsl:copy-of select="key('targets', @name)/*"/>-->
      </references>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="children">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="children/element">
    <xsl:copy>
      <xsl:copy-of select="@name"/>
      <xsl:copy-of select="@type"/>
      <!-- Extra test to see if any equivalents are listed for which a declared type-id is defined. Works in reverse to the equivalents lookup for parents on the doc/element.-->
      <xsl:choose>
        <xsl:when test="count(key('doc-elements-by-type-id', @type-id)) &gt; 0">
          <xsl:copy-of select="@type-id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="type-id" select="key('equivalent-types', @type-id)/@id"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="element/type"/>

  <xsl:template match="*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="schema-ids"/>
  <xsl:template match="type-equivalents"/>
  <xsl:template match="targets"/>

  <xsl:template name="getParents">
    <xsl:variable name="this-element" select="@name"/>
    <xsl:variable name="multi-schemas">
      <xsl:choose>
        <xsl:when test="count(key('type-equivalents', type/@id)/equivalent) = 0">false</xsl:when>
        <xsl:otherwise>true</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="parents">
      <xsl:for-each select="key('elements-by-type-id', type/@id)">
        <xsl:if test="@name = $this-element">
          <parent name="{ancestor::element/@name}" type-id="{ancestor::element/type/@id}">
            <xsl:if test="$multi-schemas = 'true'">
              <xsl:for-each select="key('schemas', ancestor::element/@id)/schema">
                <schema name="{@name}"/>
              </xsl:for-each>
            </xsl:if>
          </parent>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="key('type-equivalents', type/@id)/equivalent">
        <xsl:for-each select="key('elements-by-type-id', @id)">
          <xsl:if test="@name = $this-element">
            <parent name="{ancestor::element/@name}" type-id="{ancestor::element/type/@id}">
              <xsl:for-each select="key('schemas', ancestor::element/@id)/schema">
                <schema name="{@name}"/>
              </xsl:for-each>
            </parent>
          </xsl:if>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <parents>
      <xsl:for-each select="$parents/*">
        <xsl:sort select="string-join(@name, schema/@name)"/>
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </parents>
  </xsl:template>

</xsl:stylesheet>
