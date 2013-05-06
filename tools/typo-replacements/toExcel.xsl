<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:e="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:x="urn:schemas-microsoft-com:office:excel"
    xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:html="http://www.w3.org/TR/REC-html40" exclude-result-prefixes="xs" version="2.0">
    <xsl:output indent="no"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="contextColor" select="'#50A524'"/>
    <xsl:variable name="spaceColor" select="'#F18E00'"/>
    <xsl:variable name="patternColor" select="'#00A6EA'"/>
    <xsl:template match="/">
        <xsl:processing-instruction name="mso-application">progid="Excel.Sheet"</xsl:processing-instruction>
        <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet">
            <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
                <Author>wilkie_n</Author>
                <LastAuthor>Pierre Attar</LastAuthor>
                <Created>2012-11-14T10:33:26Z</Created>
                <LastSaved>2013-02-08T16:28:53Z</LastSaved>
                <Company>OECD</Company>
                <Version>14.00</Version>
            </DocumentProperties>
            <CustomDocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
                <ContentTypeId dt:dt="string"
                    >0x010100F14E3E4DB085C346BAFC0D2C3A9ACFCF</ContentTypeId>
            </CustomDocumentProperties>
            <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
                <AllowPNG/>
            </OfficeDocumentSettings>
            <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
                <WindowHeight>11760</WindowHeight>
                <WindowWidth>20730</WindowWidth>
                <WindowTopX>360</WindowTopX>
                <WindowTopY>360</WindowTopY>
                <ActiveSheet>4</ActiveSheet>
                <ProtectStructure>False</ProtectStructure>
                <ProtectWindows>False</ProtectWindows>
            </ExcelWorkbook>
            <Styles>
                <Style ss:ID="Default" ss:Name="Normal">
                    <Alignment ss:Vertical="Bottom"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>
                    <Interior/>
                    <NumberFormat/>
                    <Protection/>
                </Style>
                <Style ss:ID="s16">
                    <Alignment ss:Vertical="Top" ss:WrapText="1"/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>
                </Style>
                <Style ss:ID="s17">
                    <Alignment ss:Vertical="Top" ss:WrapText="1"/>
                </Style>
                <Style ss:ID="s18">
                    <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>
                </Style>
                <Style ss:ID="s19">
                    <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
                </Style>
                <Style ss:ID="s20">
                    <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
                </Style>
                <Style ss:ID="s21">
                    <Alignment ss:Vertical="Top" ss:WrapText="1"/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>
                </Style>
                <Style ss:ID="s22">
                    <Alignment ss:Vertical="Top" ss:WrapText="1"/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
                </Style>
                <Style ss:ID="s23">
                    <Alignment ss:Vertical="Top"/>
                </Style>
                <Style ss:ID="s24">
                    <Alignment ss:Vertical="Top"/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>
                </Style>
                <Style ss:ID="s25">
                    <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>
                </Style>
                <Style ss:ID="s26">
                    <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>
                </Style>
                <Style ss:ID="s27">
                    <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>
                </Style>
                <Style ss:ID="s28">
                    <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
                </Style>
                <Style ss:ID="s29">
                    <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
                    <Interior/>
                </Style>
                <Style ss:ID="s30">
                    <Alignment ss:Vertical="Top" ss:WrapText="1"/>
                    <Interior/>
                </Style>
                <Style ss:ID="Section">
                    <Alignment ss:Vertical="Center" ss:WrapText="1"/>
                    <Borders/>
                </Style>
                <Style ss:ID="s33">
                    <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>
                    <Borders/>
                </Style>
                <Style ss:ID="s34">
                    <Alignment ss:Vertical="Center" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>
                </Style>
                <Style ss:ID="s35">
                    <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                    <Interior/>
                </Style>
                <Style ss:ID="s36">
                    <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                </Style>
                <Style ss:ID="s37">
                    <Alignment ss:Vertical="Center"/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>
                </Style>
                <Style ss:ID="s38">
                    <Alignment ss:Vertical="Center" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#1A1A1E"/>
                </Style>
                <Style ss:ID="s39">
                    <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Times New Roman" x:Family="Roman" ss:Color="{$patternColor}"/>
                    <NumberFormat ss:Format="@"/>
                </Style>
                <Style ss:ID="s40">
                    <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Times New Roman" x:Family="Roman" ss:Color="{$patternColor}"
                    />
                </Style>
                <Style ss:ID="s41">
                    <Alignment ss:Vertical="Bottom"/>
                    <Borders/>
                </Style>
                <Style ss:ID="s42">
                    <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="17.5" ss:Color="#F18E00"/>
                </Style>
                <Style ss:ID="s43">
                    <Alignment ss:Vertical="Center"/>
                    <Borders/>
                    <Interior/>
                </Style>
                <Style ss:ID="s44">
                    <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#B81014"/>
                    <NumberFormat ss:Format="@"/>
                </Style>
                <Style ss:ID="s45">
                    <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#1A1A1E"/>
                    <NumberFormat ss:Format="@"/>
                </Style>
                <Style ss:ID="s46">
                    <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="17.5" ss:Color="#F18E00"/>
                    <NumberFormat ss:Format="@"/>
                </Style>
                <Style ss:ID="s47">
                    <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#1A1A1E"/>
                </Style>
                <Style ss:ID="s48">
                    <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#B81014"/>
                </Style>
                <Style ss:ID="s49">
                    <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Times New Roman" x:Family="Roman" ss:Size="11.5"
                        ss:Color="{$patternColor}"/>
                </Style>
                <Style ss:ID="s50">
                    <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#50A524"/>
                </Style>
                <Style ss:ID="s51">
                    <Alignment ss:Vertical="Center"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>
                </Style>
                <Style ss:ID="s52">
                    <Alignment ss:Vertical="Bottom"/>
                    <Borders/>
                    <NumberFormat ss:Format="@"/>
                </Style>
                <Style ss:ID="s53">
                    <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>
                </Style>
                <Style ss:ID="s54">
                    <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                    <Interior/>
                </Style>
                <Style ss:ID="s55">
                    <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>
                    <Borders/>
                </Style>
                <Style ss:ID="s56">
                    <Alignment ss:Vertical="Center"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#1A1A1E"/>
                </Style>
                <Style ss:ID="s57">
                    <Alignment ss:Vertical="Top" ss:WrapText="1"/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
                </Style>
                <Style ss:ID="s58">
                    <Alignment ss:Vertical="Top"/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#FF0000"/>
                </Style>
                <Style ss:ID="typeLevel">
                    <Alignment ss:Vertical="Center" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#974706" ss:Bold="1"/>
                </Style>
                <Style ss:ID="groupLevel">
                    <Alignment ss:Vertical="Center" ss:WrapText="1"/>
                    <Borders/>
                    <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="12" ss:Color="#974706"
                        ss:Bold="1"/>
                </Style>
            </Styles>
            <xsl:apply-templates>
                <xsl:with-param name="lang" select="'en'" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates>
                <xsl:with-param name="lang" select="'fr'" tunnel="yes"/>
            </xsl:apply-templates>
            <xsl:apply-templates>
                <xsl:with-param name="lang" select="'all'" tunnel="yes"/>
            </xsl:apply-templates>
        </Workbook>

    </xsl:template>
    <xsl:template match="typo">
        <xsl:param name="lang" tunnel="yes"/>
        <!-- first level -->
        <Worksheet xmlns="urn:schemas-microsoft-com:office:spreadsheet">
            <xsl:attribute name="ss:Name">
                <xsl:value-of select="$lang"/>
            </xsl:attribute>

            <Table ss:ExpandedColumnCount="9" ss:ExpandedRowCount="3000" x:FullColumns="1"
                x:FullRows="1">
                <xsl:if test="$lang='all'">
                    <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="40.25"/>
                </xsl:if>
                <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="200.25"/>
                <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="200.25"/>
                <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="200.25"/>
                <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="200.25"/>
                <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="200.25"/>
                <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="200.25"/>
                <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="200.25"/>
                <Row ss:StyleID="s37" xmlns="urn:schemas-microsoft-com:office:spreadsheet">
                    <xsl:if test="$lang='all'">
                        <Cell>
                            <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40"
                                >Lang.</ss:Data>
                        </Cell>
                    </xsl:if>
                    <Cell>
                        <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40"
                            >Search</ss:Data>
                    </Cell>
                    <Cell>
                        <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40"
                            >Replace</ss:Data>
                    </Cell>
                    <Cell>
                        <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40"
                            >Context</ss:Data>
                    </Cell>
                    <Cell>
                        <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40"
                            >Comment</ss:Data>
                    </Cell>
                </Row>
                <xsl:apply-templates/>
            </Table>
            <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
                <PageSetup>
                    <Layout x:Orientation="Landscape"/>
                    <Header x:Margin="0.3"/>
                    <Footer x:Margin="0.3"/>
                    <PageMargins x:Bottom="0.75" x:Left="0.25" x:Right="0.25" x:Top="0.75"/>
                </PageSetup>
                <Print>
                    <ValidPrinterInfo/>
                    <PaperSizeIndex>9</PaperSizeIndex>
                    <HorizontalResolution>600</HorizontalResolution>
                    <VerticalResolution>600</VerticalResolution>
                </Print>
                <ProtectObjects>False</ProtectObjects>
                <ProtectScenarios>False</ProtectScenarios>
            </WorksheetOptions>
        </Worksheet>
    </xsl:template>

    <xsl:template match="section">
        <xsl:param name="lang" tunnel="yes"/>

        <Row ss:StyleID="{if(ancestor::section) then 'typeLevel' else 'groupLevel'}"
            xmlns="urn:schemas-microsoft-com:office:spreadsheet">
            <xsl:if test="$lang='all'">
                <Cell>
                    <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40"
                        >&#xa0;</ss:Data>
                </Cell>
            </xsl:if>
            <Cell  ss:MergeAcross="3">
                <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40">
                    <xsl:apply-templates select="title"/>
                </ss:Data>
            </Cell>
        </Row>
        <xsl:apply-templates select="*[local-name()!='title']"/>
    </xsl:template>

    <xsl:template match="replacement">
        <xsl:param name="lang" tunnel="yes"/>
        <xsl:if test="contains(@targetLanguage,$lang) or $lang='all'">
            <Row ss:StyleID="s36" xmlns="urn:schemas-microsoft-com:office:spreadsheet">
                <xsl:if test="$lang='all'">
                    <Cell>
                        <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40">
                            <xsl:value-of select="@targetLanguage"/>
                        </ss:Data>
                    </Cell>
                </xsl:if>
                <Cell>
                    <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40">
                        <xsl:apply-templates select=".//patternToSearch"/>
                    </ss:Data>
                </Cell>
                <Cell>
                    <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40">
                        <xsl:apply-templates select=".//replacementPattern"/>
                    </ss:Data>
                </Cell>
                <Cell>
                    <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40">
                        <xsl:apply-templates select=".//context"/>
                    </ss:Data>
                </Cell>
                <Cell>
                    <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40">
                        <xsl:apply-templates select=".//comment"/>
                    </ss:Data>
                </Cell>
            </Row>
        </xsl:if>
    </xsl:template>
    <xsl:template match="alert">
        <xsl:param name="lang" tunnel="yes"/>
        <xsl:if test="contains(@targetLanguage,$lang) or $lang='all'">
            <Row ss:StyleID="s36" xmlns="urn:schemas-microsoft-com:office:spreadsheet">
                <xsl:if test="$lang='all'">
                    <Cell>
                        <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40">
                            <xsl:value-of select="@targetLanguage"/>
                        </ss:Data>
                    </Cell>
                </xsl:if>
                <Cell>
                    <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40">
                        <xsl:apply-templates select=".//patternToSearch"/>
                    </ss:Data>
                </Cell>
                <Cell>
                    <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40"
                        >&#xa0;</ss:Data>
                </Cell>
                <Cell>
                    <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40">
                        <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40"
                            >&#xa0;</ss:Data>
                    </ss:Data>
                </Cell>
                <Cell>
                    <ss:Data ss:Type="String" xmlns="http://www.w3.org/TR/REC-html40">
                        <xsl:apply-templates select=".//comment"/>
                    </ss:Data>
                </Cell>
            </Row>
        </xsl:if>
    </xsl:template>
    <xsl:template match="pattern">
        <B xmlns="http://www.w3.org/TR/REC-html40">
            <Font html:Color="{$patternColor}">
                <xsl:value-of select="concat('&lt;',@value,'&gt;')"/>
            </Font>
        </B>
    </xsl:template>
    <xsl:template match="character">
        <B xmlns="http://www.w3.org/TR/REC-html40">
            <Font html:Color="{$patternColor}">
                <xsl:text>&lt;</xsl:text>
            </Font>
        </B>
        <Font html:Color="black" xmlns="http://www.w3.org/TR/REC-html40">
            <xsl:value-of select="@value"/>
        </Font>
        <B xmlns="http://www.w3.org/TR/REC-html40">
            <Font html:Color="{$patternColor}" xmlns="http://www.w3.org/TR/REC-html40">
                <xsl:text>&gt;</xsl:text>
            </Font>
        </B>
    </xsl:template>
    <xsl:template match="entity">
        <xsl:value-of select="concat('&amp;',@value,';')"/>
    </xsl:template>
    <xsl:template match="space">
        <Font html:Color="{$spaceColor}" xmlns="http://www.w3.org/TR/REC-html40">
            <xsl:value-of select="'•'"/>
        </Font>
    </xsl:template>


    <xsl:template match="implementedIn">
        <xsl:value-of select="concat(' - implementation:',@group,' -> ',@type)"/>
    </xsl:template>

    <xsl:template match="context">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="notInElement">
        <Font html:Color="{$contextColor}" xmlns="http://www.w3.org/TR/REC-html40">
            <xsl:value-of select="concat(' ( not in ',.,')')"/>
        </Font>
    </xsl:template>
    <xsl:template match="inElement">
        <Font html:Color="{$contextColor}" xmlns="http://www.w3.org/TR/REC-html40">
            <xsl:value-of select="concat(' ( only in ',.,')')"/>
        </Font>
    </xsl:template>
    <xsl:template match="freeContext">
        <Font html:Color="{$contextColor}" xmlns="http://www.w3.org/TR/REC-html40">
            <xsl:variable name="content"><xsl:apply-templates></xsl:apply-templates></xsl:variable>
            <xsl:value-of select="concat(' (',$content,')')"/>
        </Font>
    </xsl:template>
    <xsl:template match="conditionalReplacementPattern">
        <xsl:variable name="context">
            <xsl:apply-templates select="context/*"/>
        </xsl:variable>
        <xsl:variable name="replacement">
            <xsl:apply-templates select="replacementPattern"/>
        </xsl:variable>
        <xsl:value-of select="concat(' [si ',$context,' alors ',$replacement,']')"/>
    </xsl:template>
</xsl:stylesheet>
