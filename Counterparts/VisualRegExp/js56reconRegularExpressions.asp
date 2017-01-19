<HTML >
<HEAD>
	<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=windows-1252" />
    	<TITLE>Regular Expressions</TITLE>
<META NAME="Description" CONTENT=""/>
<META NAME="Robots" CONTENT=""/>
<META NAME="Keywords" CONTENT=""/>
<META NAME="MS.LOCALE" CONTENT="en-us"/>

<LINK REL="stylesheet" TYPE="text/css" HREF="ie3.css" />
<LINK REL="stylesheet" TYPE="text/css" HREF="/library/shared/comments/css/down.css" />

	<style>
	BODY
	{
		font-family:verdana,arial,helvetica;
		margin:0;
	}
	</style>
	
<SCRIPT LANGUAGE="javascript" SRC="/library/en-us/_customscripts/vbcon/dtuelink.js"></SCRIPT>
<SCRIPT LANGUAGE="javascript" SRC="/library/toolbar/toolbar.js"></SCRIPT>

<LINK REL="stylesheet" TYPE="text/css" HREF="/library/en-us/vsintro7/scripts/dtue.css" />
<LINK REL="stylesheet" TYPE="text/css" HREF="/library/shared/eyebrow/css/default.css" />


   <SCRIPT LANGUAGE="JavaScript"><!--
   function BrowserData()
{
		this.userAgent = "Opera/7.03 (Windows NT 4.0; U)  [en]";

		this.bot = true;

		this.browser = "Other";

		this.getsNavBar = false;

		this.doesActiveX = false;

		this.doesPersistence = false;

		this.fullVer = NaN;

   }

   var oBD = new BrowserData();

   //--></SCRIPT>

   <SCRIPT LANGUAGE="JavaScript"><!--

   if (document.layers) {
    origWidth  = innerWidth;
  origHeight = innerHeight;
   }

   function resizeFix() { if (innerWidth != origWidth || innerHeight != origHeight) location.reload(); }

   if (document.layers) onresize = resizeFix;

   //--></SCRIPT><BASE TARGET="_top" />

   <SCRIPT LANGUAGE="JavaScript"><!--
   function BrowserData()
{
		this.userAgent = "Opera/7.03 (Windows NT 4.0; U)  [en]";

		this.bot = true;

		this.browser = "Other";

		this.getsNavBar = false;

		this.doesActiveX = false;

		this.doesPersistence = false;

		this.fullVer = NaN;

   }

   var oBD = new BrowserData();

   //--></SCRIPT>

   <SCRIPT LANGUAGE="JavaScript"><!--

   if (document.layers) {
    origWidth  = innerWidth;
  origHeight = innerHeight;
   }

   function resizeFix() { if (innerWidth != origWidth || innerHeight != origHeight) location.reload(); }

   if (document.layers) onresize = resizeFix;

   //--></SCRIPT>

