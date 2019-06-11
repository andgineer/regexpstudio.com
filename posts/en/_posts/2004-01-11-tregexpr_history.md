---
layout: redirected
redirect_to: https://regex.sorokin.engineer/en/latest/index.html
sitemap: false
lang: en
ref: tregexpr_history
comments: false
title: "TRegExpr history"
---

Legend:
* (+) - new feature
* (-) - bugfix
* (^) - improvement

 v. 0.952 2004.01.11
====================
* (+) FreePascal support, thanks to Yaroslav Romanchenko (SAGE)


 v. 0.951 2002.09.29
====================
* (+) Defined constant EscChar ('\\' by default). Can be usefull for  C++
Builder users who are tired with r.e. like
'\\\\w+\\\\\\\\\\\\w+\\\\.\\\\w+'.  Now they can define for example
EscChar='/' and write '/w+\\/w+/./w+' -  sligtly unusual but more
readable.. Suggested by unonimous CPPB user.
* (+) Overloaded versions of Exec (only for Delphi 5 and higher).
* (-) ExecNext in some cases didn't raise exception if called after
unsuccessful exec\*, that is wrong (ExecNext must be called ONLY after
successful Exec\* ). Bug reported by Craig A. Peterson
* (+) ReplaceEx and overloaded version of Replace - for complex,
context-sensitive replacements. Implemented by Thor Asmund.
* (+) Use StrLCopy instead of StpPCopy - in SetExpression() as 0.927 did
in SetInputString(). Fixed by Maley, Scott D.
* (-) Bug in HyperLinkDecorator.DecorateURLs.
* (-) Delphi 2 compatibility restored.
* (^) Delphi 7 compatibility tested, Ok.
* (+) New demos.
* (^) Documentation and distribution package were reorganized.

 v. 0.948 2002.01.03
====================
* (-) back-offset calculation in UniCode version due to Delphi's
PWideChar subtraction 'feature' (produced
* Integer overflow (if Overflow checking is on) and, sometimes, wrong
operation), bug reported by Craig A. Peterson
* (-) Bug that was found by Lars Karlslund was fixed by Martin Fuller (in
addition Martin made some excellent source code optimizations). The bug
was: "If I do '(something|^$)' on '' I get false (which is  wrong
...).". Fixed ExecPrim (empty strings were not allowed to pass  thru in
UseFirstCharSet mode) and FillFirstCharSet (many bugs).
* (-) Visualization bug in Dump method. Fixed by Martin Fuller.

 v. 0.947 2001.10.03
====================
* (+) [Word boundary](regexp_syntax.html#syntax_word_boundaries) (\\b &
\\B) metachar
* (-) Bug in processing predefined char.classes in non-UseSetOfChar mode
* (+) Spanish help - translated by Diego Calp (mail@diegocalp.com),
Argentina
* (+) [VersionMajor/Minor](tregexpr_interface.html#tregexpr.version)
class method of TRegExpr ;)
* (-) Bug in CompileRegExpr, Thanks to Oleg Orlov
&lt;orlov@diasoft.ru&gt;
* (^) Method RegExprSubExpressions wasn't compatible with D2-D3.
 Thanks to Eugene Tarasov for bug report.
