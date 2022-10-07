<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2005 rel. 3 U (http://www.altova.com) by Don Brutzman (Naval Postgraduate School) -->
<!--
  <head>
   <meta name="filename"    content="ContentCatalogToXmlSpyProject.xslt" />
   <meta name="author"      content="Don Brutzman" />
   <meta name="created"     content="24 October  2005" />
   <meta name="revised"     content="5 July  2006" />
   <meta name="description" content="XSLT stylesheet to convert X3D example-archive catalogs into XML Spy project files." />
   <meta name="url"         content="http://www.web3d.org/x3d/content/ContentCatalogToXmlSpyProject.xslt" />
  </head>

Correspondence mapping:

X3D Catalog				XML Spy Project
===========				===============
ContentCatalog		Project/Folder
	@name				@FolderName
	Section@name			Folder@FolderName
	Chapter@name			Folder@FolderName
	Page				File
	[relative location url]		@FilePath


Recommended tools:
- XML Spy http://www.xmlspy.com

TODO:  appropriate error message when more than one meta identifier, name, date, etc. tag encountered
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="ContentCatalog">
		<xsl:text>&#10;</xsl:text>
		<xsl:comment><![CDATA[
	<meta name="author" content="Don Brutzman"/>
	<meta name="generator" content="ContentCatalogToXmlSpyProject.xslt"/>
	<meta name="url" content="http://www.web3d.org/x3d/content/ContentCatalogToXmlSpyProject.xslt"/>
	<meta name="description" content="XSLT stylesheet to convert X3D example-archive catalogs into XML Spy project files."/>
]]></xsl:comment>
		<xsl:text>&#10;</xsl:text>
		<xsl:message><xsl:text>[Info] ContentCatalogToXmlSpyProject.xslt construction note:  scenes with validation errors or warnings are kept in a separate XMLSpy project folder in order to support block testing of archive validation.</xsl:text></xsl:message>
		<!-- wrap output project document in top-level tag.  literal format, no customization needed -->
		<Project ValidFileSet="Yes" ValidFile="C:/www.web3d.org/TaskGroups/x3d/translation/x3d-3.1.xsd" XSL_XMLUseFile=".\X3dToXhtml.xslt">

			<!-- html pages of interest -->
			<xsl:element name="Folder">
				<xsl:attribute name="FolderName"><xsl:text>HTML pages</xsl:text></xsl:attribute>
				<File FilePath=".\index.html" HomeFolder="Yes"/>
				<File FilePath=".\help.html" HomeFolder="Yes"/>
				<File FilePath=".\license.html" HomeFolder="Yes"/>
				<File FilePath=".\X3dSceneAuthoringHints.html" HomeFolder="Yes"/>
			</xsl:element>

			<!-- primary directory of scenes -->
			<xsl:element name="Folder">
				<xsl:attribute name="FolderName">
					<xsl:choose>
						<xsl:when test="@title='examples'">
							<xsl:text>X3D Examples .x3d encoding</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@title"/>
							<xsl:text> X3D Examples .x3d encoding</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="ExtStr"><xsl:text>.x3d</xsl:text></xsl:attribute>
				<xsl:attribute name="ValidFileSet"><xsl:text>Yes</xsl:text></xsl:attribute>
				<xsl:attribute name="ValidFile"><xsl:text>C:/www.web3d.org/TaskGroups/x3d/translation/x3d-3.1.xsd</xsl:text></xsl:attribute>
				<xsl:attribute name="XSL_XMLUseSet"><xsl:text>Yes</xsl:text></xsl:attribute>
				<xsl:attribute name="XSL_XMLUseFile"><xsl:text>C:\www.web3d.org\x3d\content\X3dToXhtml.xslt</xsl:text></xsl:attribute>
				<xsl:attribute name="XSL_DestFileExtSet"><xsl:text>Yes</xsl:text></xsl:attribute>
				<xsl:attribute name="XSL_DestFolderSet"><xsl:text>Yes</xsl:text></xsl:attribute>
				<xsl:attribute name="XSL_DestFolder"><xsl:text>.</xsl:text></xsl:attribute>
				<!-- now loop over children tags and process each X3D scene -->
				<xsl:choose>
					<xsl:when test="Section">
						<xsl:apply-templates select="Section">
							<xsl:with-param name="canonical"><xsl:text>false</xsl:text></xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="Chapter">
							<xsl:with-param name="canonical"><xsl:text>false</xsl:text></xsl:with-param>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>

				<!-- add HelloWorld example-->
				<File FilePath="HelloWorld.x3d"/>
			</xsl:element>

			<!-- repeat for directory of Canonical.xml scenes -->
			<xsl:element name="Folder">
				<xsl:attribute name="FolderName">
					<xsl:choose>
						<xsl:when test="@title='examples'">
							<xsl:text>X3D Examples Canonical.xml encoding</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@title"/>
							<xsl:text> X3D Examples Canonical.xml encoding</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="ExtStr"><xsl:text>.xml</xsl:text></xsl:attribute>
				<xsl:attribute name="ValidFileSet"><xsl:text>Yes</xsl:text></xsl:attribute>
				<xsl:attribute name="ValidFile"><xsl:text>C:/www.web3d.org/TaskGroups/x3d/translation/x3d-3.1.xsd</xsl:text></xsl:attribute>
				<xsl:attribute name="XSL_XMLUseSet"><xsl:text>Yes</xsl:text></xsl:attribute>
				<xsl:attribute name="XSL_XMLUseFile"><xsl:text>C:\www.web3d.org\x3d\content\X3dToXhtml.xslt</xsl:text></xsl:attribute>
				<xsl:attribute name="XSL_DestFileExtSet"><xsl:text>Yes</xsl:text></xsl:attribute>
				<xsl:attribute name="XSL_DestFolderSet"><xsl:text>Yes</xsl:text></xsl:attribute>
				<xsl:attribute name="XSL_DestFolder"><xsl:text>.</xsl:text></xsl:attribute>
				<!-- now loop over children tags and process each X3D scene -->
				<xsl:apply-templates select="*">
					<xsl:with-param name="canonical"><xsl:text>true</xsl:text></xsl:with-param>
				</xsl:apply-templates>
				<!-- add HelloWorld example -->
				<File FilePath="HelloWorldCanonical.xml"/>
			</xsl:element>

			<!-- now repeat for scenes with validation problems, if any exist -->
			<xsl:if test="//Page[contains(@error,'valid') or contains(@error,'Valid') or contains(@warning,'valid') or contains(@warning,'Valid')]">
				<xsl:element name="Folder">
					<xsl:attribute name="FolderName">	<xsl:text>Validation warnings</xsl:text></xsl:attribute>
					<xsl:attribute name="ExtStr">		<xsl:text>.x3d</xsl:text></xsl:attribute>
					<xsl:attribute name="ValidFileSet">	<xsl:text>Yes</xsl:text></xsl:attribute>
					<xsl:attribute name="ValidFile">	<xsl:text>C:/www.web3d.org/TaskGroups/x3d/translation/x3d-3.1.xsd</xsl:text></xsl:attribute>
					<xsl:attribute name="XSL_XMLUseFile">	<xsl:text>.\X3dToXhtml.xslt</xsl:text></xsl:attribute>
					<xsl:for-each select="//Page[contains(@error,'valid') or contains(@error,'Valid') or contains(@warning,'valid') or contains(@warning,'Valid')]">
						<xsl:variable name="path">
							<xsl:value-of select="ancestor::ContentCatalog/@name"/>
							<xsl:text>/</xsl:text>
							<xsl:if test="ancestor::Section">
								<xsl:value-of select="ancestor::Section/@name"/>
								<xsl:text>/</xsl:text>
							</xsl:if>
							<xsl:value-of select="ancestor::Chapter/@name"/>
							<xsl:text>/</xsl:text>
							<xsl:value-of select="@name"/>
						</xsl:variable>
						<xsl:variable name="relativeUrl">
							 <xsl:call-template name="constructRelativeUrl">
								<xsl:with-param name="url">
									<xsl:value-of select="@url"/>
								</xsl:with-param>
								<xsl:with-param name="path">
									<xsl:value-of select="$path"/>
								</xsl:with-param>
							 </xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$relativeUrl">
								<xsl:element name="File">
									<xsl:attribute name="FilePath">
										<xsl:value-of select="$relativeUrl"/>
									</xsl:attribute>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@url">
								<xsl:comment>
									<xsl:value-of select="$path"/>
									<xsl:text>.x3d has problematic url: </xsl:text>
									<xsl:value-of select="@url"/>
								</xsl:comment>
							</xsl:when>
							<xsl:otherwise>
								<xsl:comment>
									<xsl:value-of select="$path"/>
									<xsl:text>.x3d missing meta tag for url</xsl:text>
								</xsl:comment>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:element>
			</xsl:if>
<!--
			<xsl:element name="Folder">
				<xsl:attribute name="FolderName">	<xsl:text>Content Catalog</xsl:text></xsl:attribute>
				<xsl:attribute name="ExtStr">		<xsl:text>.xml</xsl:text></xsl:attribute>
				<xsl:attribute name="ValidFileSet">	<xsl:text>Yes</xsl:text></xsl:attribute>
				<xsl:attribute name="ValidFile">
					<xsl:if test="contains(@name,'Basic') or contains(@name,'ConformanceNist') or contains(@name,'Vrml2.0Sourcebook') or contains(@name,'Savage') or contains(@name,'SavageDefense')">
						<xsl:text>..\</xsl:text>
					</xsl:if>
					<xsl:text>..\dom\ContentCatalog.dtd</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="XSL_XMLUseSet"><xsl:value-of select="Yes"/></xsl:attribute>
  why is Savage in next line???
			<Folder FolderName="Content Catalog" ExtStr=".xml" ValidFileSet="Yes" ValidFile=".\dom\ContentCatalog.dtd" XSL_XMLUseSet="Yes" XSL_XMLUseFile=".\ContentCatalogToXmlSpyProject.xslt" XSL_DestFolderSet="Yes" XSL_DestFolder=".\examples\Savage" XSL_DestFileExtSet="Yes" XSL_DestFileExt=".spp">
			</xsl:element>
				<File FilePath=".\ContentCatalog.spp" HomeFolder="Yes"/>
-->
			<!-- if Savage catalog, SMAL files of interest -->
			<xsl:if test="contains(@name,'Savage')">
				<xsl:element name="Folder">
					<xsl:attribute name="FolderName"><xsl:text>Savage Modeling Analysis Language (SMAL)</xsl:text></xsl:attribute>
					<File FilePath="..\Savage\Tools\SMAL\SavageModelingAnalysisLanguage1.0.xsd" HomeFolder="Yes"/>
					<File FilePath="..\Savage\Tools\SMAL\SavageModelingAnalysisLanguageDataTypes1.0.xsd" HomeFolder="Yes"/>
					<File FilePath="..\Savage\Tools\SMAL\SavageModelingAnalysisLanguageEnumerations1.0.xsd" HomeFolder="Yes"/>
					<File FilePath="..\Savage\Tools\SMAL\SavageModelingAnalysisLanguage1.0.dtd" HomeFolder="Yes"/>
				</xsl:element>
			</xsl:if>
			<!-- add content catalog -->
			<File FilePath=".\ContentCatalog{@name}.xml" HomeFolder="Yes"/>
		</Project>
	</xsl:template>

	<!-- n.b. some X3D example-archive catalogs do not have Section, only Chapter tags.  processing is identical for these. -->
	<xsl:template match="Section | Chapter">
		<xsl:param name="canonical"><xsl:text>false</xsl:text></xsl:param>
		<!-- skip if no pages exist in this folder -->
		<xsl:if test="Page or */Page">
			<!-- Section maps to Folder -->
			<xsl:element name="Folder">
				<xsl:attribute name="FolderName"><xsl:value-of select="@title"/></xsl:attribute>
				<!-- now loop over children tags and process each -->
				<xsl:apply-templates select="*">
					<xsl:with-param name="canonical"><xsl:value-of select="$canonical"/></xsl:with-param>
				</xsl:apply-templates>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Page">
		<xsl:param name="canonical"><xsl:text>false</xsl:text></xsl:param>
		<!-- Page maps to File -->
		<xsl:variable name="path">
			<xsl:value-of select="ancestor::ContentCatalog/@name"/>
			<xsl:text>/</xsl:text>
			<xsl:if test="ancestor::Section">
				<xsl:value-of select="ancestor::Section/@name"/>
				<xsl:text>/</xsl:text>
			</xsl:if>
			<xsl:value-of select="ancestor::Chapter/@name"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="@name"/>
		</xsl:variable>
		<xsl:variable name="relativeUrl">
			 <xsl:call-template name="constructRelativeUrl">
				<xsl:with-param name="url">
					<xsl:value-of select="@url"/>
				</xsl:with-param>
				<xsl:with-param name="path">
					<xsl:value-of select="$path"/>
				</xsl:with-param>
				<xsl:with-param name="canonical">
					<xsl:value-of select="$canonical"/>
				</xsl:with-param>
			 </xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="(@url='')">
				<!-- already reported -->
			</xsl:when>
			<xsl:when test="contains(@error,'valid') or contains(@error,'Valid')">
				<!-- don't provide link to scenes with validation error -->
				<xsl:text>&#10;	</xsl:text>
				<xsl:comment><xsl:text>[Error] </xsl:text><xsl:value-of select="@name"/><xsl:text>.x3d validation error:  </xsl:text><xsl:value-of select="@error"/></xsl:comment>
				<xsl:message><xsl:text>[Error] </xsl:text><xsl:value-of select="$path"/><xsl:text>.x3d validation error:  </xsl:text><xsl:value-of select="@error"/></xsl:message>
			</xsl:when>
			<xsl:when test="contains(@warning,'valid') or contains(@warning,'Valid')">
				<!-- don't provide link to scenes with validation warning -->
				<xsl:text>&#10;	</xsl:text>
				<xsl:comment><xsl:text>[Warning] </xsl:text><xsl:value-of select="@name"/><xsl:text>.x3d validation warning:  </xsl:text><xsl:value-of select="@warning"/></xsl:comment>
				<xsl:message><xsl:text>[Warning] </xsl:text><xsl:value-of select="$path"/><xsl:text>.x3d validation warning:  </xsl:text><xsl:value-of select="@warning"/></xsl:message>
			</xsl:when>
			<xsl:when test="($relativeUrl='.\')">
				<!-- don't provide link to scenes with url error -->
				<xsl:text>&#10;	</xsl:text>
				<xsl:comment><xsl:text>[Error] </xsl:text><xsl:value-of select="@name"/><xsl:text>.x3d url error:  </xsl:text><xsl:value-of select="@url"/></xsl:comment>
				<xsl:message><xsl:text>[Error] </xsl:text><xsl:value-of select="$path"/><xsl:text>.x3d url error:  </xsl:text><xsl:value-of select="@url"/></xsl:message>
			</xsl:when>
			<xsl:when test="(@url)">
				<xsl:element name="File">
					<xsl:attribute name="FilePath">
						<xsl:value-of select="$relativeUrl"/>
					</xsl:attribute>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<!-- if url missing, output error -->
				<xsl:message>
					<xsl:text>[Error] </xsl:text>
					<xsl:value-of select="$path"/>
					<xsl:text>.x3d file missing url information in meta tag, not trapped by other checks</xsl:text>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="constructRelativeUrl">
		<xsl:param name="url"/>
		<xsl:param name="path"/>
		<xsl:param name="canonical"><xsl:text>false</xsl:text></xsl:param>
		<!-- [relative location url] use meta tag, strip off unnecessary lead address, convert / to \ -->
		<xsl:text>.\</xsl:text>
		<xsl:variable name="x3dResult">
			<xsl:choose>
				<xsl:when test="contains($url,'/Basic/')">
					<xsl:value-of select="translate(substring-after(@url,'http://www.web3d.org/x3d/content/examples/Basic/'),'/','\')"/>
				</xsl:when>
				<xsl:when test="contains($url,'/ConformanceNist/')">
					<xsl:value-of select="translate(substring-after(@url,'http://www.web3d.org/x3d/content/examples/ConformanceNist/'),'/','\')"/>
				</xsl:when>
				<xsl:when test="contains($url,'/Vrml2.0Sourcebook/')">
					<xsl:value-of select="translate(substring-after(@url,'http://www.web3d.org/x3d/content/examples/Vrml2.0Sourcebook/'),'/','\')"/>
				</xsl:when>
				<xsl:when test="contains($url,'/Savage/')">
					<xsl:value-of select="translate(substring-after(@url,'https://savage.nps.edu/Savage/'),'/','\')"/>
				</xsl:when>
				<xsl:when test="contains($url,'/SavageDefense/')">
					<xsl:value-of select="translate(substring-after(@url,'https://SavageDefense.nps.navy.mil/SavageDefense/'),'/','\')"/>
				</xsl:when>
				<xsl:when test="contains($url,'http://www.web3d.org/x3d/content/examples/')">
					<!-- basic examples -->
					<xsl:value-of select="translate(substring-after(@url,'http://www.web3d.org/x3d/content/examples/'),'/','\')"/>
				</xsl:when>
                                <xsl:when test="(@url!='')">
                                    <!-- don't provide link to scenes with url error -->
                                    <xsl:comment><xsl:text>[Error] </xsl:text><xsl:value-of select="@name"/><xsl:text>.x3d url error:  no address provided</xsl:text></xsl:comment>
                                    <xsl:message><xsl:text>[Error] </xsl:text><xsl:value-of select="$path"/><xsl:text>.x3d url error:  no address provided</xsl:text></xsl:message>
                                </xsl:when>
				<xsl:otherwise>
					<xsl:message>
						<xsl:text>[Error] </xsl:text>
						<xsl:value-of select="$path"/>
						<xsl:text>.x3d meta tag has unrecognized url</xsl:text>
						<xsl:if test="@url">
							<xsl:text>:&#10;        url='</xsl:text>
							<xsl:value-of select="@url"/>
							<xsl:text>'</xsl:text>
						</xsl:if>
					</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$canonical='false'"><xsl:value-of select="$x3dResult"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="concat(substring-before($x3dResult,'.x3d'),'Canonical.xml')"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
