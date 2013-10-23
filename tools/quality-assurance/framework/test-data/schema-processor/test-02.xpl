<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:l="http://xproc.org/library"
	xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0" name="test">

	<p:input port="source" primary="true">
		<p:inline>
			<root id="foo" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xsi:noNamespaceSchemaLocation="test1.xsd">
				<child1>Child 1 - instance 1</child1>
				<child1>Child 1 - instance 2</child1>
				<child3>Child 3 - instance 1</child3>
				<child1>Child 1 - invalid instance</child1>
			</root>
		</p:inline>
	</p:input>
	
	<p:output port="result" primary="true">
		<p:pipe port="result" step="show-uri"/>
	</p:output>

	<p:add-attribute attribute-name="foo" match="//*" attribute-value="bar" name="adder">
		<p:input port="source">
			<p:pipe port="source" step="test"></p:pipe>
		</p:input>
	</p:add-attribute>
	
	<p:xslt name="show-uri">
		
		<p:input port="source">
			<p:pipe port="result" step="adder"></p:pipe>
		</p:input>
		
		<p:input port="parameters">
			<p:empty/>
		</p:input>
		<p:input port="stylesheet">
			<p:inline>
				<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
					<xsl:variable name='uri' select="document-uri(.)"/>
					<xsl:template match="/">
						<uri><xsl:value-of select="$uri"/></uri>
					</xsl:template>
				</xsl:stylesheet>
			</p:inline>
		</p:input>
		
	</p:xslt>
	

	
	
</p:declare-step>