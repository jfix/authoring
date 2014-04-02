<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:pxp="http://exproc.org/proposed/steps" name="docx2xml"
	xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
	xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
	xmlns:prop="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties"
	xmlns:rels="http://schemas.openxmlformats.org/package/2006/relationships" version="1.0"
	type="ccproc:docx2xml" xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
	xmlns:cx="http://xmlcalabash.com/ns/extensions"
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
					<revision>
						<revnumber>9</revnumber>
						<date>2014-01-15</date>
						<revremark>Update to read .rels files to locate content rather
						than using try/catch and fallbacks.</revremark>
					</revision>
					<revision>
						<revnumber>9</revnumber>
						<date>2014-04-1</date>
						<revremark>Improve the approach to identify the URLs to files to be
						loaded from the rels files.</revremark>
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

	<p:declare-step name="find-docs-in-archive" type="ccproc:find-docs-in-archive">
		
		
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>Load the rels documents and return a sequence of file
				names to be extracted.</p>
		</p:documentation>
		
		
		<p:output port="result" primary="true"/>
		<p:option name="archive" required="true"/>
		
		<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
		
		<!-- get the zip contents -->
		<pxp:unzip name="list-zip">
			<p:with-option name="href" select="$archive"/>
		</pxp:unzip>
		
		<!-- find the rels files and process them -->
		<p:for-each name="extract-rels">
			
			<p:output port="result" primary="true">
				<p:pipe port="result" step="transform-rels"/>
			</p:output>
			
			<!-- get the file name from the list step -->
			<p:iteration-source select="//c:file[ends-with(@name, '.rels')]">
				<p:pipe port="result" step="list-zip"/>
			</p:iteration-source>
			
			<!-- load the file -->
			<pxp:unzip name="get-rels-file">
				<p:with-option name="href" select="$archive"/>
				<p:with-option name="file" select="/c:file/@name"/>
			</pxp:unzip>	


			<!-- make these relative to the root not the rels file -->
			<p:xslt name="transform-rels">
				<p:input port="source">
					<p:pipe port="result" step="get-rels-file"/>
				</p:input>
				<p:input port="parameters">
					<p:empty/>
				</p:input>
				<p:input port="stylesheet">
					<p:document href="../xslt/misc/fixup-rels.xsl"/>
				</p:input>
				<p:with-param name="base-uri" select="concat('/', /c:file/@name)">
					<p:pipe port="current" step="extract-rels"/>
				</p:with-param>
			</p:xslt>	
			
		</p:for-each>
		
		<p:wrap-sequence wrapper="rels" wrapper-namespace="http://www.corbas.co.uk/ns/cword" name="wrap-rels">
			<p:input port="source">
				<p:pipe port="result" step="extract-rels"/>
			</p:input>
		</p:wrap-sequence>		
		
			
		
	</p:declare-step>



	<p:declare-step name="load-docs-from-archive" type="ccproc:load-docs-from-archive">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>Calls find-docs-in-archive and the extracts each file marked as xml
			from the archive. </p>
		</p:documentation>
		
		<p:output port="result" primary="true"  sequence="true">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>Returns a sequence of documents read from the archive</p>
			</p:documentation>
		</p:output>
		
		<p:option name="archive" required="true">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>URI for the archive file</p>
			</p:documentation>
		</p:option>
		
		<ccproc:find-docs-in-archive>
			<p:with-option name="archive" select="$archive"/>
		</ccproc:find-docs-in-archive>
		
		<p:for-each name="load-files">
			
			<p:output port="result" primary="true">
				<p:pipe port="result" step="file-to-primary"/>
			</p:output>
			
			<p:iteration-source select="//c:file[@type='xml']"/>
			
			<pxp:unzip name="get-zipped-file" >
				<p:with-option name="href" select="$archive"/>
				<p:with-option name="file" select="/c:file/@href"/>
			</pxp:unzip>
			
			<p:identity name="file-to-primary">
				<p:input port="source">
					<p:pipe port="result" step="get-zipped-file"/>
				</p:input>
			</p:identity>	
			
		</p:for-each>
		
		
	</p:declare-step>


	<ccproc:load-docs-from-archive name="load-docs">
		<p:with-option name="archive" select="$package-url"/>
	</ccproc:load-docs-from-archive>
	
	<p:wrap-sequence name="wrap-up" wrapper="word-doc"
		wrapper-namespace="http://www.corbas.co.uk/ns/word"/>

	<p:add-attribute name="insert-url" xmlns:cword="http://www.corbas.co.uk/ns/word"
		attribute-name="package-url" match="/cword:word-doc">
		<p:with-option name="attribute-value" select="$package-url"/>
	</p:add-attribute>


	<p:identity name="the-end"/>


</p:declare-step>
