<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:d="urn:oecd:names:xmlns:authoring:document" xmlns:mods="http://www.loc.gov/mods/v3"  xmlns:xlink="http://www.w3.org/1999/xlink">
    <!-- Narrdoc 2 A/E conversion -->

    <xsl:output indent="yes"/>
    <!-- Top level narrdoc -->
    <xsl:template match="narr-doc">
        <xsl:comment>General repeated messages:
        - Attribute p/@numbering and li/@numbering have no equivalent
        - Attribute shortcitation/@citationsource has no equivalent in phrase element
        - Missing tablegrp element enabling to group different tables. In this case difficult to create an id for different contained tables.
        - Missing table titles.
        - Table/tfoot should not be mandatory.
        - Missing rotate and position attributes at entry level.
        - Missing inline hyperlinking mechanism &lt;hyperlink  url="http://www.oecd.org/std/ppp" target="webpage">www.oecd.org/std/ppp&lt;/hyperlink>
        - Missing attributes of a section : section content="default" numbering id="o30-2010-01-1-fmt-intro-s03" geocontainer="false" statisticalannex="false"
        - Missing foreword, about, acknowledgement, glossary-acronyms elements for front matter.
        - Why do we need to set titles within an introduction, an appendix or a chapter ? Why is the glossary required in an introduction ?
        - shortTitle is required but there are not always the information in A/E. What are authorexpect to provide ? Is it the same optional idea than subheading ? 
        - Occurrences indicator pb: only one block element is allowed in a section. 
        - shortcitation has no equivalent.
        - What is the use of mods elements at inline level ? No elements like this within narrdoc.
        - How to make a link, no provision for xref or fignoteref element.</xsl:comment>
        <publication xmlns="urn:oecd:names:xmlns:authoring:document"
            xsi:schemaLocation="urn:oecd:names:xmlns:authoring:document file:///P:/Production/Users/Frederic/Author_Modelling/V2/oecd.publication.xsd"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xmlns:xlink="http://www.w3.org/1999/xlink">

            <xsl:comment>Attribute narr-doc/@status has no equivalent</xsl:comment>
            <xsl:comment>Attribute narr-doc/@notestyle has no equivalent</xsl:comment>
            <xsl:comment>Attribute narr-doc/@classification has no equivalent</xsl:comment>
            <metadata>
                <xsl:comment>No information to provide to element publication/metadata as soon as
                    the information is provided at document level</xsl:comment>
                <metadata>
                    <metadataItem>
                        <mods:genre>none at this level</mods:genre>
                    </metadataItem>
                </metadata>
            </metadata>
            <title>
                <xsl:comment>No information to provide to element publication/title as soon as the
                    information is provided at document level</xsl:comment>
            </title>
            <shortTitle>
                <xsl:comment>No information to provide to element publication/shorttitle as soon as
                    the information is provided at document level</xsl:comment>
            </shortTitle>
            <document xml:lang="en">
                <metadata>
                    <xsl:apply-templates select="frontmatter/bibinfo/*" mode="metadata"/>
                </metadata>
                <title>
                    <xsl:apply-templates
                        select="frontmatter/bibinfo/maintitl/*|frontmatter/bibinfo/maintitl/text()"
                    />
                </title>
                <shortTitle>
                    <xsl:apply-templates
                        select="frontmatter/bibinfo/abbrtitl/*|frontmatter/bibinfo/abbrtitl/text()"
                    />
                </shortTitle>
                <xsl:apply-templates/>
            </document>
        </publication>
    </xsl:template>
    
    
    <!--  bib info and top level doc metadata -->
    <xsl:template match="bibinfo">
        <!-- yet managed as metadata -->
    </xsl:template>
    <xsl:template match="pubyear" mode="metadata">
        <d:metadataItem>
            <mods:date>
                <xsl:apply-templates/>
            </mods:date>
        </d:metadataItem>
    </xsl:template>
    <xsl:template match="jobno|isbn|doi" mode="metadata">
        <xsl:comment>
            <xsl:value-of select="concat('Metadata ',local-name(),' not managed')"/>
        </xsl:comment>
    </xsl:template>

    <xsl:template match="maintitl|abbrtitl" mode="metadata"/>


    <!-- hugh level structure -->
    <xsl:template match="frontmatter|backmatter">
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="foreword">
        <!-- removed for now, no equivalent -->
    </xsl:template>

    <xsl:template match="introduction">
        <introduction xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </introduction>
    </xsl:template>

    <xsl:template match="body">
        <xsl:comment>Attribute of body element impossible to manage.</xsl:comment>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="chapter">
        <xsl:comment>Attribute of chapter element impossible to manage.</xsl:comment>
        <xsl:comment>Impossible to add an id to a chapter</xsl:comment>
        <chapter xmlns="urn:oecd:names:xmlns:authoring:document">
            <!-- !!! error in the ae model, needed twice -->
            <!--<title>
                <xsl:apply-templates select="heading/mainhead/*|heading/mainhead/text()"/>
            </title>
            <shortTitle>
                <xsl:choose>
                    <xsl:when test="not(subheading)">
                        <xsl:text>NULL shortTitle to respect the model.</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates
                            select="subheading/mainhead/*|subheading/mainhead/text()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </shortTitle>-->
            <xsl:apply-templates/>
        </chapter>
    </xsl:template>
    
    <xsl:template match="abstract">
        <abstract xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </abstract>
        <title xmlns="urn:oecd:names:xmlns:authoring:document">NULL second Title to respect the model.</title>
    </xsl:template>
    
    <xsl:template match="annex">
        <appendix xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </appendix>
    </xsl:template>

    <xsl:template match="heading|subheading">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="chapter/heading/mainhead|introduction/heading/mainhead">
        <title xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </title>        
    </xsl:template>

    <xsl:template match="section/heading/mainhead|sectionlevel2/heading/mainhead|sectionlevel3/heading/mainhead|sectionlevel4/heading/mainhead|sectionlevel5/heading/mainhead|textbox/boxsection/heading/mainhead|boxsectionlevel2/heading/mainhead|boxsectionlevel3/heading/mainhead|boxsectionlevel4/heading/mainhead|boxsectionlevel5/heading/mainhead|annex/heading/mainhead">
        <title xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </title>        
    </xsl:template>

    <xsl:template match="subheading/mainhead">
        <shortTitle xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </shortTitle>
    </xsl:template>

    <xsl:template match="biblio">
        <bibliography xmlns="urn:oecd:names:xmlns:authoring:document">
            <title><xsl:value-of select="heading/mainhead/text()"/></title>
            <biblioSection>
                <xsl:apply-templates select="*[local-name()!='heading']"/>
            </biblioSection>
        </bibliography>
    </xsl:template>
    


    <!-- Sections -->
    <xsl:template match="section|sectionlevel2|sectionlevel3|sectionlevel4|sectionlevel5">
        <section xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </section>
    </xsl:template>
    
    <!-- Text box model -->
    <xsl:template match="textbox">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="textbox/boxsection">
        <box xmlns="urn:oecd:names:xmlns:authoring:document" number="{@number}">
            <xsl:choose>
                <xsl:when test="not(heading)">
                    <title>null title when there are no section contained within boxsection</title>
                    <shortTitle>null shortTitle when there are no section contained within boxsection</shortTitle>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </box>
    </xsl:template>
    <xsl:template match="boxsection|boxsectionlevel2|boxsectionlevel3">
        <section xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </section>
    </xsl:template>
    
    
    <!-- block level -->
    <xsl:template match="p">
        <para xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </para>
    </xsl:template>
    
    <xsl:template match="specchar">
        <xsl:choose>
            <xsl:when test="@position='sub'">
                <sub xmlns="urn:oecd:names:xmlns:authoring:document">
                    <xsl:apply-templates/>
                </sub>
            </xsl:when>
            <xsl:when test="@position='sup'">
                <sup xmlns="urn:oecd:names:xmlns:authoring:document">
                    <xsl:apply-templates/>
                </sup>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    

    <xsl:template match="randlist">
        <itemizedList xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:attribute name="d:marker">
                <xsl:choose>
                    <xsl:when test="@type='bullet'">circle</xsl:when>
                    <xsl:when test="@type='hyphen'">auto</xsl:when>
                    <xsl:when test="@type='zapf'">
                        <xsl:comment>randlist/@type=zapf has no equivalent</xsl:comment>
                    </xsl:when>

                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </itemizedList>
    </xsl:template>

    <xsl:template match="li">
        <listItem xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </listItem>
    </xsl:template>
    
    <xsl:template match="graphic">
        <xsl:choose>
            <xsl:when test="ancestor::p">
                <inlineGraphic xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
                    <externalGraphic xlink:href="{@graphic}"
                        xmlns="urn:oecd:names:xmlns:authoring:document"/>
                </inlineGraphic>
            </xsl:when>
            <xsl:otherwise>
                <graphic xmlns="urn:oecd:names:xmlns:authoring:document">
                    <externalGraphic xlink:href="{@graphic}"
                        xmlns="urn:oecd:names:xmlns:authoring:document"/>
                </graphic>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    
    <!-- figure -->
    <xsl:template match="figure">
        <figure xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates select="*[local-name()!='fignote']"/>
            <xsl:if test="fignote">
                <notes xmlns="urn:oecd:names:xmlns:authoring:document">
                    <xsl:apply-templates select="fignote"/>
                </notes>
            </xsl:if>
        </figure>
    </xsl:template>
    <xsl:template match="fignote">
        <note xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </note>
    </xsl:template>

    <xsl:template match="figureheading|figuresubheading">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="figureheading/figuremainhead">
        <title xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </title>
