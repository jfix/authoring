<?xml version="1.0" encoding="UTF-8"?>
<pattern id="document-content-pattern" xmlns="http://purl.oclc.org/dsdl/schematron">
	<title>Submission Content Tests</title>
	<p>This pattern tests for properties of content that are only true in submitted content.</p>
	
	
	<!-- This rule is evaluated for documents that have been submitted -->
	<rule context="doc:document-metadata[.//doc:metadata-item[@property='oecd:SRPJobNumber']]">
		
		<!-- Instructional text -->
		<report test="descendant::para[@class='instruct']">All instructional text must be stripped from the document before submission.</report>
		
	</rule>
	
	
</pattern>