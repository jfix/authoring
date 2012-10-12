<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    <!-- 
  Project: OECD.Author
  Version: 0.09
  Date: 2012/10/12 11:50
  Programmer: J. Cowther
  Language: W3C Schema
  Date started: 2012/03/19 13:20
  Currently supported in: n/a 
  Notes:
  NG20120319 Added initial version.
  JC20121012 Transposed NG's initial comments to <p/> and added rules for titles and table footers (with a view to doing the XSD work required)
    -->
    
    <title>OECD.Author Initial Schematron</title>

    <p>This schematron keeps track of schematron requirements for the OECD.Author base schema. They may be integrated into the schema as annotations.</p>

    <p>rule to check the consistency of numbered lists</p>
    <p>rule to check that no element has both a metadataReference attribute and a metadata element</p>
    <p>rule to check that note reference attributes only occur on descendants of elements which may have notes</p>
    <p>rule to check a title is never empty</p>
    <p>rule to check a table footer is never empty</p>

</schema>