<!--        <xsl:if test="not(../../figuresubheading)">
            <shortTitle xml:id="ST{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
                <xsl:text>NULL shortTitle to respect the model.</xsl:text>
            </shortTitle>
        </xsl:if>-->
    </xsl:template>

    <xsl:template match="figuresubheading/figuremainhead">
        <subTitle xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </subTitle>
    </xsl:template>
    
    <xsl:template match="tableheading">
        <titles xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </titles>
    </xsl:template>

    <xsl:template match="tableheading/tablemainhead">
        <title xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </title>
    </xsl:template>
    
    <xsl:template match="tablesubheading/tablemainhead">
        <subTitle xml:id="{@id}" xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </subTitle>
    </xsl:template>
    
    
    
    
    <!-- tables -->
    <xsl:template match="tablegrp">
        <!-- mising titles -->
        <table xmlns="urn:oecd:names:xmlns:authoring:document">
<!--            <xsl:copy-of select="table/@*"/>
-->         <xsl:apply-templates select="*[local-name()='tableheading']"/>
            <xsl:apply-templates select="*[local-name()='table']"/>
            <!-- select="table/*"-->
        <tfoot>
            <xsl:if test="tabnote">
            <notes>
                <xsl:apply-templates select="*[local-name()='tabnote']"/>
            </notes>
            </xsl:if>
            <xsl:if test="source">
            <sources>
                <xsl:apply-templates select="*[local-name()='source']"/>
            </sources>
            </xsl:if>
        </tfoot>    
        </table>
    </xsl:template>
    
    <xsl:template match="table">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tabnote">
        <note xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </note>
    </xsl:template>
    
    <xsl:template match="source">
        <source xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </source>
    </xsl:template>

    <xsl:template match="tgroup|thead|tbody|row|entry">
        <xsl:choose>
            <xsl:when test="local-name()='tgroup'">
                <xsl:comment>tgroup/@type @charoff and @numbering have no
                    equivalent</xsl:comment>
            </xsl:when>
            <xsl:when test="local-name()='entry'">
                <xsl:comment>entry/@rotate and @position have no equivalent</xsl:comment>
            </xsl:when>
        </xsl:choose>
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="*|@*|text()|comment()"/>
        </xsl:element>
    </xsl:template>

