<?xml version="1.0" encoding="UTF-8"?>
<!--
  <head>
   <meta name="title"    content="X3dToXhtml.xslt" />
   <meta name="creator"      content="Don Brutzman" />
   <meta name="created"     content=" 1 January   2001" />
   <meta name="revised"     content="26 September 2006" />
   <meta name="description" content="XSLT stylesheet to convert X3D source into an easily readable XHTML page.
   				This version applies color and style using Cascading Style Sheet (CSS) markup via HTML span, div tags." />
   <meta name="url"         content="http://www.web3d.org/x3d/content/X3dToXhtml.xslt" />
  </head>

Recommended tools:
- X3D-Edit http://www.web3d.org/x3d/content/README.X3D-Edit.html
- SAXON XML Toolkit (and Instant Saxon) from Michael Kay of ICL, http://saxon.sourceforge.net
- XML Spy http://www.xmlspy.com
-->

<!--	xmlns:fo="http://www.w3.org/1999/XSL/Format"	-->
<!--	xmlns:saxon="http://icl.com/saxon" saxon:trace="true"	-->

<xsl:stylesheet version="1.1"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/TR/xhtml1/strict">

	<xsl:import href="X3dExtrusionToSvgViaXslt1.1.xslt"/>

	<xsl:strip-space elements="*"/>
	<xsl:output encoding="UTF-8" media-type="text/html" indent="yes" cdata-section-elements="Script" omit-xml-declaration="no" method="xml"/>

	<!-- start - - - - - - - - - - - - - - - - - - - - - - - -->
	<xsl:template match="/">

	<!-- first produce supporting SVG figures -->
	<xsl:call-template name="produce-SVG-figures">
		<!--	<xsl:with-param name="list" select="."/> -->
	</xsl:call-template>

	<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
]]>
</xsl:text>
	<!--	<html xmlns="http://www.w3.org/1999/xhtml">
		<xsl:element name="html">
			<xsl:attribute name="xmlns">http://www.w3.org/1999/xhtml</xsl:attribute>
	  -->
	 	<xsl:comment>
	  		<xsl:text>Generated using XSLT processor: </xsl:text>
	  		<xsl:value-of select="system-property('xsl:vendor')"/>
	  	</xsl:comment>
		<html>
			<head>
				<title>
					<!-- Note that the name of the input file is not available/inspectable, and so the name must be extracted from the document itself.  This is OK for X3D files, since we have have such metadata conventions in the X3D Scene Authoring Hints.  If no name information was embedded, and the stylesheet were to be invoked by an external application, then the invoking application might be able to pass the input filename as a parameter to the stylesheet.-->
					<xsl:variable name="fileName" select="//head/meta[@name='title']/@content"/>
					<xsl:choose>
						<xsl:when test="$fileName!='*enter FileNameWithNoAbbreviations.x3d here*' ">
							<xsl:value-of select="$fileName"/>
							<xsl:text> (X3dToXhtml)</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>(X3dToXhtml)</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</title>
				<style type="text/css">
