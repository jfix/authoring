<?xml version="1.0" encoding="UTF-8"?>
	
<pattern id="document-meta-pattern" xmlns="http://purl.oclc.org/dsdl/schematron" >
		<title>Metadata Tests</title>
		<p>This pattern tests the required metadata structures for OECD.Author Documents</p>
		
		<rule context="doc:document-metadata" id="document-metadata">
			<!-- oecd:originalClassif -->
			<assert test=".//doc:metadata-item[@property='oecd:originalClassif']">All documents must have an original classification</assert>
			<assert test="string-length(normalize-space(.//doc:metadata-item[@property ='oecd:originalClassif']/@value)) gt 1">The original classification of a document must not be empty or only whitespace.</assert>

			<!-- oecd:language -->
			<assert test=".//doc:metadata-item[@property='oecd:language']">All documents must have a language defined</assert>
			<assert test="lower-case(normalize-space(.//doc:metadata-item[@property='oecd:language']/@value)) = ('en', 'fr')">The language of a document must be either 'en' or 'fr'.</assert>

			<!-- oecd:cote -->
			<assert test=".//doc:metadata-item[@property='oecd:cote']">All documents must have the cote metadata item, even if it is blank</assert>
		</rule>
	
	</pattern>
