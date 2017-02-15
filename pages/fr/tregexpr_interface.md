---
layout: page
lang: fr
ref: tregexpr_interface
title: TRegExpr Interface
permalink: /fr/tregexpr_interface.html
---

Interface de TRegExpr

Mйthodes et propriйtйs publique de TRegExpr:

 

 

property Expression : string

Fonction

Contient l'expression Rйguliиre. Pour L'optimisation, TRegExpr va
automatiquement le compiler en 'P-code' (vous pouvez le voir avec l'aide
de la mйthode Dump) et stockй dans sa structure interne. La vrai
\[re\]compilation survient quand c'est rйellement le cas - en appellant
Exec\[Next\], Substitute, Dump, etc et seulement si l'expression ou un
autre P-code a affectй les propriйtйs qui ont йtй changйes aprиs la
derniиre \[re\]compilation.

Erreur

Si une erreur survient durant la \[re\]compilation, une mйthode d'erreur
est appelйe (par dйfaut une erreur d'exception est levйe - voir plus
bas).

 

 

property ModifierStr : string

Fonction

Ajuste/rйcupиre les valeurs par dйfaut des modifications d'e.r.. Le
format de chaоne est similaire а (?ismx-ismx). Par exemple si
ModifierStr := 'i-x' va mettre а On le modifier /i, а Off /x et laisser
les autres inchangйs.

Valeurs Possibles

-i-s-m-x ou ismx ou,...

Valeurs par Dйfaut

-i-s-m-x

Erreur

Si vous essayez des modifications non supportйes, une erreur sera
appelйe (par dйfaut les erreurs lиve une exception dans ERegExpr).

 

 

property ModifierI : boolean

Fonction

Modifier /i - ("casse des caractиres ignorйe"), initialisй avec la
valeur RegExprModifierI.

Valeurs Possibles

[TABLE]

[TABLE]

Valeur par Dйfaut

False

Erreur

Aucune

 

 

property ModifierR : boolean

Fonction

Modifier /r - ("extension de syntaxe Russe"), initialisй avec la valeur
RegExprModifierR.

Valeurs Possibles

[TABLE]

[TABLE]

Valeur par Dйfaut

True

Erreur

Aucune

 

 

property ModifierS : boolean

Fonction

Modifier /s - '.' veut dire n'importe quel caractиre (normalement il ne
comprend pas les LinesSeparators et LinePairedSeparator), initialisй
avec la valeur RegExprModifierS.

Valeurs Possible

[TABLE]

[TABLE]

Valeur par Dйfaut

True

Erreur

Aucune

 

 

property ModifierG : boolean;

Fonction

Modifier /g. En le mettant а Off tous les opйrateurs fonctionne en mode
non-vorace, donc si ModifierG = Faux, alors '\*' est comme '\*?', tous
les '+' comme '+?' et ainsi de suite, initialisй avec la valeur
RegExprModifierG.

Valeurs Possible

[TABLE]

[TABLE]

Valeur par Dйfaut

True

Erreur

Aucune

 

property ModifierM : boolean;

Fonction

