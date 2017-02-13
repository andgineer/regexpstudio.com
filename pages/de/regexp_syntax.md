---
layout: page
lang: de
ref: syntax
title: Syntax
permalink: /de/regexp_syntax.html
---

Reguläre Ausdrücke werden weitum verwendet, um Textmuster zu beschreiben, nach welchen
dann gesucht wird. Spezielle *Metazeichen* erlauben das Definieren von Bedingungen,
beispielsweise soll ein bestimmter gesuchter String am Anfang oder am Ende einer
Zeile vorkommen, oder ein bestimmtes Zeichen soll n mal Vorkommen.

Reguläre Ausdrücke sehen üblicherweise für Anfänger ziemlich kryptisch aus, sind aber im
Grunde genommen sehr einfache (nun, üblicherweise einfache ;) ), handliche und enorm
mächtige Werkzeuge.

Ich empfehle Dir wärmstens, dass Du mit dem Demo-Projekt in TestRExp.dpr etwas mit den
regulären Ausdrücken herumspielst &#150; es wird Dir enorm dabei helfen, die
hauptsächlichen Konzepte zu erfassen. Darüberhinaus findest Du viele vorgegebene und
kommentierte Beispiele in TestRExp.

Also, starten wir in die Lernkurve!


## Einfache Treffer

Jedes einzelne Zeichen findet sich selbst, ausser es sei ein *Metazeichen*
mit einer speziellen Bedeutung (siehe weiter unten).

Eine Sequenz von Zeichen findet genau dieses Sequenz im zu durchsuchenden String (Zielstring).
Also findet das Muster (= reguläre Ausdruck) "bluh" genau die Sequenz "bluh"
irgendwo im Zielstring. Ganz einfach, nicht wahr?

Damit Du Zeichen, die üblicherweise als *Metazeichen* oder *Escape-Sequenzen* dienen,
als ganz normale Zeichen ohne jede Bedeutung finden kannst, stelle so einem Zeichen
einen "\" voran. Diese Techninik nennt man Escaping. Ein Beispiel: das Metazeichen "^"
findet den Anfang des Zielstrings, aber "\^" findet das Zeichen "^" (Circumflex),
"\\" findet also "\" etc.


### Beispiele:
`foobar` findet den String 'foobar'
`^FooBarPtr` findet den String '^FooBarPtr'


## Escape-Sequenzen

Zeichen könenn auch angeben werden mittels einer *Escape-Sequenz*, in der Syntax
ähnlich derer, die in C oder Perl benutzt wird: "\n'' findet eine neue Zeile,
"\t'' einen Tabulator etc. Etwas allgemeiner: \xnn, wobei nn ein String aus hexadezimalen
Ziffern ist, findet das Zeichen, dessen ASCII Code gleich nn ist.
Falls Du Unicode-Zeichen (16 Bit breit kodierte Zeichen) angeben möchtest,
dann benutze '\x{nnnn}', wobei 'nnnn' &#150; eine oder mehrere hexadezimale Ziffern sind.

