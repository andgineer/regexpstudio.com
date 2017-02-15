#!/usr/bin/perl

##########################################################################
# LogCount: An IMG SRC, SSI and A HREF(links) called script that saves   #
# to common log files also used by the Loglook.cgi log viewer, SSI count.#
# viewer. DO NOT use these programs without first reading the            #
# accompanying README TEXTS.                                             #
##########################################################################
# This script "LOGLOOK.CGI" written (and ©) by Ron F Woolley, Melbourne  #
# Australia. Copyright 1998'99. This free to use script can be altered   #
# for personal use, BUT all of this header text MUST REMAIN intact as    #
# is, AND, using this script without first reading the accompanying      #
# README file, is prohibited. Copyright notices MUST remain and visible. #
#                                                                        #
# The scripts and associated files REMAIN the property of Ron F Woolley. #
# NO PROFIT what so ever is to be gained from users of these scripts     #
# for installation of these scripts or any other purpose, except that a  #
# reasonable minimal charge for installation MAY be allowed when         #
# installed on the users behalf. One copy only is allowed only on a users#
# web site. Supply of EACH copy of this program is allowed directly from #
# dtp-aus.com ONLY. Remote site hosting of the program is strictly not   #
# allowed. Ron Woolley, the author, MUST be notified via the addresses / #
# URLs below if any gain is to be made for the installation of these     #
# scripts, and by whom.                                                  #
#                                                                        #
# NOTE: If you use this and/or the accompanying files, you do so         #
# entirely at your own risk, and take on full reponsability for the      #
# consequences of using the described files. You must first agree that   #
# Ron Woolley / HostingNet, the only allowed supplier of this or         #
# accompanying files are exempt from any responsibility for all or any   #
# resulting problems, losses or costs caused by your using this or any   #
# associated files.                                                      #
##########################################################################
# This program script is free to use. But if you try, then use this      #
# script and/or the accompanying files, a support registration of AU$25  #
# to the Author would be appreciated.  payments on-line Visa MasterCrd   #
##########################################################################
# Registration and Support Information - contact Ron Woolley             #
# Helppage at http://www.dtp-aus.com/cgiscript/scrpthlp.htm              #
# Files from http://www.dtp-aus.com/cgiscript/cntscrpt.shtml             #
##########################################################################
# THESE FILES can only be obtained via the above web addresses,and MUST  #
# NOT BE PASSED ON TO OTHERS in any form by any means what so ever. This #
# DOES NOT contradict any other statements above.                        #
# EACH USER SITE MUST OBTAIN THESE FILES from URL above.                 #
##########################################################################
#                     VERSION 3.5d November 1999                         #
##########################################################################

#--- Alter these two paths only, if needed! ---------------------#
	require "sets/gmtset.pl"; 
	require "sets/cntcnfg.pl";
#--- Do Not make any changes below this line. -------------------#

	&check_method;
		&is_referer_ok;

