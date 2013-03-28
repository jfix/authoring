<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xpath-default-namespace="http://docbook.org/ns/docbook" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xd="http://www.oecd.org/ns/schema/xdocs" xmlns:xlink="http://www.w3.org/1999/xlink">
  <xsl:output method="xhtml" doctype-public="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    encoding="UTF-8"/>
  
  <xsl:include href="db-table-to-html.xsl"/>
  
  <xsl:param name="output-folder"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect1">
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
          <h1 class="title"/>
          <div id="menu"> </div>
        </div>
        <div id="content">
          <div id="left">
            <xsl:apply-templates/>
          </div>
          <div id="right"> </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="info">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect1/info/title">
    <h2>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>

  <xsl:template match="sect1/info/date">
    <h3 style="font-style:italic">Release date: <xsl:apply-templates/></h3>
  </xsl:template>

  <xsl:template match="sect2">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect2/info/title | bridgehead">
    <h3>
      <xsl:if test="parent::info/parent::sect2/@xml:id">
        <xsl:attribute name="id" select="parent::info/parent::sect2/@xml:id"/>
      </xsl:if>
      <xsl:apply-templates/>
    </h3>
  </xsl:template>

  <xsl:template match="sect3">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect3/info/title">
    <h4>
      <xsl:if test="parent::info/parent::sect3/@xml:id">
        <xsl:attribute name="id" select="parent::info/parent::sect3/@xml:id"/>
      </xsl:if>
      <xsl:apply-templates/>
    </h4>
  </xsl:template>

  <xsl:template match="sect4">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect4/info/title">
    <h5>
      <xsl:if test="parent::info/parent::sect4/@xml:id">
        <xsl:attribute name="id" select="parent::info/parent::sect4/@xml:id"/>
      </xsl:if>
      <xsl:apply-templates/>
    </h5>
  </xsl:template>


  <xsl:template match="sect5">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect5/info/title">
    <h6>
      <xsl:if test="parent::info/parent::sect5/@xml:id">
        <xsl:attribute name="id" select="parent::info/parent::sect5/@xml:id"/>
      </xsl:if>
      <xsl:apply-templates/>
    </h6>
  </xsl:template>


  <xsl:template match="figure">
    <div class="figure">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="figure/info/title | example/title">
    <h4 style="font-style:italic;">
      <xsl:apply-templates/>
    </h4>
  </xsl:template>

  <xsl:template match="mediaobject | imageobject">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="imagedata">
    <xsl:choose>
      <xsl:when test="not(contains(@fileref, 'http://'))">
        <img src="../resources/images/{@fileref}" style="display:block;"/>
      </xsl:when>
      <xsl:otherwise>
        <img src="{@fileref}" style="display:block;"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="programlisting[productname[@role = 'schema']]">
    <div class="related">
      <h4>Related Items</h4>
      <ul>
        <xsl:apply-templates/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="productname[@role = 'schema']">
    <!-- TODO: Does this capture all following adjacent xd:refs correctly? -->
    <!--<xsl:apply-templates select="following-sibling::xd:ref[count(preceding-sibling::*[name() != 'xd:ref'][position() &gt; current()/position()]) = 0]" mode="reference"/>-->
    <li>
      <a href="../models/{replace(., ':', '!')}.xhtml">Data Model - &lt;<xsl:value-of select="."/>&gt;</a>
    </li>
  </xsl:template>

  <xsl:template match="para[emphasis[starts-with(., 'Rule')]]">
    <p class="rule">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="para">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="itemizedlist">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="orderedlist">
    <ol>
      <xsl:attribute name="class">
        <xsl:text>orderedlist</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </ol>
  </xsl:template>

  <xsl:template match="listitem">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="code">
    <pre>
      <xsl:apply-templates/>
    </pre>
  </xsl:template>

  <xsl:template match="note">
    <div class="note">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="important">
    <div class="important">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="example">
    <div>
      <xsl:apply-templates select="title"/>
      <div class="example">
        <xsl:apply-templates select="*[name() != 'title']"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="emphasis[@role='italic']">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xsl:template match="emphasis[@role='bold']">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>

  <xsl:template match="emphasis[@role='bolditalic']">
    <em>
      <strong>
        <xsl:apply-templates/>
      </strong>
    </em>
  </xsl:template>

  <!--  <xsl:template match="link">
    <a href="../models/{@xlink:href}.xhtml">
      <xsl:apply-templates/>
    </a>
  </xsl:template>-->


  <xsl:template match="link">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="@xlink:href"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>


  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="*">
    <xsl:message>No template for <xsl:value-of select="name()"/> (<xsl:for-each select="ancestor::*"
          ><xsl:value-of select="name()"/>/</xsl:for-each>)</xsl:message>
  </xsl:template>

</xsl:stylesheet>
