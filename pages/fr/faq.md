---
layout: page
lang: fr
ref: faq
title: FAQ
permalink: /fr/faq.html
---

FAQ
===

Q.

Comment utiliser TRegExpr avec Borland C++ Builder?

J'ai un problиme depuis qu'il n'y a plus aucun fichier d'en-tкte (.h or
.hpp) n'est pas disponible.

R.

[TABLE]

[TABLE]

[TABLE]

[TABLE]

 

Q.

Pourquoi TRegExpr retourne plus d'une ligne?

Par exemple l'e.r. &lt;font .\*&gt; retourne le premier &lt;font, et
ensuite le reste du fichier incluant le dernier &lt;/html&gt;...

R.

Pour la compatibilitй prйcйdente le modifier /s est а 'On' par dйfaut.

Le mettre а off et ensuite le '.' concordera а tout exceptй les
séparateurs de ligne - comme voulu.

Mais je suggиre aussi l'e.r. suivante '&lt;font (\[^\\n&gt;\]\*)&gt;',
dans Match\[1\] sera l'url.

 

Q.

Pourquoi TRegExpr retourne plus que prйvu?

Par exemple l'e.r. '&lt;p&gt;(.+)&lt;/p&gt;' appliquй а la chaоne
'&lt;p&gt;a&lt;/p&gt;&lt;p&gt;b&lt;/p&gt;' retourne
'a&lt;/p&gt;&lt;p&gt;b' mais pas 'a' comme prйvu.

R.

Par dйfaut tous les opйrateurs fonctionne en mode "vorace", aussi il
correspond а compare le plus possible. Si vous voulez le mode
"non-vorace" vous pouvez utiliser les opйrateurs '+?' et ainsi de suite
(nouveau dans la v. 0.940) ou changer tous les opйrateurs en mode
"non-vorace" avec l'aide du modifier "g" (utiliser les propriйtйs
convenablement dans TRegExpr ou avec une inscription dans l'e.r. comme
'?(-g)').

 

Q.

Comment analyser des sources comme du HTML avec l'aide deTRegExpr

R.

Dйsolй les gars, mais c'est pratiquement impossible!

Bien sur que vous pouvez utiliser TRegExpr pour extraire des
informations comme dйmontrй dans mes exemples, mais si vous voulez faire
une analyse prйcise, vous devez utiliser un vrai analyseur, pas l'e.r.!

Vous pouvez lire les explications de Tom Christiansen et Nathan
Torkington dans le document 'Perl Cookbook', par exemple. Pour faire une
histoire courte, il y a plusieurs expressions qui peuvent кtre analyser
facilement avec un vrai analyseur mais pas toutes par e.r., et les vrai
analyseurs sont PLUS rapide pour faire l'analyse, parce que l'e.r. ne
scanne pas l'entrйe avant, il fait plutфt une optimisation de recherche
qui peut prendre beaucoup de temps.

 

Q.

Est-ce qu'il y a une faзon d'avoir une correspondance multiple d'un
modиle sur TRegExpr?

R.

Vous pouvez faire une loupe et procйder comparaison par comparaison avec
la mйthode ExecNext.

Зa ne peut кtre plus fait plus facilement parce que delphi n'est pas un
interprйteur comme Perl (et les interprйteurs fonctionnent gйnйralement
trиs lentement!).

Si vous voulez quelques exemples, svp visionner la mйthode
TRegExpr.Replace. ou aux exemples dans
[HyperLinksDecorator.pas](#hyperlinksdecorator.html).

 

Q.

Je vйrifie l'entrйe d'utilisateur. Pourquoi TRegExpr retourne 'Vrai'
pour une mauvaise chaоne d'entrйe?

R.

Dans plusieurs cas de TRegExpr les utilisateurs oublient qu'une
expression rйguliиre est pour chercher dans les chaоnes d'entrйes.
Aussi, si vous voulez faire que l'utilisateur entre seulement 4
caractиres numйrique et que vous utiliser l'expression '\\d{4,4}', vous
pouvez ignorer les mauvaises entrйes comme '12345' ou 'n'importe quel
caractиre 1234 et n'importe quoi'. Vous devez ajouter une vйrification
pour le dйbut et la fin de la ligne et vous assurer qu'il n'y a rien
d'autre comme dans l'expression suivante: '^\\d{4,4}$'.

 

Q.

Pourquoi que le mode non-vorace quelquefois fonctionne comme le mode
vorace?

Par exemple, l'e.r. 'a+?,b+?' appliquй а 'aaa,bbb' retourne 'aaa,b',
mais normalement ne devrait-il pas retourner 'a,b' а cause de la nature
non-vorace du premier itйrateur ?

R.

C'est une limite d'utilisation par la mathйmatique de TRegExpr (et
plusieurs autre comme Perl et Unix). E.r. effectue seulement une
'simple' optimisation de recherche, et ne tente pas d'obtenir la
meilleure optimisation. Dans plusieurs cas ce n'est pas bon, mais en
gйnйral cette limite est plutфt avantageuse, а cause des performances et
des prйvisions de raison.

La rиgle gйnйrale est que premiиrement e.r. essaie de trouver une
correspondance а partir de sa position actuelle et seulement si c'est
complиtement impossible de trouver une correspondance alors il avance
d'un caractиre et rйessaie de nouveau а partir de cet emplacement. Aussi
si vous utiliser 'a,b+?' il correspondra avec 'a,b', mais dans le cas de
'a+?,b+?' ce 'n'est pas recommandй' (а cause du mode non-vorace) mais
possible de correspondre а plus d'un 'a', aussi TRegExpr le fait mais le
rйsultat obtenu ne sera pas une correspondance optimum. TRegExpr comme
Perl ou les e.r. de Unix ne tente pas de bouger en avant et vйrifier
qu'est-ce qu'il serait la meilleure correspondance. De plus, il ne peut
comparer en terme 'plus ou moins bon'.

SVP, lire le section 'Syntaxe' du fichier d'aide pour plus
d'explication.