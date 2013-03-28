<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="2.0">

  <xsl:param name="output-folder"/>

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"
      xmlns:url="http://www.oecd.org/ns/schema" url:base="{$output-folder}">
      <head>
        <link href="resources/stylesheets/style.css" media="screen" rel="stylesheet" type="text/css"/>
        <title>Data Standards - Supporting Documentation</title>
      </head>
      <body>
        <div id="header">
          <h1>Data Standards - Supporting Documentation</h1>
        </div>
        <div id="content">
          <div id="left">
            <p>These pages contain documentation for the following:</p>
            <div id="global"/>
            <p>Please click on the links above.</p>
          </div>
          <div id="right"> </div>
        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