<xml id='xmlPageContext'><eyebrow findmenu="false">
	<item label="MSDN Home" url="/default.asp"/>
	<item label="MSDN Library" url="/library/default.asp"/>
	<item label="Web Development" id="msdnlib1480" xmlsrc="/library/en-us/toc/msdnlib/msdnlib1480_.xml"/><item label="Scripting" url="/nhp/Default.asp?contentid=28001169" id="msdnlib1538" xmlsrc="/library/en-us/toc/msdnlib/msdnlib1538_.xml"/><item label="Documentation" id="msdnlib1539"/><item label="Windows Script Technologies" url="/library/en-us/script56/html/vtoriMicrosoftWindowsScriptTechnologies.asp" id="script562" xmlsrc="/library/en-us/toc/script56/script562_.xml"/><item label="JScript" url="/library/en-us/script56/html/js56jsoriJScript.asp" id="script563"/><item label="User's Guide" url="/library/en-us/script56/html/js56jsconJScriptUsersGuide.asp" id="script564" xmlsrc="/library/en-us/toc/script56/script564_.xml"/><item label="Introduction to Regular Expressions" url="/library/en-us/script56/html/js56reconIntroductionToRegularExpressions.asp" id="script5628" xmlsrc="/library/en-us/toc/script56/script5628_.xml"/><item label="Regular Expressions" url="/library/en-us/script56/html/js56reconRegularExpressions.asp" id="script5629"/></eyebrow></xml>
        <!--VENUS_START-->
        <meta name="MSHTOCTitle" content="Regular Expressions" />
        <meta name="MSHRLTitle" content="Regular Expressions" />
        <meta name="MSHKeywordA" content="js56reconRegularExpressions"/>
        <meta name="MSHKeywordK" content="regular expressions, overview"/>
        <meta name="MSHKeywordA" content="js56reconRegularExpressions"/>
        <meta name="MSHAttr" content="DevLang:JScript"/>
        <meta name="MSHAttr" content="DevLangVers:kbJScript"/>
        <meta name="MSHAttr" content="DocSet:JScript"/>
        <meta name="MSHAttr" content="DocSet:PSDK"/>
        <meta name="MSHAttr" content="Product:VS"/>
        <meta name="MSHAttr" content="ProductVers:kbVS"/>
        <meta name="MSHAttr" content="TargetOS:WinCE"/>
        <meta name="MSHAttr" content="TargetOSVers:kbWinCE"/>
        <meta name="MSHAttr" content="TargetOSVers:kbWinOS"/>
        <meta name="MSHAttr" content="Technology:ASP"/>
        <meta name="MSHAttr" content="TechnologyVers:kbASP"/>
        <meta name="MSHAttr" content="Technology:IE"/>
        <meta name="MSHAttr" content="TechnologyVers:kbIE"/>
        <meta name="MSHAttr" content="TechnologyVers:kbWSH200"/>
        <meta name="MSHAttr" content="TopicType:kbRef"/>
        <meta name="MSHAttr" content="TargetOS:Windows"/>
        <meta name="MSHAttr" content="Locale:kbEnglish"/>

        <!---VENUS_END--->
         </HEAD> <BODY TOPMARGIN="0"  LEFTMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0" BGCOLOR="#FFFFFF" TEXT="#000000">

       <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="4" HEIGHT="24" WIDTH="100%" BGCOLOR="#FFFFFF">
       <TR>
        <TD CLASS="eyebrow" VALIGN="middle" ALIGN="left" WIDTH="100%">&nbsp;&nbsp;

            <a class="small" target="_top" href="/default.asp">MSDN Home</a>&nbsp;>&nbsp;
            <a class="small" target="_top" href="/library/default.asp">MSDN Library</a>&nbsp;>&nbsp;
            <a class="small" target="_top" href="/library/default.asp?url=/nhp/Default.asp?contentid=28001169">Scripting</a>&nbsp;>&nbsp;
            <a class="small" target="_top" href="/library/default.asp?url=/library/en-us/script56/html/vtoriMicrosoftWindowsScriptTechnologies.asp">Windows Script Technologies</a>&nbsp;>&nbsp;
            <a class="small" target="_top" href="/library/default.asp?url=/library/en-us/script56/html/js56jsoriJScript.asp">JScript</a>&nbsp;>&nbsp;
            <a class="small" target="_top" href="/library/default.asp?url=/library/en-us/script56/html/js56jsconJScriptUsersGuide.asp">User's Guide</a>&nbsp;>&nbsp;
            <a class="small" target="_top" href="/library/default.asp?url=/library/en-us/script56/html/js56reconIntroductionToRegularExpressions.asp">Introduction to Regular Expressions</a><a href=""></a>
        </TD>
       </TR>
       </TABLE>
 <TABLE class='clsContainer' CELLPADDING='15' CELLSPACING='0' float='left' WIDTH='100%' BORDER='0'> <TR> <TD VALIGN='top'>
<!--TOOLBAR_START-->
<!--TOOLBAR_EXEMPT-->
<!--TOOLBAR_END-->
<!-- Begin Content -->

<!--NONSCROLLING BANNER START-->
<div id="nsbanner">
<div id="bannerrow1">
<TABLE CLASS="bannerparthead" CELLSPACING=0>
<TR ID="hdr">
<TD CLASS="runninghead" nowrap>JScript</TD>
<TD CLASS="product" nowrap>&nbsp;</TD>
</TR>
</TABLE>
</div>
<div id="TitleRow">
<H1 class="dtH1"><A NAME="js56reconregularexpressions"></A>Regular Expressions</H1>
</div></div>
<!--NONSCROLLING BANNER END-->
<DIV id="nstext" valign="bottom">
<div id="allHistory" class="saveHistory" onsave="saveAll()" onload="loadAll()"></div>
<P>Unless you have worked with regular expressions before, the term and the concept may be unfamiliar to you. However, they may not be as unfamiliar as you think.</P>

<P>Think about how you search for files on your hard disk. You most likely use the ? and * characters to help find the files you're looking for. The ? character matches a single character in a file name, while the * matches zero or more characters. A pattern such as 'data?.dat' would find the following files:</P>

<BLOCKQUOTE class="dtBlock">
data1.dat</BLOCKQUOTE>

