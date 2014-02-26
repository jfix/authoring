<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:l="http://xproc.org/library" 
	xmlns:oecdstep="urn:oecd:names:xmlns:xproc:steps"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps" version="1.0">
	
	<!-- NDW's libary step to simplify validation -->
	<p:import href="validation.xpl"/>
	
	<!-- Calabash std extensions -->
	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	
	<!-- Corbas utility library -->
	<p:import href="temp-dir.xpl"/>
	
	<p:declare-step type="oecdstep:xsd-validation" name="xsd-validation">

		<p:input port="source" primary="true">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>The primary input is the document to be validated</p>
			</p:documentation>
		</p:input>
		
		<p:input port="schema">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>The schema which the document is to be validated agains</p>
			</p:documentation>
		</p:input>
		
		

		<p:output port="result" primary="true">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>The primary output is an SVRL document listing any errors in the validation</p>
			</p:documentation>			
			<p:pipe port="result" step="convert-to-svrl"/>
		</p:output>

		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<div class="info">
				<p>Author: Nic Gibson</p>
				<p>Email: nicg@corbas.co.uk</p>
				<p>Date: 08/10/2013</p>
			</div>
			<p>This step adds additional detail to the output of a validation step. The output of
				the validation is used along with a text representation of the input document to
				convert validation errors with line (and possibly column) numbers to XPath
				statements that provide approximate context for the result. </p>
			<p>This is achieved by loading the XML document as unparsed text, inserting an marker
				attribute into the document and then using <code>saxon:parse</code> to load the
				content. Once loaded, an XPath location for the element containing the marker is
				generated and returned.</p>
			<p>There are performance issues with this step when the input document is very large and
				there are many validation errors.</p>
			<p>Once the content has been reparsed and the error statements with XPaths generated,
				these are converted to SVRL output and returned.</p>
			<p>These XPaths are usable against the original doc because we do nothing that changed
			the XML structure itself.</p>
		</p:documentation>



		<p:xslt name="strip-excess">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>Create a tidied version of the XML with no XML declaration or comments with
					indenting on. This makes it easier to generate useful locations and XPaths for
					errors</p>
				<p>An issue with empty metadata nodes is also resolved here - whitespace only
				text is stripped to avoid confusing the schema validation.</p>
			</p:documentation>
			<p:input port="source">
				<p:pipe port="source" step="xsd-validation"/>
			</p:input>
			<p:input port="stylesheet">
				<p:inline>
					<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
						<xsl:template match="@*|node()">
							<xsl:copy>
								<xsl:apply-templates select="@*|node()"/>
							</xsl:copy>
						</xsl:template>
						
						<xsl:template match="*:metadata-item[normalize-space(.) = '']">
							<xsl:copy>
								<xsl:apply-templates select="@*"/>
							</xsl:copy>
						</xsl:template>

						<xsl:template match="processing-instruction()|comment()" priority="1"/>
					</xsl:stylesheet>
				</p:inline>
			</p:input>
			<p:input port="parameters">
				<p:empty/>
			</p:input>
		</p:xslt>

		<!-- write the file temp. URL of stored file on secondary output (href)
			of store-to-temp -->
		<oecdstep:store-to-temp name="store-stripped"/>

		<!-- ignore primary output -->
		<p:sink/>
		
	
		<!-- make secondary primary so we can get the name in the load below-->
		<p:identity>
			<p:input port="source">
				<p:pipe port="href" step="store-stripped"/>
			</p:input>
		</p:identity>

		
		<!-- load the stripped down document -->
		<p:load name="load-stripped">
			<p:with-option name="href" select="/c:result/text()"/>
		</p:load>
		
		<p:store  href="/tmp/stripped.xml">
			<p:input port="source">
				<p:pipe port="result" step="load-stripped"/>
			</p:input>
		</p:store>
	

		<!-- validate the stripped down doc -->
		<l:xml-schema-report name="validate">
			<p:input port="source">
				<p:pipe port="result" step="load-stripped"/>
			</p:input>
			<p:input port="schema">
				<p:pipe port="schema" step="xsd-validation"/>
			</p:input>
		</l:xml-schema-report>

		<!-- again, we have no interest in the primary output -->
		<p:sink/>
		
		<p:store href="/tmp/validation.xml">
			<p:input port="source">
				<p:pipe port="report" step="validate"/>
			</p:input>
		</p:store>
				
		<!-- force the stored file name to be in the primary port again -->
		<p:identity>
			<p:input port="source">
				<p:pipe port="href" step="store-stripped"/>
			</p:input>
		</p:identity>

		<!-- process the report output with XSLT, providing the xml doc URL as
			as a string -->
		<p:xslt name="insert-error-markers">
			<p:input port="source">
				<p:pipe port="report" step="validate"/>
			</p:input>
			<p:input port="stylesheet">
				<p:document href="../xsl/insert-error-markers.xsl"/>
			</p:input>
			<p:with-param name="xml-file" select="/c:result/text()"/>
		</p:xslt>
		
		
		<!-- now process the c:errors to turn to svrl -->
		<p:xslt name="convert-to-svrl">
			<p:input port="source">
				<p:pipe port="result" step="insert-error-markers"/>
			</p:input>
			<p:input port="stylesheet">
				<p:document href="../xsl/validation-errors-to-svrl.xsl"/>
			</p:input>
			<p:input port="parameters">
				<p:empty/>
			</p:input>
		</p:xslt>

	</p:declare-step>


	<p:declare-step name="store-to-temp" type="oecdstep:store-to-temp">

		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p><code>ccproc:store-temp</code> wraps <code>p:store</code> to save a document to a
				temporary file.</p>
		</p:documentation>

		<p:input port="source" primary="true">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>The input port contains the document to be stored to disk.</p>
			</p:documentation>
		</p:input>

		<p:output port="result" primary="true">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>The input document is copied to the primary output.</p>
			</p:documentation>
			<p:pipe port="source" step="store-to-temp"/>
		</p:output>

		<p:output port="href" primary="false">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>The URL to which the document was saved is returned as the value of a
						<code>c:result</code> element.</p>
			</p:documentation>
			<p:pipe port="result" step="temp-name"/>
		</p:output>

		<!-- get the name of temp file, ensuring we delete on script exit -->
		<ccproc:temp-file name="temp-name" delete-on-exit="true" fail-on-error="true"/>
		
		<!-- need to make the preceding primary -->
		<p:identity name="make-file-name-primary">
			<p:input port="source">
				<p:pipe port="result" step="temp-name"/>
			</p:input>
		</p:identity>

		<!-- specify UTF-8 here because we are writing a file which 
		will have no declaration. indent for ease of handling the validation messages -->
		<p:store omit-xml-declaration="true" encoding="utf-8" indent="true">
			<p:input port="source">
				<p:pipe port="source" step="store-to-temp"/>
			</p:input>
			<p:with-option name="href" select="/c:result/text()"/>
		</p:store>
	</p:declare-step>
	
	
</p:library>
