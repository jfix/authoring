<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:pxf="http://exproc.org/proposed/steps/file"
	xmlns:oecdstep="urn:oecd:names:xmlns:xproc:steps"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
	xmlns:cx="http://xmlcalabash.com/ns/extensions"
	xmlns:tmp="urn:oecd:names:xmlns:transform:temp"
	name="element-coverage" type="oecdstep:element-coverage"
	xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
	
	<p:documentation xmlns="http://docbook.org/ns/docbook">
		<para>This module is used to check the elements used in a document or set of documents against
		a schema and report on which documents use which elements from the set defined in the schema.
		Only those elements in the top level schema namespace are explored in detail - if an element
		contains elements in a different namespace only the top level element is considered.</para>
	</p:documentation>

	<p:input port="schema">
		<p:documentation xmlns="http://docbook.org/ns/docbook">
			<para>Top level XML Schema for document. This schema must the be the output of Oxygen's
			flatten schema command</para>
		</p:documentation>
	</p:input>
	
	<p:input port="documents" sequence="true"/>
	
	
	<p:output port="result" primary="true">
		<p:pipe port="result" step="generate-usage-report"/>
	</p:output>
	
	<p:serialization port="result" version="5.0" method="html"/>
	
	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

	<!-- get the list of elements in the schema -->
	<p:xslt version="2.0" name="extract-schema-elements">
		<p:input port="source">
			<p:pipe port="schema" step="element-coverage"/>
		</p:input>
		<p:input port="parameters">
			<p:empty/>
		</p:input>
		<p:input port="stylesheet">
			<p:document href="../xsl/schema-elements.xsl"/>
		</p:input>
	</p:xslt>
	
	<!-- convert the schema listing into a stylesheet to process the files -->
	<p:xslt name="build-schema-coverage" version="2.0">
		<p:input port="source">
			<p:pipe port="result" step="extract-schema-elements"/>
		</p:input>
		<p:input port="parameters">
			<p:empty/>
		</p:input>
		<p:input port="stylesheet">
			<p:document href="../xsl/build-schema-coverage.xsl"/>
		</p:input>
	</p:xslt>
	
	<!-- Loop over all the input documents, applying the preceding stylesheet to them -->
	<p:for-each name="loop-documents">
		
		<p:output port="results" primary="true"/>
		
		<p:iteration-source select="//manifest:item">
			<p:pipe port="documents" step="element-coverage"/>
		</p:iteration-source>
		
		<p:variable name="current-url" select="/manifest:item/@href"/>
		
		<p:load name="single-doc">
			<p:with-option name="href" select="$current-url"/>
		</p:load>
		
		<p:xslt>
			<p:input port="stylesheet">
				<p:pipe port="result" step="build-schema-coverage"/>
			</p:input>
			<p:input port="source">
				<p:pipe port="result" step="single-doc"></p:pipe>
			</p:input>
			<p:with-param name="document-uri" select="$current-url"/>
		</p:xslt>
		
	</p:for-each>
	
	<p:wrap-sequence wrapper="tmp:documents" name="wrapped">
		<p:input port="source">
			<p:pipe port="results" step="loop-documents"/>
		</p:input>
	</p:wrap-sequence>
	
	<p:xslt name="generate-usage-report">
		<p:input port="source">
			<p:pipe port="result" step="wrapped"/>
		</p:input>
		<p:input port="stylesheet">
			<p:document href="../xsl/summarise-schemas.xsl"/>
		</p:input>
		<p:input port="parameters">
			<p:empty/>
		</p:input>
	</p:xslt>
	

</p:declare-step>