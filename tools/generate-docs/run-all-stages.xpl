<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:saxon="http://saxon.sf.net/"
  xmlns:c="http://www.w3.org/ns/xproc/step" xmlns:db="http://docbook.org/ns/docbook"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:url="http://www.oecd.org/ns/schema" name="create-docs"
  xmlns:xd="http://www.oecd.org/ns/schema/xdocs" version="1.0">


  <p:input port="source" sequence="true" primary="true"/>
  <p:input port="supplements" sequence="true" primary="false"/>
  <p:input port="parameters" kind="parameter"/>
  <p:output port="result" primary="true" sequence="true">
    <p:empty/>
  </p:output>

  <p:for-each>
    <p:xslt>
      <p:input port="stylesheet">
        <p:document href="stage1.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:empty/>
      </p:input>
    </p:xslt>
    <p:xslt>
      <p:input port="stylesheet">
        <p:document href="stage2.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:empty/>
      </p:input>
    </p:xslt>
    <p:xslt>
      <p:input port="stylesheet">
        <p:document href="stage2_5.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:empty/>
      </p:input>
    </p:xslt>
  </p:for-each>

  <p:wrap-sequence wrapper="schemas"/>

  <p:xslt name="stage3">
    <p:input port="stylesheet">
      <p:document href="stage3.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>
  <!--
  <p:try>-->
  <p:group>
    <!-- Added a try/catch to avoid errors being thrown when the supplements input is empty. This will also hide any errors with the xquery and wrap-sequence below though... -->
    <p:for-each>
      <p:iteration-source>
        <p:pipe port="supplements" step="create-docs"/>
      </p:iteration-source>
      <p:xquery>
        <p:input port="query">
          <p:inline>
            <c:query> declare namespace xd = "http://xml.smg-uk.com/schema/xdocs"; declare namespace db =
              "http://docbook.org/ns/docbook"; declare namespace xlink = "http://www.w3.org/1999/xlink";
              declare default element namespace ""; for $target in
              distinct-values(//db:productname[@role='schema'] | //db:link[@role='schema']/@xlink:href) let
              $targets := //db:productname[. = $target] | //db:link[@role='schema'][@xlink:href = $target]
              return &lt;target element="{$target}">{ for $this-target in $targets return
              <!--&lt;link id="{substring-before(subsequence(reverse(tokenize(base-uri(.), '/')), 1, 1), '.xml')}/{normalize-space(replace($this-target/ancestor::db:sect1/db:info/db:title, ' ', '_'))}.xhtml#{$this-target/ancestor::*[db:info/db:title][1]/@xml:id}">-->
              &lt;link id="{replace(replace(/db:book/db:info/db:title, ' ', '_'), ':',
              '_')}/{normalize-space(replace($this-target/ancestor::db:sect1/db:info/db:title, ' ',
              '_'))}.xhtml#{$this-target/ancestor::*[db:info/db:title][1]/@xml:id}"> {
              <!-- Added caveat to not put in 'article' title, as when using an article it will usually be the only article in a document (otherwise use chapters) - and so the article title is unnecessary. -->
              for $title in $this-target/ancestor::*[name() != 'article'][db:info/db:title]/db:info/db:title
              return &lt;path-item>{data($title)}&lt;/path-item> } &lt;/link> } &lt;/target> </c:query>
          </p:inline>
        </p:input>
        <p:input port="parameters">
          <p:empty/>
        </p:input>
      </p:xquery>
    </p:for-each>
    <p:wrap-sequence name="find-references" wrapper="targets"/>

    <p:wrap-sequence wrapper="schemas-with-references">
      <p:input port="source">
        <p:pipe port="result" step="stage3"/>
        <p:pipe port="result" step="find-references"/>
      </p:input>
    </p:wrap-sequence>

  </p:group>
  <!--    <p:catch>
      <p:identity/>
    </p:catch>
  </p:try>-->

  <p:xslt name="complete-compilation">
    <p:input port="stylesheet">
      <p:document href="stage4.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>

  <p:xslt name="generate-html">
    <p:input port="stylesheet">
      <p:document href="stage5-compile-to-html.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:pipe port="result" step="params"/>
    </p:input>
  </p:xslt>

  <p:filter select="/xhtml:outputs/xhtml:output"/>
  <p:for-each>
    <p:variable name="path" select="replace(/xhtml:output/@href, ' ', '%20')"/>
    <p:filter select="/xhtml:output/xhtml:html"/>
    <!-- Insert global links. -->
    <p:insert position="first-child" match="//xhtml:div[@id = 'menu']">
      <p:input port="insertion">
        <p:pipe port="result" step="global-links"/>
      </p:input>
    </p:insert>
    <!-- Insert product-specific links in each of these documents. -->
    <p:insert position="last-child" match="/xhtml:html//xhtml:div[@id='right']">
      <p:input port="insertion">
        <p:pipe port="result" step="create-product-links"/>
      </p:input>
    </p:insert>
    <p:store>
      <p:with-option name="href" select="$path"/>
    </p:store>
  </p:for-each>

  <p:parameters name="params">
    <p:input port="parameters">
      <p:pipe port="parameters" step="create-docs"/>
    </p:input>
  </p:parameters>

  <!-- Creates an overview of each docbook structure. -->
  <p:for-each name="create-book-html">
    <p:iteration-source>
      <p:pipe port="supplements" step="create-docs"/>
    </p:iteration-source>
    <p:variable name="folder" select="replace(replace(/db:book/db:info/db:title, ' ', '_'), ':', '_')"/>
    <!--<p:variable name="folder" select="substring-before(subsequence(reverse(tokenize(base-uri(.), '/')), 1, 1), '.xml')"/>-->
    <p:xslt>
      <p:input port="stylesheet">
        <p:document href="db-book-to-html.xsl"/>
      </p:input>
      <p:input port="parameters">
        <p:pipe port="result" step="params"/>
      </p:input>
    </p:xslt>
    <p:insert position="first-child" match="//xhtml:div[@id = 'menu']">
      <p:input port="insertion">
        <p:pipe port="result" step="global-links"/>
      </p:input>
    </p:insert>
    <p:store>
      <p:with-option name="href"
        select="concat(replace(/xhtml:html/@url:base, ' ', '%20'), $folder,'/book.xhtml')"/>
    </p:store>
  </p:for-each>

  <!-- Create links to be used on all pages. -->
  <p:for-each>
    <p:iteration-source>
      <p:pipe port="supplements" step="create-docs"/>
    </p:iteration-source>
    <p:xslt>
      <p:input port="stylesheet">
        <p:inline>
          <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xpath-default-namespace="http://docbook.org/ns/docbook"
            xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs db c saxon" version="2.0"
            xmlns="http://www.w3.org/1999/xhtml">
            <xsl:variable name="folder"
              select="replace(replace(/db:book/db:info/db:title, ' ', '_'), ':', '_')"/>
            <!--<xsl:variable name="folder" select="substring-before(subsequence(reverse(tokenize(base-uri(.), '/')), 1, 1), '.xml')"/>-->
            <xsl:template match="/">
              <xsl:if test="not(db:book/@role)">
                <li>
                  <a href="../{$folder}/book.xhtml">
                    <xsl:value-of select="/book/info/title"/>
                  </a>
                </li>
              </xsl:if>
            </xsl:template>
          </xsl:stylesheet>
        </p:inline>
      </p:input>
    </p:xslt>
  </p:for-each>
  <p:wrap-sequence wrapper="xhtml:ul"/>
  <p:add-attribute match="xhtml:ul" attribute-name="id" attribute-value="nav"/>
  <p:insert position="first-child" match="/xhtml:ul">
    <p:input port="insertion">
      <p:inline>
        <li xmlns="http://www.w3.org/1999/xhtml">
          <a href="../models/dm_documentation.xhtml">Data Models</a>
        </li>
      </p:inline>
    </p:input>
  </p:insert>
  <p:insert name="global-links" position="first-child" match="/xhtml:ul">
    <p:input port="insertion">
      <p:inline>
        <li xmlns="http://www.w3.org/1999/xhtml">
          <a href="../index.htm">Home</a>
        </li>
      </p:inline>
    </p:input>
  </p:insert>

  <p:for-each name="create-sect1-html">
    <p:iteration-source>
      <p:pipe port="supplements" step="create-docs"/>
    </p:iteration-source>
    <!-- Create a copy of the supplement doc-book for referring back to. -->
    <p:identity name="this-supplement"/>
    <p:group>
      <p:variable name="folder" select="replace(replace(/db:book/db:info/db:title, ' ', '_'), ':', '_')"/>
      <!--<p:variable name="folder" select="substring-before(subsequence(reverse(tokenize(base-uri(.), '/')), 1, 1), '.xml')"/>-->
      <!-- Create an outline of the doc-book to insert in each section below. -->
      <p:xslt name="create-book">
        <p:input port="stylesheet">
          <p:document href="db-book-outline-to-html.xsl"/>
        </p:input>
        <p:input port="parameters">
          <p:pipe port="result" step="params"/>
        </p:input>
        <p:input port="source">
          <p:pipe port="result" step="this-supplement"/>
        </p:input>
      </p:xslt>
      <!-- Grab the book title -->
      <p:xslt name="get-title">
        <p:input port="source">
          <p:pipe port="result" step="this-supplement"/>
        </p:input>
        <p:input port="stylesheet">
          <p:inline>
            <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xpath-default-namespace="http://docbook.org/ns/docbook"
              xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs db c saxon url"
              version="2.0" xmlns="http://www.w3.org/1999/xhtml">
              <xsl:template match="/">
                <span>
                  <xsl:value-of select="/book/info/title"/>
                </span>
              </xsl:template>
            </xsl:stylesheet>
          </p:inline>
        </p:input>
      </p:xslt>
      <!-- Grab another copy of the reference doc-book above... -->
      <p:identity name="this-supplement2">
        <p:input port="source">
          <p:pipe port="result" step="this-supplement"/>
        </p:input>
      </p:identity>
      <!-- ...then cycle through it to create a document for each section. -->
      <p:for-each>
        <p:iteration-source select="/db:book/db:chapter/db:sect1 | /db:book/db:article/db:sect1"/>
        <p:variable name="file" select="replace(replace(/db:sect1/db:info/db:title, ' ', '_'), ':', '_')"/>
        <p:xslt>
          <p:input port="stylesheet">
            <p:document href="db-sect1-to-html.xsl"/>
          </p:input>
          <p:input port="parameters">
            <p:pipe port="result" step="params"/>
          </p:input>
        </p:xslt>
        <!-- Insert the doc-book outline in each of these documents. -->
        <p:insert position="first-child" match="/xhtml:html//xhtml:div[@id='right']">
          <p:input port="insertion">
            <p:pipe port="result" step="create-book"/>
          </p:input>
        </p:insert>
        <!-- Insert product-specific links in each of these documents. -->
        <p:insert position="last-child" match="/xhtml:html//xhtml:div[@id='right']">
          <p:input port="insertion">
            <p:pipe port="result" step="create-product-links"/>
          </p:input>
        </p:insert>
        <!-- Insert global links. -->
        <p:insert position="first-child" match="//xhtml:div[@id = 'menu']">
          <p:input port="insertion">
            <p:pipe port="result" step="global-links"/>
          </p:input>
        </p:insert>
        <!-- Insert the book title -->
        <p:insert position="first-child" match="//xhtml:h1[@class='title']">
          <p:input port="insertion">
            <p:pipe port="result" step="get-title"/>
          </p:input>
        </p:insert>
        <p:store>
          <p:with-option name="href"
            select="concat(replace(/xhtml:html/@url:base, ' ', '%20'), $folder,'/', normalize-space($file), '.xhtml')"
          />
        </p:store>
      </p:for-each>
    </p:group>
  </p:for-each>

  <p:xslt>
    <p:input port="source">
      <p:inline>
        <empty/>
      </p:inline>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="create-index.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:pipe port="result" step="params"/>
    </p:input>
  </p:xslt>
  <!-- Insert global links. -->
  <!--
  <p:insert position="first-child" match="//xhtml:div[@id = 'menu']">
    <p:input port="insertion">
      <p:pipe port="result" step="global-links"/>
    </p:input>
    </p:insert>-->
  <p:insert position="first-child" match="//xhtml:div[@id = 'global']">
    <p:input port="insertion">
      <p:pipe port="result" step="create-product-links"/>
    </p:input>
  </p:insert>
  <p:insert position="first-child" match="//xhtml:div[@id = 'global']">
    <p:input port="insertion">
      <p:pipe port="result" step="global-links"/>
    </p:input>
  </p:insert>
  <p:delete match="//xhtml:div[@id = 'global']/xhtml:ul/xhtml:li[1]"/>
  <p:string-replace match="//xhtml:div[@id = 'global']//xhtml:a/@href" replace="substring-after(., '../')"/>
  <p:store>
    <p:with-option name="href" select="concat(replace(/xhtml:html/@url:base, ' ', '%20'), 'index.htm')"/>
  </p:store>

  <!-- Universal links for Product Specific Documentation -->
  <p:for-each>
    <p:iteration-source>
      <p:pipe port="supplements" step="create-docs"/>
    </p:iteration-source>
    <p:xslt>
      <p:input port="stylesheet">
        <p:inline>
          <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xpath-default-namespace="http://docbook.org/ns/docbook"
            xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs db c saxon url"
            version="2.0" xmlns="http://www.w3.org/1999/xhtml">
            <xsl:variable name="folder"
              select="replace(replace(/db:book/db:info/db:title, ' ', '_'), ':', '_')"/>
            <xsl:template match="/">
              <xsl:if test="/book/@role">
                <li role="{/book/@role}">
                  <a href="../{$folder}/book.xhtml">
                    <xsl:value-of select="/book/info/title"/>
                  </a>
                </li>
              </xsl:if>
            </xsl:template>
          </xsl:stylesheet>
        </p:inline>
      </p:input>
    </p:xslt>
  </p:for-each>
  <p:wrap-sequence wrapper="xhtml:html"/>
  <p:xslt>
    <p:input port="stylesheet">
      <p:inline>
        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
          xpath-default-namespace="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema"
          exclude-result-prefixes="xs db c saxon url" version="2.0" xmlns="http://www.w3.org/1999/xhtml">
          <xsl:template match="/">
            <xsl:if test="count(html/li) &gt; 0">
              <div class="box">
                <h4>Product Specific Documentation</h4>
                <xsl:for-each-group select="html/li" group-by="@role">
                  <xsl:sort select="@role"/>
                  <h5>
                    <xsl:value-of select="current-grouping-key()"/>
                  </h5>
                  <ul>
                    <xsl:apply-templates select="current-group()"/>
                  </ul>
                </xsl:for-each-group>
              </div>
            </xsl:if>
          </xsl:template>
          <xsl:template match="html/li">
            <li>
              <xsl:copy-of select="*"/>
            </li>
          </xsl:template>
        </xsl:stylesheet>
      </p:inline>
    </p:input>
  </p:xslt>
  <p:identity name="create-product-links"/>
  <p:sink/>

</p:declare-step>
