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
        filename="review2burn.xsl" vocabulary="DocBook">
  <xs:title>Burst a Crane SVG review file into individual SVG burn files</xs:title>
  <para>
    This stylesheet is taking a collection of sets of layers and creating
    individual SVG files with only the layers in the given set. At the same
    time, any strokes that are magenta in colour are indicated to have a stroke
    width of 0.001in for the cutter to recognize as a cut instead of an etch.
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
    The input file has layers with layer titles that name the output SVG file
    dedicated to that layer's content.
  </para>
  <para>
    The output file is a dummy placebo that isn't actually written to. Rather
    the URI of the dummy file is 
  </para>
</xs:doc>
  
<xs:param>
  <para>
    The base name of the scripts synthesized to be executed to invoke the
    Inkscape production of PDF files.
  </para>
</xs:param>
<xsl:param name="base-name" as="xsd:string" required="yes"/>

<xs:param>
  <para>
    The suffix to use for the names of the files generated.
  </para>
</xs:param>
<xsl:param name="name-suffix" as="xsd:string" required="yes"/>

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
  <xsl:if test="exists(//text[string(.)!=''])">
    <xsl:message terminate="yes"
               select="'This SVG file has not had objects converted to paths.',
                       'Such is necessary to avoid font issues.'"/>
  </xsl:if>
  <xsl:if test="count(/*/g)=1">
    <xsl:message terminate="yes"
      select="'This SVG file has but one top-level group rather than multiple',
              'groups, one group for each output file.'"/>
  </xsl:if>
  <xsl:result-document href="{$base-name}.bat" method="text">
    <xsl:call-template name="c:commandLines"/>
  </xsl:result-document>
  <xsl:result-document href="{$base-name}.sh" method="text">
    <xsl:call-template name="c:commandLines"/>
  </xsl:result-document>
  <xsl:for-each select="g">
    <xsl:variable name="c:thisGroup" select="."/>
    <xsl:result-document href="svg/{@inkscape:label}{$name-suffix}.svg"
                         method="xml" indent="no">
      <xsl:for-each select="/*">
        <xsl:copy>
          <!--preserve document element-->
          <xsl:copy-of select="@*"/>
          <!--preserve everything other than groups-->
          <xsl:copy-of select="* except g"/>
          <!--put out the one group only, turning on visibility-->
          <xsl:for-each select="$c:thisGroup">
            <xsl:copy>
              <xsl:copy-of select="@*"/>
              <xsl:attribute name="style"
                             select="'display:inline;',
                                     replace(@style,'display:.+?;?','')"/>
              <xsl:apply-templates/>
            </xsl:copy>
          </xsl:for-each>
        </xsl:copy>
      </xsl:for-each>
    </xsl:result-document>
  </xsl:for-each>
</xsl:template>

<xs:template>
  <para>
    Synthesize the command line functions for conversion to PDF assuming that
    the command is being invoked from the parent directory.
  </para>
</xs:template>
<xsl:template name="c:commandLines">
  <xsl:for-each select="g">
    <xsl:value-of select="concat('echo Processing ''burn/svg/',@inkscape:label, 
                                 $name-suffix,''' Files remaining: ',
                                 count(following-sibling::g),'&#xa;')"/>
    <xsl:value-of select="concat('inkscape burn/svg/',@inkscape:label,
         $name-suffix,'.svg --export-type=pdf --export-filename=burn/pdf/',
         @inkscape:label,$name-suffix,'.pdf&#xa;')"/>
  </xsl:for-each>
</xsl:template>

<xs:template>
  <para>
    Convert magenta lines to .001in.
  </para>
</xs:template>
<xsl:template match="@style[contains(.,'stroke:#ff00ff')]">
  <xsl:attribute name="style"
           select="replace(.,'stroke-width:[^;]*;?','stroke-width:.001in;')"/>
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
