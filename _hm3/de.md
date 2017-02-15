TRegExpr - Delphi Regularen Ausdrucken
======================================

1.  [About](#about.html)
2.  [Rechtliche Themen](#disclaimer.html)
3.  [Installation und die Liste der Dateien](#installation.html)
4.  [Wie funktioniert's?](#demos.html)
5.  [Syntax von Regularen Ausdrucken](#regexp_syntax.html)
6.  [TRegExpr interface](#tregexpr_interface.html)
7.  [Das Demo-Projekt (TestRExp)](#tregexpr_testrexp.html)
8.  [Example: Hyper Links Decorator](#hyperlinksdecorator.html)
9.  [FAQ](#faq.html)
10. [Author](#author.html)

About
=====

 
=

TRegExpr ist eine Sammlung von einfach zu benutzenden Routinen, um
mächtige, vorlagenbasierte Zeichenkettenvergleiche durchzuführen,
beispielsweise zur Prüfung von strukturierten Dateneingaben in
Datenbanken wie beispielsweise Telefonnummern mit Vorwahlen,
Sozialversicherungsnummern, Web-Applikationen, komplexere Suchen &
Ersetzen-Vorgänge, Werkzeuge zur Durchforstung von Dateibeständen nach
regelbasierenden Ausdrücken und so weiter.

 

Du kannst mit TRegExpr leicht und schnell die korrekte Syntax einer
E-Mail-Adresse prüfen, Telefonnummern in einem Text erkennen, URLs aus
Qelltexten von Web-Seiten extrahieren, unterschiedliche Schreibweisen
eines Ausdruckes finden und durch eine einzige ersetzen. Es bleibt
Deiner Fantasie überlassen, wozu Du TRegExpr noch benutzen kannst. Die
Suchvorlagen (im folgenden Templates genannt), können zur Laufzeit
geändert werden, ohne dass eine Neuübersetzung des Programmes notwendig
würde!

 

Diese Bibliothek, die ich hiermit in die Freeware lege, ist eine
Delphi-Portierung der Routinen, die Henry Spencer als V8-Routinen
herausbrachte, um damit eine Untermenge der [Regulären Ausdrücke von
Perl](#regexp_syntax.html) handhaben zu können.

 

Demgegenüber ist TRegExpr vollständig in einfachem Object-Pascal
geschrieben und wird mit dem ganzen Quelltext kostenlos zur Verfügung
gestellt.

 

Der originale C-Quelltext wurde verbessert, in eine Klasse
[TRegExpr](#tregexpr_interface.html) gekapselt und in einer einzigen
Datei gespeichert: RegExpr.pas.

 

Du brauchst also keine DLL mehr für Reguläre Ausdrücke!

 

Schaue Dir mal die einfachen [Beispiele](#demos.html) an und studiere
die [Syntax](#regexp_syntax.html) der Regulären Ausdrücke (Du kannst
natürlich auch das [Demo-Projekt](#tregexpr_testrexp.html) für
Studienzwecke heranziehen und damit auch Deine eigenen Regulären
Ausdrücken ausarbeiten oder debuggen).

 

Du kannst sogar Unicode (d.h. Delphis WideString) benutzen – weiteres
unter "[Wie wird Unicode
benutzt?](#tregexpr_interface.html#unicode_support)".

 

Wirf auch einen Blick auf die [Was gibt's
Neues](http://RegExpStudio.com/TRegExpr/Help/Whats_New.html) web-Sektion
für die neuesten Änderungen.

 

Und natürlich sind Kommentare, Ideen, Vorschläge und sogar Bug Reports
[willkommen](#author.html).

 

Rechtliche Themen
=================

 

Copyright (c) 1999-2004 by Andrey V. Sorokin
&lt;[anso@mail.ru]('mailto:anso@mail.ru')&gt;

 

Diese Software wird kostenlos im jeweils aktuellsten Zustand zur
Verfügung gestellt. Es besteht weder eine Garantie noch irgendeine
Haftung für deren Einsatz. Benutze sie auf Dein eigenes Risiko.

 

Du kannst diese Software in Deinen eigenen Entwicklungen, seien diese
kostenlos oder kommerziell, benutzen, anpassen oder ändern, sofern Du
folgende Bedingungen einhältst:

1. Die Herkunft dieser Software darf nicht entfernt werden. Du darfst
keine Urheberschaft auf dieser Software erheben. Wenn Du die Software
irgendwo einsetzst, wäre es wünschenswert, wenn eine Notiz auf meine
Urheberschaft vorhanden wäre, sei es in einer Informationsbox oder der
Dokumentation.

2. Du darfst kein Einkommen aus der Verteilung des Quellcodes an andere
Entwickler erzielen. Wenn Du diese Software in einem kommerziellen
Produkt einsetzst, darfst Du den eventuell mitgelieferten Quelltext
dieser Software nicht implizit oder separat verrechnen.

 

 

---------------------------------------------------------------

    Legal issues for the original C sources:

---------------------------------------------------------------

\*  Copyright (c) 1986 by University of Toronto.

\*  Written by Henry Spencer.  Not derived from licensed software.

\*

\*  Permission is granted to anyone to use this software for any

\*  purpose on any computer system, and to redistribute it freely,

\*  subject to the following restrictions:

\*  1. The author is not responsible for the consequences of use of

\*      this software, no matter how awful, even if they arise

\*      from defects in it.

\*  2. The origin of this software must not be misrepresented, either

\*      by explicit claim or by omission.

\*  3. Altered versions must be plainly marked as such, and must not

\*      be misrepresented as being the original software.

 

Installation und die Liste der Dateien
======================================

 

Um die Bibliothek zu installieren, kopiere einfach RegExpr.pas in ein
Verzeichnis Deiner Wahl und/oder füge den Pfad zu diesem Verzeichnis in
Delphis Projekt-Manager hinzu.

 

Das ist schon alles!

 

Danach benutze einfach das TregExpr-Objekt oder die globalen Routinen in
Deinem Projekt (beachte die [Beispiele](#demos.html)).

 

Hilfe-Dateiens

•  RegExpE.hlp, RegExpE.cnt – Englische Hilfe

•  RegExpRu.hlp, RegExpRu.cnt – Russische Hilfe

•  RegExpBg.hlp, RegExpBg.cnt – Bulgarische Help (von Simeon Lilov)

•  RegExpG.hlp, RegExpG.cnt – Deutsche Hilfe (von Martin Baur,
[www.mindpower.com](http://www.mindpower.com/))

•RegExpF.hlp, RegExpF.cnt - French help (by Martin Ledoux)

•  Platz für die Hilfe in Deiner Sprache ;) Bitte, hilf mir beim
Übersetzen!

•RegExpS.hlp, RegExpS.cnt – Spanische Hilfe (von Diego Calp)

 

Das [Demo-Projekt](#tregexpr_testrexp.html) besteht aus folgenden
Dateien:

•  TestRExp.dpr (Projekt-Datei)

•  TestRE.pas (Haupt-Form)

•  TestRE.dfm

•  PCode.pas (Pseudo-Code (übersetzte Reguläre Ausdrücke) Betrachter)

•  PCode.dfm

•  FileViewer.pas (egrep-ähnliches Dateisuche-Werkzeug)

•  FileViewer.dfm

• [HyperLinkDecorator.pas](#hyperlinksdecorator.html) (etwas komplexere
Beispiele)

•  test.htm (Demo-Datei für den FileViewer).

 

Wie funktioniert's?
===================

 

Einfache Beispiele

 

Falls Du nicht mit Regulären Ausdrücken bekannt bist, dann könntest Du
etwas unter dem Abschnitt [Syntax](#regexp_syntax.html) dazulernen oder
schaue in ein gutes Perl oder Unix Buch.

 

Globale Routinen verwenden

Das ist zwar einfach, aber nicht besonders flexibel oder effektiv.

 

ExecRegExpr ('\\d{3}-(\\d{2}-\\d{2}|\\d{4})', 'Phone: 555-1234');

Rückgabewert: True

 

ExecRegExpr ('^\\d{3}-(\\d{2}-\\d{2}|\\d{4})', 'Phone: 555-1234');

Rückgabewert: False, weil es einige Zeichen vor der Telefonnummer hat
und weil wir das Metazeichen '^' benutzen (Bedeutung von '^':
BeginningOfLine)

 

ReplaceRegExpr ('product', 'Take a look at product. product is the best
!', 'TRegExpr');

Rückgabewert: 'Take a look at TRegExpr. TRegExpr is the best !'; ;)

 

Die TRegExpr-Klasse verwenden

Damit hast Du alle Möglichkeiten der Bibliothek zur Verfügung.

 

// Diese einfache Funktion extrahiert alle E-Mail-Adressen aus dem
InputString

// und legt eine Liste dieser Adressen in den Rьckgabewert

function ExtractEmails (const AInputString : string) : string;

const

 EmailRE =
'\[\_a-zA-Z\\d\\-\\.\]+@\[\_a-zA-Z\\d\\-\]+(\\.\[\_a-zA-Z\\d\\-\]+)+'

var

 r : TRegExpr;

begin

 Result := '';

 r := TRegExpr.Create; // Erzeuge Objekt

 try // garantiere Speicherfreigabe

         r.Expression := EmailRE;

         // der R.A. wird automatisch in die interne Struktur ьbersetzt

         // innerhalb der Zuweisung an diese Eigenschaft

         if r.Exec (AInputString) then

                 REPEAT

                         Result := Result + r.Match \[0\] + ', ';

                 UNTIL not r.ExecNext;

         finally r.Free;

 end;

end;

begin

 ExctractEmails ('My e-mails is anso@mail.ru and anso@usa.net');

 // gibt zurьck: 'anso@mail.ru, anso@usa.net, '

end.

(\* Beachte: Die Übersetzung eines Regulären Ausdruckes beansprucht
etwas Zeit während der Zuweisung. Wenn Du also diese Funktion öfters
ausführst, dann erzeugst Du damit unnötigen Aufwand. Wenn der Reguläre
Ausdruck also konstant bleibt, dann kannst Du dies beträchtlich
optimieren, indem Du diese Zuweisung nur während der
Initialisierungsphase Deines Projektes ausführst. \*)

 

// Dieses einfache Beispie extrahiert Telefonnummern und

// zerlegt sie in Teile (Stadt- und Landesvorwahl, interne Nummer).

// Danach ersetzt es diese Teile im Template.

function ParsePhone (const AInputString, ATemplate : string) : string;

const

 IntPhoneRE = '(\\+\\d \*)?(\\(\\d+\\) \*)?\\d+(-\\d\*)\*';

var

 r : TRegExpr;

begin

 r := TRegExpr.Create;

 try

         r.Expression := IntPhoneRE;

         if r.Exec (AInputString)

                 then Result := r.Substitute (ATemplate)

                 else Result := '';

         finally r.Free;

 end;

end;

begin

 ParsePhone ('Phone of AlkorSoft (project PayCash) is +7(812)
329-44-69',

 'Zone code $1, city code $2. Whole phone number is $&.');

 // Rьckgabe: 'Zone code +7, city code (812) . Whole phone number is
+7(812) 329-44-69.'

end.

 

Etwas komplexere Beispiele

 

Du findest komplexere Beispiele für den Gebrauch von TRegExpr in den
Projekten [TestRExp.dpr](#tregexpr_testrexp.html) und
[HyperLinkDecorator.pas](#hyperlinksdecorator.html).

 

Beachte bitte auch meine kleinen Artikel auf
[Delphi3000.com](http://www.delphi3000.com/member.asp?ID=1300)
(Englisch) und [Delphi
Kingdom](http://delphi.vitpc.com/mastering/strings_birds_eye_view.htm)
(Russisch).

 

 

Ausführliche Erklärung

 

Bitte beachte dazu die
TRegExpr-Interface-[Beschreibung](#tregexpr_interface.html).

 

Syntax von Regulären Ausdrücken
===============================

 

Einführung

 

Reguläre Ausdrücke werden weitum verwendet, um Textmuster zu
beschreiben, nach welchen dann gesucht wird. Spezielle Metazeichen
erlauben das Definieren von Bedingungen, beispielsweise soll ein
bestimmter gesuchter String am Anfang oder am Ende einer Zeile
vorkommen, oder ein bestimmtes Zeichen soll n mal Vorkommen.

 

Reguläre Ausdrücke sehen üblicherweise für Anfänger ziemlich kryptisch
aus, sind aber im Grunde genommen sehr einfache (nun, üblicherweise
einfache ;) ), handliche und enorm mächtige Werkzeuge.

 

Ich empfehle Dir wärmstens, dass Du mit dem Demo-Projekt in
[TestRExp.dpr](#tregexpr_testrexp.html) etwas mit den regulären
Ausdrücken herumspielst – es wird Dir enorm dabei helfen, die
hauptsächlichen Konzepte zu erfassen. Darüberhinaus findest Du viele
vorgegebene und kommentierte Beispiele in TestRExp.

 

Also, starten wir in die Lernkurve!

 

 

Einfache Treffer

 

Jedes einzelne Zeichen findet sich selbst, ausser es sei ein Metazeichen
mit einer speziellen Bedeutung (siehe weiter unten).

 

Eine Sequenz von Zeichen findet genau dieses Sequenz im zu
durchsuchenden String (Zielstring). Also findet das Muster (= reguläre
Ausdruck) "bluh" genau die Sequenz "bluh'' irgendwo im Zielstring. Ganz
einfach, nicht wahr?

 

Damit Du Zeichen, die üblicherweise als Metazeichen oder
Escape-Sequenzen dienen, als ganz normale Zeichen ohne jede Bedeutung
finden kannst, stelle so einem Zeichen einen "\\" voran. Diese Techninik
nennt man Escaping. Ein Beispiel: das Metazeichen "^" findet den Anfang
des Zielstrings, aber "\\^" findet das Zeichen "^" (Circumflex), "\\\\"
findet also "\\" etc.

 

Beispiele:

  foobar         findet den String 'foobar'

  \\^FooBarPtr     findet den String '^FooBarPtr'

 

 

Escape-Sequenzen

 

Zeichen könenn auch angeben werden mittels einer Escape-Sequenz, in der
Syntax ähnlich derer, die in C oder Perl benutzt wird: "\\n'' findet
eine neue Zeile, "\\t'' einen Tabulator etc. Etwas allgemeiner: \\xnn,
wobei nn ein String aus hexadezimalen Ziffern ist, findet das Zeichen,
dessen ASCII Code gleich nn ist. Falls Du Unicode-Zeichen (16 Bit breit
kodierte Zeichen) angeben möchtest, dann benutze '\\x{nnnn}', wobei
'nnnn' – eine oder mehrere hexadezimale Ziffern sind.

 

  \\xnn     Zeichen mit dem Hex-Code nn (ASCII-Text)

  \\x{nnnn} Zeichen mit dem Hex-Code nnnn (ein Byte für ASCII-Text und
zwei Bytes für
[Unicode](#tregexpr_interface.html#unicode_support)-Zeichen

  \\t       ein Tabulator (HT/TAB), gleichbedeutend wie \\x09

  \\n       Zeilenvorschub (NL), gleichbedeutend wie \\x0a

  \\r       Wagenrücklauf (CR), gleichbedeutend wie \\x0d

  \\f       Seitenvorschub (FF), gleichbedeutend wie \\x0c

  \\a       Alarm (bell) (BEL), gleichbedeutend wie \\x07

  \\e       Escape (ESC), gleichbedeutend wie \\x1b

 

Beispiele:

  foo\\x20bar   findet 'foo bar' (beachte den Leerschlag in der Mitte)

  \\tfoobar     findet 'foobar', dem unmittelbar ein Tabulator vorangeht

 

 

Zeichenklassen

 

Du kannst sogenannte Zeichenklassen definieren, indem Du eine Liste von
Zeichen, eingeschlossen in eckige Klammern \[\], angibst. So eine
Zeichenklasse findet genau eines der aufgelisteten Zeichen Zeichen im
Zielstring.

 

Falls das erste aufgelistete Zeichen, das direkt nach dem "\[", ein "^"
ist, findet die Zeichenklasse jedes Zeichen ausser denjenigen in der
Liste.

 

Beispiele:

  foob\[aeiou\]r   findet die Strings 'foobar', 'foober' etc. aber nicht
'foobbr', 'foobcr' etc.

  foob\[^aeiou\]r findet die Strings 'foobbr', 'foobcr' etc. aber nicht
'foobar', 'foober' etc.

 

Innerhalb der Liste kann das Zeichen "-" benutzt werden, um einen
Bereich oder eine Menge von Zeichen zu definieren. So definiert a-z alle
Zeichen zwischen "a" and "z" inklusive.

 

Falls das Zeichen "-" selbst ein Mitglied der Zeichenklasse sein soll,
dann setze es als erstes oder letztes Zeichen in die Liste oder schьtze
es mit einem vorangestellten "\\" (escaping). Wenn das Zeichen "\]"
ebenfalls Mitglied der Zeichenklasse sein soll, dann setze es als erstes
Zeichen in die Liste oder escape es.

 

Beispiele:

  \[-az\]     findet 'a', 'z' und '-'

  \[az-\]     findet 'a', 'z' und '-'

  \[a\\-z\]     findet 'a', 'z' und '-'

  \[a-z\]     findet alle 26 Kleinbuchstaben von 'a' bis 'z'

  \[\\n-\\x0D\] findet eines der Zeichen  \#10, \#11, \#12 oder \#13.

  \[\\d-t\]     findet irgendeine Ziffer, '-' oder 't'.

  \[\]-a\]     findet irgendein Zeichen von '\]'..'a'.

 

 

Metazeichen

 

Metazeichen sind Zeichen mit speziellen Bedeutungen. Sie sind die Essenz
der regulдren Ausdrьcke. Es gibt verschiedene Arten von Metazeichen wie
unten beschrieben.

 

 

Metazeichen - Zeilenseparatoren

 

  ^   Beginn einer Zeile

  $   Ende einer Zeile

  \\A start of text

  \\Z end of text

  .   irgendein beliebiges Zeichen

 

Beispiele:

  ^foobar     findet den String 'foobar' nur, wenn es am Zeilenanfang
vorkommt

  foobar$     findet den String 'foobar' nur, wenn es am Zeilenende
vorkommt

  ^foobar$   findet den String 'foobar' nur, wenn er der einzige String
in der Zeile ist

  foob.r     findet Strings wie 'foobar', 'foobbr', 'foob1r' etc.

 

Standardmässig garantiert das Metazeichen "^" nur, dass das Suchmuster
sich am Anfang des Zielstrings befinden muss, oder am Ende des
Zielstrings mit dem Metazeichen "$". Kommen im Zielstring
Zeilenseparatoren vor, so werden diese von "^" oder "$" nicht gefunden.

Du kannst allerdings den Zielstring als mehrzeiligen Puffer behandeln,
so dass "^" die Stelle unmittelbar nach, und "$" die Stelle unmittelbar
vor irgendeinem Zeilenseparator findet. Du kannst diese Art der Suche
einstellen mit dem [Modifikator /m](#regexp_syntax.html#modifier_m).

 

The \\A and \\Z are just like "^'' and "$'', except that they won't
match multiple times when the [modifier
/m](#regexp_syntax.html#modifier_m) is used, while "^'' and "$'' will
match at every internal line separator.

 

Das ".'' Metazeichen findet standardmässig irgendein beliebiges Zeichen,
also auch Zeilenseparatoren. Wenn Du den [Modifikator
/s](#regexp_syntax.html#modifier_s)

 

ausschaltest, dann findet '.' keine Zeilenseparatoren mehr.

 

TRegExpr geht mit Zeilenseparatoren so um, wie es auf www.unicode.org
(http://www.unicode.org/unicode/reports/tr18/) empfohlen ist:

 

"^" ist am Anfang des Eingabestrings, und, falls der [Modifikator
/m](#regexp_syntax.html#modifier_m) gesetzt ist, auch unmitelbar folgend
einem Vorkommen von \\x0D\\x0A oder \\x0A or \\x0D (falls Du die
[Unicode-Version](#tregexpr_interface.html#unicode_support) von TregExpr
benutzst, dann auch nach \\x2028 oder  \\x2029 oder \\x0B oder \\x0C
oder \\x85). Beachte, dass es keine leere Zeile gibt in den Sequence
\\x0D\\x0A. Diese beiden Zeichen werden atomar behandelt.

 

"$" ist am Anfang des Eingabestrings, und, falls der [Modifikator
/m](#regexp_syntax.html#modifier_m) gesetzt ist, auch unmitelbar vor
einem Vorkommen von \\x0D\\x0A oder \\x0A or \\x0D (falls Du die
[Unicode-Version](#tregexpr_interface.html#unicode_support) von TregExpr
benutzst, dann auch vor \\x2028 oder  \\x2029 oder \\x0B oder \\x0C oder
\\x85). Beachte, dass es keine leere Zeile gibt in den Sequence
\\x0D\\x0A. Diese beiden Zeichen werden atomar behandelt.

 

"." findet ein beliebiges Zeichen. Wenn Du aber den [Modifikator
/s](#regexp_syntax.html#modifier_s) ausstellst, dann findet "." keine
Zeilensearaptoren \\x0D\\x0A und \\x0A und \\x0D mehr (falls Du die
[Unicode-Version](#tregexpr_interface.html#unicode_support) von TregExpr
benutzst, dann auch \\x2028 und  \\x2029 und \\x0B und \\x0C and \\x85).

 

Beachte, dass "^.\*$" (was auch eine leere Zeile findet können sollte)
dennoch nicht den leeren String innerhalb der Sequence \\x0D\\x0A
findet, aber es findet den Leerstring innerhalb der Sequenz \\x0A\\x0D.

 

Die Behandlung des Zielstrings als mehrzeiliger String kann leicht
Deinen Bedürfnissen angepasst werden dank der TregExpr-Eigenschaften
[LineSeparators](#tregexpr_interface.html#lineseparators) und
[LinePairedSeparator](#tregexpr_interface.html#linepairedseparator). Du
kannst nur den UNIX-Stil Zeilenseparator \\n benutzen oder nur DOS-Stil
Separatoren \\r\\n oder beide gelichzeitig (wie schon oben beschrieben
und wie es als Standard gesetzt ist). Du kannst auch Deine eigenen
Zeilenseparatoren definieren!

 

 

Metazeichen – vordefinierte Klassen

 

  \\w     ein alphanumerisches Zeichen inklusive "\_"

  \\W     kein alphanumerisches Zeichen, auch kein "\_"

  \\d     ein numerisches Zeichen

  \\D     kein numerisches Zeichen

  \\s     irgendein wцrtertrennendes Zeichen (entspricht \[
\\t\\n\\r\\f\])

  \\S     kein wцrtertrennendes Zeichen

 

Du kannst \\w, \\d und \\s innerhalb Deiner selbstdefinierten
Zeichenklassen benutzen.

 

Beispiele:

  foob\\dr     findet Strings wie 'foob1r', ''foob6r' etc., aber not
'foobar', 'foobbr' etc.

  foob\[\\w\\s\]r findet Strings wie 'foobar', 'foob r', 'foobbr' etc.,
aber nicht 'foob1r', 'foob=r' etc.

 

TRegExpr benutzt die Eigenschaften
[SpaceChars](#tregexpr_interface.html#tregexpr.spacechars) und
[WordChars](#tregexpr_interface.html#tregexpr.wordchars), um die
Zeichenklassen \\w, \\W, \\s, \\S zu definieren. Somit kannst Du sie
auch leicht umdefinieren.

 

 

Metazeichen – Wortgrenzen

 

 \\b     findet eine Wortgrenze

 \\B    findet alles ausser einer Wortgrenze

 

Eine Wortgrenze (\\b) is der Ort zwischen zwei Zeichen, welcher ein \\w
auf der einen und ein \\W auf der anderen Seite hat bzw. umgekehrt. \\b
bezeichnet alle Zeichen des \\w bis vor das erste Zeichen des \\W bzw.
umgekehrt.

 

 

Metazeichen - Iteratoren

 

Jeder Teil eines regulдren Ausdruckes kann gefolgt werden von einer
anderen Art von Metazeichen – den Iteratoren. Dank dieser Metazeichen
kannst Du die Hдufigkeit des Auftretens des Suchmusters im Zielstring
definieren. Dies gilt jeweils fьr das vor diesem Metazeichen stehenden
Zeichen, das Metazeichen oder den Teilausdruck.

 

  \*     kein- oder mehrmaliges Vorkommen ("gierig"), gleichbedeutend
wie {0,}

  +   ein- oder mehrmaliges Vorkommen ("gierig"), gleichbedeutend wie
{1,}

  ?   kein- oder einmaliges Vorkommen  ("gierig"), gleichbedeutend wie
{0,1}

  {n}   genau n-maliges Vorkommen ("gierig")

  {n,}   mindestens n-maliges Vorkommen ("gierig")

  {n,m} mindestens n-, aber hцchstens m-maliges Vorkommen ("gierig")

  \*?     kein- oder mehrmaliges Vorkommen ("genьgsam"), gleichbedeutend
wie {0,}?

  +?     ein oder mehrmaliges Vorkommen ("genьgsam"), gleichbedeutend
wie {1,}?

  ??     kein- oder einmaliges Vorkommen ("genьgsam"), gleichbedeutend
wie {0,1}?

  {n}?   genau n-maliges Vorkommen ("genьgsam")

  {n,}? Mindestens n-maliges Vorkommen ("genьgsam")

  {n,m}? mindestens n-, aber hцchstens m-maliges Vorkommen ("genьgsam")

 

Also, die Ziffern in den geshcweiften Klammern in der Form {n,m} geben
an, wieviele Male das Suchmuster im Zielstring gefunden muss, um einen
Treffer zu ergeben. Die Angabe {n} ist gleichbedeutend wie {n,n} und
findet genau n Vorkommen. Die Form {n,} findet n oder mehre Vorkommen.
Es gibt keine Limiten fьr die Zahlen n und m. Aber je grцsser sie sind,
desto mehr Speicher und Zeit wird benцtigt, um den regulдren Ausdruck
auszuwerten.

 

Falls eine geschweifte Klammer in einem anderen als dem eben
vorgestellten Kontext vorkommt, wird es wie ein normales Zeichen
behandelt.

 

Beispiele:

  foob.\*r     findet Strings wie 'foobar',  'foobalkjdflkj9r' und
'foobr'

  foob.+r     findet Strings wie 'foobar', 'foobalkjdflkj9r', aber nicht
'foobr'

  foob.?r     findet Strings wie 'foobar', 'foobbr' und 'foobr', aber
nicht 'foobalkj9r'

  fooba{2}r   findet den String 'foobaar'

  fooba{2,}r findet Strings wie 'foobaar', 'foobaaar', 'foobaaaar' etc.

  fooba{2,3}r findet Strings wie 'foobaar', or 'foobaaar', aber nicht
'foobaaaar'

 

Eine kleine Erklärung zum Thema "gierig" oder "genügsam". "Gierig" nimmt
soviel wie möglich, wohingegen "genügsam" bereits mit dem ersten
Erfüllen des Suchmusters zufrieden ist. Beispiel: 'b+' und 'b\*'
angewandut auf den Zielstring 'abbbbc' findet 'bbbb', 'b+?' findet 'b',
'b\*?' findet den leeren String, 'b{2,3}?' findet 'bb', 'b{2,3}' findet
'bbb'.

 

Du kannst alle Iteratoren auf den genugsamen Modus umschalten mit dem
[Modifier /g](#regexp_syntax.html#modifier_g).

 

 

Metazeichen - Alternativen

 

Du kannst eine Serie von Alternativen fьr eine Suchmuster angeben, indem
Du diese mit einem "|'' trennst. Auf diese Art findet das Suchmuster
fee|fie|foe eines von "fee", "fie", oder "foe" im Zielstring – dies
wьrde auch mit f(e|i|o)e ereicht.

 

Die erste Alternative beinhaltet alles vom letzten Muster-Limiter ("(",
"\[" oder natьrlich der Anfang des Suchmusters) bis zum ersten "|". Die
letzte Alternative beinhaltet alles vom letzten "|" bis zum nдchsten
Muster-Limiter. Aus diesem Grunde ist es allgemein eine gute Gewohnheit,
die Alternativen in Klammern anzugeben, um mцglichen Missverstдndnissen
darьber vorzubeugen, wo die Alternativen beginnen und enden.

 

Alternativen werden von links nach rechts gepьrft, so dass der Treffer
im Zielstring zusammengesetzt ist aus den jeweils zuerst passenden
Alternativen. Das bedeutet, dass Alternativen nicht notwendigerweise
"gierig" sind. Ein Beispiel: Wenn man mit "(foo|foot)" im Zielstring
"barefoot" sucht, so passt bereits die erste Variante. Diese Tatsache
mag nicht besonders wichtig erscheinen, aber es ist natьrlich wichtig,
wenn der gefundene Text weiterverwendet wird. Im Beispiel zuvor wьrde
der Benutzer nicht "foot" erhalten, wie er eventuell beabsichtigt hatte,
sondern nur "foo".

 

Erinnere Dich auch daran, dass das "|" innerhalb von eckigen Klammern
wie ein normales Zeichen behandelt wird, so dass \[fee|fie|foe\]
dasselbe bedeutet wie \[feio|\].

 

Beispiele:

  foo(bar|foo) findet die Strings 'foobar' oder 'foofoo'.

 

 

Metazeichen - Teilausdrьcke

 

Das KLammernkonstrukt (...) wird auch dazu benutzt, regulдre
Teilausdrьcke zu definieren (nach dem Parsen findest Du Positionen,
Lдngen und effektive Inhalte der regulдren Teilausdrьcke in den
TRegExpr-Eigenschaften MatchPos, MatchLen und
[Match](#tregexpr_interface.html#tregexpr.match) und kannst sie ersetzen
mit den Template-Strings in
[TRegExpr.Substitute](#tregexpr_interface.html#tregexpr.substitute)).

 

Teilausdrьcke werden nummeriert von links nach recht, jeweils in der
Reihenfolge ihrer цffnenden Klammer. Der erste Teilausdruck hat die
Nummer 1, der gesamte regulдre Ausdruck hat die Nummer 0 (der gesamte
Ausdruck kann ersetzt werden in
[TRegExpr.Substitute](#tregexpr_interface.html#tregexpr.substitute) als
'$0' oder '$&').

 

Beispiele:

  (foobar){8,10} findet Strings, die 8, 9 oder 10 Vorkommen von 'foobar'
beinhalten

  foob(\[0-9\]|a+)r findet 'foob0r', 'foob1r' , 'foobar', 'foobaar',
'foobaar' etc.

 

 

Metazeichen - Rьckwдrtsreferenzen

 

Die Metacharacters \\1 bis \\9 werden in Suchmustern interpretiert als
Rьckwдrtsreferenzen. \\&lt;n&gt; findet einen zuvor bereits gefundenen
Teilausdruck \#&lt;n&gt;.

 

Beispiele:

  (.)\\1+         findet 'aaaa' und 'cc'.

  (.+)\\1+       findet auch 'abab' und '123123'

  (\['"\]?)(\\d+)\\1 findet "13" (innerhalb "), oder '4' (innerhalb ')
oder auch 77, etc.

 

 

Modifikatoren

 

Modifikatoren sind dazu da, das Verhalten von TRegExpr zu verдndern.

 

Es gibt viele Wege, die weiter unten beschriebenen Modifikatoren zu
nutzen. Jeder der Modifikatoren lann eingebettet werden im Suchmuster
des regulдren Ausdruckes mittels des Konstruktes
[(?...)](#regexp_syntax.html#inline_modifiers).

 

Du kannst allerdings auch die meisten Modifikatoren beeinflussen, indem
Du den entsprechenden TRegExpr-Eigenschaften die passenden Werte zuweist
(Beispiel: Zuweisung an
[ModifierX](#tregexpr_interface.html#tregexpr.modifier_x) oder
ModifierStr fьr alle Modifikatoren zugleich).

 

Die Standardwerte fьr neue Instanzen von TRegExpr-Objekte sind definiert
in [globalen Variablen](#tregexpr_interface.html#modifier_defs).
Beispielsweise definiert die globale Variable RegExprModifierX das
Verhalten des Modifikators X und damit die Einstellung der
TRegExpr-Eigenschaft ModifierX bei neu instantiierten TRegExpr-Objekten.

 

i

Fьhre die Suche Schreibweisen-unabhдgig durch (allerdings abhдngig von
den Einstellungen in Deinem System, Lokale Einstellungen), (beachte auch
die [InvertCase](#tregexpr_interface.html#invertcase))

m

Behandle den Zielstring als mehrzeiligen String. Das bedeutet, дndere
die Bedeutungen von "^" und "$": Statt nur den Anfang oder das Ende des
Zielstrings zu finden, wird jeder Zeilenseparator innerhalb eines
Strings erkannt (beachte auch die
[Zeilenseparatoren](#tregexpr_interface.html#lineseparators))

s

Behandle den Zielstring als einzelne Zeile. Das bedeutet, dass "." jedes
beliebige Zeichen findet, sogar Zeilenseparatoren (beachte auch
[Zeilenseparatoren](#tregexpr_interface.html#lineseparators)), die es
normalerweise nicht findet.

g

Modifikator fьr den "Genьgsam"-Modus. Durch das Ausstellen werden alle
folgenden Operatoren in den "Genugsam"-Modus. Standardmassig sind alle
Operatoren "gierig". Wenn also der Modifikator /g aus ist, dann arbeitet
'+' wie '+?', '\*' als '\*?' etc.

x

Erweitert die Lesbarkeit des Suchmusters durch Whitespace und Kommentare
(beachte die Erklдrung unten).

r

Modifikator. Falls er gesetzt ist, beinhaltet die Zeichenklasse а-я
zusätzliche russissche Buchstaben 'ё', А-Я beinhaltet zusätzlich 'Ё',
und а-Я beinhaltet alle russischen Symbole.

Sorry für fremdsprachliche Benutzer, er ist gesetzt standardmässig.
Falls Du ihn ausgeschaltet haben willst standardässig, dann setze die
globale Variable
[RegExprModifierR](#tregexpr_interface.html#modifier_defs) auf false.

 

 

Der [Modifikator /x](#regexp_syntax.html#modifier_x) selbst braucht
etwas mehr Erklärung. Er sagt TRegExpr, dass er allen Whitespace
ignorieren soll, der nicht escaped oder innerhalb einer Zeichenklasse
ist. Du kannst ihn benutzen, um den regulären Ausdruck in kleinere,
besser lesbare Teile zu zerlegen. Das Zeichen \# wird nun ebenfalls als
Metazeichen behandelt und leitet einen Kommentar bis zum Zeilenende ein.
Beispiel:

 

(

(abc) \# Kommentar 1

  |   \# Du kannst Leerschlдge zur Formatierung benutzen - TRegExpr
ignoriert sie

(efg) \# Kommentar 2

)

 

Dies bedeutet auch, wenn Du echten Whitespace oder das \# im Suchmuster
haben mцchtest (ausserhalb einer Zeichenklasse, wo sie unbehelligt von
/x sind), dann muss der entweder escaped oder mit der hexadezimalen
Schreibweise angegeben werden. Beides zusammen sorgt dafьr, dass
regulдre Ausdrьcke besser lesbar werden.

 

 

Perl Erweiterungen

 

(?imsxr-imsxr)

Dies kann benutzt werden in Regulдren Ausdrьcken, um Modifikatoren
innerhalb eines Ausdruckes im Flug zu дndern. Wenn dieses Konstrukt
innerhalb eines Teilausdruckes erscheint, betriefft er auch nur diesen.

 

Beispiele:

  (?i)Saint-Petersburg       findet 'Saint-petersburg' und
'Saint-Petersburg'

  (?i)Saint-(?-i)Petersburg findet 'Saint-Petersburg', aber nicht
'Saint-petersburg'

  (?i)(Saint-)?Petersburg   findet 'Saint-petersburg' und
'saint-petersburg'

  ((?i)Saint-)?Petersburg   findet 'saint-Petersburg', aber nicht
'saint-petersburg'

 

 

(?\#text)

Ein Kommentar, der Text wird ignoriert. Beachte, dass TRegExpr den
Kommentar abschliesst, sobald er eine ")" sieht. Es gibt also keine
Mцglichkeit, das Zeichen ")" im Kommentar zu haben.

 

 

Erklдrung der internen Mechanismen

 

So, es scheint also, als möchtest Du einige Geheimnisse der internen
Mechanismen von TRegExpr erklärt bekommen? Nun, dieser Abschnitt ist im
Aufbau – bitte sei etwas geduldig. Bis heute empfehle ich Dir die
[FAQ](#faq.html) (zu lesen, speziell zu den Fragen der Optimierungen
beim ["genügsamen" Modus](#faq.html#nongreedyoptimization)).

 

TRegExpr Interface
==================

Public Methoden und Eigenschaften von TRegExpr:

 

class function VersionMajor: integer;

class function VersionMinor: integer;

Sie geben die grosse und kleine Versionsummer zurück, Beispiel 0.944
ergibt: VersionMajor = 0 und VersionMinor = 944

 

property Expression : string

Regulärer Ausdruck

Aus Optimierungsgründen übersetzt TRegExpr den regulären Ausdruck in den
P-Code, den Du kannst ihn sehen mittels der Methode Dump. Der P-Code
wird in den internen Strukturen gespeichert.

Eine \[Neu\]Übersetzung findet nur statt, wenn sie wirklich benötigt
wird, beim Aufruf von Exec, ExecNext, Substitute, Dump etc. und auch
dann nur, wenn der reguläre Ausdruck oder eine ihn betreffende
Eigenschaft geändert wurde seit der letzten \[Neu\]Übersetzung.

Falls ein Übersetzungsfehler auftaucht, wird die Methode Error
aufgerufen. Diese erzeugt standardmässig eine Ausnahme vom Typ ERegExpr
– siehe unten

 

property ModifierStr : string

Setze / hole die Standardwerte für die
[Modifikatoren](#regexp_syntax.html#about_modifiers). Modifikatoren in
Regulären Ausdrücken
[(?ismx-ismx)](#regexp_syntax.html#inline_modifiers) ersetzen diese
Standardwerte. Falls Du nicht unterstützte Modifikatoren setzst, wird
die Methode Error aufgerufen, die standardmässig eine Ausnahme vom Typ
EregExpr erzeugt.

 

property ModifierI : boolean

[Modifikator /i](#regexp_syntax.html#modifier_i) – Gross- oder
Kleinschreibweise wird nicht berücksichtigt. Standardmässig False

 

property ModifierR : boolean

[Modiifikator /r](#regexp_syntax.html#modifier_r) – benutze die für
Russen erweiterte Syntax. Standardmässig True. (war die Eigenschaft
ExtSyntaxEnabled in früheren Versionen)

 

property ModifierS : boolean

[Modifikator /s](#regexp_syntax.html#modifier_s) - '.' findet jedes
beliebige Zeichen (sonst wie \[^\\n\]). Standardmässig True.

 

property ModifierG : boolean

[Modifikator /g](#regexp_syntax.html#modifier_g) – schaltet alle
Operatoren in den genügsamen Modus. Falls ModifierG False ist, dann
arbeitet '\*' als '\*?', und '+' als '+?' und so weiter. Standardmässig
True.

 

property ModifierM : boolean

[Modifikator /m](#regexp_syntax.html#modifier_m) – Behandelt den
Zielstring als mehrzeiligen String. So finden "^" und "$" nicht mehr nur
den Anfang und das Ende des Zielstringes, sondern auch Zeilenseparatoren
innerhalb des Zielstrings. Standardmässig False.

 

property ModifierX : boolean

[Modifikator /x](#regexp_syntax.html#modifier_x) – Erweiterte Syntax,
erlaubt das Formatieren des regulärenm Ausdruckes zur besseren
Lesbarkeit. Standardmässig False.

 

function Exec (const AInputString : string) : boolean;

Lässt einen Regulären Ausdruck auf einem Zielstring ablaufen. Exec
speichert AInputString in der Eigenschaft InputString

For Delphi 5 and higher available overloaded versions:

function Exec : boolean;

without parameter (uses already assigned to InputString property value)

function Exec (AOffset: integer) : boolean;

is same as ExecPos

 

function ExecNext : boolean;

Findet nächsten Treffer:

   ExecNext;

Arbeitet gleich wie

  if MatchLen \[0\] = 0 then ExecPos (MatchPos \[0\] + 1)

    else ExecPos (MatchPos \[0\] + MatchLen \[0\]);

ist aber viel einfacher!

Raises exception if used without preceeding successful call to

Exec\* (Exec, ExecPos, ExecNext). So You always must use something like

if Exec (InputString) then repeat { proceed results} until not ExecNext;

 

function ExecPos (AOffset: integer = 1) : boolean;

Findet einen Treffer im Zielstring, jedoch beginnend ab Position
Aoffset. (Hinweis: AOffset=1 – das erste Zeichen im Zielstring)

 

property InputString : string;

Gibt den aktuellen Zielstring zurück (vom letzten Exec-Aufruf oder der
letzten Zuweisung an diese Eigenschaft. Eine Zuweisung an diese
Eigenschaft löscht die Match\*-Eigenschaften!

 

function Substitute (const ATemplate : string) : string;

Gibt ATemplate mit durch $& oder $0 ersetztem Regulären Ausdruck und
durch die Vorkommen von Regulären Unterausdrücken ersetzten $n zurück.
Seit Version v.0.929 wird das '$' anstelle des '\\' verwendet (aus
Gründen der künfitgen Erweiterbarkeit und der besseren Kompatibilität zu
Perl) und es akzeptiert mehr als eine Ziffer. Falls Du die Zeichen $
oder \\ als Literale in einem Template verwenden möchtest, nutze das
vorangestellte Escape-Zeichen: Beispiel:

   '1\\$ is $2\\\\rub\\\\' -&gt; '1$ is &lt;Match\[2\]&gt;\\rub\\'

Falls Du eine Ziffer als Literal hinter einem $n plazieren möchtest,
dann musst Du das n mit geschweiften Klammern {} begrenzen: Beispiel:

   'a$12bc' -&gt; 'a&lt;Match\[12\]&gt;bc'

   'a${1}2bc' -&gt; 'a&lt;Match\[1\]&gt;2bc'.

 

procedure Split (AInputStr : string; APieces : TStrings);

Zerlege AInputStr in die Einzelteile APieces mit den Treffern des
Regulären Ausdruckes als Trenner

 

function Replace (AInputStr : RegExprString;

 const AReplaceStr : RegExprString;

 AUseSubstitution : boolean = False) : RegExprString;

function Replace (AInputStr : RegExprString;

 AReplaceFunc : TRegExprReplaceFunction) : RegExprString;

function ReplaceEx (AInputStr : RegExprString;

 AReplaceFunc : TRegExprReplaceFunction)  : RegExprString;

Gibt AInputStr mit den Treffern des regulären Ausdruckes ersetzt durch
AReplaceStr. Wenn AUseSubstitution true ist, wird AReplaceStr genutzt
als Vorlage für die Ersetzungsmethoden.

Beispiel:

  Expression := '({-i}block|var)\\s\*\\(\\s\*(\[^ \]\*)\\s\*\\)\\s\*';

  Replace ('BLOCK( test1)', 'def "$1" value "$2"', True);

   gibt zurück:  def 'BLOCK' value 'test1'

  Replace ('BLOCK( test1)', 'def "$1" value "$2"', False)

   gibt zurück:  def "$1" value "$2"

Ruft intern Exec\[Next\] auf.

Overloaded version and ReplaceEx operate with call-back function,

so You can implement really complex functionality.

 

 

property SubExprMatchCount : integer; // ReadOnly

Die Anzahl der Unterausdrücke, die beim letzten Exec-Aufruf gefunden
wurde. Falls keine Unterausdrücke gefunden wurden, aber der gesamte
Reguläre Ausdruck schon (Exec gab True zurück), ist dieser Wert 0. Falls
weder Unterausdrücke noch der gesamte Reguläre Ausdruck gefunden wurde
(Exec gab False zurück), dann ist dieser Wert –1. Beachte, dass einige
Unterausdrücke eventuell nicht gefunden werden können und für solche
Unterausdrücke gilt:

MathPos=MatchLen=-1 and Match=''.

Beispiel: Ausdruck := '(1)?2(3)?';

Exec ('123'): SubExprMatchCount=2, Match\[0\]='123', \[1\]='1',
\[2\]='3'

Exec ('12'): SubExprMatchCount=1, Match\[0\]='23', \[1\]='1'

Exec ('23'): SubExprMatchCount=2, Match\[0\]='23', \[1\]='', \[2\]='3'

Exec ('2'): SubExprMatchCount=0, Match\[0\]='2'

Exec ('7') - ergibt False: SubExprMatchCount=-1

 

property MatchPos \[Idx : integer\] : integer; // ReadOnly

Position des Starts des Unterausdruckes mit der Nummer Idx, gefunden
beim letzten Exec-Aufruf. Der erste Unterausdruck hat Idx=1, der Letzte
– MatchCount. Der gesamte Reguläre Ausdruck hat Idx=0. Gibt –1 zurück,
wenn entweder der gewünschte Unterausdruck im Regulären Ausdruck nicht
vorhanden ist oder im Zielstring nicht gefunden wurde.

 

property MatchLen \[Idx : integer\] : integer; // ReadOnly

(\* Die Länge des Unterausdruckes mit der Nummer Idx. Numerierung und
Rückgabewert wie bei MatchPos. \*)

 

  property Match \[Idx : integer\] : string; // ReadOnly

== copy (InputString, MatchPos \[Idx\], MatchLen \[Idx\])

Gibt einen Leerstring zurück, wenn entweder der gewünschte Unterausdruck
im Regulären Ausdruck nicht vorhanden ist oder im Zielstring nicht
gefunden wurde

 

function LastError : integer;

Gibt die ID des letzten Fehler zurück, 0 für keinen Fehler. Nicht zu
verwenden, wenn die Error Methode eine Ausnahme erzeugt. Setzt den
internen Fehlerzustand zurück auf 0.

 

function ErrorMsg (AErrorID : integer) : string; virtual;

Gibt die Fehlermeldung zur Fehler-ID AErrorID zurück.

 

property CompilerErrorPos : integer; // ReadOnly

Gibt die Position im Regulären Ausdruck zurück, wo der Compiler beim
Übersetzen stoppte. Nützlich bei der Fehlerdiagnose.

 

property SpaceChars : RegExprString

Beinhaltet die Zeichen, die für das Metazeichen \\s verwendet werden.
Anfänglich gefüllt mit der globalen Konstanten RegExprSpaceChars.

 

property WordChars : RegExprString

Beinhaltet die Zeichen, die für das Metazeichen \\w verwendet werden.
Anfänglich gefüllt mit der globalen Konstanten RegExprWordChars.

 

property LineSeparators : RegExprString

Beinhaltet die Zeichen, die für Zeilenseparatoren wie \\n in UNIX
verwendet werden. Anfänglich gefüllt mit der globalen Konstanten
RegExprLineSeparators. Beachte auch
[Zeilenseparatoren](#regexp_syntax.html#syntax_line_separators)

 

property LinePairedSeparators : RegExprString

Beinhaltet die Zeichen, die paarweise für Zeilenseparatoren wie \\r\\n
in DOS/Windows verwendet werden. Es müssen genau zwei oder gar keine
Zeichen sein. Anfänglich gefüllt mit der globalen Konstanten
RegExprLinePairedSeparators. Beachte auch
[Zeilenseparatoren](#regexp_syntax.html#syntax_line_separators)

 

Beispiel: Wenn Du den UNIX-Stil als Zeilenseparatoren haben möchtest,
dann weise LineSeparators := \#$a (Newline Zeichen) und
LinePairedSeparator := '' (Leerstring) zu. Wenn Du als Zeilenseparatoren
nur genau \\x0D\\x0A akzeptieren möchtest, jedoch nicht \\x0D oder \\x0A
aleine, dann weise LineSeparators := '' (Leerstring) und
LinePairedSeparator := \#$d\#$a zu.

 

Standardmässig ist der gemsichte Modus aktiv wie er definiert ist in den
globalen Konstanten RegExprLine\[Paired\]Separator\[s\]: LineSeparators
:= \#$d\#$a; LinePairedSeparator := \#$d\#$a. Das Verhalten dieses Modus
wird ausführlich im Abschnitt [Syntax
besprochen](#regexp_syntax.html#syntax_line_separators).

 

class function InvertCaseFunction  (const Ch : REChar) : REChar;

Wandelt Ch in Grossschreibweise um, wenn er in Kleinschreibweise
vorliegt oder umgekehrt. Die aktuellen lokalen System-Einstellungen
werden dafür benutzt.

 

property InvertCase : TRegExprInvertCaseFunction;

Setze diese Eigenschaft, wenn Du die
[Umwandlungsfunktion](#regexp_syntax.html#modifier_i) zwischen der
Gross- oder Kleinschreibung durch eine eigene ersetzen möchtest.
Standardmässig auf InvertCaseFunction gesetzt.

 

procedure Compile;

Übersetzt den regulären Ausdruck \[erneut\]. Nützlich für das
interaktive Erstellen eines regulären Ausdruckes in einem Editor, zur
Prüfung der Gültigkeit aller Parameter, etc.

 

function Dump : string;

Gibt den übersetzten Regulären Ausdruck in knapp verständlicher Form
zurück.

 

 

Globale Konstanten

 

 EscChar = '\\';  // 'Escape'-char ('\\' in common r.e.) used for
escaping metachars (\\w, \\d etc).

 // it's may be usefull to redefine it if You are using C++ Builder - to
avoide ugly constructions

 // like '\\\\w+\\\\\\\\\\\\w+\\\\.\\\\w+' - just define EscChar='/' and
use '/w+\\/w+/./w+'

 

Standardmдssig fьr Modifikatoren

RegExprModifierI : boolean = False;        //
[TRegExpr.ModifierI](#tregexpr_interface.html#tregexpr.modifier_i)

RegExprModifierR : boolean = True;        //
[TRegExpr.ModifierR](#tregexpr_interface.html#tregexpr.modifier_r)

RegExprModifierS : boolean = True;        //
[TRegExpr.ModifierS](#tregexpr_interface.html#tregexpr.modifier_s)

RegExprModifierG : boolean = True;        //
[TRegExpr.ModifierG](#tregexpr_interface.html#tregexpr.modifier_g)

RegExprModifierM : boolean = False;        //
[TRegExpr.ModifierM](#tregexpr_interface.html#tregexpr.modifier_m)

RegExprModifierX : boolean = False;        //
[TRegExpr.ModifierX](#tregexpr_interface.html#tregexpr.modifier_x)

 

RegExprSpaceChars : RegExprString = ' '\#$9\#$A\#$D\#$C;

 // Standardbelegung für die Eigenschaft SpaceChars

 

RegExprWordChars : RegExprString =

    '0123456789'

 + 'abcdefghijklmnopqrstuvwxyz'

 + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ\_';

 // Standardbelegung für die Eigenschaft WordChars

 

RegExprLineSeparators : RegExprString =

 \#$D\#$A{$IFDEF UniCode}\#$B\#$C\#$2028\#$2029\#$85{$ENDIF};

 // Standardbelegung für die Eigenschaft LineSeparators

 

RegExprLinePairedSeparators : RegExprString = ' '\#$D\#$A;

 // Standardbelegung für die Eigenschaft LinePairedSeparators

 

RegExprInvertCaseFunction : TRegExprInvertCaseFunction =
TRegExpr.InvertCaseFunction;

 // Standardbelegung für die Eigenschaft InvertCase

 

function RegExprSubExpressions (const ARegExpr : string;

ASubExprs : TStrings; AExtendedSyntax : boolean = False) : integer;

Erzeugt eine Liste der Teilausdrücke in einem regulären Ausdruck.

In ASubExps repräsentiert jeder String einen Teilausdruck, beginnend mit
dem ersten bis zum letzten, im Format:

 String – Teilausdruck-Text (ohne die Klammern '()')

 Low Word (TString.Object) - Startposition im ARegExpr, inklusive '('
falls einer existiert (die erste Position ist 1)

 High Word (TString.Object) – Länge, inklusive Start-'(' und End-')'
falls einer existiert.

AExtendedSyntax - must be True if modifier /x will be On while

using the r.e.

Nützlich für GUIs für Editoren für reguläre Ausdrücke etc. (Du findest
ein Beispiel davon im Projekt)

 

Result code        Meaning

------------------------------------------------------------------------

0                Success. No unbalanced brackets was found;

-1                there are not enough closing brackets ')';

-(n+1)                at position n was found opening '\[' without
corresponding closing '\]';

n                at position n was found closing bracket ')' without
corresponding opening '('.

 

// Falls Result &lt;&gt; 0, dann könnten in ASubExprs auch leere Items
enthalten sein.

 

 

 

Nützliche globale Functionen

 

function ExecRegExpr (const ARegExpr, AInputStr : string) : boolean;

True, wenn in AInputString der Reguläre Ausdruck AregExpr gefunden wird.
Erzeugt eine Ausnahme, wenn es Syntaxfehler hat in AregExpr

 

procedure SplitRegExpr (const ARegExpr, AInputStr : string; APieces :
TStrings);

Zerlegt AInputStr in die Einzelteile APieces getrennt durch die Treffer
des Regulären Ausdruckes ARegExpr.

 

function ReplaceRegExpr (const ARegExpr, AInputStr, AReplaceStr :
string) : string;

Gibt AInputStr mit den Treffern des regulären Audruckes ersetzt durch
AReplaceStr. Wenn AUseSubstitution true ist, wird AReplaceStr genutzt
als Vorlage für die Ersetzungsmethoden.

Beispiel:

ReplaceRegExpr ('({-i}block|var)\\s\*\\(\\s\*(\[^ \]\*)\\s\*\\)\\s\*',

  'BLOCK( test1)', 'def "$1" value "$2"', True)

gibt zurück:  def 'BLOCK' value 'test1'

ReplaceRegExpr ('({-i}block|var)\\s\*\\(\\s\*(\[^ \]\*)\\s\*\\)\\s\*',

  'BLOCK( test1)', 'def "$1" value "$2"')

  gibt zurück:  def "$1" value "$2"

ReplaceRegExpr ('({-i}block|var)\\s\*\\(\\s\*(\[^ \]\*)\\s\*\\)\\s\*',

  'BLOCK( test1)', 'def "$1" value "$2"', True)

gibt zurück:  def 'BLOCK' value 'test1'

ReplaceRegExpr ('({-i}block|var)\\s\*\\(\\s\*(\[^ \]\*)\\s\*\\)\\s\*',

  'BLOCK( test1)', 'def "$1" value "$2"')

  gibt zurück:  def "$1" value "$2"

 

 

function QuoteRegExprMetaChars (const AStr : string) : string;

Ersetze alle Metazeichen durch deren sichere Repräsentationen. Beispiel:

 'abc$cd.(' wird gewandelt in 'abc\\$cd\\.\\('

Diese Funktion ist nützlich, wenn ein Benutzer einen Regulären Ausdruck
selbst zusammenstellen darf, ohne sich um das Escaping kümmern zu
müssen.

 

Ausnahme Typ

 

Die standardmässige Fehlerbehandlungsroutine erzeugt folgende Ausnahme:

 

ERegExpr = class (Exception)

  public

   ErrorCode : integer; // Error-Code. Übersetzungsfehler haben Codes
&lt; 1000.

   CompilerErrorPos : integer; // Position im Regulären Ausdruck, wo der
Übersetzungsfehler auftauchte

 end;

 

Wie wird Unicode benutzt?

 

TRegExpr unterstützt nun UniCode, aber leider sehr langsam :(

Wer möchte dies optimieren? ;)

Benütze es nur, wenn Du wirklich nicht auf Unicode-Unterstützung
verzichten kannst!

Entferne '.' aus {.$DEFINE UniCode} in regexpr.pas. Danach werden alle
Strings als Delphis WideString (= Unicode) behandelt

 

Das Demo-Projekt (TestRExp)
===========================

 

Die Demo ist ein einfaches Programm, um mit den Regulären Ausdrücken zu
spielen, sie kennenzulernen und eigene Ausdrücke zu testen Es ist im
Quelltext vorhanden im Projekt TestRExp.dpr) und als TestRExp.exe.

 

Beachte, dass es einige VCL-Eigenschaften verwendet, die nur in Delphi 4
oder höher vorhanden sind. Wenn Du es unter Delphi 2 oder 3 übersetzst,
wirst Du Fehlermeldungen erhalten über unbekannte Eigenschaften. Du
kannst diese Meldungen ignorieren – diese Eigenschaften werden nur fürs
Anpassen der Komponenten auf dem Formular beim Ändern der Grösse des
Formulars verwendet.

 

Mit Hilfe dieses Programmens kannst Du unter anderem leicht die Anzahl
der Teilausdrücke eines komplexeren regulären Ausdruckes bestimmen. Du
kannst zu jedem dieser Teilausdrücke springen, sowohl im Eingabe- wie
auch im Zielstring, kannst mit den Funktionen Substitute, Replace und
Split functions etc. spielen.

 

Darüberhinaus sind im Demo-Projekt zahlreiche Beispiele – benutze sie
als Lernobjekte, um entweder die Syntax der regulären Ausdrücke oder
TRegExpr kennenzulernen

Example: Hyper Links Decorator
==============================

[DecorateURLs](#hyperlinksdecorator.html#decorateurls)  
[DecorateEMails](#hyperlinksdecorator.html#decorateemails)

Funktionen um reine URLs in HTML-Anker (aka Links) umzuwandeln.

 

Beispiel: Ersetze 'http://anso.da.ru' mit '&lt;a
href="http://anso.da.ru"&gt;anso.da.ru&lt;/a&gt;'

oder 'anso@mail.ru' mit '&lt;a
href="mailto:anso@mail.ru"&gt;anso@mail.ru&lt;/a&gt;'.

 

Funktionen DecorateURLs

 

Findet URLs wie 'http://...' or 'ftp://..', aber auch solche, die mit
'www.' Beginnen. E-Mailadressen werden mit der Function
[DecorateEMails](#hyperlinksdecorator.html#decorateemails) umgewandelt.

 

function DecorateURLs (const AText : string; AFlags :
TDecorateURLsFlagSet = \[durlAddr, durlPath\]) : string;

 

Beschreibung

 

Gibt den Eingabetext AText mit umgewandelten URLs zurück

 

AFlags welche gefundenen Teile der URL müssen in den sichtbaren Teil.
Beispiel: Wenn \[durlAddr\] dann wird die URL
'http://anso.da.ru/index.htm' zu '&lt;a
href="http://anso.da.ru/index.htm"&gt;anso.da.ru&lt;/a&gt;'

 

type

 TDecorateURLsFlags = (durlProto, durlAddr, durlPort, durlPath,
durlBMark, durlParam);

 TDecorateURLsFlagSet = set of TDecorateURLsFlags;

 

Beschreibung

 

Dies sind die mцglichen Werte:

 

Benennung        Bedeutungen

------------------------------------------------------------------------

 

durlProto        Protokoll (wie 'ftp://' or 'http://')

durlAddr        TCP Adresse oder Domain-Name (wie 'anso.da.ru')

durlPort                Port falls angeben (wie ':8080')

durlPath        Pfad zum Dokument (wie 'index.htm')

durlBMark        Bookmark (wie '\#mark')

durlParam        URL Parameters (wie '?ID=2&User=13')

 

 

Funktionen DecorateEMails

 

Ersetzt alle korrekten E-Mails-URLs mit '&lt;a
href="mailto:ADDR"&gt;ADDR&lt;/a&gt;' Beispiel: Ersetze 'anso@mail.ru'
mit '&lt;a href="mailto:anso@mail.ru"&gt;anso@mail.ru&lt;/a&gt;'.

 

function DecorateEMails (const AText : string) : string;

 

Beschreibung

 

Gibt den Eingabetext AText mit umgewandelten E-Mail-Links zurück

 

FAQ
===

F.

Wie kann ich TRegExpr mit Borland C++ Builder benutzen?

Ich habe ein Problem, weil offensichtlich die Header Datei fehlt (.h or
.hpp).

A.

•Füge RegExpr.pas zum BCB Projekt hinzu.

•Kompiliere das Projekt. Dies generiert die Header Datei RegExpr.hpp.

•Nun kann Programmcode geschrieben werden, der die RegExpr unit
benutzt.Nicht vergessen den Verweis auf die Header Datei (\#include
"RegExpr.hpp") einzufügen, wo dies nötig ist.

•Don't forget to replace all '\\' in regular expressions with '\\\\'.

 

F.

Why many r.e. (including r.e. from TRegExpr help and demo) work wrong in
Borland C++ Builder?

A.

Please, reread answer to previous question ;) Symbol '\\' has special
treting in C++, so You have to 'escape' it (as described in
prev.answer). But if You don't like r.e. like
'\\\\w+\\\\\\\\\\\\w+\\\\.\\\\w+' You can redefine constant EscChar
(RegExpr.pas), for example EscChar='/' - then r.e. will be
'/w+\\/w+/./w+', sligtly unusual but more readable..

 

F.

Weshalb gibt TRegExpr mehr als eine Zeile zurück?

Beispiel sei der reguläre Ausdruck &lt;font .\*&gt;, der das erste
&lt;font und danach den ganzen Rest des Eingabefiles zurückbringt
inklusive dem letzten &lt;/html&gt;...

A.

Aus Grunden der Abwarstkompatibilitat ist der [Modifikator
/s](#regexp_syntax.html#modifier_s) standardmassig eingeschaltet.

Schalte ihn aus und '.' findet alles ausser
[Zeilenseparatoren](#regexp_syntax.html#syntax_line_separators) – Wie Du
es wunschst.

BTW Ich schlage vor, Du nimmst '&lt;font (\[^\\n&gt;\]\*)&gt;', dann
hast Du in Match\[1\] die URL.

 

F.

Weshalb gibt TRegExpr mehr zurück als ich erwarte?

Beispiel sei der reguläre Ausdruck '&lt;p&gt;(.+)&lt;/p&gt;', angewandt
auf den Zielstring '&lt;p&gt;a&lt;/p&gt;&lt;p&gt;b&lt;/p&gt;', der
'a&lt;/p&gt;&lt;p&gt;b' zurückgibt, aber nicht nur das 'a' wie erwartet.

A.

Standardmässig arbeiten alle Operatoren im "gierig" Modus. Sie finden
also soviel wie möglich.

Falls Du den "genügsamen" Modus benutzen möchtest, so geht das nun ab
Version 0.940. Da funktionieren Operatoren wie '+?' etc. in diesem
minimalen Match-Modus. Du kannst auch alle Operatoren standardmässig in
diesem Modus arbeiten lassen mit dem Einsatz des Modifikators 'g'
(benutze dazu die entsprechenden TRegExpr-Eigenschaften oder
Inline-Konstrukte wie '?(-g)' im regulären Ausdruck).

 

F.

Wie parse ich Quelltexte wie HTML mit Hilfe von TRegExpr?

A.

Sorry folks, aber das ist fast unmöglich!

Natürlich kann man TRegExpr benutzen, um Teile aus einem HTML-File zu
extrahieren, wie ich ja auch zeige in den Beispielen. Aber wenn effektiv
ein ganzes File geparsed (d.h. in seine Elemente erlegt werden soll),
dann braucht man einen ausgewachsenen Parser, nicht nur einen
Regulären-Ausdruck-Matcher. Eine umfassende Lektüre bietet
beispielsweise das 'Perl Cookbook' von Tom Christiansen und Nathan
Torkington. In kurzen Worten, es gibt viele Konstruktionen, die ganz
leicht mit echten Parsern, aber nicht mit regulären Ausdrücken zerlegt
werden können. Zudem ist ein echter Parser viel schneller beim Zerlegen
des Files, weil ein Regulärer-Ausdruck-Matcher nicht nur den Eingabetext
liest, sondern ein optimiertes Suchmuster aufbaut, was viel Zeit in
Anspruch nehmen kann.

 

F.

Gibt es einen Weg, mehrere Treffer eines Suchmusters zu erhalten?

A.

Du kannst eine Schleife mittels der ExecNext-Methode schreiben und so
einen Treffer nach dem anderen herausholen.

Leichter kann es nicht gemacht werden, weil Delphi nicht wie Perl ein
Interpreter ist. Als Compiler ist Delphi dafür schneller.

Falls Du ein Beispiel suchst, schaue Dir doch die Implementation von
TRegExpr.Replace an oder das Beispiel in
[HyperLinksDecorator.pas](#hyperlinksdecorator.html)

 

F.

Ich überpfüfe die Eingabe des Benutzers. Weshalb gibt TRegExpr 'True'
zurück für falsche Eingabestrings?

A.

In vielen Fällen vergessen die Benutzer von TRegExpr, dass er gemacht
ist zur Suche im Eingabestring. Wenn Du also den Benutzer dazubringen
möchtest, dass er nur 4 Ziffern eingibt und Du dazu den regulären
Ausdruck '\\d{4,4}' benutzst, so wird dieser Ausdruck schon die 4
Ziffern in Eingaben wie '12345' oder 'irgendwas 1234 und nochwas'
erkennen. Eventuell hast Du nur vergessen, dass die 4 Ziffern alleine
vorkommen sollen. Du müsstest also den regulären Ausdruck so schreiben:
'^\\d{4,4}$'.

 

F.

Weshalb arbeiten genügsame Operatoren manchmal wie ihre gierigen
Gegenstücke?

Beispiel sei der reguläre Ausdruck 'a+?,b+?' angewandt auf den String
'aaa,bbb' findet 'aaa,b'. Sollte er nicht 'a,b' finden wegen des
genügsamen ersten Iterators?

A.

Dies ist eine Einschränkung der von TRegExpr (und Perl und vielen
UNIXen) verwandten Mathematik – reguläre Ausdrücke verwenden nur
"einfache" Suchoptimierungen, nicht unbedingt die beste Optimierung. In
seltenen Fällen ist das nicht ausreichend, aber in den meisten Fällen
ist es wohl eher ein Vorteil denn ein Nachteil: Und zwar aus Gründen der
Performance und Vorhersagbarkeit des Resultats. Die Hauptregel ist: Die
regulären Ausdrücke versuchen zuerst, von der aktuellen Stelle im
Zielstring alle Varianten zu finden und nur wenn es absolut keinen
Treffer gibt, wird vom Zielstring ein Zeichen vorwärtsgelesen und alles
wiederholt. Wenn Du also 'a,b+?' benutzst, dann findet es 'a,b'. Im
Falle von 'a+?,b+?' ist es zwar nicht wünschenswert (wegen der
genügsamen Iteratoren) aber möglich, mehrere 'a's zu finden, also findet
TRegExpr sie auch und gibt einen korrekten, aber nicht unbedingt
optimalen Treffer zurück. Genauso wie die regulären Ausdrücke Perl oder
UNIX geht TRegExpr nicht so weit, dass es nach einem Zeichen weitergeht
im Zielstring und erneut prüft, ob es einen "noch besseren Treffer"
gäbe. Zudem kann man hierbei überhaupt nicht von "schlechteren oder
besseren Treffern" sprechen. Bitte lies den Abschnitt  für
[Syntax](#regexp_syntax.html#mechanism) weitere Erläuterungen.

 

 

Autor
=====

 

    Andrey V. Sorokin

    Saint Petersburg, Russia

    <anso@mail.ru>

    [http://RegExpStudio.com](http://RegExpStudio.com/)

 

Bitte, wenn Du denkst, Du hast einen Fehler in TRegExpr gefunden oder
eine Frage zu TRegExpr hast, dann lade zuerst die aktuelle Version von
meiner Homepage herunter und lese die FAQ durch, bevor Du mir eine Mail
schreibst. Danke.

 

Diese Bibliothek ist abgeleitet worden von den Quelltexten von Henry
Spencer. Ich übersetzte die C-Quelltexte in Object-Pascal,
implementierte eine Object-Wrapper-Klasse und fügte einige neue Features
hinzu. Viele Features wurden vorgeschlagen oder teilweise implementiert
von den Benutzern von TRegExpr (siehe Danksagung unten).

 

 

---------------------------------------------------------------

    Danksagung

---------------------------------------------------------------

•  Guido Muehlwitz – er fand und behob einen ärgerlichen Fehler bei  der
Bearbeitung von grossen Strings

•  Stephan Klimek – er testete in CPPB und schlug einige Features vor
und implementierte sie auch gleich

•  Steve Mudford – er implementierte den Offset-Parameter

•  Martin Baur ([www.mindpower.com](http://www.mindpower.com)) –
Deutsche Hilfe,nützliche Vorschläge

•  Yury Finkel – er implementierte die UniCode-Unterstützung, fand und
behob einige Fehler

•  Ralf Junker – er implementierte einige Features, zahlreiche
Optimierungsvorschläge

•  Simeon Lilov – Bulgarische Hilfe

•  Filip Jirsák und Matthew Winter (wintermi@yahoo.com) – Hilfe bei der
Implementation des "genügsamen" Moduls

•  Kit Eason – Viele Beispiele un die Einführung im Hilfe-Abschnitt

•  Juergen Schroth - bug hunting and usefull suggestions

•  Martin Ledoux - French help

•Diego Calp (mail@diegocalp.com), Argentinien – Spanische Hilfe

 

Und viele andere – für die grosse Arbeit des Fehlerfindens!

 

[![helpman88x30](OPF/helpman88x30.gif)](http://www.helpandmanual.com)

 
