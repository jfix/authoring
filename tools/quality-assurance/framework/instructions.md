# Running the quality tools

## Single document

1. Open the project 'quality.xpr'
2. Open the XML file to be tested.
3. Click on the "Congfigure Transformation Scenario(s)" button. Select the appropriate "OECD Author Validation…" scenario. Click on "Apply Scenario" and the scenario will run and then the results will be displayed in an HTML page.
4. If a DOCX version of the file is available, open this as well. Click on the "Configure Transformation Scenario(s)" button and select "OECD Author DOCX Verfification". Click on "Apply Scenario" and the scenario will run and then the results will be displayed in an HTML page.

## Multiple documents

1. Create a  manifest file by saving the template in "template/manifest.xml" under a new name.
2. The paths to each file in the manifest must be relative to the manifest file iteslf.
3. Where a DOCX version of the file is available add a __docx-href__ attribute to the item.
4. Run the "process-docs.bat" (or "process-docs.sh") script. The manifest should be the first argument to this script and the path to which output should be written should be the second

    process-docs.bat manifest.xml results

 5. Open 'index.html' in the output directory to see the results.

