<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../utilities/xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
                xmlns="http://www.w3.org/2000/svg"
                xmlns:c="urn:X-Crane"
                exclude-result-prefixes="xs xsd c"
                xpath-default-namespace="http://www.w3.org/2000/svg"
                version="2.0">

<xs:doc info="$Id$"
        filename="design2review.xsl" vocabulary="DocBook">
  <xs:title>Convert a Crane SVG design file into a review file</xs:title>
  <para>
    This stylesheet is looking for cues that assemble Inkscape layers
    for review and modification for bursting into burn files.
  </para>
  <programlisting>
BSD 3-Clause License

Copyright (c) 2023, Crane Softwrights Ltd.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.    
  </programlisting>
</xs:doc>

<!--========================================================================-->
<xs:doc>
  <xs:title>Invocation parameters and input file</xs:title>
  <para>
    The input file has layers with layer titles that include layer tags
    of the form {name}:{distinction} that are combined into layers with titles
    that include the name of the output burst file, an equal sign, and tags of
    the form {name}:* that are combined into the output.    
  </para>
  <para>
    The output file has only the combination layers with the identified layers
    combined. This is suitable for review, for modification of objects to
    paths, then bursting into burn files.
  </para>
  <para>
    There are no invocation parameters.
  </para>
</xs:doc>

<xs:variable>
  <para>Need to remember the input context for key() to work</para>
</xs:variable>
<xsl:variable name="c:top" as="document-node()" select="/"/>

<!--========================================================================-->
<xs:doc>
  <xs:title>Convert all identified layers</xs:title>
</xs:doc>

<xs:key>
  <para>Find all layers that are building blocks</para>
</xs:key>
<xsl:key name="c:build" match="g[matches(@inkscape:label,':[^\*]')]"
         use="'__all__',
              for $each in tokenize(@inkscape:label,'\s+')[matches(.,':[^\*]')]
              return substring-before($each,':')"/>

<xs:key>
  <para>Find all layers that are assembled building blocks</para>
</xs:key>
<xsl:key name="c:assemble" match="/*/g[tokenize(@inkscape:label,'\s+')='=']"
         use="'__all__',tokenize(@inkscape:label,'\s+')[1]"/>

<xs:key>
  <para>Find all objects based on their label</para>
</xs:key>
<xsl:key name="c:objectsByLabel" match="*[@inkscape:label]"
         use="normalize-space(@inkscape:label)"/>

<xs:template>
  <para>
    Can't get started
  </para>
</xs:template>
<xsl:template match="/*">
  <xsl:message terminate="yes"
               select="'Unexpected input document element:',name(.)"/>
</xsl:template>

<xs:template>
  <para>Get started</para>
</xs:template>
<xsl:template match="/svg" priority="1">
  <!--integrity check on version strings-->
  <xsl:variable name="c:printVersionStrings"
                select="key('c:objectsByLabel','Version')/
                        replace(.,'[\s-:]','')"/>
  <xsl:if test="count(distinct-values($c:printVersionStrings))>1">
    <xsl:message terminate="yes"
                 select="'Inconsistent version strings:',
                         distinct-values($c:printVersionStrings)"/>
  </xsl:if>
  <xsl:copy>
    <!--preserve document element-->
    <xsl:copy-of select="@*"/>
    <!--preserve everything other than groups-->
    <xsl:copy-of select="* except g"/>
    <!--put everything in a group to make conversion easier-->
    <g inkscape:label=
               "Select this group, convert object to path, ungroup this group">
      <xsl:for-each select="key('c:assemble','__all__',$c:top)">
        <xsl:call-template name="c:addReferencedLayers">
          <xsl:with-param name="c:layer" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </g>
  </xsl:copy>
</xsl:template>

<xs:template>
  <para>Recursively copy in referenced groups, checking for loops</para>
  <xs:param name="c:layer">
    <para>The layer making the references</para>
  </xs:param>
  <xs:param name="c:pastLayers">
    <para>A history of layers to prevent infinite loops and visibility</para>
  </xs:param>
</xs:template>
<xsl:template name="c:addReferencedLayers">
  <xsl:param name="c:layer" as="element(g)" required="yes"/>
  <xsl:param name="c:pastLayers" as="element(g)*"/>
  <xsl:variable name="c:refs" 
                select="tokenize($c:layer/@inkscape:label,'\s+')"/>
  <!--the output layer uses the given name-->
  <g inkscape:label="{$c:refs[1]}"
     style="display:{if(count($c:pastLayers)>0) then 'inline' else 'none'}">
    <xsl:for-each select="reverse($c:refs[contains(.,':')])">
      <xsl:variable name="c:ref" select="substring-before(.,':')"/>
      <g inkscape:label="{.}">
        <xsl:choose>
          <xsl:when test="some $c:past in $c:pastLayers
                          satisfies $c:past is $c:layer">
            <!--this is an infinite loop-->
            <xsl:message terminate="yes">
              <xsl:text>An infinite loop detected with:&#xa;</xsl:text>
              <xsl:for-each select="$c:pastLayers">
                <xsl:value-of select="@inkscape:label,'&#xa;'"/>
              </xsl:for-each>
            </xsl:message>
          </xsl:when>
          <xsl:when test="exists(key('c:assemble',$c:ref,$c:top))">
            <xsl:call-template name="c:addReferencedLayers">
              <xsl:with-param name="c:layer"
                              select="key('c:assemble',$c:ref,$c:top)"/>
              <xsl:with-param name="c:pastLayers"
                              select="$c:pastLayers,$c:layer"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="empty(key('c:build',$c:ref,$c:top))">
            <!--something is amiss-->
            <xsl:message>
              <xsl:text>Missing a definition for the reference: </xsl:text>
              <xsl:value-of select="$c:ref"/>
            </xsl:message>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select="key('c:build',$c:ref,$c:top)">
              <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:attribute name="style"
                               select="'display:inline;',
                                       replace(@style,'display:.+?;?','')"/>
                <xsl:apply-templates/>
              </xsl:copy>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </g>
    </xsl:for-each>
  </g>
</xsl:template>

<xs:template>
  <para>
    The identity template is used to copy all nodes not already being handled
    by other template rules.
  </para>
</xs:template>
<xsl:template match="@*|node()" mode="#all">
  <xsl:copy>
    <xsl:apply-templates mode="#current" select="@*|node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
