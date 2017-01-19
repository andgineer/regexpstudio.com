#!/usr/bin/perl

##########################################################################
# An IMG SRC, SSI and A HREF(links) called script that saves to common   #
# log files also used by the Loglook.cgi log viewer, SSI count viewer.   #
# DO NOT use this script without first reading the accompanying README   #
# TEXTS                                                                  #
##########################################################################
# This script "LOGCNT.CGI" written (and ©) by Ron F Woolley, Melbourne   #
# Australia. Copyright 1998'99. This free to use script can be altered   #
# for personal use, BUT all of this header text MUST REMAIN intact as    #
# is, AND, using this script without first reading the accompanying      #
# README file(s), is prohibited.                                         #
#                                                                        #
# The scripts and associated files REMAIN the property of Ron F Woolley. #
# NO PROFIT what so ever is to be gained from users of these scripts     #
# for installation of these scripts or any other purpose, except that a  #
# reasonable minimal charge for installation MAY be allowed when         #
# installed on the uers behalf. One copy only is allowed only on a users #
# web site. Supply of each copy of this program is allowed directly from #
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
# HELP page at:                                                          #
#    http://www.dtp-aus.com/cgiscript/scrpthlp.htm                       #
# Files from:                                                            #
#    http://www.dtp-aus.com/cgiscript/cntscrpt.shtml                     #
##########################################################################
# THESE FILES can only be obtained via the above web addresses,and MUST  #
# NOT BE PASSED ON TO OTHERS in any form by any means what so ever. This #
# DOES NOT contradict any other statements above.                        #
# EACH USER SITE MUST OBTAIN THESE FILES from URL above.                 #
##########################################################################
#                     VERSION 3.5e November 1999                         #
#   Once installed, please respond with system type and general          #
#   information to webmaster@dtp-aus.com.                                #
##########################################################################

#--- Alter these two paths only, if needed! ---------------------#
	require "sets/gmtset.pl"; 
	require "sets/cntcnfg.pl";
#--- Do Not make any changes below this line. -------------------#

	if ( $ENV{'DOCUMENT_URI'} ) { &do_ssi; }
		&check_method;
	$pn = substr($query_string,0,1);
		&ref_ok;
	if ($pn eq "l" || $pn eq "L") {&do_link;}
	elsif ($pn =~ /^(c|n)/) {&do_clock(substr($query_string,1,1));}
		&sg_count;
	if ($pn eq "t") {
		&sendFile($img_url."trans.gif", "image/gif");
		&do_log ;
	} elsif ($pn eq "0") {
		local($digit) = substr($cnb,0,1);
		&sendFile($img_url.$digit.".gif", "image/gif");
		&do_log ;
	} elsif ($pn eq "v") {
		local($digit) = substr($cnb,0,1);
		&sendFile($img_url.$digit.".gif", "image/gif");
	} elsif ($pn =~ /[1-7]/) {
		local($digit) = substr($cnb,$pn,1);
		&sendFile($img_url.$digit.".gif", "image/gif");
	}		
