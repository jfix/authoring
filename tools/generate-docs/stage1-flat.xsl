<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oecd.org/ns/schema/xdocs" xmlns:xd2="http://www.oecd.org/ns/schema/xdocs" xmlns:xd0="http://www.oecd.org/ns/schema/xdocs" xmlns:saxon="http://saxon.sf.net/" xmlns:sch="http://purl.oclc.org/dsdl/schematron" extension-element-prefixes="saxon">
  <xsl:namespace-alias  stylesheet-prefix="xd0" result-prefix="xd2"/>
  <xsl:output method="xml" encoding="utf-8" indent="yes" />
  
  <xsl:param name="schema">
    <xsl:call-template name="substring-after-last">
      <xsl:with-param name="string" select="substring-before(base-uri(.), '.xsd')" />
      <xsl:with-param name="delimiter" select="'/'" />
    </xsl:call-template>    
  </xsl:param>  
  <xsl:variable name="importedSchema" saxon:assignable="yes"/>

  <xsl:template match="/">
      <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="xs:schema">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="schema" select="$schema"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xs:include">
    <xsl:param name="nsPrefix"/>
    <xsl:param name="redefinitions"/>
    <xsl:apply-templates select="document(@schemaLocation)/xs:schema/*">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
      <xsl:with-param name="redefinitions" select="$redefinitions"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="xs:import">
    <!-- Check we've not already imported this xsd by checking the resolved uri of the xsd against the list. -->
    <xsl:if test="not(contains($importedSchema, concat('[', resolve-uri(@schemaLocation, base-uri()), ']')))">
      <!-- If it's not on the list, add it, and then process the xsd. -->
      <saxon:assign name="importedSchema" select="concat($importedSchema, '[', resolve-uri(@schemaLocation, base-uri()), ']')"/>
      <xsl:variable name="namespace-uri" select="@namespace"/>
      <xsl:variable name="thisElement" select="."/>
      <!-- Calculate the namespace prefix to be used for elements in this imported xsd. -->
      <xsl:variable name="nsPrefix">
        <xsl:if test="@namespace">
          <xsl:for-each select="in-scope-prefixes(/xs:schema)">
            <xsl:variable name="thisPrefix" select="."/>
            <xsl:if test="namespace-uri-for-prefix($thisPrefix, $thisElement/.) = $namespace-uri">
              <xsl:value-of select="$thisPrefix"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </xsl:variable>
      <xsl:apply-templates select="document(@schemaLocation)/xs:schema/*">
        <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xs:redefine">
    <xsl:param name="nsPrefix"/>
    <xsl:param name="redefinitions"/>
    <!-- Now carries redefines through into redefines... -->
    <!--<xsl:variable name="redefinitions" select="."/>-->
    <xsl:variable name="these-redefinitions">
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:copy-of select="$redefinitions"/>
        <xsl:copy-of select="*"/>
      </xsl:copy>
    </xsl:variable>
    <xsl:apply-templates select="document(@schemaLocation)/xs:schema/*">
      <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
      <!--<xsl:with-param name="redefinitions" select="$redefinitions"/>-->
      <xsl:with-param name="redefinitions" select="$these-redefinitions"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <!--**Just try this to see if we can pick up definitions nested inside element names -->
  <xsl:template match="xs:element[xs:complexType] | xs:element[xs:simpleType]">
    <xs:element type="{@name}-{generate-id(xs:complexType | xs:simpleType)}">
      <xsl:copy-of select="@*"/>
    </xs:element>
    <xsl:apply-templates/>
  </xsl:template>
  
  <!--**Just try this to see if we can pick up definitions nested inside attribute names -->
  <xsl:template match="xs:attribute[xs:simpleType][not(parent::xs:attributeGroup)]">
    <xs:attribute type="{@name}-{generate-id(xs:simpleType)}">
      <xsl:copy-of select="@*"/>
    </xs:attribute>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="xs:attribute[not(xs:simpleType) and not(@type)]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="type">xs:string</xsl:attribute>
    </xsl:copy>
  </xsl:template>
  
  <!-- **Added to cater for attributes in attributeGroups with nested simpleTypes. -->
  <xsl:template match="xs:attributeGroup[xs:attribute/xs:simpleType]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:for-each select="xs:attribute[not(xs:simpleType)]">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
      <xsl:for-each select="xs:attribute[xs:simpleType]">
        <xs:attribute type="{@name}-{generate-id(xs:simpleType)}">
          <xsl:copy-of select="@*"/>
        </xs:attribute>
      </xsl:for-each>
      <xsl:apply-templates select="*[name() != 'xs:attribute']"/>
    </xsl:copy>
    <xsl:for-each select="xs:attribute/xs:simpleType">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="xs:complexType | xs:simpleType">
    <xsl:param name="nsPrefix"/>
    <xsl:param name="redefinitions"/>
    <xsl:variable name="elementName" select="name()"/>
    <!--**Just try this to see if we can pick up definitions nested inside element names -->
    <xsl:variable name="thisName">
      <xsl:choose>
        <xsl:when test="@name">
          <xsl:value-of select="@name"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat(parent::xs:element/@name | parent::xs:attribute/@name, '-', generate-id())"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--**<xsl:variable name="thisName" select="@name"/>-->
    <xsl:element name="{name()}">
      <!--**Just try this to see if we can pick up definitions nested inside element names -->
      <xsl:copy-of select="@*[name() != 'name']"/>
      <xsl:attribute name="name" select="$thisName"/>
      <!--**<xsl:copy-of select="@*"/>-->
      <xsl:choose>
        <xsl:when test="$redefinitions = ''">
          <xsl:apply-templates>
            <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="count($redefinitions//*[name() = $elementName and @name = $thisName]) = 0">
              <xsl:apply-templates>
                <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="$redefinitions//*[name() = $elementName and @name = $thisName]/xs:annotation">
                  <xsl:apply-templates select="$redefinitions//*[name() = $elementName and @name = $thisName]/xs:annotation"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="xs:annotation"/>
                </xsl:otherwise>
              </xsl:choose>                  
              <xsl:apply-templates select="*[name() != 'xs:annotation']">
                <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="$redefinitions != ''">
            <xsl:apply-templates select="$redefinitions//*[name() = $elementName and @name = $thisName]/xs:complexContent/xs:extension/*">
              <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*">
    <!-- Copy all elements, adding the namespace prefix onto any referenced element names where necessary -->
    <xsl:param name="nsPrefix"/>
    <xsl:choose>
      <xsl:when test="$nsPrefix != ''">
        <xsl:element name="{name()}">
          <xsl:choose>
            <xsl:when test="name(.) = 'xs:element'">
              <xsl:variable name="elementFormDefault" select="ancestor::xs:schema/@elementFormDefault"/>
              <xsl:if test="@name">
                <xsl:attribute name="name">
                  <xsl:choose>
                    <xsl:when test="$elementFormDefault = 'qualified'">
                      <xsl:value-of select="concat($nsPrefix, ':', @name)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@name"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="@ref and not(contains(@ref, ':'))">
                <xsl:attribute name="ref">
                  <xsl:choose>
                    <xsl:when test="$elementFormDefault = 'qualified'">
                      <xsl:value-of select="concat($nsPrefix, ':', @ref)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@ref"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </xsl:if>
              <xsl:copy-of select="@*[name() != 'name' and name() != 'ref']"/>
              <xsl:if test="@ref and contains(@ref, ':')">
                <xsl:copy-of select="@ref"/>
              </xsl:if>
            </xsl:when>
            <xsl:when test="name(.) = 'xs:attribute'">
              <xsl:variable name="attributeFormDefault" select="ancestor::xs:schema/@attributeFormDefault"/>
              <xsl:if test="@name">
                <xsl:attribute name="name">
                  <xsl:choose>
                    <xsl:when test="$attributeFormDefault = 'qualified' or parent::xs:schema">
                      <xsl:value-of select="concat($nsPrefix, ':', @name)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@name"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="@ref and not(contains(@ref, ':'))">
                <xsl:attribute name="ref">
                  <xsl:choose>
                    <xsl:when test="$attributeFormDefault = 'qualified'">
                      <xsl:value-of select="concat($nsPrefix, ':', @ref)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@ref"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </xsl:if>
              <xsl:copy-of select="@*[name() != 'name' and name() != 'ref']"/>
              <xsl:if test="@ref and contains(@ref, ':')">
                <xsl:copy-of select="@ref"/>
              </xsl:if>
            </xsl:when>
            <xsl:when test="name(.) = 'xs:attributeGroup'">
              <xsl:if test="@name">
                <xsl:attribute name="name">
                  <xsl:value-of select="concat($nsPrefix, ':', @name)"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="@ref and not(contains(@ref, ':'))">
                <xsl:attribute name="ref">
                  <xsl:value-of select="concat($nsPrefix, ':', @ref)"/>
                </xsl:attribute>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="@*"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates>
            <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates>
            <xsl:with-param name="nsPrefix" select="$nsPrefix"/>
          </xsl:apply-templates>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="substring-after-last">
    <xsl:param name="string" />
    <xsl:param name="delimiter" />
    <xsl:choose>
      <xsl:when test="contains($string, $delimiter)">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="string"
            select="substring-after($string, $delimiter)" />
          <xsl:with-param name="delimiter" select="$delimiter" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$string" /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>