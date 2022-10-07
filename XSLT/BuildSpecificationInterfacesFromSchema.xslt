<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="1.1"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:date="http://exslt.org/dates-and-times"
                saxon:trace="true"
                extension-element-prefixes="saxon xs"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xeena="../content/profile.dtd"
                xmlns:x3d="../content/x3d-3.0.xsd">
  <xsl:param name="LinkDom" select="true"/>

<!--	XSL namespaces are in transition!  Tools are slow to catch up.
    ***	Edit the topmost stylesheet tag on line 2 of this file to match the xmlns namespace URI for your XSL tool. ***
	W3C:
	Saxon:           <xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
	IBM XSLEditor:   <xsl:stylesheet xmlns:xsl='http://www.w3.org/XSL/Transform/1.0'>
	IE 5:            <xsl:stylesheet xmlns:xsl='http://www.w3.org/TR/WD-xsl'>
	XT:              <xsl:stylesheet xmlns:xsl='http://www.w3.org/XSL/Transform'>
-->

<!--
  <head>
   <meta name="filename"    content="BuildSpecificationInterfacesFromSchema.xslt" />
   <meta name="author"      content="Don Brutzman" />
   <meta name="created"     content="14 July 2002" />
   <meta name="revised"     content="24 January 2005" />
   <meta name="description" content="XSL stylesheet to convert X3D Schema to XHTML files for X3D specification." />
   <meta name="url"         content="http://www.web3D.org/TaskGroups/x3d/sai/BuildSpecificationInterfacesFromSchema.xslt" />
  </head>

Recommended tool:
-  SAXON XML Toolkit (and Instant Saxon) from Michael Kay of ICL, http://saxon.sourceforge.net
   Especially necessary since this stylesheet uses saxon-specific extensions for file handling

Invocation:
-  cd   C:\www.web3D.org\TaskGroups\x3d\content
   make buildSpecInterfacesFromSchema

Bugs:
- LoadSensor children not handled properly   
-->

<xsl:output method="xml" encoding="UTF8" indent="yes" omit-xml-declaration="yes"/>

<xsl:strip-space elements="*" />

<xsl:variable name="X3dTooltipsFile"><xsl:text>x3d-3.0.profile.xml</xsl:text></xsl:variable>


<!-- ****************** root:  start of file ****************** -->
<xsl:template match="/">

<xsl:message>
  <xsl:text>BuildSpecificationInterfacesFromSchema:  X3D schema version </xsl:text>
  <xsl:value-of select="//xs:schema/@version"/>
 </xsl:message> 
		 
<!-- X3D schema validity checks  -->
<!-- check for duplicate accessType definitions -->
<xsl:for-each select="//xs:schema/xs:simpleType[contains(@name,'AccessType')]/xs:restriction/xs:enumeration">
  <xsl:variable name="enumerationValue"><xsl:value-of select="@value"/>
  </xsl:variable>
	<xsl:if test="(count(preceding-sibling::*[@value=$enumerationValue])>1) and (count(following-sibling::*[@value=$enumerationValue])=0)">
		<xsl:message>
		  <xsl:text>[Warning] accessType enumeration '</xsl:text>
		  <xsl:value-of select="$enumerationValue"/>
		  <xsl:text>' has </xsl:text>
		  <xsl:value-of select="count(preceding-sibling::*[@value=$enumerationValue])+1"/>
		  <xsl:text> definitions</xsl:text>
		 </xsl:message> 
	</xsl:if>
	<xsl:if test="not(//xs:attribute[@name=$enumerationValue])">
		<xsl:message>
		  <xsl:text>[Warning] accessType enumeration '</xsl:text>
		  <xsl:value-of select="$enumerationValue"/>
		  <xsl:text>' has no corresponding attribute definition</xsl:text>
		 </xsl:message> 
	</xsl:if>
</xsl:for-each>

<!-- check for missing accessType definitions -->
<xsl:for-each select="//xs:attribute[not(@name='DEF' or @name='USE' or @name='containerField' or @name='class'  
		or @name='AS' or @name='http-equiv' or @name='lang' or @name='profile'  
		or @name='nodeField'  or @name='protoField' 
		or @name='InlineDEF' or @name='importedDEF' or @name='localDEF'
		or @name='fromNode' or @name='fromField' and @name='toNode' or @name='toField')]">
 <xsl:variable name="attributeName"><xsl:value-of select="@name"/></xsl:variable>
 <xsl:variable name="elementName">
	 <xsl:choose>
			<xsl:when test="../../../../@name">
				<xsl:value-of select="../../../../@name"/>
			</xsl:when>
			<xsl:when test="parent::*[@name!='']">
				<xsl:value-of select="parent::*[@name!='']/@name"/>
				<!--<xsl:message><xsl:text>[found parent name] </xsl:text></xsl:message>-->
			</xsl:when>
			<xsl:otherwise><xsl:text>NoNameFound</xsl:text></xsl:otherwise>
	</xsl:choose>
 </xsl:variable>
 <!--  -->
 <xsl:choose>
	<xsl:when test="local-name(..)='appinfo'">
		<!-- ignore, documentation --> 
	</xsl:when>
	<xsl:when test="($elementName='component') or ($elementName='field') or ($elementName='meta') or ($elementName='ExternProtoDeclare') or ($elementName='ProtoDeclare') or ($elementName='ROUTE')">
		<!-- ignore, scene graph structural elements (not actual nodes) --> 
	</xsl:when>
	<!-- incidentally ensure UrlNodes are on X3DNetworkSensorNode list -->
	<xsl:when test="($attributeName='url') and ($elementName!='X3DUrlObject') and not(//xs:complexType[@name='X3DNetworkSensorNode']//xs:element[@ref=$elementName])">
		<xsl:message>
		  <xsl:text>[Error] </xsl:text>
		  <xsl:value-of select="$elementName"/>
		  <xsl:text> has attribute '</xsl:text>
		  <xsl:value-of select="$attributeName"/>
		  <xsl:text>' needs to be referenced by X3DNetworkSensorNode</xsl:text>
		 </xsl:message> 
		<!-- also should look for UrlObject -->
	</xsl:when>
	<xsl:when test="contains(attributeName,'otherInterfaces')">
		<xsl:message>
		  <xsl:text>[Error] </xsl:text>
		  <xsl:value-of select="$elementName"/>
		  <xsl:text> attribute '</xsl:text>
		  <xsl:value-of select="$attributeName"/>
		  <xsl:text>' needs to be defined within appinfo, not as a regular attribute</xsl:text>
		 </xsl:message> 
	</xsl:when>
	<xsl:when test="not(//xs:enumeration[@value=$attributeName]) and not(preceding-sibling::*[@name=$attributeName])">
		<xsl:message>
		  <xsl:text>[Warning] </xsl:text>
		  <xsl:value-of select="$elementName"/>
		  <xsl:text> attribute '</xsl:text>
		  <xsl:value-of select="$attributeName"/>
		  <xsl:text>' has no corresponding accessType enumeration defined</xsl:text>
		 </xsl:message> 
	</xsl:when>
	<!-- corresponding accessType has been found -->
	<xsl:otherwise>
		<xsl:variable name="accessType" select="substring-before(//xs:simpleType[xs:restriction/xs:enumeration/@value=$attributeName]/@name,'AccessTypes')"/>
		<xsl:choose>
			<xsl:when test="not(starts-with(@type,'SF') or starts-with(@type,'MF'))">
				<!-- skip derived types -->
			</xsl:when>
			<xsl:when test="(@type='SFNode' or @type='MFNode') and (@default!='')">
					<xsl:message>
					  <xsl:text>[Error] </xsl:text>
					  <xsl:value-of select="$elementName"/>
					  <xsl:text> attribute '</xsl:text>
					  <xsl:value-of select="$attributeName"/>
					  <xsl:text>' has accessType </xsl:text>
					  <xsl:value-of select="$accessType"/>
					  <xsl:text>, type </xsl:text>
					  <xsl:value-of select="@type"/>
					  <xsl:text> with initializing value </xsl:text>
					  <xsl:value-of select="@default"/>
				</xsl:message> 
			</xsl:when>
			<xsl:when test="(@type='SFNode' or @type='MFNode')">
				<!-- no value is correct, no action -->
			</xsl:when>
			<xsl:when test="($accessType='inputOnly' or $accessType='outputOnly') and (@default!='')">
					<xsl:message>
					  <xsl:text>[Error] </xsl:text>
					  <xsl:value-of select="$elementName"/>
					  <xsl:text> attribute '</xsl:text>
					  <xsl:value-of select="$attributeName"/>
					  <xsl:text>' has accessType </xsl:text>
					  <xsl:value-of select="$accessType"/>
					  <xsl:text>, type </xsl:text>
					  <xsl:value-of select="@type"/>
					  <xsl:text> and initializing value</xsl:text>
					  <xsl:value-of select="@default"/>
				</xsl:message> 
			</xsl:when>
			<xsl:when test="($accessType='inputOnly' or $accessType='outputOnly')">
				<!-- no value is correct, no action -->
			</xsl:when>
			<xsl:when test="(@type='SFString')">
				<!-- SFString can be null -->
			</xsl:when>
			<xsl:when test="($accessType='initializeOnly' or $accessType='inputOutput') and starts-with(@type,'MF')">
				<!-- no value is allowed for MF types, no action -->
			</xsl:when>
			<xsl:when test="($accessType='initializeOnly' or $accessType='inputOutput') and not(@default)">
					<xsl:message>
					  <xsl:text>[Error] </xsl:text>
					  <xsl:value-of select="$elementName"/>
					  <xsl:text> attribute '</xsl:text>
					  <xsl:value-of select="$attributeName"/>
					  <xsl:text>' has accessType </xsl:text>
					  <xsl:value-of select="$accessType"/>
					  <xsl:text>, type </xsl:text>
					  <xsl:value-of select="@type"/>
					  <xsl:text> and no initializing value</xsl:text>
				</xsl:message> 
			</xsl:when>
		</xsl:choose>
	</xsl:otherwise>
 </xsl:choose>