exit;
sub do_ssi {
	&sg_count;
	if ($cnb eq 0 || $cnb eq "") {$cnb = "???";}
		$cnb =~ s/^(0+)// if !$ssi_zro;
	if (!$ssi_img) {
		print "Content-type: text/html\n\n";
		print "$cnb";
	}
	else {
		for($cnt = 0; $cnt <= length($cnb) - 1; $cnt++) { 
			$digit = substr($cnb,$cnt,1);
			print "<img \n src=\"$ssi_url/$digit.gif\" width=\"$iwid\" height=\"$ihgt\" border=\"0\">";
	}	}
	$ENV{'HTTP_REFERER'} = $ENV{'DOCUMENT_URI'};
	&do_log;
exit;
}
sub sg_count {
	if (!open (COUNT, "+<$count_url")) {$err = "Count File Access"; &err_log;}
   eval"flock(COUNT, 2)";
	$cnb = <COUNT>;
	if ( $pn eq "0" || $pn eq "t" || $pn eq "c" || $ENV{'DOCUMENT_URI'} ) {
		if ($rjct !~ /(\|$ENV{'REMOTE_HOST'}\||\|$ENV{'REMOTE_ADDR'})\|/i) {$cnb = $cnb + 1;}
		seek (COUNT, 0, 0); 
		print COUNT $cnb; 
   	}
   eval"flock(COUNT, 8)";
	close (COUNT);
	chomp($cnb);
 	$cnb = (substr($iszeros,1,length($iszeros) - length($cnb)).$cnb);
}
sub do_log { 
	$pnm = $ENV{'HTTP_REFERER'} ;
	$pnm =~ s|^.*/|| ;
	$pnm =~ s/\?/-/g ;
	$pid = $pnm ;
	if ($pid =~ m/^(.*\..?(htm?l?|cgi|pl))/) {$pid = $1};
	if ($pid eq "") {$pid = "default";}
	if (($ENV{'REMOTE_ADDR'} eq $ENV{'REMOTE_HOST'} || !$ENV{'REMOTE_HOST'}) && $ENV{'REMOTE_ADDR'} =~ /(\d+)\.(\d+)\.(\d+)\.(\d+)/) {
		$pk = pack('C4', $1, $2, $3, $4);
		$cnvrt = (gethostbyaddr($pk, 2))[0];
		if ($cnvrt) {$ENV{'REMOTE_HOST'} = $cnvrt;}
	}
      if (!open (MLOG, ">>$log_url")) {$err = "Log File Access"; &err_log;} 
   eval"flock(MLOG, 2)";
      print MLOG date_time(1).", $ENV{'REMOTE_ADDR'}, $pid, $ENV{'HTTP_USER_AGENT'}, $ENV{'REMOTE_HOST'}\n";
   eval"flock(MLOG, 8)";
	close(MLOG);
}
sub do_link {
($scrap, $lnkNumb) = split(/\=/,$query_string);
	if (!open (COUNT, "+<$lnk_url")) {$err = "Links File Access"; &err_log;}
   eval"flock(COUNT,2)";
	@lns = <COUNT>;
	$cnts = 0;
	foreach $ln (@lns){
		@TL = split(/\|/,$ln);
		if ($TL[0] eq $lnkNumb) {
			$the_link = $TL[1];
			if ($pn eq "l") {
				$TL[2]++;
				$lns[$cnts] = "$TL[0]|$TL[1]|$TL[2]\n";
				seek(COUNT,0,0);
				print COUNT @lns;
				last;
		}	}
	$cnts++;
	}
   eval"flock(COUNT,8)";
close(COUNT);
	if (!($the_link eq "")) {print "Location: $the_link\n\n";}
	else { 
		print "Content-type: text/html\n\n";
		print "<html><head>\n";
		print "<meta name=\"author\" content=\"Ron F Woolley 1998-99 - www.dtp-aus.com\">\n";
		print "<meta HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\">\n";
		print "<title>Error Response</title></head>\n";
		print "<body bgcolor=\"#FFFFFD\" text=\"#333333\" link=\"#0000CC\">\n";
		print "<center><h2>Link Error Response</h2><table><tr><td align=center><font size=\"2\" face=\"arial,helvetica,geneva\"><hr>\n";
		print "<p><strong>The link you requested cannot be found.</strong><br>Please report this error to the <a href=\"$webmstr\">webmaster</a>. <em>Thank you</em></p><hr>\n";
		print "<p><em>Return with your</em> Back Arrow.</p>\n";
		print "</font></td></tr></table></center></body></html>\n";
		$err = "No Link"; &err_log; 
	exit;
	}
exit;
}
sub do_clock {
	local($digit,$chk) = ($_[0],$_[0]);
	$digit = substr(date_time(0),$digit,1);
	&sendFile($img_url.$digit.".gif", "image/gif");
	if ($pn eq "c" && $chk eq 0) {&sg_count; &do_log;}
exit;	
}
sub err_log {
	if (!open (LOG, ">>$badlog_url")) {exit;}
   eval"flock(LOG, 2)";
	print LOG date_time(1)."|$err|$ENV{'HTTP_REFERER'}|$ENV{'REMOTE_ADDR'}|$ENV{'HTTP_USER_AGENT'}\n";
   eval"flock(LOG, 8)";
	close(LOG);
	if (!($pn eq "l")) {&sendFile($img_url."trans.gif", "image/gif");}
	else {print "Content-type: text/html\n\n";
		print "Possible copyright violation. Remote link access refused!<br>Please use the actual on-site page.\n";}
exit;
}
sub ref_ok {
	$crf = 0;
	if ($ENV{'HTTP_REFERER'}) {
        foreach $referer (@referers) {
            if ($ENV{'HTTP_REFERER'} =~ m|\Ahttps?://([^/]*)$referer|i) {
                $crf = 1;
                last;
	}}	}
    if ($crf eq 0) {$err = "bad ref"; &err_log;}
}
sub sendFile {
	die("$0: sendFile called w/o File\n") unless my $File = $_[0];
	die("$0: sendFile called on $File, no type\n") unless my $type = $_[1];
	my $size = 0;
	if ( open( FILE, $File)) {  
		$size = ( -s $File);
		print "Content-type: $type\n";
		print "Content-length: $size\n\n";
		print <FILE>;
		close (FILE);
	} else {
		die("$0: sendFile died on file \"$File\" (", (0+$!), " - $!)\n");
		exit;
	}
  $size; 
}
sub date_time {
	($which,$z) = ($_[0],"a") ; 
	if (!$which) { 
		($min,$hour,$mday,$mon,$year,$wday) = (gmtime(time + $gmtPlusMinus))[1,2]; 
		if ($hour > 11) {$z = "p";}
		if ($hour > 12) {$hour = $hour - 12;}
		return sprintf("%02d-%02d$z",$hour,$min);
	}
	elsif ($which)  { 
		($sec,$min,$hour,$mday,$mon,$year,$wday) = (gmtime(time + $gmtPlusMinus))[0,1,2,3,4,5,6];
	}
	if ($year < 38) {$year = "20$year";}
		elsif ($year > 99) {$year = 2000 + ($year - 100);}
		elsif ($year > 37) {$year = "19$year";}
	if ($dtUS eq "1") {return sprintf("%02d\/%02d\/%04d %02d:%02d:%02d",$mon + 1,$mday,$year,$hour,$min,$sec);}
	elsif ($dtUS eq "2") {return sprintf("%02d\/%02d\/%04d %02d:%02d:%02d",$year,$mon + 1,$mday,$hour,$min,$sec);}
	else {return sprintf("%02d\/%02d\/%04d %02d:%02d:%02d",$mday,$mon + 1,$year,$hour,$min,$sec);}
}
sub check_method {
	local($request_method) = $ENV{'REQUEST_METHOD'};
	if ( $request_method eq 'GET' ) { 
		$query_string = $ENV{'QUERY_STRING'};  
	} elsif ( $request_method eq 'POST' ) { 
 		read(STDIN,$query_string, $ENV{'CONTENT_LENGTH'}); 
	} else {
		$err = "bad Method"; &err_log;       
	}
   return
}
