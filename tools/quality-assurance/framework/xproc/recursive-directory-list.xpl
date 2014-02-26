	<p:declare-step type="ccproc:recursive-directory-list"  xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
		xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:ccproc="http://www.corbas.co.uk/ns/xproc/steps"
		xmlns:cx="http://xmlcalabash.com/ns/extensions">

		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<p>Recursively explore directory listings. The include and exclude filters are only
				applied to file names and not to directories. This seems more obvious than the
				standard approach. We've implemented this by handling the pattern matches in xslt
				rather than in the <code>p:directory-list</code> step. The patterns are not required
				to match the whole path name.</p>
		</p:documentation>


		<p:output port="result"> </p:output>
		<p:option name="path" required="true"/>
		<p:option name="include-filter"/>
		<p:option name="exclude-filter"/>
		<p:option name="depth" select="-1"/>
		
		<p:directory-list name="listing">
			<p:with-option name="path" select="$path"/>
		</p:directory-list>

		<p:choose name="apply-include-filter">
			<p:when test="p:value-available('include-filter')">
				<p:xslt version="2.0">
					<p:input port="stylesheet">
						<p:inline>
							<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								version="2.0">
								<xsl:param name="filter"/>
								<xsl:template
									match="c:directory|c:other|c:file[matches(@name, $filter)]|@*|text()">
									<xsl:copy>
										<xsl:apply-templates select="@*|node()"/>
									</xsl:copy>
								</xsl:template>
								<xsl:template match="c:file"/>
							</xsl:stylesheet>
						</p:inline>
					</p:input>
					<p:with-param name="filter" select="$include-filter"/>
				</p:xslt>
			</p:when>
			<p:otherwise>
				<p:identity/>
			</p:otherwise>
		</p:choose>

		<p:choose name="apply-exclude-filter">

			<p:when test="p:value-available('exclude-filter')">
				<p:xslt version="2.0">
					<p:input port="stylesheet">
						<p:inline>
							<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								version="2.0">
								<xsl:param name="filter"/>
								<xsl:template
									match="c:directory|c:other|c:file[not(matches(@name, $filter))]|@*|text()">
									<xsl:copy>
										<xsl:apply-templates select="@*|node()"/>
									</xsl:copy>
								</xsl:template>
								<xsl:template match="c:file"/>
							</xsl:stylesheet>
						</p:inline>
					</p:input>
					<p:with-param name="filter" select="$exclude-filter"/>
				</p:xslt>
			</p:when>

			<p:otherwise>
				<p:identity/>
			</p:otherwise>

		</p:choose>

		<p:viewport match="/c:directory/c:directory" name="recurse-directory">
			<p:variable name="name" select="/*/@name"/>

			<p:choose>
				<p:when test="$depth != 0">
					<p:choose>
						<p:when
							test="p:value-available('include-filter')
						and p:value-available('exclude-filter')">
							<ccproc:recursive-directory-list>
								<p:with-option name="path" select="concat($path,'/',$name)"/>
								<p:with-option name="include-filter" select="$include-filter"/>
								<p:with-option name="exclude-filter" select="$exclude-filter"/>
								<p:with-option name="depth" select="$depth - 1"/>
							</ccproc:recursive-directory-list>
						</p:when>

						<p:when test="p:value-available('include-filter')">
							<ccproc:recursive-directory-list>
								<p:with-option name="path" select="concat($path,'/',$name)"/>
								<p:with-option name="include-filter" select="$include-filter"/>
								<p:with-option name="depth" select="$depth - 1"/>
							</ccproc:recursive-directory-list>
						</p:when>

						<p:when test="p:value-available('exclude-filter')">
							<ccproc:recursive-directory-list>
								<p:with-option name="path" select="concat($path,'/',$name)"/>
								<p:with-option name="exclude-filter" select="$exclude-filter"/>
								<p:with-option name="depth" select="$depth - 1"/>
							</ccproc:recursive-directory-list>
						</p:when>

						<p:otherwise>
							<ccproc:recursive-directory-list>
								<p:with-option name="path" select="concat($path,'/',$name)"/>
								<p:with-option name="depth" select="$depth - 1"/>
							</ccproc:recursive-directory-list>
						</p:otherwise>
					</p:choose>
				</p:when>
				<p:otherwise>
					<p:identity/>
				</p:otherwise>
			</p:choose>

		</p:viewport>

	</p:declare-step>
