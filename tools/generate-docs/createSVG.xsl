<?xml version="1.0"?>
<xsl:stylesheet version="2.0" xmlns:xd="http://www.oecd.org/ns/schema/xdocs"
  xmlns:svg="http://www.w3.org/2000/svg" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
  extension-element-prefixes="saxon" exclude-result-prefixes="xd">

  <xsl:variable name="stroke-width" select="1"/>

  <!--
	Notes: Development version. Generates site.xml, tabs.xml, a folder named 'model' containing xdoc formatted xml for each simplex/simple Type defined,
            and adds an svg file for each complexType defined.
-->



  <xsl:template match="xs:complexType" mode="buildSvg">
    <xsl:param name="file-name"/>
    <xsl:param name="element-name"/>
    <xsl:param name="this-schema"/>
    <!--calculate width for viewBox-->
    <xsl:variable name="viewBox-width">
      <xsl:for-each select="descendant::xs:element">
        <!--complicated sort calculation works out which element will extend furthest to the right when displayed-->
        <xsl:sort
          select="(count(ancestor::xs:choice) + count(ancestor::xs:sequence)) * 57 + string-length(ancestor::xs:element/@name) * 7 + string-length(ancestor::xs:complexType/@name) * 7 + count(ancestor::xs:element) * 20 + count(ancestor::xs:complexType) * 20 + (string-length(@name) * 7) + (count(ancestor::xs:complexType/descendant::xs:element[@maxOccurs='unbounded']) * 4)"
          data-type="number" order="descending"/>
        <xsl:if test="position()=1">
          <xsl:value-of
            select="(count(ancestor::xs:choice) + count(ancestor::xs:sequence)) * 57 + string-length(ancestor::xs:element/@name) * 7 + string-length(ancestor::xs:complexType/@name) * 7 + count(ancestor::xs:element) * 20 + count(ancestor::xs:complexType) * 20 + (string-length(@name) * 7) + 20 + (count(ancestor::xs:complexType/descendant::xs:element[@maxOccurs='unbounded']) * 4)"
          />
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <!--calculate height for viewBox-->
    <xsl:variable name="viewBox-height">
      <xsl:variable name="element-count" select="count(descendant::xs:element) + 1"/>
      <xsl:variable name="infinity-count">
        <xsl:value-of select="count(descendant::xs:element[@maxOccurs='unbounded'])"/>
      </xsl:variable>
      <xsl:value-of select="($element-count * 37) + ($infinity-count * 20)"/>
    </xsl:variable>

    <!-- calculates height and width from viewbox variables above, downsizing if the height is greater than 500 (otherwise it breaks the pdf) - REMOVED as PDF not currently required. -->
    <xsl:variable name="height">
      <!--   <xsl:choose>
        <xsl:when test="number($viewBox-height) &gt; 500">
          <xsl:text>500</xsl:text>
        </xsl:when>
        <xsl:otherwise>-->
      <xsl:value-of select="$viewBox-height"/>
      <!--
        </xsl:otherwise>
      </xsl:choose>-->
    </xsl:variable>
    <xsl:variable name="width">
      <!-- <xsl:choose>
        <xsl:when test="number($viewBox-height) &gt; 500">
          <xsl:value-of select="floor($viewBox-width div $viewBox-height * 500)"/>
        </xsl:when>
        <xsl:otherwise>-->
      <xsl:value-of select="$viewBox-width"/>
      <!--
        </xsl:otherwise>
      </xsl:choose>-->
    </xsl:variable>

    <!--<xsl:result-document href="{$file-name}" xmlns="http://www.w3.org/2000/svg">-->
    <!-- Removed attributes in line below 'cos docbook doesn't like them - they're only really for PDF output... -->
    <!--<svg:svg xmlns:svg="http://www.w3.org/2000/svg" version="1.1" height="{$height}" width="{$width}" pngheight="{$viewBox-height}" pngwidth="{$viewBox-width}">-->
    <svg:svg xmlns:svg="http://www.w3.org/2000/svg" version="1.1" height="{$height}" width="{$width}">
      <xsl:attribute name="viewBox">
        <xsl:value-of select="concat('-5 -5 ',number($viewBox-width) + 10,' ',number($viewBox-height) + 10)"/>
      </xsl:attribute>
      <!--use rectangle to set background colour-->
      <svg:rect x="-5" y="-5" style="fill:lightgoldenrodyellow">
        <xsl:attribute name="width">
          <xsl:value-of select="number($viewBox-width) + 10"/>
        </xsl:attribute>
        <xsl:attribute name="height">
          <xsl:value-of select="number($viewBox-height) + 10"/>
        </xsl:attribute>
      </svg:rect>
      <xsl:apply-templates select="." mode="svg">
        <xsl:with-param name="element-name" select="$element-name"/>
        <xsl:with-param name="this-schema" select="$this-schema"/>
      </xsl:apply-templates>
    </svg:svg>
    <!--</xsl:result-document>-->
  </xsl:template>

  <xsl:template match="xs:sequence | xs:choice | xs:all | xs:element | xs:complexType" mode="svg">
    <xsl:param name="this-schema"/>
    <xsl:param name="xpos" select="number(0)"/>
    <xsl:param name="ypos" select="number(0)"/>
    <xsl:param name="element-name"/>
    <xsl:variable name="complexType" select="ancestor-or-self::xs:complexType"/>
    <!--variable used to give a dashed line when @minOccurs='0'-->
    <xsl:variable name="stroke-dasharray">
      <xsl:choose>
        <xsl:when test="@minOccurs='0'">
          <xsl:text>stroke-dasharray:3,3;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>stroke-dasharray:none;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--variable used to alter display when @maxOccurs='unbounded'-->
    <xsl:variable name="infinite">
      <xsl:choose>
        <xsl:when test="@maxOccurs='unbounded'">
          <xsl:text>yes</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>no</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!--if the current node is the child of an element, need to draw a connecting line between them-->
    <xsl:if test="parent::xs:element | parent::xs:complexType">
      <xsl:variable name="path-start">
        <xsl:value-of select="concat('M',$xpos - 10,' ',$ypos + 17)"/>
      </xsl:variable>
      <xsl:variable name="path-line" select="'h10'"/>
      <svg:path>
        <xsl:attribute name="d">
          <xsl:value-of select="concat($path-start,' ',$path-line)"/>
        </xsl:attribute>
        <xsl:attribute name="style">
          <xsl:value-of select="concat('stroke:black;stroke-width:',$stroke-width,';fill-opacity:0')"/>
        </xsl:attribute>
      </svg:path>
    </xsl:if>
    <xsl:choose>
      <!--current node is an element-->
      <xsl:when test="name()='xs:element' or name() = 'xs:complexType'">
        <xsl:variable name="rect-width" select="(string-length(@name) * 7) + 10"/>
        <xsl:variable name="rect-height" select="26"/>
        <xsl:variable name="fill-colour">
          <xsl:text>white</xsl:text>
          <!--					<xsl:choose>
						<xsl:when test="@minOccurs='0'">
							<xsl:text>rgb(255,127,127)</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>rgb(255,0,0)</xsl:text>
						</xsl:otherwise>
					</xsl:choose>-->
        </xsl:variable>
        <!--Indicate if maxOccurs="unbounded" (code-block 1 of 2)-->
        <xsl:if test="$infinite='yes'">
          <svg:rect>
            <xsl:attribute name="width">
              <xsl:value-of select="$rect-width"/>
            </xsl:attribute>
            <xsl:attribute name="height">
              <xsl:value-of select="$rect-height"/>
            </xsl:attribute>
            <xsl:attribute name="style">
              <xsl:value-of
                select="concat($stroke-dasharray,'fill:',$fill-colour,';stroke:black;stroke-width:',$stroke-width)"
              />
            </xsl:attribute>
            <xsl:attribute name="x">
              <xsl:value-of select="$xpos + 4"/>
            </xsl:attribute>
            <xsl:attribute name="y">
              <xsl:value-of select="$ypos + 4 + 4"/>
            </xsl:attribute>
          </svg:rect>
        </xsl:if>
        <!--display element graphics-->
        <xsl:variable name="element-type-id">
          <xsl:if test="name() = 'xs:element'">
            <xsl:choose>
              <xsl:when test="starts-with(@type, 'xs:')">
                <xsl:value-of select="generate-id()"/>
              </xsl:when>
              <xsl:when
                test="count(key('complexTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1]) != 0">
                <xsl:value-of
                  select="generate-id(key('complexTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1])"
                />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="generate-id(key('simpleTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1])"
                />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:variable>
        <svg:rect>
          <xsl:attribute name="width">
            <xsl:value-of select="$rect-width"/>
          </xsl:attribute>
          <xsl:attribute name="height">
            <xsl:value-of select="$rect-height"/>
          </xsl:attribute>
          <xsl:attribute name="style">
            <xsl:value-of
              select="concat($stroke-dasharray,'fill:',$fill-colour,';stroke:black;stroke-width:',$stroke-width)"
            />
          </xsl:attribute>
          <xsl:attribute name="x">
            <xsl:value-of select="$xpos"/>
          </xsl:attribute>
          <xsl:attribute name="y">
            <xsl:value-of select="$ypos + 4"/>
          </xsl:attribute>
          <xsl:if test="$element-type-id != ''">
            <xsl:attribute name="id" select="concat('rect-', generate-id())"/>
          </xsl:if>
        </svg:rect>
        <xsl:choose>
          <xsl:when test="name() = 'xs:complexType'">
            <svg:text>
              <xsl:attribute name="text-anchor">
                <xsl:text>middle</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="x">
                <xsl:value-of select="$xpos + ($rect-width div 2)"/>
              </xsl:attribute>
              <xsl:attribute name="y">
                <xsl:value-of select="$ypos + 20"/>
              </xsl:attribute>
              <xsl:value-of select="$element-name"/>
            </svg:text>
          </xsl:when>
          <xsl:otherwise>
            <!-- Add some linking if it's a child element... -->
            <svg:a xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$element-type-id}"
              xlink:type="simple">
              <svg:text>
                <xsl:attribute name="text-anchor">
                  <xsl:text>middle</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="x">
                  <xsl:value-of select="$xpos + ($rect-width div 2)"/>
                </xsl:attribute>
                <xsl:attribute name="y">
                  <xsl:value-of select="$ypos + 20"/>
                </xsl:attribute>
                <xsl:value-of select="@name"/>
              </svg:text>
            </svg:a>
          </xsl:otherwise>
        </xsl:choose>
        <!--Indicate if maxOccurs="unbounded" (code-block 2 of 2)-->
        <xsl:if test="$infinite='yes'">
          <xsl:variable name="min">
            <xsl:choose>
              <xsl:when test="not(@minOccurs)">
                <xsl:text>1</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@minOccurs"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <svg:path>
            <xsl:attribute name="d">
              <xsl:value-of
                select="concat('M',$xpos + $rect-width - 15,' ',$ypos + 4 + $rect-height,' l5 10 l2.5 -6')"/>
            </xsl:attribute>
            <xsl:attribute name="style">
              <xsl:value-of select="concat('stroke:black;fill-opacity:0;stroke-width:',$stroke-width)"/>
            </xsl:attribute>
          </svg:path>
          <svg:text>
            <xsl:attribute name="text-anchor">
              <xsl:text>start</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="x">
              <xsl:value-of select="$xpos + $rect-width - 20"/>
            </xsl:attribute>
            <xsl:attribute name="y">
              <xsl:value-of select="$ypos + 4 + $rect-height + 17"/>
            </xsl:attribute>
            <xsl:value-of select="concat($min,'..&#x221E;')"/>
            <!--not the best way of getting an infinity sign, but will do for the moment?-->
            <!--<svg:tspan rotate="270" dx="10">8</svg:tspan>-->
          </svg:text>
        </xsl:if>
        <!--display child nodes-->
        <xsl:for-each select="*[name()='xs:sequence' or name()='xs:choice']">
          <!--variables $tree-position and $infinity-indicators are used to calculate the position on the y-axis of the next node-->
          <xsl:variable name="tree-position">
            <xsl:value-of
              select="count(preceding::xs:element[generate-id(ancestor::xs:complexType) = generate-id($complexType)] | ancestor::xs:complexType) + count(ancestor::xs:element)"
            />
          </xsl:variable>
          <xsl:variable name="infinity-indicators">
            <xsl:value-of
              select="count(preceding::xs:element[generate-id(ancestor::xs:complexType) = generate-id($complexType)][@maxOccurs='unbounded'])"
            />
          </xsl:variable>
          <!--draw vertical line to connect child elements-->
          <xsl:if test="not(position()= 1) and position()=last()">
            <svg:path>
              <xsl:attribute name="d">
                <!--                <xsl:value-of select="concat('M',$xpos + 52,' ',$ypos + 17,' h10 V',($tree-position * 37) + 2 + 15 + ($infinity-indicators * 10))"/>-->
                <xsl:value-of
                  select="concat('M',$xpos + $rect-width,' ',$ypos + 17,' h10 V',($tree-position * 37) + 2 + 15 + ($infinity-indicators * 10))"
                />
              </xsl:attribute>
              <xsl:attribute name="style">
                <xsl:value-of
                  select="concat($stroke-dasharray,'stroke:black;fill-opacity:0;stroke-width:',$stroke-width)"
                />
              </xsl:attribute>
            </svg:path>
          </xsl:if>
          <xsl:choose>
            <xsl:when
              test="position()=1 and position()=last() and (name()='xs:choice' or name()='xs:sequence')">
              <!--if a choice or sequence is the first child of its parent, then it should be displayed immediately to the right of the parent-->
              <xsl:apply-templates select="." mode="svg">
                <xsl:with-param name="xpos" select="$xpos + $rect-width + 10"/>
                <xsl:with-param name="ypos" select="(($tree-position - 1) * 37) + ($infinity-indicators * 10)"/>
                <xsl:with-param name="this-schema" select="$this-schema"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="." mode="svg">
                <xsl:with-param name="xpos" select="$xpos + $rect-width + 10 + 10"/>
                <xsl:with-param name="ypos" select="($tree-position * 37) + ($infinity-indicators * 10)"/>
                <xsl:with-param name="this-schema" select="$this-schema"/>
              </xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <!--current node is a choice-->
      <xsl:when test="name()='xs:choice'">
        <!--display choice graphic-->
        <xsl:call-template name="choice-graphic">
          <xsl:with-param name="start-point-x" select="$xpos"/>
          <xsl:with-param name="start-point-y" select="$ypos + 17"/>
          <xsl:with-param name="stroke-dasharray" select="$stroke-dasharray"/>
        </xsl:call-template>
        <svg:path>
          <xsl:attribute name="d">
            <xsl:value-of select="concat('M',$xpos + 37,' ',$ypos + 17,' h10')"/>
          </xsl:attribute>
          <xsl:attribute name="style">
            <xsl:value-of
              select="concat($stroke-dasharray,'stroke:black;fill-opacity:0;stroke-width:',$stroke-width)"/>
          </xsl:attribute>
        </svg:path>
        <xsl:for-each select="*">
          <xsl:variable name="tree-position">
            <xsl:value-of
              select="count(preceding::xs:element[generate-id(ancestor::xs:complexType) = generate-id($complexType)] | ancestor::xs:complexType) + count(ancestor::xs:element)"
            />
          </xsl:variable>
          <xsl:variable name="infinity-indicators">
            <xsl:value-of
              select="count(preceding::xs:element[generate-id(ancestor::xs:complexType) = generate-id($complexType)][@maxOccurs='unbounded'])"
            />
          </xsl:variable>
          <svg:path>
            <xsl:attribute name="d">
              <xsl:value-of
                select="concat('M',$xpos + 47,' ',($tree-position * 37) + 2 + 15 + ($infinity-indicators * 10),' h10')"
              />
            </xsl:attribute>
            <xsl:attribute name="style">
              <xsl:value-of
                select="concat($stroke-dasharray,'stroke:black;fill-opacity:0;stroke-width:',$stroke-width)"/>
            </xsl:attribute>
          </svg:path>
          <xsl:if test="position()=last()">
            <svg:path>
              <xsl:attribute name="d">
                <xsl:value-of
                  select="concat('M',$xpos + 47,' ',$ypos + 17,' V',($tree-position * 37) + 2 + 15 + ($infinity-indicators * 10))"
                />
              </xsl:attribute>
              <xsl:attribute name="style">
                <xsl:value-of
                  select="concat($stroke-dasharray,'stroke:black;fill-opacity:0;stroke-width:',$stroke-width)"
                />
              </xsl:attribute>
            </svg:path>
          </xsl:if>
          <!--display child nodes-->
          <xsl:apply-templates select="." mode="svg">
            <xsl:with-param name="xpos" select="$xpos + 37 + 20"/>
            <xsl:with-param name="ypos" select="($tree-position * 37) + ($infinity-indicators * 10)"/>
            <xsl:with-param name="this-schema" select="$this-schema"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:when>
      <!--current node is a sequence-->
      <xsl:when test="name()='xs:sequence'">
        <!--display sequence graphic-->
        <xsl:call-template name="sequence-graphic">
          <xsl:with-param name="start-point-x" select="$xpos"/>
          <xsl:with-param name="start-point-y" select="$ypos + 17"/>
          <xsl:with-param name="stroke-dasharray" select="$stroke-dasharray"/>
        </xsl:call-template>
        <svg:path>
          <xsl:attribute name="d">
            <xsl:value-of select="concat('M',$xpos + 37,' ',$ypos + 17,' h10')"/>
          </xsl:attribute>
          <xsl:attribute name="style">
            <xsl:value-of
              select="concat($stroke-dasharray,'stroke:black;fill-opacity:0;stroke-width:',$stroke-width)"/>
          </xsl:attribute>
        </svg:path>
        <xsl:for-each select="*">
          <xsl:variable name="tree-position">
            <xsl:value-of
              select="count(preceding::xs:element[generate-id(ancestor::xs:complexType) = generate-id($complexType)] | ancestor::xs:complexType) + count(ancestor::xs:element)"
            />
          </xsl:variable>
          <xsl:variable name="infinity-indicators">
            <xsl:value-of
              select="count(preceding::xs:element[generate-id(ancestor::xs:complexType) = generate-id($complexType)][@maxOccurs='unbounded'])"
            />
          </xsl:variable>
          <svg:path>
            <xsl:attribute name="d">
              <xsl:value-of
                select="concat('M',$xpos + 47,' ',($tree-position * 37) + 2 + 15 + ($infinity-indicators * 10),' h10')"
              />
            </xsl:attribute>
            <xsl:attribute name="style">
              <xsl:value-of
                select="concat($stroke-dasharray,'stroke:black;fill-opacity:0;stroke-width:',$stroke-width)"/>
            </xsl:attribute>
          </svg:path>
          <xsl:if test="position()=last()">
            <svg:path>
              <xsl:attribute name="d">
                <xsl:value-of
                  select="concat('M',$xpos + 47,' ',$ypos + 17,' V',($tree-position * 37) + 2 + 15 + ($infinity-indicators * 10))"
                />
              </xsl:attribute>
              <xsl:attribute name="style">
                <xsl:value-of
                  select="concat($stroke-dasharray,'stroke:black;fill-opacity:0;stroke-width:',$stroke-width)"
                />
              </xsl:attribute>
            </svg:path>
          </xsl:if>
          <!--display child nodes-->
          <xsl:apply-templates select="." mode="svg">
            <xsl:with-param name="xpos" select="$xpos + 37 + 20"/>
            <xsl:with-param name="ypos" select="($tree-position * 37) + ($infinity-indicators * 10)"/>
            <xsl:with-param name="this-schema" select="$this-schema"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="sequence-graphic">
    <!--template used to draw sequence graphic-->
    <xsl:param name="start-point-x"/>
    <xsl:param name="start-point-y"/>
    <xsl:param name="stroke-dasharray"/>
    <xsl:variable name="polygon-path">
      <xsl:text>M</xsl:text>
      <xsl:value-of select="concat($start-point-x,' ',$start-point-y)"/>
      <xsl:text>l0 -4 l6 -6 l25 0 l6 6 l0 8 l-6 6 l-25 0 l-6 -6 l0 -4</xsl:text>
    </xsl:variable>
    <xsl:variable name="unbounded-polygon-path">
      <xsl:text>M</xsl:text>
      <xsl:value-of select="concat($start-point-x + 4,' ',$start-point-y + 4)"/>
      <xsl:text>l0 -4 l6 -6 l25 0 l6 6 l0 8 l-6 6 l-25 0 l-6 -6 l0 -4</xsl:text>
    </xsl:variable>
    <xsl:variable name="inside-path">
      <xsl:text>M</xsl:text>
      <xsl:value-of select="concat($start-point-x + 6,' ',$start-point-y,' l25 0')"/>
    </xsl:variable>
    <!--Indicate if maxOccurs="unbounded" (code-block 1 of 2)-->
    <xsl:if test="@maxOccurs='unbounded'">
      <svg:path>
        <xsl:attribute name="d">
          <xsl:value-of select="$unbounded-polygon-path"/>
        </xsl:attribute>
        <xsl:attribute name="style">
          <xsl:value-of
            select="concat($stroke-dasharray,'fill:white;stroke:black;stroke-width:',$stroke-width)"/>
        </xsl:attribute>
      </svg:path>
    </xsl:if>
    <!--polygonal frame of graphic-->
    <svg:path>
      <xsl:attribute name="d">
        <xsl:value-of select="$polygon-path"/>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of
          select="concat('fill:white;',$stroke-dasharray,'stroke:black;stroke-width:',$stroke-width)"/>
      </xsl:attribute>
    </svg:path>
    <!--inside polygonal frame-->
    <svg:path>
      <xsl:attribute name="d">
        <xsl:value-of select="$inside-path"/>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of select="concat('stroke:black;fill-opacity:0;stroke-width:',$stroke-width)"/>
      </xsl:attribute>
    </svg:path>
    <svg:rect>
      <xsl:attribute name="x">
        <xsl:value-of select="$start-point-x + 11"/>
      </xsl:attribute>
      <xsl:attribute name="y">
        <xsl:value-of select="$start-point-y - 1.5"/>
      </xsl:attribute>
      <xsl:attribute name="width">
        <xsl:text>1.5</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:text>3</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of select="concat('stroke:black;stroke-width:',$stroke-width)"/>
      </xsl:attribute>
    </svg:rect>
    <svg:rect>
      <xsl:attribute name="x">
        <xsl:value-of select="$start-point-x + 11 + 6.5"/>
      </xsl:attribute>
      <xsl:attribute name="y">
        <xsl:value-of select="$start-point-y - 1.5"/>
      </xsl:attribute>
      <xsl:attribute name="width">
        <xsl:text>1.5</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:text>3</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of select="concat('stroke:black;stroke-width:',$stroke-width)"/>
      </xsl:attribute>
    </svg:rect>
    <svg:rect>
      <xsl:attribute name="x">
        <xsl:value-of select="$start-point-x + 11 + 6.5 + 6.5"/>
      </xsl:attribute>
      <xsl:attribute name="y">
        <xsl:value-of select="$start-point-y - 1.5"/>
      </xsl:attribute>
      <xsl:attribute name="width">
        <xsl:text>1.5</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:text>3</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of select="concat('stroke:black;stroke-width:',$stroke-width)"/>
      </xsl:attribute>
    </svg:rect>
    <!--Indicate if maxOccurs="unbounded" (code-block 2 of 2)-->
    <xsl:if test="@maxOccurs='unbounded'">
      <xsl:variable name="min">
        <xsl:choose>
          <xsl:when test="not(@minOccurs)">
            <xsl:text>1</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@minOccurs"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <svg:path>
        <xsl:attribute name="d">
          <xsl:value-of select="concat('M',$start-point-x + 20,' ',$start-point-y + 10,' l5 10 l2.5 -6')"/>
        </xsl:attribute>
        <xsl:attribute name="style">
          <xsl:value-of select="concat('stroke:black;fill-opacity:0;stroke-width:',$stroke-width)"/>
        </xsl:attribute>
      </svg:path>
      <svg:text>
        <xsl:attribute name="text-anchor">
          <xsl:text>start</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="x">
          <xsl:value-of select="$start-point-x + 15"/>
        </xsl:attribute>
        <xsl:attribute name="y">
          <xsl:value-of select="$start-point-y + 10 + 17"/>
        </xsl:attribute>
        <xsl:value-of select="concat($min,'..&#x221E;')"/>
        <!--not the best way of getting an infinity sign, but will do for the moment?-->
        <!--<svg:tspan rotate="270" dx="10">8</svg:tspan>-->
      </svg:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="choice-graphic">
    <!--template used to draw choice graphic-->
    <xsl:param name="start-point-x"/>
    <xsl:param name="start-point-y"/>
    <xsl:param name="stroke-dasharray"/>
    <xsl:variable name="polygon-path">
      <xsl:text>M</xsl:text>
      <xsl:value-of select="concat($start-point-x,' ',$start-point-y)"/>
      <xsl:text>l0 -4 l6 -6 l25 0 l6 6 l0 8 l-6 6 l-25 0 l-6 -6 l0 -4</xsl:text>
    </xsl:variable>
    <xsl:variable name="unbounded-polygon-path">
      <xsl:text>M</xsl:text>
      <xsl:value-of select="concat($start-point-x + 4,' ',$start-point-y + 4)"/>
      <xsl:text>l0 -4 l6 -6 l25 0 l6 6 l0 8 l-6 6 l-25 0 l-6 -6 l0 -4</xsl:text>
    </xsl:variable>
    <xsl:variable name="inside-path">
      <xsl:text>M</xsl:text>
      <xsl:value-of select="concat($start-point-x + 6,' ',$start-point-y)"/>
      <xsl:text>l5 0 l5 -5</xsl:text>
    </xsl:variable>
    <xsl:variable name="inside-path2">
      <xsl:text>M</xsl:text>
      <xsl:value-of select="concat($start-point-x + 19 + 3.5,' ',$start-point-y - 6.5 + 1)"/>
      <xsl:text>l5 0 l0 10 l-5 0</xsl:text>
    </xsl:variable>
    <xsl:variable name="inside-path3">
      <xsl:text>M</xsl:text>
      <xsl:value-of select="concat($start-point-x + 19 + 3.5,' ',$start-point-y)"/>
      <xsl:text>l10 0</xsl:text>
    </xsl:variable>
    <!--Indicate if maxOccurs="unbounded" (code-block 1 of 2)-->
    <xsl:if test="@maxOccurs='unbounded'">
      <svg:path>
        <xsl:attribute name="d">
          <xsl:value-of select="$unbounded-polygon-path"/>
        </xsl:attribute>
        <xsl:attribute name="style">
          <xsl:value-of
            select="concat($stroke-dasharray,'fill:white;stroke:black;stroke-width:',$stroke-width)"/>
        </xsl:attribute>
      </svg:path>
    </xsl:if>
    <!--polygonal frame of graphic-->
    <svg:path>
      <xsl:attribute name="d">
        <xsl:value-of select="$polygon-path"/>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of select="concat($stroke-dasharray,'fill:white;stroke:black;stroke-width:',$stroke-width)"
        />
      </xsl:attribute>
    </svg:path>
    <!--inside polygonal frame-->
    <svg:path>
      <xsl:attribute name="d">
        <xsl:value-of select="$inside-path"/>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of select="concat('fill-opacity:0;stroke:black;stroke-width:',$stroke-width)"/>
      </xsl:attribute>
    </svg:path>
    <svg:rect>
      <xsl:attribute name="x">
        <xsl:value-of select="$start-point-x + 19"/>
      </xsl:attribute>
      <xsl:attribute name="y">
        <xsl:value-of select="$start-point-y - 6.5"/>
      </xsl:attribute>
      <xsl:attribute name="width">
        <xsl:text>1.5</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:text>2</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of select="concat('fill-opacity:0;stroke:black;stroke-width:',$stroke-width)"/>
      </xsl:attribute>
    </svg:rect>
    <svg:rect>
      <xsl:attribute name="x">
        <xsl:value-of select="$start-point-x + 19"/>
      </xsl:attribute>
      <xsl:attribute name="y">
        <xsl:value-of select="$start-point-y - 1.5"/>
      </xsl:attribute>
      <xsl:attribute name="width">
        <xsl:text>1.5</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:text>2</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of select="concat('fill-opacity:0;stroke:black;stroke-width:',$stroke-width)"/>
      </xsl:attribute>
    </svg:rect>
    <svg:rect>
      <xsl:attribute name="x">
        <xsl:value-of select="$start-point-x + 19"/>
      </xsl:attribute>
      <xsl:attribute name="y">
        <xsl:value-of select="$start-point-y + 3.5"/>
      </xsl:attribute>
      <xsl:attribute name="width">
        <xsl:text>1.5</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="height">
        <xsl:text>2</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of select="concat('fill-opacity:0;stroke:black;stroke-width:',$stroke-width)"/>
      </xsl:attribute>
    </svg:rect>
    <svg:path>
      <xsl:attribute name="d">
        <xsl:value-of select="$inside-path2"/>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of select="concat('fill-opacity:0;stroke:black;stroke-width:',$stroke-width)"/>
      </xsl:attribute>
    </svg:path>
    <svg:path>
      <xsl:attribute name="d">
        <xsl:value-of select="$inside-path3"/>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of select="concat('fill-opacity:0;stroke:black;stroke-width:',$stroke-width)"/>
      </xsl:attribute>
    </svg:path>
    <!--Indicate if maxOccurs="unbounded" (code-block 2 of 2)-->
    <xsl:if test="@maxOccurs='unbounded'">
      <xsl:variable name="min">
        <xsl:choose>
          <xsl:when test="not(@minOccurs)">
            <xsl:text>1</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@minOccurs"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <svg:path>
        <xsl:attribute name="d">
          <xsl:value-of select="concat('M',$start-point-x + 20,' ',$start-point-y + 10,' l5 10 l2.5 -6')"/>
        </xsl:attribute>
        <xsl:attribute name="style">
          <xsl:value-of select="concat('stroke:black;fill-opacity:0;stroke-width:',$stroke-width)"/>
        </xsl:attribute>
      </svg:path>
      <svg:text>
        <xsl:attribute name="text-anchor">
          <xsl:text>start</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="x">
          <xsl:value-of select="$start-point-x + 15"/>
        </xsl:attribute>
        <xsl:attribute name="y">
          <xsl:value-of select="$start-point-y + 10 + 17"/>
        </xsl:attribute>
        <xsl:value-of select="concat($min,'..&#x221E;')"/>
        <!--not the best way of getting an infinity sign, but will do for the moment?-->
        <!--<svg:tspan rotate="270" dx="10">8</svg:tspan>-->
      </svg:text>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
