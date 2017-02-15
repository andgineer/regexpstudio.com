#### adding/subtracting zeros alters length of visible counters ---#
$iszeros = "0000";

#### Select British ("0"), US ("1"), Internat ("2") date pattern --#
$dtUS = "2";

#### An array of accepted referers domain names / IP#s ------------#
@referers = ('anso.virtualave.net',);   

#### An array of rejected domain names / IP#s ---------------------#
$rjct = "";

#### Path to Records and Counter Images, SEE readme.txt file ------#
$cfg_url = "sets/cntcnfg.pl";
$gmt_url = "sets/gmtset.pl";
$count_url = "counters/hitcount.t";
$log_url = "counters/hitlog.t";
$lnk_url = "counters/hitlnk.t";
$badlog_url = "counters/hitbadlog.t";
$pwrd_url = "counters/look.pwd";
$img_url = "counters/";
$ssi_img = 0;
$ssi_zro = 1;
$iwid = 13;
$ihgt = 17;

#### URL to the images for SSI img display only (see readme) ------#
$ssi_url = "http://anso.virtualave.net/log_img";

#### URL of the prefered return page (Home)------------------------#
$hm_url = "http://regexpstudio.com/index.html";

#### URL of the LOGLOOK.CGI log viewer script ---------------------#
$logScrpt = "http://anso.virtualave.net/cgi-bin/loglook.cgi";

#### URL of the LOGCNT.CGI log viewer script ----------------------#
$countScrpt = "http://anso.virtualave.net/cgi-bin/logcnt.cgi";

#### E-Mail address of the Webmaster ------------------------------#
$webmstr = "mailto:anso\@mail.ru?subject=LogCount Link Error";

#### Display either last 2 (""), or last 7 days ("1") -------------#
$shwDays7 = "1";

#### Show Referer Domain Names, SEE readme.txt file ---------------#
$showDoms = "1";

#### Enter a Password or leave blank(""), SEE readme.txt file -----#
$theword = "mastervoice";

1;	# this line MUST remain in all 'require' files.
