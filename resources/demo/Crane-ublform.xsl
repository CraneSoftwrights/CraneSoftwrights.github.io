<?xml version="1.0" encoding="US-ASCII"?>
<?xml-stylesheet type="text/xsl" href="../xslstyle/xslstyle-docbook.xsl"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.CraneSoftwrights.com/ns/xslstyle"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:c="urn:X-Crane"
                xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                xmlns:js="http://saxonica.com/ns/globalJS"
                xmlns:prop="http://saxonica.com/ns/html-property"
                xmlns:style="http://saxonica.com/ns/html-style-property"
                xmlns:saxon="http://saxon.sf.net/"
                exclude-result-prefixes="xs xsd c ixsl js prop style saxon" 
                extension-element-prefixes="ixsl"
                version="2.0">
<!--
    $Id: Crane-ublform.xsl,v 1.7 2014/03/31 19:56:43 admin Exp $
    
    This is a proof of concept of the use of XSLT 2.0 for form-filling in a
    client-side web browser application.
    
    As a proof of concept, it does not do rigourous checking of values (for
    example, the entered format for the date is not checked).  It also 
    creates a minimal instance that is validatable.
    
    The resulting UBL instance can be cut out of the browser window and
    pasted into a file for validation.
-->

<xs:doc info="$Id: Crane-ublform.xsl,v 1.7 2014/03/31 19:56:43 admin Exp $"
        filename="Crane-ublform.xsl" vocabulary="DocBook">
  <xs:title>A proof of concept of UBL Invoice form filling</xs:title>
  <para>
    This stylesheet interacts with a user in a web browser to create an
    OASIS UBL invoice document.
  </para>
  <section>
    <title>Installation</title>
    <para>
      There are two steps to install this package:  downloading resources
      and populating directories on a web server.
    </para>
    <section>
      <title>Download</title>
      <para>
        The Saxon-CE (Client Edition) package is available from
        <literal><ulink url="http://saxon.sf.net"/></literal>.  When
        the version 1.1 is unpacked, there are three directories:
      </para>
      <itemizedlist>
        <listitem><literal>notices/</literal></listitem>
        <listitem><literal>Saxonce/</literal></listitem>
        <listitem><literal>SaxonceDebug/</literal></listitem>
      </itemizedlist>
    </section>
    <section>
      <title>Installation</title>
      <para>
        Determine where these demonstration files are going to go on your
        server, say the directory <literal>test/</literal>, and add the
        Saxon-CE directories by unzipping the package while preserving
        directories.
      </para>
      <para>
        In a temporary area, unzip Crane's package while preserving
        directories and then move the files into the target directory.
      </para>
      <para>
        The resulting set of directories and files should look like:
      <itemizedlist>
        <listitem><literal>test/readme-Crane-ublform.html</literal></listitem>
        <listitem><literal>test/demo/Crane-ublform.html</literal></listitem>
        <listitem><literal>test/demo/Crane-ublform.xsl</literal></listitem>
        <listitem><literal>test/notices/*</literal></listitem>
        <listitem><literal>test/Saxonce/*</literal></listitem>
        <listitem><literal>test/SaxonceDebug/*</literal></listitem>
      </itemizedlist>
      </para>
    </section>
  </section>
  <section>
    <title>Execution</title>
    <para>
      Open the file <literal>test/demo/Crane-ublform.html</literal> in a
      modern web browser.
    </para>
    <para>
      Fill out the fields as required.  The "+" button adds an invoice line.
      The "-" button removes an invoice line.
    </para>
    <para>
      The "Reveal" button creates the UBL instance and reveals it on the
      page.  The same logic would be engaged to do anything else with the
      string that is created containing the UBL document.
    </para>
  </section>
  <section>
    <title>Copyright</title>
  <literallayout><literal>
Copyright (C) - Crane Softwrights Ltd.
              - http://www.CraneSoftwrights.com/links/res-dev.htm

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
- The name of the author may not be used to endorse or promote products
  derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Note: for your reference, the above is the "Modified BSD license", this text
      was obtained 2003-07-26 at http://www.xfree86.org/3.3.6/COPYRIGHT2.html#5

THE AUTHOR MAKES NO REPRESENTATION ABOUT THE SUITABILITY OF THIS CODE FOR ANY
PURPOSE.
</literal></literallayout>
  </section>
</xs:doc>

<!--========================================================================-->
<xs:doc>
  <xs:title>Getting started</xs:title>
</xs:doc>

<xs:template>
  <para>
    The initial template creates the header portion of the page and the
    first invoice line of the page.
  </para>
</xs:template>
<xsl:template match="/">
  <!--replace the header with the fields for data entry-->
  <xsl:result-document href="#header">
    <tr>
      <td>Buyer Party Name: 
        <input type="text" name="buyerPartyName" size="50"/></td>
      <td>Seller Party Name: 
        <input type="text" name="sellerPartyName" size="50"/></td>
    </tr>
    <tr>
      <td>Invoice Number: 
        <input type="text" name="invoiceNumber" value=""/></td>
      <td>Invoice Date: 
        <input type="text" name="invoiceDate" value=""/></td>
    </tr>
  </xsl:result-document>
  <!--add the first row to the non-existent rows of the page-->
  <xsl:call-template name="c:addDeleteLine"/>
</xsl:template>

<!--========================================================================-->
<xs:doc>
  <xs:title>Line logic</xs:title>
</xs:doc>

<xs:template>
  <para>This will add (the default) or delete a line from the screen.</para>
  <xs:param name="action">
    <para>The identity of any field on the line to be deleted.</para>
    <para>
      When absent, the default is "add" which adds a line at the end.
    </para>
  </xs:param>
</xs:template>
<xsl:template name="c:addDeleteLine">
  <xsl:param name="action" select="'add'" as="xsd:string"/>
  <!--how many lines are there now?-->
  <xsl:variable name="lines" 
                select="ixsl:page()//tr[matches(@id,'l\d+item')]"/>
  <!--a prototypical new line without any line number-->
  <xsl:variable name="new">
    <tr id="l0item">
      <td><input type="input" name="l0id" size="3"
      /><input type="button" name="l0del" value="-"/></td>
      <td><input type="textarea" name="l0desc" size="50"/></td>
      <td><input type="textarea" name="l0quan" size="8" value="0" data="number"/></td>
      <td><input type="textarea" name="l0price" size="8" value="0" data="number"/></td>
      <td id="l0amount" align="right">0</td>
    </tr>
  </xsl:variable>
  <!--replace the set of lines with a new set of lines-->
  <xsl:result-document href="#items" method="ixsl:replace-content">
    <tr>
      <td>Item ID</td>
      <td>Description</td>
      <td>Quantity</td>
      <td>Price</td>
      <td align="right">Amount</td>
    </tr>
    <!--do not process a line that is deleted, and add a line if needed-->
    <xsl:for-each select="$lines except
                          $lines[td/input/@name=$action],
                          if( $action='add' ) then $new else ()">
      <!--processing a line renumbers it based on its position (which may
          be new if a line has been deleted)-->
      <xsl:apply-templates mode="c:renumber" select=".">
        <xsl:with-param name="lineNumber" tunnel="yes" select="position()"/>
      </xsl:apply-templates>
    </xsl:for-each>
    <!--follow the line items with a total line, and take advantage of the
        real estate for a button used to add a new line-->
    <tr>
      <td><input type="button" name="ladd" value="+"/></td>
      <td/>
      <td/>
      <td align="right">Total:</td>
      <td id="total" align="right">
    <xsl:value-of
      select="sum( (../../../tr[position()>1][position()&lt;last()] except
                    ../.. )/td[5] )"/>
      </td>
    </tr>
  </xsl:result-document>
</xsl:template>

<xs:template>
  <para>
    An identity template except for massaging line-number attributes.
  </para>
</xs:template>
<xsl:template match="*" mode="c:renumber">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()" mode="c:renumber"/>
  </xsl:copy>
</xsl:template>

<xs:template>
  <para>
    Any attribute that matches a line-number attribute gets massaged with
    the running line number.
  </para>
  <xs:param name="lineNumber">
    <para>The running position amongst the active line numbers.</para>
  </xs:param>
</xs:template>
<xsl:template match="@*" mode="c:renumber">
  <xsl:param name="lineNumber" tunnel="yes" as="xsd:integer"/>
  <xsl:attribute name="{name(.)}" 
                 select="if( matches(.,'l\d+') )
                        then concat('l',$lineNumber,replace(.,'l\d+(.*)','$1'))
                        else ."/>
</xsl:template>

<!--========================================================================-->
<xs:doc>
  <xs:title>Line-oriented button pushing</xs:title>
</xs:doc>

<xs:template>
  <para>The button that adds a line to the set of lines.</para>
</xs:template>
<xsl:template match="input[@name='ladd']" mode="ixsl:onclick">
  <xsl:call-template name="c:addDeleteLine"/>
</xsl:template>

<xs:template>
  <para>The button that removes a line from the set of lines.</para>
</xs:template>
<xsl:template match="input[matches(@name,'l\d+del')]" mode="ixsl:onclick">
  <xsl:call-template name="c:addDeleteLine">
    <xsl:with-param name="action" select="@name"/>
  </xsl:call-template>
</xsl:template>

<!--========================================================================-->
<xs:doc>
  <xs:title>Data entry field processing</xs:title>
</xs:doc>

<xs:template>
  <para>
    All field processing must, at the least, establish the new attribute
    value from the event's value
  </para>
</xs:template>
<xsl:template match="input" mode="ixsl:onchange"
              priority="10">
  <xsl:variable name="value" select="ixsl:get(.,'value')"/>
  <xsl:if test="not(@data='number') or $value castable as xsd:double">
    <ixsl:set-attribute name="value" select="$value"/>
  </xsl:if>
  <xsl:next-match>
    <xsl:with-param name="value" select="$value" tunnel="yes"/>
  </xsl:next-match>
</xsl:template>

<xs:template>
  <para>When the input field is in a line item, determine which line</para>
</xs:template>
<xsl:template match="input[matches(@name,'l\d+.*')]" mode="ixsl:onchange"
              priority="5">
  <xsl:next-match>
    <xsl:with-param name="line" select="replace(@name,'l(\d+).*','$1')"
                    tunnel="yes"/>
  </xsl:next-match>
</xsl:template>

<xs:template>
  <para>When quantity changes, multiply by price to get amount.</para>
  <xs:param name="value">
    <para>The given quantity.</para>
  </xs:param>
  <xs:param name="line">
    <para>The position of the line.</para>
  </xs:param>
</xs:template>
<xsl:template match="input[matches(@name,'l\d+quan')]" mode="ixsl:onchange">
  <xsl:param name="value" tunnel="yes" as="xsd:string"/>
  <xsl:param name="line" tunnel="yes" as="xsd:string"/>

  <xsl:call-template name="c:setAmount">
    <xsl:with-param name="value" 
     select="xsd:double($value) * 
          xsd:double(../../td/input[@name=concat('l',$line,'price')]/@value)"/>
  </xsl:call-template>
</xsl:template>

<xs:template>
  <para>When price changes, multiply by quantity to get amount.</para>
  <xs:param name="value">
    <para>The given price.</para>
  </xs:param>
  <xs:param name="line">
    <para>The position of the line.</para>
  </xs:param>
</xs:template>
<xsl:template match="input[matches(@name,'l\d+price')]" mode="ixsl:onchange">
  <xsl:param name="value" tunnel="yes" as="xsd:string"/>
  <xsl:param name="line" tunnel="yes" as="xsd:string"/>
  
  <xsl:call-template name="c:setAmount">
    <xsl:with-param name="value" 
     select="xsd:double($value) * 
           xsd:double(../../td/input[@name=concat('l',$line,'quan')]/@value)"/>
  </xsl:call-template>
</xsl:template>

<xs:template>
  <para>Change the amount for the line, then update the totals.</para>
  <xs:param name="value">
    <para>The given amount.</para>
  </xs:param>
  <xs:param name="line">
    <para>The position of the line.</para>
  </xs:param>
</xs:template>
<xsl:template name="c:setAmount">
  <xsl:param name="value" as="xsd:double?"/>
  <xsl:param name="line" tunnel="yes" as="xsd:string"/>
  
  <!--replace the amount for the given line-->
  <xsl:result-document href="#{concat('l',$line,'amount')}"
                       method="ixsl:replace-content">
    <xsl:value-of select="$value"/>
  </xsl:result-document>
  <!--replace the total of all lines-->
  <xsl:result-document href="#total" method="ixsl:replace-content">
    <xsl:value-of
      select="sum( (../../../tr[position()>1][position()&lt;last()] except
                    ../.. )/td[5] ) +
              $value"/>
  </xsl:result-document>
</xsl:template>

<!--========================================================================-->
<xs:doc>
  <xs:title>Generating results</xs:title>
</xs:doc>

<xs:template>
  <para>Respond to a request to reveal the generated UBL instance.</para>
</xs:template>
<xsl:template match="input[@name='reveal']" mode="ixsl:onclick">
  <xsl:result-document href="#result" method="ixsl:replace-content">
    <xsl:call-template name="c:makeUBL"/>
  </xsl:result-document>
</xsl:template>

<xs:template>
  <para>
    Create a UBL Invoice instance using the attributes and text values.
  </para>
</xs:template>
<xsl:template name="c:makeUBL" xml:space="preserve">
  <!--first build the document as nodes-->
  <xsl:variable name="doc">
<Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">
 <cbc:ID><xsl:value-of select="c:fieldAttr('invoiceNumber')"/></cbc:ID>
 <cbc:IssueDate><xsl:value-of
                    select="c:fieldAttr('invoiceDate')"/></cbc:IssueDate>
 <cac:AccountingSupplierParty>
  <cac:Party>
   <cac:PartyName>
    <cbc:Name><xsl:value-of
                select="c:fieldAttr('sellerPartyName')"/></cbc:Name>
   </cac:PartyName>
  </cac:Party>
 </cac:AccountingSupplierParty>
 <cac:AccountingCustomerParty>
  <cac:Party>
   <cac:PartyName>
    <cbc:Name><xsl:value-of
                select="c:fieldAttr('buyerPartyName')"/></cbc:Name>
   </cac:PartyName>
  </cac:Party>
 </cac:AccountingCustomerParty>
 <cac:LegalMonetaryTotal>
  <cbc:PayableAmount currencyID="EUR"><xsl:value-of
                        select="c:fieldText('total')"/></cbc:PayableAmount>
 </cac:LegalMonetaryTotal>
<xsl:for-each select="ixsl:page()//tr[matches(@id,'l\d+item')]"
    > <cac:InvoiceLine>
  <cbc:ID><xsl:value-of
            select="c:fieldAttr(concat('l',position(),'id'))"/></cbc:ID>
  <cbc:InvoicedQuantity><xsl:value-of
  select="c:fieldAttr(concat('l',position(),'quan'))"/></cbc:InvoicedQuantity>
  <cbc:LineExtensionAmount currencyID="EUR"><xsl:value-of
  select="c:fieldText(concat('l',position(),'amount'))"
                                          /></cbc:LineExtensionAmount>
  <cac:Item>
   <cbc:Description><xsl:value-of
  select="c:fieldAttr(concat('l',position(),'desc'))"/></cbc:Description>
  </cac:Item>
  <cac:Price>
   <cbc:PriceAmount currencyID="EUR"><xsl:value-of
  select="c:fieldAttr(concat('l',position(),'price'))"/></cbc:PriceAmount>
  </cac:Price>
 </cac:InvoiceLine>
</xsl:for-each></Invoice>
  </xsl:variable>
  <!--serialize the document nodes just created to create angle brackets-->
  <!--first add the XML Declaration-->
  <xsl:text><![CDATA[<?xml version="1.0" encoding="UTF-8"?>]]>
</xsl:text>
  <!--then add the nodes-->
  <xsl:apply-templates mode="c:serialize" select="$doc"/>
</xsl:template>

<xs:function>
  <para>Obtain a value stored in an attribute.</para>
  <xs:param name="name">
    <para>Identified by the input field's name.</para>
  </xs:param>
</xs:function>
<xsl:function name="c:fieldAttr" as="xsd:string?">
  <xsl:param name="name" as="xsd:string"/>
  <xsl:value-of select="ixsl:page()//*[@name=$name]/@value"/>
</xsl:function>

<xs:function>
  <para>Obtain a value stored in a text element.</para>
  <xs:param name="id">
    <para>Identified by the element's identifier.</para>
  </xs:param>
</xs:function>
<xsl:function name="c:fieldText" as="xsd:string?">
  <xsl:param name="id" as="xsd:string"/>
  <xsl:value-of select="ixsl:page()//*[@id=$id]"/>
</xsl:function>

<!--========================================================================-->
<xs:doc>
  <xs:title>XML serialization</xs:title>
  <para>
    This mimics what an XML serializer would do when creating angle brackets
    from structure.
  </para>
</xs:doc>

<xs:template>
  <para>Handle elements and their attributes.</para>
</xs:template>
<xsl:template mode="c:serialize" match="*">
 <xsl:value-of>
  <xsl:value-of select="concat('&lt;',name(.))"/>
  <xsl:for-each select="namespace::*">
    <xsl:if test="not(../../namespace::*[name(.)=name(current()) and
                                            .=current()])
                  and name(.)!='xml'">
    <xsl:value-of select="concat('&#xa; xmlns',if( name(.) ) then ':' else '',
                                 name(.),'=&#x22;',c:escapeAttr(.),'&#x22;')"/>
    </xsl:if>
  </xsl:for-each>
  <xsl:for-each select="attribute::*">
    <xsl:value-of select="concat(' ',name(.),'=&#x22;',
                                 c:escapeAttr(.),'&#x22;')"/>
  </xsl:for-each>
  <xsl:choose>
    <xsl:when test="node()">
      <xsl:text>></xsl:text>
      <xsl:apply-templates mode="c:serialize"/>
      <xsl:value-of select="concat('&lt;/',name(.),'>')"/>
    </xsl:when>
    <xsl:otherwise>/></xsl:otherwise>
  </xsl:choose>
 </xsl:value-of>
</xsl:template>

<xs:template>
  <para>Handle text inside of elements.</para>
</xs:template>
<xsl:template mode="c:serialize" match="text()">
  <xsl:value-of select="c:escapeText(.)"/>
</xsl:template>

<xs:template>
  <para>Handle a comment.</para>
</xs:template>
<xsl:template mode="c:serialize" match="comment()">
  <xsl:value-of select="concat('&lt;!--',.,'-->')"/>
</xsl:template>

<xs:template>
  <para>Handle a processing instruction.</para>
</xs:template>
<xsl:template mode="c:serialize" match="processing-instruction()">
  <xsl:value-of select="concat('&lt;?',name(.),
                         if(not(string(.))) then '' else concat(' ',.),'?>')"/>
</xsl:template>

<xs:function>
  <para>Escape the special characters in an attribute's value.</para>
  <xs:param name="string">
    <para>The value to be escaped.</para>
  </xs:param>
</xs:function>
<xsl:function name="c:escapeAttr" as="xsd:string?">
  <xsl:param name="string" as="xsd:string?"/>
  <xsl:variable name="quot" as="xsd:string">"</xsl:variable>
  <xsl:variable name="apos" as="xsd:string">'</xsl:variable>
  <xsl:sequence select="replace(replace(c:escapeText($string),
                            $quot,'&amp;quot;'),$apos,'&amp;apos;')"/>
</xsl:function>

<xs:function>
  <para>Escape the special characters in a PCDATA's value.</para>
  <xs:param name="string">
    <para>The value to be escaped.</para>
  </xs:param>
</xs:function>
<xsl:function name="c:escapeText" as="xsd:string?">
  <xsl:param name="string" as="xsd:string?"/>
  <xsl:sequence select="replace(replace(replace($string,'&amp;',
                          '&amp;amp;'),'&gt;','&amp;gt;'),'&lt;','&amp;lt;')"/>
</xsl:function>

</xsl:stylesheet>