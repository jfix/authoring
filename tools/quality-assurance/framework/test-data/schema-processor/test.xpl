<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:l="http://xproc.org/library"
	xmlns:oecd="http://www.oecd.org/ns/oecd"
	xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"	
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0" name="test">
	
    <p:input port="source">
    	<p:document href="test-02.xml"/>
    </p:input>
	
	<p:input port="schema">
		<p:document href="test1.xsd"/>
	</p:input>
	
	<p:input port="parameters" kind="parameter" primary="true"/>
	
	<p:output port="result">
		<p:pipe port="result" step="validate"/>
	</p:output>

	
	<p:import href="../../xproc/xsd-validation-with-xpath.xpl"/>

	<oecd:xsd-validation name="validate">
		<p:input port="source">
			<p:pipe port="source" step="test"/>
		</p:input>
		<p:input port="schema">
			<p:pipe port="schema" step="test"/>
		</p:input>
	</oecd:xsd-validation>
	
	
	
    
</p:declare-step>