|`\xnn` |Zeichen mit dem Hex-Code nn (ASCII-Text)|
|`\x{nnnn}` |Zeichen mit dem Hex-Code nnnn (ein Byte für ASCII-Text und zwei Bytes für Unicode-Zeichen|
|`\t` |ein Tabulator (HT/TAB), gleichbedeutend wie \x09|
|`\n` |Zeilenvorschub (NL), gleichbedeutend wie \x0a|
|`\r` |Wagenrücklauf (CR), gleichbedeutend wie \x0d|
|`\f` |Seitenvorschub (FF), gleichbedeutend wie \x0c|
|`\a` |Alarm (bell) (BEL), gleichbedeutend wie \x07|
|`\e` |Escape (ESC), gleichbedeutend wie \x1b|


### Beispiele:

|`foo\x20bar` |findet 'foo bar' (beachte den Leerschlag in der Mitte)|
|`\tfoobar` |findet 'foobar', dem unmittelbar ein Tabulator vorangeht|

## Zeichenklassen

Du kannst sogenannte *Zeichenklassen* definieren, indem Du eine Liste von Zeichen,
eingeschlossen in eckige Klammern [], angibst.
So eine Zeichenklasse findet genau *eines der aufgelisteten Zeichen* Zeichen im Zielstring.

Falls das erste aufgelistete Zeichen, das direkt nach dem "[", ein "^" ist, findet
die Zeichenklasse jedes Zeichen *ausser* denjenigen in der Liste.

### Beispiele:

|`foob[aeiou]r` |findet die Strings 'foobar', 'foober' etc. aber nicht 'foobbr', 'foobcr' etc.|
|`foob[^aeiou]r` |findet die Strings 'foobbr', 'foobcr' etc. aber nicht 'foobar', 'foober' etc.|


Innerhalb der Liste kann das Zeichen "-" benutzt werden, um einen *Bereich* oder
eine *Menge* von Zeichen zu definieren.
So definiert a-z alle Zeichen zwischen "a" and "z" inklusive.

Falls das Zeichen "-" selbst ein Mitglied der Zeichenklasse sein soll, dann setze es als
erstes oder letztes Zeichen in die Liste oder schütze es mit einem vorangestellten "\" (escaping).
Wenn das Zeichen "]" ebenfalls Mitglied der Zeichenklasse sein soll, dann setze es als
erstes Zeichen in die Liste oder escape es.

### Beispiele:

|`[-az]` |findet 'a', 'z' und '-'|
|`[az-]` |findet 'a', 'z' und '-'|
|`[a\-z]` |findet 'a', 'z' und '-'|
|`[a-z]` |findet alle 26 Kleinbuchstaben von 'a' bis 'z'|
|`[\n-\x0D]` |findet eines der Zeichen  #10, #11, #12 oder #13.|
|`[\d-t]` |findet irgendeine Ziffer, '-' oder 't'.|
|`[]-a]` |findet irgendein Zeichen von ']'..'a'.|

## Metazeichen

Metazeichen sind Zeichen mit speziellen Bedeutungen. Sie sind die Essenz der regulären Ausdrücke.
Es gibt verschiedene Arten von Metazeichen wie unten beschrieben.

### Metazeichen - Zeilenseparatoren

|`^` | Beginn einer Zeile|
|`$` | Ende einer Zeile|
|`\A` | start of text|
|`\Z` | end of text|
|`.` | irgendein beliebiges Zeichen |

### Beispiele:

|`^foobar` | findet den String 'foobar' nur, wenn es am Zeilenanfang vorkommt|
|`foobar$` | findet den String 'foobar' nur, wenn es am Zeilenende vorkommt|
|`^foobar` | findet den String 'foobar' nur, wenn er der einzige String in der Zeile ist|
|`foob.r` | findet Strings wie 'foobar', 'foobbr', 'foob1r' etc.|

Standardmässig garantiert das Metazeichen "^" nur, dass das Suchmuster sich am Anfang
des Zielstrings befinden muss, oder am Ende des Zielstrings mit dem Metazeichen "$".
Kommen im Zielstring Zeilenseparatoren vor, so werden diese von "^" oder "$" nicht gefunden.

Du kannst allerdings den Zielstring als mehrzeiligen Puffer behandeln, so dass "^" die
Stelle unmittelbar nach, und "$" die Stelle unmittelbar vor irgendeinem Zeilenseparator findet.
Du kannst diese Art der Suche einstellen mit dem [Modifikator /m](#modifier /m).

The \A and \Z are just like "^'' and "$'', except that they won't match multiple times when the [Modifikator /m](#modifier /m) is used, while "^'' and "$'' will match at every internal line separator.

Das ".'' Metazeichen findet standardmässig irgendein beliebiges Zeichen, also auch Zeilenseparatoren. Wenn Du den <a href=regexp_syntax.html#modifier_s>Modifikator /s</a>

 ausschaltest, dann findet '.' keine Zeilenseparatoren mehr.

TRegExpr geht mit Zeilenseparatoren so um, wie es auf www.unicode.org (http://www.unicode.org/unicode/reports/tr18/) empfohlen ist:

 "^" ist am Anfang des Eingabestrings, und, falls der [Modifikator /m](#modifier /m) gesetzt ist,
 auch unmitelbar folgend einem Vorkommen von \x0D\x0A oder \x0A or \x0D (falls Du die <a href=tregexpr_interface.html#unicode_support>Unicode-Version</a> von TregExpr benutzst, dann auch nach \x2028 oder  \x2029 oder \x0B oder \x0C oder \x85). Beachte, dass es keine leere Zeile gibt in den Sequence \x0D\x0A. Diese beiden Zeichen werden atomar behandelt.

"$" ist am Anfang des Eingabestrings, und, falls der [Modifikator /m](#modifier /m) gesetzt ist,
auch unmitelbar vor einem Vorkommen von \x0D\x0A oder \x0A or \x0D (falls Du die <a href=tregexpr_interface.html#unicode_support>Unicode-Version</a> von TregExpr benutzst, dann auch vor \x2028 oder  \x2029 oder \x0B oder \x0C oder \x85). Beachte, dass es keine leere Zeile gibt in den Sequence \x0D\x0A. Diese beiden Zeichen werden atomar behandelt.

"." findet ein beliebiges Zeichen. Wenn Du aber den [Modifikator /s](#modifier /s) ausstellst, dann findet "." keine Zeilensearaptoren \x0D\x0A und \x0A und \x0D mehr (falls Du die <a href=tregexpr_interface.html#unicode_support>Unicode-Version</a> von TregExpr benutzst, dann auch \x2028 und  \x2029 und \x0B und \x0C and \x85).

Beachte, dass "^.*$" (was auch eine leere Zeile findet können sollte) dennoch nicht den leeren String innerhalb der Sequence \x0D\x0A findet, aber es findet den Leerstring innerhalb der Sequenz \x0A\x0D.

Die Behandlung des Zielstrings als mehrzeiliger String kann leicht Deinen Bedürfnissen angepasst werden dank der TregExpr-Eigenschaften <a href=tregexpr_interface.html#lineseparators>LineSeparators</a> und <a href=tregexpr_interface.html#linepairedseparator>LinePairedSeparator</a>. Du kannst nur den UNIX-Stil Zeilenseparator \n benutzen oder nur DOS-Stil Separatoren \r\n oder beide gelichzeitig (wie schon oben beschrieben und wie es als Standard gesetzt ist). Du kannst auch Deine eigenen Zeilenseparatoren definieren!

### Metazeichen  vordefinierte Klassen</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000"><span style="font-family:Arial; font-size:10pt; color:#0000FF"><b>

<br>
</b></span></span></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\w&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>ein alphanumerisches Zeichen inklusive "_"
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\W&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>kein alphanumerisches Zeichen, auch kein "_"</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\d&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>ein </i><i>numerisches Zeichen
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>kein </i><i>numerisches Zeichen</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>irgendein wörtertrennendes Zeichen (entspricht [ \t\n\r\f])
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;\S&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>kein wörtertrennendes Zeichen</i>
<br>

Du kannst \w, \d und \s innerhalb Deiner selbstdefinierten Zeichenklassen benutzen.

### Beispiele:
</b></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foob\dr&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet Strings wie 'foob1r', ''foob6r' etc., aber not 'foobar', 'foobbr' etc.</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foob[\w\s]r&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet Strings wie 'foobar', 'foob r', 'foobbr' etc., aber nicht 'foob1r', 'foob=r' etc.</i>
<br>

TRegExpr benutzt die Eigenschaften <a href=tregexpr_interface.html#tregexpr.spacechars>SpaceChars</a> und <a href=tregexpr_interface.html#tregexpr.wordchars>WordChars</a>, um die Zeichenklassen \w, \W, \s, \S zu definieren. Somit kannst Du sie auch leicht umdefinieren.

<span style="font-family:Arial; font-size:10pt; color:#0000FF"><b><a name="syntax_word_boundaries"></a>Metazeichen  Wortgrenzen</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000"><span style="font-family:Arial; font-size:10pt; color:#0000FF"><b>
<br>
</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">
<br>
  \b<i>     findet eine Wortgrenze
<br>
</i>  \B<i>    findet alles ausser einer Wortgrenze
<br>

</i>Eine Wortgrenze (\b) is der Ort zwischen zwei Zeichen, welcher ein \w auf der einen und ein \W auf der anderen Seite hat bzw. umgekehrt. \b bezeichnet alle Zeichen des \w bis vor das erste Zeichen des \W bzw. umgekehrt.

<a name="metacharacters_iterators"></a>Metazeichen - Iteratoren<span style="font-family:Arial; font-size:10pt; color:#0000FF"><b>

</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Jeder Teil eines regulären Ausdruckes kann gefolgt werden von einer anderen Art von Metazeichen &#150; den <b>Iteratoren</b>. Dank dieser Metazeichen kannst Du die Häufigkeit des Auftretens des Suchmusters im Zielstring definieren. Dies gilt jeweils für das vor diesem Metazeichen stehenden Zeichen, das <b>Metazeichen</b> oder den <b>Teilausdruck</b>.

</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>kein- oder mehrmaliges Vorkommen</i><i> ("gierig"), gleichbedeutend wie {0,}</i><i>

</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;+&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Courier; font-size:12pt; color:#000000">&nbsp;</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>ein- oder mehrmaliges Vorkommen</i><i> ("gierig"), gleichbedeutend wie {1,}</i><i>
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;?&nbsp;&nbsp;&nbsp;</span><span style="font-family:Courier; font-size:12pt; color:#000000">&nbsp;</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>kein- oder einmaliges Vorkommen  ("gierig"), gleichbedeutend wie {0,1}</i><i>
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;{n}&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>genau n-maliges Vorkommen ("gierig")</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;{n,}&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>mindestens n-maliges Vorkommen ("gierig")
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;{n,m}&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>mindestens n-, aber höchstens m-maliges Vorkommen ("gierig")
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;*?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>kein- oder mehrmaliges Vorkommen</i><i> ("genügsam"), gleichbedeutend wie {0,}?</i><i>
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;+?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>ein oder mehrmaliges Vorkommen</i><i> ("genügsam"), gleichbedeutend wie {1,}?</i><i>
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;??&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>kein- oder einmaliges Vorkommen ("genügsam"), gleichbedeutend wie {0,1}?</i><i>
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;{n}?&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>genau n-maliges Vorkommen ("genügsam")</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;{n,}?&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>Mindestens n-maliges Vorkommen ("genügsam")
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;{n,m}?&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>mindestens n-, aber höchstens m-maliges Vorkommen ("genügsam")
<br>
</i>
<br>
Also, die Ziffern in den geshcweiften Klammern in der Form {n,m} geben an, wieviele Male das Suchmuster im Zielstring gefunden muss, um einen Treffer zu ergeben. Die Angabe {n} ist gleichbedeutend wie {n,n} und findet genau n Vorkommen. Die Form {n,} findet n oder mehre Vorkommen. Es gibt keine Limiten für die Zahlen n und m. Aber je grösser sie sind, desto mehr Speicher und Zeit wird benötigt, um den regulären Ausdruck auszuwerten.

Falls eine geschweifte Klammer in einem anderen als dem eben vorgestellten Kontext vorkommt, wird es wie ein normales Zeichen behandelt.

### Beispiele:
</b></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foob.*r&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet Strings wie 'foobar',  'foobalkjdflkj9r' und 'foobr'</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foob.+r&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet Strings wie 'foobar', 'foobalkjdflkj9r', aber nicht 'foobr'
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foob.?r&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet Strings wie 'foobar', 'foobbr' und 'foobr', aber nicht 'foobalkj9r'
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;fooba{2}r&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet den String 'foobaar'
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;fooba{2,}r&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet Strings wie 'foobaar', 'foobaaar', 'foobaaaar' etc.
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;fooba{2,3}r&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet Strings wie 'foobaar', or 'foobaaar', aber nicht 'foobaaaar'
<br>
</i>
<br>
Eine kleine Erklärung zum Thema "gierig" oder "genügsam". "Gierig" nimmt soviel wie möglich, wohingegen "genügsam" bereits mit dem ersten Erfüllen des Suchmusters zufrieden ist. Beispiel: 'b+' und 'b*' angewandut auf den Zielstring 'abbbbc' findet 'bbbb', 'b+?' findet 'b', 'b*?' findet den leeren String, 'b{2,3}?' findet 'bb', 'b{2,3}' findet 'bbb'.

Du kannst alle Iteratoren auf den genugsamen Modus umschalten mit dem [Modifikator /g](#modifier /g).

<span style="font-family:Arial; font-size:10pt; color:#0000FF"><b>Metazeichen - Alternativen

</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Du kannst eine Serie von <b>Alternativen</b> für eine Suchmuster angeben, indem Du diese mit einem "|'' trennst. Auf diese Art findet das Suchmuster fee|fie|foe eines von "fee", "fie", oder "foe" im Zielstring &#150; dies würde auch mit f(e|i|o)e ereicht.

Die erste Alternative beinhaltet alles vom letzten Muster-Limiter ("(", "[" oder natürlich der Anfang des Suchmusters) bis zum ersten "|". Die letzte Alternative beinhaltet alles vom letzten "|" bis zum nächsten Muster-Limiter. Aus diesem Grunde ist es allgemein eine gute Gewohnheit, die Alternativen in Klammern anzugeben, um möglichen Missverständnissen darüber vorzubeugen, wo die Alternativen beginnen und enden.

Alternativen werden von links nach rechts gepürft, so dass der Treffer im Zielstring zusammengesetzt ist aus den jeweils zuerst passenden Alternativen. Das bedeutet, dass Alternativen nicht notwendigerweise "gierig" sind. Ein Beispiel: Wenn man mit "(foo|foot)" im Zielstring "barefoot" sucht, so passt bereits die erste Variante. Diese Tatsache mag nicht besonders wichtig erscheinen, aber es ist natürlich wichtig, wenn der gefundene Text weiterverwendet wird. Im Beispiel zuvor würde der Benutzer nicht "foot" erhalten, wie er eventuell beabsichtigt hatte, sondern nur "foo".

Erinnere Dich auch daran, dass das "|" innerhalb von eckigen Klammern wie ein normales Zeichen behandelt wird, so dass [fee|fie|foe] dasselbe bedeutet wie [feio|].

### Beispiele:
</b></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foo(bar|foo)&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet die Strings 'foobar' oder 'foofoo'.</i>

<span style="font-family:Arial; font-size:10pt; color:#0000FF"><b>Metazeichen - Teilausdrücke

</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Das KLammernkonstrukt (...) wird auch dazu benutzt, reguläre Teilausdrücke zu definieren (nach dem Parsen findest Du Positionen, Längen und effektive Inhalte der regulären Teilausdrücke in den TRegExpr-Eigenschaften MatchPos, MatchLen und <a href=tregexpr_interface.html#tregexpr.match>Match</a> und kannst sie ersetzen mit den Template-Strings in <a href=tregexpr_interface.html#tregexpr.substitute>TRegExpr.Substitute</a>).

Teilausdrücke werden nummeriert von links nach recht, jeweils in der Reihenfolge ihrer öffnenden Klammer. Der erste Teilausdruck hat die Nummer 1, der gesamte reguläre Ausdruck hat die Nummer 0 (der gesamte Ausdruck kann ersetzt werden in <a href=tregexpr_interface.html#tregexpr.substitute>TRegExpr.Substitute</a> als '$0' oder '$&amp;').

### Beispiele:
</b></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;(foobar){8,10}&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet Strings, die 8, 9 oder 10 Vorkommen von 'foobar' beinhalten

</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;foob([0-9]|a+)r&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet 'foob0r', 'foob1r' , 'foobar', 'foobaar', 'foobaar' etc.</i>

<span style="font-family:Arial; font-size:10pt; color:#0000FF"><b>Metazeichen - Rückwärtsreferenzen
<br>
</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">
<br>
Die <b>Metacharacters</b> \1 bis \9 werden in Suchmustern interpretiert als Rückwärtsreferenzen. \&lt;n&gt; findet einen zuvor bereits gefundenen <b>Teilausdruck</b> #&lt;n&gt;.

### Beispiele:
</b></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;(.)\1+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet 'aaaa' und 'cc'.
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;(.+)\1+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet auch 'abab' und '123123'
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000"><i>&nbsp;&nbsp;(['"]?)(\d+)\1&nbsp;</i></span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet "13"</i><i> (innerhalb ")</i><i>, oder '4'</i><i> (innerhalb ')</i><i> oder auch 77, etc.
<br>
</i>

<span style="font-family:Arial; font-size:10pt; color:#0000FF"><b><a name="about_modifiers"></a>Modifikatoren</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">

<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000">
&nbsp;<br>
</span></span></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000">Modifikatoren sind dazu da, das Verhalten von TRegExpr zu verändern.

Es gibt viele Wege, die weiter unten beschriebenen Modifikatoren zu nutzen. Jeder der Modifikatoren lann eingebettet werden im Suchmuster des regulären Ausdruckes mittels des Konstruktes </span><span style="font-family:Times New Roman; font-size:10pt; color:#000000"><a href=regexp_syntax.html#inline_modifiers>(?...)</a></span><span style="font-family:Arial; font-size:10pt; color:#000000">.

Du kannst allerdings auch die meisten Modifikatoren beeinflussen, indem Du den entsprechenden TRegExpr-Eigenschaften die passenden Werte zuweist (Beispiel: Zuweisung an <a href=tregexpr_interface.html#tregexpr.modifier_x>ModifierX</a> oder ModifierStr für alle Modifikatoren zugleich).

Die Standardwerte für neue Instanzen von TRegExpr-Objekte sind definiert in <a href=tregexpr_interface.html#modifier_defs>globalen Variablen</a>. Beispielsweise definiert die globale Variable RegExprModifierX das Verhalten des Modifikators X und damit die Einstellung der TRegExpr-Eigenschaft ModifierX bei neu instantiierten TRegExpr-Objekten.

<b><a name="modifier_i"></a>i</b>

<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000">Führe die Suche Schreibweisen-unabhägig durch (allerdings abhängig von den Einstellungen in Deinem System, Lokale Einstellungen), (beachte auch die <a href=tregexpr_interface.html#invertcase>InvertCase</a>)
&nbsp;<br>
</span></span></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000"><b>

<a name="modifier_m"></a>m</b><b> </b></span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Times New Roman; font-size:12pt; color:#000000"></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Behandle den Zielstring als mehrzeiligen String. Das bedeutet, ändere die Bedeutungen von "^" und "$": Statt nur den Anfang oder das Ende des Zielstrings zu finden, wird jeder Zeilenseparator innerhalb eines Strings erkannt (beachte auch die </span><span style="font-family:Times New Roman; font-size:10pt; color:#000000"><a href=tregexpr_interface.html#lineseparators>Zeilenseparatoren</a></span><span style="font-family:Arial; font-size:10pt; color:#000000">)
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000"><b><a name="modifier_s"></a>s</b><b> </b></span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Times New Roman; font-size:12pt; color:#000000"></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Behandle den Zielstring als einzelne Zeile. Das bedeutet, dass "." jedes beliebige Zeichen findet, sogar Zeilenseparatoren (beachte auch </span><span style="font-family:Times New Roman; font-size:10pt; color:#000000"><a href=tregexpr_interface.html#lineseparators>Zeilenseparatoren</a></span><span style="font-family:Arial; font-size:10pt; color:#000000">), die es normalerweise nicht findet.
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000"><b><a name="modifier_g"></a>g</b><b> </b></span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Times New Roman; font-size:12pt; color:#000000"></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Modifikator für den "Genügsam"-Modus. Durch das Ausstellen werden alle folgenden Operatoren in den "Genugsam"-Modus. Standardmassig sind alle Operatoren "gierig". Wenn also der Modifikator /g aus ist, dann arbeitet '+' wie '+?', '*' als '*?' etc.
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000"><b><a name="modifier_x"></a>x</b></span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>
<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Times New Roman; font-size:12pt; color:#000000"></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Erweitert die Lesbarkeit des Suchmusters durch Whitespace und Kommentare (beachte die Erklärung unten)</span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">.
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Times New Roman; font-size:12pt; color:#000000"></span></td></tr></table><span style="font-family:Times New Roman; font-size:12pt; color:#000000"></span><span style="font-family:Arial; font-size:10pt; color:#000000"><b><a name="modifier_r"></a>r</b><span style="font-family:Arial; font-size:10pt; color:#800000"><b>
<br>
</b><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#800000"></span></span></span></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">Modifikator. Falls er gesetzt ist, beinhaltet die Zeichenklasse à-ÿ zusätzliche russissche Buchstaben '¸', À-ß beinhaltet zusätzlich '¨', und à-ß beinhaltet alle russischen Symbole.
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000">Sorry für fremdsprachliche Benutzer, er ist gesetzt standardmässig. Falls Du ihn ausgeschaltet haben willst standardässig, dann setze die globale Variable <a href=tregexpr_interface.html#modifier_defs>RegExprModifierR</a> auf false.
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000">
&nbsp;<br>
</span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="25"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></td></tr></table><span style="font-family:Arial; font-size:10pt; color:#000000">
<br>
Der [Modifikator /x](#modifier /x) selbst braucht etwas mehr Erklärung. Er sagt TRegExpr, dass er allen Whitespace ignorieren soll, der nicht escaped oder innerhalb einer Zeichenklasse ist. Du kannst ihn benutzen, um den regulären Ausdruck in kleinere, besser lesbare Teile zu zerlegen. Das Zeichen # wird nun ebenfalls als Metazeichen behandelt und leitet einen Kommentar bis zum Zeilenende ein. Beispiel:

<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="19"></td><td><span style="font-family:Arial; font-size:10pt; color:#000000"></span></span></span><span style="font-family:Courier; font-size:10pt; color:#000000"><i>(&nbsp;
&nbsp;<br>
</i></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="19"></td><td><span style="font-family:Courier; font-size:10pt; color:#000000"><i>(abc)&nbsp;#&nbsp;Kommentar&nbsp;1
&nbsp;<br>
</i></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="19"></td><td><span style="font-family:Courier; font-size:10pt; color:#000000"><i>&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;#&nbsp;Du&nbsp;kannst&nbsp;Leerschläge&nbsp;zur&nbsp;Formatierung&nbsp;benutzen&nbsp;-&nbsp;TRegExpr&nbsp;ignoriert&nbsp;sie
&nbsp;<br>
</i></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="19"></td><td><span style="font-family:Courier; font-size:10pt; color:#000000"><i>(efg)&nbsp;#&nbsp;Kommentar&nbsp;2
&nbsp;<br>
</i></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="19"></td><td><span style="font-family:Courier; font-size:10pt; color:#000000"><i>)
&nbsp;<br>
</i></span></td></tr></table><table width="100%" border="0" cellpadding="0" cellspacing="0"><tr valign="top"><td width="19"></td><td><span style="font-family:Courier; font-size:10pt; color:#000000"><i></i></span></td></tr></table><span style="font-family:Courier; font-size:10pt; color:#000000"></span><span style="font-family:Arial; font-size:10pt; color:#000000">
<br>
Dies bedeutet auch, wenn Du echten Whitespace oder das # im Suchmuster haben möchtest (ausserhalb einer Zeichenklasse, wo sie unbehelligt von /x sind), dann muss der entweder escaped oder mit der hexadezimalen Schreibweise angegeben werden. Beides zusammen sorgt dafür, dass reguläre Ausdrücke besser lesbar werden.

## Perl Erweiterungen
`(?imsxr-imsxr)`

Dies kann benutzt werden in Regulären Ausdrücken, um Modifikatoren innerhalb eines Ausdruckes im Flug zu ändern. Wenn dieses Konstrukt innerhalb eines Teilausdruckes erscheint, betriefft er auch nur diesen.

### Beispiele:
</b></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;(?i)Saint-Petersburg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet 'Saint-petersburg' und 'Saint-Petersburg'
<br>
</i></span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;(?i)Saint-(?-i)Petersburg&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet 'Saint-Petersburg', aber nicht 'Saint-petersburg'</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;(?i)(Saint-)?Petersburg&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet 'Saint-petersburg' und 'saint-petersburg'</i>
<br>
</span><span style="font-family:Courier; font-size:10pt; color:#000000">&nbsp;&nbsp;((?i)Saint-)?Petersburg&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="font-family:Arial; font-size:10pt; color:#000000"><i>findet 'saint-Petersburg', aber nicht 'saint-petersburg'
<br>

<br>
</i></span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>
</span><span style="font-family:Arial; font-size:10pt; color:#000000"><b><a name="inline_comment"></a>(?#text)</b></span><span style="font-family:Times New Roman; font-size:12pt; color:#000000">
<br>
</span><span style="font-family:Arial; font-size:10pt; color:#000000">Ein Kommentar, der Text wird ignoriert. Beachte, dass TRegExpr den Kommentar abschliesst, sobald er eine ")" sieht. Es gibt also keine Möglichkeit, das Zeichen ")" im Kommentar zu haben.

<span style="font-family:Arial; font-size:10pt; color:#0000FF"><b><a name="mechanism"></a>Erklärung der internen Mechanismen</b></span></span></span><span style="font-family:Arial; font-size:10pt; color:#000000">
<br>

So, es scheint also, als möchtest Du einige Geheimnisse der internen Mechanismen von TRegExpr erklärt bekommen? Nun, dieser Abschnitt ist im Aufbau &#150; bitte sei etwas geduldig. Bis heute empfehle ich Dir die <a href=faq.html>FAQ</a> (zu lesen, speziell zu den Fragen der Optimierungen beim <a href=faq.html#nongreedyoptimization>"genügsamen" Modus</a>).
