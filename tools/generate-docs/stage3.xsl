<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oecd.org/ns/schema/xdocs"
  xmlns:saxon="http://saxon.sf.net/" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  extension-element-prefixes="saxon" exclude-result-prefixes="sch">
  
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>
  
  <xsl:strip-space elements="*"/>
  <xsl:param name="debug">false</xsl:param>
  <xsl:param name="output-folder">file:///C:/Documents and Settings/crowther_j/Desktop/images/</xsl:param>
  <xsl:variable name="captured" saxon:assignable="yes">
    <captured/>
  </xsl:variable>
  <xsl:variable name="nodes-by-schema" saxon:assignable="yes"/>
  <xsl:variable name="identical" saxon:assignable="yes"/>
  <xsl:variable name="type-equivalent" saxon:assignable="yes"/>

  <xsl:include href="createSVG.xsl"/>

  <xsl:key name="complexTypes" match="xs:complexType" use="@name"/>
  <xsl:key name="simpleTypes" match="xs:simpleType" use="@name"/>
  <xsl:key name="elementsByType" match="xs:element" use="@type"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="schemas">
    <docs>
      <xsl:apply-templates/>
      <xsl:call-template name="resolve-schemas"/>
      <xsl:call-template name="resolve-type-equivalents"/>
    </docs>
  </xsl:template>

  <xsl:template match="xs:schema">
    <doc>
      <xsl:copy-of select="@schema"/>
      <xsl:copy-of select="@model-name"/>
      <xsl:copy-of select="@root"/>
      <xsl:attribute name="namespace" select="@targetNamespace"/>
      <annotation>
        <xsl:apply-templates select="xs:annotation" mode="xdoc"/>
      </annotation>
      <xsl:apply-templates/>
    </doc>
  </xsl:template>

  <xsl:template match="xs:complexType">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xs:choice | xs:sequence">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xs:simplyType">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="xs:element[not(@type)]">
    <xsl:if test="$debug = 'true'">
      <xsl:message>!<xsl:value-of select="@name"/> has no type!</xsl:message>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xs:element[@type]">
    <xsl:variable name="this-name" select="@name"/>
    <xsl:variable name="this-type" select="@type"/>
    <xsl:variable name="this-schema" select="ancestor::xs:schema"/>
    <xsl:if test="$debug = 'true'">
      <xsl:message>[+] Checking <xsl:value-of
          select="concat($this-name, ' - ', $this-type, ' - ', $this-schema/@schema)"/></xsl:message>
    </xsl:if>
    <!-- Create simple model for means of comparison. -->
    <xsl:variable name="this-model">
      <xsl:call-template name="comparison-model">
        <xsl:with-param name="name-param" select="@name"/>
        <xsl:with-param name="type-param" select="@type"/>
        <xsl:with-param name="schema-param" select="$this-schema"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <!-- Check that this element:type combination has not already been documented. -->
      <xsl:when test="count($captured//element[@name = $this-name and @type = $this-type]) = 0">
        <!--Add it to the list. -->
        <saxon:assign name="captured">
          <captured>
            <xsl:copy-of select="$captured//*"/>
            <xsl:copy-of select="$this-model/element"/>
          </captured>
        </saxon:assign>
        <element name="{@name}" type="{@type}" id="{generate-id()}">
          <saxon:assign name="nodes-by-schema"
            select="concat($nodes-by-schema, generate-id(), '~', ancestor::xs:schema/@schema, ',')"/>
          <xsl:choose>
            <xsl:when test="starts-with(@type, 'xs:')">
              <xsl:call-template name="base-type"/>
            </xsl:when>
            <!-- Look up the complexType... -->
            <xsl:when test="key('complexTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1]">
              <!-- Look up the definition - but be sure it's from the correct schema. -->
              <xsl:apply-templates
                select="key('complexTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1]" mode="doc">
                <xsl:with-param name="name" select="@name"/>
                <xsl:with-param name="this-schema" select="$this-schema"/>
              </xsl:apply-templates>
            </xsl:when>
            <!-- ...or the simpleType. -->
            <xsl:when test="key('simpleTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1]">
              <!-- Look up the definition - but be sure it's from the correct schema. -->
              <xsl:apply-templates
                select="key('simpleTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1]" mode="doc">
                <xsl:with-param name="name" select="@name"/>
              </xsl:apply-templates>
            </xsl:when>
          </xsl:choose>
        </element>
        <xsl:if test="$debug = 'true'">
          <xsl:message> [-] Creating new model</xsl:message>
        </xsl:if>
      </xsl:when>
      <!-- Otherwise, find the element:type combination and compare it to this element. -->
      <xsl:otherwise>
        <saxon:assign name="identical">false</saxon:assign>
        <xsl:for-each select="$captured//element[@name = $this-name and @type = $this-type]">
          <!-- If this name:type combination is already listed against this schema, then we've already done all this once... -->
          <xsl:if test="contains($nodes-by-schema, concat(@id, '~', $this-schema/@schema))">
            <saxon:assign name="identical">true</saxon:assign>
            <xsl:if test="$debug = 'true'">
              <xsl:message> [-] Already created</xsl:message>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
        <!-- If it's not already listed for this schema, compare the models against all others already captured with this name and type. -->
        <xsl:if test="$identical = 'false'">
          <xsl:for-each select="$captured//element[@name = $this-name and @type = $this-type]">
            <xsl:variable name="identical-check">
              <xsl:call-template name="check_identical">
                <xsl:with-param name="comp1">
                  <xsl:copy>
                    <xsl:copy-of select="@*[name() != 'id'][name() != 'type-id']"
                      exclude-result-prefixes="#all"/>
                    <xsl:copy-of select="*"/>
                  </xsl:copy>
                </xsl:with-param>
                <xsl:with-param name="comp2">
                  <xsl:for-each select="$this-model/element">
                    <xsl:copy>
                      <xsl:copy-of select="@*[name() != 'id'][name() != 'type-id']"
                        exclude-result-prefixes="#all"/>
                      <xsl:copy-of select="*"/>
                    </xsl:copy>
                  </xsl:for-each>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="$identical-check='true'">
              <saxon:assign name="identical">true</saxon:assign>
              <saxon:assign name="type-equivalent"
                select="concat($type-equivalent, ' ', @type-id, ':', $this-model/element/@type-id)"/>
              <!-- TODO There's a bug here: If the *type* of one of the children isn't the same as the *type* of that in the model identified as being an equivalent, that child element will have a reference to the
                parent type id (@type-id) which doesn't exist in the output. Therefore, the end result will be that element being output with no parents identified, and the the equivalent element from the other model
                listing this element's schema.              
              Need to find a way to check the complex type of each child and compare to the complex type of each child in the equivalent model and record the relevant @type-id is the output child element (so it has more
              than one value in @type-id). See a:author-text in artemis model as an example (though the only difference is in the order of the child elements - may not be apparent if a fix is in place which standardises
              the order of choice elements).
              IN ADDITION: Child elements which are of a @type-id which is identical to one already output, should reference that already output - it seems in many cases that the equivalent @type-id is not being used,
              and so the @type-id does not point anywhere...-->
              <xsl:if test="$debug = 'true'">
                <xsl:message> [-] Identical model in other schema</xsl:message>
              </xsl:if>
              <!-- Add the id of the captured element along with the schema of the current element... -->
              <saxon:assign name="nodes-by-schema"
                select="concat($nodes-by-schema, @id, '~', $this-schema/@schema, ',')"/>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
        <xsl:if test="$identical='false'">
          <!--Add it to the list. -->
          <saxon:assign name="captured">
            <captured>
              <xsl:copy-of select="$captured//*"/>
              <xsl:copy-of select="$this-model/element"/>
            </captured>
          </saxon:assign>
          <element name="{@name}" type="{@type}" id="{generate-id()}">
            <saxon:assign name="nodes-by-schema"
              select="concat($nodes-by-schema, generate-id(), '~', ancestor::xs:schema/@schema, ',')"/>
            <xsl:choose>
              <xsl:when test="starts-with(@type, 'xs:')">
                <xsl:call-template name="base-type"/>
              </xsl:when>
              <!-- Look up the complexType... -->
              <xsl:when test="key('complexTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1]">
                <xsl:apply-templates
                  select="key('complexTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1]"
                  mode="doc">
                  <xsl:with-param name="name" select="@name"/>
                  <xsl:with-param name="duplicate">true</xsl:with-param>
                  <xsl:with-param name="this-schema" select="$this-schema"/>
                </xsl:apply-templates>
              </xsl:when>
              <!-- ...or the simpleType. -->
              <xsl:when test="key('simpleTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1]">
                <xsl:apply-templates
                  select="key('simpleTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1]" mode="doc">
                  <xsl:with-param name="name" select="@name"/>
                </xsl:apply-templates>
              </xsl:when>
            </xsl:choose>
          </element>
          <xsl:if test="$debug = 'true'">
            <xsl:message> [-] Creating new model</xsl:message>
          </xsl:if>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xs:complexType" mode="doc">
    <xsl:param name="name"/>
    <xsl:param name="duplicate">false</xsl:param>
    <xsl:param name="this-schema"/>
    <xsl:variable name="complexTypeId" select="generate-id(.)"/>
    <type id="{$complexTypeId}"/>
    <!-- Create svg of element tree-->
    <!--<xsl:variable name="svg-name">
      <xsl:choose>
        <xsl:when test="$duplicate = 'false'">
          <xsl:value-of select="concat($output-folder, replace($name, ':', '!'), '_', @name, '.svg')"/>          
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($output-folder, replace($name, ':', '!'), '_', @name, generate-id(), '.svg')"/>         
        </xsl:otherwise>
      </xsl:choose>      
    </xsl:variable>-->
    <xsl:if test="descendant::xs:element">
      <diagram>
        <xsl:apply-templates select="." mode="buildSvg">
          <!--<xsl:with-param name="file-name" select="$svg-name"/>-->
          <xsl:with-param name="element-name" select="$name"/>
          <xsl:with-param name="this-schema" select="$this-schema"/>
        </xsl:apply-templates>
      </diagram>
    </xsl:if>
    <children>
      <xsl:choose>
        <xsl:when test="@mixed = 'true' and (descendant::xs:element)">
          <xsl:attribute name="mixed">true</xsl:attribute>
        </xsl:when>
        <xsl:when test="(@mixed = 'true' and not(descendant::xs:element)) or xs:simpleContent">
          <xsl:attribute name="simpleContent">true</xsl:attribute>
        </xsl:when>
        <xsl:when test="not(descendant::xs:element) and not(@mixed = 'true')">
          <xsl:attribute name="empty">true</xsl:attribute>
        </xsl:when>
      </xsl:choose>

      <xsl:for-each select="descendant::xs:element">
        <xsl:variable name="name" select="@name"/>
        <!-- Only output 1 entry for each element. -->
        <xsl:if
          test="count(preceding::xs:element[@name = $name][generate-id(ancestor::xs:complexType) = $complexTypeId]) = 0">
          <xsl:variable name="element-type-id">
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
          </xsl:variable>
          <element name="{@name}" type="{@type}" type-id="{$element-type-id}">
            <annotation>
              <xsl:apply-templates select="xs:annotation" mode="xdocs"/>
            </annotation>
          </element>
        </xsl:if>
      </xsl:for-each>

      <xsl:for-each select="descendant::xs:attribute">
        <attribute name="{@name}" type="{@type}">
          <xsl:copy-of select="@use"/>
          <description>
            <xsl:apply-templates
              select="key('simpleTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1]" mode="doc">
              <xsl:with-param name="is-attribute">true</xsl:with-param>
            </xsl:apply-templates>
          </description>
          <annotation>
            <xsl:apply-templates select="xs:annotation" mode="xdoc"/>
            <xsl:apply-templates
              select="key('simpleTypes', @type)[count(ancestor::xs:schema | $this-schema) = 1]//xs:annotation"
              mode="xdoc"/>
          </annotation>
        </attribute>
      </xsl:for-each>
    </children>
    <schematron-rules>
      <xsl:if test="descendant::sch:*">
        <xsl:for-each select="descendant::sch:assert">
          <rule>
            <xsl:value-of select="."/>
          </rule>
        </xsl:for-each>
      </xsl:if>
    </schematron-rules>
    <annotation>
      <xsl:apply-templates select="xs:annotation" mode="xdoc"/>
    </annotation>
  </xsl:template>

  <xsl:template match="xs:simpleType" mode="doc">
    <xsl:param name="is-attribute">false</xsl:param>
    <type id="{generate-id()}"/>
    <xsl:choose>
      <xsl:when test="xs:restriction/xs:pattern">
        <pattern>
          <xsl:value-of select="xs:restriction/xs:pattern/@value"/>
        </pattern>
      </xsl:when>
      <xsl:when test="xs:restriction/xs:enumeration">
        <enumeration>
          <xsl:for-each select="xs:restriction/xs:enumeration">
            <value>
              <xsl:value-of select="@value"/>
            </value>
          </xsl:for-each>
        </enumeration>
      </xsl:when>
      <xsl:otherwise>
        <base>
          <xsl:value-of select="replace(xs:restriction/@base, 'xs:', '')"/>
        </base>
      </xsl:otherwise>
    </xsl:choose>
    
    <schematron-rules>
      <xsl:if test="descendant::sch:*">
        <xsl:for-each select="descendant::sch:assert">
          <rule>
            <xsl:value-of select="."/>
          </rule>
        </xsl:for-each>
      </xsl:if>
    </schematron-rules>
    <xsl:if test="$is-attribute = 'false'">
      <annotation>
        <xsl:apply-templates select="xs:annotation" mode="xdoc"/>
      </annotation>
    </xsl:if>
  </xsl:template>

  <xsl:template name="base-type">
    <type id="{generate-id()}"/>
    <base>
      <xsl:value-of select="replace(@type, 'xs:', '')"/>
    </base>
  </xsl:template>

  <xsl:template match="xs:annotation" mode="xdoc">
    <xsl:apply-templates mode="xdoc"/>
  </xsl:template>

  <xsl:template match="xs:documentation" mode="xdoc">
    <xsl:apply-templates select="xd:*"/>
  </xsl:template>

  <xsl:template match="xs:appinfo" mode="xdoc"/>

  <xsl:template match="xd:*">
    <!-- removes all xd prefixes from xdocs documentation. -->
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*"/>

  <xsl:template name="comparison-model">
    <xsl:param name="name-param"/>
    <xsl:param name="type-param"/>
    <xsl:param name="schema-param"/>
    <xsl:element name="element" inherit-namespaces="no">
      <xsl:attribute name="id" select="generate-id()"/>
      <xsl:attribute name="name" select="$name-param"/>
      <xsl:attribute name="type" select="$type-param"/>
      <xsl:choose>
        <xsl:when test="starts-with(@type, 'xs:')">
          <xsl:attribute name="type-id" select="generate-id()"/>
          <xsl:attribute name="base">
            <xsl:value-of select="replace($type-param, 'xs:', '')"/>
          </xsl:attribute>
        </xsl:when>
        <!-- Look up the complexType... -->
        <xsl:when test="key('complexTypes', $type-param)[count(ancestor::xs:schema | $schema-param) = 1]">
          <xsl:variable name="node"
            select="key('complexTypes', $type-param)[count(ancestor::xs:schema | $schema-param) = 1]"/>
          <xsl:choose>
            <xsl:when test="$node/@mixed = 'true' and ($node//descendant::xs:element)">
              <xsl:attribute name="mixed">true</xsl:attribute>
            </xsl:when>
            <xsl:when
              test="($node/@mixed = 'true' and not($node/descendant::xs:element)) or $node/xs:simpleContent">
              <xsl:attribute name="simpleContent">true</xsl:attribute>
            </xsl:when>
            <xsl:when test="not($node/descendant::xs:element) and not($node/@mixed = 'true')">
              <xsl:attribute name="empty">true</xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:attribute name="type-id" select="generate-id($node)"/>
          <xsl:attribute name="elements">
            <xsl:for-each select="$node//xs:element">
              <xsl:variable name="name" select="@name"/>
              <xsl:variable name="complexType" select="ancestor::xs:complexType/@name"/>
              <!-- Don't need to check for duplicate child element names - would be good if the order or duplicates was picked up to provide more accurate comparison... -->
              <!-- Don't include reference to schema, as this will be irrelevant when different schemas use the same element name referencing the same type name, but the target types differ. -->
              <xsl:value-of select="@name"/>
              <xsl:text>~</xsl:text>
              <xsl:value-of select="@type"/>
              <xsl:text> </xsl:text>
              <!--</xsl:if>-->
            </xsl:for-each>
          </xsl:attribute>
          <xsl:attribute name="attributes">
            <xsl:for-each select="$node//xs:attribute">
              <xsl:value-of select="@name"/>
              <xsl:text>~</xsl:text>
              <xsl:value-of select="@type"/>
              <xsl:text> </xsl:text>
            </xsl:for-each>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="key('simpleTypes', $type-param)[count(ancestor::xs:schema | $schema-param) = 1]">
          <xsl:variable name="node"
            select="key('simpleTypes', $type-param)[count(ancestor::xs:schema | $schema-param) = 1]"/>
          <xsl:choose>
            <xsl:when test="$node/xs:restriction/xs:pattern">
              <xsl:attribute name="pattern">
                <xsl:value-of select="$node/xs:restriction/xs:pattern/@value"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="$node/xs:restriction/xs:enumeration">
              <xsl:attribute name="enumeration">
                <xsl:for-each select="$node/xs:restriction/xs:enumeration">
                  <xsl:value-of select="@value"/>
                  <xsl:text> </xsl:text>
                </xsl:for-each>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="base">
                <xsl:value-of select="replace($node/xs:restriction/@base, 'xs:', '')"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:attribute name="type-id" select="generate-id($node)"/>
        </xsl:when>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template name="check_identical">
    <xsl:param name="comp1"/>
    <xsl:param name="comp2"/>
    <!--<xsl:message>Comparing:
    <xsl:copy-of select="$comp1"/>
    with:
    <xsl:copy-of select="$comp2"/>
    </xsl:message>-->
    <xsl:value-of
      select="saxon:deep-equal($comp1, $comp2, 'http://www.w3.org/2005/xpath-functions/collation/codepoint','')"/>
    <!--<xsl:variable name="string1">
      <xsl:call-template name="stringify">
        <xsl:with-param name="node"><xsl:copy-of
          select="$comp1"/></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="string2">
      <xsl:call-template name="stringify">
        <xsl:with-param name="node"><xsl:copy-of
          select="$comp2"/></xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:message>
      String compare:
     <xsl:value-of select="$string1"/>
      ...with:
      <xsl:value-of select="$string2"/>
    </xsl:message>
    <xsl:value-of select="$string1=$string2"/>-->
  </xsl:template>

  <xsl:template name="stringify">
    <xsl:param name="node"/>
    <xsl:for-each select="$node/*/*|$node/*/text()">
      <xsl:choose>
        <xsl:when test="boolean(local-name())"> &lt;<xsl:value-of select="local-name()"/>
          <xsl:variable name="pos" select="position()"/>
          <xsl:for-each select="@*">
            <xsl:text> </xsl:text><xsl:value-of select="local-name()"/>="<xsl:value-of select="."/>" </xsl:for-each>
          <xsl:call-template name="stringify">
            <xsl:with-param name="node"><xsl:copy-of select="."/></xsl:with-param>
          </xsl:call-template> &lt;/<xsl:value-of select="local-name()"/>&gt; </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="resolve-schemas">
    <schema-ids>
      <xsl:for-each-group select="tokenize($nodes-by-schema, ',')" group-by="substring-before(., '~')">
        <!-- Quick check to be sure we don't output the final empty token... -->
        <xsl:if test="current-grouping-key() != ''">
          <element id="{current-grouping-key()}">
            <xsl:for-each select="current-group()">
              <schema name="{substring-after(., '~')}"/>
            </xsl:for-each>
          </element>
        </xsl:if>
      </xsl:for-each-group>
    </schema-ids>
  </xsl:template>

  <xsl:template name="resolve-type-equivalents">
    <type-equivalents>
      <xsl:for-each-group select="tokenize($type-equivalent, ' ')" group-by="substring-before(., ':')">
        <!-- Quick check to be sure we don't output the final empty token... -->
        <xsl:if test="current-grouping-key() != ''">
          <type id="{current-grouping-key()}">
            <xsl:for-each select="current-group()">
              <equivalent id="{substring-after(., ':')}"/>
            </xsl:for-each>
          </type>
        </xsl:if>
      </xsl:for-each-group>
    </type-equivalents>
  </xsl:template>

</xsl:stylesheet>
