#!/usr/bin/perl

# DO NOT EDIT code below this line!!

# The first line above must be a call to the location of your PERL 5 program.
# This MUST BE CORRECT - view installed scripts or consult Hosts Manual.
# FTP upload as an ASCII file to your CGI-BIN and set permissions to chmod 755
# Call as "http://www.yourdomain.name/cgi-bin/testbin.cgi

#copyright Ron F Woolley 1999

	print "Content-Type: text/html\n\n";
open (FLE, $0);@p1 = <FLE>;close (FLE);
($pl = $p1[0]) =~s/\n//g if $p1[0] =~ /^#!\//;
if (-e "C:/" || $^O =~ /MSWin32/i) {$is32 = " on Win32:NT!";}

	if ($] =~ /^5/ && !$is32) {
$t1 = "<p>If you can read this page then the cgi-bin and<br>
this script have executed without errors. Your<br>
CGI-BIN is set up and working correctly.

<p>If installing dtp-aus.com scripts, you can now <br>
try the makedir.cgi script to create directories<br>
and empty files, ready for FTP uploading of all<br>
the files supplied (see readme.htm)."; }
	elsif ($] && $] !~ /^5/ && !$is32) {
$t1 = "<p>If you can read this page then the cgi-bin and<br>
this script have executed without errors. Your<br>
CGI-BIN is set up and working correctly.

<p><font color=#FF0000>However, $pl is<br>
is NOT calling Perl versions 5. My dtp-aus.com <br>
scripts are written for Perl Version 5. Contact<br>
your Host Service for the correct path to Perl 5<BR>
on your server.</font>"; }
	elsif ($is32) {
$t1 = "<p><font color=#FF0000>My dtp-aus.com Perl 5 scripts are not written for<br>
<B>MS NT</B>, nor do they currently receive any support<br>
for that operating system.</font>

<p>But, if you can read this page then the cgi-bin<br>
and this script have executed without errors. Your<br>
CGI-BIN is set up and working correctly."; }
	elsif (!$]) {
$t1 = "<p><font color=#FF0000><B>Your Perl Version could not be ascertained<br>
for installation verification.</B></font> 

<p>But, if you can read this page then the cgi-bin<br>
and this script have executed without errors. Your<br>
CGI-BIN is set up and working correctly."; }
	else {$t1 = "<p><font color=#FF0000><B>Details could not be ascertained.</B></font>";}
print <<EOT;
<html><head><title>Unix CGI-BIN Perl 5 Test</title>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
</head>
<body bgcolor=#d5d5d5 text=#000000>
<p>&nbsp;<font face=courier new,courier>
<center><table border=0 cellspacing=0 cellpadding=2><tr><td align=center bgcolor=#cc0000>
<font size=4 color=#ffffff><b>$pl<BR>Perl $]$is32</b></font></td></tr><tr><td align=center 
bgcolor=#cc0000><table border=0 cellspacing=0 cellpadding=6><tr><td nowrap bgcolor=#ffffff>
$t1
<p><em>Thank You</em><BR>Ron Woolley - <small><small>www.dtp-aus.com / www.hostingnet.com</small></small>
</td></tr></table></td></tr></table></font>
</body></html>
EOT
exit(0);
