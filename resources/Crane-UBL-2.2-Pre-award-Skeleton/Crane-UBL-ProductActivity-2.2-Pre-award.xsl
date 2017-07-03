<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:import href="Crane-UBL-Skeleton-obfuscated.xsl"/>
  <xsl:variable name="gc" select="doc('UBL-ProductActivity-2.2-Pre-award-subset.gc')"/>
  <xsl:variable name="doc">
    <ProductActivity xmlns="urn:X-test:UBL:Pre-award:ProductActivity" xmlns:cac="urn:X-test:UBL:Pre-award:CommonAggregate" xmlns:cbc="urn:X-test:UBL:Pre-award:CommonBasic"/>
  </xsl:variable>
  <!--
Copyright (C) - Crane Softwrights Ltd.
              - http://www.CraneSoftwrights.com/links/res-skeleton.htm

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
-->
</xsl:stylesheet>