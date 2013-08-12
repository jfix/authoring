<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all">
	<xsl:output method="xhtml"/>


	<!-- PARAMETERS definition -->
	<!-- Should the CSS and the Javascript be distributed within the HTML file or not ? -->
	<xsl:param name="cssjsInDoc" select="true()"/>

	<!-- Enable to define if the HTML to be created is only for ont target or for all target. 
		 Note: the numbering remains the same if only one target is selected. -->
	<xsl:variable name="outputKindUpcast" select="'upcast'"/>
	<xsl:variable name="outputKindContentModelling" select="'contentModelAE'"/>
	<xsl:variable name="outputKindAll" select="'all'"/>
	<xsl:param name="outputKind" select="$outputKindContentModelling"/>

	<!-- Top template level -->
	<xsl:template match="TestDefinition">
		<html>
			<head>
				<title>Main Test Suite</title>
				<xsl:choose>
					<xsl:when test="$cssjsInDoc">
						<style type="text/css">
							<xsl:value-of select="unparsed-text('./checkList.css','UTF-8')"/>
						</style>
					</xsl:when>
					<xsl:otherwise>
						<link rel="stylesheet" type="text/css" href="checkList.css"/>
						<xsl:if test="$outputKind=$outputKindAll">
							<script type="text/javascript" src="./CheckList.js"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</head>
			<body>
				<xsl:if test="$outputKind=$outputKindAll">
					<xsl:if test="$cssjsInDoc">
						<script type="text/javascript">
						<xsl:comment>
							<xsl:value-of select="unparsed-text('./CheckList.js','UTF-8')"/>						
						</xsl:comment>
					</script>
					</xsl:if>
				</xsl:if>
				<h1 class="heading1">
					<a name="top"/>
					<xsl:text>Test Set</xsl:text>
					<xsl:if test="$outputKind!=$outputKindAll">
						<xsl:text>&#xa0;for&#xa0;</xsl:text>
						<xsl:text>OECD.Author</xsl:text>
						<!--<xsl:value-of select="$outputKind"/>-->
					</xsl:if>
				</h1>
				<xsl:if test="$outputKind=$outputKindAll">
					<form id="form1" method="post" action="">
						<p>
							<label>
								<input type="checkbox" name="SeeContentModel" id="SeeContentModel" checked="checked" onclick="javascript:toggle('{$outputKindContentModelling}');"/>
								<xsl:text> Content Modelling target</xsl:text>
							</label>
							<label>
								<input type="checkbox" name="SeeUpcast" id="SeeUpcast" checked="checked" onclick="javascript:toggle('{$outputKindUpcast}');"/>
								<xsl:text> Upcast target</xsl:text>
							</label>
							<label>
								<input name="SeeAll" type="checkbox" id="SeeAll" checked="checked" onclick="javascript:toggle('{$outputKindAll}');"/>
								<xsl:text> All targets</xsl:text>
							</label>
						</p>
					</form>
				</xsl:if>

				<h2 class="heading2">Table of Contents</h2>

				<div class="toc">
					<ul>
						<xsl:apply-templates mode="toc"/>
					</ul>

				</div>
				<xsl:if test=".//ToBeDone">
					<h2>To Be done</h2>
					<ul>
						<xsl:apply-templates select="//ToBeDone" mode="toc"/>
					</ul>
				</xsl:if>
				<h2 class="heading2">Details</h2>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>

	<!-- Mode TOC -->
	<xsl:template match="Section|UnitTests|IntegrationTests" mode="toc">
		<xsl:if test="not(@target) or @target=$outputKindAll or @target=$outputKind">
			<li style="padding-top:8pt;">
				<xsl:if test="@target">
					<xsl:attribute name="class">
						<xsl:value-of select="@target"/>
					</xsl:attribute>
				</xsl:if>
				<span class="toc{count(ancestor-or-self::Section|ancestor-or-self::UnitTests|ancestor-or-self::IntegrationTests)}">
					<a href="#link{generate-id()}">

						<xsl:number format="1. " level="multiple" count="Section|UnitTests|IntegrationTests|Test"/>

						<xsl:choose>
							<xsl:when test="local-name()='IntegrationTests'">
								<xsl:text>Integration Tests – </xsl:text>
							</xsl:when>
							<xsl:when test="local-name()='UnitTests'">
								<xsl:text>Unit Tests</xsl:text>
							</xsl:when>
						</xsl:choose>
						<xsl:value-of select="Purpose"/>
						<xsl:if test="@target!=''">
							<span class="warning">
								<xsl:value-of select="concat(' Used only for ',@target)"/>!</span>
						</xsl:if>
					</a>
					<!-- FRED: Ajout d'une référence pour la rediriger l'utilisateur vers la bonne section à partir du détail -->
					<a name="sectlink{generate-id()}"/>

					<xsl:text>&#160;&#160;</xsl:text>

					<span class="path">
						<xsl:value-of select="concat('folder: ', @folderName)"/>
					</span>

				</span>
				<xsl:apply-templates select="ToBeDone"/>
				<xsl:if test="Section|UnitTests|IntegrationTests|Test">
					<ul style="padding-top:3pt;">
						<xsl:apply-templates select="Section|Test" mode="toc"/>
					</ul>
				</xsl:if>
			</li>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Test" mode="toc">
		<xsl:if test="($outputKindAll=$outputKind and not(.//ValidationTarget/NotPertinent)) 
			or .//ValidationTarget[@target=$outputKindAll] 
			or (.//ValidationTarget[@target=$outputKind] and not(.//ValidationTarget/NotPertinent))">
			<li>
				<a href="#link{generate-id()}">
					<span>
						<xsl:number format="1. " level="multiple" count="Section|UnitTests|IntegrationTests|Test"/>
					</span>
				</a>
				<!-- FRED: Ajout d'une référence pour la rediriger l'utilisateur vers le bon test à partir du détail -->
				<a name="testlink{generate-id()}" title="Back to the table of contents"/>
				<span class="ts_Purpose">
					<xsl:text>&#160;&#160;</xsl:text>
					<xsl:value-of select="Purpose"/>
				</span>
				<xsl:text>&#160;&#160;</xsl:text>
				<span class="folder">

					<span class="path">
						<xsl:value-of select="concat('folder:', @folderName)"/>
					</span>
				</span>


				<xsl:if test="$outputKind=$outputKindAll">
					<xsl:text> (</xsl:text>
					<xsl:for-each select=".//ValidationTarget/ValidationActions">
						<span class="status {../Status}">
							<span class="{../@target}">
								<xsl:value-of select="concat(' -> ',parent::*/@target)"/>
							</span>
						</span>
					</xsl:for-each>
					<xsl:text>)</xsl:text>
				</xsl:if>
				<xsl:apply-templates select=".//ToBeDone"/>
			</li>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ToBeDone" mode="toc">
		<li>
			<a href="#tbd{generate-id()}">
				<xsl:apply-templates/>
			</a>
		</li>
	</xsl:template>

	<!-- Standard mode -->
	<xsl:template match="Section|UnitTests|IntegrationTests">
		<xsl:if test="not(@target) or @target=$outputKindAll or @target=$outputKind">
			<div>
				<xsl:attribute name="class">
					<xsl:value-of select="concat('section',count(ancestor-or-self::Section|ancestor-or-self::UnitTests|ancestor-or-self::IntegrationTests))"/>
					<xsl:if test="@target">
						<xsl:value-of select="concat(' ',@target)"/>
					</xsl:if>
				</xsl:attribute>
				<!--				<div class="td_Title">
-->
				<div>
					<!-- FRED: Ajout de l'attribut class pour créer un style pour chaque niveau de section -->
					<xsl:attribute name="class">
						<xsl:value-of select="concat('td_Title',count(ancestor-or-self::Section|ancestor-or-self::UnitTests|ancestor-or-self::IntegrationTests))"/>
					</xsl:attribute>
					<!-- FRED: Ajout de l'attribut style pour le décalage des niveaux de titre -->
					<xsl:attribute name="style">
						<xsl:value-of select="concat('padding-left:',count(ancestor-or-self::Section|ancestor-or-self::UnitTests|ancestor-or-self::IntegrationTests)-1,'em')"/>
					</xsl:attribute>
					<!-- FRED: Ajout du lien de redirection vers la section de la TOC, changement du title="Back to the table of contents" -->
					<a href="#sectlink{generate-id()}" title="Back to the table of contents"><img src="icons/arrow.gif" style="border:0" alt="Back to the table of contents"/></a>&#160; <a href="link{generate-id()}"/>
					<a name="link{generate-id()}"/>
					<xsl:number format="1. " level="multiple" count="Section|UnitTests|IntegrationTests|Test"/>
					<xsl:choose>
						<xsl:when test="local-name()='IntegrationTests'">Integration tests </xsl:when>
						<xsl:when test="local-name()='UnitTests'">Unit tests </xsl:when>
					</xsl:choose><xsl:value-of select="Purpose"/>
					<span class="purpose"> </span>
					<span class="path">
						<xsl:value-of select="concat('folder: ',@folderName)"/>
					</span>
				</div>
				<xsl:if test="@target!=''">
					<p class="warning">
						<xsl:value-of select="concat('Used only for ',@target)"/>
					</p>
				</xsl:if>
				<div class="td_Contents">
					<!-- FRED: Ajout de l'attribut style pour le décalage des niveaux de titre -->
					<xsl:attribute name="style">
						<xsl:value-of select="concat('padding-left:',count(ancestor-or-self::Section|ancestor-or-self::UnitTests|ancestor-or-self::IntegrationTests),'em')"/>
					</xsl:attribute>
					<xsl:value-of select="Objective/text()"/>
				</div>
				<xsl:apply-templates select="*[local-name()!='Objective']"/>
			</div>
		</xsl:if>
	</xsl:template>



	<xsl:template match="Test">
		<xsl:if test="($outputKindAll=$outputKind and not(.//ValidationTarget/NotPertinent)) 
			or .//ValidationTarget[@target=$outputKindAll] 
			or (.//ValidationTarget[@target=$outputKind] and not(.//ValidationTarget/NotPertinent))">

			<div class="test">
				<a name="link{generate-id()}"/>
				<p style="padding-left:1em">
					<!-- FRED: Ajout du lien de redirection vers le test de la TOC, changement du title="Back to the table of contents" -->
					<a href="#testlink{generate-id()}" title="Back to the table of contents">
						<img src="icons/arrow.gif" style="border:0" alt="Back to the table of contents"/>
					</a>
					<xsl:text>&#160;</xsl:text>

					<span class="purpose">
						<xsl:number format="1. " level="multiple" count="Section|UnitTests|IntegrationTests|Test"/>
						<xsl:value-of select="Purpose"/>
					</span>
				</p>
				<xsl:apply-templates select="ToBeDone"/>
				<div style="padding-left:3em; font-size:smaller;">
					<dl>
						<xsl:if test="Objective">
							<dt class="T1_Test">Objective:</dt>
							<dd class="STI_Test">
								<xsl:value-of select="Objective"/>
							</dd>
						</xsl:if>
						<xsl:if test="Comment">
							<dt class="T1_Test">Comment:</dt>
							<dd class="STI_Test">
								<xsl:value-of select="Comment"/>
							</dd>
						</xsl:if>
						<xsl:apply-templates select="ValidationTarget"/>
					</dl>
				</div>

			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ValidationTarget">
		<xsl:if test="($outputKindAll=$outputKind and not(NotPertinent))  or @target=$outputKindAll or (@target=$outputKind and not(.//ValidationTarget/NotPertinent))">

			<dt class="T1_Test">Resources:</dt>
			<dd>
				<xsl:if test="InputFiles">
					<xsl:variable name="folderInput">
						<xsl:choose>
							<xsl:when test="@target='upcast'">
								<xsl:text>Word</xsl:text>
							</xsl:when>
							<xsl:when test="@target='contentModelAE'">
								<xsl:text>odp</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>UNKNOWN_TARGET</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="pathParent">
						<xsl:for-each select="ancestor-or-self::*[@folderName]">
							<!--xsl:sort order="ascending"></xsl:sort-->
							<xsl:value-of select="concat(@folderName,'/')"/>
						</xsl:for-each>
						<xsl:value-of select="concat('Input/',$folderInput,'/')"/>
					</xsl:variable>
					<xsl:for-each select="InputFiles/File">
						<div class="path">
							<xsl:choose>
								<xsl:when test="not(@fileName) or @fileName=''">
									<font class="warning">
										<xsl:text>Missing test filename</xsl:text>
									</font>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="path" select="concat($pathParent,@fileName)"/>
									<a href="{$path}">
										<xsl:value-of select="$path"/>
									</a>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</xsl:for-each>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="NotPertinent"> (Not pertinent)</xsl:when>
					<xsl:when test="NotAvailable"> (Not available)</xsl:when>
				</xsl:choose>
			</dd>


			<xsl:if test="not(NotPertinent or NotAvailable)">

				<xsl:apply-templates/>

			</xsl:if>

			<xsl:choose>
				<xsl:when test="$outputKindAll=$outputKind or not(@target) or @target=$outputKindAll">

					<p>
						<span class="{Status}">
							<xsl:value-of select="concat('(',Status,') ') "/>
						</span>
						<em>
							<xsl:value-of select="concat('Validation for ',@target,': ')"/>
						</em>
					</p>


				</xsl:when>
				<xsl:otherwise>
					<dt class="{Status}">
						<xsl:value-of select="concat('Test is ',Status) "/>
					</dt>
				</xsl:otherwise>
			</xsl:choose>

		</xsl:if>
	</xsl:template>

	<xsl:template match="ValidationActions">
		<dt class="T1_Test">Verifications:</dt>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="P">
		<dd class="STI_Test" style="padding-bottom:3pt">
			<xsl:apply-templates/>
		</dd>
	</xsl:template>

	<xsl:template match="Results">
		<div class="T1_Test">Results</div>
		<dd class="STI_Test">
			<xsl:apply-templates/>
		</dd>

	</xsl:template>

	<xsl:template match="Result">
		<li class="TestResult">
			<xsl:variable name="passed">
				<xsl:choose>
					<xsl:when test="@passed='true' or @passed='1'">
						<xsl:text>:-)</xsl:text>
					</xsl:when>
					<xsl:otherwise>:-(</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:value-of select="concat($passed,' ',.)"/>
		</li>
	</xsl:template>

	<xsl:template match="ToBeDone">
		<div class="toBeDone warning">
			<a name="tbd{generate-id()}"/>
			<xsl:apply-templates/>
		</div>
	</xsl:template>


	<xsl:template match="Status|Purpose"><!-- yet managed --></xsl:template>
</xsl:stylesheet>
