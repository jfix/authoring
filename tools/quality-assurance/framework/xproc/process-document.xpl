<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"  xmlns:oecd="urn:oecd:names:xmlns:xproc"
	xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="process-document"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
 
 	<p:documentation xmlns="http://www.w3.org/1999/xhtml">
 		<h2>Process an XML source</h2> 
 		
 		<p>Process an XML source,passing it through validation and schematron processing and the generating a single report
 		from the results. This should be used directly agains XML output and used as a procedure for HTML processing
 		having first parsed the content using the tagsoup parser (see <a href="process-html-document.xpl">process-html-document.xpl</a>)</p>
 		
 	</p:documentation>
	
	<p:input port="source" primary="true">
		<p:documentation  xmlns="http://www.w3.org/1999/xhtml">
			<p>The source input port must refer to the input document to be parsed.</p>
		</p:documentation>
	</p:input>
	
	<p:input port="schema">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>The schema input port refers to the XML Schema for the document.</p>
		</p:documentation>
	</p:input>
	
	<p:input port="schematron" sequence="true">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>The schematron input port refers to the Schematron schema for the document. Multiple schematrons
			may be provided on this port.</p>
		</p:documentation>
	</p:input>
	
	<p:output port="result" primary="true">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>The result of the script is the HTML report detailing validation and schematron results.</p>
		</p:documentation>
	</p:output>
	
	<p:import href="xsd-validation-with-xpath.xpl"/>
	
	<p:declare-step name="merge-svrl" type="oecd:merge-svrl">
		
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>Given a sequence of inputs, each of which represents
				SVRL output, merge into a single SVRL document. The simplest
			way to do this is to wrap the sequence in a new svrl:schematron-output
			element and then unwrap the children. Then, all we need to do is
			slightly shuffle the content to ensure that the namespace declaration
			elements are before everything else.</p>
		</p:documentation>
		
		<p:input port="source" primary="true"  sequence="true">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>The input must be sequence of SVRL documents.</p>
			</p:documentation>
		</p:input>
		
		<p:output port="result" primary="true" sequence="false">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>The output is the merged SVRL document.</p>
			</p:documentation>
		</p:output>

		<!-- wrap the sequence to create a single document -->
		<p:wrap-sequence name="wrap-output" wrapper="svrl:schematron-output"/>
		
		<!-- remove the child wrappers -->
		<p:unwrap name="remove-children" match="svrl:schematron-output/svrl:schematron-output"/>
		
		<p:store href="/tmp/unwrapped.xml"/>
		
		<!-- shuffle the child elements -->
		<p:xslt name="move-children" version="2.0">
			<p:input port="source">
				<p:pipe port="result" step="remove-children"/>
			</p:input>
			<p:input port="parameters">
				<p:empty/>
			</p:input>
			<p:input port="stylesheet">
				<p:inline>
					<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
						<xsl:template match="svrl:schematron-output">
							<xsl:copy>
								<xsl:apply-templates select="@*"/>
								<xsl:copy-of select="(svrl:ns-prefix-in-attribute-values, * except svrl:ns-prefix-in-attribute-values)"/>
							</xsl:copy>
						</xsl:template>
					</xsl:stylesheet>
				</p:inline>
			</p:input>
		</p:xslt>
		
	</p:declare-step>
	
	<!-- validate agains the XML schema -->
	<oecd:xsd-validation name="validate-against-xsd">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>Process the input document with XSD, getting an SVRL document as the result.</p>
		</p:documentation>
		<p:input port="source">
			<p:pipe port="source" step="process-document"/>
		</p:input>
		<p:input port="schema">
			<p:pipe port="schema" step="process-document"/>
		</p:input>
	</oecd:xsd-validation>
	
	<!-- set the primary input to be the schematrons -->
	<p:identity name="set-primary">
		<p:input port="source">
			<p:pipe port="schematron" step="process-document"/>
		</p:input>
	</p:identity>
	
	<!-- for each schema, get the report -->
	<p:for-each name="validate-against-schematrons">
		
		<p:output port="result" primary="true" sequence="true">
			<p:pipe port="report" step="do-schematron"/>
		</p:output>
		
		<p:validate-with-schematron name="do-schematron">
			<p:input port="parameters">
				<p:empty/>
			</p:input>
			<p:input port="source">
				<p:pipe port="source" step="process-document"/>
			</p:input>
			<p:input port="schema">
				<p:pipe port="current" step="validate-against-schematrons"/>
			</p:input>
		</p:validate-with-schematron>
		
		<!-- not interested in the primary output of the validation (the input doc) -->
		<p:sink/>
		
	</p:for-each>	
	
	<!-- put the schematrons together -->
	<p:identity name="schematron-sequence">
		<p:input port="source">
			<p:pipe port="result" step="validate-against-xsd"/>
			<p:pipe port="result" step="validate-against-schematrons"/>
		</p:input>
	</p:identity>
		
	<!-- merge them -->
	<oecd:merge-svrl name="merge-results"/>
	
	<!-- force the primary input to be the source document so we can get
		the base uri for it -->
	<p:identity name="set-source-as-primary">
		<p:input port="source">
			<p:pipe port="source" step="process-document"/>
		</p:input>
	</p:identity>
			
	<!-- Use the result of the schematron processing (the merged
			SVRL doc) to create a stylesheet we can apply to the original
			source document for reporting-->
	<p:xslt version="2.0" name="create-reporter-stylesheet">
		<p:input port="parameters">
			<p:empty/>
		</p:input>
		<p:input port="stylesheet">
			<p:document href="../xsl/create-svrl-html-reporter.xsl"/>
		</p:input>
		<p:input port="source">
			<p:pipe port="result" step="merge-results"/>
		</p:input>
		
		<!-- base uri for the primary input (the source document) -->
		<p:with-param name='report-title' select="concat('Report on: ', base-uri(/))"/>
		
	</p:xslt>
	
	<!-- Apply the generated stylesheet to the original source
				document to create the annotated report. -->
	<p:xslt version="2.0" name="run-reporter-stylesheet">
		<p:input port="parameters">
			<p:empty/>
		</p:input>
		<p:input port="stylesheet">
			<p:pipe port="result" step="create-reporter-stylesheet"/>
		</p:input>
		<p:input port="source">
			<p:pipe port="source" step="process-document"/>
		</p:input>
	</p:xslt>
	
 
</p:declare-step>