* (+) [Method Replace](tregexpr_interface.html#tregexpr.replace) can now
do substitution as well
 Thanks to Warren Bare, Ken Friesen and many others who suggested it.
* (+) Updated ReplaceRegExpr to use new Replace method functionality
* (^) Restored UniCode compatibility lost in some previous version
 Thanks to Stephan Klimek for bug report
* (^) Updated TestRE project, new examples for Replace with substitution
included.

v. 0.942+ 2001.03.01
====================
* (+) Published French help for TRegExpr, translated by Martin Ledoux,
Quebec, Canada.

v. 0.942 2001.02.12
===================
* (-) Range-check error in DEMO-project (due to bug in
RegExprSubExpressions), Thanks to Juergen Schroth
* (^) RegExprSubExpressions - added error codes for "unclosed "\[" error
* (^) Help file bug fixing

 v. 0.941 2001.02.01
====================
* (^) Attension! Behaviour of '\\w', '\\W' was changed! Now it really
 match alphanum characters and '\_' as described in documentation,  not
only alpha as it was before. Thanks to Vadim Alexandrov.
If You want to restore previous behaviour, reassign  RegExprWordChars
(exclude '0123456789' from it).
* (+) Full compatible with recommended at unicode.org implementation  of
[modifier /m](regexp_syntax.html#modifier_m), including DOS-styled line
separators (\\r\\n) mixed  with Unix styled (\\n) - see properties
[LineSeparators](regexp_syntax.html#syntax_line_separators),
LinePairedSeparator
* (^) Attension! Behaviour of '.' was changed! Now if [modifier
/s](regexp_syntax.html#modifier_s) is off  it doesn't match all chars
from [LineSeparators](regexp_syntax.html#syntax_line_separators) and
LinePairedSeparator (by  default \\r and \\n)
* (^) Attension! To prevent unneeded recompilation of r.e., now
assignment  to Expression or changing modifiers doesn't cause immidiate
\[re\]compilation.  So, now You don't get exception while assigning
wrong expression, but can  get exception while calling Exec\[Next\],
Substitute, Dump, etc if there  are errors in Expression or other
properties.
* (+) Non-greedy style
[iterators](regexp_syntax.html#metacharacters_iterators) (like '\*?'),
[modifier /g](regexp_syntax.html#modifier_g).  Implemented with help
from Matthew Winter and Filip Jirsбk
* (+) [modifier /x](regexp_syntax.html#modifier_x) (eXtended syntax -
allow formating r.e.)
* (+) Procedure Compile to \[re\]compile r.e. Usefull for GUI r.e.
editors  and so on (to check all properties validity).
* (+) [FAQ](faq.html) in documentation. I am too tired to answer to the
same  questions again and again :(
* (^) [DEMO project](#regexpstudio.html) have been significantly
improved. Now this is the  real r.e. debugger! Thanks to Jon Smith for
his ideas.
* (+) function RegExprSubExpressions, usefull for GUI editors of  r.e.
(see example of using in TestRExp.dpr project)
* (+) [HyperLinkDecorator](#hyperlinksdecorator.html) unit - practical
example of TRegExpr using
* (-) Range checking error in some cases if ComplexBraces defined  Thanks
to Juergen Schroth
* (^) 'ComplexBraces' now is defined by default
* (+) Kit Eason sent to me many examples for
"[syntax](regexp_syntax.html)" help section and I decided to complitely
rewrite this section. I hope, You'll enjoy the results ;)
* (+) The \\A and \\Z metacharacters are just like "^'' and "$'', except
that they won't match multiple times when the [modifier
/m](regexp_syntax.html#modifier_m) is used

 v. 0.938 2000.07.23
====================
* (^) Exeptions now jump to appropriate source line, not to Error
procedure (I am not quite sure this is safe for all compiler versions
(PLEASE, LET ME KNOW about any problems with this). You can turn it off - remove reRealExceptionAddr definition from regexpr.pas).
* (^) Forgotten BSUBEXP\[CI\] in FillFirstCharSet caused exeption 'memory
corruption' in case if back reference can be first op, like this:
(a)\*\\1 (first subexpression can be skipped and we'll start matching
with back reference..).

 v. 0.937 2000.06.12
====================
* (-) Bug in optimization engine (since v.0.934). In some cases TRegExpr
didn't catch right strings.
    Thanks to Matthias Fichtner

 v. 0.936 2000.04.22
====================
* (+) Back references, like '&lt;font size=(\['"\]?)(\\d+)\\1&gt;' see
[syntax description](regexp_syntax.html)
* (+) Wide hex char support, like '\\x{263a}'

 v. 0.935 2000.04.19 (by Yury Finkel)
=====================================
* (-) fInvertCase now isn't readonly ;)
* (-) UniCode mode compiling errors

 v. 0.934 2000.04.17
====================
* (^) New ranges implementation (range matching now is very fast - uses
one(!) CPU instruction)
* (^) Internal p-code structure converted into 32-bits - works faster and
now there is no 64K limit for compiled r.e.
* (^)'{m,n}' now use 32-bits arguments (up to 2147483646) - specially for
Dmitry Veprintsev ;)
* (^) Ranges now support metachars: \[\\n-\\x0D\] -&gt;
\#10,\#11,\#12,\#13; Changed '-' processing, now it's like in Perl:
\[\\d-t\] -&gt; '0'..'9','-','t'; \[\]-a\] -&gt; '\]'..'a'
* (-) Bug with \\t and etc macro (they worked only in ranges) Thanks to
Yury Finkel
* (^) Added new preprocessing optimization (see FirstCharSet). Incredible
fast (!). But be carefull it isn's properly tested. You can switch it
Off - remove UseFirstCharSet definition.
* (^) Many other speed optimizations
* (-) Case-insensitive mode now support system-defined national charset
(due to bug in v.0.90 .. 0.926 supported only english one)
* (^) Case-insensitive mode implemented with InvertCase (param & result
of REChar type) - works 10 .. 100 times faster.
* (^) Match and ExecNext interfaces optimized, added IsProgrammOk by Ralf
Junker
* (^) Increased max.subexpression number (NSUBEXP, now 15) and fixed code
for this, now you can simply increase NSUBEXP constant by yourself.
Suggested by Alexander V. Akimov.
* (^+) Substitute adapted for NSUBEXP &gt; 10 and significant (!)
optimized, improved error checking.  ATTENTION! Read new Substitute
description - syntax was changed !
* (+) SpaceChars & WordChars property - now you may change chars treated
as \\s & \\w. By defauled assigned RegExprSpaceChars/WordChars
* (+) Now \\s and \\w supported in ranges
* (-) Infinite loop if end of range=\#$FF Thanks to Andrey Kolegov
* (+) Function QuoteRegExprMetaChars (see description)
* (+) UniCode support - sorry, works VERY slow (remove '.' from {.$DEFINE
UniCode} in regexpr.pas for unicode version). Implemented by Yury Finkel

 v. 0.926 2000.02.26
====================
* (-) Old bug derived from H.Spencer sources - SPSTART was set for '?'
and '\*' instead of '\*', '{m,n}' and '+'.
* (-^) Now {m,n} works like Perl's one - error occures only if m &gt; n
or n &gt; BracesMax (BracesMax = 255 in this version). In other cases
(no m or nondigit symbols in m or n values,  or no '}') symbol '{' will
be compiled as literal.  Note: so, you must include m value (use {0,n}
instead of {,n}).  Note: {m,} will be compiled as {m,BracesMax}.
* (-^) CaseInsensitive mode now support ranges '(?i)\[a\]' == '\[aA\]'
* (^) Roman-number template in TestRExp ;)
* (+^) Beta version of complex-braces - like ((abc){1,2}|d){3} By default
its turned off. If you want take part in beta-testing, please, remove
'.' from {.$DEFINE ComplexBraces} in regexpr.pas.
* (-^) Removed \\b metachar (in Perl it isn't BS as in my implementation,
 but word bound)
* (+) Add /s modifier. But I am not sure that it's ok for Windows. I
implemented it as \[^\\n\] for '.' metachar in non-/s mode. But lines
separated by \\n\\r in windows. I need you suggestions !
* (^) Sorry, but I had to rename Modifiers to ModifierStr (ModifierS uses
for /s now)

 v. 0.91 2000.02.02
===================
* (^) some changes in documentation and demo-project.

 v. 0.90 2000.02.01
===================
* (+) implemented braces repetitions {min,max}. Sorry - only simple cases
now - like '\\d{2,3}' or '\[a-z1-9\]{,7}', but not (abc){2,3} .. I still
too short in time. Wait for future versions of TRegExpr or
    implement it by youself and share with me ;)
* (+) implemented case-insensitive modifier and way to work with other
modifiers - see properties     Modifiers, ModifierR, ModifierI and
[(?ismxr-ismxr)](regexp_syntax.html#inline_modifiers)Perl extension.
You may use global variables
[RegExpr\*](tregexpr_interface.html#modifier_defs) for assigning
 default modifier values.
* (+) property ExtSyntaxEnabled changed to 'r'-modifier (russian
extensions - [see documentation](regexp_syntax.html#modifier_r))
* (+) implemented [(?\#comment)](regexp_syntax.html#inline_comment)Perl
extension - very hard and usefull work ;)
* (^) property MatchCount renamed to
[SubExprMatchCount](tregexpr_interface.html#subexprmatchcount). Sorry
for any inconvenients, but it's because new version works slightly
different and if you used MatchCount in your programms you have to
rethink it ! (see comments to this property)
* (+) add InputString property - stores input string from last Exec call.
You may directly assign values to this property for using in ExecPos
method.
* (+) add ExecPos method - for working with assigned to InputString
property. You may use it like this InputString := AString; ExecPos; or
this InputString := AString; ExecPos (AOffset); Note: ExecPos without
parameter works only in Delphi 4 or higher.
* (+) add ExecNext method - simple and fast (!) way to finding multiple
occurences of r.e. in big input string.
* (^) Offset parameter removed from Exec method, if you used it in your
programs, please replace all Exec (AString, AOffset) with combination
InputString := AString; ExecPos (AOffset) Sorry for any inconvenients,
but old design (see v.0.81) was too ugly :( In addition, multiple Exec
calls with same input string produce fool overhead because each Exec
reallocate input string buffer.
* (^) optimized implementation of Substitution, Replace and Split methods
* (-) fixed minor bug - if r.e. compilation raise error during second
pass (!!! I think it's impossible in really practice), TRegExpr stayed
in 'compiled' state.
* (-) fixed bug - Dump method didn't check program existance and raised
'access violation' if previouse Exec was finished with error.
* (+) changed error handling (see functions Error, ErrorMsg, LastError,
property CompilerErrorPos, type ERegExpr).
* (-^) TRegExpr.Replace, Split and ExecNext made a infinite loop in case
of r.e. match empty-string. Now ExecNext moves by MatchLen if MatchLen
&lt;&gt; 0  and by +1 if MatchLen = 0 Thanks to Jon Smith and George
Tasker for bugreports.
* (-) While playing with null-matchs I discovered, that null-match at
tail of input string is never found. Well, I fixed this, but I am not
sure this is safe (MatchPos\[0\]=length(AInputString)+1, MatchLen = 0).
Any suggetions are very appreciated.
* (^) Demo project and documentation was upgraded
* (^) Documentation and this version was published on my home page

 v. 0.81 1999.12.25 // Merry Christmas ! :)
===========================================
* (+) \\s (AnySpace) and \\S (NotSpace) meta-symbols  - implemented by
Stephan Klimek with minor fixes by AVS
* (+) \\f, \\a and \\b chars (translates into FF, BEL, BS)
* (-) removed meta-symbols 'Ў' & 'г' - sorry for any inconvenients
* (+) Match property (== copy (InputStr, MatchPos \[Idx\], MatchLen
\[Idx\]))
* (+) extra parameter Offset to Exec method (thanks to Steve Mudford)

 v. 0.7 1999.08.22
==================
*(-) in some cases the r.e. \[^...\] incorrectly processed (as any
symbol) (thanks to Jan Korycan)
* (^) Some changes and improvements in TestRExp.dpr

 v. 0.6 1999.08.13 // Friday 13 !
=================================
* (^) changed header of TRegExpr.Substitute
* (+) Split, Replace & appropriate global wrappers (thanks to Stephan
Klimek for suggetions)

 v. 0.5 1999.08.12
==================
* (+) TRegExpr.Substitute routine
* (^) Some changes and improvements in TestRExp.dpr
* (-) Errors in english version of documentation  (Thanks to Jon
Buckheit)

 v. 0.4 1999.07.20
==================
* (-) bug with parsing of strings longer then 255 bytes  (thanks to Guido
Muehlwitz)
* (-) bug in RegMatch - mathes only first occurence of r.e.   (thanks to
Stephan Klimek)

 v. 0.3 1999.06.13
==================
* (+) ExecRegExpr function

 v. 0.2 1999.06.10
==================
* (^) packed into object-pascal class
* (^) code slightly rewriten for pascal
* (^) now macro correct proceeded in ranges
* (+) r.e.ranges syntax extention for russian letters ranges:
    * р-  - replaced with all small russian letters (Win1251)
    * L-- - replaced with all capital russian letters (Win1251)
    * р-- - replaced with all russian letters (Win1251)
* (+) macro '\\d' (opcode ANYDIGIT) - match any digit
* (+) macro '\\D' (opcode NOTDIGIT) - match not digit
* (+) macro '\\w' (opcode ANYLETTER) - match any english letter or '\_'
* (+) macro '\\W' (opcode NOTLETTER) - match not english letter or '\_'
(all r.e.syntax extensions may be turned off by flag ExtSyntax)

 v. 0.1 1999.06.09
==================
* (+) Just first version