my (@allArray,@dtList,@dtLst,@countaDay,$dateChange,$alips);
	@pairs = split(/&/, $query_string);
	foreach $pair (@pairs) {
	($name, $value) = split(/=/, $pair);
		$value =~ tr/+/ /;
		$name =~ tr/+/ /;
		$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		$name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		$value =~ s/~!/ ~!/g;
		$value =~ s/<([^>]|\n)*>//g; 
		$value =~ s/<!--#(.|\n)*-->//g;
		$value =~ s/`//g;
	$FORM{$name} = $value;
	}
jmpin:
	if ($FORM{'m'} && &pwrd($FORM{'m'})) {$listAll = 1;}
	elsif ($FORM{'l'} && &pwrd($FORM{'l'})) {$listLnk = 1;}
	elsif (($FORM{'edlog'} == 1 || $FORM{'vdays'} == 1 || $FORM{'gmed'} == 1 || $FORM{'edwrd'} == 1) && &pwrd($FORM{'pwd'})) {&eds;}
	elsif ($FORM{'edlnx'} == 1 && &pwrd($FORM{'pwd'})) {&lnxed;}
	elsif ($FORM{'shwcde'} == 1 && &pwrd($FORM{'pwd'})) {&shwcode;}
	elsif ($FORM{'htm'} && &pwrd($FORM{'pwd'})) {&do_get;}
	else {&showErr('Unknown Request');}
		open (COUNT, "<$count_url") || &showErr('Count File Access');
 	    eval"flock (COUNT, 2)";
			$counter = <COUNT>;
 	    eval"flock (COUNT, 8)";
		close (COUNT);

	print "Content-type: text/html\n\n";
	print<<EOF;
<html>

<head>
	<title>LogLook, Log viewer and Admin program</title>
	<meta name="author" content="Ron F Woolley 1998 '99 - www.dtp-aus.com">
	<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
</head>
	<basefont size="2" face="arial,verdana,helvetica">
<body bgcolor="#FFFFFF">
EOF
if (!($listLnk)) {print "<font face=\"arial,helvetica,geneva\"><p align=\"center\"><b>&#149; <a href=\"$hm_url\">HOME</a> &#149; <a href=\"$logScrpt\?l=$theword\">LINKS \&amp\; DEFAULTS</a> &#149;</b> &nbsp;&nbsp;&nbsp;&nbsp;Log Viewer for LogCount CGI</p></font>\n";}
else {print "<font face=\"arial,helvetica,geneva\"><p align=\"center\"><b>&#149; <a href=\"$hm_url\">HOME</a> &#149; <a href=\"$logScrpt\?m=$theword\">MAIN LIST</a> &#149;</b> &nbsp;&nbsp;&nbsp;&nbsp;Log Viewer for LogCount CGI</p></font>\n";}

	open(MAINlog, $log_url) || &showErr('Log File Access');
     eval"flock (MAINlog, 2)";

$fsize = ( -s "$log_url" );
$isnow = &date_time(1);
print "<center><table bgcolor=\"#FFFFCC\" width=\"595\" border=\"1\" cellpadding=\"0\" cellspacing=\"0\"><tr><td align=\"center\"><font size=\"2\">\n";
print "Log <b>File size: <font color=\"#CC0000\">$fsize</font></b> bytes &#149; Current <b>Counter Total: <font color=\"#CC0000\">$counter</font></b><br>\n";
print "Server-Date: <font color=\"#3300FF\">".&date_time(0)."</font> &#149; Zoned-Date: <font color=\"#3300FF\">$isnow</font>\n";
print "</font></td></tr></table></center>\n";
($isnow,$scrap) = split(/ /,$isnow);

	my $nn = 0; my $perDay = 0; 
while ($input_line = <MAINlog>) {
	chomp($input_line);
		@lineInArray = split(/\,/,$input_line);
	$nn++; $perDay++;
	@datein = split(/ /,$lineInArray[0]);
	if ($datein[0] ne $dateChange) {
		push(@dtList,$lineInArray[0]);
		push(@dtLst,$datein[0]);
		push(@countaDay,$perDay);
		push(@countaIP,$ipperDay);
		$ipperDay = 0;
		$dalips = "";
		$perDay = 0;
		$dateChange = $datein[0];
	}
	if ($listAll) {
		push(@allArray,$input_line);
		&tallyips;
	} 
	$lastDate = $lineInArray[0];
}
     eval"flock (MAINlog, 8)";
	close(MAINlog);

	push(@countaIP,$ipperDay);
		$dalips = "";
		$alips = "";	
	push(@countaDay,$perDay+1);
	  $firstDate = $dtList[0];
	    ($scrap,$scrap1) = split(/ /,$lastDate);
	      @scrap = split(/\:/,$scrap1);
	        $partdays = ((($scrap[0]*60)+$scrap[1])/60)/24+(@dtList-1);

if ($listAll && @allArray > 0 && @dtList > 0) {
print "<center><table width=\"595\" border=\"0\"><tr><td align=\"center\"><small>\n";
print "<p align=\"center\">&nbsp;<br><b>$nn hits</b> over <b>".sprintf("%0.2f",$partdays)." days</b>, ";
print "averaging <b><font color=\"#990000\">".sprintf("%0.2f",$nn/$partdays)."</font> hits per day</b>.<br>\n"; 
if ($wiz && $nn) {print "( of $nn, <font color=\"#990000\"><b>$wiz</b></font> <small>( ".sprintf("%0.2f",(100/$nn) * $wiz)."% )</small> were recorded as <b>unique IP#s</b> )<br>\n";}
print "First Hit: <font color=\"#990000\">$firstDate</font> &#149; Last hit: <font color=\"#990000\">$lastDate</font><br>&nbsp;</p>\n";
print "</small></td></tr></table><hr width=\"595\" noshade size=\"1\"></center>\n";

print "<center><table width=\"595\" bgcolor=\"#EEEEFF\" border=\"0\" cellpadding=\"2\" cellspacing=\"0\"><tr>\n";
$cnts = 0; $cnts2 = 0;
foreach $scrap (@dtList) {
	($scrap1,$scrap2) = split(/ /,$scrap);
	push (@dateList,$scrap1); 
	if ($cnts eq 6) {
		$cnts = 0; 
		print "</tr><tr>\n";
	}
	$cnts++; $cnts2++; 
	print "<td align=\"center\"><small><small>$scrap1<br></small>Hits: <font color=\"#660000\"><b>$countaDay[$cnts2]</b></font></small></td>\n"; 
}
	if ($cnts < 6) {
	for ($cnts = $cnts; $cnts < 6; $cnts++) {
		print "<td>&nbsp;</td>\n"; 
	} }
	$wch = "";
		if ($shwDays7 && @dateList > 7) {$shwDays7 = @dateList[@dateList-7]; $ld = 7;}
		elsif ((!($shwDays7)) && @dateList > 2) {$shwDays7 = @dateList[@dateList-2]; $ld = 2;}
		else {$shwDays7 = $wch = "1"; $ld = @dateList;}
print "</tr></table></center>\n";
print "<center><table width=\"595\" cellspacing=\"0\" cellpadding=\"3\" border=\"0\">\n";
print "<tr><td width=\"100\%\" align=\"center\"><small><b><font color=\"#006600\">Hits for the last $ld days</font></b></small></td></tr></table></center>\n";
	$cnts = 1; $dateChange = ""; $ld = (@dtLst - $ld) + 1;
foreach $wooza(@allArray) {
	if ($wch || $wooza =~ /$shwDays7/) {
	$wch = "1";
	@dt = split(/, /,$wooza);
		($hitdate,$hitTime) = (split / /,$dt[0]);
		if ($hitdate ne $dateChange) {
 		print "</table></center>\n";
		print "<center><table width=\"595\" bgcolor=\"#EEEEEE\" cellspacing=\"0\" cellpadding=\"3\" border=\"0\">\n";
		print "<tr><td width=\"100%\" colspan=\"5\" bgcolor=\"#99CC99\">&nbsp;&nbsp;&#149; <small><b>$hitdate</b>&nbsp;&nbsp; $countaIP[$ld] unique IP#</small></td></tr>\n";
		$dateChange = $hitdate;
		$cnts = 1; $ld++;
		}
	if ($dt[2] !~ /[a-z0-9]/i) {$dt[2] = "default";}
		($pageName,$scrap) = split(/\#/,$dt[2]);
		@clrs = split (/\./, $dt[1]);
	print "<tr><td width=\"5%\" align=\"right\"><small><small><font color=\"#666666\">$cnts</font></small></small></td><td width=\"10%\"><font color=\"#990000\"><small>$hitTime</small></font></td><td width=\"13%\" align=\"right\">";
	print "<small>$dt[1]</small></td><td width=\"2%\" bgcolor=\"#".sprintf("%02X%02X%02X",$clrs[0],$clrs[1],$clrs[2])."\"><small>&nbsp;&nbsp;</small></td><td width=\"70%\"><small>$pageName";
	if ($showDoms) {print " <small><font color=\"#666666\">- $dt[4]</font></small>";}
	print "</small></td></tr>\n";
	$cnts++;
	}
}
print "</table><hr width=\"595\" noshade size=\"1\"></center>\n";
} 
elsif ($listLnk) {
	$lstbx = "         <option> </option>\n";
		&r_lnx;
	print "<CENTER>\n";
	print "&nbsp;<br><font face=\"arial,helvetica,geneva\" size=\"2\">Installed <b>Counted-Links</b></font>\n";
	print "<table width=\"595\" bgcolor=\"#EEEEEE\" cellspacing=\"0\" cellpadding=\"3\" border=\"0\">\n";
	print "<tr><td bgcolor=\"#CCCCE5\" width=\"5%\"><FONT SIZE=\"2\" FACE=\"arial,geneva,helvetica\">Tag</FONT></td>\n";
	print "<td bgcolor=\"#CCCCE5\" width=\"5%\"><FONT SIZE=\"2\" FACE=\"arial,geneva,helvetica\"><b>Name</b></FONT></td>\n";
	print "<td align=\"center\" bgcolor=\"#CCCCE5\" width=\"5%\"><FONT FACE=\"arial,geneva,helvetica\" SIZE=\"2\" color=\"#CC0000\">Count</FONT></td>\n";
	print "<td bgcolor=\"#CCCCE5\" width=\"85%\"><FONT SIZE=\"2\" FACE=\"arial,geneva,helvetica\">URL&nbsp;&nbsp;<font size=\"1\">testing a link ( to a new window ) will not update count</FONT></FONT></td></tr>\n";
	foreach $ln (sort(@lns)) {
		@TL = split(/\|/,$ln);
		print "<tr><td width=\"5%\"><FONT FACE=\"arial,geneva,helvetica\" SIZE=\"1\"><a href=\"$logScrpt\?htm=$TL[0]&pwd=$theword\" target=\"_blank\">GET</a></font></td>\n";
		print "<td align=\"center\" width=\"5%\"><FONT FACE=\"arial,geneva,helvetica\" SIZE=\"2\"><b>$TL[0]</b></font></td>\n";
	$lstbx .= "         <option value=\"$TL[0]\">$TL[0]</option>\n";
		print "<td align=\"center\" width=\"5%\"><FONT FACE=\"arial,geneva,helvetica\" SIZE=\"2\" color=\"#CC0000\">$TL[2]</font></td>\n";
		print "<td width=\"85%\"><FONT FACE=\"arial,geneva,helvetica\" SIZE=\"2\"><a href=\"$countScrpt\?L=$TL[0]\" target=\"_blank\">$TL[1]</a></font></td></tr>\n";
	}
	print "</table>\n";
		@dtList = "";
	$tmp = "";
	pop @dtLst;
		foreach $s1 (@dtLst) {
			($s2, $scrap) = split(/ /,$s1);
			$tmp .= "      <option value=\"$s2\">$s2</option>\n";	}
	if ($shwDays7) {$dy = "7"; $dyy = " checked";}
	else {$dy = "2"; $dyy = "";}
		$gm = sprintf("%0.2f",$gmtPlusMinus / 60 / 60);
			$datetime = &date_time(1);
			
print <<EOT;
$rsltpnl
<form method="POST" action="$logScrpt">
 <INPUT TYPE="hidden" NAME="edlnx" VALUE="1">
 <INPUT TYPE="hidden" NAME="pwd" VALUE="$theword">
<TABLE width="595" BORDER="0" CELLSPACING="0" CELLPADDING="3">
  <TR><TD ALIGN="CENTER" COLSPAN="2" WIDTH="100%"><table width="595" border="0" cellspacing="0" cellpadding="2" bgcolor="#666666"><tr>
	<td align="center"><font face="arial,geneva,helvetica" color="#FFFFFF"><b>add, edit, reset, or delete links</b></font></td></tr></table></TD> 
  </TR><TR>
      <TR><TD WIDTH="60%">
        <FONT SIZE="-1" FACE="arial,helvetica,geneva"><B>Enter NEW Link Name</B> ( ADD only! )</FONT><BR>
        &nbsp;&nbsp;<INPUT NAME="newname" TYPE="text" SIZE="21" MAXLENGTH="20"><FONT
         SIZE="-2" FACE="arial,helvetica,geneva">&nbsp;20 characters max</FONT><BR><FONT SIZE="-1" 
         FACE="arial,helvetica,geneva">&nbsp;&nbsp;<FONT COLOR="#CC0000">OR</FONT><BR>
         <B>Select EXISTING Name<B></FONT><BR>
         &nbsp;&nbsp;<SELECT NAME="oldname" SIZE="1">
$lstbx
      	 </SELECT><BR>&nbsp;<BR>
        <B><FONT SIZE="-1" FACE="arial,helvetica,geneva">New Link URL - <small>only needed if adding to or editing the list</small></FONT><BR>
        &nbsp;&nbsp;<INPUT NAME="newurl" TYPE="text" SIZE="38" MAXLENGTH="85"></TD>
        <TD ALIGN="CENTER" WIDTH="40%"><FONT SIZE="2" 
        FACE="arial,helvetica,geneva"><P><INPUT TYPE="radio" NAME="deladd" VALUE="add"> <B><FONT COLOR="#CC0000">Confirm</FONT> ADD</B><small><BR>
        Select this button to ADD a<BR>new link Name (and link URL).</small>
        <BR><INPUT TYPE="radio" NAME="deladd" VALUE="deled"> <B><FONT COLOR="#CC0000">Confirm</FONT> EDIT</B><small><BR>
        Select this button to Edit the<BR>URL of the selected Link Name.</small>
        <BR><INPUT TYPE="radio" NAME="deladd" VALUE="delrst"> <B><FONT COLOR="#CC0000">Confirm</FONT> RESET</B><small><BR>
        Select this button to Reset the<BR>selected Link Names Counter.</small>
        <BR><INPUT TYPE="radio" NAME="deladd" VALUE="del"> <B><FONT COLOR="#CC0000">Confirm</FONT> DELETE</B><small><BR>
        Select this button to Delete<BR>the selected Link Name.</small></FONT></TD>
      </TR><TR>
        <TD COLSPAN="2" BGCOLOR="#EFEFEF" ALIGN="CENTER" WIDTH="100%">
        <FONT SIZE="-1" FACE="arial,helvetica,geneva">Admin PWrd:&nbsp;</FONT><INPUT
        NAME="admwrd" TYPE="password" SIZE="11" MAXLENGTH="10">&nbsp;&nbsp<INPUT
        NAME="send" TYPE="submit" VALUE="Add / Delete Link">&nbsp;&nbsp;<INPUT
        NAME="name" TYPE="reset" VALUE="Clear All"></TD>
    </TR></TABLE></FORM>
EOT
	print "<b>Current Program Defaults</b>\n";
	print "<table width=\"470\" bgcolor=\"#EEEEEE\" cellspacing=\"0\" cellpadding=\"3\" border=\"1\"><tr><td width=\"100\%\"><small><blockquote>\&nbsp\;<br>\n";
	if ($shwDays7) {print "Days Viewed = <b>Seven</b><br>\n";}
		else {print "Days Viewed = <b>Two</b><br>\n";}
	print "Zeros Padding = <b>$iszeros</b><br>\n";
	print "GMT Plus/Minus= <b>".sprintf("%0.2f",$gmtPlusMinus/60/60)." hrs</b><br>\n";
	if ($dtUS eq "1") {print "Date Format = <b>US</b><br>\n";}
	elsif ($dtUS eq "2") {print "Date Format = <b>International</b><br>\n";}
	else {print "Date Format = <b>British</b><br>\n";}
	print "Home URL:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>$hm_url</b><br>\n";
	if ($showDoms) {print "View Host Names = <b>Yes</b><br>\n";}
		else {print "View Referer Hosts = <b>No</b><br>\n";}
	@tmp = split(/\|/,$rjct);
	print "Rejected Addresses:<br><b>\n";
		foreach $rj (@tmp) {
			if ($rj) {print "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$rj<br>\n";}
		}
	$webmstr =~ s/mailto\://g;
	print "</b>Webmaster Address:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>$webmstr</b>\n";
	print "</blockquote></small></td></tr></table>\n";

print <<EOT;
<form method="POST" action="$logScrpt">
 <INPUT TYPE="hidden" NAME="edlog" VALUE="1">
 <INPUT TYPE="hidden" NAME="pwd" VALUE="$theword">
  <table border="0" width="595" cellspacing="0" cellpadding="2">
    <tr><td valign="middle" align="center" nowrap colspan="2"><table width="595" border="0" cellspacing="0" cellpadding="2" bgcolor="#666666"><tr>
	<td align="center"><font face="arial,geneva,helvetica" color="#FFFFFF"><b>delete some or all log records</b></font></td></tr>
	</table></td></tr><tr>
      <td valign="middle" align="center" nowrap><font face="arial,geneva,helvetica" size="2"><font
      color="#FF0000"><b>Last</font>&nbsp;Date</b></font><br>
      <select name="dlist" size="-2">
$tmp
      </select><br>
      <font face="arial,geneva,helvetica" size="2"><b>to&nbsp;Remove</b></font></td>
      <td valign="top"><font face="arial,geneva,helvetica" size="-1">&nbsp;<input 
	type="radio" value="d" name="deldates"> <font color="#990000"><b>Confirm Delete</b></font><BR><font color="#FF0000">NOTE</font> 
	<small>All dates from the beginning, <u>up to and including</u>, the selected date will be permanently deleted. The most recent logged date cannot be deleted with this option, and should not appear in the list.</small></font></td>
    </tr><tr>
      <td valign="top" align="center" colspan="2"><hr noshade size="1"></td>
    </tr><tr>
      <td valign="top" align="center" colspan="2" bgcolor="#FFE5E5"><small><input type="radio" name="deldates"
      value="k"></small><font face="arial,geneva,helvetica" size="2" color="#FF0000"> <b>KILL Log</b>&nbsp;&nbsp;&nbsp;NOTE </font><font
      face="arial,geneva,helvetica" size="1">: This option will DELETE ALL records from the Log File.</font></td>
    </tr><tr>
      <td width="591" valign="top" align="center" BGCOLOR="#EFEFEF" colspan="3"><font
      face="arial,geneva,helvetica" size="-1">Admin PWrd: </font><input type="password"
      name="admwrd" size="15"> <input type="submit" value="Prune Dates from Log"> <input
      type="reset" value="Reset"></td>
    </tr></table></form>

<form method="POST" action="$logScrpt">
 <INPUT TYPE="hidden" NAME="shwcde" VALUE="1">
 <INPUT TYPE="hidden" NAME="pwd" VALUE="$theword">
<table width="595" border="0" cellspacing="0" cellpadding="3">
  <tr><td align="CENTER" width="100%" colspan="4">
      <table width="595" border="0" cellspacing="0" cellpadding="2" bgcolor="#666666">
        <tr><td align="center"><font face="arial,geneva,helvetica" color="#FFFFFF"><b>veiw counter source code</b></font></td>
        </tr></table></td></tr><tr>
     <td align="CENTER" colspan="4"><font size="2" face="arial,helvetica,geneva">Display link samples for your counters.</font><font size="-2" face="arial,helvetica,geneva"><br>
      </font></td></tr><tr>
     <td align="CENTER" bgcolor="#EFEFEF" colspan="4" width="100%"><input 
      name="send" type="submit" value="Display Hyperlinks HTML"></td>
  </tr></table></FORM>

<form method="POST" action="$logScrpt">
 <INPUT TYPE="hidden" NAME="vdays" VALUE="1">
 <INPUT TYPE="hidden" NAME="pwd" VALUE="$theword">
  <table border="0" width="595" cellspacing="0" cellpadding="2"><tr bgcolor="#666666">
      <td width="100%" valign="top" align="center" colspan="2"><font face="arial,geneva,helvetica" color="#FFFFFF"><b>logged dates displayed by LogLook</b>&nbsp;&nbsp;&nbsp;&nbsp;<font size="2">current = <b>$dy</b></font></font></td>
    </tr><tr>
      <td valign="middle" align="center" nowrap><font face="arial,geneva,helvetica" size="-1"><b>&nbsp;Default&nbsp;2&nbsp;days&nbsp;</b></font><br>
        <input type="checkbox" name="vdys" value="1" $dyy><br><font face="arial,geneva,helvetica" size="-1"><b>&nbsp;Select&nbsp;for&nbsp;last&nbsp;7&nbsp;</b></font></td>
      <td><input type="checkbox" name="vdychange" value="y"><font face="arial,geneva,helvetica" size="-1"><font color="#000080"><b>Confirm Change</b></font><br>
      <small><font size="1" face="verdana, arial, geneva, helvetica">The main LogLook page displays either the last <b>2</b> or <b>7</b> days of the current logged dates. If hits rise to numbers making the page take too long to load, then de-select this option to display only the last 2 - ie <b>Not Selected</b> = last 2 dates, <b>Selected</b> = last 7 dates.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>Also select &quot;confirm&quot; to save the change.</i></font></small></font></td>
    </tr><tr>
      <td width="591" valign="top" align="center" BGCOLOR="#EFEFEF" colspan="2"><font
      face="arial,geneva,helvetica" size="-1">Admin PWrd:</font><input type="password" name="admwrd" size="12"> 
        <input type="submit" value="Set Days displayed">
         <input type="reset" value="Reset form"></td>
    </tr></table></form>

<form method="POST" action="$logScrpt">
 	<input type="hidden" name="gmed" value="1">
	<input type="hidden" name="pwd" value="$theword">
       <table border="0" width="595" cellspacing="0" cellpadding="2">
        <tr><td bgcolor="#666666" valign="middle" align="center" colspan="2"><font face="arial,geneva,helvetica" color="#FFFFFF">Adjust site <b>GMT Time Zone</b><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;current time: $datetime</font></font></td>
        </tr><tr>
          <td valign="middle" align="center" nowrap bgcolor="#FFFFFE"><font face="arial,geneva,helvetica" size="2"><b>&nbsp;GMT</b></font><br>
            &nbsp;&nbsp;<input type="text" name="gmt" value="$gm" size="8">&nbsp;&nbsp;<br>
            <font face="arial,geneva,helvetica" size="2">Hours + or -</font></td>
          <td bgcolor="#FFFFFE">
            <input type="checkbox" name="gmted" value="y">
            <font face="arial,geneva,helvetica" size="2"><font color="#000080"><b>Confirm Change</b></font><font size="1"><br>
         If you move from the current time zone, or change to / from daylight savings, enter the new value and tick
         &quot;Change&quot;, Even if the local GMT time zone equals the servers (0.00), you must
         have your local GMT time zone value entered here. (ie 0.0 or 5.5 or -9 etc).... <i>refer to your local pc clock setup? ie Windows</i></font></font></td>
        </tr><tr bgcolor="#EFEFEF">
          <td width="591" valign="top" align="center" colspan="2"><font face="arial,geneva,helvetica" size="2">admin PWrd:</font>
            <input type="password" name="admwrd" size="15">
            <input type="submit" value="Change GMT Zone"> <input type="reset" value="reset"></td>
          </tr></table></form>

<form method="POST" action="$logScrpt">
 <INPUT TYPE="hidden" NAME="edwrd" VALUE="1">
 <INPUT TYPE="hidden" NAME="pwd" VALUE="$theword">
<TABLE WIDTH="595" BORDER="0" CELLSPACING="0" CELLPADDING="3">
  <TR><TD ALIGN="CENTER" WIDTH="100%" COLSPAN="4"><table width="595" border="0" cellspacing="0" cellpadding="2"><tr>
	<td bgcolor="#666666" align="center"><font face="arial,geneva,helvetica" color="#FFFFFF"><b>administration password</b></font></td>
	</tr></table></TD> 
  </TR><TR>
      <TD ALIGN="CENTER" COLSPAN="4"><FONT SIZE="1" FACE="verdana,arial,helvetica,geneva">Use this form to add/change your admin password - required to edit these options.<BR></FONT></TD>
      </TR><TR>
      <TR><TD WIDTH="15%">&nbsp;</TD>
      <TD ALIGN="CENTER" WIDTH="35%"><FONT SIZE="2" FACE="arial,helvetica,geneva"><B>New</B> Admin Password</FONT><BR>
        <INPUT TYPE="password" NAME="newwrd" maxlength="15" SIZE="15"></TD>
      <TD ALIGN="CENTER" WIDTH="35%"><FONT SIZE="2" FACE="arial,helvetica,geneva"><B>Repeat</B> New Password</FONT><BR>
        <INPUT TYPE="password" NAME="newwrd2" maxlength="15" SIZE="15"></TD>
      <TD WIDTH="15%">&nbsp;</TD>
      </TR><TR>
        <TD ALIGN="CENTER" BGCOLOR="#EFEFEF" COLSPAN="4" WIDTH="100%">
        <FONT SIZE="-1" FACE="arial,helvetica,geneva"><B>Old</B> Admin PWrd:&nbsp;</FONT><INPUT
        NAME="admwrd" TYPE="password" SIZE="16" MAXLENGTH="15">&nbsp;&nbsp<INPUT
        NAME="send" TYPE="submit" VALUE="Change Password">&nbsp;&nbsp;<INPUT
        NAME="name" TYPE="reset" VALUE="Clear All"></TD>
    </TR></TABLE></FORM></center>
EOT
}
else {print "<p align=\"center\"><b>Not enough data for a listing</b></p>\n";}
print "<p align=\"center\"><a href=\"#top\"><small>TOP</small></a></p>\n";
print "<p align=\"center\"><small>LogLook v3.5d, copyright 1998 '99 Ron Woolley - HostingNet</small></p>\n";
print "</body></html>\n";
exit;
sub tallyips {
	if($dalips !~ / $lineInArray[1]( |\Z)/) {
		$dalips .= " $lineInArray[1]";
		$ipperDay++	}
		if($alips !~ / $lineInArray[1]( |\Z)/) {
			$alips .= " $lineInArray[1]";
			$wiz++	}
}
sub shwcode {
	$FORM{'icol'} = "w";
	$ilen = length($iszeros);
	$oneline = "<img src=&quot;$countScrpt?t&quot; valign=&quot;middle&quot; width=&quot;1&quot; height=&quot;1&quot;>";
	$vizis = "<img src=\"$countScrpt?0\" valign=\"middle\" width=\"$iwid\" height=\"$ihgt\">";
	$vizno = "<img src=\"$countScrpt?v\" valign=\"middle\" width=\"$iwid\" height=\"$ihgt\">";
	$tmeis = "<img src=\"$countScrpt?c0\" valign=\"middle\" width=\"$iwid\" height=\"$ihgt\">";
	$tmeno = "<img src=\"$countScrpt?n0\" valign=\"middle\" width=\"$iwid\" height=\"$ihgt\">";
	for ($cnt = 1; $cnt < $ilen; $cnt++) {
		$tg = $cnt;
	$vizis .= "<img \n src=\"$countScrpt?$tg\" valign=\"middle\" width=\"$iwid\" height=\"$ihgt\">";
	$vizno .= "<img \n src=\"$countScrpt?$tg\" valign=\"middle\" width=\"$iwid\" height=\"$ihgt\">";
		$tg = "c" . $cnt;
	$tmeis .= "<img \n src=\"$countScrpt?$tg\" valign=\"middle\" width=\"$iwid\" height=\"$ihgt\">";
		$tg =  "n" . $cnt;
	$tmeno .= "<img \n src=\"$countScrpt?$tg\" valign=\"middle\" width=\"$iwid\" height=\"$ihgt\">";
	}
	print "Content-type: text/html\n\n";
print <<EOT;
<html>
<head><title>Your Counter Source Code</title></head>
<body bgcolor="#FFFFFF" text="#000000" link="#0000FF" vlink="#6600FF" alink="#FF0000">
<center><p><font face="arial, geneva, helvetica"><b><font color="#990000">Click here <a href=\"$logScrpt\?l=$theword\">to return</a> to your admin page</font></b></font></p>
  <table width="560" border="0" cellspacing="0" cellpadding="3">
    <tr><td align="center" bgcolor="#CCCCCC"><font face="verdana, arial, geneva, helvetica"><b><font color="#000099">html source code for your counters</font></b></font></td>
    </tr><tr><td align="center" bgcolor="#FFFFCC"><font face="verdana, arial, geneva, helvetica"><b>Copy and paste source code</b> into relevant html pages</font></td>
    </tr><tr><td align="center" bgcolor="#FFFFFF"><font size="2" face="arial, geneva, helvetica">note: Over use of visible counters can lead to a site appearing 'amateurish'<font size="1" color="#000099"><br>To copy - right mouse button click on texts, then 'Select All', then 'Copy'</font></font></td>
    </tr></table>
  <form method="post" action="">
    <p><font face="arial, geneva, helvetica" size="2">Simple <b>HIDDEN</b> hit counter <b>without</b> display</font><br>
      <input type="text" name="onelink" size="75" maxlength="200" value="$oneline"><br>
      <font face="verdana, arial, geneva, helvetica" size="1">this is the preferred counter for most pages ( and faster loading )<br>place near the top of your html code within the &ltbody&gt; ... &lt/body&gt; tags</font></p>
    <p><font face="arial, geneva, helvetica" size="2">Hit counter <b>with <font color="#CC0000">number</font></b> display</font><br>
      <textarea name="vizwith" cols="65" rows="$ilen" wrap="OFF">$vizis</textarea><br>
      <font face="arial, geneva, helvetica" size="1">displays the count total AND updates the counter</font></p>
    <p><b><font face="arial, geneva, helvetica" size="2">NON</font></b><font face="arial, geneva, helvetica" size="2"> counting  </font><b><font face="arial, geneva, helvetica" size="2">with <font color="#CC0000">number</font></font></b><font face="arial, geneva, helvetica" size="2"> display</font><br>
      <textarea name="viznone" cols="65" rows="$ilen" wrap="OFF">$vizno</textarea><br>
      <font face="arial, geneva, helvetica" size="1">displays the count total without updating the counter<br>useful for your non-public webmasters utility-links page</font></p>
    <p><font face="arial, geneva, helvetica" size="2">Hit counter  <b>with <font color="#CC0000">time</font></b> display</font><br>
      <textarea name="timewith" cols="65" rows="$ilen" wrap="OFF">$tmeis</textarea><br>
      <font face="arial, geneva, helvetica" size="1">displays the time AND updates the counter</font></p>
    <p><b><font face="arial, geneva, helvetica" size="2">NON</font></b><font face="arial, geneva, helvetica" size="2"> counting  </font><b><font face="arial, geneva, helvetica" size="2">with <font color="#CC0000">time</font></font></b><font face="arial, geneva, helvetica" size="2"> display</font><br>
      <textarea name="timenone" cols="65" rows="$ilen" wrap="OFF">$tmeno</textarea><br>
      <font face="arial, geneva, helvetica" size="1">displays the time  without updating the counter</font></p>
    <p><font face="arial, geneva, helvetica" size="2"><b>SSI</b> Server Side Include html imbedded <b>text counter</b><br>
      <font face="courier,courier new" color="#0000CC">&lt;!--#exec cgi="/cgi-bin/logcnt.cgi"--&gt;</font><br>If your site allows SSI cgi calls, the path to the program should be<br><u>relative to the page</u> the call is imbedded in.</font></p>
  </form><p><font face="arial, geneva, helvetica" size="2"><a href="#top">page top</a></font></p>
  <p><font face="arial, geneva, helvetica"><b><font color="#990000">Click here <a href=\"$logScrpt\?l=$theword\">to return</a> to your admin page</font></b></font></p>
</center></body></html>
EOT
exit;
}
sub admwd {
	&r_acnt;
	if (!$FORM{'admwrd'} && !$acnt) {return;}
	elsif (crypt($FORM{'admwrd'}, substr($FORM{'admwrd'},2,2)) ne $acnt) {&showErr('Incorrect ADMIN Password');}
}
sub r_lnx {
	if (!open (LINKS, "<$lnk_url")) {&showErr("Link File Access");}
      eval"flock (LINKS, 2)";
		@lns = <LINKS>;
      eval"flock (LINKS, 8)";
	close (LINKS);
}
sub w_lnx {
	if (!open (LINKS, ">$lnk_url")) {&showErr("Link File Access");}
      eval"flock (LINKS, 2)";
		print LINKS sort @lns;
      eval"flock (LINKS, 8)";
	close (LINKS);
}
sub eds {
	&admwd;
if ($FORM{edlog}) {
	if ($FORM{deldates} eq "d" && $FORM{dlist}) {
	local(@fileout);
		open(MAINlog, $log_url) || &showErr('Log File Access');
 		eval"flock (MAINlog, 2)";
			@fileinput = <MAINlog>;
		eval"flock (MAINlog, 8)";
		close(MAINlog);
	$s2 = 0;
	foreach $s1(@fileinput) {
		chomp($s1);
		if ($s1 =~ /$FORM{'dlist'}/) {$s2 = 1;}
		if ($s1 !~ /$FORM{'dlist'}/ && $s2) {push(@fileout,$s1."\n");}
	}
	if (!$s2) {&showErr('No Matching Dates Found');}
	if (@fileout) {
		open(MAINlog, ">$log_url") || &showErr('Unable to Overwrite Log File');
 		eval"flock (MAINlog, 2)";
			print MAINlog @fileout;
		eval"flock (MAINlog, 8)";
		close(MAINlog);
	} 
	$fsize = ( -s "$log_url");
	if (!$fsize) {&showErr('Critical Error!<br>Review Your Hit Page');}
	if (!@fileout) {&showErr('NO Records were Removed');}
	$rsltpnl = '<p><font face="arial,geneva,helvetica" color="#CC0000" size="2"><b>Log Pruning comeplete</b></font></p>';
	$FORM{'l'} = $theword; goto jmpin;
	} 
	elsif ($FORM{deldates} eq "k") {
		open(MAINlog, ">$log_url") || &showErr('Unable to Open Log File');
		close(MAINlog);
		$fsize = ( -s "$log_url" );
	if ($fsize) {&showErr('Failure, Log File Not Empty!');}
	$rsltpnl = '<p><font face="arial,geneva,helvetica" color="#CC0000" size="2"><b>All Log Records were Deleted</b></font></p>';
	$FORM{'l'} = $theword; goto jmpin;
	} 
else {&showErr('Please check your Edit Options');}
}
elsif ($FORM{'gmted'} eq "y") {
	if ($FORM{'gmt'} !~ /[0-9]/) {&showErr('<b>GMT Value Error</b>');}
	elsif ($FORM{'gmt'} > 12 || $FORM{'gmt'} < -12) {&showErr('<b>GMT Value + or - 12</b> maximum');}
		$s1 = "\$gmtPlusMinus = ".($FORM{'gmt'} * 60 * 60).";\n";
	open (GMT, "<$gmt_url") || &showErr('<b>GMTSET File Access</b>');
 	 eval "flock (GMT,2)";
		@gmtin = <GMT>;
 	 eval "flock (GMT,8)";
	close (GMT);
		$cnts = 0; $s3 = 0;
		foreach $s2 (@gmtin) {
			if ($s2 =~ /gmtPlusMinus/) {$gmtin[$cnts] = $s1; $s3 = 1; last;}
		$cnts++;
		}
		if ($s3 eq 0) {&showErr('<b>gmtset.pl Variable Not Found</b>');}
	open (GMT, ">$gmt_url") || &showErr('<b>GMTSET File Access</b>');
 	 eval "flock (GMT,2)";
		print GMT @gmtin;
 	 eval "flock (GMT,8)";
	close (GMT);
	$gmtPlusMinus = $FORM{'gmt'} * 60 * 60;
	$rsltpnl = '<p><font face="arial,geneva,helvetica" color="#CC0000" size="2"><b>New GMT Value Saved</b></font></p>';
	$FORM{'l'} = $theword; goto jmpin;
}
elsif ($FORM{'vdychange'} eq "y") {
		if ($FORM{'vdys'}) {$s1 = "\$shwDays7 = \"1\";\n";}
		else {$s1 = "\$shwDays7 = \"\";\n";}
	open (CFG, "<$cfg_url") || &showErr('<b>CONFIG File Access</b>');
 	 eval "flock (CFG,2)";
		@cfgin = <CFG>;
 	 eval "flock (CFG,8)";
	close (GMT);
		$cnts = 0; $s3 = 0;
		foreach $s2 (@cfgin) {
			if ($s2 =~ /\$shwDays7/) {$cfgin[$cnts] = $s1; $s3 = 1; last;}
		$cnts++;
		}
		if ($s3 eq 0) {&showErr('<b>$shwDays7 Variable Not Found</b>');}
	open (CFG, ">$cfg_url") || &showErr('<b>CONFIG File Access</b>');
 	 eval "flock (CFG,2)";
		print CFG @cfgin;
 	 eval "flock (CFG,8)";
	close (CFG);
	$shwDays7 = $FORM{'vdys'};
	$rsltpnl = '<p><font face="arial,geneva,helvetica" color="#CC0000" size="2"><b>New Dates-to-View Value Saved</b></font></p>';
	$FORM{'l'} = $theword; goto jmpin;
}
elsif ($FORM{'edwrd'}) {
	if ($FORM{'newwrd'} !~ /^\w{3,}$/) {&showErr("Use minimum 3 Alpha-Numeric characters only<BR>( a to z, A to Z, 0 to 9, and _ )");}
	if ($FORM{'newwrd'} ne $FORM{'newwrd2'}) {&showErr('New Password Entries Do Not Match');}
	elsif (length ($FORM{'newwrd'}) > 15 || length ($FORM{'newwrd2'}) > 15) {&showErr('15 characters Maximum');}
	elsif (!$FORM{'newwrd'} && !$acnt) {&showErr('No Changes Requested');}
	elsif (crypt($FORM{'newwrd'}, substr($FORM{'newwrd'},2,2)) eq $acnt) {&showErr('No Changes Requested');}
	$newrd = crypt($FORM{'newwrd'}, substr($FORM{'newwrd'},2,2));
	&w_acnt;
	$rsltpnl = '<p><font face="arial,geneva,helvetica" color="#CC0000" size="2"><b>New ADMIN Password Installed</b></font></p>';
	$FORM{'l'} = $theword; goto jmpin;
} 
else {
	$rsltpnl = '<p><font face="arial,geneva,helvetica" color="#CC0000" size="2"><b>Editing Options were NOT recognised</b></font></p>';
	$FORM{'l'} = $theword; goto jmpin;	}
}
sub r_acnt {
	if (!(-e "$pwrd_url")) {open(ACCNT, ">$pwrd_url");}
	else {open(ACCNT, "<$pwrd_url") || &showErr("Unable to Read Admin PassWRD File");}
		$acnt = <ACCNT>;
		chomp ($acnt);
	close(ACCNT);
}
sub w_acnt {
	open(ACCNT, ">$pwrd_url") || &showErr('Unable to Write Admin PassWRD File');
		 print ACCNT $newrd;
	close(ACCNT);
}
sub lnxed {
	&admwd;
if ($FORM{'deladd'} eq "add") {
	if ($FORM{'newname'} !~ /^\w+$/) {&showErr("Use only Alpha-Numeric characters in Name<BR>( a to z, A to Z, 0 to 9, and _ )");}	
	if (length($FORM{'newname'}) > 20) {&showErr("Maximum Name_Length is 20 characters");}	
	if ($FORM{'newurl'} =~ /\s+/) {&showErr("Do not use spaces etc in URLs");}	
	if (length($FORM{'newurl'}) > 200) {&showErr("Maximum URL_Length is 200 characters");}
	&r_lnx;
	$s1 = 0;
	foreach $ln (@lns) {if ($ln =~ /^$FORM{'newname'}\|/i) {$s1 = 1; last;}  }
	if ($s1) {&showErr("Link_Name Already Exists in list");}
	else {push(@lns,"$FORM{'newname'}|$FORM{'newurl'}|0\n");}
	&w_lnx;
		$fsize = ( -s "$lnk_url" );
	if (!$fsize) {&showErr('Critical Failure. Contact Host');}
	$rsltpnl = '<p><font face="arial,geneva,helvetica" color="#CC0000" size="2"><b>New Link successfully added</b></font></p>';
	$FORM{'l'} = $theword; goto jmpin;
}
elsif ($FORM{'deladd'} eq "del") {
	if (length($FORM{'oldname'}) > 20) {&showErr("Maximum Name_Length is 20 characters");}	
	($FORM{'newurl'}) = "";
	&r_lnx;
	$s1 = 0;
	for($cnt = 0; $cnt < @lns; $cnt++) {
		if ($lns[$cnt] =~ /^$FORM{'oldname'}\|/i) {splice(@lns,$cnt,1); $s1 = 1; last;}
	}
	if (!$s1) {&showErr("Link_Name Not Found");}
	&w_lnx;
		$fsize = ( -s "$lnk_url" );
	if (!$fsize) {&showErr('Critical Failure. Contact Host');}
	$rsltpnl = '<p><font face="arial,geneva,helvetica" color="#CC0000" size="2"><b>Link_Name successfully Removed</b></font></p>';
	$FORM{'l'} = $theword; goto jmpin;
}
elsif ($FORM{'deladd'} eq "delrst") {
	if (length($FORM{'oldname'}) > 20) {&showErr("Maximum Name_Length is 20 characters");}	
	($FORM{'newurl'}) = "";
	&r_lnx;
	$s1 = 0;
	for($cnt = 0; $cnt < @lns; $cnt++) {
		@flds = split(/\|/,$lns[$cnt]);
		if (uc $flds[0] eq uc $FORM{'oldname'}) {
		$lns[$cnt] = "$flds[0]|$flds[1]|0\n";
		$s1 = 1; last;}
	}
	if (!$s1) {&showErr("Link_Name Not Found");}
	&w_lnx;
		$fsize = ( -s "$lnk_url" );
	if (!$fsize) {&showErr('Critical Failure. Contact Host');}
	$rsltpnl = '<p><font face="arial,geneva,helvetica" color="#CC0000" size="2"><b>Link_Count successfully Reset</b></font></p>';
	$FORM{'l'} = $theword; goto jmpin;
}	
elsif ($FORM{'deladd'} eq "deled") {
	if ($FORM{'oldname'} !~ /^\w+$/) {&showErr("Use only Alpha-Numeric characters in Name<BR>( a to z, A to Z, 0 to 9, and _ )");}	
	if (length($FORM{'oldname'}) > 20) {&showErr("Maximum Name_Length is 20 characters");}	
	if ($FORM{'newurl'} =~ /\s+/) {&showErr("Do not use spaces etc in URLs");}	
	if (length($FORM{'newurl'}) > 200) {&showErr("Maximum URL_Length is 200 characters");}
	&r_lnx;
	$s1 = 0;
	for($cnt = 0; $cnt < @lns; $cnt++) {
		@flds = split(/\|/,$lns[$cnt]);
		if (uc $flds[0] eq uc $FORM{'oldname'}) {
		chomp($flds[2]);
		$lns[$cnt] = "$flds[0]|$FORM{'newurl'}|$flds[2]\n";
		$s1 = 1; last;
		}
	}
	if (!$s1) {&showErr("Link_Name Not Found");}
	&w_lnx;
		$fsize = ( -s "$lnk_url" );
	if (!$fsize) {&showErr('Critical Failure. Contact Host');}
	$rsltpnl = '<p><font face="arial,geneva,helvetica" color="#CC0000" size="2"><b>Link_URL Edit successful</b></font></p>';
	$FORM{'l'} = $theword; goto jmpin;
}	
else {&showErr('Edit Request Not Recognised');}
exit;	
}
sub do_get {
	&r_lnx;
foreach $listin (@lns) {
	if ($listin =~ /^$FORM{'htm'}\|/) {
	($c1) = split(/\|/,$listin);
		$box = "&lt;a href=&quot;$countScrpt?l=$c1&quot;&gt;object&lt;/a&gt;";
		$nofind = 1;
		last;
	}	}
	if (!$nofind) {$shwget = "<P><FONT SIZE=\"2\" FACE=\"arial,helvetica,geneva\">The Link Name <b>$FORM{'htm'}</b> could not be found.</FONT></p>";}
	else {
		($sname = $ENV{'SCRIPT_NAME'}) =~ s/^([^\.].*)\.//;
		if ($ENV{'SCRIPT_NAME'} =~ m/^(\/.*\/)/ || $ENV{'SCRIPT_NAME'} =~ m/^(\\.*\\)/) {$bin = $1;}
		else {$bin = "/???/";}
		$rname = "$FORM{'htm'}.$sname";
		$shwget = "<P><FONT SIZE=\"2\" FACE=\"arial,helvetica,geneva\">Here is the hyperlink tag for your <b>$FORM{'htm'}</b> link.</P><P><b>Copy the code from this text box</b></FONT><BR><INPUT TYPE=\"text\" VALUE=\"$box\" SIZE=\"65\"><FONT SIZE=\"1\" FACE=\"arial,helvetica,geneva\"><br>drag cursor over tag (highlight), then right mouse button click - 'Copy'</font></P>\n";
	    $shwget .= '<blockquote><p><font face="arial, geneva, helvetica" size="2"><b>SSI utilities</b></font></p>'."\n";
        $shwget .= "<p><input type=\"text\" size=\"55\" value=\"&lt;!--#exec cgi=&quot;$bin$rname&quot;--&gt;\"><br>\n";
        $shwget .= "<font size=\"2\" face=\"arial, geneva, helvetica\">Copy and rename the &quot;<b>linkname.cgi</b>&quot; script to <b>$rname</b> (chmod 755), and use the above tag in an SSI page. The <font color=\"#000099\"><b>click total</b></font> will display as text.</font><br>\n";
        $shwget .= "OR<br><input type=\"text\" size=\"55\" value=\"&lt;!--#exec cgi=&quot;$bin$rname&quot;--&gt;\"><br>\n";
        $shwget .= "<font face=\"arial, geneva, helvetica\" size=\"2\">Copy and rename the &quot;<b>linkcount.cgi</b>&quot; script to <b>$rname</b> (chmod 755), and use the above tag in an SSI page. The <font color=\"#000099\"><b>hyperlink <u>plus</u> click total</b></font> will display as text.</font></p></blockquote>\n";}

	print "Content-type: text/html\n\n";
print <<EOT;
<HTML><HEAD>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<TITLE>Link HTML Code</TITLE>
</HEAD><BODY BGCOLOR="#FFFFFF" TEXT="#000000" LINK="#0000FF">
<P>&nbsp;</P><CENTER><TABLE width="570" BORDER="0" CELLSPACING="0" CELLPADDING="0" BGCOLOR="#999966"><TR><TD ALIGN="CENTER" BGCOLOR="#999966">
<B><FONT COLOR="#ffffff" FACE="arial,helvetica,geneva">Your Hyperlink Sample</FONT></B></TD> 
</TR><TR><TD ALIGN="CENTER" BGCOLOR="#FFFFCC"><TABLE BORDER="0" CELLSPACING="0" CELLPADDING="6" width="100%" >
<TR><TD ALIGN="CENTER" width="100%" BGCOLOR="#f0f0f0"><FORM>
$shwget</FORM></TD> 
</TR></TABLE></TD></TR><TR><TD BGCOLOR="#666666" NOWRAP ALIGN="CENTER">
&nbsp;<FONT COLOR="#ffffff" SIZE="2" FACE="arial,helvetica,geneva"><b>CLOSE This Window to display the admin page</b><BR><FONT 
SIZE="-2" color="#FFFFCC">LogLook v3.5d Copyright 1999 - HostingNet</FONT></FONT>&nbsp;</TD> 
</TR></TABLE></CENTER></BODY></HTML>
EOT
exit;
}
sub is_referer_ok {
	$check_referer = 0;
	if ($ENV{'HTTP_REFERER'}) {
        foreach $referer (@referers) {
            if ($ENV{'HTTP_REFERER'} =~ m|\Ahttps?://$referer|i) {
                $check_referer = 1;
                return;
   }	}	}
	&showErr('Bad Referer - offsite access denied');
}
sub date_time {
	my $which = $_[0] ; 
	if ($which eq 0) {
		($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = (localtime)[0,1,2,3,4,5,6,7];}
	elsif ($which eq 1)  { 
		($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = (gmtime(time + $gmtPlusMinus))[0,1,2,3,4,5,6,7];}
	if ($year < 38) { $year = "20$year" }
		elsif ($year > 99) { $year = 2000 + ( $year - 100 ) }
		elsif ($year > 37) { $year = "19$year" }
	if ($dtUS eq "1") {return sprintf("%02d\/%02d\/%04d %02d:%02d:%02d",$mon + 1,$mday,$year,$hour,$min,$sec);}
	elsif ($dtUS eq "2") {return sprintf("%02d\/%02d\/%04d %02d:%02d:%02d",$year,$mon + 1,$mday,$hour,$min,$sec);}
	else {return sprintf("%02d\/%02d\/%04d %02d:%02d:%02d",$mday,$mon+1,$year,$hour,$min,$sec);}
}
sub check_method {
	if ( $ENV{'REQUEST_METHOD'} eq 'GET' ) {$query_string = $ENV{'QUERY_STRING'};} 
	elsif ( $ENV{'REQUEST_METHOD'} eq 'POST' ) {read(STDIN,$query_string, $ENV{'CONTENT_LENGTH'});} 
	else {&showErr('Wrong Request Method');}
}
sub pwrd {
	if ($_[0] ne $theword) {&showErr('Incorrect Access Password');}
	else {return 1;}
}
sub showErr {
	print "Content-type: text/html\n\n";
	print <<EOT;
 <html><head><meta name="author" content="Ron F Woolley 1998 - www.dtp-aus.com">
   <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
   <title>Error Response</title></head>
   <body bgcolor="#FFFFFF" text="#000000" link="#0000FF" vlink="#0000FF" alink="#FF0000">
	<center><p>&nbsp;</p><table width="380" border="0" cellspacing="0" cellpadding="2"><tr bgcolor="#FFFFFF">
        <td><font face="verdana, arial, geneva, helvetica"><b>LogLook Viewer</b> Error Response</font></td></tr></table>
      <table border="0" cellspacing="0" cellpadding="1"><tr bgcolor="#FFFFFF">
        <td><font size="2" face="arial,helvetica,geneva">
	  <p align="center"><b>The program has responded with an <font color="#FF0000">error</font>.</b></p></font>
          <dl><dt><font size="2" face="arial,helvetica,geneva">The result is:</font></dt>
            <dd><font size="2" face="arial,helvetica,geneva"><font color="#CC0000"><b>$_[0]</b></font></font></dd></dl></td>
      </tr><tr bgcolor="#666666" align="center">
        <td><font size="2" face="arial,helvetica,geneva" color="#FFFFFF">&nbsp;&nbsp;Use your <b>Back Arrow</b> to return. <em>Thank you.&nbsp;&nbsp;</em></font></td>
  </tr></table></center</body></html>
EOT
exit;
}
