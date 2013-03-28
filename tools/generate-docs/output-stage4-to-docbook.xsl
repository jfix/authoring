<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xd="http://www.oecd.org/ns/schema/xdocs" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs xd" version="2.0" xpath-default-namespace="">
  
  <xsl:output method="xml" doctype-system="http://www.oasis-open.org/docbook/xml/svg/1.1CR1/dbsvg.dtd"
    doctype-public="-//OASIS//DTD DocBook SVG Module V1.1CR1//EN"/>

  <xsl:param name="output-folder">file:///C:/Documents and
    Settings/crowther_j/Desktop/documentation/</xsl:param>

  <xsl:key name="schemas" match="schema-ids/element" use="@id"/>
  <xsl:key name="elements-by-schema" match="doc/element" use="schemas/schema/@name"/>
  <xsl:key name="elements-by-id" match="doc/element" use="@id"/>
  <xsl:key name="elements-by-name" match="doc/element" use="@name"/>
  <xsl:key name="elements-by-type-id" match="children/element" use="@type-id"/>
  <xsl:key name="type-equivalents" match="type-equivalents/type" use="@id"/>
  <xsl:key name="doc-by-schema" match="doc" use="@schema"/>

  <xsl:template match="/">
    <book>
      <xsl:apply-templates/>
    </book>
  </xsl:template>

  <xsl:template match="docs">
    <article>
      <title>Model Documentation</title>
      <para>Documentation is provided below for the following models: <itemizedlist>
          <xsl:for-each select="doc">
            <xsl:sort select="@model-name"/>
            <listitem>
              <para><link linkend="{@schema}"><xsl:value-of select="@model-name"/></link></para>
            </listitem>
          </xsl:for-each>
        </itemizedlist>
      </para>
      <para>This documentation is best viewed in a browser with inline SVG support.</para>
    </article>
    <xsl:apply-templates select="doc"/>
    <xsl:for-each-group select="doc/element" group-by="@name">
      <article>
        <title>&lt;<xsl:value-of select="current-grouping-key()"/>&gt; - used by <xsl:for-each-group
            select="key('elements-by-name', current-grouping-key())/schemas/schema" group-by="@name"><xsl:if
              test="position() =
        last() and position() != 1"
              ><xsl:text>and </xsl:text></xsl:if><xsl:value-of
              select="key('doc-by-schema', current-grouping-key())/@model-name"/><xsl:choose>
              <xsl:when test="position() != last() and position() != last()-1"
                ><xsl:text>, </xsl:text></xsl:when>
              <xsl:when test="position() = last()"><xsl:text>.</xsl:text></xsl:when>
              <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
            </xsl:choose>
          </xsl:for-each-group></title>
        <anchor id="{replace(current-grouping-key(), ':', '.')}"/>
        <xsl:apply-templates select="current-group()"/>
        <xsl:call-template name="links"/>
      </article>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template match="doc">
    <xsl:variable name="root" select="@root"/>
    <article>
      <title>
        <xsl:value-of select="@model-name"/>
      </title>
      <anchor id="{@schema}"/>
      <para>The <emphasis><xsl:value-of select="@model-name"/></emphasis> model uses the namespace <emphasis
          role="strong"><xsl:value-of select="@namespace"/></emphasis></para>
      <xsl:apply-templates select="annotation"/>
      <para>The following elements are available to the <xsl:value-of select="@model-name"/> model:</para>
      <itemizedlist>
        <xsl:for-each select="key('elements-by-schema', @schema)">
          <xsl:sort select="@name"/>
          <xsl:choose>
            <xsl:when test="@name = $root">
              <listitem>
                <para>
                  <emphasis role="strong"><link linkend="{replace(@name, ':', '.')}{@type-id}"><xsl:value-of
                        select="@name"/></link> (root element)</emphasis>
                </para>
              </listitem>
            </xsl:when>
            <xsl:otherwise>
              <listitem>
                <para>
                  <link linkend="{replace(@name, ':', '.')}{@type-id}">
                    <xsl:value-of select="@name"/>
                  </link>
                </para>
              </listitem>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </itemizedlist>
    </article>
  </xsl:template>

  <xsl:template match="doc/element">
    <xsl:variable name="type" select="@type"/>
    <xsl:variable name="id" select="@id"/>
    <sect1>
      <title>The following definition of <emphasis role="strong">&lt;<xsl:value-of
            select="current-grouping-key()"/>&gt;</emphasis> is used by the <xsl:for-each
          select="schemas/schema"><xsl:if test="position() =
          last() and position() != 1"
            ><xsl:text>and </xsl:text></xsl:if><emphasis><xsl:value-of
              select="key('doc-by-schema', @name)/@model-name"/></emphasis><xsl:choose>
            <xsl:when test="position() != last() and position() != last()-1"
              ><xsl:text>, </xsl:text></xsl:when>
            <xsl:when test="position() = last()"><xsl:text> model</xsl:text><xsl:if test="position() &gt; 1"
                ><xsl:text>s</xsl:text></xsl:if><xsl:text>.</xsl:text></xsl:when>
            <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
          </xsl:choose></xsl:for-each></title>
      <anchor id="{replace(@name, ':', '.')}{@type-id}"/>
      <xsl:apply-templates select="parents"/>
      <sect2>
        <title>Elements and Attributes available within <emphasis role="strong">&lt;<xsl:value-of
              select="current-grouping-key()"/>&gt;</emphasis></title>
        <xsl:if test="children/@mixed = 'true'">
          <para>This is a mixed model allowing for elements and text.</para>
        </xsl:if>
        <xsl:if test="children/@simpleContent = 'true'">
          <para>This model does not allow for any elements but allows only for text.</para>
        </xsl:if>
        <xsl:if test="children/@empty = 'true'">
          <para>This is an empty model and does not allow for any elements or text.</para>
        </xsl:if>
        <xsl:apply-templates select="diagram"/>
        <xsl:apply-templates select="children"/>
        <xsl:apply-templates select="pattern"/>
        <xsl:apply-templates select="enumeration"/>
        <xsl:apply-templates select="base"/>
        <xsl:apply-templates select="schematron-rules"/>
      </sect2>
      <xsl:apply-templates select="annotation"/>
    </sect1>
  </xsl:template>

  <xsl:template match="diagram">
    <para>
      <inlinemediaobject>
        <imageobject>
          <xsl:copy-of select="*" copy-namespaces="no"/>
        </imageobject>
      </inlinemediaobject>
    </para>
  </xsl:template>

  <xsl:template match="children">
    <xsl:if test="element">
      <table width="98%" cellpadding="0" cellspacing="0">
        <title>Elements</title>
        <tgroup cols="2">
          <thead>
            <row>
              <entry>Element</entry>
              <entry>Notes</entry>
            </row>
          </thead>
          <tbody>
            <xsl:apply-templates select="element"/>
          </tbody>
        </tgroup>
      </table>
    </xsl:if>
    <xsl:if test="attribute">
      <table width="98%" cellpadding="0" cellspacing="0">
        <title>Attributes</title>
        <tgroup cols="3">
          <colspec colname="1" colnum="1"/>
          <colspec colname="2" colnum="2"/>
          <colspec colname="3" colnum="3"/>
          <thead>
            <row>
              <entry>Attribute</entry>
              <entry>Content</entry>
              <entry>Notes</entry>
            </row>
          </thead>
          <tbody>
            <xsl:apply-templates select="attribute"/>
            <row>
              <entry namest="1" nameend="3">Attributes in italics are optional.</entry>
            </row>
          </tbody>
        </tgroup>
      </table>
    </xsl:if>
  </xsl:template>

  <xsl:template match="children/element">
    <row>
      <entry valign="top">
        <link linkend="{replace(@name, ':', '.')}{@type-id}">&lt;<xsl:value-of select="@name"/>&gt;</link>
      </entry>
      <entry valign="top">
        <xsl:apply-templates/>
      </entry>
    </row>
  </xsl:template>

  <xsl:template match="attribute">
    <row>
      <entry valign="top">
        <xsl:if test="not(@use = 'required')">
          <xsl:attribute name="style">font-style: italic;</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="@name"/>
      </entry>
      <entry valign="top">
        <xsl:apply-templates select="description"/>
      </entry>
      <entry valign="top">
        <xsl:apply-templates select="annotation"/>
      </entry>
    </row>
  </xsl:template>

  <xsl:template match="description">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="pattern">
    <para>Allows content according to the following pattern:</para>
    <para>
      <xsl:apply-templates/>
    </para>
  </xsl:template>

  <xsl:template match="enumeration">
    <para>Allows for any of the following specific values: <itemizedlist>
        <xsl:apply-templates/>
      </itemizedlist>
    </para>
  </xsl:template>

  <xsl:template match="enumeration/value">
    <listitem>
      <para>
        <xsl:apply-templates/>
      </para>
    </listitem>
  </xsl:template>

  <xsl:template match="base">
    <xsl:choose>
      <xsl:when test="empty(*)">
        <para>Allows for content defined as 'string'.</para>
      </xsl:when>
      <xsl:otherwise>
        <dpara>Allows for content defined as '<xsl:apply-templates/>'.</dpara>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="annotation">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="doc/element/annotation[not(section)][*]">
    <sect2>
      <title>Usage</title>
      <xsl:apply-templates/>
    </sect2>
  </xsl:template>

  <xsl:template match="annotation/section[not(ancestor::attribute)]">
    <sect2>
      <xsl:apply-templates/>
    </sect2>
  </xsl:template>

  <xsl:template match="attribute/annotation/section"/>

  <xsl:template match="annotation/section/section">
    <sect3>
      <xsl:apply-templates/>
    </sect3>
  </xsl:template>

  <xsl:template match="section/title">
    <title>
      <xsl:apply-templates/>
    </title>
  </xsl:template>

  <xsl:template match="p">
    <para>
      <xsl:apply-templates/>
    </para>
  </xsl:template>

  <xsl:template match="note">
    <para role="note">
      <xsl:apply-templates/>
    </para>
  </xsl:template>

  <xsl:template match="warning">
    <para role="warning">
      <xsl:apply-templates/>
    </para>
  </xsl:template>

  <xsl:template match="strong">
    <emphasis role="strong">
      <xsl:apply-templates/>
    </emphasis>
  </xsl:template>

  <xsl:template match="p/source">
    <code>
      <xsl:apply-templates/>
    </code>
  </xsl:template>

  <xsl:template match="source">
    <para>
      <code>
        <xsl:apply-templates/>
      </code>
    </para>
  </xsl:template>

  <xsl:template match="table">
    <table>
      <title/>
      <!-- TODO Need a better method of counting max rows - I'll do it later. -->
      <tgroup cols="{count(tr[1]/td)}">
        <tbody>
          <xsl:apply-templates/>
        </tbody>
      </tgroup>
    </table>
  </xsl:template>

  <xsl:template match="tr">
    <row>
      <xsl:apply-templates/>
    </row>
  </xsl:template>

  <xsl:template match="td">
    <entry>
      <xsl:apply-templates/>
    </entry>
  </xsl:template>

  <xsl:template match="schematron-rules">
    <xsl:if test="rule">
      <sect3>
        <title>The following specific rules also apply:</title>
        <itemizedlist>
          <xsl:apply-templates/>
        </itemizedlist>
      </sect3>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rule">
    <listitem>
      <para>
        <xsl:apply-templates/>
      </para>
    </listitem>
  </xsl:template>

  <xsl:template match="schema-ids"/>
  <xsl:template match="type-equivalents"/>

  <xsl:template match="parents">
    <xsl:if test="*">
      <sect2>
        <title>This version of the <emphasis role="strong">&lt;<xsl:value-of select="current-grouping-key()"
            />&gt;</emphasis> element is applicable when used as a child to the following elements:</title>
        <itemizedlist>
          <xsl:apply-templates/>
        </itemizedlist>
      </sect2>
    </xsl:if>
  </xsl:template>

  <xsl:template match="parent">
    <listitem>
      <para>
        <link linkend="{replace(@name, ':', '.')}{@type-id}">&lt;<xsl:value-of select="@name"/>&gt;</link>
        <xsl:for-each select="schema">
          <xsl:if test="position() = 1">
            <xsl:text> (</xsl:text>
          </xsl:if>
          <emphasis>
            <xsl:value-of select="key('doc-by-schema', @name)/@model-name"/>
          </emphasis>
          <xsl:choose>
            <xsl:when test="not(following-sibling::*)">
              <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise>, </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </para>
    </listitem>
  </xsl:template>

  <xsl:template name="links">
    <!--<h5><a href="documentation.xhtml">Home</a></h5>
    <h5>Models:</h5>
    <ul>
      <xsl:for-each select="/docs/doc">
        <xsl:sort select="@model-name"/>
        <li><a href="{@schema}.xhtml"><xsl:value-of select="@model-name"/></a></li>
      </xsl:for-each>
    </ul>
    <h5>All Elements:</h5>
    <ul>
      <xsl:for-each-group select="/docs/doc/element" group-by="@name">
        <xsl:sort select="@name"/>
        <li><a href="{replace(@name, ':', '.')}.xhtml"><xsl:value-of select="@name"/></a></li>
      </xsl:for-each-group>
    </ul>-->
  </xsl:template>

</xsl:stylesheet>