</xsl:for-each>

<!-- <xsl:message><xsl:text>$LinkDom=</xsl:text><xsl:value-of select="$LinkDom"/><xsl:text>&#10;</xsl:text></xsl:message> -->

  <xsl:variable name="nameX3dEncodingsFile">
    <xsl:text>EncodingOfNodes.html</xsl:text>
  </xsl:variable>
    <!--<xsl:text>part03/EncodingOfNodes.html</xsl:text>-->
  <xsl:variable name="nameUtf8EncodingsFile">
    <xsl:text>part04/Utf8Encodings.html</xsl:text>
  </xsl:variable>
<xsl:document href="{$nameX3dEncodingsFile}" method="html" omit-xml-declaration="yes" encoding="UTF8" indent="yes">
<!-- <xsl:text><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"></xsl:text> -->
<xsl:text>&#10;</xsl:text>

<xsl:element name="html">
  <xsl:attribute name="lang"><xsl:text>en</xsl:text></xsl:attribute>
  <xsl:text>&#10;</xsl:text>
  <xsl:comment> autogenerated field-attribute encodings </xsl:comment>
  <xsl:element name="head">
	<xsl:element name="title">
		<!-- mdash = 8212 -->
		<xsl:text>ISO/IEC 19776-1 &#8212; XML encoding &#8212; 6 Encoding of nodes</xsl:text>
	</xsl:element>
	<xsl:element name="link">
		<xsl:attribute name="rel"><xsl:text>stylesheet</xsl:text></xsl:attribute>
		<xsl:attribute name="href"><xsl:text>../X3DEncodings.css</xsl:text></xsl:attribute>
		<xsl:attribute name="type"><xsl:text>text/css</xsl:text></xsl:attribute>
	</xsl:element>
	<xsl:element name="meta">
		<xsl:attribute name="http-equiv"><xsl:text>Content-Type</xsl:text></xsl:attribute>
		<xsl:attribute name="content"><xsl:text>text/html; charset=utf-8</xsl:text></xsl:attribute>
	</xsl:element>
	<xsl:element name="meta">
		<xsl:attribute name="name"><xsl:text>creator</xsl:text></xsl:attribute>
		<xsl:attribute name="content"><xsl:text>Don Brutzman</xsl:text></xsl:attribute>
	</xsl:element>
	<xsl:element name="meta">
		<xsl:attribute name="name"><xsl:text>generator</xsl:text></xsl:attribute>
		<xsl:attribute name="content"><xsl:text>BuildSpecificationInterfacesFromSchema.xsl</xsl:text></xsl:attribute>
	</xsl:element>
	<xsl:element name="meta">
		<xsl:attribute name="name"><xsl:text>created</xsl:text></xsl:attribute>
		<xsl:attribute name="content">
			<xsl:value-of select="date:day-in-month()"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="date:month-name()"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="date:year()"/>
		</xsl:attribute>
	</xsl:element>
  </xsl:element>
  <xsl:element name="body">
	<xsl:text>&#10;</xsl:text>

	<xsl:element name="div">
		<xsl:attribute name="class"><xsl:text>CenterDiv</xsl:text></xsl:attribute>
		<xsl:element name="img">
			<xsl:attribute name="class"><xsl:text>x3dlogo</xsl:text></xsl:attribute>
			<xsl:attribute name="src"><xsl:text>../Images/x3d.png</xsl:text></xsl:attribute>
			<xsl:attribute name="alt"><xsl:text>X3D logo</xsl:text></xsl:attribute>
			<xsl:attribute name="width"><xsl:text>115</xsl:text></xsl:attribute>
			<xsl:attribute name="height"><xsl:text>106</xsl:text></xsl:attribute>
		</xsl:element>
	</xsl:element>
	<xsl:text>&#10;</xsl:text>

	<xsl:element name="div">
		<xsl:attribute name="class"><xsl:text>CenterDiv</xsl:text></xsl:attribute>
		<xsl:element name="p">
			<xsl:attribute name="class"><xsl:text>HeadingPart</xsl:text></xsl:attribute>
			<xsl:text>Encoding of nodes</xsl:text>
			<xsl:text>&#10;</xsl:text>
			<xsl:element name="br"/>
			<xsl:text>&#10;</xsl:text>
			<xsl:text>Part 1: Extensible Markup Language (XML) encoding</xsl:text>
		</xsl:element>
		<xsl:element name="p">
			<xsl:attribute name="class"><xsl:text>HeadingClause</xsl:text></xsl:attribute>
			<xsl:text>6 Encoding of nodes</xsl:text>
		</xsl:element>
	</xsl:element>
	<xsl:text>&#10;</xsl:text>

	<xsl:element name="img">
		<xsl:attribute name="class"><xsl:text>x3dbar</xsl:text></xsl:attribute>
		<xsl:attribute name="src"><xsl:text>../Images/x3dbar.png</xsl:text></xsl:attribute>
		<xsl:attribute name="alt"><xsl:text>--- X3D separator bar ---</xsl:text></xsl:attribute>
		<xsl:attribute name="width"><xsl:text>430</xsl:text></xsl:attribute>
		<xsl:attribute name="height"><xsl:text>23</xsl:text></xsl:attribute>
	</xsl:element>
	<xsl:text>&#10;</xsl:text>

	<xsl:element name="h1">
		<xsl:element name="img">
			<xsl:attribute name="class"><xsl:text>cube</xsl:text></xsl:attribute>
			<xsl:attribute name="src"><xsl:text>../Images/cube.gif</xsl:text></xsl:attribute>
			<xsl:attribute name="alt"><xsl:text>cube</xsl:text></xsl:attribute>
			<xsl:attribute name="width"><xsl:text>20</xsl:text></xsl:attribute>
			<xsl:attribute name="height"><xsl:text>19</xsl:text></xsl:attribute>
		</xsl:element>
		<xsl:element name="a">
			<xsl:attribute name="name"><xsl:text>h-6.1</xsl:text></xsl:attribute>
			<xsl:text>6.1&#160;&#160;Introduction</xsl:text>
		</xsl:element>
	</xsl:element>
	<xsl:text>&#10;</xsl:text>

	<xsl:element name="p">
		<xsl:text>This clause provides a detailed specification of the XML encoding of each node defined in </xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:text>references.html#[I19775_1]</xsl:text></xsl:attribute>
			<xsl:text>ISO/IEC&#160;19775-1</xsl:text>
		</xsl:element>
		<xsl:text>.</xsl:text>
		<xsl:text>&#10;</xsl:text>

		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:text>#T-6.1</xsl:text></xsl:attribute>
			<xsl:text>Table&#160;6.1</xsl:text>
		</xsl:element>
		<xsl:text> lists the topics in this clause.</xsl:text>
	</xsl:element>
	
	<xsl:element name="p">
		<xsl:text>Content models indicate the node elements that can be contained by other node elements.</xsl:text>
	</xsl:element>
	<xsl:text>&#10;</xsl:text>
	
	<xsl:element name="p">
		<xsl:text>This XML encoding is autogenerated using the </xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>XML Schema for the Extensible 3D (X3D) Graphics Specification tagset defined in </xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:element name="a">
			<xsl:attribute name="href"><xsl:text>Schema.html</xsl:text></xsl:attribute>
			<xsl:attribute name="target">_source</xsl:attribute>
			<xsl:text>Annex&#160;B&#160;X3D&#160;XML&#160;Schema</xsl:text>
		</xsl:element>
		<xsl:text>.</xsl:text>
	<!--	<xsl:text> version </xsl:text>
		<xsl:value-of select="xs:schema/@version"/>
		<xsl:text>.  </xsl:text> -->
	</xsl:element>
	<xsl:text>&#10;</xsl:text>
	
	<xsl:element name="p">
		<xsl:text>Notational conventions for this section are as follows.
		</xsl:text>
	</xsl:element>
	<xsl:text>&#10;</xsl:text>
	
		<xsl:element name="ol">
			<xsl:attribute name="type"><xsl:text>a</xsl:text></xsl:attribute>
			<xsl:element name="li">	Each node name is followed by a list of fields (if any). </xsl:element>
			<xsl:element name="li">	Each field attribute name is followed by default&#160;value (if any), type and accessType. </xsl:element>
			<xsl:element name="li">	After field attributes, contained node content (if any) is listed. </xsl:element>
			<xsl:element name="li">	Singleton tags or open/close tag pairs are used to complete each element, as appropriate. </xsl:element>
		</xsl:element>
	<xsl:text>&#10;</xsl:text>

	<xsl:element name="p">	Fields with accessType inputOnly or outputOnly are transient, and thus must not be written out in an .x3d file. </xsl:element>
	<xsl:text>&#10;</xsl:text>
	
	<xsl:element name="p">	Note that type and accessType designations for each node are solely informational, and are not part of the valid XML encoding for an X3D scene. </xsl:element>
	<xsl:text>&#10;</xsl:text>
	
	<xsl:element name="p">	
			<a href="#ChildContentModeCore">ChildContentModeCore</a> is implicit throughout.
			It enables the first child of any node to be MetadataDouble, MetadataFloat, MetadataInteger, MetadataSet or MetadataString. 
	</xsl:element>
	<xsl:text>&#10;</xsl:text>
	
	<xsl:element name="div">
		<xsl:attribute name="class"><xsl:text>CenterDiv</xsl:text></xsl:attribute>
		<xsl:element name="p">
			<xsl:attribute name="class"><xsl:text>TableCaption</xsl:text></xsl:attribute>
			<xsl:element name="a">
				<xsl:attribute name="name"><xsl:text>T-6.1</xsl:text></xsl:attribute>
				<!-- mdash = 8212 -->
				<xsl:text disable-output-escaping="yes">Table 6.1 &amp;mdash; Table of contents</xsl:text>
			</xsl:element>
		</xsl:element>
		<xsl:text>&#10;</xsl:text>

		<!-- Loop over elements, build index -->
		
		<xsl:element name="table">
			<xsl:attribute name="class"><xsl:text>topics</xsl:text></xsl:attribute>
			<xsl:attribute name="align"><xsl:text>center</xsl:text></xsl:attribute>
			<xsl:attribute name="border"><xsl:text>1</xsl:text></xsl:attribute>
			<xsl:attribute name="summary"><xsl:text>Table of contents</xsl:text></xsl:attribute>
			<xsl:text>&#10;</xsl:text>
			<xsl:element name="tr">
				<xsl:attribute name="align"><xsl:text>left</xsl:text></xsl:attribute>
				<xsl:text>&#10;</xsl:text>
				<xsl:element name="td">
				<!--	<xsl:attribute name="rowspan"><xsl:text>25</xsl:text></xsl:attribute> -->
					<xsl:attribute name="width"><xsl:text>25%</xsl:text></xsl:attribute>
					<xsl:attribute name="valign"><xsl:text>top</xsl:text></xsl:attribute>
					<xsl:element name="a">
						<xsl:attribute name="href"><xsl:text>#h-6.1</xsl:text></xsl:attribute>
						<xsl:text>6.1&#160;Introduction</xsl:text>
					</xsl:element>
					<xsl:element name="br"/>
					<xsl:element name="a">
						<xsl:attribute name="href"><xsl:text>#h-6.2</xsl:text></xsl:attribute>
						<xsl:text>6.2&#160;Nodes</xsl:text>
					</xsl:element>
					<xsl:element name="br"/>
				
					<xsl:for-each select="//xs:schema/xs:element[not (@name='ProtoDeclare' or @name='ProtoInterface' or @name='ProtoBody' or @name='ExternProtoDeclare' or @name='component' or @name='head' or @name='meta' or @name='IS' or @name='connect' or @name='IMPORT' or @name='EXPORT' or @name='ROUTE' or @name='Scene' or @name='X3D'
							 or @name='inputCoord' or @name='outputCoord' or @name='inputTransform' or @name='rootNodeType' or @name='humanoidBodyType')]">
						<xsl:sort select="@name"/>
					<!--	<xsl:text>&#10;</xsl:text> -->
						<!-- html bookmarks -->
						<xsl:text>&#160;&#160;</xsl:text>
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:text>#</xsl:text>
								<xsl:value-of select="@name"/>
							</xsl:attribute>
							<xsl:text>6.2.</xsl:text>
							<xsl:value-of select="position()"/>
							<xsl:text>&#160;</xsl:text>
							<xsl:value-of select="@name"/>
						</xsl:element>
						<xsl:text> </xsl:text>
						<xsl:element name="br"/>
						<xsl:text>&#10;</xsl:text>
						<!-- three-column index, the following numbers decide column breaks -->
						<xsl:if test="((position()=56) or (position()=114))">
							<xsl:text>&#10;</xsl:text>
							<xsl:text disable-output-escaping="yes"><![CDATA[</td>]]></xsl:text>
							<xsl:text>&#10;</xsl:text>
							<xsl:text disable-output-escaping="yes"><![CDATA[<td valign="top" width="25%">]]></xsl:text>
							<xsl:text>&#10;</xsl:text>
						</xsl:if>
					</xsl:for-each>
					
					<xsl:element name="a">
						<xsl:attribute name="href"><xsl:text>#h-6.3</xsl:text></xsl:attribute>
						<xsl:text>6.3&#160;Content models</xsl:text>
					</xsl:element>
					<xsl:element name="br"/>
					<xsl:text>&#10;</xsl:text>
					
					<xsl:text>&#160;&#160;</xsl:text>
					<xsl:element name="a">
						<xsl:attribute name="href"><xsl:text>#h-6.3.1</xsl:text></xsl:attribute>
						<xsl:text>6.3.1&#160;Overview</xsl:text>
					</xsl:element>
					<xsl:element name="br"/>
					<xsl:text>&#10;</xsl:text>
	
					<!-- now append index entries for the pertinent content models -->
					<xsl:for-each select="//xs:schema/xs:group[@name=//xs:schema/xs:element[not(@name='ProtoDeclare' or @name='ProtoInterface' or @name='ProtoBody' or @name='ExternProtoDeclare' or @name='component' or @name='head' or @name='meta' or @name='IS' or @name='connect' or @name='IMPORT' or @name='EXPORT' or @name='ROUTE' or @name='Scene' or @name='X3D'
							 		or @name='inputCoord' or @name='outputCoord' or @name='inputTransform' or @name='rootNodeType' or @name='humanoidBodyType')]//xs:group/@ref
							 	or @name=//xs:schema/xs:complexType//xs:group/@ref]">
						<xsl:sort select="@name"/>
						
						<xsl:variable name="contentModelGroupName">
							<xsl:value-of select="@name"/>
						</xsl:variable>
					<!--	debug
						<xsl:text>$contentModelGroupName=</xsl:text>
						<xsl:value-of select="$contentModelGroupName"/> -->
						<!-- html bookmarks -->
						<xsl:text>&#160;&#160;</xsl:text>
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:text>#</xsl:text>
								<xsl:value-of select="$contentModelGroupName"/>
							</xsl:attribute>
							<xsl:text>6.3.</xsl:text>
							<xsl:value-of select="position()+1"/>
							<xsl:text>&#160;</xsl:text>
							<xsl:value-of select="$contentModelGroupName"/>
						</xsl:element>
						<xsl:element name="br"/>
						<xsl:text>&#10;</xsl:text>
					</xsl:for-each>
				</xsl:element>
				<xsl:text>&#10;</xsl:text>
			</xsl:element>
			<xsl:text>&#10;</xsl:text>
		</xsl:element> <!-- table -->
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>

	</xsl:element>  <!-- div CenterDiv -->
	<xsl:text>&#10;</xsl:text>
	<xsl:text>&#10;</xsl:text>

	<xsl:element name="h1">
		<xsl:element name="img">
			<xsl:attribute name="class"><xsl:text>cube</xsl:text></xsl:attribute>
			<xsl:attribute name="src"><xsl:text>../Images/cube.gif</xsl:text></xsl:attribute>
			<xsl:attribute name="alt"><xsl:text>cube</xsl:text></xsl:attribute>
			<xsl:attribute name="width"><xsl:text>20</xsl:text></xsl:attribute>
			<xsl:attribute name="height"><xsl:text>19</xsl:text></xsl:attribute>
		</xsl:element>
		<xsl:element name="a">
			<xsl:attribute name="name"><xsl:text>h-6.2</xsl:text></xsl:attribute>
			<xsl:text>6.2&#160;&#160;Nodes</xsl:text>
		</xsl:element>
	</xsl:element>
	<xsl:text>&#10;</xsl:text>

	<!-- Loop over elements, for each detailed page entry -->
	<xsl:for-each select="//xs:schema/xs:element[not (@name='ProtoDeclare' or @name='ProtoInterface' or @name='ProtoBody' or @name='ExternProtoDeclare' or @name='component' or @name='head' or @name='meta' or @name='IS' or @name='connect' or @name='IMPORT' or @name='EXPORT' or @name='ROUTE' or @name='Scene' or @name='X3D'
				 or @name='inputCoord' or @name='outputCoord' or @name='inputTransform' or @name='rootNodeType' or @name='humanoidBodyType')]">  <!-- these wrappers need removal... -->
		<xsl:sort select="@name"/>
		<xsl:variable name="nodeName" select="@name"/>
		<xsl:variable name="nodeType">
			<xsl:value-of select="xs:complexType/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/@base"/>
		</xsl:variable>
		<xsl:variable name="parentNodeType">
			<xsl:value-of select="//xs:schema/xs:complexType[@name=$nodeType]/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/@base"/>
		</xsl:variable>
		<xsl:variable name="grandParentNodeType">
			<xsl:value-of select="//xs:schema/xs:complexType[@name=$parentNodeType]/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/@base"/>
		</xsl:variable>
		<xsl:variable name="greatGrandParentNodeType">
			<xsl:value-of select="//xs:schema/xs:complexType[@name=$grandParentNodeType]/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/@base"/>
		</xsl:variable>
		<xsl:variable name="greatGreatGrandParentNodeType">
			<xsl:value-of select="//xs:schema/xs:complexType[@name=$greatGrandParentNodeType]/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/@base"/>
		</xsl:variable>
		<xsl:variable name="attributeNodeList" select="
			       //xs:schema/xs:complexType[@name=$greatGreatGrandParentNodeType]/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/xs:attribute
			    | //xs:schema/xs:complexType[@name=$greatGrandParentNodeType]/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/xs:attribute
			    | //xs:schema/xs:complexType[@name=$grandParentNodeType]/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/xs:attribute
			    | //xs:schema/xs:complexType[@name=$parentNodeType]/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/xs:attribute
			    | //xs:schema/xs:complexType[@name=$nodeType]/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/xs:attribute
			    | //xs:schema/xs:complexType[@name=$greatGreatGrandParentNodeType]/xs:attribute
			    | //xs:schema/xs:complexType[@name=$greatGrandParentNodeType]/xs:attribute
			    | //xs:schema/xs:complexType[@name=$grandParentNodeType]/xs:attribute
			    | //xs:schema/xs:complexType[@name=$parentNodeType]/xs:attribute
			    | //xs:schema/xs:complexType[@name=$nodeType]/xs:attribute
			    | xs:complexType/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/xs:attribute">
		</xsl:variable>
		<xsl:variable name="elementNodeList" select="
			       //xs:schema/xs:complexType[@name=$greatGreatGrandParentNodeType]//xs:element[@ref!='IS']
			    | //xs:schema/xs:complexType[@name=$greatGrandParentNodeType]//xs:element[@ref!='IS']
			    | //xs:schema/xs:complexType[@name=$grandParentNodeType]//xs:element[@ref!='IS']
			    | //xs:schema/xs:complexType[@name=$parentNodeType]//xs:element[@ref!='IS']
			    | //xs:schema/xs:complexType[@name=$nodeType]//xs:element[@ref!='IS']">
		</xsl:variable>
		<xsl:variable name="extensionName" select="*//xs:extension/@base"/>
		<xsl:variable name="restrictionName" select="*//xs:restriction/@base"/>
		<xsl:variable name="contentModelGroupName">
			<xsl:choose>
				<xsl:when test="*//xs:group">
					<xsl:value-of select="*//xs:group/@ref"/>
				<!--	<xsl:message>
						<xsl:value-of select="$nodeName"/>
						<xsl:text> matched content model </xsl:text>
						<xsl:value-of select="*//xs:group/@ref"/>
					</xsl:message> -->
				</xsl:when>
				<xsl:when test="$extensionName and (//xs:complexType[@name=$extensionName]//xs:group/@ref)">
					<xsl:value-of select="//xs:complexType[@name=$extensionName]//xs:group/@ref"/>
				<!--	<xsl:message>
						<xsl:value-of select="$nodeName"/>
						<xsl:text> found extension </xsl:text>
						<xsl:value-of select="$extensionName"/>
						<xsl:text>, matched complexType </xsl:text>
						<xsl:value-of select="//xs:complexType[@name=$extensionName]/@name"/>
						<xsl:text>, matched content model </xsl:text>
						<xsl:value-of select="//xs:complexType[@name=$extensionName]//xs:group/@ref"/>
					</xsl:message> -->
				</xsl:when>
				<xsl:when test="$restrictionName and (//xs:complexType[@name=$restrictionName]//xs:group/@ref)">
					<xsl:value-of select="//xs:complexType[@name=$restrictionName]//xs:group/@ref"/>
				<!--	<xsl:message>
						<xsl:value-of select="$nodeName"/>
						<xsl:text> found restriction </xsl:text>
						<xsl:value-of select="$restrictionName"/>
						<xsl:text>, matched complexType </xsl:text>
						<xsl:value-of select="//xs:complexType[@name=$restrictionName]/@name"/>
						<xsl:text>, matched content model </xsl:text>
						<xsl:value-of select="//xs:complexType[@name=$restrictionName]//xs:group/@ref"/> 
					</xsl:message> -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//xs:complexType[@name=$nodeType]/xs:complexContent/xs:extension/xs:group/@ref"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="containerFieldFound">
			<xsl:call-template name="includes-containerField">
				<xsl:with-param name="inputAttributeNodeList" select="$attributeNodeList"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:if test="($containerFieldFound='false' and nodeName!='field' and nodeName!='fieldValue')">
					<xsl:message>
						<xsl:text>[Error] </xsl:text>
						<xsl:value-of select="$nodeName"/>
						<xsl:text> containerField definition not found</xsl:text>
					</xsl:message>
		</xsl:if>

		<xsl:element name="h2">
			<!-- html bookmark for node -->
			<xsl:element name="a">
				<xsl:attribute name="name">
					<xsl:value-of select="@name"/>
				</xsl:attribute>
				<!-- paragraph number -->
					<xsl:element name="b">
					<xsl:text>6.2.</xsl:text>
					<xsl:value-of select="position()"/>
					<xsl:text>&#160;&#160;</xsl:text>
					<xsl:value-of select="@name"/>
				</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:text>&#10;</xsl:text>

		<xsl:element name="div">
			<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>
	
			<!-- main table of node characteristics -->
			<xsl:element name="table">
				<xsl:attribute name="summary">
					<xsl:value-of select="@name"/>
					<xsl:text> node characteristics</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>
			<!--	<xsl:attribute name="width"><xsl:text>100%</xsl:text></xsl:attribute> -->
			<!--	<xsl:attribute name="align"><xsl:text>center</xsl:text></xsl:attribute> -->
			<!--	<xsl:attribute name="border"><xsl:text>0</xsl:text></xsl:attribute>  -->
	
		<!-- header, no longer included.  if test not filtering properly.
			<xsl:element name="tr">
				<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>
				<xsl:element name="th">
					<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>
					<xsl:text>Node, attributes, fields, default&#160;values</xsl:text>
					<xsl:if test="//xs:schema/xs:group[@name=//xs:schema/xs:element[not (@name='ProtoDeclare' or @name='ProtoInterface' or @name='ProtoBody' or @name='ExternProtoDeclare' or @name='component' or @name='head' or @name='meta' or @name='IS' or @name='connect' or @name='IMPORT' or @name='EXPORT' or @name='ROUTE' or @name='Scene' or @name='X3D'
							 		or @name='inputCoord' or @name='outputCoord' or @name='inputTransform' or @name='rootNodeType' or @name='humanoidBodyType')]//xs:group/@ref
							 	or xs:attribute/@name=//xs:schema/xs:complexType//xs:group/@ref]">
						<xsl:text>, content&#160;model</xsl:text>
					</xsl:if>
				</xsl:element>
				<xsl:element name="th">
					<xsl:text>Type</xsl:text>
				</xsl:element>
				<xsl:element name="th">
					<xsl:text>Access type</xsl:text>
				</xsl:element>
				<xsl:element name="th">
					<xsl:text>Derives from</xsl:text>
				</xsl:element>
			</xsl:element>
	 	-->
	 		
			<!-- second  row:  element (node) name -->
			<xsl:element name="tr">
				<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>	
				<!-- first column:  node name -->
				<xsl:element name="td">
					<xsl:attribute name="class"><xsl:text>node1</xsl:text></xsl:attribute>
					<xsl:attribute name="valign"><xsl:text>top</xsl:text></xsl:attribute> <!-- -->
					<xsl:element name="b">
						<xsl:text>&lt;</xsl:text>
						<xsl:value-of select="@name"/>
					</xsl:element>
				</xsl:element>
				<!-- 2 empty columns in node row -->
				<xsl:element name="td">
					<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>
					<xsl:attribute name="valign"><xsl:text>top</xsl:text></xsl:attribute> <!-- -->
					<xsl:text>&#160;</xsl:text>
				</xsl:element>
				<xsl:element name="td">
					<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>
					<xsl:attribute name="valign"><xsl:text>top</xsl:text></xsl:attribute> <!-- -->
					<xsl:text>&#160;</xsl:text>
				</xsl:element>
			<!-- node type(s) not used in final spec version
				<xsl:element name="td">
					<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>
					<xsl:if test="$nodeType!=''">
						<xsl:text> : </xsl:text>
						<xsl:value-of select="$nodeType"/>
					</xsl:if>
					<xsl:if test="//xs:schema/xs:complexType[@name=$nodeType]
							and $nodeType!='X3dNode'
							and $parentNodeType!=''">
						<xsl:text> : </xsl:text>
						<xsl:value-of select="$parentNodeType"/>
					</xsl:if>
					<xsl:if test="//xs:schema/xs:complexType[@name=$parentNodeType]
							and $nodeType!='X3dNode'
							and $parentNodeType!='X3dNode'
							and $grandParentNodeType!=''">
						<xsl:text> : </xsl:text>
						<xsl:value-of select="$grandParentNodeType"/>
					</xsl:if>
					<xsl:if test="//xs:schema/xs:complexType[@name=$grandParentNodeType]
							and $nodeType!='X3dNode'
							and $parentNodeType!='X3dNode'
							and $grandParentNodeType!='X3dNode'
							and $greatGrandParentNodeType!=''">
						<xsl:text> : </xsl:text>
						<xsl:value-of select="$greatGrandParentNodeType"/>
					</xsl:if>
					<xsl:if test="//xs:schema/xs:complexType[@name=$greatGrandParentNodeType]
							and $nodeType!='X3dNode'
							and $parentNodeType!='X3dNode'
							and $grandParentNodeType!='X3dNode'
							and $greatGrandParentNodeType!='X3dNode'
							and $greatGreatGrandParentNodeType!=''">
						<xsl:text> : </xsl:text>
						<xsl:value-of select="$greatGreatGrandParentNodeType"/>
					</xsl:if>
					<xsl:if test="xs:complexType/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/xs:attribute[@name='otherInterfaces']">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="xs:complexType/xs:complexContent/*[(local-name()='extension') or (local-name()='restriction')]/xs:attribute[@name='otherInterfaces']/@fixed"/>
					</xsl:if>
				</xsl:element>
			-->
			</xsl:element>
			
			<!-- third row:  detailed attributes -->
			<xsl:element name="tr">
				<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>
				<!-- first column:  copyable attribute names, defaults -->
				<xsl:element name="td">
					<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>
					<xsl:attribute name="valign"><xsl:text>top</xsl:text></xsl:attribute> <!---->
				<xsl:element name="div">
					<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>
				<!--	<xsl:attribute name="style"><xsl:text>padding-left:25</xsl:text></xsl:attribute> -->
					<xsl:text>DEF=""</xsl:text>
					<xsl:element name="br"/>
					<xsl:text>&#10;</xsl:text>
					<xsl:text>USE=""</xsl:text>
					<!-- Loop over attributes -->
					<xsl:for-each select="$attributeNodeList">
					  <xsl:sort select="@name[. ='class']"/>
					  <xsl:sort select="@name[. ='containerField']"/>
					  <xsl:sort select="@name[.!='containerField' and .!='class']"/>
						<xsl:if test="not(starts-with(@name,'otherInterfaces'))"> 
					<!--	<xsl:if test="not(@name='otherInterfaces') and not(@name='isActive') and not(@name='isOver') and not(@name='isFilled') and not(@name='isLoaded') and not(@name='loadTime') and not(@name='Progress') and not(starts-with (@name,'set_')) and not(contains (@name,'_changed'))"> -->
							<xsl:element name="br"/>
							<xsl:text>&#10;</xsl:text>
							<xsl:value-of select="@name"/>
							<xsl:text>="</xsl:text>
							<!-- default xor fixed value -->
							<xsl:choose>
								<xsl:when test="@name='DEF' or @name='USE'">
							    		<!-- no output, DEF/USE handled above, don't care here about default or fixed -->
								</xsl:when>
								<xsl:when test="@default">
									<xsl:value-of select="@default"/>
								</xsl:when>
								<xsl:when test="@fixed">
							 		<xsl:value-of select="@fixed"/>
								</xsl:when>
							</xsl:choose>
							<xsl:text>"</xsl:text>
							<xsl:text>&#160;</xsl:text>
						</xsl:if>
					</xsl:for-each>
					<!-- no line break here, to maintain page spacing -->
					<!--	debug
					<xsl:value-of select="local-name()"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="@name"/>
					<xsl:text> nodeType=</xsl:text>
					<xsl:value-of select="$nodeType"/> -->
					<xsl:text>&#10;</xsl:text>
					<xsl:element name="br"/><!-- dick's break -->	
					<xsl:text>&#10;</xsl:text>
					<!-- properly finish opening tag before content model (if any) -->
					<xsl:choose>
						<xsl:when test="(starts-with($nodeType,'X3D') and contains($nodeType,'Node') and 
								not($nodeType='X3DNode') and
								$contentModelGroupName!='') or (//xs:element[@name=$nodeName]//xs:element[@ref!='IS'])">
							<xsl:element name="b">
								<xsl:text>&gt;</xsl:text>
							</xsl:element>
							<xsl:text>&#10;</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="b">
								<xsl:text>/&gt;</xsl:text>
							</xsl:element>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>&#10;</xsl:text>
				</xsl:element> <!-- end div, style padding-left -->
				<xsl:text>&#10;</xsl:text>
				
					<!-- show content model:  contained node definitions -->
					<xsl:for-each select="*//xs:element[@ref!='IS']">
						<xsl:variable name="contentModelElementName" select="@ref"/>
						<!-- avoid repeats -->
						<xsl:if test="position()=1 or not(preceding-sibling::*/@ref=$contentModelElementName)">
							<!-- html bookmarks -->
							<xsl:text>&#160;&#160;&#160;&lt;</xsl:text>
							<xsl:element name="a">
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text>
									<xsl:value-of select="$contentModelElementName"/>
								</xsl:attribute>
								<xsl:value-of select="$contentModelElementName"/>
							</xsl:element>
							<xsl:text>&#160;/&gt;</xsl:text>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="br"/>
							<xsl:text>&#10;</xsl:text>
						</xsl:if>
					</xsl:for-each>
					<!-- show content model:  node type -->
					<xsl:if test="starts-with($nodeType,'X3D') and contains($nodeType,'Node') and
							not($nodeType='X3DNode') and
							$contentModelGroupName!='' and $contentModelGroupName!='ChildContentModeCore' ">
						<xsl:text>&#160;&#160;&#160;&lt;!--&#160;</xsl:text>
						<!-- html bookmarks -->
						<xsl:element name="a">
							<xsl:attribute name="href">
								<xsl:text>#</xsl:text>
								<xsl:value-of select="$contentModelGroupName"/>
							</xsl:attribute>
							<xsl:value-of select="$contentModelGroupName"/>
						</xsl:element>
						<xsl:text>&#160;--&gt;</xsl:text>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="br"/>
						<xsl:text>&#10;</xsl:text>
					</xsl:if>
					<xsl:text>&#10;</xsl:text>
					<!-- show content model:  derived node definitions -->
					<xsl:for-each select="$elementNodeList">
						<xsl:variable name="contentModelElementName" select="@ref"/>
						<!--	<xsl:message>
								<xsl:text>found type-derived </xsl:text>
								<xsl:value-of select="local-name()"/>
								<xsl:text> contentModelElementName=</xsl:text>
								<xsl:value-of select="$contentModelElementName"/>
							</xsl:message>
						-->
						<!-- avoid repeats -->
						<xsl:if test="(position()=1 or not(preceding-sibling::*/@name=$contentModelElementName))">
							<!-- html bookmarks -->
							<xsl:text>&#160;&#160;&#160;&lt;</xsl:text>
							<xsl:element name="a">
								<xsl:attribute name="href">
									<xsl:text>#</xsl:text>
									<xsl:value-of select="$contentModelElementName"/>
								</xsl:attribute>
								<xsl:value-of select="$contentModelElementName"/>
							</xsl:element>
							<xsl:text>&#160;/&gt;</xsl:text>
							<xsl:text>&#10;</xsl:text>
							<xsl:element name="br"/>
							<xsl:text>&#10;</xsl:text>
						</xsl:if>
					</xsl:for-each>
					<!-- special cases -->
					<xsl:if test="@name='Collision'">
						<xsl:text>&#10;</xsl:text>
						<xsl:text>&#160;&#160;&#160;&lt;!--&#160;Collision can also have a single X3DChildNode with containerField='proxy'&#160;--&gt;</xsl:text>
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="br"/>
						<xsl:text>&#10;</xsl:text>
					</xsl:if>
					<xsl:if test="@name='Script'">
						<xsl:text>&#10;</xsl:text>
						<xsl:element name="br"/>
						<xsl:text>&#10;</xsl:text>
						<xsl:text>&lt;![CDATA[</xsl:text>
						<xsl:element name="br"/>
						<xsl:text>&#10;ecmascript:&#10;</xsl:text>
						<xsl:element name="br"/>
						<xsl:text>&#10;// contained code here&#10;</xsl:text>
						<xsl:element name="br"/>
						<xsl:text>&#10;]]&gt;&#10;</xsl:text>
						<xsl:element name="br"/>
						<xsl:text>&#10;</xsl:text>
					</xsl:if>
					
					<!-- closing element -->
					<xsl:if test="(starts-with($nodeType,'X3D') and contains($nodeType,'Node') and
								not($nodeType='X3DNode') and
								$contentModelGroupName!='') or (//xs:element[@name=$nodeName]//xs:element[@ref!='IS'])">
						<xsl:element name="b">
							<xsl:text>&lt;/</xsl:text>
							<xsl:value-of select="@name"/>
							<xsl:text>&gt;</xsl:text>
						</xsl:element>
						<xsl:text>&#10;</xsl:text>
					</xsl:if>
				<xsl:text>&#10;</xsl:text>
				</xsl:element>
				<xsl:text>&#10;</xsl:text>
				
				<!--  second column: field (attribute) types -->
				<xsl:element name="td">
					<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>
					<xsl:attribute name="valign"><xsl:text>top</xsl:text></xsl:attribute> <!-- -->
					<xsl:text>&#10;</xsl:text>
					<xsl:text>ID</xsl:text>
					<xsl:element name="br"/>
					<xsl:text>&#10;</xsl:text>
					<xsl:text>IDREF</xsl:text>
					<xsl:element name="br"/>
					<xsl:text>&#10;</xsl:text>
					<xsl:for-each select="$attributeNodeList">
					  <xsl:sort select="@name[. ='class']"/>
					  <xsl:sort select="@name[. ='containerField']"/>
					  <xsl:sort select="@name[.!='containerField' and .!='class']"/>
						<xsl:if test="not(starts-with(@name,'otherInterfaces'))"> 
					<!--	<xsl:if test="not(@name='otherInterfaces') and not(@name='isActive') and not(@name='isOver') and not(@name='isFilled') and not(@name='isLoaded') and not(@name='loadTime') and not(@name='Progress') and not(starts-with (@name,'set_')) and not(contains (@name,'_changed'))"> -->
							<!-- promote schema-constrained types to native X3D types -->
							<xsl:variable name="type" select="@type"/>
							<xsl:variable name="constrainedTypeParent" select="//xs:schema/xs:simpleType[@name=$type]/xs:restriction/@base"/>
							<xsl:variable name="constrainedTypeGrandParent" select="//xs:schema/xs:simpleType[@name=$constrainedTypeParent]/xs:restriction/@base"/>
						<!--	debug
							<xsl:if test="$constrainedTypeParent">
								<xsl:text>@type=</xsl:text>
								<xsl:value-of select="@type"/>
								<xsl:text> $constrainedTypeParent=</xsl:text>
								<xsl:value-of select="$constrainedTypeParent"/>
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:if test="$constrainedTypeGrandParent">
								<xsl:text>$constrainedTypeGrandParent=</xsl:text>
								<xsl:value-of select="$constrainedTypeGrandParent"/>
								<xsl:text> </xsl:text>
							</xsl:if>
						-->
							<xsl:variable name="X3dType">
								<xsl:choose>
									<xsl:when test="starts-with(@type,'SF') or starts-with(@type,'MF')">
										<xsl:value-of select="@type"/>
									</xsl:when>
									<xsl:when test="starts-with(xs:simpleType/xs:restriction/@base,'SF') or starts-with(xs:simpleType/xs:restriction/@base,'MF')">
										<xsl:value-of select="xs:simpleType/xs:restriction/@base"/>
									</xsl:when>
									<xsl:when test="starts-with($constrainedTypeParent,'SF') or starts-with($constrainedTypeParent,'MF')">
										<xsl:value-of select="$constrainedTypeParent"/>
									</xsl:when>
									<xsl:when test="$constrainedTypeParent">
										<xsl:choose>
											<xsl:when test="($constrainedTypeParent='xs:token')">
												<xsl:text>SFString</xsl:text>
											</xsl:when>
											<xsl:when test="starts-with($constrainedTypeParent,'xs:')">
												<xsl:value-of select="substring-after($constrainedTypeParent,'xs:')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$constrainedTypeParent"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:when test="$constrainedTypeGrandParent">
										<xsl:choose>
											<xsl:when test="($constrainedTypeGrandParent='xs:token')">
												<xsl:text>SFString</xsl:text>
											</xsl:when>
											<xsl:when test="starts-with($constrainedTypeGrandParent,'xs:')">
												<xsl:value-of select="substring-after($constrainedTypeGrandParent,'xs:')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$constrainedTypeGrandParent"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="starts-with(@type,'xs:')">
												<xsl:value-of select="substring-after(@type,'xs:')"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="@type"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="$X3dType"/>
							<xsl:text>&#160;</xsl:text>
							<xsl:element name="br"/>
							<xsl:text>&#10;</xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:element>
				<!-- third column:  accessType values -->
				<xsl:element name="td">
					<xsl:attribute name="class"><xsl:text>nodes</xsl:text></xsl:attribute>
					<xsl:attribute name="valign"><xsl:text>top</xsl:text></xsl:attribute> <!-- -->
					<!-- skip lines for DEF, USE -->
					<xsl:text>&#10;</xsl:text>
					<xsl:element name="br"/>
					<xsl:element name="br"/>
					<xsl:text>&#10;</xsl:text>
					<xsl:for-each select="$attributeNodeList">
					  <xsl:sort select="@name[. ='class']"/>
					  <xsl:sort select="@name[. ='containerField']"/>
					  <xsl:sort select="@name[.!='containerField' and .!='class']"/>
						<xsl:variable name="attributeName" select="@name"/>
					  	<xsl:choose>
					  		<!-- first ignore non-field attributes -->
					  		<xsl:when test="(@name='DEF' or @name='USE' or @name='containerField')">
								<!-- no action required -->
					  		</xsl:when>
					  		<!-- next ignore non-node elements -->
					  		<xsl:when test="($nodeName='field' or $nodeName='fieldValue')">
								<!-- no action required -->
					  		</xsl:when>
					  		<!-- next handle special case accessTypes -->
					  		<xsl:when test="($nodeName='GeoCoordinate') and ($attributeName='point') or
					  				($nodeName='Extrusion') and ($attributeName='scale')">
								<xsl:text>[initializeOnly]</xsl:text>
					  		</xsl:when>
					  		<xsl:when test="(($nodeName='HAnimDisplacer') and ($attributeName='coordIndex')) or
					  				(($nodeName='GeoOrigin') and ($attributeName='geoSystem')) or
					  				(($nodeName='NurbsPositionInterpolator') and ($attributeName='order')) or
					  				(($nodeName='Viewpoint') and ($attributeName='orientation')) or
					  				(($nodeName='GeoElevationGrid') and ($attributeName='yScale')) or
					  				( contains($nodeName,'Light') and ($attributeName='radius')) or
					  				(($nodeName='ProximitySensor' or $nodeName='VisibilitySensor') and ($attributeName='size'))">
								<xsl:text>[inputOutput]</xsl:text>
					  		</xsl:when>
					  		<!-- four tables of enumerations in X3D schema matches most cases -->
					  		<xsl:when test="//xs:simpleType[@name='inputOnlyAccessTypes']//xs:enumeration[@value=$attributeName]">
								<xsl:text>[inputOnly]</xsl:text>
					  		</xsl:when>
					  		<xsl:when test="//xs:simpleType[@name='outputOnlyAccessTypes']//xs:enumeration[@value=$attributeName]">
								<xsl:text>[outputOnly]</xsl:text>
					  		</xsl:when>
					  		<xsl:when test="//xs:simpleType[@name='inputOutputAccessTypes']//xs:enumeration[@value=$attributeName]">
								<xsl:text>[inputOutput]</xsl:text>
					  		</xsl:when>
					  		<xsl:when test="//xs:simpleType[@name='initializeOnlyAccessTypes']//xs:enumeration[@value=$attributeName]">
								<xsl:text>[initializeOnly]</xsl:text>
					  		</xsl:when>
					  		<xsl:otherwise>
								<xsl:message>
									<xsl:text>[Error] </xsl:text>
									<xsl:value-of select="$nodeName"/>
									<xsl:text> </xsl:text>
									<xsl:value-of select="$attributeName"/>
									<xsl:text> missing accessType information in X3D schema</xsl:text>
								</xsl:message>
					  		</xsl:otherwise>
					  	</xsl:choose>
					  	<xsl:if test="not(starts-with($attributeName,'otherInterfaces'))">
							<xsl:element name="br"/>
							<xsl:text>&#10;</xsl:text>
					  	</xsl:if>
					</xsl:for-each>
				</xsl:element>
				<!-- fourth column:  constraint bounds -->
				<!-- right column:  node types not used in final spec version -->
			<!--	<xsl:element name="td"> -->
			<!--		<xsl:attribute name="valign"><xsl:text>top</xsl:text></xsl:attribute> -->
					<!-- skip lines for DEF, USE -->
			<!--		<xsl:element name="br"/> -->
			<!--		<xsl:element name="br"/> -->
			<!--		<xsl:for-each select="$attributeNodeList"> -->
			<!--		  <xsl:sort select="@name[. ='class']"/> -->
			<!--		  <xsl:sort select="@name[. ='containerField']"/> -->
			<!--		  <xsl:sort select="@name[.!='containerField' and .!='class']"/> -->
			<!--			<xsl:variable name="attributeName" select="@name"/> -->
			<!--		  	<xsl:choose> -->
					  		<!-- multiple interfaces -->
			<!--		  		<xsl:when test="//xs:element[@name=$nodeName]//xs:attribute[@name=$attributeName]/preceding-sibling::*[@name='otherInterfaces']"> -->
			<!--		  			<xsl:text> : </xsl:text> -->
					  			<!-- can we figure out which, if more than one? -->
			<!--		  			<xsl:variable name="otherInterfaces" select="translate(//xs:element[@name=$nodeName]//xs:attribute[@name=$attributeName]/preceding-sibling::*[@name='otherInterfaces']/@fixed,' ',',')"/> -->
			<!--		  			<xsl:choose> -->
			<!--		  				<xsl:when test="not(contains($otherInterfaces,','))"> -->
			<!--		  					<xsl:value-of select="$otherInterfaces"/> -->
			<!--		  				</xsl:when> -->
			<!--		  				<xsl:when test="starts-with($attributeName,'bbox') and contains($otherInterfaces,'X3DBoundedObject')"> -->
			<!--		  					<xsl:text>X3DBoundedObject</xsl:text> -->
			<!--		  				</xsl:when> -->
			<!--		  				<xsl:when test="($attributeName='enabled' or $attributeName='isActive') and contains($otherInterfaces,'X3DEnvironmentalSensorNode')"> -->
			<!--		  					<xsl:text>X3DEnvironmentalSensorNode</xsl:text> -->
			<!--		  				</xsl:when> -->
			<!--		  				<xsl:when test="($attributeName='url') and contains($otherInterfaces,'X3DUrlObject')"> -->
			<!--		  					<xsl:text>X3DUrlObject</xsl:text> -->
			<!--		  				</xsl:when>  -->
			<!--		  				<xsl:otherwise> -->
			<!--		  					<xsl:value-of select="$otherInterfaces"/> -->
			<!--		  				</xsl:otherwise>  -->
			<!--		  			</xsl:choose> -->
			<!--					<xsl:text>&#10;</xsl:text> -->
			<!--		  		</xsl:when> -->
					  		<!-- part of node definition, no separate interface, no output -->
			<!--		  		<xsl:when test="//xs:element[@name=$nodeName]//xs:attribute[@name=$attributeName]"> -->
			<!--		  		</xsl:when> -->
					  		<!-- part of nodeType interface, possibly *parent nodeType interface -->
			<!--		  		<xsl:when test="//xs:schema/xs:complexType[@name=$nodeType]//xs:attribute[@name=$attributeName]"> -->
			<!--		  			<xsl:text> : </xsl:text> -->
			<!--		  			<xsl:value-of select="$nodeType"/> -->
			<!--		  		</xsl:when> -->
			<!--		  		<xsl:when test="//xs:schema/xs:complexType[@name=$parentNodeType]//xs:attribute[@name=$attributeName]"> -->
			<!--		  			<xsl:text> : </xsl:text> -->
			<!--		  			<xsl:value-of select="$parentNodeType"/> -->
			<!--		  		</xsl:when> -->
			<!--		  		<xsl:when test="//xs:schema/xs:complexType[@name=$grandParentNodeType]//xs:attribute[@name=$attributeName]"> -->
			<!--		  			<xsl:text> : </xsl:text> -->
			<!--		  			<xsl:value-of select="$grandParentNodeType"/> -->
			<!--		  		</xsl:when> -->
			<!--		  		<xsl:when test="//xs:schema/xs:complexType[@name=$greatGrandParentNodeType]//xs:attribute[@name=$attributeName]"> -->
			<!--		  			<xsl:text> : </xsl:text> -->
			<!--		  			<xsl:value-of select="$greatGrandParentNodeType"/> -->
			<!--		  		</xsl:when> -->
			<!--		  		<xsl:when test="//xs:schema/xs:complexType[@name=$greatGreatGrandParentNodeType]//xs:attribute[@name=$attributeName]"> -->
			<!--		  			<xsl:text> : </xsl:text> -->
			<!--		  			<xsl:value-of select="$greatGreatGrandParentNodeType"/> -->
			<!--		  		</xsl:when> -->
			<!--		  	</xsl:choose> -->
			<!--		  	<xsl:if test="$attributeName!='otherInterfaces'"> -->
			<!--				<xsl:element name="br"/> -->
			<!--				<xsl:text>&#10;</xsl:text> -->
			<!--		  	</xsl:if> -->
			<!--		</xsl:for-each> -->
					<!-- add derivation information for content model, if any -->				
			<!--		<xsl:choose> -->
			<!--			<xsl:when test="*//xs:group"> -->
							<!-- local -->
			<!--			</xsl:when> -->
			<!--			<xsl:when test="//xs:complexType[@name=$nodeType]/xs:complexContent/xs:extension/xs:group/@ref"> -->
			<!--				<xsl:text> : </xsl:text> -->
			<!--				<xsl:value-of select="$nodeType"/> -->
			<!--				<xsl:element name="br"/> -->
			<!--				<xsl:text>&#10;</xsl:text> -->
			<!--			</xsl:when> -->
			<!--			<xsl:otherwise> -->
							<!-- nothing -->
			<!--			</xsl:otherwise> -->
			<!--		</xsl:choose> -->
			<!--	</xsl:element> --> <!-- td -->
			</xsl:element> <!-- tr -->
		</xsl:element> <!-- table -->
	</xsl:element> <!-- div CenterDiv -->
	<xsl:element name="br"/>
	<xsl:text>&#10;</xsl:text>
	
	</xsl:for-each>
	<xsl:text>&#10;</xsl:text>

	<!-- now append index entries for the pertinent content models -->

	<xsl:element name="h1">
		<xsl:element name="img">
			<xsl:attribute name="class"><xsl:text>cube</xsl:text></xsl:attribute>
			<xsl:attribute name="src"><xsl:text>../Images/cube.gif</xsl:text></xsl:attribute>
			<xsl:attribute name="alt"><xsl:text>cube</xsl:text></xsl:attribute>
			<xsl:attribute name="width"><xsl:text>20</xsl:text></xsl:attribute>
			<xsl:attribute name="height"><xsl:text>19</xsl:text></xsl:attribute>
		</xsl:element>
		<xsl:element name="a">
			<xsl:attribute name="name"><xsl:text>h-6.3</xsl:text></xsl:attribute>
			<xsl:text>6.3&#160;&#160;Content models</xsl:text>
		</xsl:element>
	</xsl:element>
	<xsl:text>&#10;</xsl:text>

	<xsl:element name="h2">
		<xsl:element name="a">
			<xsl:attribute name="name"><xsl:text>h-6.3.1</xsl:text></xsl:attribute>
			<xsl:text>6.3.1&#160;&#160;Overview</xsl:text>
		</xsl:element>
	</xsl:element>
	<xsl:text>&#10;</xsl:text>

	<xsl:element name="p">
		<xsl:text>Content models provide rules for what child-node elements are allowed for a given node.</xsl:text>
	</xsl:element>
	<xsl:text>&#10;</xsl:text>
	
	<xsl:for-each select="//xs:schema/xs:group[@name=//xs:schema/xs:element[not (@name='ProtoDeclare' or @name='ProtoInterface' or @name='ProtoBody' or  @name='ExternProtoDeclare' or @name='component' or @name='head' or @name='meta' or @name='IS' or @name='connect' or @name='IMPORT' or @name='EXPORT' or @name='ROUTE' or @name='Scene' or @name='X3D'
			 		or @name='inputCoord' or @name='outputCoord' or @name='inputTransform' or @name='rootNodeType' or @name='humanoidBodyType')]//xs:group/@ref
			 	or @name=//xs:schema/xs:complexType//xs:group/@ref]">
		<xsl:sort select="@name"/>
					
		<xsl:variable name="contentModelGroupName">
			<xsl:value-of select="@name"/>
		</xsl:variable>
		
		<xsl:element name="h2">
			<!-- html bookmarks -->
			<xsl:element name="a">
				<xsl:attribute name="name">
					<xsl:value-of select="$contentModelGroupName"/>
				</xsl:attribute>
				<xsl:text>6.3.</xsl:text>
				<xsl:value-of select="position()+1"/>
				<xsl:text>&#160;&#160;</xsl:text>
				<xsl:value-of select="$contentModelGroupName"/>
			</xsl:element>
			<xsl:text>&#10;</xsl:text>
		</xsl:element>
		
		<xsl:element name="p">
			<xsl:value-of select="xs:annotation/xs:appinfo"/>
		</xsl:element>
		<xsl:text>&#10;</xsl:text>
		
		<xsl:if test="$contentModelGroupName != 'ChildContentModelSceneGraphStructure'">
			<xsl:element name="p">
				<xsl:text> A properly typed ProtoInstance node can be substituted for any node in this content model.</xsl:text>
			</xsl:element>
			<xsl:text>&#10;</xsl:text>
		</xsl:if>

	</xsl:for-each>
	<xsl:text>&#10;</xsl:text>

	<xsl:element name="img">
		<xsl:attribute name="class"><xsl:text>x3dbar</xsl:text></xsl:attribute>
		<xsl:attribute name="src"><xsl:text>../Images/x3dbar.png</xsl:text></xsl:attribute>
		<xsl:attribute name="alt"><xsl:text>--- X3D separator bar ---</xsl:text></xsl:attribute>
		<xsl:attribute name="width"><xsl:text>430</xsl:text></xsl:attribute>
		<xsl:attribute name="height"><xsl:text>23</xsl:text></xsl:attribute>
	</xsl:element>
	<xsl:text>&#10;</xsl:text>

	<xsl:text>&#10;</xsl:text>
  </xsl:element> <!-- body -->
  <xsl:text>&#10;</xsl:text>
</xsl:element> <!-- xhtml -->
<xsl:text>&#10;</xsl:text>
</xsl:document>

</xsl:template>

<xsl:template name="includes-containerField">
  <xsl:param name="inputAttributeNodeList"></xsl:param>
	<!--
	<xsl:message>
	  <xsl:value-of select="local-name ($inputAttributeNodeList[1])"/>
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="$inputAttributeNodeList[1]/@name"/>
	 </xsl:message> 
	-->
  <xsl:choose>
    <xsl:when test="count($inputAttributeNodeList)=0">
		<!-- <xsl:message><xsl:text>$inputAttributeNodeList length 0, return false</xsl:text></xsl:message> -->
		<xsl:text>false</xsl:text>
    </xsl:when>
    <xsl:when test="$inputAttributeNodeList[1]/@name='containerField'">
		<!-- <xsl:message><xsl:text>containerField found, return true</xsl:text></xsl:message> -->
		<xsl:text>true</xsl:text>
    </xsl:when>
    <xsl:otherwise>
		<!-- recurse on remainder -->
		<xsl:call-template name="includes-containerField">
			<xsl:with-param name="inputAttributeNodeList" select="$inputAttributeNodeList[position()!=1]"/>
		</xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- ****************** catch-all ****************** -->

<xsl:template match="*">

<xsl:text>&#10;/* catch-all template:  </xsl:text>
<xsl:value-of select="local-name ()"/>
<xsl:text> */&#10;</xsl:text>

	<xsl:apply-templates/>

</xsl:template>


</xsl:stylesheet>

