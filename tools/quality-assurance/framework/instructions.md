# Running the quality tools

## Single document

1. Open the project 'quality.xpr'
2. Open the XML file to be tested.
3. Click on the "Congfigure Transformation Scenario(s)" button. Select the appropriate "OECD Author Validation…" scenario. Click on "Apply Scenario" and the scenario will run and then the results will be displayed in an HTML page.
4. If a DOCX version of the file is available, open this as well. Click on the "Configure Transformation Scenario(s)" button and select "OECD Author DOCX Verfification". Click on "Apply Scenario" and the scenario will run and then the results will be displayed in an HTML page.

## Multiple documents

1. Create a  manifest file as described below
2. The paths to each file in the manifest must be relative to the manifest file itslf.
4. Run the "process-manifest.bat" (or "process-manifest.sh") script. The manifest should be the first argument to this script and the path to which output should be written should be the second

    `process-manifest.bat manifest.xml results/`

 5. Open 'index.html' in the output directory to see the results.


The XML manifest file  should look like:

    <manifest xmlns="urn:oecd:names:xmlns:transform:manifest">
        <item href="submit/DSTI-SU-SC-A(2013)2-REV1-ENG-demoFIXDATE.xml"
            submitted-href="submit/OdsRequest_wilkie_n.qxa"
            docx-href="submit/OdsRequest_wilkie_n.docx"/>		
     </manifest>

There should be as many `item` elements as required. Each `item` must have an `href` attribute referencing the QXA file. Additionally, it may have a `docx-href` attribute referencing the docx version of the file and a `submitted-href` attribute referencing the final submitted QXA file. 

#  Managing the Schema Files #

## OECD W3C Schemas ##

The Quark schemas (XAS files) must be flattened using `xmllint` , copied to the  repository and stored in the `configs` directory. The `schema-manifest.xml` file must be updated if any file name changes are made or new types added.

The OECD schemas (XSD files) must be flattened using the the Oxygen flattening tool and copied to the `schemas` directory. The `schema-manifest.xml` file must be updated if any file name changes are made or new types added.

Note, that the external schemas referenced via `xs:import`  are already copied to the framework's `schemas` directory. This requirement is resolved in Oxygen 15.2 but not in earlier versions.

There is a script `flatten-schemas.bat` in th `bin` directory which flattens both sets of schema files.

The structure of the manifest file is as follows:

    <manifest xmlns="urn:oecd:names:xmlns:transform:manifest">
    <item type="Official Document" 
        quark-schema="official-document.xas" 
        schema="../schemas/oecd.author.xsd" 
        schematron="../schematron/document.sch" 
        elements="document-schema-elements.xml"/>
    </manifest>


The `type` attribute matches the content type metadata in the document file itself and is used to select the schema item to be used when processing a document. The other attributes represent relative paths to files (relative to the manifest file)

* The `quark-schema` attribute references the flattened XAS file. 
* The `schema` attribute references the OECD W3C schema for the type.
*  The `schematron` attribute references the schematron file for the type (please use __basic.sch__ if no appropriate schematron exists).
*  The `elements` attribute is used by the coverage tests and can be ignored at this time.



The `bin` directory contains a script which can be used to generate the flattened schema files. 




