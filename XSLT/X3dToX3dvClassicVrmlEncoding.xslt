<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1"
                xmlns:saxon="http://icl.com/saxon" saxon:trace="no">
<!--
  <head>
   <meta name="filename"    content="X3dToX3dvClassicVrmlEncoding.xslt" />
   <meta name="author"      content="Don Brutzman, Duane Davis" />
   <meta name="created"     content="5 July 2004" />
   <meta name="revised"     content="3 April 2005" />
   <meta name="description" content="XSLT stylesheet to convert X3D files to ClassicVRML encoding,
   				     simply by using X3dToVrml97.xslt" />
   <meta name="url"         content="http://www.web3d.org/x3d/content/X3dToX3dvClassicVrmlEncoding.xslt" />
  </head>
-->

  <!-- use xsl:import rather than xsl:include so that variable definitions are overridden -->
  <xsl:import href="X3dToVrml97.xslt"/>

  <xsl:variable name="fileEncoding"><xsl:text>ClassicVRML</xsl:text></xsl:variable>
  <xsl:variable name="outputDiagnostics"><xsl:text>false</xsl:text></xsl:variable>

</xsl:stylesheet>
