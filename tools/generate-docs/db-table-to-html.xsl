<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
	xpath-default-namespace="http://docbook.org/ns/docbook" exclude-result-prefixes="doc" version="2.0">


	<xsl:template match="informaltable|table">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tgroup">
		<table>

			<xsl:if test="../@pgwide=1">
				<xsl:attribute name="width">100%</xsl:attribute>
			</xsl:if>

			<xsl:if test="@align">
				<xsl:attribute name="align">
					<xsl:value-of select="@align"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="../@frame='none'">
					<xsl:attribute name="border">0</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="border">1</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:variable name="colgroup">
				<colgroup>
					<xsl:call-template name="generate.colgroup">
						<xsl:with-param name="cols" select="@cols"/>
					</xsl:call-template>
				</colgroup>
			</xsl:variable>
			<xsl:copy-of select="$colgroup"/>

			<xsl:apply-templates/>

			<xsl:if test=".//footnote">
				<tr>
					<td colspan="{@cols}">
						<xsl:apply-templates select=".//footnote" mode="table.footnote.mode"/>
					</td>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>


	<xsl:template match="colspec"/>

	<xsl:template match="spanspec"/>

	<xsl:template match="thead|tfoot">
		<xsl:element name="{name(.)}">
			<xsl:if test="@align">
				<xsl:attribute name="align">
					<xsl:value-of select="@align"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@char">
				<xsl:attribute name="char">
					<xsl:value-of select="@char"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@charoff">
				<xsl:attribute name="charoff">
					<xsl:value-of select="@charoff"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@valign">
				<xsl:attribute name="valign">
					<xsl:value-of select="@valign"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="tbody">
		<tbody>
			<xsl:if test="@align">
				<xsl:attribute name="align">
					<xsl:value-of select="@align"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@char">
				<xsl:attribute name="char">
					<xsl:value-of select="@char"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@charoff">
				<xsl:attribute name="charoff">
					<xsl:value-of select="@charoff"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@valign">
				<xsl:attribute name="valign">
					<xsl:value-of select="@valign"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates/>
		</tbody>
	</xsl:template>

	<xsl:template match="row">
		<tr>
			<xsl:if test="@align">
				<xsl:attribute name="align">
					<xsl:value-of select="@align"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@char">
				<xsl:attribute name="char">
					<xsl:value-of select="@char"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@charoff">
				<xsl:attribute name="charoff">
					<xsl:value-of select="@charoff"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@valign">
				<xsl:attribute name="valign">
					<xsl:value-of select="@valign"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates/>
		</tr>
	</xsl:template>

	<xsl:template match="thead/row/entry">
		<xsl:variable name="colnum">
			<xsl:call-template name="entry.colnum"/>
		</xsl:variable>
		<xsl:variable name="colspec" select="./ancestor::tgroup/colspec[@colnum=$colnum]"/>
		<xsl:call-template name="process.cell">
			<xsl:with-param name="cellgi">th</xsl:with-param>
			<xsl:with-param name="colspec" select="$colspec"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="tbody/row/entry">
		<xsl:variable name="colnum">
			<xsl:call-template name="entry.colnum"/>
		</xsl:variable>
		<xsl:variable name="colspec" select="./ancestor::tgroup/colspec[@colnum=$colnum]"/>
		<xsl:call-template name="process.cell">
			<xsl:with-param name="cellgi">td</xsl:with-param>
			<xsl:with-param name="colspec" select="$colspec"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="tfoot/row/entry">
		<xsl:variable name="colnum">
			<xsl:call-template name="entry.colnum"/>
		</xsl:variable>
		<xsl:variable name="colspec" select="./ancestor::tgroup/colspec[@colnum=$colnum]"/>
		<xsl:call-template name="process.cell">
			<xsl:with-param name="cellgi">th</xsl:with-param>
			<xsl:with-param name="colspec" select="$colspec"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="process.cell">
		<xsl:param name="cellgi">td</xsl:param>
		<xsl:param name="colspec"/>
		<xsl:variable name="empty.cell" select="count(node()) = 0"/>

		<xsl:variable name="entry.colnum">
			<xsl:call-template name="entry.colnum"/>
		</xsl:variable>

		<xsl:variable name="align">
			<xsl:choose>
				<xsl:when test="@align">
					<xsl:value-of select="@align"/>
				</xsl:when>
				<xsl:when test="$colspec/@align">
					<xsl:value-of select="$colspec/@align"/>
				</xsl:when>
				<xsl:otherwise>left</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$entry.colnum != ''">
			<xsl:variable name="prev.entry" select="preceding-sibling::*[1]"/>
			<xsl:variable name="prev.ending.colnum">
				<xsl:choose>
					<xsl:when test="$prev.entry">
						<xsl:call-template name="entry.ending.colnum">
							<xsl:with-param name="entry" select="$prev.entry"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:call-template name="add-empty-entries">
				<xsl:with-param name="number">
					<xsl:choose>
						<xsl:when test="$prev.ending.colnum = ''">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$entry.colnum - $prev.ending.colnum - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>

		<xsl:element name="{$cellgi}">
			<xsl:if test="@morerows">
				<xsl:attribute name="rowspan">
					<xsl:value-of select="@morerows+1"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@namest">
				<xsl:attribute name="colspan">
					<xsl:call-template name="calculate.colspan"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="$align">
				<xsl:attribute name="align">
					<xsl:value-of select="$align"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="@char">
				<xsl:attribute name="char">
					<xsl:value-of select="@char"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@charoff">
				<xsl:attribute name="charoff">
					<xsl:value-of select="@charoff"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@valign">
				<xsl:attribute name="valign">
					<xsl:value-of select="@valign"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="not(preceding-sibling::*)                   and ancestor::row/@id">
				<a name="{ancestor::row/@id}"/>
			</xsl:if>

			<xsl:if test="@id">
				<a name="{@id}"/>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="$empty.cell">
					<xsl:text>&#xA0;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$align">
							<xsl:apply-templates>
								<xsl:with-param name="align" select="$align"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<xsl:template name="add-empty-entries">
		<xsl:param name="number" select="'0'"/>
		<xsl:choose>
			<xsl:when test="$number &lt;= 0"/>
			<xsl:otherwise>
				<td>&#xA0;</td>
				<xsl:call-template name="add-empty-entries">
					<xsl:with-param name="number" select="$number - 1"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<doc:template name="add-empty-entries" xmlns="">
		<refpurpose>Insert empty TDs into a table row</refpurpose>
		<refdescription>
			<para>This template inserts empty TDs into a table row.</para>
		</refdescription>
		<refparameter>
			<variablelist>
				<varlistentry>
					<term>number</term>
					<listitem>
						<para>The number of empty TDs to add.</para>
					</listitem>
				</varlistentry>
			</variablelist>
		</refparameter>
		<refreturn>
			<para>Nothing</para>
		</refreturn>
	</doc:template>

	<xsl:template name="entry.colnum">
		<xsl:param name="entry" select="."/>

		<xsl:choose>
			<xsl:when test="$entry/@colname">
				<xsl:variable name="colname" select="$entry/@colname"/>
				<xsl:variable name="colspec" select="$entry/ancestor::tgroup/colspec[@colname=$colname]"/>
				<xsl:call-template name="colspec.colnum">
					<xsl:with-param name="colspec" select="$colspec"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$entry/@namest">
				<xsl:variable name="namest" select="$entry/@namest"/>
				<xsl:variable name="colspec" select="$entry/ancestor::tgroup/colspec[@colname=$namest]"/>
				<xsl:call-template name="colspec.colnum">
					<xsl:with-param name="colspec" select="$colspec"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="count($entry/preceding-sibling::*) = 0">1</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="pcol">
					<xsl:call-template name="entry.ending.colnum">
						<xsl:with-param name="entry" select="$entry/preceding-sibling::*[1]"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$pcol + 1"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<doc:template name="entry.colnum" xmlns="">
		<refpurpose>Determine the column number in which a given entry occurs</refpurpose>
		<refdescription>
			<para>If an <sgmltag>entry</sgmltag> has a <sgmltag class="attribute">colname</sgmltag>or <sgmltag
					class="attribute">namest</sgmltag>attribute, this template will determine the number of
				the column in which the entry should occur. For other <sgmltag>entry</sgmltag>s, nothing is
				returned.</para>
		</refdescription>
		<refparameter>
			<variablelist>
				<varlistentry>
					<term>entry</term>
					<listitem>
						<para>The <sgmltag>entry</sgmltag>-element which is to be tested.</para>
					</listitem>
				</varlistentry>
			</variablelist>
		</refparameter>

		<refreturn>
			<para>This template returns the column number if it can be determined, or nothing (the empty
				string)</para>
		</refreturn>
	</doc:template>

	<xsl:template name="entry.ending.colnum">
		<xsl:param name="entry" select="."/>

		<xsl:choose>
			<xsl:when test="$entry/@colname">
				<xsl:variable name="colname" select="$entry/@colname"/>
				<xsl:variable name="colspec" select="$entry/ancestor::tgroup/colspec[@colname=$colname]"/>
				<xsl:call-template name="colspec.colnum">
					<xsl:with-param name="colspec" select="$colspec"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$entry/@nameend">
				<xsl:variable name="nameend" select="$entry/@nameend"/>
				<xsl:variable name="colspec" select="$entry/ancestor::tgroup/colspec[@colname=$nameend]"/>
				<xsl:call-template name="colspec.colnum">
					<xsl:with-param name="colspec" select="$colspec"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="count($entry/preceding-sibling::*) = 0">1</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="pcol">
					<xsl:call-template name="entry.ending.colnum">
						<xsl:with-param name="entry" select="$entry/preceding-sibling::*[1]"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$pcol + 1"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="colspec.colnum">
		<xsl:param name="colspec" select="."/>
		<xsl:choose>
			<xsl:when test="$colspec/@colnum">
				<xsl:value-of select="$colspec/@colnum"/>
			</xsl:when>
			<xsl:when test="$colspec/preceding-sibling::colspec">
				<xsl:variable name="prec.colspec.colnum">
					<xsl:call-template name="colspec.colnum">
						<xsl:with-param name="colspec" select="$colspec/preceding-sibling::colspec[1]"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$prec.colspec.colnum + 1"/>
			</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="generate.colgroup">
		<xsl:param name="cols" select="1"/>
		<xsl:param name="count" select="1"/>
		<xsl:choose>
			<xsl:when test="$count&gt;$cols"/>
			<xsl:otherwise>
				<xsl:call-template name="generate.col">
					<xsl:with-param name="countcol" select="$count"/>
				</xsl:call-template>
				<xsl:call-template name="generate.colgroup">
					<xsl:with-param name="cols" select="$cols"/>
					<xsl:with-param name="count" select="$count+1"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="generate.col">
		<xsl:param name="countcol">1</xsl:param>
		<xsl:param name="colspecs" select="./colspec"/>
		<xsl:param name="count">1</xsl:param>
		<xsl:param name="colnum">1</xsl:param>

		<xsl:choose>
			<xsl:when test="$count&gt;count($colspecs)">
				<col/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="colspec" select="$colspecs[$count=position()]"/>
				<xsl:variable name="colspec.colnum">
					<xsl:choose>
						<xsl:when test="$colspec/@colnum">
							<xsl:value-of select="$colspec/@colnum"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$colnum"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:choose>
					<xsl:when test="$colspec.colnum=$countcol">
						<col>
							<xsl:if test="$colspec/@colwidth">
								<xsl:attribute name="width">
									<xsl:value-of select="$colspec/@colwidth"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="$colspec/@align">
								<xsl:attribute name="align">
									<xsl:value-of select="$colspec/@align"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="$colspec/@char">
								<xsl:attribute name="char">
									<xsl:value-of select="$colspec/@char"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="$colspec/@charoff">
								<xsl:attribute name="charoff">
									<xsl:value-of select="$colspec/@charoff"/>
								</xsl:attribute>
							</xsl:if>
						</col>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="generate.col">
							<xsl:with-param name="countcol" select="$countcol"/>
							<xsl:with-param name="colspecs" select="$colspecs"/>
							<xsl:with-param name="count" select="$count+1"/>
							<xsl:with-param name="colnum">
								<xsl:choose>
									<xsl:when test="$colspec/@colnum">
										<xsl:value-of select="$colspec/@colnum + 1"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$colnum + 1"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="colspec.colwidth">
		<!-- when this macro is called, the current context must be an entry -->
		<xsl:param name="colname"/>
		<!-- .. = row, ../.. = thead|tbody, ../../.. = tgroup -->
		<xsl:param name="colspecs" select="../../../../tgroup/colspec"/>
		<xsl:param name="count">1</xsl:param>
		<xsl:choose>
			<xsl:when test="$count&gt;count($colspecs)"/>
			<xsl:otherwise>
				<xsl:variable name="colspec" select="$colspecs[$count=position()]"/>
				<xsl:choose>
					<xsl:when test="$colspec/@colname=$colname">
						<xsl:value-of select="$colspec/@colwidth"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="colspec.colwidth">
							<xsl:with-param name="colname" select="$colname"/>
							<xsl:with-param name="colspecs" select="$colspecs"/>
							<xsl:with-param name="count" select="$count+1"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="calculate.colspan">
		<xsl:param name="entry" select="."/>
		<xsl:variable name="namest" select="$entry/@namest"/>
		<xsl:variable name="nameend" select="$entry/@nameend"/>

		<xsl:variable name="scol">
			<xsl:call-template name="colspec.colnum">
				<xsl:with-param name="colspec" select="$entry/ancestor::tgroup/colspec[@colname=$namest]"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="ecol">
			<xsl:call-template name="colspec.colnum">
				<xsl:with-param name="colspec" select="$entry/ancestor::tgroup/colspec[@colname=$nameend]"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:value-of select="$ecol - $scol + 1"/>
	</xsl:template>

	<xsl:template match="table/title">
		<h3>
			<xsl:value-of select="."/>
		</h3>
	</xsl:template>
</xsl:stylesheet>
