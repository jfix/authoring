<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:manifest="urn:oecd:names:xmlns:transform:manifest"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
	xmlns:oecdstep="urn:oecd:names:xmlns:xproc:steps"
	xmlns:cx="http://xmlcalabash.com/ns/extensions" xmlns:c="http://www.w3.org/ns/xproc-step"
	version="1.0" name="pipeline">

	<p:documentation xmlns="http://www.w3.org/1999/xhtml">
		<p>Process a test manifest listing xml files and (potentially) docx files for
			validation.</p>
		<p>The manifest consists of an element (<code>manifest</code>in the
				<code>urn:oecd:names:xmlns:transform:manifest</code> namespace. This must contain
			one or more <code>item</code> elements. The <code>item</code> elements contain one or
			two attributes: <code>href</code> which contains a path to a XML file for testing and
			(potentially) <code>docx-href</code> which contains the path to the DOCX version of the
			same file.</p>
		<p>Each item is passed through the validation toolkit and an output file written to the
			directory name in the <code>output-path</code> option. An index file is written to
			facilitate use of the results.</p>
		<p>After all of the input files have been processed, they are reprocessed to generate a
			schema coverage report.</p>
	</p:documentation>


	<p:input port="manifest">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>The <code>manifest</code> port should contain the list of files to be processed.</p>
		</p:documentation>
	</p:input>

	<p:input port="config">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>The <code>config</code> port references the document type to schema data
				information.</p>
		</p:documentation>
	</p:input>

	<p:input port="parameters" kind="parameter" primary="true"/>

	<p:option name="output-base-uri" required="true"/>

	<p:import href="library.xpl"/>

	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	<p:import href="process-document.xpl"/>
	<p:import href="compare-xml-docx.xpl"/>

	<p:variable name="input-base-uri" select="base-uri(/)">
		<p:pipe port="manifest" step="pipeline"/>
	</p:variable>

	<!-- load the manifest and process one file at a time. -->
	<p:for-each name="loop-items">

		<!--<p:output port="result"/>-->

		<p:iteration-source select="//manifest:item">
			<p:pipe port="manifest" step="pipeline"/>
		</p:iteration-source>

		<p:variable name="document-uri" select="resolve-uri(//manifest:item/@href, $input-base-uri)"/>

		<cx:message>
			<p:with-option name="message" select="concat('Processing… ', $document-uri)"/>
		</cx:message>

		<!-- get the report URI -->
		<oecdstep:report-uri name="report-uri">
			<p:input port="source">
				<p:pipe port="current" step="loop-items"/>
			</p:input>
			<p:with-option name="output-root" select="$output-base-uri"/>
		</oecdstep:report-uri>

		<!-- load the document -->
		<p:load name="load-test-document">
			<p:with-option name="href" select="$document-uri"/>
		</p:load>


		<!-- get the document type -->
		<oecdstep:find-doc-type name="find-doc-type">
			<p:input port="source">
				<p:pipe port="result" step="load-test-document"/>
			</p:input>
		</oecdstep:find-doc-type>

		<!-- extract the appropriate element from the schema manifest -->
		<oecdstep:load-schema-manifest-item name="load-schema-manifest-item">
			<p:input port="manifest">
				<p:pipe port="config" step="pipeline"/>
			</p:input>
			<p:with-option name="doctype" select="/c:result">
				<p:pipe port="result" step="find-doc-type"/>
			</p:with-option>

		</oecdstep:load-schema-manifest-item>

		<!-- and finally load the schema -->
		<p:load name="load-schema">
			<p:with-option name="href" select="resolve-uri(/manifest:item/@schema, base-uri(/))">
				<p:pipe port="result" step="load-schema-manifest-item"/>
			</p:with-option>
		</p:load>

		<!-- and the schematron -->
		<p:load name="load-schematron">
			<p:with-option name="href" select="resolve-uri(/manifest:item/@schematron, base-uri(/))">
				<p:pipe port="result" step="load-schema-manifest-item"/>
			</p:with-option>
		</p:load>

		<!-- NOW, we can process the document -->
		<oecdstep:process-document name="process-document">
			<p:input port="source">
				<p:pipe port="result" step="load-test-document"/>
			</p:input>
			<p:input port="schema">
				<p:pipe port="result" step="load-schema"/>
			</p:input>
			<p:input port="schematron">
				<p:pipe port="result" step="load-schematron"/>
			</p:input>
		</oecdstep:process-document>


		<p:store>
			<p:input port="source">
				<p:pipe port="result" step="process-document"/>
			</p:input>
			<p:with-option name="href" select="//c:result/@href">
				<p:pipe port="result" step="report-uri"/>
			</p:with-option>
		</p:store>

		<p:choose>

			<p:xpath-context>
				<p:pipe port="current" step="loop-items"/>
			</p:xpath-context>

			<p:when test="/manifest:item/@docx-href">

				<!-- get the qxa schema -->
				<p:load name="load-quark-schema">
					<p:with-option name="href"
						select="resolve-uri(/manifest:item/@quark-schema, base-uri(/))">
						<p:pipe port="result" step="load-schema-manifest-item"/>
					</p:with-option>
				</p:load>

				<!-- get the report URI -->
				<oecdstep:docx-report-uri name="docx-report-uri">
					<p:input port="source">
						<p:pipe port="current" step="loop-items"/>
					</p:input>
					<p:with-option name="output-root" select="$output-base-uri"/>
				</oecdstep:docx-report-uri>

				<!-- do comparison -->
				<oecdstep:compare-xml-docx name="docx-comparison">
					<p:input port="config">
						<p:pipe step="load-quark-schema" port="result"/>
					</p:input>
					<p:input port="xml-document">
						<p:pipe port="result" step="load-test-document"/>
					</p:input>
					<p:with-option name="word-document" select="/manifest:item/@docx-href">
						<p:pipe port="current" step="loop-items"/>
					</p:with-option>
				</oecdstep:compare-xml-docx>

				<!-- write report -->
				<p:store name="store-docx-report">
					<p:input port="source">
						<p:pipe port="result" step="docx-comparison"/>
					</p:input>
					<p:with-option name="href" select="//c:result/@href">
						<p:pipe port="result" step="docx-report-uri"/>
					</p:with-option>
				</p:store>


				<!-- use an identity to ensure the same result whichever path is taken -->
				<p:identity name="docx-identity">
					<p:input port="source">
						<p:pipe port="result" step="load-test-document"/>
					</p:input>
				</p:identity>

			</p:when>

			<p:otherwise>

				<!-- use an identity to ensure the same result whichever path is taken -->
				<p:identity name="docx-default-identity">
					<p:input port="source">
						<p:pipe port="result" step="load-test-document"/>
					</p:input>
				</p:identity>

			</p:otherwise>
		</p:choose>

		<!-- the result is not required -->
		<p:sink/>

		<!--		<!-\- use an identity to output the test document at the end so we can gather them for
			coverage processing -\->
		<p:identity name="loop-result">
			<p:input port="source">
				<p:pipe port="result" step="load-test-document"/>
			</p:input>
		</p:identity>-->

	</p:for-each>

	<!-- now process the manifest with xslt to generate the index page -->
	<p:xslt name="create-index">
		<p:input port="source">
			<p:pipe port="manifest" step="pipeline"/>
		</p:input>
		<p:input port="stylesheet">
			<p:document href="../xsl/create-report-index.xsl"/>
		</p:input>
		<p:with-param name="output-root" select="$output-base-uri"/>
	</p:xslt>
	
	<p:store>
		<p:with-option name="href" select="resolve-uri('index.html', concat($output-base-uri, '/'))"/>
	</p:store>
	


</p:declare-step>
