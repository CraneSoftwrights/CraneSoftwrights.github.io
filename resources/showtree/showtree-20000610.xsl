<?xml version="1.0"?><!--showtree.xsl-->
<!--XSLT/XPath 1.0 - http://www.CraneSoftwrights.com/training -->
<!--
  PUBLIC
    "+//ISBN 1-894049::CSL::XSL::Debug//DOCUMENT Show All Nodes Stylesheet//EN"
  Copyright (C) Crane Softwrights Ltd. - http://www.CraneSoftwrights.com

  $Source: d:/backup/Ken/CVSROOT/dev/showtree/showtree.xsl,v $
  $Date: 2000/06/10 05:24:50 $$Revision: 1.7 $

  This stylesheet exposes the entire XPath data model of an XML instance as
  seen by an XSLT processor.  Namespace nodes are numerated in roman numerals.
  Attribute nodes are enumerated in letters.  All other nodes are in
  parent/child relationships and are enumerated in digits.  Attribute and
  namespace nodes are ordered, but the order is implementation dependent, thus
  different processors may produce different reports for the same document.

  As delivered, the stylesheet does not expose the namespace axis.  If the
  processor you are using does support accessing the namespace axis (for
  example: XT does not support accessing the namespace axis; Saxon does),
  removing the empty definition for &namespace-reporting; will engage the
  full definition of this general entity, thus utilizing the template in
  the result.

  By default, element nodes are described only by their breakdown of
  constituent nodes.  To request that the element's value be shown in addition
  to the element's descendants, set the top-level parameter
  $show-element-values to any non-empty string.
-->

