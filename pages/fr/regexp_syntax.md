---
layout: page
lang: fr
ref: syntax
title: Syntax von Regulären Ausdrücken
permalink: /fr/regexp_syntax.html
---

Syntaxe des Expressions Rйguliиres

Introduction

 

Les Expressions Rйguliиres sont grandement utilisйes pour spйcifier des
type de recherches pour le texte. Les mйtacaractиres spйciaux vous
permettent de spйcifier, par exemple, qu'une chaоne particuliиre que
vous chercher se trouve au dйbut ou а la fin d'une ligne, ou contient n
rйcurrence d'un certain caractиre.

 

Les Expressions Rйguliиres ressemblent vraiment а du charabia pour les
dйbutants, mais elles sont rйellement simples (bien, habituellement), et
sont un outil pratique et puissant.

 

Je recommande fortement de vous amuser avec le demo
[TestRExp.dpr](#tregexpr_testrexp.html) - il vous aidera а comprendre le
concept principal. De plus, il y a plusieurs exemple prйdйfinis avec des
commentaires inclus dans TestRExp.

 

Commenзons notre voyage d'apprentissage!

 

 

Simple comparaison

 

Un simple se compare а lui-mкme, sauf s'il est un mйtacaractиre avec une
spйcification spйciale dйcris plus bas.

 

Une sйrie de caractиre se compare а la mкme sйrie de caractиre dans la
chaоne de destination, aussi le gabarit "bluh" se compare а "bluh'' dans
la chaоne de destination. Relativement simple, n'est-ce pas ?

 

Vous pouvez obliger les mйtacaractиres ou les Sйquences d'йchappements а
кtre interprйtйs littйralement avec un 'йchappement' en les prйcйdents
avec une barre oblique inverse "\\", par exemple: le mйtacaractиre "^"
normalement se compare au dйbut de ligne, mais "\\^" se compare au
caractиre "^", "\\\\" se compare а "\\" et ainsi de suite.

 

Exemples:

[TABLE]

[TABLE]

 

 

Sйquences d'Йchappements

 

Les caractиres peuvent кtre spйcifiйs avec une Sйquence d'Йchappement
comme celles utilisй dans le langage C et Perl: "\\n'' se compare а une
nouvelle ligne, "\\t'' а une tabulation, etc... Plus gйnйralement,
\\xnn, oщ nn est un nombre hexadйcimal, se compare aux caractиres ASCII
avec une valeur dans nn. Si vous avez besoin des caractиres large (wide,
ou Unicode), vous pouvez utiliser '\\x{nnnn}', d'oщ 'nnnn' - un nombre
de plus ou moins 4 caractиres numйrique hexadйcimal.

 

  \\xnn     caractиre hexa avec le code nn.

  \\x{nnnn} caractиre hexa avec un code nnnn (un octet pour le texte
ordinaire et 2 octets pour l'Unicode).

  \\t       Tabulation horizontale (HT/TAB), mкme chose que \\x09.

  \\n       Nouvelle ligne (NL), mкme chose que \\x0a.

  \\r       Retour de chariot (CR), mкme chose que \\x0d.

  \\f       Avance page (FF), mкme chose que \\x0c.

  \\a       Alarme (bell) (BEL), mкme chose que \\x07.

  \\e       Йchappement (ESC), mкme chose que \\x1b.

 

Exemples:

[TABLE]

[TABLE]

 

 

Classes de Caractиres

 

Vous pouvez spйcifier une Classe de caractиres, en insйrant une liste de
caractиres dans \[\], lequel comparera tous les caractиres inclus dans
la liste.

 

Si le premier caractиre aprиs "\['' est "^'', la classe se compare comme
une nйgation en comparant tous les caractиres qui ne sont pas dans la
liste.

 

Exemples:

[TABLE]

[TABLE]

 

Dans une liste, le caractиre "-'' est utilisй pour spйcifier une
distance (range), aussi a-z reprйsente tous les caractиres entre ''a''
et "z'', inclusivement.

 

Si vous voulez que "-'' soit membre de la classe, veuillez le mettre au
dйbut ou а la fin de la liste, ou encore placer un йchappement ("\\")
devant. Si vous voulez un '\]' vous pouvez le placer au dйbut de la
liste ou le placer avec un йchappement "\\".

 

Exemples:

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

 

 

Mйtacaractиres

 

Les Mйtacaractиres sont des caractиres spйciaux qui sont l'essence mкme
des expressions rйguliиres. Il y a diffйrents types de mйtacaractиres,
dйcris plus bas.

 

Mйtacaractиres - Sйparateurs de ligne

 

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

 

Exemples:

[TABLE]

[TABLE]

[TABLE]

[TABLE]

 

Le mйtacaractиre "^" par dйfaut garantie de trouver le mot seulement
s'il est au dйbut de la chaоne ou du texte, le mйtacaractиre "$"
seulement а la fin. Les sйparateurs de ligne inclus dans le texte ne
sont pas considйrйs comme valable par "^'' ou "$'', donc la condition
est fausse et la recherche n'est pas valide.

 

Vous pouvez, toutefois, dйsirer traiter une chaоne comme une chaоne de
plusieurs ligne de texte, de cette faзon "^''  sera valable aprиs le
sйparateur de ligne, et "$'' sera valable avant un sйparateur de ligne.
Vous pouvez faire ceci avec le modifier /m.

 

Les mйtacaractиres \\A et \\Z sont comme "^'' et "$'', exceptй qu'ils
fonctionne seulement qu'une seule fois pour tout le texte quand le
modifier /m est en usage, pendant que "^'' et "$'' recherchera а chaque
sйparateur de ligne.

 

Le mйtacaractиre ".'' par dйfaut se compare а n'importe quel caractиre,
mais si vous mettez а off le modifier /s, les sйparateurs de ligne ne
seront plus inclus pour '.'.

 

TRegExpr travaille avec les sйparateurs de lignes comme recommandй au
site web www.unicode.org ( http://www.unicode.org/unicode/reports/tr18/
):

 

 "^" est au dйbut de la chaоne d'entrйe, et si le modifier /m est а On,
aussi suivant immйdiatement n'importe quelle occurrence de \\x0D\\x0A ou
\\x0A ou \\x0D (si vous utiliser la Version Unicode de TRegExpr, et
ensuite \\x2028 ou  \\x2029 ou \\x0B ou \\x0C ou \\x85). Noter qu'il n'y
a pas de ligne vide dans la sйquence \\x0D\\x0A.

 

"$" est а la fin de la chaоne d'entrйe, et si le modifier /m est а On,
aussi prйcйdant immйdiatement n'importe quelle occurrence de \\x0D\\x0A
ou \\x0A ou \\x0D (si vous utiliser la Version Unicode de TRegExpr, et
ensuite \\x2028 ou  \\x2029 ou \\x0B ou \\x0C ou \\x85). Noter qu'il n'y
a pas de ligne vide dans la sйquence \\x0D\\x0A.

 

"." se compare а n'importe quel caractиre, mais si le modifier /s est a
Off "." ne correspondra plus а \\x0D\\x0A et \\x0A et \\x0D (si vous
utiliser la Version Unicode de TRegExpr, et ensuite \\x2028 et  \\x2029
et \\x0B et \\x0C et \\x85).

 

Noter que "^.\*$" (un gabarit de ligne vide) ne correspond pas а une
chaоne vide, mais se compare а une chaоne vide contenant la sйquence
\\x0A\\x0D.

 

Le traitement Multiligne peut facilement кtre ajustй selon vos besoins
avec l'aide des propriйtйs LineSeparators et LinePairedSeparator de
TregExpr. Vous pouvez utiliser le style Unix "\\n" ou seulement le style
DOS/Windows "\\r\\n" ou un mйlange des deux (comme dйcris plus haut et
utilisй par dйfaut) ou dйfinir vos propres sйparateurs!

 

Mйtacactиres - classes prйdйfinies

 

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

 

Vous pouvez utiliser \\w, \\d et \\s а l'intйrieur de la classe de
caractиres.

 

Exemples:

[TABLE]

[TABLE]

 

TRegExpr utilise les propriйtйs SpaceChars et WordChars pour dйfinir les
classes de caractиres \\w, \\W, \\s, \\S, aussi vous pouvez aisйment les
redйfinir.

 

Mйtacaractиres - itйrateurs

 

N'importe quel item d'une expression rйguliиre peut-кtre suivi par un
autre type de mйtacaractиre - les itйrateurs. En utilisant ces
mйtacaractиres vous pouvez spйcifier le nombre de fois que le caractиre
prйcйdent sera reprйsentй, mйtacaractиres ou sous expression.

 

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

 

Donc, les nombres dans les accolades de la forme {n,m}, spйcifie le
nombre de fois minimum avec la lettre n et le nombre maximum avec la
lettre m. La forme {n} est йquivalente а {n,n} et correspond exactement
а n fois. La forme {n,} correspond а n ou plus. Il n'y a aucune limite
quand а la grosseur de n et m, mais les grands nombres prendront
beaucoup plus de mйmoire et vont ralentir l'exйcution de l'e.r.

 

Si les accolades apparaissent dans un autre contexte, ils sont traitйes
comme un caractиre rйgulier.

 

Exemples:

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

[TABLE]

 

Une petite explication а propos de l'utilisation des termes "non-vorace"
et "vorace". "Vorace" prend autant que possible, "non-vorace" prend
aussi peu que possible. Par exemple, 'b+' et 'b\*' appliquй а la chaоne
'abbbbc' retourne 'bbbb', 'b+?' retourne 'b', 'b\*?' retourne une chaоne
vide, 'b{2,3}?' retourne 'bb', 'b{2,3}' retourne 'bbb'.

 

Vous pouvez changer tous les itйrateurs en mode "non-vorace" en
utilisant le modifier /g.

 

 

Mйtacaractиres - Alternatifs

 

Vous pouvez spйcifier des alternatifs pour le modиle en utilisant "|''
pour les sйparer, donc fee|fie|foe correspond а "fee'', "fie'', ou
"foe'' dans la chaоne de destination (comme f(e|i|o)e le ferait). La
premiиre alternative inclus tout du dйlimiteur prйcйdent ("('', "\['',
ou le dйbut du modиle) jusqu'au premier "|'', et la derniиre alternative
contient tout du dernier "|'' jusqu'au dernier dйlimiteur. Pour cette
raison, il est de pratique courante d'inclure les alternatives dans des
parenthиses, pour minimiser le risque de confusion pour savoir quand
c'est le dйpart et quand c'est la fin.

 

Les alternatifs sont йvaluйs de gauche а droite, donc la premiиre
alternative trouvй pour la correspondance est celle qui est choisi. Ceci
signifie que les alternatives ne sont pas nйcessairement vorace. Par
exemple : quand vous faites correspondre foo|foot а "barefoot'',
seulement la partie "foo'' correspond, comme c'est la premiиre
alternative essayйe, elle correspond exactement а la chaоne de
destination. (Ceci ne semble pas important, mais ceci le deviens quand
vous capturer du texte correspondant en utilisant les parenthиses.)

 

Aussi rappeler vous que "|'' est interprйtй comme un littйral entre
"\[\]", donc si vous йcrivez \[fee|fie|foe\] Vous rйellement rechercher
pour \[feio|\].

 

Exemples:

  foo(bar|foo) Trouve la chaоne 'foobar' ou 'foofoo'.

 

 

Mйtacaractиres - sous expressions

 

Les parenthиses ( ... ) peuvent aussi кtre utilisйes pour construire des
sous expression rйguliиre. (aprиs  l'analyse, vous pouvez trouver les
positions des sous expressions, longueurs et valeurs actuelles dans
MatchPos, MatchLen et les propriйtйs de Match dans TRegExpr, et les
substituer dans les chaоnes du gabarit de TRegExpr.Substitute).

 

Les Sous expressions sont numйrotйs de gauche а droite selon les
ouvertures des parenthиses. La premiиre sous expression а le numйro '1'
(l'e.r. complиte a le numйro '0' - vous pouvez le substituer dans
TRegExpr.Substitute comme '$0' ou '$&').

 

Exemples:

[TABLE]

[TABLE]

  

 

Mйtacaractиres - Rйfйrences Prйcйdentes

 

Les Mйtacaractиres \\1 jusqu'а \\9 sont interprйtйs comme des rйfйrences
prйcйdentes. \\&lt;n&gt; compare la sous expression \#&lt;n&gt;
prйcйdente trouvй.

 

Exemples:

  (.)\\1+         Trouve 'aaaa' et 'cc'.

  (.+)\\1+       Aussi se compare а 'abab' et '123123'.

  (\['"\]?)(\\d+)\\1 Trouve  '"13" (entre guillemets), ou '4' (en
apostrophe) ou 77 (sans guillemet ou apostrophe), etc...

 

 

Modifier

 

Les Modifier existe dans le but de changer le comportement de TRegExpr.

 

Il y a plusieurs faзon d'ajuster ces modifier. N'importe quel de ces
modifier peuvent кtre incorporй dans l'expression rйguliиre elle-mкme en
utilisant la construction de (?...).

 

Aussi, vous pouvez changer la propriйtй adйquate de TRegExpr (ModifierX
par exemple pour changer /x, ou ModifierStr pour changer tous les
modificateurs ensemble). Les valeurs par dйfaut de la nouvelle instance
de l'objet TRegExpr sont dйfinis dans les variables globales, par
exemple la variable globale RegExprModifierX dйfinie la valeur
(ModifierX) d'une nouvelle instance de TRegExpr.

 

i

Faire des recherche sans йgard а la casse des caractиres (utilisant les
ajustements locaux dйfinis dans votre systиme), voir aussi CasInversé.

m

Traite les chaоnes comme des ligne multiples. Change la fonction de "^''
et "$'' pour chercher uniquement а partir du dйbut ou de la fin de la
chaоne, ce sera maintenant а partir du dйbut d'une ligne ou а la fin de
la ligne, voir aussi Séparateurs de Ligne.

s

Traite les chaоnes comme une simple ligne de texte. Change la fonction
de "." pour qu'il se compare а n'importe quel caractиre, mкme un
sйparateur de ligne (voir aussi Séparateur de Ligne), normalement il
ignorerait les sauts de ligne.

g

Modifier non standard. En le mettant а Off vous spйcifier de mettre tous
les opйrateurs en mode non-vorace (par dйfaut, ce modifier est а On).
Aussi, si le modifier /g est а Off, alors '+' fonctionne comme '+?',
'\*' comme '\*?' et ainsi de suite...

x

Йtend la lisibilitй du modиle en vous permettant des espaces et des
commentaires (voir l'explication plus bas).

r

Modificateur non standard. Si ajustй, les distances additionnelles de
а-я inclus les lettres russe 'ё', А-Я  inclus additionnellement 'Ё', et
а-Я inclus tous les symboles russe.

Dйsolй pour les utilisateurs de l'extйrieur, mais ces valeurs sont
ajustй par dйfaut. Si vous voulez les mettre а off par dйfaut - changer
la valeur de la variable globale RegExprModifierR.

 

 

Le modifier /x requiert des explications. Il dit а TRegExpr d'ignorer
les espaces qui ne sont pas avec un йchappement ou qui ne sont pas dans
une classe. Vous pouvez utiliser ceci pour casser l'expression rйguliиre
en morceaux plus petit et plus lisible. Le caractиre \# est aussi traitй
comme un mйtacaractиre qui introduit les commentaires, par exemple:

 

(

(abc) \# commentaire 1

  |   \# Vous ne pouvez pas utiliser les espaces pour formater l'e.r. -
TRegExpr l'ignorera.

(efg) \# commentaire 2

)

 

Ceci signifie que si vous voulez avoir des espace ou des caractиres \#
dans le modиle (а l'extйrieur de la classe, oщ ils ne sont pas affectйs
par /x), que vous aurez а mettre des йchappements ou les encoder avec
des valeurs octal ou hexadйcimale. Pris ensemble, cette option va plus
loin pour l'йcriture d'expressions rйguliиre pour les rendent plus
lisible.

 

 

Extensions Perl

 

(?imsxr-imsxr)

Vous pouvez l'utiliser dans les e.r. pour les modifier sur le champ. Si
la construction est encapsulй dans une sous expression, alors seulement
la sous expression sera affectй.

 

Exemples:

[TABLE]

[TABLE]

[TABLE]

[TABLE]

 

 

(?\#text)

Un commentaire, le texte est ignorй. Veuillez noter que TRegExpr ferme
le commentaire aussitфt qu'il voit une parenthиse ")", Aussi il n'y a
aucune faзon de placer une parenthиse dans le commentaire sans fermer
celui-ci.

 

 

Explication du mйcanisme interne

 

Vous voulez connaоtre les secrets interne de TRegExpr?

 

Bien, cette section est en construction, svp veuillez attendre quelque
temps..

N'oubliez pas de lire la [FAQ](#faq.html) (spйcifiquement la section
'non-vorace' ou cette Question).
