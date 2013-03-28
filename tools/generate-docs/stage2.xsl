<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oecd.org/ns/schema/xdocs"
  xmlns:xd2="http://www.oecd.org/ns/schema/xdocs" xmlns:saxon="http://saxon.sf.net/"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron" extension-element-prefixes="saxon">
  
  <xsl:namespace-alias stylesheet-prefix="xd2" result-prefix="xd"/>
  
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  
  <xsl:param name="schema" select="/xs:schema/@schema"/>
  <xsl:param name="model-name" select="/xs:schema/xs:annotation/xs:appinfo/xd:name/text()"/>
  <xsl:param name="root" select="/xs:schema/xs:annotation/xs:appinfo/xd:root/text()"/>

  <xsl:key name="complexTypes" match="xs:complexType" use="@name"/>
  <xsl:key name="elements" match="xs:element[not(ancestor::xs:complexType)]" use="@name"/>
  <xsl:key name="attributes" match="xs:attribute[not(ancestor::xs:complexType)]" use="@name"/>
  <xsl:key name="substitutes" match="xs:element[@substitutionGroup]" use="@substitutionGroup"/>
  <xsl:key name="groups" match="xs:group[@name]" use="@name"/>
  <xsl:key name="attributeGroups" match="xs:attributeGroup[@name]" use="@name"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xs:complexType[xs:complexContent/xs:extension]">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="xs:annotation"/>
      <xsl:variable name="baseType" select="xs:complexContent/xs:extension/@base"/>
      <xsl:apply-templates select="key('complexTypes', $baseType)/*[name() != 'xs:annotation']"/>
      <xsl:apply-templates select="xs:complexContent/xs:extension/*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xs:element[@ref]">
    <xsl:variable name="globalElement" select="key('elements', @ref)"/>
    <xsl:choose>
      <xsl:when test="$globalElement/@type">
        <xsl:copy>
          <xsl:copy-of select="@*[name() != 'ref']"/>
          <xsl:attribute name="name">
            <xsl:value-of select="@ref"/>
          </xsl:attribute>
          <xsl:attribute name="type">
            <xsl:value-of select="$globalElement/@type"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="$globalElement/@abstract = 'true'">
        <!-- if the parent of the element is a choice, and the element has no min or max occurs, then don't create a second unnecessary choice -->
        <xsl:choose>
          <xsl:when test="not(@minOccurs or @maxOccurs) and parent::xs:choice">
            <xsl:apply-templates select="key('substitutes', @ref)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <!-- if there's more than one substitutable element ... -->
              <xsl:when test="count(key('substitutes', @ref)) &gt; 1">
                <xs:choice>
                  <xsl:copy-of select="@minOccurs"/>
                  <xsl:copy-of select="@maxOccurs"/>
                  <xsl:apply-templates select="key('substitutes', @ref)"/>
                </xs:choice>
              </xsl:when>
              <!-- ...otherwise, just take a copy of the one substitute, and apply the minOccurs and maxOccurs - no choice or sequence necessary. -->
              <xsl:otherwise>
                <xsl:variable name="minOccurs" select="@minOccurs"/>
                <xsl:variable name="maxOccurs" select="@maxOccurs"/>
                <xsl:choose>
                  <!-- Prevent single substitutable elements with a single substitute appearing as the lone child of a sequence being output as a direct child of xs:complexType with no parent xs:sequence. -->
                  <xsl:when test="count(parent::*/*) = 1 and parent::xs:sequence/parent::xs:complexType">
                    <xs:sequence>
                      <xsl:for-each select="key('substitutes', @ref)">
                        <!-- (there'll only be one...) -->
                        <xsl:copy>
                          <xsl:copy-of select="@*"/>
                          <xsl:if test="$minOccurs != ''">
                            <xsl:attribute name="minOccurs" select="$minOccurs"/>
                          </xsl:if>
                          <xsl:if test="$maxOccurs != ''">
                            <xsl:attribute name="maxOccurs" select="$maxOccurs"/>
                          </xsl:if>
                          <xsl:apply-templates/>
                        </xsl:copy>
                      </xsl:for-each>
                    </xs:sequence>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:for-each select="key('substitutes', @ref)">
                      <!-- (there'll only be one...) -->
                      <xsl:copy>
                        <xsl:copy-of select="@*"/>
                        <xsl:if test="$minOccurs != ''">
                          <xsl:attribute name="minOccurs" select="$minOccurs"/>
                        </xsl:if>
                        <xsl:if test="$maxOccurs != ''">
                          <xsl:attribute name="maxOccurs" select="$maxOccurs"/>
                        </xsl:if>
                        <xsl:apply-templates/>
                      </xsl:copy>
                    </xsl:for-each>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xs:attribute[@ref]">
    <xsl:copy>
      <xsl:copy-of select="@*[name() != 'ref']"/>
      <xsl:attribute name="name">
        <xsl:value-of select="@ref"/>
      </xsl:attribute>
      <xsl:attribute name="type">
        <xsl:value-of select="key('attributes', @ref)/@type"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xs:attributeGroup[@ref]">
    <xsl:variable name="attributeGroup" select="key('attributeGroups', @ref)"/>
    <xsl:apply-templates select="$attributeGroup/*"/>
  </xsl:template>

  <xsl:template match="xs:group[@ref]">
    <xsl:variable name="group" select="key('groups', @ref)"/>
    <xsl:variable name="minOccurs" select="@minOccurs"/>
    <xsl:variable name="maxOccurs" select="@maxOccurs"/>
    <xsl:choose>
      <!-- If the parent of the reference to the group is xs:sequence, and the first element of the actual group is xs:sequence with no min or max restrictions, then just output the contents of that xs:sequence -->
      <xsl:when
        test="parent::xs:sequence and ($group/xs:sequence and not($group/xs:sequence/@minOccurs) and not($group/xs:sequence/@maxOccurs))">
        <xsl:apply-templates select="$group/xs:sequence/*"/>
      </xsl:when>
      <!-- If the parent of the reference to the group is xs:choice, and the first element of the actual group is xs:choice with no min or max restrictions, then just output the contents of that xs:choice -->
      <xsl:when
        test="parent::xs:choice and ($group/xs:choice and not($group/xs:choice/@minOccurs) and not($group/xs:choice/@maxOccurs))">
        <xsl:apply-templates select="$group/xs:choice/*"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$group/*">
          <!-- check for any min or max occurs on the group and pass it to the child -->
          <xsl:with-param name="minOccurs" select="$minOccurs"/>
          <xsl:with-param name="maxOccurs" select="$maxOccurs"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xs:group[@name]"/>

  <!-- If the sequence only holds a choice (generated by a group or a reference to an element with a substitutionGroup) then don't bother with the sequence. -->
  <xsl:template match="xs:sequence[not(@minOccurs or @maxOccurs)]">
    <xsl:choose>
      <xsl:when test="count(child::*) = 1">
        <xsl:choose>
          <xsl:when test="xs:element[@ref]">
            <xsl:variable name="globalElement" select="key('elements', xs:element/@ref)"/>
            <xsl:choose>
              <xsl:when test="$globalElement/@abstract = 'true'">
                <xsl:apply-templates/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy>
                  <xsl:copy-of select="@*"/>
                  <xsl:apply-templates/>
                </xsl:copy>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="xs:group">
            <xsl:apply-templates/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:apply-templates/>
            </xsl:copy>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xs:schema">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="model-name">
        <xsl:choose>
          <xsl:when test="$model-name != ''">
            <xsl:value-of select="$model-name"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@schema"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="$root != ''">
        <xsl:attribute name="root" select="$root"/>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*">
    <!-- catch any min or max occurs passed from a parent group ref -->
    <xsl:param name="minOccurs"/>
    <xsl:param name="maxOccurs"/>
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:if test="$minOccurs != ''">
        <xsl:attribute name="minOccurs" select="$minOccurs"/>
      </xsl:if>
      <xsl:if test="$maxOccurs != ''">
        <xsl:attribute name="maxOccurs" select="$maxOccurs"/>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