<!DOCTYPE xsl:stylesheet [
<!ENTITY nl "&#xa;"><!--new line sequence-->

<!--remove the following empty declaration if namespaces are to be reported-->
<!ENTITY namespace-reporting ''>

<!--the following declaration will only be used if not previously defined-->
<!ENTITY namespace-reporting '
      <xsl:for-each select="namespace::*">
        <xsl:call-template name="namespace">
          <xsl:with-param name="ancestry" select="$this-ancestry"/>
          <xsl:with-param name="node-pos" select="$this-node-pos"/>
        </xsl:call-template>
      </xsl:for-each>
'>
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
<xsl:output method="text"/>

             <!--set the following non-empty to reveal element's node values-->
<xsl:param name="show-element-values"/>

<!--========================================================================-->
<!--nodes with children-->

<xsl:template match="/">                                       <!--root node-->
  <xsl:text>SHOWTREE Stylesheet - </xsl:text>
  <xsl:text>http://www.CraneSoftwrights.com/resources/</xsl:text>
  <xsl:text>&nl;Processor: </xsl:text>
  <xsl:value-of select="system-property('xsl:vendor')"/>
  <xsl:apply-templates select="node()"/>
</xsl:template>

<xsl:template match="*">                                      <!--an element-->
  <xsl:param name="ancestry"/>
  <xsl:variable name="this-ancestry">
    <xsl:if test="$ancestry!=''">
      <xsl:value-of select="$ancestry"/><xsl:text>,</xsl:text>
    </xsl:if>
    <xsl:value-of select="name(.)"/>
  </xsl:variable>
  <xsl:param name="node-pos"/>
  <xsl:variable name="this-node-pos">
    <xsl:if test="$node-pos!=''">
      <xsl:value-of select="$node-pos"/><xsl:text>.</xsl:text>
    </xsl:if>
    <xsl:value-of select="position()"/>
  </xsl:variable>
  <xsl:call-template name="node">
    <xsl:with-param name="ancestry" select="$ancestry"/>
    <xsl:with-param name="node-pos" select="$this-node-pos"/>
    <xsl:with-param name="type">Element</xsl:with-param>
    <xsl:with-param name="contents">                          <!--node value-->
      <xsl:choose>
        <xsl:when test="not($show-element-values)"/>
        <xsl:when test="node()">
          <xsl:text>{</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>}</xsl:text>
        </xsl:when>
        <xsl:otherwise>no child nodes</xsl:otherwise>
      </xsl:choose>
      &namespace-reporting;           <!--defined in a general entity in DTD-->
      <xsl:for-each select="@*">
        <xsl:call-template name="attribute">
          <xsl:with-param name="ancestry" select="$this-ancestry"/>
          <xsl:with-param name="node-pos" select="$this-node-pos"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:choose>                                         <!--node children-->
        <xsl:when test="node()">
          <xsl:apply-templates select="node()">
            <xsl:with-param name="ancestry" select="$this-ancestry"/>
            <xsl:with-param name="node-pos" select="$this-node-pos"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$show-element-values"/>    <!--content already shown-->
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!--========================================================================-->
<!--for every leaf node, show the value in report-->

<!--child leaf nodes-->

<xsl:template match="comment()">                               <!--a comment-->
  <xsl:param name="ancestry"/>
  <xsl:param name="node-pos"/>
  <xsl:variable name="this-node-pos">
    <xsl:if test="$node-pos!=''">
      <xsl:value-of select="$node-pos"/><xsl:text>.</xsl:text>
    </xsl:if>
    <xsl:value-of select="position()"/>
  </xsl:variable>
  <xsl:call-template name="node">
    <xsl:with-param name="ancestry" select="$ancestry"/>
    <xsl:with-param name="node-pos" select="$this-node-pos"/>
    <xsl:with-param name="type">Comment</xsl:with-param>
    <xsl:with-param name="contents">
      <xsl:text>{</xsl:text><xsl:value-of select="."/><xsl:text>}</xsl:text>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="processing-instruction()">       <!--a processing inst.-->
  <xsl:param name="ancestry"/>
  <xsl:param name="node-pos"/>
  <xsl:variable name="this-node-pos">
    <xsl:if test="$node-pos!=''">
      <xsl:value-of select="$node-pos"/><xsl:text>.</xsl:text>
    </xsl:if>
    <xsl:value-of select="position()"/>
  </xsl:variable>
  <xsl:call-template name="node">
    <xsl:with-param name="ancestry" select="$ancestry"/>
    <xsl:with-param name="node-pos" select="$this-node-pos"/>
    <xsl:with-param name="type">Proc. Inst.</xsl:with-param>
    <xsl:with-param name="contents">
      <xsl:text>{</xsl:text><xsl:value-of select="."/><xsl:text>}</xsl:text>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="text()">                                <!--a text node-->
  <xsl:param name="ancestry"/>
  <xsl:param name="node-pos"/>
  <xsl:variable name="this-node-pos">
    <xsl:value-of select="$node-pos"/><xsl:text>.</xsl:text>
    <xsl:value-of select="position()"/>
  </xsl:variable>
  <xsl:call-template name="node">
    <xsl:with-param name="ancestry" select="$ancestry"/>
    <xsl:with-param name="node-pos" select="$this-node-pos"/>
    <xsl:with-param name="type">Text</xsl:with-param>
    <xsl:with-param name="contents">
      <xsl:text>{</xsl:text><xsl:value-of select="."/><xsl:text>}</xsl:text>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!--attached leaf nodes-->

<xsl:template name="attribute">                             <!--an attribute-->
  <xsl:variable name="ancestry"/><!--change to xsl:param to include ancestry-->
  <xsl:param name="node-pos"/>
  <xsl:variable name="this-node-pos">
    <xsl:value-of select="$node-pos"/><xsl:text>.</xsl:text>
    <xsl:number value="position()" format="A"/>
  </xsl:variable>
  <xsl:call-template name="node">
    <xsl:with-param name="ancestry" select="$ancestry"/>
    <xsl:with-param name="node-pos" select="$this-node-pos"/>
    <xsl:with-param name="type">Attribute</xsl:with-param>
    <xsl:with-param name="contents">
      <xsl:text>{</xsl:text><xsl:value-of select="."/><xsl:text>}</xsl:text>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="namespace">                        <!--a namespace node-->
  <xsl:variable name="ancestry"/><!--change to xsl:param to include ancestry-->
  <xsl:param name="node-pos"/>
  <xsl:variable name="this-node-pos">
    <xsl:value-of select="$node-pos"/><xsl:text>.</xsl:text>
    <xsl:number value="position()" format="I"/>
  </xsl:variable>
  <xsl:call-template name="node">
    <xsl:with-param name="ancestry" select="$ancestry"/>
    <xsl:with-param name="node-pos" select="$this-node-pos"/>
    <xsl:with-param name="type">Namespace</xsl:with-param>
    <xsl:with-param name="contents">
      <xsl:text>{</xsl:text><xsl:value-of select="."/><xsl:text>}</xsl:text>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!--========================================================================-->
<!--display the content of a node-->

<xsl:template name="node">
  <xsl:param name="ancestry"/>
  <xsl:param name="node-pos"/>
  <xsl:param name="type"/>
  <xsl:param name="contents"/>
  <xsl:text>&nl;</xsl:text>
  <xsl:value-of select="$node-pos"/>                     <!--report location-->
  <xsl:text>  </xsl:text>
  <xsl:value-of select="$type"/>                               <!--node type-->
  <xsl:if test="not(name(.)='')">                   <!--node name (if appl.)-->
    <xsl:text> '</xsl:text>
    <xsl:if test="namespace-uri(.)!=''">                  <!--with namespace-->
      <xsl:text>{</xsl:text>
      <xsl:value-of select="namespace-uri(.)"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:value-of select="name(.)"/>
    <xsl:text>'</xsl:text>
  </xsl:if>
                                                            <!--node context-->
  <xsl:if test="$ancestry"> (<xsl:value-of select="$ancestry"/>)</xsl:if>
  <xsl:text>: </xsl:text>
  <xsl:value-of select="$contents"/>
</xsl:template>

</xsl:stylesheet>