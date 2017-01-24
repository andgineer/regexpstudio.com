---
layout: page
lang: en
ref: syntax
title: Regular expressions syntax
permalink: /regexp_syntax/
---


#### Important note
Below is the description of regular expressions implemented in freeware library
 [TRegExpr](http://regexpstudio.com).
Please note, that the library widely used in many free and commertial software products.
The author of TRegExpr library cannot answer direct questions from this products' users.
Please, send Your questions to the product's support first.

## Introduction

Regular Expressions are a widely-used method of specifying patterns of text to search
for.
Special <b>metacharacters</b> allow You to specify, for instance, that a particular \
string You are looking for occurs at the beginning or end of a line, or contains
<b>n</b> recurrences of a certain character.

Regular expressions look ugly for novices, but really they are very simple
(well, usually simple ;) ), handly and powerfull tool.

I recommend You to play with regular expressions using
using any of many [on-line debuggers](https://www.google.ru/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#newwindow=1&q=regular+expressions+online+debug), it'll help You to uderstand main
conceptions.

Let's start our learning trip!

## Simple matches

Any single character matches itself, unless it is a <b>metacharacter</b> with a
special meaning described below.

A series of characters matches that series of characters in the target string,
so the pattern "bluh" would match "bluh'' in the target string. Quite simple, eh ?

You can cause characters that normally function as <b>metacharacters</b> or
<b>escape sequences</b> to be interpreted literally by 'escaping' them by preceding them with a backslash "\", for instance: metacharacter "^" match beginning of string, but "\^" match character "^", "\\" match "\" and so on.

### Examples:
* foobar <i>matchs string 'foobar'</i>
* ^FooBarPtr <i>matchs '^FooBarPtr'</i>

Note for C++ Builder users</i></b>
<i>Please, read in FAQ answer on question <a href=faq.html#CPPBEscChar>Why many r.e. work wrong in Borland C++ Builder?</a></i>

## Escape sequences

Characters may be specified using a <b>escape sequences</b> syntax much like that used
in C and Perl: "\n'' matches a newline, "\t'' a tab, etc.
More generally, \xnn, where nn is a string of hexadecimal digits, matches the character
whose ASCII value is nn. If You need wide (Unicode) character code,
You can use '\x{nnnn}', where 'nnnn' - one or more hexadecimal digits.

char with hex code nn \x{nnnn} <i>char with hex code nnnn (one byte for plain text and
two bytes for </i><i><a href=tregexpr_interface.html#unicode_support>Unicode</a></i><i>)

* \t <i>tab (HT/TAB), same as \x09</i>
* \n <i>newline (NL), same as \x0a</i>
* \r <i>car.return (CR), same as \x0d
* \f <i>form feed (FF), same as \x0c
* \a <i>alarm (bell) (BEL), same as \x07</i>
* \e <i>escape (ESC), same as \x1b</i>


### Examples:
* foo bar <i>matchs 'foo bar' (note space in the middle)
* \tfoobar <i>matchs 'foobar' predefined by tab</i>

## Character classes
You can specify a <b>character class</b>, by enclosing a list of characters in [], which will match any <b>one</b>
character from the list.


If the first character after the "['' is "^'', the class matches any character <b>not</b> in the list.

### Examples:</b>
* foob[aeiou]r <i>finds strings 'foobar', 'foober' etc. but not 'foobbr', 'foobcr' etc.</i>
foob[^aeiou]r <i>find strings 'foobbr', 'foobcr' etc. but not 'foobar', 'foober' etc.</i>

Within a list, the "-'' character is used to specify a <b>range</b>, so that a-z represents all characters
between "a'' and "z'', inclusive.


If You want "-'' itself to be a member of a class, put it at the start or end of the list, or escape it with a backslash.
If You want ']' you may place it at the start of list or escape it with a backslash.


### Examples:
* [-az] matchs 'a', 'z' and '-'
* [az-] matchs 'a', 'z' and '-'
* [a\-z] matchs 'a', 'z' and '-'
* [a-z] matchs all twenty six small characters from 'a' to 'z'
* [\n-\x0D] matchs any of #10,#11,#12,#13.
* [\d-t] matchs any digit, '-' or 't'.
* []-a] matchs any char from ']'..'a'.

## Metacharacters
Metacharacters are special characters which are the essence of Regular Expressions.
There are different types of metacharacters, described below.

### <a name="syntax_line_separators"></a>Metacharacters - line separators
* ^ start of line
* $ end of line
* \A start of text
* \Z end of text
* . any character in line

### Examples:
<br>
</b></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;^foobar&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs string 'foobar' only if it's at the beginning of line</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foobar$&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs string 'foobar' only if it's at the end of line</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;^foobar$&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs string 'foobar' only if it's the only string in line</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foob.r&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs strings like 'foobar', 'foobbr', 'foob1r' and so on
<br>
</i>
<br>
The "^" metacharacter by default is only guaranteed to match at the beginning of the input string/text, the "$" metacharacter only at the end. Embedded line separators will not be matched by "^'' or "$''.
<br>
You may, however, wish to treat a string as a multi-line buffer, such that the "^'' will match after any line separator within the string, and "$'' will match before any line separator. You can do this by switching On the <a href=regexp_syntax.html#modifier_m>modifier /m</a>.
<br>
The \A and \Z are just like "^'' and "$'', except that they won't match multiple times when the <a href=regexp_syntax.html#modifier_m>modifier /m</a> is used, while "^'' and "$'' will match at every internal line separator. </span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>
</span><span style="font-family:Arial; font-size:10pt; color:#000000">
<br>
The ".'' metacharacter by default matches any character, but if You switch Off the <a href=regexp_syntax.html#modifier_s>modifier /s</a>, then '.' won't match embedded line separators.
<br>

<br>
TRegExpr works with line separators as recommended at www.unicode.org ( http://www.unicode.org/unicode/reports/tr18/ ):
<br>

<br>
 "^" is at the beginning of a input string, and, if <a href=regexp_syntax.html#modifier_m>modifier /m</a> is On, also immediately following any occurrence of \x0D\x0A or \x0A or \x0D (if You are using <a href=tregexpr_interface.html#unicode_support>Unicode version</a> of TRegExpr, then also \x2028 or  \x2029 or \x0B or \x0C or \x85). Note that there is no empty line within the sequence \x0D\x0A.
<br>

<br>
"$" is at the end of a input string, and, if <a href=regexp_syntax.html#modifier_m>modifier /m</a> is On, also immediately preceding any occurrence of  \x0D\x0A or \x0A or \x0D (if You are using <a href=tregexpr_interface.html#unicode_support>Unicode version</a> of TRegExpr, then also \x2028 or  \x2029 or \x0B or \x0C or \x85). Note that there is no empty line within the sequence \x0D\x0A.
<br>

<br>
"." matchs any character, but if You switch Off <a href=regexp_syntax.html#modifier_s>modifier /s</a> then "." doesn't match \x0D\x0A and \x0A and \x0D (if You are using <a href=tregexpr_interface.html#unicode_support>Unicode version</a> of TRegExpr, then also \x2028 and  \x2029 and \x0B and \x0C and \x85).
<br>

<br>
Note that "^.*$" (an empty line pattern) doesnot match the empty string within the sequence \x0D\x0A, but matchs the empty string within the sequence \x0A\x0D.
<br>

<br>
Multiline processing can be easely tuned for Your own purpose with help of TRegExpr properties <a href=tregexpr_interface.html#lineseparators>LineSeparators</a> and <a href=tregexpr_interface.html#linepairedseparator>LinePairedSeparator</a>, You can use only Unix style separators \n or only DOS/Windows style \r\n or mix them together (as described above and used by default) or define Your own line separators!
<br>

<br>

<br>
<span style="font-family:Arial; font-size:10pt; color:#0000FF"><b><a name="syntax_predefined_classes"></a>Metacharacters - predefined classes</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000"><span style="font-family:Arial; font-size:10pt; color:#0000FF"><b>
<br>

<br>
</b></span></span></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\w&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>an alphanumeric character (including "_")
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\W&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>a nonalphanumeric</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\d&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>a </i><i>numeric character
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>a</i><i> non-numeric</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>any space (same as [ \t\n\r\f])
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\S&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>a non space</i>
<br>

<br>
You may use \w, \d and \s within custom <b>character classes</b>.
<br>

### Examples:
</b></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foob\dr&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs strings like 'foob1r', ''foob6r' and so on but not 'foobar', 'foobbr' and so on</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foob[\w\s]r&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs strings like 'foobar', 'foob r', 'foobbr' and so on but not 'foob1r', 'foob=r' and so on</i>
<br>

<br>
TRegExpr uses properties <a href=tregexpr_interface.html#tregexpr.spacechars>SpaceChars</a> and <a href=tregexpr_interface.html#tregexpr.wordchars>WordChars</a> to define character classes \w, \W, \s, \S, so You can easely redefine it.
<br>

<br>

<br>
<span style="font-family:Arial; font-size:10pt; color:#0000FF"><b><a name="syntax_word_boundaries"></a>Metacharacters - word boundaries</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000"><span style="font-family:Arial; font-size:10pt; color:#0000FF"><b>
<br>
</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\b&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>Match a word boundary</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\B&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>Match a non-(word boundary)
<br>
</i></span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>
</span><span style="font-family:Arial; font-size:10pt; color:#000000">A word boundary (\b) is a spot between two characters that has a \w on one side of it and a \W on the other side of it (in either order), counting the imaginary characters off the beginning and end of the string as matching a \W.
<br>

<br>

<br>
<span style="font-family:Arial; font-size:10pt; color:#0000FF"><b><a name="metacharacters_iterators"></a>Metacharacters - iterators</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000"><span style="font-family:Arial; font-size:10pt; color:#0000FF"><b>
<br>

<br>
</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Any item of a regular expression may be followed by another type of metacharacters - <b>iterators</b>. Using this metacharacters You can specify number of occurences of previous character, <b>metacharacter</b> or <b>subexpression</b>.
<br>

<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>zero or more</i><i> ("greedy"), similar to {0,}</i><i>
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Courier; font-size:12pt; color:#000000">&nbsp;</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>one or more</i><i> ("greedy"), similar to {1,}</i><i>
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;?&nbsp;&nbsp;&nbsp;</span><span style="font-family:Courier; font-size:12pt; color:#000000">&nbsp;</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>zero or one ("greedy"), similar to {0,1}</i><i>
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;{n}&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>exactly n times ("greedy")</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;{n,}&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>at least n times ("greedy")
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;{n,m}&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>at least n but not more than m times ("greedy")
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;*?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>zero or more</i><i> ("non-greedy"), similar to {0,}?</i><i>
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;+?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>one or more</i><i> ("non-greedy"), similar to {1,}?</i><i>
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;??&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>zero or one ("non-greedy"), similar to {0,1}?</i><i>
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;{n}?&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>exactly n times ("non-greedy")</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;{n,}?&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>at least n times ("non-greedy")
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;{n,m}?&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>at least n but not more than m times ("non-greedy")
<br>
</i>
<br>
So, digits in curly brackets of the form {n,m}, specify the minimum number of times to match the item n and the maximum m. The form {n} is equivalent to {n,n} and matches exactly n times. The form {n,} matches n or more times. There is no limit to the size of n or m, but large numbers will chew up more memory and slow down r.e. execution.
<br>

<br>
If a curly bracket occurs in any other context, it is treated as a regular character.
<br>

### Examples:
</b></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foob.*r&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs strings like 'foobar',  'foobalkjdflkj9r' and 'foobr'</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foob.+r&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs strings like 'foobar', 'foobalkjdflkj9r' but not 'foobr'
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foob.?r&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs strings like 'foobar', 'foobbr' and 'foobr' but not 'foobalkj9r'
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;fooba{2}r&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs the string 'foobaar'
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;fooba{2,}r&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000">m<i>atchs strings like 'foobaar', 'foobaaar', 'foobaaaar' etc.
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;fooba{2,3}r&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs strings like 'foobaar', or 'foobaaar'  but not 'foobaaaar'
<br>
</i>
<br>
A little explanation about "greediness". "Greedy" takes as many as possible, "non-greedy" takes as few as possible. For example, 'b+' and 'b*' applied to string 'abbbbc' return 'bbbb', 'b+?' returns 'b', 'b*?' returns empty string, 'b{2,3}?' returns 'bb', 'b{2,3}' returns 'bbb'.
<br>

<br>
You can switch all iterators into "non-greedy" mode (see the <a href=regexp_syntax.html#modifier_g>modifier /g</a>).
<br>

<br>

<br>
<span style="font-family:Arial; font-size:10pt; color:#0000FF"><b>Metacharacters - alternatives
<br>

<br>
</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">You can specify a series of <b>alternatives</b> for a pattern using "|'' to separate them, so that fee|fie|foe will match any of "fee'', "fie'', or "foe'' in the target string (as would f(e|i|o)e). The first alternative includes everything from the last pattern delimiter ("('', "['', or the beginning of the pattern) up to the first "|'', and the last alternative contains everything from the last "|'' to the next pattern delimiter. For this reason, it's common practice to include alternatives in parentheses, to minimize confusion about where they start and end.
<br>
Alternatives are tried from left to right, so the first alternative found for which the entire expression matches, is the one that is chosen. This means that alternatives are not necessarily greedy. For example: when matching foo|foot against "barefoot'', only the "foo'' part will match, as that is the first alternative tried, and it successfully matches the target string. (This might not seem important, but it is important when you are capturing matched text using parentheses.)
<br>
Also remember that "|'' is interpreted as a literal within square brackets, so if You write [fee|fie|foe] You're really only matching [feio|].
<br>

### Examples:
</b></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foo(bar|foo)&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs strings 'foobar' or 'foofoo'.</i>
<br>

<br>

<br>
<span style="font-family:Arial; font-size:10pt; color:#0000FF"><b>Metacharacters - subexpressions
<br>

<br>
</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">The bracketing construct ( ... ) may also be used for define r.e. subexpressions (after parsing You can find subexpression positions, lengths and actual values in MatchPos, MatchLen and <a href=tregexpr_interface.html#tregexpr.match>Match</a> properties of TRegExpr, and substitute it in template strings by <a href=tregexpr_interface.html#tregexpr.substitute>TRegExpr.Substitute</a>).
<br>

<br>
Subexpressions are numbered based on the left to right order of their opening parenthesis.
<br>
First subexpression has number '1' (whole r.e. match has number '0' - You can substitute it in <a href=tregexpr_interface.html#tregexpr.substitute>TRegExpr.Substitute</a> as '$0' or '$&amp;').
<br>

### Examples:
* (foobar){8,10} <i>matchs strings which contain 8, 9 or 10 instances of the 'foobar'</i>
* foob([0-9]|a+)r <i>matchs 'foob0r', 'foob1r' , 'foobar', 'foobaar', 'foobaar' etc.</i>


## Metacharacters - backreferences
<b>Metacharacters</b> \1 through \9 are interpreted as backreferences.
\&lt;n&gt; matches previously matched <b>subexpression</b> #&lt;n&gt;.

### Examples:
* (.)\1+ <i>matchs 'aaaa' and 'cc'.</i>
* (.+)\1+ <i>also match 'abab' and '123123' (['"]?)(\d+)\1&nbsp;</i></span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs '"13"</i><i> (in double quotes), or '4' (in single quotes) or 77 (without quotes) etc</i>

## <a name="about_modifiers"></a>Modifiers

<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000">
&nbsp;<br>
</span></span></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000">Modifiers are for changing behaviour of TRegExpr.
<br>

<br>
There are many ways to set up modifiers.
<br>
Any of these modifiers may be embedded within the regular expression itself using the <a href=regexp_syntax.html#inline_modifiers>(?...)</a> construct.
<br>
Also, You can assign to appropriate TRegExpr properties (<a href=tregexpr_interface.html#tregexpr.modifier_x>ModifierX</a> for example to change /x, or ModifierStr to change all modifiers together). The default values for new instances of TRegExpr object defined in <a href=tregexpr_interface.html#modifier_defs>global variables</a>, for example global variable RegExprModifierX defines value of new TRegExpr instance ModifierX property.
<br>

<br>
<b><a name="modifier_i"></a>i</b>
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000">Do case-insensitive pattern matching (using installed in you system locale settings), see also <a href=tregexpr_interface.html#invertcase>InvertCase</a>.
&nbsp;<br>
</span></span></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000"><b><a name="modifier_m"></a>m</b><b> </b></span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Times New Roman; font-size:12pt; color:#000000"></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Treat string as multiple lines. That is, change "^'' and "$'' from matching at only the very start or end of the string to the start or end of any line anywhere within the string, see also <a href=regexp_syntax.html#syntax_line_separators>Line separators</a>.
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000"><b><a name="modifier_s"></a>s</b><b> </b></span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Times New Roman; font-size:12pt; color:#000000"></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Treat string as single line. That is, change ".'' to match any character whatsoever, even a line separators (see also <a href=regexp_syntax.html#syntax_line_separators>Line separators</a>), which it normally would not match.
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000"><b><a name="modifier_g"></a>g</b><b> </b></span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Times New Roman; font-size:12pt; color:#000000"></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Non standard modifier. Switching it Off You'll switch all following operators into non-greedy mode (by default this modifier is On). So, if modifier /g is Off then '+' works as '+?', '*' as '*?' and so on
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000"><b><a name="modifier_x"></a>x </b></span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Times New Roman; font-size:12pt; color:#000000"></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Extend your pattern's legibility by permitting whitespace and comments (see explanation below)</span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">.
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Times New Roman; font-size:12pt; color:#000000"></span></td></tr></table><span style="font-family:Times New Roman; font-size:12pt; color:#000000"></span><span style="font-family:Arial; font-size:10pt; color:#000000"><b><a name="modifier_r"></a>r</b><span style="font-family:Arial; font-size:10pt; color:#7F0000"><b>
<br>
</b><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#7F0000"></span></span></span></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Non-standard modifier. If is set then range &#224;-&#255; additional include russian letter '&#184;', &#192;-&#223;  additional include '&#168;', and &#224;-&#223; include all russian symbols.
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000">Sorry for foreign users, but it's set by default. If you want switch if off by default - set false to global variable <a href=tregexpr_interface.html#modifier_defs>RegExprModifierR</a>.
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000">
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000">
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000">The <a href=regexp_syntax.html#modifier_x>modifier /x</a> itself needs a little more explanation. It tells the TRegExpr to ignore whitespace that is neither backslashed nor within a character class. You can use this to break up your regular expression into (slightly) more readable parts. The # character is also treated as a metacharacter introducing a comment, for example:
<br>

<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="19"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></span></span><span style="font-family:Courier; font-size:10pt; color:#000000"><i>(&nbsp;
&nbsp;<br>
</i></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="19"></td><td><span style="font-family:Courier; font-size:10pt; color:#000000"><i>(abc)&nbsp;#&nbsp;comment&nbsp;1
&nbsp;<br>
</i></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="19"></td><td><span style="font-family:Courier; font-size:10pt; color:#000000"><i>&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;#&nbsp;You&nbsp;can&nbsp;use&nbsp;spaces&nbsp;to&nbsp;format&nbsp;r.e.&nbsp;-&nbsp;TRegExpr&nbsp;ignores&nbsp;it
&nbsp;<br>
</i></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="19"></td><td><span style="font-family:Courier; font-size:10pt; color:#000000"><i>(efg)&nbsp;#&nbsp;comment&nbsp;2
&nbsp;<br>
</i></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="19"></td><td><span style="font-family:Courier; font-size:10pt; color:#000000"><i>)
&nbsp;<br>
</i></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="19"></td><td><span style="font-family:Courier; font-size:10pt; color:#000000"><i></i></span></td></tr></table><span style="font-family:Courier; font-size:10pt; color:#000000"></span><span style="font-family:Arial; font-size:10pt; color:#000000">
<br>
This also means that if you want real whitespace or # characters in the pattern (outside a character class, where they are unaffected by /x), that you'll either have to escape them or encode them using octal or hex escapes. Taken together, these features go a long way towards making regular expressions text more readable.
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000">
&nbsp;<br>
</span></span></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000">
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000"><span style="font-family:Arial; font-size:10pt; color:#0000FF"><b>Perl extensions
<br>
</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">
<br>
</span><span style="font-family:Times New Roman; font-size:12pt; color:#000000"><b><a name="inline_modifiers"></a>(?imsxr-imsxr)</b>
<br>
</span><span style="font-family:Arial; font-size:10pt; color:#000000">You may use it into r.e. for modifying modifiers by the fly. If this construction inlined into subexpression, then it effects only into this subexpression</span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>

### Examples:
</b></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;(?i)Saint-Petersburg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs 'Saint-petersburg' and 'Saint-Petersburg'
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;(?i)Saint-(?-i)Petersburg&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs 'Saint-Petersburg' but not 'Saint-petersburg'</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;(?i)(Saint-)?Petersburg&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs 'Saint-petersburg' and 'saint-petersburg'</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;((?i)Saint-)?Petersburg&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>matchs 'saint-Petersburg', but not 'saint-petersburg'
<br>

## <a name="inline_comment"></a>(?#text)
A comment, the text is ignored.
Note that TRegExpr closes the comment as soon as it sees a ")", so there is
no way to put a literal ")" in the comment.

Don't forget to read the <a href=faq.html>FAQ</a> (expecially 'non-greediness' optimization <a href=faq.html#nongreedyoptimization>question</a>).
