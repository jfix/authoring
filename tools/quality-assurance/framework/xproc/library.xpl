<?xml version="1.0" encoding="UTF-8"?>
<p:library xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:oecdstep="urn:oecd:names:xmlns:xproc:steps"
	xmlns:manifest="urn:oecd:names:xmlns:transform:manifest"
	xmlns:cx="http://xmlcalabash.com/ns/extensions"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
	
	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	
	<p:documentation xmlns="http://www.w3.org/1999/xhtml">
		<p>Library of useful steps for loading up and processing QXA docs.</p>
	</p:documentation>
	
	
	
	<p:declare-step name="report-uri" type="oecdstep:report-uri">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>Given the <code>item</code> element for a document in the input sequence, 
			create the URI for the output document from the output path and the input name.</p>
		</p:documentation>
		
		<p:input port="source" primary="true">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>The <code>item</code> element for a document in the input sequence.</p>
			</p:documentation>
		</p:input>
		
		<p:output port="result" primary="true">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>A c:result containing the output URI on the href attribute.</p>
			</p:documentation>
		</p:output>
		
			
		<p:option name="output-root" required="true">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>The base URI for output files.</p>
			</p:documentation>
		</p:option>
		
		<p:option name="attrib" select="'href'">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>Name of the attribute to base the file name on.</p>
			</p:documentation>
		</p:option>
		
		<p:option name="suffix" select="'.report.html'"/>
		
		<p:xslt>
			<p:input port="stylesheet">
				<p:inline>
					<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
						<xsl:param name="output-root"/>
						<xsl:param name="suffix"/>
						<xsl:param name="attrib"/>
						<xsl:variable name="rel" select="/manifest:item/@*[local-name() eq $attrib]"/>
						<xsl:variable name="cleaned" select="string-join(
							for $part in tokenize($rel, '/') return replace($part, '[^\w]', '_'),
							'/')"></xsl:variable>
						<xsl:template match="manifest:item">
							<c:result href="{resolve-uri(concat($cleaned, $suffix), if (ends-with($output-root, '/')) then $output-root else concat($output-root, '/'))}"/>
						</xsl:template>
					</xsl:stylesheet>
				</p:inline>
			</p:input>
			<p:with-param name="output-root" select="$output-root"/>
			<p:with-param name="suffix" select="$suffix"/>
			<p:with-param name="attrib" select="$attrib"/>
		</p:xslt>
		
		
	</p:declare-step>
	
	
	
	
	<p:declare-step name="find-doc-type" type="oecdstep:find-doc-type">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>Given a document return a c:result element that contains the
			document type. Note that the case is not predictable so further
			tests using this type must be done case insensitively.</p>
		</p:documentation>
		
		<p:input port="source" primary="true">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>The input document</p>
			</p:documentation>
		</p:input>
		
		<p:output port="result" primary="true">
			<p:pipe port="result" step="doc-type-xslt"/>
		</p:output>
		
		<p:xslt version="2.0" name="doc-type-xslt">
			<p:input port="source">
				<p:pipe port="source" step="find-doc-type"/>
			</p:input>
			
			<p:input port="parameters">
				<p:empty/>
			</p:input>
			
			<p:input port="stylesheet">
				<p:document href="../xsl/oecd-document-type.xsl"/>
			</p:input>
		</p:xslt>
		
		
	</p:declare-step>
	
	<p:declare-step type="oecdstep:load-schema-manifest-item" name="load-schema-manifest-item">
		
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>Given the schema configuration file and a document type, load the appropriate
			schema information from it and return</p>
		</p:documentation>
		
		<p:input port="manifest">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>Should contain the schema configuration file.</p>
			</p:documentation>
		</p:input>
		
		<p:output port="result" primary="true">
			<p:documentation xmlns="http://www.w3.org/1999/xhtml">
				<p>A schema config matching the current document type.</p>
			</p:documentation>			
			<p:pipe port="result" step="get-doctype-data"/>
		</p:output>
		
		
		<p:option name="doctype" required="true"/>
		
		<p:xslt name="get-doctype-data">
			<p:input port="stylesheet">
				<p:inline>
					<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
						
						<xsl:param name="doctype"/>
						
						<xsl:template match="/|*">
							<xsl:apply-templates/>
						</xsl:template>
						
						<xsl:template match="manifest:item[lower-case(@type) = lower-case($doctype)]">
							<xsl:copy-of select="."/>
						</xsl:template>
						
					</xsl:stylesheet>
				</p:inline>
			</p:input>
			<p:with-param name="doctype" select="$doctype"/>
		</p:xslt>
		
		
	</p:declare-step>
	
	
</p:library>