<BLOCKQUOTE class="dtBlock">
data2.dat</BLOCKQUOTE>

<BLOCKQUOTE class="dtBlock">
datax.dat</BLOCKQUOTE>

<BLOCKQUOTE class="dtBlock">
dataN.dat</BLOCKQUOTE>

<P>Using the * character instead of the ? character expands the number of files found. 'data*.dat' matches all of the following:</P>

<BLOCKQUOTE class="dtBlock">
data.dat</BLOCKQUOTE>

<BLOCKQUOTE class="dtBlock">
data1.dat</BLOCKQUOTE>

<BLOCKQUOTE class="dtBlock">
data2.dat</BLOCKQUOTE>

<BLOCKQUOTE class="dtBlock">
data12.dat</BLOCKQUOTE>

<BLOCKQUOTE class="dtBlock">
datax.dat</BLOCKQUOTE>

<BLOCKQUOTE class="dtBlock">
dataXYZ.dat</BLOCKQUOTE>

<P>While this method of searching for files can certainly be useful, it is also very limited. The limited ability of the ? and * wildcard characters give you an idea of what regular expressions can do, but regular expressions are much more powerful and flexible.</P>



<!-- End Content -->

 </TD> </TR> </TABLE>
<TABLE WIDTH="100%" HEIGHT="50" ID="idToolbar" CELLPADDING="0" CELLSPACING="0" BORDER="0" BGCOLOR="#003399">
<TR>
<TD BGCOLOR=#003399 HEIGHT="20" VALIGN="middle" NOWRAP ID="idTBLocal" WIDTH="100%">
<FONT FACE="Verdana, Arial" SIZE="2"><B>

		&nbsp;&nbsp;<A STYLE='color:##FFFFFF;text-decoration:none;' HREF='http://register.microsoft.com/contactus30/contactus.asp?domain=msdn' TARGET='_top'><FONT COLOR='#FFFFFF'>Contact Us</FONT></A>

					&nbsp;&nbsp;<FONT COLOR='#FFFFFF'>|</FONT>
				
		&nbsp;&nbsp;<A STYLE='color:##FFFFFF;text-decoration:none;' HREF='mailto:?subject=An article from MSDN&body=Here is an interesting article from MSDN:  msdn.microsoft.com/library/en-us/script56/html/js56reconRegularExpressions.asp' TARGET='_top'><FONT COLOR='#FFFFFF'>E-Mail this Page</FONT></A>

					&nbsp;&nbsp;<FONT COLOR='#FFFFFF'>|</FONT>
				
		&nbsp;&nbsp;<A STYLE='color:##FFFFFF;text-decoration:none;' HREF='/flash/' TARGET='_top'><FONT COLOR='#FFFFFF'>MSDN Flash Newsletter</FONT></A>

					&nbsp;&nbsp;<FONT COLOR='#FFFFFF'>|</FONT>
				
		&nbsp;&nbsp;<A STYLE='color:##FFFFFF;text-decoration:none;' HREF='/isapi/gomscom.asp?target=/legal/' TARGET='_top'><FONT COLOR='#FFFFFF'>Legal</FONT></A>


</B></FONT>
</TD>
</TR>
<TR>
<TD BGCOLOR=#003399 HEIGHT="20" VALIGN="middle" NOWRAP ID="idTBLocal" WIDTH="100%">
<FONT FACE="Verdana, Arial" SIZE="2"><B>
&nbsp;&nbsp;<FONT COLOR='#FFFFFF'>&#169; 2003 Microsoft Corporation. All rights reserved.</FONT>&nbsp;&nbsp;
&nbsp;&nbsp;<A STYLE='color:##FFFFFF;text-decoration:none;' HREF=' /isapi/gomscom.asp?target=/info/cpyright.htm' TARGET='_top'><FONT COLOR='#FFFFFF'>Terms of Use</FONT></A>&nbsp;&nbsp;&nbsp;&nbsp;<A STYLE='color:##FFFFFF;text-decoration:none;' HREF='/isapi/gomscom.asp?target=/info/privacy.htm' TARGET='_top'><FONT COLOR='#FFFFFF'>Privacy Statement </FONT></A>&nbsp;&nbsp;&nbsp;&nbsp;<A STYLE='color:##FFFFFF;text-decoration:none;' HREF='/isapi/gomscom.asp?target=/enable/' TARGET='_top'><FONT COLOR='#FFFFFF'>Accessibility </FONT></A>&nbsp;&nbsp;</B></FONT>
</TD>
</TR>
</TABLE>
 </BODY> </HTML>