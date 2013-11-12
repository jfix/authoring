<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
	name="docx2xml"
	xmlns:pxp="http://exproc.org/proposed/steps"
	xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
	xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
	xmlns:prop="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties"
	xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships" version="1.0"
	type="ccproc:docx2xml" xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
	xmlns:cword="http://www.corbas.co.uk/ns/cword">
	
	<p:documentation>
		
		This program and accompanying files are copyright 2008, 2009, 20011, 2012, 2013 Corbas Consulting Ltd.
		
		This program is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.
		
		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		
		You should have received a copy of the GNU General Public License
		along with this program.  If not, see http://www.gnu.org/licenses/.
		
		If your organisation or company are a customer or client of Corbas Consulting Ltd you may
		be able to use and/or distribute this software under a different license. If you are
		not aware of any such agreement and wish to agree other license terms you must
		contact Corbas Consulting Ltd by email at corbas@corbas.co.uk. 
		
	</p:documentation>

	<p:documentation>
		<section xmlns="http://docbook.org/ns/docbook">
			<info> <title>docx2xml.xpl</title>
				<author><personname>Nic Gibson</personname></author>
				<revhistory>
					<revision>
						<revnumber>1</revnumber>
						<date>2010-02-08</date>
						<revremark>Initial Version</revremark>
					</revision>
					<revision>
						<revnumber>2</revnumber>
						<date>2010-03-19</date>
						<revremark>Added support for loading and merging the document.xml.rels file
							in order to access URLs for linked images.</revremark>
					</revision>
					<revision>
						<revnumber>2</revnumber>
						<date>2010-03-29</date>
						<revremark>Added support for loading app.xml for document properties and
							numbering.xml for list handling.</revremark>
					</revision>
					<revision>
						<revnumber>3</revnumber>
						<date>2010-04-11</date>
						<revremark> Added support for footnote, endnote and styles files.
						</revremark>
					</revision>
					<revision>
						<revnumber>4</revnumber>
						<date>2010-04-12</date>
						<revremark> Added wrappers around all loaders to handle missing xml files.
						</revremark>
					</revision>
					<revision>
						<revnumber>5</revnumber>
						<date>2012-05-12</date>
						<revremark>Added core and app properties</revremark>
					</revision>
					<revision>
						<revnumber>6</revnumber>
						<date>2012-07-02</date>
						<revremark>Added omitted relationships doc</revremark>
					</revision>
					<revision>
						<revnumber>7</revnumber>
						<date>2012-07-04</date>
						<revremark>Added comments so we can insert as XML comments into the xml
							doc.</revremark>
					</revision>
					<revision>
						<revnumber>8</revnumber>
						<date>2012-10-11</date>
						<revremark>Added footnotes.xml.rels and endnotes.xml.rels</revremark>
					</revision>
				</revhistory>
			</info>
			<para>XProc script to unzip a word docx document, extract metadata and convert to
				DocBook xml</para>
			<para>Input is the url for the docx file supplied as an option named
				'package-url'.</para>
		</section>
	</p:documentation>

	<p:output port="result" primary="true">
		<p:documentation>
			<para xmlns="http://docbook.org/ns/docbook">The result of this step is the primary XML
				documents in the word document loaded into a single XML document wrapped into a
					<markup class="element">word-doc</markup> element in the <markup
					class="namespace">http://www.corbas.co.uk/ns/cword</markup> namespace.</para>
		</p:documentation>
		<p:pipe port="result" step="the-end"/>
	</p:output>

	<p:option name="package-url" required="true">
		<p:documentation>
			<para xmlns="http://docbook.org/ns/docbook">The <code>package-uri</code> option defines
				the word document to be loaded and processed.</para>
		</p:documentation>
	</p:option>

	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>



	<p:declare-step name="get-doc-from-archive" type="ccproc:get-doc-from-archive">

		<p:documentation>
			<section xmlns="http://docbook.org/ns/docbook">
				<title>corbas:get-doc-from-archive</title>
				<para>Step to extract a file from an archive and fall back to a default if not
					found.</para>
			</section>
		</p:documentation>

		<p:input port="fallback" primary="false"/>
		<p:output port="result" primary="true">
			<p:pipe port="result" step="extract-doc"/>
		</p:output>
		<p:option name="archive" required="true"/>
		<p:option name="doc" required="true"/>
		
		<pxp:unzip name="get-zip-listing">
			<p:with-option name="href" select="$archive"/>
		</pxp:unzip>
		
		<p:identity name="primary-zip-listing">
			<p:input port="source">
				<p:pipe port="result" step="get-zip-listing"/>
			</p:input>
		</p:identity>
		
		<p:choose name="extract-doc">

			<p:when test="//c:file[@name = $doc]">
				<p:output port="result" primary="true">
					<p:pipe port="result" step="get-zip-file"/>
				</p:output>
				<pxp:unzip name="get-zip-file">
					<p:with-option name="href" select="$archive"/>
					<p:with-option name="file" select="$doc"/>
				</pxp:unzip>
			</p:when>
			<p:otherwise>
				<p:output port="result" primary="true">
					<p:pipe port="result" step="use-fallback"/>
				</p:output>
				<p:identity name="use-fallback">
					<p:input port="source">
						<p:pipe port="fallback" step="get-doc-from-archive"/>
					</p:input>
				</p:identity>
			</p:otherwise>
		</p:choose>

	</p:declare-step>



	<ccproc:get-doc-from-archive name="get-styles">
		<p:input port="fallback">
			<p:inline>
				<w:styles/>
			</p:inline>
		</p:input>
		<p:with-option name="archive" select="$package-url"/>
		<p:with-option name="doc" select="'word/styles.xml'"/>
	</ccproc:get-doc-from-archive>

	<ccproc:get-doc-from-archive name="get-endnotes">
		<p:input port="fallback">
			<p:inline>
				<w:endnotes/>
			</p:inline>
		</p:input>
		<p:with-option name="archive" select="$package-url"/>
		<p:with-option name="doc" select="'word/endnotes.xml'"/>
	</ccproc:get-doc-from-archive> 
 
	<ccproc:get-doc-from-archive name="get-numbering">
		<p:input port="fallback">
			<p:inline>
				<w:numbering/>
			</p:inline>
		</p:input>
		<p:with-option name="archive" select="$package-url"/>
		<p:with-option name="doc" select="'word/numbering.xml'"/>
	</ccproc:get-doc-from-archive>

	<ccproc:get-doc-from-archive name="get-footnotes">
		<p:input port="fallback">
			<p:inline>
				<w:footnotes/>
			</p:inline>
		</p:input>
		<p:with-option name="archive" select="$package-url"/>
		<p:with-option name="doc" select="'word/footnotes.xml'"/>
	</ccproc:get-doc-from-archive>

	<ccproc:get-doc-from-archive name="get-doc">
		<p:input port="fallback">
			<p:inline>
				<w:document/>
			</p:inline>
		</p:input>
		<p:with-option name="archive" select="$package-url"/>
		<p:with-option name="doc" select="'word/document.xml'"/>
	</ccproc:get-doc-from-archive>

	<ccproc:get-doc-from-archive name="get-core-properties">
		<p:input port="fallback">
			<p:inline>
				<cp:coreProperties/>
			</p:inline>
		</p:input>
		<p:with-option name="archive" select="$package-url"/>
		<p:with-option name="doc" select="'docProps/core.xml'"/>
	</ccproc:get-doc-from-archive>


	<ccproc:get-doc-from-archive name="get-app-properties">
		<p:input port="fallback">
			<p:inline>
				<prop:Properties/>
			</p:inline>
		</p:input>
		<p:with-option name="archive" select="$package-url"/>
		<p:with-option name="doc" select="'docProps/app.xml'"/>
	</ccproc:get-doc-from-archive>


	<ccproc:get-doc-from-archive name="get-relationships">
		<p:input port="fallback">
			<p:inline>
				<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"
				/>
			</p:inline>
		</p:input>
		<p:with-option name="archive" select="$package-url"/>
		<p:with-option name="doc" select="'word/_rels/document.xml.rels'"/>
	</ccproc:get-doc-from-archive>
	
	<ccproc:get-doc-from-archive name="get-footnote-relationships">
		<p:input port="fallback">
			<p:inline>
				<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"
				/>
			</p:inline>
		</p:input>
		<p:with-option name="archive" select="$package-url"/>
		<p:with-option name="doc" select="'word/_rels/footnotes.xml.rels'"/>
	</ccproc:get-doc-from-archive>

	<ccproc:get-doc-from-archive name="get-endnote-relationships">
		<p:input port="fallback">
			<p:inline>
				<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"
				/>
			</p:inline>
		</p:input>
		<p:with-option name="archive" select="$package-url"/>
		<p:with-option name="doc" select="'word/_rels/endnotes.xml.rels'"/>
	</ccproc:get-doc-from-archive>


	<ccproc:get-doc-from-archive name="get-comments">
		<p:input port="fallback">
			<p:inline>
				<comments xmlns="http://schemas.openxmlformats.org/wordprocessingml/2006/main"/>
			</p:inline>
		</p:input>
		<p:with-option name="archive" select="$package-url"/>
		<p:with-option name="doc" select="'word/comments.xml'"/>
	</ccproc:get-doc-from-archive>

	<p:identity name="create-sequence">
		<p:input port="source">
			<p:pipe port="result" step="get-doc"/>
			<p:pipe port="result" step="get-styles"/>
			<p:pipe port="result" step="get-numbering"/>
			<p:pipe port="result" step="get-footnotes"/> 
			<p:pipe port="result" step="get-endnotes"/>
			<p:pipe port="result" step="get-app-properties"/>
			 <p:pipe port="result" step="get-core-properties"/>
			<p:pipe port="result" step="get-relationships"/>
			<p:pipe port="result" step="get-footnote-relationships"/>
			<p:pipe port="result" step="get-endnote-relationships"/>
			<p:pipe port="result" step="get-comments"/>
		</p:input>
	</p:identity>

	<p:wrap-sequence name="wrap-up" wrapper="word-doc"
		wrapper-namespace="http://www.corbas.co.uk/ns/word"/>

	<p:add-attribute name="insert-url" xmlns:cword="http://www.corbas.co.uk/ns/word"
		attribute-name="package-url" match="/cword:word-doc">
		<p:with-option name="attribute-value" select="$package-url"/>
	</p:add-attribute>


	<p:identity name="the-end"/>


</p:declare-step>
