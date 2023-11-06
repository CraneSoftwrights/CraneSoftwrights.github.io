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
        filename="md2xhtml.xsl" vocabulary="DocBook">
  <xs:title>Convert an XHTML file made from markdown to linked XHTML</xs:title>
  <para>
    This stylesheet is looking for references to ".md" files that should be
    ".html".
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
    The input file is XHTML that may make references to ".md" markdown files.
    These references are changed to be ".html" for linking purposes in the
    output.
  </para>
</xs:doc>

<xs:param ignore-ns="yes">
  <para>The base directory with which to chop off URI strings</para>
</xs:param>
<xsl:param name="baseDirectory" as="xsd:string" required="yes"/>

<!--========================================================================-->
<xs:doc>
  <xs:title>Find links</xs:title>
</xs:doc>
  
<xs:key>
  <para>For some reason, pandoc creates bad links</para>
</xs:key>
<xsl:key name="c:ids" match="*[@id]" use="@id"/>

<xs:template>
  <para>
    Catch the bad links
  </para>
</xs:template>
<xsl:template match="@href[starts-with(.,'#') and ends-with(.,'-') and
                           empty(key('c:ids',substring-after(.,'#'))) and
                       exists(key('c:ids',substring(.,2,string-length(.)-2)))]"
              priority="2">
  <xsl:attribute name="href" select="substring(.,1,string-length(.)-1)"/>
</xsl:template>

<xs:template>
  <para>
    Catch the local links
  </para>
</xs:template>
<xsl:template match="@href[starts-with(.,'#') and
                       exists(key('c:ids',substring(.,2,string-length(.)-1)))]"
              priority="1">
  <xsl:attribute name="href" select="."/>
</xsl:template>

<xs:template>
  <para>
    Links to md files now need to be links to HTML files.
  </para>
</xs:template>
<xsl:template match="@href[matches(.,'\.md$')]">
  <xsl:attribute name="href" select="replace(.,'\.md([^\.]|$)','.md.html$1')"/>
</xsl:template>

<xs:template>
  <para>
    Links to non-md files now need to be links found in GitHub
  </para>
</xs:template>
<xsl:template match="@href[not(matches(.,'\.md$')) and
                           not(starts-with(.,'http'))]">
  <xsl:attribute name="href" 
                 select="concat($baseDirectory,replace(.,'\.\./',''))"/>
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