<!--    <xsl:template match="thead/@*|tfoot/@*|tbody/@*|row/@*|entry/@*">
        <xsl:copy-of select="."/>        
    </xsl:template>-->

    <xsl:template match="thead">
        <thead xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </thead>
    </xsl:template>
    
    <xsl:template match="tbody">
        <tbody xmlns="urn:oecd:names:xmlns:authoring:document" valign="{@valign}">
            <xsl:apply-templates/>
        </tbody>
    </xsl:template>
    
    <xsl:template match="row">
        <row xmlns="urn:oecd:names:xmlns:authoring:document">
            <xsl:apply-templates/>
        </row>
    </xsl:template>

    <xsl:template match="tgroup">
        <xsl:comment>
            <xsl:text>&#xa0; UNABLE to manage @type @charoff @numbering</xsl:text>
        </xsl:comment>
        <tgroup xmlns="urn:oecd:names:xmlns:authoring:document"
            cols="{@cols}" colsep="{@colsep}" rowsep="{@rowsep}" align="{@align}">
            <xsl:apply-templates/>
        </tgroup>
    </xsl:template>

    <xsl:template match="entry">
        <xsl:comment>
            <xsl:text>&#xa0; UNABLE to manage @rotate and @position</xsl:text>
        </xsl:comment>
        <entry xmlns="urn:oecd:names:xmlns:authoring:document"
            valign="{@valign}" align="{@align}" charoff="{@charoff}" morerows="{@morerows}">
            <xsl:apply-templates/>
        </entry>
    </xsl:template>

    
    <!-- inline level -->
    <xsl:template match="emphasis">
        <xsl:choose>
            <xsl:when test="@emph='normal' or @emph='caps' or @emph='bolditalic' or not(@emph)">
                <xsl:comment>emphasis/@emph=normal caps or bolditalic has no
                    equivalent</xsl:comment>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <emphasis xmlns="urn:oecd:names:xmlns:authoring:document">
                    <xsl:attribute name="style">
                        <xsl:choose>
                            <xsl:when test="@emph='bold'">bold</xsl:when>
                            <xsl:when test="@emph='italic'">italic</xsl:when>
                            <xsl:when test="@emph='underline'">underline</xsl:when>
                            <xsl:when test="@emph='strikeout'">strikethrough</xsl:when>
                            <xsl:when test="@emph='smallcaps'">small-caps</xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </emphasis>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="hyperlink">
        <!-- removed because missing an equivalent -->
        <xsl:call-template name="commentElement"/>
    </xsl:template>
    
    <xsl:template match="figure/source">
        <!-- removed because missing an equivalent -->
        <xsl:comment>
            <xsl:text>&#xa0; UNABLE to manage </xsl:text>
            <xsl:apply-templates select="self::*" mode="comment"/>
        </xsl:comment>
    </xsl:template>

    <xsl:template match="xref|fignoteref">
        <!-- nothing done for now, no equivalent. -->
        <xsl:call-template name="commentElement"/>
    </xsl:template>
    <xsl:template match="shortcitation">
        <emphasis xmlns="urn:oecd:names:xmlns:authoring:document" style="italic">
            <xsl:apply-templates/>
        </emphasis>
    </xsl:template>
    
    
    
    <!-- default transformations -->
    <xsl:template match="text()|comment()" priority="-100">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="@*" priority="-100">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="*" priority="-100">
        <xsl:message>
            <xsl:value-of select="concat('!!!! unknown element ',local-name())"/>
        </xsl:message>
        <xsl:element name="d:{local-name()}">
            <xsl:apply-templates select="*|@*|text()|comment()"/>
        </xsl:element>
    </xsl:template>

    <!-- named tempates -->
    <xsl:template name="commentElement">
        <xsl:comment>
            <xsl:text>&#xa0; UNABLE to manage </xsl:text>
            <xsl:apply-templates select="self::*" mode="comment"/>
        </xsl:comment>
    </xsl:template>

    <!-- default -->
    <xsl:template match="*" mode="comment">
        <xsl:value-of select="concat('&lt; ',local-name())"/>
        <xsl:apply-templates select="@*" mode="comment"/>
        <xsl:text>></xsl:text>
        <xsl:apply-templates select="*|text()|comment()" mode="comment"/>
        <xsl:value-of select="concat('&lt;/',local-name(),'&gt;')"/>
    </xsl:template>
    <xsl:template match="@*" mode="comment">
        <xsl:value-of select="concat(' ',local-name(),'=',.)"/>
    </xsl:template>
</xsl:stylesheet>