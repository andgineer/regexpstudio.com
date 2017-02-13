---
layout: page
lang: de
ref: index
title:
permalink: /de/index.html
---

TRegExpr ist eine Sammlung von einfach zu benutzenden Routinen, um mächtige, vorlagenbasierte
Zeichenkettenvergleiche durchzuführen, beispielsweise zur Prüfung von strukturierten
Dateneingaben in Datenbanken wie beispielsweise Telefonnummern mit Vorwahlen,
Sozialversicherungsnummern, Web-Applikationen, komplexere Suchen Ersetzen-Vorgänge,
Werkzeuge zur Durchforstung von Dateibeständen nach regelbasierenden Ausdrücken und so weiter.


Du kannst mit TRegExpr leicht und schnell die korrekte Syntax einer E-Mail-Adresse prüfen,
Telefonnummern in einem Text erkennen, URLs aus Qelltexten von Web-Seiten extrahieren,
unterschiedliche Schreibweisen eines Ausdruckes finden und durch eine einzige ersetzen.
Es bleibt Deiner Fantasie überlassen, wozu Du TRegExpr noch benutzen kannst.
Die Suchvorlagen (im folgenden Templates genannt), können zur Laufzeit geändert werden,
ohne dass eine Neuübersetzung des Programmes notwendig würde!

Diese Bibliothek, die ich hiermit in die Freeware lege, ist eine Delphi-Portierung der Routinen,
die Henry Spencer als V8-Routinen herausbrachte, um damit eine Untermenge
der [Regulären Ausdrücke](regexp_syntax.html) handhaben zu können.

Demgegenüber ist TRegExpr vollständig in einfachem Object-Pascal geschrieben und wird mit
dem ganzen Quelltext kostenlos zur Verfügung gestellt.

Der originale C-Quelltext wurde verbessert, in eine Klasse [TRegExpr](tregexpr_interface.html)
gekapselt und in einer einzigen Datei gespeichert: RegExpr.pas.

Du brauchst also keine DLL mehr für Reguläre Ausdrücke!

Schaue Dir mal die einfachen Beispiele an und studiere
die [Syntax](regexp_syntax.html) der Regulären Ausdrücke (Du kannst natürlich auch
das [Demo-Projekt](tregexpr_testrexp.html) für Studienzwecke heranziehen und damit
auch Deine eigenen Regulären Ausdrücken ausarbeiten oder debuggen).

Du kannst sogar Unicode (d.h. Delphis WideString) benutzen &#150; weiteres unter
[Wie wird Unicode benutzt?](tregexpr_interface.html#unicode).

Wirf auch einen Blick auf die [Was gibt's Neues](http://regexpstudio.com) web-Sektion
für die neuesten Änderungen.

Und natürlich sind Kommentare, Ideen, Vorschläge und sogar Bug Reports [willkommen](about.html).
