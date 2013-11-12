<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
	xmlns:temp="urn:oecd:names:xmlns:transform:temp"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0" name="compare-xml-docx">
	
	<p:documentation xmlns="http://www.w3.org/1999/xhtml">
		<p>Generate a stripped down version of the word document with style names and paragraphs only, compare
		that to the XML document using the Quark config as a key between style and element.</p>
	</p:documentation>
	
	<p:input port="config">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>The QXA configuration file to be used as the key across
			XML and docx version of the document.</p>
		</p:documentation>
	</p:input>
		
	<p:input port="xml-document">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>The XML version of the document.</p>
		</p:documentation>
	</p:input>
	
	<p:input port="parameters" kind="parameter" primary="true"/>
	
	
	<p:output port="result" primary="true">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>The comparison result.</p>
		</p:documentation>
		<p:pipe port="result" step="compare-pairs"/>
	</p:output>
	
	<p:option name="word-document" required="true">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>The docx version of the document. This has to be passed as an option
			as docx files can't be sources (they're not xml).</p>
		</p:documentation>
	</p:option>
	
	<p:import href="docx2xml.xpl"/>
	
	<!-- Convert the docx file into a single XML document -->
	<ccproc:docx2xml name="extract-doc">
 		<p:with-option name="package-url" select="$word-document"/>
	</ccproc:docx2xml>
	
	<p:store href="/tmp/extracted.xml"/>
	
	
	<!-- Filter the word document down to a set of blocks of text
	with their styles as attributes. -->
	<p:xslt version="2.0" name="filter-word-doc">
		<p:input port="stylesheet">
			<p:document href="../xsl/filter-word-document.xsl"/>
		</p:input>
		<p:input port="source">
			<p:pipe port="result" step="extract-doc"/>
		</p:input>		
	</p:xslt>
	
	
	<!-- Filter the XML document down to a set of blocks of text
	with their styles as above. There are a couple of complexities
	to this documented in the stylesheet -->
	<p:xslt version="2.0" name="filter-xml-doc">
		<p:input port="source">
			<p:pipe port="xml-document" step="compare-xml-docx"/>
		</p:input>
		<p:input port="stylesheet">
			<p:document href="../xsl/filter-xml-document.xsl"/>
		</p:input>
	</p:xslt>
	
	<!-- Take the temp:block elements from the xml document and
		convert them to a sequence -->
	<p:filter select="//temp:block" name="split-xml-doc">
		<p:input port="source">
			<p:pipe port="result" step="filter-xml-doc"/>
		</p:input>
	</p:filter>
	
	
	<!-- Do the same with the temp:block elements from the
		word document -->
	<p:filter select="//temp:block" name="split-word-doc">
		<p:input port="source">
			<p:pipe port="result" step="filter-word-doc"/>
		</p:input>
	</p:filter>
	
	<!-- Do a pairwise wrap of those so that each matching element from the above steps are
		wrapped intot a temp:block-pair element. -->
	<p:pack wrapper="block-pair"  wrapper-namespace="urn:oecd:names:xmlns:transform:temp" name="wrap-pairs">
		<p:input port="source">
			<p:pipe port="result" step="split-xml-doc"/>
		</p:input>
		<p:input port="alternate">
			<p:pipe port="result" step="split-word-doc"/>
		</p:input>		
	</p:pack>
	
	<!-- Wrap the resulting sequence in a temp:paired-doc element to create a new XML file that contains
		multiple temp:pair-block elements, each of which contains an element from the XML file and
		an element from the docx file -->
	<p:wrap-sequence wrapper="paired-doc"  wrapper-namespace="urn:oecd:names:xmlns:transform:temp" name="paired-docs">
		<p:input port="source">
			<p:pipe port="result" step="wrap-pairs"></p:pipe>
		</p:input>
	</p:wrap-sequence>
	
	<!-- Process the config to get a list of class attributes
		that we might expect -->
	<p:xslt version="2.0" name="build-style-mapping">
		<p:input port="stylesheet">
			<p:document href="../xsl/quark-style-mapping.xsl"/>
		</p:input>
		<p:input port="source">
			<p:pipe port="config" step="compare-xml-docx"/>
		</p:input>
	</p:xslt> 


	<!-- Now wrap that and the result of mapping the styles into a single document - 
		there doesn't seem to be a sensible way of passing two documents into XSLT without
		using a calabash extension -->
	<p:identity name="combine-xml">
		<p:input port="source">
			<p:pipe port="result" step="build-style-mapping"/>
			<p:pipe port="result" step="paired-docs"/>
		</p:input>
	</p:identity>
	
	<p:wrap-sequence wrapper="doc-wrapper" wrapper-namespace="urn:oecd:names:xmlns:transform:temp" name="docs-wrapped"/>
	
	<!-- Compare the textual content of the pairs. The way that QXA writes out the styling means that 
	content which has an upper case style appear to be upper cased in the output so we compare case
	insensitively. Matching content is suppressed but mismatched content is output. -->
	<p:xslt name="compare-pairs" version="2.0">
		<p:input port="stylesheet">
			<p:document href="../xsl/compare-docs.xsl"></p:document>
		</p:input>
		<p:input port="source">
			<p:pipe port="result" step="docs-wrapped"/>
		</p:input>
	</p:xslt>
	
	

</p:declare-step>