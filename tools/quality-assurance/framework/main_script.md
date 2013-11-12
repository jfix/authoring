# Document Quality Master Script

## Inputs

For each test, the only initial input is an official document, agenda or publication that has been saved to SharePoint.

The following inputs are required for all tests:

* The OECDAuthor schema files (see below for location)
* oXygen XML editor
* The test scripts and project stored in subversion at https://pacps01.oecd.org/svn/authoring/trunk/tools/quality-assurance/framework

### Schema locations

The scripts are written with the assumption that the tools and models directories from the subversion repository have been checked out together so that `tools` and `models` are sibling directories. If this is not the case, it will be necessary to edit the transformation scenarios.

## Processing

The input document for each test must be saved to a DOCX file. If available, it must also be rendered to PDF. 

## Validation

The first stage of quality checking involves processing the QXA XML file to ensure that the content is valid against the XML schema and any defined schematron rules. This requires the use of the `quality.xpr` project from the subversion repository above. Opening this project in oXygen whilst the project is open will give access to the "OECDAuthor XML Validation" scenarios.

When the document is first loaded, clicking on the "Apply Transformation Scenario(s)" button will allow the user to select the appropriate scenario. There is one for each of Agenda, Official Document and Publication. 



Having select the scenario


