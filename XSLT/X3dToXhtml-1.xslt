<?xml version="1.0" encoding="UTF-8"?>
<!--
  <head>
   <meta name="filename"    content="X3dToXhtml-1.xslt" />
   <meta name="author"      content="Don Brutzman" />
   <meta name="created"     content="23 January 2003" />
   <meta name="revised"     content="28 December 2005" />
   <meta name="description" content="XSLT stylesheet, dissected, to convert X3D source into an easily readable XHTML page.
   				This initial introductory version sets up headers and walks the tree.  Comments are ignored." />
   <meta name="url"         content="http://www.web3d.org/TaskGroups/x3d/content/X3dToXhtml-1.xslt" />
  </head>

Recommended tools:
- X3D-Edit http://www.web3d.org/TaskGroups/x3d/content/README.X3D-Edit.html
- SAXON XML Toolkit (and Instant Saxon) from Michael Kay of ICL, http://saxon.sourceforge.net
- XML Spy http://www.xmlspy.com
-->
 <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:saxon="http://icl.com/saxon" saxon:trace="yes">
	<xsl:strip-space elements="*"/>
	<xsl:output encoding="UTF-8" media-type="text/html" indent="yes" cdata-section-elements="Script" omit-xml-declaration="no" method="xml"/>

	<!-- precedence of pattern match is most-specific rules (templates) first, then least-specific rules (templates) -->
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:variable name="fileName" select="//head/meta[@name='title']/@content"/>
					<xsl:choose>
						<xsl:when test="//head/meta[@name='title']/@content='HelloWorld.x3d' ">
							<xsl:text> bleah bleah bleah!</xsl:text>
						</xsl:when>
						<xsl:when test="//head/meta[@name='title']/@content!='*enter FileNameWithNoAbbreviations.x3d here*' ">
							<xsl:value-of select="$fileName"/>
							<xsl:text> (X3dToXhtml)</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text> X3dToXhtml </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</title>
				<meta name="generator" content="http://www.web3D.org/TaskGroups/x3d/content/X3dToXhtml-1.xslt"></meta>
			</head>
			<body>
				<xsl:apply-templates select="*" />

				<!-- end of file output (if any) could go here -->
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="*" >
		<p>
			<xsl:text>element </xsl:text>
			<xsl:value-of select="local-name(.)"></xsl:value-of>
			<xsl:text> has name() 
</xsl:text>
			<xsl:value-of select="name()"></xsl:value-of>
			<xsl:text> &#10;and parent </xsl:text>
			<xsl:value-of select="local-name(..)"></xsl:value-of>
		</p>
		<xsl:apply-templates select="*" />
	</xsl:template>

</xsl:stylesheet>