<!-- first put generic XML constructs, then X3D & specialized constructs -->
<![CDATA[
span.element {color: navy}
span.attribute {color: green}
span.value {color: teal}
span.plain {color: black}
span.gray  {color: gray}
span.idName {color: maroon}
a.idName {color: maroon}
div.center {text-align: center}
div.indent {margin-left: 25px}

span.prototype {color: purple}
a.prototype {color: purple, visited: black}
span.route {color: red}
b.warning {color: #CC5500}
b.error {color: #CC0000}
]]>
	</style>
				<meta name="generator" content="http://www.web3d.org/x3d/content/X3dToXhtml.xslt"/>
				<link rel="shortcut icon" href="http://www.web3d.org/x3d/content/icons/X3DtextIcon16.png" title="X3D" />
			</head>
			<body>
                                <xsl:choose>
                                    <xsl:when test="//X3D/@version='3.1'">
<!-- final DOCTYPE: -->
<pre>
&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;
&lt;!DOCTYPE X3D PUBLIC &quot;ISO//Web3D//DTD X3D 3.1//EN&quot;   &quot;http://www.web3d.org/specifications/x3d-3.1.dtd&quot;&gt;</pre>
<xsl:text>&#10;</xsl:text>
<!-- transitional DOCTYPE:
&lt;!DOCTYPE X3D PUBLIC &quot;http://www.web3d.org/specifications/x3d-3.1.dtd&quot; &quot;file:///www.web3d.org/specifications/x3d-3.1.dtd&quot;&gt;
-->
                                    </xsl:when>
                                    <xsl:otherwise>
<!-- final DOCTYPE: -->
<pre>
&lt;?xml version=&quot;1.0&quot; encoding=&quot;UTF-8&quot;?&gt;
&lt;!DOCTYPE X3D PUBLIC &quot;ISO//Web3D//DTD X3D 3.0//EN&quot;   &quot;http://www.web3d.org/specifications/x3d-3.0.dtd&quot;&gt;</pre>
<xsl:text>&#10;</xsl:text>
<!-- transitional DOCTYPE:
&lt;!DOCTYPE X3D PUBLIC &quot;http://www.web3d.org/specifications/x3d-3.0.dtd&quot; &quot;file:///www.web3d.org/specifications/x3d-3.0.dtd&quot;&gt;
-->
                                    </xsl:otherwise>
                                </xsl:choose>

				<xsl:apply-templates select="* | comment()" />

				<!-- build color key as XML comment -->
				<p>
				<xsl:text>&#10;&lt;!-- Tag color codes:&#10;</xsl:text>
				<xsl:text>&lt;</xsl:text>
				<span class="element">
					<xsl:text>Node</xsl:text>
				</span>
				<xsl:if test="//*[@DEF]">
					<span class="idName">
						<xsl:text> DEF</xsl:text>
					</span>
					<xsl:text>='</xsl:text>
					<span class="idName">
						<xsl:text>idName</xsl:text>
					</span>
					<xsl:text>'</xsl:text>
				</xsl:if>
				<xsl:text> </xsl:text>
				<span class="attribute">
					<xsl:text>attribute</xsl:text>
				</span>
				<xsl:text>='</xsl:text>
				<span class="value">
					<xsl:text>value</xsl:text>
				</span>
				<xsl:text>'/&gt;</xsl:text>
				<!-- ends node, begin Prototype -->
				<xsl:if test="//*[contains(local-name(),'Proto')]">
					<xsl:text>&#10;&lt;</xsl:text>
					<span class="prototype">
						<xsl:text>Prototype</xsl:text>
					</span>
					<xsl:text> </xsl:text>
					<span class="attribute">
						<xsl:text>name</xsl:text>
					</span>
					<xsl:text>='</xsl:text>
					<span class="prototype">
						<xsl:text>ProtoName</xsl:text>
					</span>
					<xsl:text>'&gt;</xsl:text>
					<xsl:text>&#10;	&lt;</xsl:text>
					<span class="prototype">
						<xsl:text>field</xsl:text>
					</span>
					<span class="attribute">
						<xsl:text>name</xsl:text>
					</span>
					<xsl:text>='</xsl:text>
					<span class="prototype">
						<xsl:text>fieldName</xsl:text>
					</span>
					<xsl:text>'/&gt;</xsl:text>
					<xsl:text> &lt;/</xsl:text>
					<span class="prototype">
						<xsl:text>Prototype</xsl:text>
					</span>
					<xsl:text>&gt;</xsl:text>
				</xsl:if>
				<xsl:text> --&gt;&#10;</xsl:text>
				</p>
			</body>
		<!-- </xsl:element> </html> -->
		</html>

		<!-- build Extrusion crossSection SVG diagrams
		<xsl:for-each select="//Extrusion">
		</xsl:for-each>
		 -->
	</xsl:template>

	<xsl:template match="*" >
		<!-- break to new line if needed -->
		<xsl:if test="(position() > 1) and not(local-name() ='X3D')"><xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text></xsl:if>
		<xsl:if test="@DEF or local-name()='ProtoDeclare' or local-name()='ExternProtoDeclare' or (local-name(..)='ProtoInterface' and local-name()='field') or local-name()='ROUTE'">
			<!-- add bookmarks -->
			<xsl:element name="a">
				<xsl:attribute name="name">
					<xsl:choose>
						<xsl:when test="@DEF">
							<xsl:value-of select="@DEF"/>
						</xsl:when>
						<xsl:when test="local-name()='ProtoDeclare'">
							<xsl:text>ProtoDeclare_</xsl:text>
							<xsl:value-of select="@name"/>
						</xsl:when>
						<xsl:when test="local-name()='ExternProtoDeclare'">
							<xsl:text>ExternProtoDeclare_</xsl:text>
							<xsl:value-of select="@name"/>
						</xsl:when>
						<xsl:when test="(local-name(..)='ProtoInterface' and local-name()='field')">
							<xsl:value-of select="../../@name"/>
							<xsl:text>ProtoField_</xsl:text>
							<xsl:value-of select="@name"/>
						</xsl:when>
						<xsl:when test="local-name()='ROUTE'">
							<xsl:text>ROUTE_</xsl:text>
							<xsl:value-of select="count(preceding::ROUTE)"/>
						</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<xsl:text> </xsl:text>
			</xsl:element>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:text>&#10;</xsl:text>
		<!-- insert ROUTE comment preceding node, if applicable -->
		<xsl:if test="@DEF">
			<xsl:variable name="DEFname" select="@DEF"/>
			<xsl:variable name="IncomingRoutes" select="//ROUTE[(@toNode=$DEFname)   and not(@fromNode=$DEFname)]"/>
			<xsl:variable name="OutgoingRoutes" select="//ROUTE[(@fromNode=$DEFname) and not(@toNode=$DEFname)]"/>
			<xsl:variable name="SelfRoutes"     select="//ROUTE[(@fromNode=$DEFname) and    (@toNode=$DEFname)]"/>
			<xsl:if test="$IncomingRoutes or $OutgoingRoutes or $SelfRoutes">
				<xsl:text>&lt;!-- </xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;span class="idName"&gt;</xsl:text>
				<xsl:value-of select="@DEF"/>
				<xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
				<xsl:text> </xsl:text>
				<i>
				<xsl:text>ROUTE</xsl:text>
				<xsl:if test="count($IncomingRoutes) + count($OutgoingRoutes) + count($SelfRoutes) > 1">
					<xsl:text>s</xsl:text>
				</xsl:if>
				</i>
				<xsl:text>:</xsl:text>
				<xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text> <!-- &nbsp; -->
				<xsl:text>&#10;</xsl:text>
				<xsl:for-each select="$IncomingRoutes">
					<xsl:text>[</xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>#ROUTE_</xsl:text>
							<xsl:value-of select="count(preceding::ROUTE)"/>
						</xsl:attribute>
						<xsl:text disable-output-escaping="yes">&lt;i&gt;</xsl:text>
						<xsl:text>from</xsl:text>
						<xsl:text disable-output-escaping="yes">&lt;/i&gt;</xsl:text>
						<xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text> <!-- &nbsp; -->
						<span class="idName">
							<xsl:value-of select="@fromNode"/>
						</span>
						<xsl:text>.</xsl:text>
						<span class="attribute">
							<xsl:value-of select="@fromField"/>
						</span>
						<xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text> <!-- &nbsp; -->
						<xsl:text disable-output-escaping="yes">&lt;i&gt;</xsl:text>
						<xsl:text>to</xsl:text>
						<xsl:text disable-output-escaping="yes">&lt;/i&gt;</xsl:text>
						<xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text> <!-- &nbsp; -->
						<span class="attribute">
							<xsl:value-of select="@toField"/>
						</span></xsl:element><xsl:text>]&#10;</xsl:text>
				</xsl:for-each>
				<xsl:for-each select="$OutgoingRoutes">
					<xsl:text>[</xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>#ROUTE_</xsl:text>
							<xsl:value-of select="count(preceding::ROUTE)"/>
						</xsl:attribute>
						<xsl:text disable-output-escaping="yes">&lt;i&gt;</xsl:text>
						<xsl:text>from</xsl:text>
						<xsl:text disable-output-escaping="yes">&lt;/i&gt;</xsl:text>
						<xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text> <!-- &nbsp; -->
						<span class="attribute">
							<xsl:value-of select="@fromField"/>
						</span>
						<xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text> <!-- &nbsp; -->
						<xsl:text disable-output-escaping="yes">&lt;i&gt;</xsl:text>
						<xsl:text>to</xsl:text>
						<xsl:text disable-output-escaping="yes">&lt;/i&gt;</xsl:text>
						<xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text> <!-- &nbsp; -->
						<span class="idName">
							<xsl:value-of select="@toNode"/>
						</span>
						<xsl:text>.</xsl:text>
						<span class="attribute">
							<xsl:value-of select="@toField"/>
						</span></xsl:element><xsl:text>]&#10;</xsl:text>
				</xsl:for-each>
				<xsl:for-each select="$SelfRoutes">
					<xsl:text>[</xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>#ROUTE_</xsl:text>
							<xsl:value-of select="count(preceding::ROUTE)"/>
						</xsl:attribute>
						<xsl:text>self-route</xsl:text>
						<xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text> <!-- &nbsp; -->
						<xsl:text disable-output-escaping="yes">&lt;i&gt;</xsl:text>
						<xsl:text>from</xsl:text>
						<xsl:text disable-output-escaping="yes">&lt;/i&gt;</xsl:text>
						<xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text> <!-- &nbsp; -->
						<span class="attribute">
							<xsl:value-of select="@fromField"/>
						</span>
						<xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text> <!-- &nbsp; -->
						<xsl:text disable-output-escaping="yes">&lt;i&gt;</xsl:text>
						<xsl:text>to</xsl:text>
						<xsl:text disable-output-escaping="yes">&lt;/i&gt;</xsl:text>
						<xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text> <!-- &nbsp; -->
						<span class="attribute">
							<xsl:value-of select="@toField"/>
						</span></xsl:element><xsl:text>]&#10;</xsl:text>
				</xsl:for-each>
				<xsl:text> --&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text>
				<xsl:text>&#10;</xsl:text>
			</xsl:if>
		</xsl:if>
		<!-- process element tag.  manually control generation of brackets since they are unaffected by styles.  -->
		<xsl:choose>
			<xsl:when test="* or comment() or local-name()='Script'">
				<!-- open tag for current element, which is a parent -->
				<xsl:text>&lt;</xsl:text>
				<xsl:call-template name="style-element-name" />
				<!-- handle attribute(s) if any -->
				<xsl:call-template name="process-attributes-in-order" />
				<!-- finish initial tag of pair -->
				<xsl:text>&gt;&#10;</xsl:text>
				<!-- indent children -->
				<div class="indent">
					<xsl:apply-templates select="* | comment()" />
					<!-- Script node:  output script source, preserve CDATA delimiters around contained code -->
					<xsl:if test="local-name()='Script' and text() and not (normalize-space(.)='' or normalize-space(.)=' ')">
						<xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text>
						<xsl:text>&#10;</xsl:text>
						<!-- eliminate/restore left margin so that CDATA script code has maximum page width -->
						<xsl:for-each select="ancestor::*">
							<xsl:text disable-output-escaping="yes">&lt;/div class="indent"&gt;</xsl:text>
							<xsl:text>&#10;</xsl:text>
						</xsl:for-each>
						<code><b><xsl:text>&lt;![CDATA[</xsl:text></b></code>
						<xsl:text>&#10;</xsl:text>
						<pre>
							<xsl:for-each select="text()">
								<xsl:choose>
									<xsl:when test="(normalize-space(.)='' or normalize-space(.)=' ') and preceding::field"></xsl:when><!--<xsl:text>// stripped LF before field&#10;</xsl:text> -->
									<xsl:when test="(normalize-space(.)='' or normalize-space(.)=' ') and following::field"></xsl:when><!--<xsl:text>// stripped LF after  field&#10;</xsl:text> -->
									<!-- usable text found, need to convert '<' to &lt; -->
									<xsl:otherwise>
										<xsl:call-template name="escape-lessthan-characters">
											<xsl:with-param name="inputString" select="."/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</pre>
						<code><b><xsl:text>]]&gt;</xsl:text></b></code>
						<xsl:text>&#10;</xsl:text>
						<!-- eliminate/restore left margin so that CDATA script code has maximum page width -->
						<xsl:for-each select="ancestor::*">
							<xsl:text disable-output-escaping="yes">&lt;div class="indent"&gt;</xsl:text>
							<xsl:text>&#10;</xsl:text>
						</xsl:for-each>
					</xsl:if>
				</div>
				<!-- close tag for this element -->
				<xsl:text>&lt;/</xsl:text>
				<xsl:call-template name="style-element-name" />
				<xsl:text>&gt;&#10;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<!-- single tag, no children -->
				<xsl:text>&lt;</xsl:text>
				<xsl:call-template name="style-element-name" />
				<!-- handle attribute(s) if any -->
				<xsl:call-template name="process-attributes-in-order" />

				<!-- finish singleton tag -->
				<xsl:text>/&gt;&#10;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	<!-- 	<xsl:if test="last() > position()"><xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text></xsl:if> -->
		<!-- element complete, insert index (after head tag prior to Scene tag, or after final X3D) or else break -->
		<xsl:if test="local-name()='head' or local-name()='X3D'">
			<xsl:call-template name="ID-link-index"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="escape-lessthan-characters">
		<xsl:param name="inputString" select="0"/>
		<!-- debug:  <xsl:text>//######&#10;</xsl:text> -->
  		<!-- debug:  <xsl:text>### inputString received: </xsl:text><xsl:value-of select="$inputString"/><xsl:text>&#10;</xsl:text> -->
		<xsl:choose>
			<!-- handle preceding &quot marks first -->
			<xsl:when test="contains($inputString,'&quot;') and not(contains(substring-before($inputString,'&quot;'),'&#60;'))">
				<xsl:value-of select="substring-before($inputString,'&quot;')"/>
				<xsl:text disable-output-escaping="no">&quot;</xsl:text>
				<xsl:call-template name="escape-lessthan-characters">
					<xsl:with-param name="inputString" select="substring-after($inputString,'&quot;')"/>
				</xsl:call-template>
			</xsl:when>
			<!-- &#60; is &lt; -->
			<xsl:when test="contains($inputString,'&#60;')">
				<xsl:value-of select="substring-before($inputString,'&#60;')"/>
				<xsl:text disable-output-escaping="no">&lt;</xsl:text>
				<xsl:call-template name="escape-lessthan-characters">
					<xsl:with-param name="inputString" select="substring-after($inputString,'&#60;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$inputString"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="style-element-name">
		<xsl:choose>
			<xsl:when test="contains(local-name(),'Proto') or starts-with(local-name(),'field')">
				<span class="prototype">
					<xsl:value-of select="local-name()"/>
				</span>
			</xsl:when>
			<xsl:when test="local-name()='ROUTE'">
				<span class="route">
					<xsl:value-of select="local-name()"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="element">
					<xsl:value-of select="local-name()"/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="process-attributes-in-order">
		<xsl:choose>
			<!-- handle specially ordered cases first -->
			<xsl:when test="local-name()='meta'">
				<xsl:apply-templates select="@name" />
				<xsl:apply-templates select="@content" />
				<xsl:apply-templates select="@*[local-name()!='name' and local-name()!='content']" />
			</xsl:when>
			<xsl:when test="starts-with(local-name(),'Metadata')">
				<!-- debug: <xsl:message>// process Metadata node</xsl:message> -->
				<xsl:apply-templates select="@name" />
				<xsl:apply-templates select="@value" />
				<xsl:apply-templates select="@containerField" />
			</xsl:when>
			<xsl:when test="local-name()='ROUTE'">
				<xsl:apply-templates select="@fromNode"/>
				<xsl:apply-templates select="@fromField"/>
				<xsl:apply-templates select="@toNode"/>
				<xsl:apply-templates select="@toField"/>
			</xsl:when>
			<xsl:when test="local-name()='ElevationGrid' or local-name()='GeoElevationGrid'">
				<xsl:apply-templates select="@DEF | @USE "/>
				<xsl:apply-templates select="@*[local-name()!='DEF' and local-name()!='USE' and local-name()!='height' and local-name()!='colorIndex']"/>
				<xsl:apply-templates select="@height"/>
				<xsl:apply-templates select="@colorIndex"/>
			</xsl:when>
			<xsl:when test="local-name()='IndexedFaceSet' or local-name()='IndexedLineSet'">
				<xsl:apply-templates select="@DEF | @USE "/>
				<xsl:apply-templates select="@*[local-name()!='DEF' and local-name()!='USE' and not(contains(local-name(), 'Index'))]"/>
				<xsl:apply-templates select="@*[contains(local-name(), 'Index')]"/>
			</xsl:when>
			<xsl:when test="local-name()='IMPORT'">
				<xsl:apply-templates select="@InlineDEF"/>
				<xsl:apply-templates select="@exportedDEF"/>
				<xsl:apply-templates select="@AS"/>
			</xsl:when>
			<xsl:when test="local-name()='EXPORT'">
				<xsl:apply-templates select="@localDEF"/>
				<xsl:apply-templates select="@AS"/>
			</xsl:when>
			<xsl:when test="contains(local-name(),'Proto')">
				<xsl:apply-templates select="@name"/>
				<xsl:apply-templates select="@DEF"/>
				<xsl:apply-templates select="@*[(local-name()!='DEF') and (local-name()!='name')]"/>
			</xsl:when>
			<xsl:when test="local-name()='field' or local-name()='fieldValue'">
				<xsl:apply-templates select="@name"/>
				<xsl:apply-templates select="@type"/>
				<xsl:apply-templates select="@value"/>
				<xsl:apply-templates select="@*[(local-name()!='name') and (local-name()!='type') and (local-name()!='value') and (local-name()!='appinfo') and (local-name()!='documentation')]"/>
				<xsl:if test="@appinfo">
					<xsl:text disable-output-escaping="yes">&#10;&lt;br /&gt;&#10;</xsl:text>
				</xsl:if>
				<xsl:apply-templates select="@appinfo"/>
				<xsl:if test="@documentation">
					<xsl:text disable-output-escaping="yes">&#10;&lt;br /&gt;&#10;</xsl:text>
				</xsl:if>
				<xsl:apply-templates select="@documentation"/>
			</xsl:when>
			<xsl:when test="contains(local-name(),'connect')">
				<xsl:apply-templates select="@nodeField"/>
				<!-- IS -->
				<xsl:apply-templates select="@protoField"/>
			</xsl:when>
			<!-- otherwise not a special case, process DEF/USE first and urls last -->
			<xsl:otherwise>
				<xsl:apply-templates select="@DEF | @USE | @*[not(contains(local-name(), 'url') or contains(local-name(), 'Url'))]"/>
				<xsl:apply-templates select="@*[contains(local-name(), 'url') or contains(local-name(), 'Url')]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*" >
  <!-- eliminate default attribute values, otherwise they will all appear in output  -->
  <!-- this block is used identically in X3dToVrml97.xsl X3dToHtml.xsl X3dUnwrap.xsl and X3dWrap.xsl -->
  <!-- check values with/without .0 suffix since these are string checks and autogenerated/DOM output might have either -->
  <!-- do not check ProtoInstances or natively defined nodes, since they might have different user-defined defaults -->
  <!-- tool-bug workaround:  split big boolean queries into pieces to avoid overloading the Xalan/lotusxml query buffer -->
  <xsl:variable name="notImplicitEvent1"
	select="not(local-name(..)='AudioClip'	and	(local-name()='duration_changed' or local-name()='elapsedTime' or local-name()='isPaused' or local-name()='isActive')) and
		not(contains(local-name(..),'Interpolator') and (local-name()='set_fraction' or local-name()='value_changed')) and
		not(contains(local-name(..),'Sequencer')    and (local-name()='set_fraction' or local-name()='value_changed' or local-name()='previous' or local-name()='next')) and
		not(local-name(..)='Background'	and	(local-name()='set_bind' or local-name()='bindTime' or local-name()='isBound')) and
		not(local-name(..)='Collision' and (local-name()='isActive' or local-name()='collideTime')) and
		not(local-name(..)='CylinderSensor' and	(local-name()='isActive' or local-name()='isOver' or local-name()='rotation' or local-name()='trackPoint_changed')) and
		not(local-name(..)='ElevationGrid'	and	local-name()='set_height') and
		not((local-name(..)='Extrusion') and starts-with(local-name(),'set_')) and
		not((local-name(..)='IndexedFaceSet' or local-name(..)='IndexedFaceSet') and starts-with(local-name(),'set_') and contains(local-name(),'Index')) and
		not(local-name(..)='IndexedLineSet' and	 local-name()='lineWidth') and
		not(local-name(..)='MovieTexture' and	(local-name()='duration_changed' or local-name()='elapsedTime' or local-name()='isPaused' or local-name()='isActive')) and
		not(local-name(..)='NavigationInfo' and	(local-name()='set_bind' or local-name()='bindTime' or local-name()='isBound'))
		" />
  <xsl:variable name="notImplicitEvent2"
	select="not(local-name(..)='PointSet'	and	 local-name()='pointSize') and
		not(local-name(..)='PlaneSensor' and	(local-name()='isActive' or local-name()='isOver' or local-name()='translation_changed' or local-name()='trackPoint_changed')) and
		not(local-name(..)='ProximitySensor' and (local-name()='isActive' or local-name()='position' or local-name()='orientation' or
						 	 local-name()='enterTime' or local-name()='exitTime')) and
		not(local-name(..)='SphereSensor' and	(local-name()='isActive' or local-name()='rotation' or local-name()='trackPoint_changed')) and
		not(local-name(..)='TimeSensor'	and	(local-name()='isActive' or local-name()='elapsedTime' or local-name()='isPaused' or local-name()='cycleTime' or local-name()='set_fraction' or
							 local-name()='time')) and
		not(local-name(..)='TouchSensor' and	(local-name()='isActive' or local-name()='isOver' or local-name()='hitNormal_changed' or
							 local-name()='touchTime' or local-name()='hitPoint_changed' or local-name()='hitTexCoord_changed')) and
		not(local-name(..)='Viewpoint'	  and	(local-name()='set_bind' or local-name()='bindTime' or local-name()='isBound' or local-name()='examine')) and
		not(local-name(..)='GeoViewpoint' and	(local-name()='set_bind' or local-name()='bindTime' or local-name()='isBound' or local-name()='examine'))
		" />
  <xsl:variable name="notImplicitEvent3"
	select="not(local-name(..)='BooleanTrigger'	and	(local-name()='set_triggerTime' or local-name()='triggerTrue')) and
		not(local-name(..)='IntegerTrigger'	and	(local-name()='set_boolean' or local-name()='triggerValue'))
		" />
  <xsl:variable name="notDefaultFieldValue1"
	select="not( local-name()='bboxCenter'	and	(.='0 0 0' or .='0.0 0.0 0.0')) and
		not( local-name()='bboxSize'	and	(.='-1 -1 -1' or .='-1.0 -1.0 -1.0')) and
		not( local-name(..)='AudioClip'	and
						((local-name()='loop' and .='false') or
						 (local-name()='pitch' and (.='1' or .='1.0')) or
						 (local-name()='startTime' and (.='0' or .='0.0')) or
						 (local-name()='stopTime' and (.='0' or .='0.0')) or
						 (local-name()='pauseTime' and (.='0' or .='0.0')) or
						 (local-name()='resumeTime'  and (.='0' or .='0.0')))) and
		not( local-name(..)='Background' and local-name()='skyColor' and (.='0 0 0' or .='0.0 0.0 0.0')) and
		not( local-name(..)='Billboard'	and local-name()='axisOfRotation' and (.='0 1 0' or .='0.0 1.0 0.0')) and
		not( local-name(..)='Box'	and ((local-name()='size' and (.='2 2 2' or .='2.0 2.0 2.0')) or (local-name()='solid' and .='true'))) and
		not( local-name(..)='Collision'	and local-name()='enabled' and .='true') and
		not( local-name(..)='Cone' and	((local-name()='bottomRadius' and (.='1' or .='1.0')) or
						 (local-name()='height' and (.='2' or .='2.0')) or
						 (local-name()='side' and .='true') or
						 (local-name()='solid' and .='true') or
						 (local-name()='bottom' and .='true')))"/>
  <xsl:variable name="notDefaultFieldValue1a"
	select="not( local-name(..)='Cylinder' and
						((local-name()='height' and (.='2' or .='2.0')) or
						 (local-name()='radius' and (.='1' or .='1.0')) or
						 (local-name()='bottom' and .='true') or
						 (local-name()='side' and .='true') or
						 (local-name()='solid' and .='true') or
						 (local-name()='top' and .='true'))) and
		not( local-name(..)='CylinderSensor' and
						((local-name()='autoOffset' and .='true') or
						 (local-name()='enabled' and .='true') or
						 (local-name()='diskAngle' and .='0.26179167') or
						 (local-name()='offset' and (.='0' or .='0.0')) or
						 (local-name()='maxAngle' and (.='-1' or .='-1.0')) or
						 (local-name()='minAngle' and (.='0' or .='0.0'))))" />
  <xsl:variable name="notDefaultFieldValue2"
	select="not( local-name(..)='DirectionalLight' and
						((local-name()='ambientIntensity' and (.='0' or .='0.0')) or
						 (local-name()='color' and (.='1 1 1' or .='1.0 1.0 1.0')) or
						 (local-name()='direction' and (.='0 0 -1' or .='0.0 0.0 -1.0')) or
						 (local-name()='intensity' and (.='1' or .='1.0')) or
						 (local-name()='on' and .='true'))) and
		not( local-name(..)='ElevationGrid' and
						((local-name()='ccw' and .='true') or
						 (local-name()='colorPerVertex' and .='true') or
						 (local-name()='normalPerVertex' and .='true') or
						 (local-name()='solid' and .='true') or
						 (local-name()='xDimension' and (.='0' or .='0.0')) or
						 (local-name()='xSpacing' and (.='1' or .='1.0')) or
						 (local-name()='zDimension' and (.='0' or .='0.0')) or
						 (local-name()='zSpacing' and (.='1' or .='1.0')) or
						 (local-name()='creaseAngle' and (.='0' or .='0.0')))) and
		not( local-name(..)='Extrusion'	and
						((local-name()='beginCap' and .='true') or
						 (local-name()='ccw' and .='true') or
						 (local-name()='convex' and .='true') or
						 (local-name()='endCap' and .='true') or
						 (local-name()='solid' and .='true') or
						 (local-name()='creaseAngle' and (.='0' or .='0.0')) or
						 (local-name()='orientation' and (.='0 0 1 0' or .='0.0 0.0 1.0 0.0')) or
						 (local-name()='scale' and (.='1 1' or .='1.0 1.0')) or
						 (local-name()='crossSection' and .='1 1, 1 -1, -1 -1, -1 1, 1 1') or
						 (local-name()='crossSection' and .='1 1 1 -1 -1 -1 -1 1 1 1') or
						 (local-name()='spine' and .='0 0 0, 0 1 0') or
						 (local-name()='spine' and .='0 0 0 0 1 0')))" />
  <xsl:variable name="notDefaultFieldValue3"
	select="not( local-name(..)='Fog' and 	((local-name()='color' and (.='1 1 1' or .='1.0 1.0 1.0')) or
						 (local-name()='visibilityRange' and (.='0' or .='0.0')) or
						 (local-name()='fogType' and .='&quot;LINEAR&quot;'))) and
		not( local-name(..)='FontStyle'	and
						((local-name()='horizontal' and .='true') or
						 (local-name()='leftToRight' and .='true') or
						 (local-name()='topToBottom' and .='true') or
						 (local-name()='size' and (.='1' or .='1.0')) or
						 (local-name()='spacing' and (.='1' or .='1.0')) or
						 (local-name()='family' and .='&quot;SERIF&quot;') or
						 (local-name()='justify' and .='&quot;BEGIN&quot;') or
						 (local-name()='style' and .='PLAIN'))) and
		not( local-name(..)='ImageTexture' and
						((local-name()='repeatS' and .='true') or
						 (local-name()='repeatT' and .='true'))) and
		not( local-name(..)='IndexedFaceSet' and
						((local-name()='ccw' and .='true') or
						 (local-name()='colorPerVertex' and .='true') or
						 (local-name()='convex' and .='true') or
						 (local-name()='normalPerVertex' and .='true') or
						 (local-name()='solid' and .='true') or
						 (local-name()='creaseAngle' and (.='0' or .='0.0')))) and
		not( local-name(..)='IndexedLineSet' and local-name()='colorPerVertex' and .='true') and
		not( local-name(..)='Inline' and local-name()='load' and .='true') and
		not( local-name(..)='LoadSensor' and
						((local-name()='enabled' and .='true'))) and
		not( local-name(..)='LOD'	and	 local-name()='center' and (.='0 0 0' or .='0.0 0.0 0.0')) and
		not( local-name(..)='Material'	and
						((local-name()='ambientIntensity' and .='0.2') or
						 (local-name()='diffuseColor' and .='0.8 0.8 0.8') or
						 (local-name()='emissiveColor' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='shininess' and .='0.2') or
						 (local-name()='specularColor' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='transparency' and (.='0' or .='0.0'))))" />
  <xsl:variable name="notDefaultFieldValue4"
	select="not( local-name(..)='MovieTexture' and
						((local-name()='loop' and .='false') or
						 (local-name()='speed' and (.='1' or .='1.0')) or
						 (local-name()='startTime' and (.='0' or .='0.0')) or
						 (local-name()='stopTime' and (.='0' or .='0.0')) or
						 (local-name()='pauseTime' and (.='0' or .='0.0')) or
						 (local-name()='resumeTime'  and (.='0' or .='0.0')) or
						 (local-name()='repeatS' and .='true') or
						 (local-name()='repeatT' and .='true'))) and
		not( local-name(..)='NavigationInfo' and
						((local-name()='avatarSize' and .='0.25 1.6 0.75') or
						 (local-name()='headlight' and .='true') or
						 (local-name()='speed' and (.='1' or .='1.0')) or
						 (local-name()='visibilityLimit' and (.='0' or .='0.0')))) and
		not( local-name(..)='PixelTexture' and
						((local-name()='repeatS' and .='true') or
						 (local-name()='repeatT' and .='true') or
						 (local-name()='image' and (.='0 0 0' or .='0.0 0.0 0.0')))) and
		not( local-name(..)='PlaneSensor' and
						((local-name()='autoOffset' and .='true') or
						 (local-name()='enabled' and .='true') or
						 (local-name()='maxPosition' and (.='-1 -1' or .='-1.0 -1.0')) or
						 (local-name()='minPosition' and (.='0 0' or .='0.0 0.0')) or
						 (local-name()='offset' and (.='0 0 0' or .='0.0 0.0 0.0')))) and
		not( local-name(..)='PointLight' and
						((local-name()='ambientIntensity' and (.='0' or .='0.0'))or
						 (local-name()='attenuation' and (.='1 0 0' or .='1.0 0.0 0.0')) or
						 (local-name()='color' and (.='1 1 1' or .='1.0 1.0 1.0')) or
						 (local-name()='intensity' and (.='1' or .='1.0')) or
						 (local-name()='location' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='on' and .='true') or
						 (local-name()='radius' and (.='100' or .='100.0'))))" />
  <xsl:variable name="notDefaultFieldValue5"
	select="not( local-name(..)='ProximitySensor' and
						((local-name()='center' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='size' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='enabled' and .='true'))) and
		not( local-name(..)='Script' and ((local-name()='directOutput' and .='false') or
						 (local-name()='mustEvaluate' and .='false'))) and
		not( local-name(..)='Sound' and ((local-name()='direction' and (.='0 0 1' or .='0.0 0.0 1.0')) or
						 (local-name()='intensity' and (.='1' or .='1.0')) or
						 (local-name()='location' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='priority' and (.='0' or .='0.0')) or
						 (local-name()='maxBack' and (.='10' or .='10.0')) or
						 (local-name()='maxFront' and (.='10' or .='10.0')) or
						 (local-name()='minBack' and (.='1' or .='1.0'))  or
						 (local-name()='minFront' and (.='1' or .='1.0')) or
						 (local-name()='spatialize' and .='true'))) and
		not( local-name(..)='Sphere' and ((local-name()='radius' and (.='1' or .='1.0')) or (local-name()='solid' and .='true'))) and
		not( local-name(..)='SphereSensor' and
						((local-name()='autoOffset' and .='true') or
						 (local-name()='enabled' and .='true') or
						 (local-name()='offset' and (.='0 1 0 0' or .='0.0 1.0 0.0 0.0'))))" />
  <!-- Switch whichChoice='-1' is very significant, so always show it -->
  <!--		not( local-name(..)='Switch' and  local-name()='whichChoice' and (.='-1' or .='-1.0')) and -->
  <xsl:variable name="notDefaultFieldValue6"
	select="not( parent::SpotLight	and
						((local-name()='ambientIntensity' and (.='0' or .='0.0')) or
						 (local-name()='attenuation' and (.='1 0 0' or .='1.0 0.0 0.0')) or
						 (local-name()='beamwidth' and .='1.570796') or
						 (local-name()='color' and (.='1 1 1' or .='1.0 1.0 1.0')) or
						 (local-name()='cutOffAngle' and .='0.785398') or
						 (local-name()='direction' and (.='0 0 -1' or .='0.0 0.0 -1.0')) or
						 (local-name()='intensity' and (.='1' or .='1.0')) or
						 (local-name()='location' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='on' and .='true') or
						 (local-name()='radius' and (.='100' or .='100.0')))) and
		not( local-name(..)='Text'   and  local-name()='maxExtent' and (.='0' or .='0.0')) and
		not( local-name(..)='TextureTransform' and
						((local-name()='center' and (.='0 0' or .='0.0 0.0')) or
						 (local-name()='rotation' and (.='0' or .='0.0')) or
						 (local-name()='scale ' and (.='1 1' or .='1.0 1.0')) or
						 (local-name()='translation' and (.='0 0' or .='0.0 0.0'))))" />
  <xsl:variable name="notDefaultFieldValue7"
	select="not( local-name(..)='TimeSensor' and
						((local-name()='cycleInterval' and (.='1' or .='1.0')) or
						 (local-name()='enabled' and .='true') or
						 (local-name()='startTime' and (.='0' or .='0.0')) or
						 (local-name()='stopTime' and (.='0' or .='0.0')) or
						 (local-name()='pauseTime' and (.='0' or .='0.0')) or
						 (local-name()='resumeTime'  and (.='0' or .='0.0')) or
						 (local-name()='loop' and .='false'))) and
		not( local-name(..)='TouchSensor' and
						  local-name()='enabled' and .='true') and
		not( local-name(..)='Transform' and
						((local-name()='center' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='rotation' and (.='0 0 1 0' or .='0.0 0.0 1.0 0.0')) or
						 (local-name()='scale' and (.='1 1 1' or .='1.0 1.0 1.0')) or
						 (local-name()='scaleOrientation' and (.='0 0 1 0' or .='0.0 0.0 1.0 0.0')) or
						 (local-name()='translation' and (.='0 0 0' or .='0.0 0.0 0.0')))) and
		not( local-name(..)='Viewpoint' and
						((local-name()='centerOfRotation' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='fieldOfView' and .='0.785398') or
						 (local-name()='jump' and .='true') or
						 (local-name()='orientation' and (.='0 0 1 0' or .='0.0 0.0 1.0 0.0')) or
						 (local-name()='position' and (.='0 0 10' or .='0.0 0.0 10.0')))) and
		not( local-name(..)='VisibilitySensor' and
						((local-name()='center' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='enabled' and .='true') or
						 (local-name()='size' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='enterTime' and (.='0' or .='0.0')) or
						 (local-name()='exitTime'  and (.='0' or .='0.0')) or
						 (local-name()='isActive' and .='false')))" />
  <xsl:variable name="notDefaultContainerField1"
	select="not((local-name()='containerField' and .='children')	and
			(contains(local-name(..),'Interpolator') or
			 contains(local-name(..),'Light') or
			 contains(local-name(..),'Sensor') or
			 local-name(..)='Anchor' or
			 local-name(..)='Background' or
			 local-name(..)='Billboard' or
			 local-name(..)='Collision' or
			 local-name(..)='Fog' or
			 local-name(..)='Group' or
			 local-name(..)='Inline' or
			 local-name(..)='LOD' or
			 local-name(..)='NavigationInfo' or
			 local-name(..)='Script' or
			 local-name(..)='Shape' or
			 local-name(..)='Sound' or
			 local-name(..)='Switch' or
			 local-name(..)='Transform' or
			 local-name(..)='Viewpoint' or
			 local-name(..)='WorldInfo')) and
		not((local-name()='containerField' and .='geometry')	and
			(local-name(..)='Box' or
			 local-name(..)='Cone' or
			 local-name(..)='Cylinder' or
			 local-name(..)='ElevationGrid' or
			 local-name(..)='Extrusion' or
			 local-name(..)='IndexedFaceSet' or
			 local-name(..)='IndexedLineSet' or
			 local-name(..)='PointSet' or
			 local-name(..)='Sphere' or
			 local-name(..)='Text' or
			 local-name(..)='XvlShell'))" />
  <xsl:variable name="notDefaultContainerField2"
	select="not((local-name()='containerField' and .='source')	and (local-name(..)='AudioClip')) and
		not((local-name()='containerField' and .='appearance')	and (local-name(..)='Appearance')) and
		not((local-name()='containerField' and .='material')	and (local-name(..)='Material')) and
		not((local-name()='containerField' and .='color')	and (local-name(..)='ColorNode' or local-name(..)='Color')) and
		not((local-name()='containerField' and .='coord')	and (local-name(..)='Coordinate')) and
		not((local-name()='containerField' and .='normal')	and (local-name(..)='Normal')) and
		not((local-name()='containerField' and .='texture')	and (local-name(..)='ImageTexture' or local-name(..)='PixelTexture' or local-name(..)='MovieTexture')) and
		not((local-name()='containerField' and .='fontStyle')	and (local-name(..)='FontStyle')) and
		not((local-name()='containerField' and .='texCoord')	and (local-name(..)='TextureCoordinate')) and
		not((local-name()='containerField' and .='textureTransform')	and (local-name(..)='TextureTransform'))" />
  <xsl:variable name="notDefaultDIS1"
	select="not(local-name(..)='EspduTransform' and
						(((local-name()='fired1' or local-name()='fired2') and (.='false')) or
						 (local-name()='deadReckoning'  and (.='0')) or
						 ((local-name()='articulationParameterCount' or local-name()='entityCategory' or local-name()='entitySubCategory' or local-name()='entityCountry' or local-name()='entityDomain' or local-name()='entityExtra' or local-name()='entityKind' or local-name()='entitySpecific' or local-name()='firingRange' or local-name()='firingRate' or local-name()='fuse' or local-name()='warhead' or local-name()='forceID' or local-name()='munitionQuantity') and (.='0')) or
						 ((local-name()='linearVelocity' or local-name()='linearAcceleration' or local-name()='munitionStartPoint' or local-name()='munitionEndPoint') and (.='0 0 0')))) and
		not((local-name(..)='EspduTransform' or contains(local-name(..),'Pdu')) and
						((starts-with(local-name(),'is')) or
						 (local-name()='rtpHeaderExpected' and (.='false')) or
						 (local-name()='readInterval'  and (.='.1' or .='0.1')) or
						 (local-name()='writeInterval'  and (.='1' or .='1.0')) or
						 ((local-name()='whichGeometry') and (.='1')) or
						 ((local-name()='multicastRelayPort' or local-name()='fireMissionIndex') and (.='0'))))" />
  <xsl:variable name="notDefaultDIS2"
  	select="not(local-name(..)='ReceiverPdu' and
						(((local-name()='radioID' or local-name()='receiverState' or starts-with(local-name(),'transmitter')) and (.='0')) or
						 (local-name()='receiverPower'  and (.='0' or .='0.0')))) and
		not(local-name(..)='SignalPdu' and
						(((local-name()='radioID' or local-name()='encodingScheme' or local-name()='tdlType' or local-name()='sampleRate' or local-name()='samples' or local-name()='dataLength') and (.='0')))) and
		not(local-name(..)='TransmitterPdu' and
						(((local-name()='radioID' or starts-with(local-name(),'antennaPattern') or starts-with(local-name(),'crypto') or local-name()='frequency' or local-name()='inputSource' or local-name()='lengthOfModulationParameters' or starts-with(local-name(),'modulationType') or starts-with(local-name(),'radioEntityType') or local-name()='transmitFrequencyBandwidth' or local-name()='transmitState') and (.='0')) or
						 (local-name()='power'  and (.='0' or .='0.0')) or
						 ((contains(local-name(),'antennaLocation') and (.='0 0 0')))))" />
  <xsl:variable name="notDefaultGeo"
	select="not(starts-with(local-name(..),'Geo') and local-name()='geoCoords' and (.='0 0 0' or .='0.0 0.0 0.0')) and
		not(local-name(..)='GeoLOD' 	  and local-name()='range' and (.='10' or .='10.0')) and
		not(local-name(..)='GeoViewpoint' and
						((local-name()='speedFactor' and (.='1' or .='1.0')) or
						 (local-name()='fieldOfView' and (.='0.785398' or .='.785398')))) and
		not((local-name(..)='GeoCoordinate' or local-name(..)='GeoOrigin') and
						((local-name()='rotateYUp' and (.='false')) or
						 (local-name()='geoSystem' and (translate(.,',','')='&quot;GD&quot; &quot;WE&quot;'))))" />
  <xsl:variable name="notDefaultHAnim"
	select="not( local-name(..)='HAnimJoint' and
						((local-name()='center' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='limitOrientation' and (.='0 0 1 0' or .='0.0 0.0 1.0 0.0')) or
						 (local-name()='rotation' and (.='0 0 1 0' or .='0.0 0.0 1.0 0.0')) or
						 (local-name()='scale' and (.='1 1 1' or .='1.0 1.0 1.0')) or
						 (local-name()='scaleOrientation' and (.='0 0 1 0' or .='0.0 0.0 1.0 0.0')) or
						 (local-name()='stiffness' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='translation' and (.='0 0 0' or .='0.0 0.0 0.0')))) and
		not( local-name(..)='HAnimSegment' and
						((local-name()='bboxCenter' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='bboxSize' and (.='-1 -1 -1' or .='-1.0 -1.0 -1.0')) or
						 (local-name()='centerOfMass' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='mass' and (.='0' or .='0.0')) or
						 (local-name()='momentsOfInertia' and
						  (.='0 0 0 0 0 0 0 0 0' or .='0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0')))) and
		not( local-name(..)='HAnimSite' and
						((local-name()='center' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='rotation' and (.='0 0 1 0' or .='0.0 0.0 1.0 0.0')) or
						 (local-name()='scale' and (.='1 1 1' or .='1.0 1.0 1.0')) or
						 (local-name()='scaleOrientation' and (.='0 0 1 0' or .='0.0 0.0 1.0 0.0')) or
						 (local-name()='translation' and (.='0 0 0' or .='0.0 0.0 0.0')))) and
		not( local-name(..)='HAnimHumanoid' and
						((local-name()='bboxCenter' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='bboxSize' and (.='-1 -1 -1' or .='-1.0 -1.0 -1.0')) or
						 (local-name()='center' and (.='0 0 0' or .='0.0 0.0 0.0')) or
						 (local-name()='rotation' and (.='0 0 1 0' or .='0.0 0.0 1.0 0.0')) or
						 (local-name()='scale' and (.='1 1 1' or .='1.0 1.0 1.0')) or
						 (local-name()='scaleOrientation' and (.='0 0 1 0' or .='0.0 0.0 1.0 0.0')) or
						 (local-name()='translation' and (.='0 0 0' or .='0.0 0.0 0.0'))))" />
  <xsl:variable name="notDefaultNurbs"
	select="not((local-name(..)='NurbsCurve' or local-name(..)='NurbsCurve2D') and
						((local-name()='tessellation ' and (.='0' or .='0.0')) or
						 (local-name()='order' and (.='3' or .='3.0')))) and
		not(local-name(..)='NurbsGroup' and
						((local-name()='tessellationScale' and (.='1' or .='1.0')))) and
		not(local-name(..)='NurbsPositionInterpolator' and
						((local-name()='fractionAbsolute' and (.='true')) or
						 (local-name()='order' and (.='3' or .='3.0')))) and
		not((local-name(..)='NurbsSurface' or local-name(..)='NurbsTextureSurface') and
						((local-name()='uTessellation' and (.='0')) or
						 (local-name()='vTessellation' and (.='0')) or
						 (local-name()='uDimension' and (.='0')) or
						 (local-name()='vDimension' and (.='0')) or
						 (local-name()='uOrder' and (.='3')) or
						 (local-name()='vOrder' and (.='3'))))" />
  <xsl:variable name="notFieldSpace"
	select="not(local-name(..)='field'  and	(local-name()='space' or local-name()='xml:space')) and
		not(local-name(..)='Script' and	(local-name()='space' or local-name()='xml:space'))" />
  <xsl:if test="$notImplicitEvent1 and
		$notImplicitEvent2 and
		$notImplicitEvent3 and
		$notDefaultFieldValue1 and
		$notDefaultFieldValue1a and
		$notDefaultFieldValue2 and
		$notDefaultFieldValue3 and
		$notDefaultFieldValue4 and
		$notDefaultFieldValue5 and
		$notDefaultFieldValue6 and
		$notDefaultFieldValue7 and
                $notDefaultDIS1        and
                $notDefaultDIS2        and
                $notDefaultGeo         and
                $notDefaultHAnim       and
                $notDefaultNurbs       and
                $notDefaultContainerField1 and
                $notDefaultContainerField2 and
                not(local-name()='containerField' and .='') and
                not(local-name()='class' and .='') and
                $notFieldSpace and
                not(contains(local-name(),'set_')) and
                not(contains(local-name(),'_changed')) and
                ." >
                <!-- good attribute found, output it -->
                <xsl:choose>
			<!-- break to new line prior to each of Background url fields -->
			<xsl:when test="(local-name()='url') or contains(local-name(), 'Url')">
				<xsl:text disable-output-escaping="yes">&#10;&lt;br /&gt;&#10;&amp;#160;&amp;#160;</xsl:text>
			</xsl:when>
                	<xsl:otherwise>
				<xsl:text disable-output-escaping="yes">&amp;#160;</xsl:text> <!-- &nbsp; -->
                	</xsl:otherwise>
                </xsl:choose>
		<!-- save value as variable $value for later use in constraint pattern matching -->
		<xsl:variable name="value" select="."/>
		<!-- style attribute name, as appropriate -->
		<xsl:choose>
			<xsl:when test="(local-name(..)='field' and (local-name()='appinfo' or local-name()='description'))">
				<span class="gray">
					<xsl:value-of select="local-name()"/>
				</span>
			</xsl:when>
			<xsl:when test="(local-name(..)='X3D' and local-name()='noNamespaceSchemaLocation')">
				<!-- xmlns:xsd attribute typically not seen, so insert it -->
				<xsl:if test="not(../@xsd)"> <!-- not(../@xmlns:xsd) and -->
					<span class="attribute">
						<xsl:text>xmlns:xsd</xsl:text>
					</span>
					<xsl:text>='</xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>http://www.w3.org/2001/XMLSchema-instance</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_blank</xsl:text>
						</xsl:attribute>
						<xsl:text>http://www.w3.org/2001/XMLSchema-instance</xsl:text>
					</xsl:element>
					<xsl:text>' </xsl:text>
				</xsl:if>
				<span class="attribute">
					<xsl:text>xsd:</xsl:text>
					<xsl:value-of select="local-name()"/>
				</span>
			</xsl:when>
			<xsl:when test="(local-name(..)='Extrusion' and local-name()='crossSection')">
				<!-- link to SVG diagram -->
				<xsl:variable name="svgFilename">
					<xsl:value-of select="substring-before(//head/meta[@name='title']/@content,'.x3d')"/>
					<xsl:text>.Extrusion</xsl:text>
					<xsl:value-of select="count(preceding::*[local-name()='Extrusion'])+1"/>
					<xsl:text>.svg</xsl:text>
				</xsl:variable>
			<!--	<xsl:message><xsl:text>$svgFilename=</xsl:text><xsl:value-of select="$svgFilename"/></xsl:message> -->
				<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>_svg/</xsl:text>
							<xsl:value-of select="$svgFilename"/>
						</xsl:attribute>
						<xsl:value-of select="local-name()"/></xsl:element><xsl:text>='</xsl:text>
						<!-- skipped to avoid whitespace: <span class="attribute"></span>-->
			</xsl:when>
			<xsl:otherwise>
				<span class="attribute">
					<xsl:value-of select="local-name()"/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="not(local-name(..)='Extrusion' and local-name()='crossSection')">
			<xsl:text>='</xsl:text>
		</xsl:if>
		<!-- style payload data, as appropriate -->
		<xsl:choose>
			<!-- handle special cases first -->
			<xsl:when test="not(.) or .=''">
				 <xsl:comment>no value, no action</xsl:comment> <!---->
			</xsl:when>
			<xsl:when test="local-name()='DEF'">
				<span class="idName">
					<xsl:value-of select="."/>
				</span>
			</xsl:when>
			<xsl:when test="local-name()='USE' or (local-name(..)='ROUTE' and contains(local-name(),'Node'))">
				<xsl:variable name="refName" select="."/>
				<xsl:choose>
					<xsl:when test="//*[@DEF=$refName]">
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:text>#</xsl:text>
								<xsl:value-of select="."/>
							</xsl:attribute>
							<xsl:attribute name="class">
								<xsl:text>idName</xsl:text>
							</xsl:attribute>
							<xsl:value-of select="."/>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<span class="idName">
							<xsl:value-of select="."/>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="local-name(..)='meta' and ../@name='warning'">
				<b class="warning">
					<xsl:value-of select="."/>
				</b>
			</xsl:when>
			<xsl:when test="local-name(..)='meta' and ../@name='error'">
				<b class="error">
					<xsl:value-of select="."/>
				</b>
			</xsl:when>
			<xsl:when test="(local-name(..)='meta' and local-name()='content') and (../@name='description')">
				<span class="plain">
					<xsl:value-of select="."/>
				</span>
			</xsl:when>
			<xsl:when test="((local-name(..)='field' or local-name(..)='fieldValue') and local-name()='appinfo')">
				<span class="gray">
					<xsl:value-of select="."/>
				</span>
			</xsl:when>
			<xsl:when test="(local-name(..)='ProtoInstance' and local-name()='name') and (//ProtoDeclare[@name=$value] or //ExternProtoDeclare[@name=$value])">
				<xsl:element name="a">
					<xsl:attribute name="href">
						<!-- build correct bookmark link for ProtoInstance name -->
						<xsl:text>#</xsl:text>
						<xsl:choose>
							<xsl:when test="//ProtoDeclare[@name=$value]">
								<xsl:text>ProtoDeclare_</xsl:text>
							</xsl:when>
							<xsl:when test="//ExternProtoDeclare[@name=$value]">
								<xsl:text>ExternProtoDeclare_</xsl:text>
							</xsl:when>
						</xsl:choose>
						<xsl:value-of select="."/>
					</xsl:attribute>
					<xsl:attribute name="class">
						<xsl:text>prototype</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="."></xsl:value-of>
				</xsl:element>
			</xsl:when>
			<xsl:when test="(local-name(..)='connect' and local-name()='nodeField')">
				<span class="prototype">
					<xsl:value-of select="."></xsl:value-of>
				</span>
			</xsl:when>
			<xsl:when test="(local-name(..)='connect' and local-name()='protoField')">
				<xsl:text disable-output-escaping="yes">&lt;span class="prototype"&gt;</xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<!-- build correct bookmark link for protoField name -->
							<xsl:text>#</xsl:text>
							<xsl:value-of select="//ProtoDeclare/@name"/>
							<xsl:text>ProtoField_</xsl:text>
							<xsl:value-of select="."/>
						</xsl:attribute>
						<xsl:attribute name="class">
							<xsl:text>prototype</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="."></xsl:value-of>
					</xsl:element>
				<xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
			</xsl:when>
			<xsl:when test="(contains(local-name(..),'Proto') or starts-with(local-name(..),'field')) and local-name()='name'">
				<span class="prototype">
					<xsl:value-of select="."></xsl:value-of>
				</span>
			</xsl:when>
			<xsl:when test="(local-name(..)='meta' and (../@name='generator') and local-name()='content') and starts-with(.,'X3D-Edit, ')">
				<xsl:variable name="containedUrl" select="substring-after(.,'X3D-Edit, ')"/>
				<span class="value">
					<xsl:text>X3D-Edit, </xsl:text>
				</span>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="$containedUrl"/>
					</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:text>_blank</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="$containedUrl"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="(local-name(..)='meta' and (../@name='generator') and local-name()='content') and starts-with(.,'Vrml97ToX3dNist, ')">
				<xsl:variable name="containedUrl" select="substring-after(.,'Vrml97ToX3dNist, ')"/>
				<span class="value">
					<xsl:text>Vrml97ToX3dNist, </xsl:text>
				</span>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="$containedUrl"/>
					</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:text>_blank</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="$containedUrl"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="(local-name(..)='meta' and (../@name='generator') and local-name()='content') and starts-with(.,'Vrml97ToX3dNist, ')">
				<xsl:variable name="containedUrl" select="substring-after(.,'Vrml97ToX3dNist, ')"/>
				<span class="value">
					<xsl:text>Vrml97ToX3dNist, </xsl:text>
				</span>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="$containedUrl"/>
					</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:text>_blank</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="$containedUrl"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="(local-name(..)='meta' and (../@name='generator') and local-name()='content') and starts-with(.,'Xj3D, ')">
				<xsl:variable name="containedUrl" select="substring-after(.,'Xj3D, ')"/>
				<span class="value">
					<xsl:text>Xj3D, </xsl:text>
				</span>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="$containedUrl"/>
					</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:text>_blank</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="$containedUrl"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="(local-name(..)='meta' and (../@name='generator') and local-name()='content') and starts-with(.,'FluxStudio, ')">
				<xsl:variable name="containedUrl" select="substring-after(.,'FluxStudio, ')"/>
				<span class="value">
					<xsl:text>FluxStudio, </xsl:text>
				</span>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="$containedUrl"/>
					</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:text>_blank</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="$containedUrl"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="(local-name(..)='meta' and (../@name='generator') and local-name()='content') and (contains(.,'.xslt') or contains(.,'.java') or contains(.,'.c') or contains(.,'.m')) and not(contains(.,' '))">
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="."/>
					</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:text>_blank</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="(local-name(..)='meta' and (../@name='generator') and local-name()='content')">
				<xsl:variable name="prefixProse"  select="substring-before(.,'http://')"/>
				<xsl:variable name="containedUrl" select="substring-after (.,$prefixProse)"/>
			<!--	<xsl:message>
					<xsl:text>$prefixProse=</xsl:text>
					<xsl:value-of select="$prefixProse"/>
					<xsl:text>, $containedUrl=</xsl:text>
					<xsl:value-of select="$containedUrl"/>
				</xsl:message> -->
				<xsl:if test="($prefixProse!='')">
					<span class="value">
						<xsl:value-of select="$prefixProse"/>
					</span>
				</xsl:if>
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:value-of select="$containedUrl"/>
					</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:text>_blank</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="$containedUrl"/>
				</xsl:element>
			</xsl:when>
			<!-- tokenize and make single/multiple url references into actual <a href=""> links -->
			<xsl:when test=" (local-name()='url' or contains(local-name(), 'Url')) or
					((local-name(..)='meta' and local-name()='content' and (../@name='identifier' or ../@name='url' or ../@name='license' or ../@name='example' or ../@name='title' or ../@name='reference' or ../@name='requires' or ../@name='drawing' or ../@name='image' or ../@name='map' or ../@name='chart' or ../@name='movie' or ../@name='MovingImage' or ../@name='photo' or ../@name='photograph' or ../@name='diagram' or ../@name='javadoc' or contains(../@name,'permission'))) and not(contains(normalize-space(.),' '))) or
					((local-name(..)='field' or local-name(..)='fieldValue') and (contains(../@name, 'Url') or contains(../@name, 'url')) and (local-name() = 'value')) or
					((local-name(..)='field' or local-name(..)='ProtoDeclare' or local-name(..)='ExternProtoDeclare') and (local-name()='documentation')) or
					 (contains(.,'http://') or contains(.,'https://'))">
	<!--				 (starts-with(normalize-space(.),'http://') or starts-with(normalize-space(.),'https://'))">	-->
	<!--	<xsl:if test="local-name(..)='Script'">
			<xsl:message>	<xsl:text>... found Script parent, attribute </xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:text>, value=</xsl:text>
					<xsl:value-of select="."/>
			</xsl:message>
		</xsl:if>
	-->
				<xsl:choose>
					<xsl:when test="starts-with(normalize-space(.),'ecmascript') or starts-with(normalize-space(.),'javascript')">
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="pre">
							<xsl:value-of select="."/>
						</xsl:element>
					</xsl:when>
					<xsl:when test="contains(.,'&quot;')">
						<xsl:text>&#10;</xsl:text>
						<xsl:call-template name="URL-ize-MFString-elements">
							<xsl:with-param name="list" select="normalize-space(.)"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="contains(.,'http://')">
		<!--	<xsl:message>	<xsl:text>... found http:// in reference... </xsl:text>
			</xsl:message> -->
						<xsl:text>&#10;</xsl:text>
						<xsl:value-of select="substring-before(.,'http://')"/>
						<xsl:call-template name="URL-ize-MFString-elements">
							<xsl:with-param name="list" select="normalize-space(substring-after(.,substring-before(.,'http://')))"/>
							<xsl:with-param name="urlsOnly"><xsl:text>true</xsl:text></xsl:with-param>
							<xsl:with-param name="insertBreaks"><xsl:text>false</xsl:text></xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:value-of select="normalize-space(.)"/>
							</xsl:attribute>
							<xsl:attribute name="target">
								<xsl:text>_blank</xsl:text>
							</xsl:attribute>
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="local-name(..)='meta' and local-name()='content' and (../@name='mail' or ../@name='email' or ../@name='e-mail' or ../@name='contact') and contains(.,'@')">
				<xsl:element name="a">
					<xsl:attribute name="href">
						<xsl:if test="not(starts-with(normalize-space(.),'mailto:'))">
							<xsl:text>mailto:</xsl:text>
						</xsl:if>
						<xsl:value-of select="normalize-space(.)"/>
					</xsl:attribute>
					<xsl:attribute name="target">
						<xsl:text>_blank</xsl:text>
					</xsl:attribute>
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:element>
			</xsl:when>
			<xsl:when test="(local-name(..)='X3D' and local-name()='noNamespaceSchemaLocation')">
				<span class="value">
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:value-of select="."/>
						</xsl:attribute>
						<xsl:attribute name="target">
							<xsl:text>_blank</xsl:text>
						</xsl:attribute>
						<xsl:value-of select="."/>
					</xsl:element>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="value">
					<xsl:value-of select="."/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>'</xsl:text>
  <!-- end if filtering of default attribute values -->
  </xsl:if>
	</xsl:template>

	<!-- ****** XML comments ****** -->
	<xsl:template match="comment()">
		<xsl:choose>
			<xsl:when test="(.='Warning:  transitional DOCTYPE in source .x3d file')">
				<!-- ignore transitional DOCTYPE warning since it is corrected by initial stylesheet output -->
			</xsl:when>
			<xsl:when test="starts-with(normalize-space(.),'Additional authoring resources for meta-tags: ')">
				<!-- break to new line if needed -->
				<xsl:if test="position() > 1"><xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text></xsl:if>
				<code><xsl:text>&lt;!--&#10;</xsl:text>
						<xsl:call-template name="URL-ize-MFString-elements">
							<xsl:with-param name="list" select="."/>
							<xsl:with-param name="urlsOnly"><xsl:text>true</xsl:text></xsl:with-param>
						</xsl:call-template>
					<xsl:text>&#10;--&gt;</xsl:text></code>
				<xsl:text>&#10;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<!-- break to new line if needed -->
				<xsl:if test="position() > 1"><xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text></xsl:if>
				<!-- wrap comment in blanks in case it ends with hyphen, since - is not a valid comment terminator -->
				<xsl:text>&lt;!-- </xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text> --&gt;</xsl:text>
				<xsl:text>&#10;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ****** XML processing-instruction ****** -->
	<xsl:template match="processing-instruction()">
		<xsl:text>&lt;-- </xsl:text><xsl:value-of select="."/><xsl:text> --&gt;&#10;</xsl:text>
	</xsl:template>

	<xsl:template name="ID-link-index">
		<!-- output bookmark index:  ExternProtoDeclare, ProtoDeclare, DEF -->
		<xsl:if test="(//*[@DEF]) or (//*[local-name()='ProtoDeclare']) or (//*[local-name()='ExternProtoDeclare'])">
			<xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text>
			<xsl:text>&#10;&lt;!--&#10;</xsl:text>
			<div class="center">
				<hr width="100%"/>
				<xsl:if test="//*[local-name()='ExternProtoDeclare']">
					<xsl:text>&#10;</xsl:text>
					<i>
						<xsl:text>Index for ExternProtoDeclare definition</xsl:text>
						<xsl:if test="count(//*[local-name()='ExternProtoDeclare']) > 1">
							<xsl:text>s</xsl:text>
						</xsl:if>
					</i>
					<xsl:text>: </xsl:text>
					<xsl:for-each select="//*[local-name()='ExternProtoDeclare']">
						<xsl:sort select="@DEF" order="ascending" case-order="upper-first" data-type="text"/>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:text>#ExternProtoDeclare_</xsl:text>
								<xsl:value-of select="@name"/>
							</xsl:attribute>
							<xsl:attribute name="class">
								<xsl:text>prototype</xsl:text>
							</xsl:attribute>
							<!-- visible part of anchor -->
							<xsl:value-of select="@name"/>
						</xsl:element>
						<xsl:if test="not(position()=last())">
							<xsl:text>,</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="//*[local-name()='ProtoDeclare']">
					<xsl:text>&#10;</xsl:text>
					<xsl:if test="//*[local-name()='ExternProtoDeclare']">
						<xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text>
						<xsl:text>&#10;</xsl:text>
					</xsl:if>
					<i>
						<xsl:text>Index for ProtoDeclare definition</xsl:text>
						<xsl:if test="count(//*[local-name()='ProtoDeclare']) > 1">
							<xsl:text>s</xsl:text>
						</xsl:if>
					</i>
					<xsl:text>: </xsl:text>
					<xsl:for-each select="//*[local-name()='ProtoDeclare']">
						<xsl:sort select="@DEF" order="ascending" case-order="upper-first" data-type="text"/>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:text>#ProtoDeclare_</xsl:text>
								<xsl:value-of select="@name"/>
							</xsl:attribute>
							<xsl:attribute name="class">
								<xsl:text>prototype</xsl:text>
							</xsl:attribute>
							<!-- visible part of anchor -->
							<xsl:value-of select="@name"/>
						</xsl:element>
						<xsl:if test="not(position()=last())">
							<xsl:text>,</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="//*[@DEF]">
					<xsl:text>&#10;</xsl:text>
					<xsl:if test="//*[local-name()='ProtoDeclare'] or //*[local-name()='ExternProtoDeclare']">
						<xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text>
						<xsl:text>&#10;</xsl:text>
					</xsl:if>
					<i>
						<xsl:text>Index for DEF node</xsl:text>
						<xsl:if test="count(//*[@DEF]) > 1">
							<xsl:text>s</xsl:text>
						</xsl:if>
					</i>
					<xsl:text>: </xsl:text>
					<xsl:for-each select="//*[@DEF]">
						<xsl:sort select="@DEF" order="ascending" case-order="upper-first" data-type="text"/>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:text>#</xsl:text>
								<xsl:value-of select="@DEF"/>
							</xsl:attribute>
							<xsl:attribute name="class">
								<xsl:text>idName</xsl:text>
							</xsl:attribute>
							<!-- visible part of anchor -->
							<xsl:value-of select="@DEF"/>
						</xsl:element>
						<xsl:if test="not(position()=last())">
							<xsl:text>,</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				<xsl:text>&#10;</xsl:text>
				<hr width="100%"/>
			</div>
			<xsl:text>&#10;--&gt;&#10;</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- ****** URL-ize-MFString-elements:  callable template (recursive function) ****** -->
	<!-- follows examples in Michael Kay's _XSLT_, first edition, pp. 551-554 -->
	<xsl:template name="URL-ize-MFString-elements">
		<xsl:param name="list"/>
		<xsl:param name="urlsOnly"><xsl:text>false</xsl:text></xsl:param>
		<xsl:param name="insertBreaks"><xsl:text>true</xsl:text></xsl:param>
		<xsl:variable name="wlist" select="concat(normalize-space($list),' ')"/>
		<!-- debug: <xsl:text>&#10;$wlist=[</xsl:text><xsl:value-of select="$wlist" disable-output-escaping="yes"/><xsl:text>]&#10;</xsl:text> -->
		<!-- debug: <xsl:message><xsl:text>$urlsOnly=</xsl:text><xsl:value-of select="$urlsOnly"/></xsl:message> -->
		<xsl:if test="$wlist!=' '">
			<xsl:variable name="nextURL"> <!-- nextCandidateUrl token, anyway -->
						<xsl:value-of select="substring-before($wlist,' ')"/>
			</xsl:variable>
					<!-- don't force &quot; substitution when working with plain text -->
					<!--	<value-of select="translate(substring-before($wlist,' '),'&quot;','')"/> -->
			<!-- 	<xsl:choose>
					<xsl:when test="($urlsOnly='true')">
						<xsl:value-of select="substring-before($wlist,' ')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>blah</xsl:text>
						<value-of select="substring-before(normalize-space(translate($wlist,'&quot;',' ')),' ')"/>
						<value-of select="substring-before($wlist,' ')"/>

						<value-of select="$wlist"/>
					</xsl:otherwise>
				</xsl:choose> -->
			<!--
						<value-of select="translate(substring-before(normalize-space($wlist),' '),'&quot;','')"/>
			-->
			<!-- debug: <xsl:text>&#10;$nextURL=[</xsl:text><xsl:value-of select="$nextURL" disable-output-escaping="yes"/><xsl:text>]&#10;</xsl:text> -->
			<xsl:variable name="nextURLsize" select="string-length($nextURL)"/>
			<!-- debug: <xsl:text>&#10;$nextURLsize=[</xsl:text><xsl:value-of select="$nextURLsize" disable-output-escaping="yes"/><xsl:text>]&#10;</xsl:text> -->
			<!-- stack overflow problems when taking substring after $nextURL -->
			<xsl:variable name="restURLs" select="substring-after($wlist,' ')"/>
			<!-- debug: <xsl:text>&#10;$restURLs=[</xsl:text><xsl:value-of select="$restURLs" disable-output-escaping="yes"/><xsl:text>]&#10;</xsl:text> -->
			<xsl:choose>
				<xsl:when test="($urlsOnly='true') and not(contains($nextURL,'http://')) and not(contains($nextURL,'ftp://'))">
					<!-- merely output text -->
					<xsl:value-of disable-output-escaping="yes" select="$nextURL"/>
					<xsl:text> </xsl:text>
				</xsl:when>
				<!-- handle ftp:// but only if it precedes http:// -->
				<xsl:when test="($urlsOnly='true') and (contains($nextURL,'ftp://')) and not(contains(substring-before($nextURL,'ftp://'),'http://'))">
					<!-- ftp:// found next -->
					<xsl:value-of disable-output-escaping="yes" select="substring-before($nextURL,'ftp://')"/>
					<xsl:if test="$insertBreaks='true'">
					  <xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text>
					</xsl:if>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>ftp://</xsl:text>
							<xsl:value-of select="normalize-space(substring-after($nextURL,'ftp://'))"/>
						</xsl:attribute>
						<xsl:text>ftp://</xsl:text>
						<xsl:value-of select="normalize-space(substring-after($nextURL,'ftp://'))"/>
					</xsl:element>
					<xsl:text> </xsl:text>
					<xsl:if test="($insertBreaks='true') and not(starts-with(normalize-space($restURLs),'ftp://')) and not(starts-with(normalize-space($restURLs),'http://'))">
						<xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text>
					</xsl:if>
				</xsl:when>
				<!-- handle http:// but only if it precedes ftp:// -->
				<xsl:when test="($urlsOnly='true')">
					<!-- http:// found next -->
					<xsl:value-of disable-output-escaping="yes" select="substring-before($nextURL,'http://')"/>
					<xsl:if test="$insertBreaks='true'">
					  <xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text>
					</xsl:if>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:text>http://</xsl:text>
							<xsl:value-of select="normalize-space(substring-after($nextURL,'http://'))"/>
						</xsl:attribute>
						<xsl:text>http://</xsl:text>
						<xsl:value-of select="normalize-space(substring-after($nextURL,'http://'))"/>
					</xsl:element>
					<xsl:text> </xsl:text>
					<xsl:if test="($insertBreaks='true') and not(starts-with(normalize-space($restURLs),'ftp://')) and not(starts-with(normalize-space($restURLs),'http://'))">
						<xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise> <!-- ($urlsOnly='false') -->
					<!-- output URL-ized nextURL -->
					<xsl:text>&quot;</xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href">
							<xsl:value-of select="normalize-space(translate($nextURL,'&quot;',''))"/>
						</xsl:attribute>
						<xsl:value-of select="normalize-space(translate($nextURL,'&quot;',''))"/>
					</xsl:element>
					<xsl:text>&quot;</xsl:text>
					<xsl:text>&#10;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<!-- tail recurse on remainder of list of URLs -->
			<xsl:if test="$restURLs!=''">
				<xsl:call-template name="URL-ize-MFString-elements">
					<xsl:with-param name="list" select="$restURLs"/>
					<xsl:with-param name="urlsOnly" select="$urlsOnly"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!-- SVG -->
	<xsl:template name="produce-SVG-figures">

		<xsl:for-each select="//Extrusion">

			<xsl:variable name="svgFilename">
				<xsl:value-of select="substring-before(//head/meta[@name='title']/@content,'.x3d')"/>
				<xsl:text>.Extrusion</xsl:text>
				<xsl:value-of select="position()"/>
				<xsl:text>.svg</xsl:text>
			</xsl:variable>
		<!--	<xsl:message><xsl:text>$svgFilename=</xsl:text><xsl:value-of select="$svgFilename"/></xsl:message> -->

			<!-- document goes in _svg directory, may need to change X3dToXhtml.xslt invocations in Makefile -->
			<xsl:result-document href="_svg/{$svgFilename}" method="xml" encoding="utf-8" indent="yes">
                            <xsl:fallback>
                                <xsl:message>&lt;xsl:result-document&gt; not supported, no SVG diagram produced for Extrusion</xsl:message>
                            </xsl:fallback>

			<!--	<svg/> -->

				<!-- invoke appropriate template in X3dExtrusionToSvgViaXslt1.1.xslt -->
				<xsl:call-template name="plotSvgExtrusionCrossSection">
					<xsl:with-param name="svgFilename" select="$svgFilename"/>
				</xsl:call-template>

			</xsl:result-document>

		</xsl:for-each>

		<!-- can invoke other 2D nodes similarly -->
	</xsl:template>

</xsl:stylesheet>