Modifier /m Traite les chaоnes comme des lignes multiples . Ceci fait,
changer \`^' et \`$' de correspondre au dйbut ou а la fin de la chaоne,
а partir d'une nouvelle ligne ou а la fin d'une ligne, initialisй avec
la valeur RegExprModifierM.

Valeurs Possible

[TABLE]

[TABLE]

Valeur par Dйfaut

False

Erreur

Aucune

 

 

property ModifierX : boolean;

Fonction

Modifier /x - ("syntaxe йtendue"), initialisй avec la
valeurRegExprModifierX.

Valeurs Possible

[TABLE]

[TABLE]

Valeur par Dйfaut

False

Erreur

Aucune

 

 

function Exec (const AInputString : string) : boolean;

Fonction

Compare une recherche а la chaоne AInputString.

Note

La fonction Exec stocke AInputString dans la propriйtй InputString.

 

 

function ExecNext : boolean;

Fonction

Trouve l'occurrence suivante de Exec(AString);

Note

fonctionne comme

Exec (AString);

if MatchLen \[0\] = 0 then ExecPos(MatchPos \[0\] + 1)

else ExecPos (MatchPos \[0\] + MatchLen \[0\]);

mais est plus simple !

 

 

function ExecPos (AOffset: integer = 1) : boolean;

Fonction

Trouve une occurrence de recherche pour de dйpart de InputString а
partir de la position Aoffset (AOffset=1 - premier caractиre de
InputString).

 

 

property InputString : string;

Fonction

Retourne le chaоne d'entrйe courante (а partir du dernier appel de Exec
ou de la derniиre dйsignation de cette propriйtй).

Note

Une modification а cette propriйtй efface les propriйtйs Match\* !

 

 

function Substitute (const ATemplate : string) : string;

Fonction

Retourne ATemplate avec '$&' ou '$0' remplacй par l'occurrence complиte
de l'e.r. et '$n' remplacй par l'occurrence de la sous expression \#n.

Valeur de Retour

Contient la chaоne avec les modification apportйes.

Note

Depuis la  v.0.929 '$' utiliser plutфt '\\' (pour les futures extensions
et pour plus de compatibilitй avec Perl) pour accepter plus d'un
caractиre numйrique.

 

Si vous voulez placer le gabarit dans le modиle '$' ou '\\', utiliser le
prйfixe '\\'.

Exemple: '1\\$ is $2\\\\rub\\\\' -&gt; '1$ est
&lt;Match\[2\]&gt;\\rub\\'

 

Si vous voulez placer un caractиre numйrique aprиs '$n' vous devez
dйlimiter n avec des accolades '{}'.

Exemple: 'a$12bc' -&gt; 'a&lt;Match\[12\]&gt;bc', 'a${1}2bc' -&gt;
'a&lt;Match\[1\]&gt;2bc'.

 

 

procedure Split (AInputStr : string; APieces : TStrings);

Fonction

Divise AInputStr en piиces dans APieces par les occurrences de l'e.r.

Note

Appelй au niveau interne Exec\[Next\].

 

 

function Replace (AInputStr : string; const AReplaceStr : string) :
string;

Fonction

Retourne AInputStr avec les occurrences de l'e.r remplacй par
AReplaceStr

Note

Appelй au niveau interne Exec\[Next\].

 

 

property SubExprMatchCount : integer; // LectureSeulement

Fonction

Le nombre de sous expressions qui a йtй trouvй dans la derniиre
exйcution de Exec\*.

Valeur de Retour

S'il n'y a aucune sous expression mais que l'expression complиte а йtй
trouvй (Exec\* а retournй vrai), alors SubExprMatchCount=0, si aucune
sous expression et aucune e.r. complиte a йtй trouvй (Exec\* retourne
Faux) alors SubExprMatchCount=-1.

 

Noter que quelques sous expressions peuvent ne pas кtre trouvйes et pour
de telles sous expressions, MathPos=MatchLen=-1 and Match=''.

 

Par exemple: L'Expression := '(1)?2(3)?';

Exec ('123'): SubExprMatchCount=2, Match\[0\]='123', \[1\]='1',
\[2\]='3'

Exec ('12'): SubExprMatchCount=1, Match\[0\]='12', \[1\]='1'

Exec ('23'): SubExprMatchCount=2, Match\[0\]='23', \[1\]='', \[2\]='3'

Exec ('2'): SubExprMatchCount=0, Match\[0\]='2'

Exec ('7') - return False: SubExprMatchCount=-1

 

 

property MatchPos \[Idx : integer\] : integer; // LectureSeulement

Fonction

La position d'entrйe de la sous expression \#Idx en test а la derniиre
exйcution de Exec\*.

Paramиtre

La premiиre sous expression a une valeur de Idx=1, derniиre -
MatchCount, l'e.r. a une valeur de Idx=0.

Valeur de Retour

Retourne -1 si dans l'e.r. il n'y a pas de sous expression trouvйe dans
la chaоne.

 

 

property MatchLen \[Idx : integer\] : integer; // Lecture Seulement

Fonction

La longueur d'entrйe de la sous expression \#Idx e.r. en test а la
derniиre exйcution de Exec\*. La premiиre sous expression a la valeur
Idx=1, derniиre - MatchCount, l'e.r. entiиre a une valeur de Idx=0.

Valeur de Retour

Retourne -1 si dans l'e.r. il n'y a pas de sous expression ou que cette
expression n'as pas йtй trouvй dans la chaоne.

 

 

property Match \[Idx : integer\] : string; // Lecture Seulement

Fonction

== copy (InputString, MatchPos \[Idx\], MatchLen \[Idx\])

Valeur de Retour

Retourne '' si dans l'e.r. il n'y a pas de sous expression ou que la
sous expression n'as pas йtй trouvй dans la chaоne.

 

 

function LastError : integer;

Fonction

Retourne l'ID de la derniиre erreur, 0 s'il y a aucune erreur
(inutilisable si l'erreur a gйnйrйe une erreur d'exception) et efface la
valeur interne а 0 (pas d'erreur).

 

 

function ErrorMsg (AErrorID : integer) : string; virtual;

Fonction

Retourne un message d'erreur pour l'erreur avec ID = AErrorID.

 

 

property CompilerErrorPos : integer; // Lecture Seulement

Fonction

Retourne la position dans l'e.r. ou le compilateur a stoppй. Trиs
pratique pour diagnostiquer les erreurs.

 

 

property SpaceChars : RegExprString

Fonction

Contient les caractиres  traitйs comme \\s (initialement remplit avec
les valeurs de la variable globale RegExprSpaceChars).

 

 

property WordChars : RegExprString;

Fonction

Contient les caractиres traitйs comme  \\w (initialement remplit avec
les valeurs de la variable globale RegExprWordChars).

 

 

property LineSeparators : RegExprString

Fonction

Les sйparateurs de ligne (comme Unix \\n), initialement remplit avec les
valeurs de la variable globale RegExprLineSeparators). Voir aussi a
propos des séparateurs de ligne.

 

 

property LinePairedSeparator : RegExprString

Fonction

Paire de sйparateur de ligne (pour le Dos et Windows \\r\\n). Doit
contenir exactement deux caractиres ou pas de caractиres du tout,
initialement remplit avec les valeurs de la variable globale
RegExprLinePairedSeparato). Voir aussi a propos des séparateurs de
ligne.

Note

Par exemple, si vous avez besoin du style Unix, assigner а
LineSeparators := \#$a (caractиre de nouvelle ligne) et
LinePairedSeparator := '' (chaоne vide), si par contre vous voulez
accepter les sйparateurs "\\x0D\\x0A" mais pas "\\x0D" ou "\\x0A" seul,
alors assigner LineSeparators := '' (chaоne vide) et LinePairedSeparator
:= \#$d\#$a.

 

Par dйfaut le mode 'mixe' est utilisй (dйfinit par dйfaut dans les
constantes globales RegExprLine\[Paired\]Separator\[s\]): LineSeparators
:= \#$d\#$a; LinePairedSeparator := \#$d\#$a. Le comportement de ce mode
est dйcris dans la section syntaxe.

 

 

class function InvertCaseFunction  (const Ch : REChar) : REChar;

Fonction

Convertit Ch en majuscule si c'est minuscule et vice-versa (en utilisant
les ajustement du systиme local).

 

 

property InvertCase : TRegExprInvertCaseFunction;

Fonction

Ajuster cette propriйtй si vous voulez йviter la fonctionnalitй de
l'ignorance des minuscules/majuscules.

Note

Crйe une interdiction а la fonction RegExprInvertCaseFunction
(InvertCaseFunction par dйfaut).

 

 

procedure Compile;

Fonction

\[Re\]compile l'e.r. Trиs pratique pour les applications qui utilise les
йditeurs graphique pour vйrifier la validitй des propriйtйs.

 

 

function Dump : string;

Fonction

Crйe pour le visionnement une e.r. compilйe en une forme plus
comprйhensive.

 

 

 

Constantes Globales

 

 

Valeurs par dйfaut des Modifiers:

 RegExprModifierI : boolean = False;                //
TRegExpr.ModifierI

 RegExprModifierR : boolean = True;                // TRegExpr.ModifierR

 RegExprModifierS : boolean = True;                // TRegExpr.ModifierS

 RegExprModifierG : boolean = True;                // TRegExpr.ModifierG

 RegExprModifierM : boolean = False;                //
TRegExpr.ModifierM

 RegExprModifierX : boolean = False;                //
TRegExpr.ModifierX

 

 

 RegExprSpaceChars : RegExprString = ' '\#$9\#$A\#$D\#$C;

  // Valeur par dйfaut pour la propriйtй SpaceChars

 

 

 RegExprWordChars : RegExprString =

    '0123456789'

  + 'abcdefghijklmnopqrstuvwxyz'

  + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ\_';

  // Valeur par dйfaut pour la propriйtй WordChars

 

 

 RegExprLineSeparators : RegExprString =

   \#$d\#$a{$IFDEF UniCode}\#$b\#$c\#$2028\#$2029\#$85{$ENDIF};

  // Valeur par dйfaut pour la propriйtй LineSeparators

 RegExprLinePairedSeparator : RegExprString =

   \#$d\#$a;

  // Valeur par dйfaut pour la propriйtй LinePairedSeparator

 

 

 RegExprInvertCaseFunction : TRegExprInvertCaseFunction =
TRegExpr.InvertCaseFunction;

  // Valeur par dйfaut pour la propriйtй InvertCase

 

 

Fonctions globales pratiques

 

 

function ExecRegExpr (const ARegExpr, AInputStr : string) : boolean;

Fonction

Retourne vrai si la chaоne AInputString concorde а l'expression
ARegExpr.

Note

!Va lever une exception s'il y a une erreur de syntaxe dans ARegExpr.

 

 

procedure SplitRegExpr (const ARegExpr, AInputStr : string; APieces :
TStrings);

Fonction

Sйpare AInputStr en piиces dans APieces par les occurrences de l'e.r.
ARegExpr.

 

 

function ReplaceRegExpr (const ARegExpr, AInputStr, AReplaceStr :
string) : string;

Fonction

Retourne AInputStr avec l'occurrence de l'e.r. remplacй par AReplaceStr.

 

 

function QuoteRegExprMetaChars (const AStr : string) : string;

Fonction

Remplace tous les mйtacaractиres avec une reprйsentation simple, par
exemple 'abc$cd.(' est converti en 'abc\\$cd\\.\\('.

Note

Cette fonction est trиs pratique pour l'autogйnйration d'e.r. а partir
d'entrйe utilisateur.

 

 

function RegExprSubExpressions (const ARegExpr : string; ASubExprs :
TStrings; AExtendedSyntax : boolean = False) : integer;

Fonction

Fabrique une liste de sous expression trouvй dans l'e.r. ARegExpr.

Note

Dans ASubExps chaque item reprйsente une sous expression, а partir de la
premiиre jusqu'а la derniиre, dans le format:

[TABLE]

[TABLE]

[TABLE]

[TABLE]

 

Utile pour les йditeurs avec interface graphique (Vous pouvez trouver un
exemple d'utilisation dans le projet
[TestRExp.dpr](#tregexpr_testrexp.html)).

 

[TABLE]

 

 

[TABLE]

[TABLE]

[TABLE]

[TABLE]

 

Si le rйsultat &lt;&gt; 0, alors ASubExprs peut contenir des items vide
ou de items illйgaux.

 

 

 

Type d'exception

 

 

Routine par Dйfaut des erreurs d'exception pour TRegExpr:

 

ERegExpr = class (Exception)

   public

    ErrorCode : integer; // code d'erreur. Les erreurs de compilation du
code sont avant 1000.

    CompilerErrorPos : integer; // Position dans l'e.r. oщ l'erreur est
survenue.

  end;

 

 
<a name="unicode"></a>
### Comment utiliser les Unicode

 

TRegExpr supporte maintenant les UniCode, mais il travaille trиs
lentement.

Qui veut se risquer а l'optimiser ?

L'utiliser seulement si vous avez vraiment besoin du support des Unicode
!

Pour utiliser les WideString, enlever le '.' dans {.$DEFINE UniCode}
dans le fichier regexpr.pas.

 