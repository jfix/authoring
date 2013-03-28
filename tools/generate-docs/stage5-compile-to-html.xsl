<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0" xpath-default-namespace="" xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="xhtml" doctype-public="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
  
  <xsl:param name="output-folder"/>
  <xsl:param name="version"/>
  
  <xsl:key name="schemas" match="schema-ids/element" use="@id"/>
  <xsl:key name="elements-by-schema" match="doc/element" use="schemas/schema/@name"/>
  <xsl:key name="elements-by-id" match="doc/element" use="@id"/>
  <xsl:key name="elements-by-name" match="doc/element" use="@name"/>
  <xsl:key name="elements-by-type-id" match="children/element" use="@type-id"/>
  <xsl:key name="type-equivalents" match="type-equivalents/type" use="@id"/>
  <xsl:key name="doc-by-schema" match="doc" use="@schema"/>

  <xsl:variable name="links">
    <script>
               <![CDATA[
               function showHide(id){
                 var thisElement = document.getElementById(id);
                 var linkElement = document.getElementById(id+'-link');
                 if(thisElement.style.display == 'block'){
                   thisElement.style.display = 'none';
                   linkElement.innerHTML = '[+]';
                 }else{
                   thisElement.style.display = 'block';
                   linkElement.innerHTML = '[-]';
                  // var a = document.getElementsByTagName("svg:a");
                   //for(i = 0; i < a.length; i++){
                    //a[i].setAttribute('xlink:href', a[i].getAttribute('xlink:href') + "?show="+id);
                   //}
                 }
               }
               ]]>
      </script>
    <h2>Data Model</h2>
    <h5>Release <xsl:value-of select="$version"/></h5>
    <h5>
      <a href="../help/help.xhtml" target="_blank">Help (new window/tab)</a>
    </h5>
    <h5>Models:</h5>
    <ul>
      <xsl:for-each select="/docs/doc">
        <xsl:sort select="@model-name"/>
        <li>
          <a href="{@schema}-model.xhtml">
            <xsl:value-of select="@model-name"/>
          </a>
        </li>
      </xsl:for-each>
    </ul>
    <h5>All Elements:</h5>
    <ul>
      <xsl:for-each select="/docs/doc">
        <xsl:sort select="@model-name"/>
        <li>
          <a href="javascript: showHide('{generate-id()}')">
            <xsl:value-of select="@model-name"/>
          </a>
          <span id="{generate-id()}-link">[+]</span>
          <ul id="{generate-id()}" style="display:none;">
            <xsl:for-each-group select="key('elements-by-schema', @schema)" group-by="@name">
              <xsl:sort select="@name"/>
              <li>
                <a href="{replace(@name, ':', '!')}.xhtml">
                  <xsl:value-of select="@name"/>
                </a>
                <xsl:if test="count(current-group()) &gt; 1">(<xsl:value-of select="count(current-group())"
                  />)</xsl:if>
              </li>
            </xsl:for-each-group>
          </ul>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:variable>

  <xsl:template match="/">
    <outputs>
      <xsl:apply-templates/>
      <output href="{$output-folder}/help/help.xhtml">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
          <head>
            <link href="../resources/stylesheets/style.css" media="screen" rel="stylesheet" type="text/css"/>
            <title>Documentation Help</title>
          </head>
          <body>
            <div id="header">
              <h1>Documentation Help</h1>
            </div>
            <div id="content">
              <div id="left">
                <p>This documentation provides details relating to the various logical and technical data
                  models and the elements and attributes within, for the <b>OECD.Author XML Ecosystem</b>.</p>

                <p>It is important that you have an understanding of how best to navigate through this
                  documentation in order to find the information relevant to you. In order to do this, each
                  page of documentation provides information for just one specific XML element. As
                  documentation is provided for several models, it is possible that the element you are
                  looking for is used in more than one of those models; therefore, the information on the page
                  is broken down for each model which uses the element you are interested in.</p>
                <p>At the very top of the page, the name of the element is given, along with a list of the
                  models which use that element.</p>
                
                <img src="ex1.png" style="border: 1px solid #333333;"/>
                
                <p>Beneath is a section for each distinct version of the component or element, with the model
                  (or models) to which that version relates clearly shown.</p>
                
                <img src="ex2.png" style="border: 1px solid #333333;"/>
                
                <p>The information for each version shows a list of components/elements which can act as a
                  'parent' to this component/element, and if relevant with the name of the model to which that
                  parent belongs. You can click on this element name to see details of that element, and you
                  should be able to see how the child element relates to it.</p>
                
                <img src="ex3.png" style="border: 1px solid #333333;"/>
                
                <p>There may also be a diagram showing the possible child elements. You will see symbols
                  representing choices of elements and sequences of elements. The model should be read from
                  top to bottom; i.e. the first child available to this element is that nearest the top of the
                  tree. You'll also notice some elements, choices and sequences have dashed line borders,
                  indicating that they are not mandatory. They may also have numbers beneath them, indicating
                  that an element, choice or sequence can be repeated more than once.</p>
                
                <p>Rolling your mouse over any of the element names in the diagram will highlight that element
                  - by clicking on it you will be taken to the definition of the element. <strong>When you
                    click on an element in the diagram, you will be taken to the correct point in the
                    subsequent page, i.e. the correct version of that element for the model you are interested
                    in.</strong></p>
                
                <img src="ex4.png" style="border: 1px solid #333333;"/>
                
                <p>To the left of the screen is a list of all the elements available from all of the models.
                  You can use this to jump straight to an element's documentation.However, if you do this
                    <strong>be sure that you scroll to the correct version of the element as defined by the
                    model it can be used in</strong> - the quickest and easiest way to see precisely the
                  information you need is to click through from the diagram, as explained above, rather than
                  using the links on the left.</p>
                
                <p>Beneath the diagram may be a table containing a list of the attributes available to this
                  element, along with some explanations as to their use. Optional attributes are shown in
                  italics.</p>
                
                <p>Beneath the attribute details may be a list of some more specific rules which should be
                  considered for this element.</p>
                
                <p>Finally, you may find some details as to the correct usage of this element and maybe some
                  example XML.</p>
                
                <p>Please note, that in order to view this documentation you should use a browser such as
                  Firefox or Google Chrome - <strong>Internet Explorer cannot display this documentation
                    correctly</strong>.</p>
                
              </div>
              <div id="right"> </div>
            </div>
          </body>
        </html>
      </output>
    </outputs>
  </xsl:template>

  <xsl:template match="docs">
    <output href="{$output-folder}models/dm_documentation.xhtml">
      <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
        <head>
          <link href="../resources/stylesheets/style.css" media="screen" rel="stylesheet" type="text/css"/>
          <title>Model Documentation</title>
        </head>
        <body>
          <div id="header">
            <h1>Data Model</h1>
            <div id="menu"> </div>
          </div>
          <div id="content">
            <div id="left">
              <p>Documentation is provided below for the following models: <ul>
                  <xsl:for-each select="doc">
                    <xsl:sort select="@model-name"/>
                    <li><a href="{@schema}-model.xhtml"><xsl:value-of select="@model-name"/></a></li>
                  </xsl:for-each>
                </ul>
              </p>
              <p>This documentation must be viewed using a browser with inline
                SVG support (e.g. Google Chrome, Firefox, IE9).</p>
              
              <p><a style="font-size:2em; color:#ee2222; padding:0.1em" href="../help/help.xhtml"
                  target="_blank">Help is available</a> (opens in a separate window or tab).</p>
            </div>
            
            <div id="right">
              <div class="box">
                <xsl:call-template name="links"/>
              </div>
            </div>
          </div>
        </body>
      </html>
    </output>
    <xsl:apply-templates select="doc"/>
    <xsl:for-each-group select="doc/element" group-by="@name">
      <output href="{$output-folder}models/{replace(current-grouping-key(), ':', '!')}.xhtml">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
          <head>
            <link href="../resources/stylesheets/style.css" media="screen" rel="stylesheet" type="text/css"/>
            <title>Model Documentation</title>
          </head>
          <body>
            <div id="header">
              <h1>Data Model</h1>
              <div id="menu"> </div>
            </div>
            <div id="content">
              <div id="left">
                <h1>&lt;<xsl:value-of select="current-grouping-key()"/>&gt; <span class="small">- used by
                      <xsl:for-each-group
                      select="key('elements-by-name', current-grouping-key())/schemas/schema" group-by="@name"
                        ><xsl:if test="position() =
                 last() and position() != 1"
                        ><xsl:text>and </xsl:text></xsl:if><xsl:value-of
                        select="key('doc-by-schema', current-grouping-key())/@model-name"/><xsl:choose>
                        <xsl:when test="position() != last() and position() != last()-1"
                          ><xsl:text>, </xsl:text></xsl:when>
                        <xsl:when test="position() = last()"><xsl:text>.</xsl:text></xsl:when>
                        <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each-group></span></h1>
                <xsl:apply-templates select="current-group()"/>
              </div>
              <div id="right">
                <div class="box">
                  <xsl:call-template name="links"/>
                </div>
              </div>
            </div>
          </body>
        </html>
      </output>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template match="doc">
    <xsl:variable name="root" select="@root"/>
    <output href="{$output-folder}models/{@schema}-model.xhtml">
      <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
        <head>
          <link href="../resources/stylesheets/style.css" media="screen" rel="stylesheet" type="text/css"/>
          <title>Model Documentation</title>
        </head>
        <body>
          <div id="header">
            <h1>Data Model</h1>
            <div id="menu"> </div>
          </div>
          <div id="content">
            <div id="left">
              <h1>
                <xsl:value-of select="@model-name"/>
              </h1>
              <p>The <em><xsl:value-of select="@model-name"/></em> model uses the namespace
                    <strong><xsl:value-of select="@namespace"/></strong></p>
              <p>The root element is &lt;<xsl:value-of select="$root"/>&gt;.</p>
              <xsl:apply-templates select="annotation"/>
              <p><a href="../help/help.xhtml" target="_blank">Help is available</a> (opens in a separate
                window or tab).</p>
              <p>The following elements are available to the <xsl:value-of select="@model-name"/> model:</p>
              <ul>
                <xsl:for-each-group select="key('elements-by-schema', @schema)" group-by="@name">
                  <xsl:sort select="@name"/>
                  <xsl:choose>
                    <xsl:when test="@name = $root">
                      <li>
                        <strong><a href="{replace(@name, ':', '!')}.xhtml#{@type-id}"><xsl:value-of
                              select="@name"/></a> (root element)</strong>
                      </li>
                    </xsl:when>
                    <xsl:otherwise>
                      <li>
                        <a href="{replace(@name, ':', '!')}.xhtml#{@type-id}">
                          <xsl:value-of select="@name"/>
                        </a>
                        <xsl:if test="count(current-group()) &gt; 1"> (<xsl:value-of
                            select="count(current-group())"/>)</xsl:if>
                      </li>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each-group>
              </ul>
            </div>
            <div id="right">
              <div class="box">
                <xsl:call-template name="links"/>
              </div>
            </div>
          </div>
        </body>
      </html>
    </output>
  </xsl:template>

  <xsl:template match="doc/element">
    <xsl:variable name="type" select="@type"/>
    <xsl:variable name="id" select="@id"/>
    <div class="definition">
      <a id="{@type-id}"/>
      <div class="models">The following definition of <strong>&lt;<xsl:value-of
            select="current-grouping-key()"/>&gt;</strong> is used by the <xsl:for-each
          select="schemas/schema"><xsl:if test="position() =
          last() and position() != 1"
            ><xsl:text>and </xsl:text></xsl:if><em><xsl:value-of
              select="key('doc-by-schema', @name)/@model-name"/></em><xsl:choose>
            <xsl:when test="position() != last() and position() != last()-1"
              ><xsl:text>, </xsl:text></xsl:when>
            <xsl:when test="position() = last()"><xsl:text> model</xsl:text><xsl:if test="position() &gt; 1"
                ><xsl:text>s</xsl:text></xsl:if><xsl:text>.</xsl:text></xsl:when>
            <xsl:otherwise><xsl:text> </xsl:text></xsl:otherwise>
          </xsl:choose></xsl:for-each></div>
      <xsl:apply-templates select="parents"/>
      <div class="structure">
        <h3>Elements and Attributes available within <strong>&lt;<xsl:value-of select="current-grouping-key()"
            />&gt;</strong></h3>
        <xsl:if test="children/@mixed = 'true'">
          <div class="overview">This is a mixed model allowing for elements and text.</div>
        </xsl:if>
        <xsl:if test="children/@simpleContent = 'true'">
          <div class="overview">This model does not allow for any elements but allows only for text.</div>
        </xsl:if>
        <xsl:if test="children/@empty = 'true'">
          <div class="overview">This is an empty model and does not allow for any elements or text.</div>
        </xsl:if>
        <xsl:apply-templates select="diagram"/>
        <xsl:apply-templates select="children"/>
        <xsl:apply-templates select="pattern"/>
        <xsl:apply-templates select="enumeration"/>
        <xsl:apply-templates select="base"/>
        <xsl:apply-templates select="schematron-rules"/>
      </div>
      <xsl:apply-templates select="references"/>
      <xsl:apply-templates select="annotation"/>
    </div>
  </xsl:template>

  <xsl:template match="diagram">
    <div class="diagram">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="svg:*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="svg:a">
    <xsl:variable name="rect" select="preceding-sibling::svg:rect[1]"/>
    <xsl:copy>
      <xsl:copy-of select="@*[name() != 'xlink:href']"/>
      <xsl:attribute name="xlink:href"
        select="concat(replace(svg:text/text(), ':', '!'), '.xhtml#', @xlink:href)"/>
      <xsl:attribute name="onmouseover">document.getElementById('<xsl:value-of select="$rect/@id"
        />').setAttribute('style', '<xsl:value-of select="replace($rect/@style,
        'white', '#eedddd')"
        />')</xsl:attribute>
      <xsl:attribute name="onmouseout">document.getElementById('<xsl:value-of select="$rect/@id"
        />').setAttribute('style', '<xsl:value-of select="$rect/@style"/>')</xsl:attribute>
      <xsl:attribute name="onclick">document.getElementById('<xsl:value-of select="$rect/@id"
        />').setAttribute('style', '<xsl:value-of select="$rect/@style"/>')</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="children">
    <!-- Removing this as linking from SVG is working instead... -->
    <!--<xsl:if test="element">
      <table width="98%" cellpadding="0" cellspacing="0">
        <tr>
          <th>Element</th>
          <th>Notes</th>
        </tr>
        <xsl:apply-templates select="element"/>
      </table>
    </xsl:if>-->
    <xsl:if test="attribute">
      <table width="98%" cellpadding="0" cellspacing="0">
        <tr>
          <th>Attribute</th>
          <th>Content</th>
          <th>Notes</th>
        </tr>
        <xsl:apply-templates select="attribute"/>
        <tr>
          <td colspan="3" style="font-weight:bold">Attributes in italics are optional.</td>
        </tr>
      </table>
    </xsl:if>
  </xsl:template>

  <xsl:template match="children/element">
    <tr>
      <td width="20%" valign="top">
        <a href="{replace(@name, ':', '!')}.xhtml#{@type-id}">&lt;<xsl:value-of select="@name"/>&gt;</a>
      </td>
      <td valign="top">
        <xsl:apply-templates/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="attribute">
    <xsl:message>
      <xsl:copy/>
    </xsl:message>
    <tr>
      <td width="20%" valign="top">
        <xsl:if test="not(@use = 'required')">
          <xsl:attribute name="style">font-style: italic;</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="@name"/>
      </td>
      <td width="40%" valign="top">
        <xsl:apply-templates select="description"/>
      </td>
      <td valign="top">
        <xsl:apply-templates select="annotation"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="description">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="pattern">
    <div>Allows content according to the following pattern:<br/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="enumeration">
    <div>Allows for any of the following specific values: <ul>
        <xsl:apply-templates/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="enumeration/value">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="base">
    <xsl:choose>
      <xsl:when test="empty(*)">
        <div>Allows for content defined as 'string'.</div>
      </xsl:when>
      <xsl:otherwise>
        <div>Allows for content defined as '<xsl:apply-templates/>'.</div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="annotation">
    <div class="annotation">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="annotation/section">
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="section/title">
    <h3>
      <xsl:apply-templates/>
    </h3>
  </xsl:template>

  <xsl:template match="p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="note">
    <div class="note">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="warning">
    <div class="warning">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="strong">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>

  <xsl:template match="source">
    <pre>
      <xsl:apply-templates/>
    </pre>
  </xsl:template>

  <xsl:template match="figure">
    <img src="{@src}" style="display:block; padding:1em; border: 1px solid #999999;"/>
  </xsl:template>

  <xsl:template match="a">
    <a href="{@href}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="table">
    <table>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="tr">
    <tr>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="td">
    <td>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match="ul">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>

  <xsl:template match="li">
    <li>
      <xsl:apply-templates/>
    </li>

  </xsl:template>

  <xsl:template match="schematron-rules">
    <xsl:if test="rule">
      <div class="rules">
        <h4>The following specific rules also apply:</h4>
        <ul>
          <xsl:apply-templates/>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rule">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <xsl:template match="schema-ids"/>
  <xsl:template match="type-equivalents"/>

  <xsl:template match="parents">
    <xsl:if test="*">
      <div class="parents">This version of the <strong>&lt;<xsl:value-of select="current-grouping-key()"
          />&gt;</strong> element is applicable when used as a child to the following elements: <ul>
          <xsl:apply-templates/>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="parent">
    <li>
      <a href="{replace(@name, ':', '!')}.xhtml#{@type-id}">&lt;<xsl:value-of select="@name"/>&gt;</a>
      <span class="parent-model">
        <xsl:for-each select="schema">
          <xsl:if test="position() = 1">
            <xsl:text> (</xsl:text>
          </xsl:if>
          <em>
            <xsl:value-of select="key('doc-by-schema', @name)/@model-name"/>
          </em>
          <xsl:choose>
            <xsl:when test="not(following-sibling::*)">
              <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise>, </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </span>
    </li>
  </xsl:template>

  <xsl:template match="references[link[path-item[1] != 'Data Model Release Notes']]">
    <div class="related">
      <h3>Related information:</h3>
      <ul>
        <xsl:apply-templates select="link[path-item[1] != 'Data Model Release Notes']"/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="references/link[path-item[1] != 'Data Model Release Notes']">
    <li>
      <a href="../{@id}">
        <xsl:for-each select="path-item">
          <xsl:value-of select="."/>
          <xsl:if test="following-sibling::path-item"> -> </xsl:if>
        </xsl:for-each>
      </a>
    </li>
  </xsl:template>

  <xsl:template match="references[not(link[path-item[1] != 'Data Model Release Notes'])]"/>

  <xsl:template match="references[link[path-item[1] = 'Data Model Release Notes']]">
    <div class="history">
      <h3>
        <a href="javascript:showHide('{generate-id()}')">Model history <span id="{generate-id()}-link"
            >[+]</span></a>
      </h3>
      <div id="{generate-id()}" style="display:none;">
        <ul>
          <xsl:apply-templates select="link[path-item[1] = 'Data Model Release Notes']"/>
        </ul>
      </div>
    </div>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="references/link[path-item[1] = 'Data Model Release Notes']">
    <li>
      <a href="../{@id}">
        <xsl:for-each select="path-item">
          <xsl:value-of select="."/>
          <xsl:if test="following-sibling::path-item"> -> </xsl:if>
        </xsl:for-each>
      </a>
    </li>
  </xsl:template>

  <xsl:template name="links">
    <xsl:copy-of select="$links"/>
  </xsl:template>

</xsl:stylesheet>
