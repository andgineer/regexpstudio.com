---
layout: page
lang: fr
ref: tregexpr_testrexp
title: Das Demo-Projekt (TestRExp)
permalink: /de/tregexpr_testrexp.html
---

Projet Demo (TestRExp)

 

Simple programme pour explorer et tester les e.r., distribuй en fichiers
sources (projet TestRExp.dpr) et avec l'exйcutable TestRExp.exe.

 

Noter qu'il utilise les propriйtйs de plusieurs VCL qui existent
seulement dans Delphi 4 ou plus rйcent. En compilant dans Delphi 3 ou
Delphi 2 vous recevrez quelques message d'erreurs a propos de propriйtйs
inconnues. Vous pouvez les ignorer, ces propriйtйs sont seulement
nйcessaire lorsque vous redimmensionner la fenкtre du programme.

 

Avec l'aide de ce programme, vous pourrez aisйment dйterminer le nombre
de sous expression que vous кtes en train de modifier, aller а n'importe
quelle sous expression dйfinie (dans le code compilй de l'e.r. autant
que dans le rйsultat des chaоnes d'entrйe), jouer avec les substituts,
remplacer, sйparer et mкme plus.

 

Et de plus, le projet inclus une bonne quantitй d'exemple - utiliser les
pour apprendre la syntaxe des e.r. ou pour apprendre rapidement les
avantages des fonctionnalitйs de TRegExpr.

Exemple: Dйcorateur HyperLinks

Décorer les URLs   Décorer les E-Mails

 

Fonctions pour dйcorer les liens hyperlinks en convertissant le texte
standard en format HTML.

 

Par exemple, remplace 'http://anso.da.ru'  avec  '&lt;a
href="http://anso.da.ru"&gt;anso.da.ru&lt;/a&gt;' ou 'anso@mail.ru'
 avec  '&lt;a href="mailto:anso@mail.ru"&gt;anso@mail.ru&lt;/a&gt;'.

 

fonction Dйcorer les URLs

 

Trouve et remplace les liens comme 'http://...' ou 'ftp://..' aussi bien
que les liens sans protocol, mais qui commence avec 'www.' Si vous
voulez dйcorer les e-mails, vous pouvez utiliser la fonction
DecorateEMails.

 

function DecorateURLs (const AText : string; AFlags :
TDecorateURLsFlagSet = \[durlAddr, durlPath\]) : string;

 

Description

 

retourne le texte d'entrйe AText avec les liens hyperliens dйcorйs.

 

AFlags dйcris quelle partie de l'hyperlien lien doit кtre inclus dans la
partie VISIBLE du lien:

Par exemple, si \[durlAddr\]  alors  hyperlien
'http://anso.da.ru/index.htm'  sera dйcorй comme  '&lt;a
href="http://anso.da.ru/index.htm"&gt;anso.da.ru&lt;/a&gt;'.

 

type

 TDecorateURLsFlags = (durlProto, durlAddr, durlPort, durlPath,
durlBMark, durlParam);

 TDecorateURLsFlagSet = jeux de TDecorateURLsFlags;

 

Description

 

Voici les valeurs possibles pour TDecorateURLsFlagSet:

 

Value                                Meaning

 

 

 

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

 

 

 

 

Fonction Dйcorer les EMails

 

Remplace les e-mails avec '&lt;a href="mailto:ADDR"&gt;ADDR&lt;/a&gt;'.
Par exemple, remplace 'anso@mail.ru' avec '&lt;a
href="mailto:anso@mail.ru"&gt;anso@mail.ru&lt;/a&gt;'.

 

function DecorateEMails (const AText : string) : string;

 

Description

 

Retourne le texte d'entrйe avec les dйcoration e-mails dans Atext.

 