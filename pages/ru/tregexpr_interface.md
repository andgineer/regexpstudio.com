---
layout: redirected
redirect_to: https://regex.sorokin.engineer/ru/latest/tregexpr.html
sitemap: false
lang: ru
ref: interface
title: Интерфейс TRegExr
permalink: /ru/tregexpr_interface.html
---

### Методы и свойства TRegExpr:

    class function VersionMajor : integer;
    class function VersionMinor : integer;

Возвращают соответственно старшую и младшую часть версии, например, для
v. 0.950 VersionMajor = 0 и VersionMinor = 950

    property Expression : string;

Собственно регулярное выражение.

Для ускорения работы TRegExpr автоматически выполняет компиляцию
выражения во внутреннее представления (его можно посмотреть через Dump).

Однако, делается это только тогда, когда это реально необходимо, т.е.
при обращении к методам Exec\[Next\], Substitute, Dump и т.п. и только в
том случае, если после последней \[пере\]компиляции было изменено
свойство Expression или какие-либо другие влияющие на откомпилированное
выражение свойства.

При ошибках компиляции вызывается метод Error (по умолчанию он
генерирует исключение ERegExpr - см. ниже)

    property ModifierStr : string;

Проверка и установка
[модификаторов](regexp_syntax.html#about_modifiers) с помощью строки в
том же формате, что и в конструкции
[(?ismx-ismx)](regexp_syntax.html#inline_modifiers). Т.е., например
ModifierStr := 'i-x' включит регистро-независимый режим и выключит режим
расширенного синтаксиса, прочие модификаторы останутся без изменений.

Если указать несуществующий модификатор, вызывается Error

    property ModifierI : boolean;

Модификатор /i <a name="modifier_i"></a> -
("регистро-независимый режим"), инициализируется из
[RegExprModifierI](#modifier_defs)

    property ModifierR : boolean;

Модификатор /r <a name="#modifier_r"></a> ("русские диапазоны"),
инициализируется из
[RegExprModifierR](#modifier_defs)

property ModifierS : boolean

[Модификатор /s](regexp_syntax.html#modifier_s) - если установлен, то
'.' совпадает с любым символом, (если сброшен, то '.' не совпадает с
[LineSeparators](tregexpr_interface.html#lineseparators) и
[LinePairedSeparator](tregexpr_interface.html#linepairedseparator), ,
инициализируется из
[RegExprModifierS](#modifier_defs)

 

property ModifierG : boolean;

[Модификатор /g](regexp_syntax.html#modifier_g), отключение приводит к
тому, что все операторы работают в "не жадном" (non-greedy) режиме, т.е.
когда ModifierG = False, то все '\*' работают как '\*?', все '+' как
'+?' и т.д.., инициализируется из
[RegExprModifierG](#modifier_defs)

 

property ModifierM : boolean;

[Модификатор /m](regexp_syntax.html#modifier_m) -воспринимать входной
текст как многострочный. Если выключен, то метасимволы \`^' и \`$'
"срабатывают" только в начале и конце входного текста.

Если включен, то эти символы срабатывают также и в начале и в конце
каждой строки входного текста., инициализируется из
[RegExprModifierM](#modifier_defs)

 

property ModifierX : boolean;

[Модификатор /x](regexp_syntax.html#modifier_x) - ("расширенный
синтаксис"), инициализируется из
[RegExprModifierX](#modifier_defs)

 

function Exec (const AInputString : string) : boolean;

Выполнить выражение применительно к входной строке AInputString

!!! также, запоминает AInputString в ствойстве InputString

For Delphi 5 and higher available overloaded versions:

function Exec : boolean;

without parameter (uses already assigned to InputString property value)

function Exec (AOffset: integer) : boolean;

is same as ExecPos

 

function ExecNext : boolean;

поиск следующего совпадения. Фактически:

   Exec (AString);

означает то же что и

  if MatchLen \[0\] = 0 then ExecPos (MatchPos \[0\] + 1)

    else ExecPos (MatchPos \[0\] + MatchLen \[0\]);

но воспринимается гораздо нагляднее!

Выдает исключение если этому вызову не предшествовал успешный вызов
метода

Exec\* (Exec, ExecPos, ExecNext). Т.е. необходимо использовать что-то
вида

if Exec (InputString) then repeat { обработка} until not ExecNext;

 

function ExecPos (AOffset: integer = 1) : boolean;

выполняет выражение для строки в InputString начиная с позиции AOffset

(AOffset=1 - первый символ InputString)

 

property InputString : string;

текущая входная строка (присвоенная явно или в последнем Exec).

Присвоение этому свойству значений делает неопределенными свойства
Match\* !

 

function Substitute (const ATemplate : string) : string;

Возвращает ATemplate в котором все '$&' и '$0' заменены на найденное
регулярное выражение, а '$n' заменены на подвыражения \#n.

Начиная с версии v.0.929 используется '$' вместо '\\' (для расширений
типа \\n\\r и т.п. а также для большей схожести с Perl) и допускаются n
> 9.

Если Вам необходим просто символ '$' или '\\', предваряйте их '\\'.

Например: '1\\$ is $2\\\\rub\\\\' -> '1$ is
<Match\[2\]>\\rub\\'

Если Вам необходимо сразу после '$n' поместить цифру, заключайте n в
фигурные скобки '{}'.

Например: 'a$12bc' -> 'a<Match\[12\]>bc', 'a${1}2bc' ->
'a<Match\[1\]>2bc'.

 

procedure Split (AInputStr : string; APieces : TStrings);

Режет входную строку AInputStr на помещаемые в APieces куски разделяемые
вхождениями выражения. Внимание! Этот метод вызывает методы Exec\[Next\]

 

function Replace (AInputStr : RegExprString;

 const AReplaceStr : RegExprString;

 AUseSubstitution : boolean = False) : RegExprString;

function Replace (AInputStr : RegExprString;

 AReplaceFunc : TRegExprReplaceFunction) : RegExprString;

function ReplaceEx (AInputStr : RegExprString;

 AReplaceFunc : TRegExprReplaceFunction)  : RegExprString;

Заменяет в AInputStr все вхождения выражения на AReplaceStr

Если AUseSubstitution = true, то AReplaceStr будет восприниматься как
шаблон для метода Substitution.

Например:

 Expression := '({-i}block|var)\\s\*\\(\\s\*(\[^ \]\*)\\s\*\\)\\s\*';

 Replace ('BLOCK( test1)', 'def "$1" value "$2"', True);

  вернет:  def 'BLOCK' value 'test1'

 Replace ('BLOCK( test1)', 'def "$1" value "$2"', False)

  вернет:  def "$1" value "$2"

Внимание! Этот метод вызывает методы Exec\[Next\]

Вариант с параметром-функцией и ReplaceEx отличаются тем, что передается
не строка, а ссылка на функцию, которая в динамике формирует строку для
замены, что позволяет реализовать сложные варианты замен.


property SubExprMatchCount : integer; // ReadOnly

Число подвыражений, найденных в последнем Exec\*. если найдено только
само выражение в целом, то SubExprMatchCount=0, если и само выражение не
найдено (Exec\* вернул false) то SubExprMatchCount=-1. Обратите
внимание, что часть подвыражений может быть не найдено и для них
MathPos=MatchLen=-1 и Match=''.

Например, для Expression := '(1)?2(3)?';

Exec ('123'): SubExprMatchCount=2, Match\[0\]='123', \[1\]='1',
\[2\]='3'

Exec ('12'): SubExprMatchCount=1, Match\[0\]='12', \[1\]='1'

Exec ('23'): SubExprMatchCount=2, Match\[0\]='23', \[1\]='', \[2\]='3'

Exec ('2'): SubExprMatchCount=0, Match\[0\]='2'

Exec ('7') - возвращает False: SubExprMatchCount=-1

 

property MatchPos \[Idx : integer\] : integer; // ReadOnly

Позиция начала подвыражения \#Idx во входной строке

Первое подвыражение имеет Idx=1, последнее - MatchCount, выражение в
целом  Idx=0.

Возвращает -1 если нет такого подвыражения или если оно не найдено во
входной строке.

 

property MatchLen \[Idx : integer\] : integer; // ReadOnly

Длина подвыражения \#Idx во входной строке

Первое подвыражение имеет Idx=1, последнее - MatchCount, выражение в
целом  Idx=0.

Возвращает -1 если нет такого подвыражения или если оно не найдено во
входной строке.

 

property Match \[Idx : integer\] : string; // ReadOnly

== copy (InputString, MatchPos \[Idx\], MatchLen \[Idx\])

Возвращает '' если нет такого подвыражения или если оно не найдено во
входной строке.

 

function LastError : integer;

Код последней ошибки, 0 если нет ошибки (бессмысленно использовать эту
функцию, если Вы не изменяете реализацию Error, поскольку текущая
реализация генерирует исключительную ситуацию).

Вызов этой функции очищает внутреннюю переменную и повторный вызов
всегда вернет 0.

 

function ErrorMsg (AErrorID : integer) : string; virtual;

Возвращает текст сообщения об ошибке с кодом AErrorID.

 

property CompilerErrorPos : integer; // ReadOnly

Возвращает позицию, в которой случилась последняя ошибка компиляции
(упрощает отладку выражений)

 

property SpaceChars : RegExprString

Содержит символы, трактуемые как \\s (инициализируется из глобальной
константы RegExprSpaceChars)

 

property WordChars : RegExprString;

Содержит символы, трактуемые как \\w (инициализируется из глобальной
константы RegExprWordChars)

<a name="line_separators"></a> 

    property LineSeparators : RegExprString

Разделители строк (например, \\n для Unix) (инициализируется из
глобальной константы RegExprLineSeparators)

[см.подробнее о разделителях
строк](regexp_syntax.html#syntax_line_separators)

 

property LinePairedSeparator : RegExprString

Сдвоенный разделитель строк (как, \\r\\n для DOS и Windows)
(инициализируется из глобальной константы RegExprLinePairedSeparator)

[см.подробнее о разделителях
строк](regexp_syntax.html#syntax_line_separators)

 

Например, если Вам необходимо отслеживать только Unix-разделители строк,
присвойте LineSeparators := \#$a (символ новой строки) и
LinePairedSeparator := '' (пустую строку), если необходимо воспринимать
как разделители строк только \\x0D\\x0A но не отдельные \\x0D или \\x0A,
присвойте LineSeparators := '' (пустую строку) и LinePairedSeparator :=
\#$d\#$a.

 

По умолчанию используется "смешанный вариант" (им инициализированы
константы RegExprLine\[Paired\]Separator\[s\]): LineSeparators :=
\#$d\#$a; LinePairedSeparator := \#$d\#$a подробно описанный в [описании
синтаксиса](regexp_syntax.html#syntax_line_separators).

 

class function InvertCaseFunction  (const Ch : REChar) : REChar;

Преобразует символ Ch в верхний регистр если это символ нижнего регистра
и в нижний - если верхнего (используются текущие установки операционной
системы)

 

property InvertCase : TRegExprInvertCaseFunction;

Позволяет определить свою собственную реализацию
[регистро-независимого]<a name="modifier_i"></a> режима работы
TRegExpr. Инициализируется из глобальной константы
RegExprInvertCaseFunction (по умолчанию она указывает на
InvertCaseFunction)

 

procedure Compile;

Вызывает принудительную \[пере\]компиляцию  регулярного выражения.

Может быть полезной, например, для проверки корректности всех свойств
при создании визуальных редакторов рег.выражений и т.п.

 

function Dump : string;

возвращает внутренний формат в который было откомпилировано выражение.
Предназначено для особо любознательных ;)

### Глобальные константы
 EscChar = '\\';  // 'Escape'-char ('\\' in common r.e.) used for
escaping metachars (\\w, \\d etc).

 // it's may be usefull to redefine it if You are using C++ Builder - to
avoide ugly constructions

 // like '\\\\w+\\\\\\\\\\\\w+\\\\.\\\\w+' - just define EscChar='/' and
use '/w+\\/w+/./w+'

 
<a name="modifier_defs"></a>
Значения по умолчанию для модификаторов:

    RegExprModifierI : boolean = False;                // TRegExpr.ModifierI
    RegExprModifierR : boolean = True;                // TRegExpr.ModifierR
    RegExprModifierS : boolean = True;                // TRegExpr.ModifierS
    RegExprModifierG : boolean = True;                // TRegExpr.ModifierG
    RegExprModifierM : boolean = False;                //TRegExpr.ModifierM
    RegExprModifierX : boolean = False;                //TRegExpr.ModifierX

RegExprSpaceChars : RegExprString // Значение по умолчанию для SpaceChars  = ' '\#$9\#$A\#$D\#$C;

RegExprWordChars : RegExprString // Значение по умолчанию для WordChars
 =  '0123456789'
 + 'abcdefghijklmnopqrstuvwxyz'
 + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ\_';

RegExprLineSeparators : RegExprString // Значение по умолчанию для
LineSeparators

  =  \#$d\#$a{$IFDEF UniCode}\#$b\#$c\#$2028\#$2029\#$85{$ENDIF};

RegExprLinePairedSeparator : RegExprString // Значение по умолчанию для
LinePairedSeparator

  = \#$d\#$a;

 

RegExprInvertCaseFunction : TRegExprInvertCaseFunction // Значение по
умолчанию для InvertCase

= TRegExpr.InvertCaseFunction;

### Глобальные функции
function ExecRegExpr (const ARegExpr, AInputStr : string) : boolean;

true если строка AInputString совпадает с выражением ARegExpr

! При ошибках в ARegExpr будет генерировать exception

 

procedure SplitRegExpr (const ARegExpr, AInputStr : string; APieces :
TStrings);

Режет AInputStr на помещаемые в APieces куски по вхождениям выражения
ARegExpr (например, разбиение строки на отдельные поля, разделенные
некой последовательностью символов)

 

function ReplaceRegExpr (const ARegExpr, AInputStr, AReplaceStr :
string;

AUseSubstitution : boolean = False) : string;

Возвращает AInputStr в которой все вхождения выражения ARegExpr заменены
на AReplaceStr. Если AUseSubstitution = true, то AReplaceStr будет
восприниматься как шаблон для Substitution:

ReplaceRegExpr ('({-i}block|var)\\s\*\\(\\s\*(\[^ \]\*)\\s\*\\)\\s\*',

 'BLOCK( test1)', 'def "$1" value "$2"', True)

возвращает:  def 'BLOCK' value 'test1'

ReplaceRegExpr ('({-i}block|var)\\s\*\\(\\s\*(\[^ \]\*)\\s\*\\)\\s\*',

 'BLOCK( test1)', 'def "$1" value "$2"')

возвращает:  def "$1" value "$2"

 

function QuoteRegExprMetaChars (const AStr : string) : string;

Заменяет все метасимволы во входной строке так, чтобы ее можно было
безопасно использовать внутри регулярного выражения.

Например 'abc$cd.(' преобразуется в 'abc\\$cd\\.\\('

Эта функция полезна для автоматического синтеза регулярного выражения на
основании пользовательских данных

 

function RegExprSubExpressions (const ARegExpr : string;

ASubExprs : TStrings; AExtendedSyntax : boolean = False) : integer;

Создает список найденные в рег.выражении ARegExpr подвыражений

Каждому подвыражению соответствует элемент в ASubExps, где

 String - исходный текст подвыражения (без обрамляющих '()')

 мл.слово Object - начальная позиция подвыражения в  ARegExpr, включая
обрамляющий '(' если он есть!

 ст.слово Object - длина подвыражения, включая '(' и ')' если они есть!

AExtendedSyntax - должен быть True если модификатор /x будет включен при
использовании данного регулярного выражения.

Эта функция полезна для написания визуальных редакторов рег.выражений и
т.п. Пример использования есть в [TestRExp.dpr](#regexpstudio.html)

 

Результат        Комментарий

------------------------------------------------------------------------

0                Успех. Все скобки сбалансированы;

-1                Не хватает как минимум одной закрывающей скобки ')';

-(n+1)                В позиции n обнаружен незакрытый '\[';

n                В позиции n обнаружена закрывающая ')' для которой нет
открывающей '('.

 

Возвращает 0 если все скобки сбалансированы, или -1 если недостаточно
закрывающих скобок ')', или n если в позиции n встречена закрывающая
скобка ')' которой не соответствует ни одна открывающая '('.

Естественно, если Result <> 0, то ASubExprs может быть
некорректен.

 

 

Тип генерируемого при ошибках Exception

 

Обработчик ошибок TRegExpr по умолчанию (Вы вполне можете его перекрыть
и изменить его поведение) генерирует exception:

 

ERegExpr = class (Exception)

  public

   ErrorCode : integer; // Код ошибки. Ошибки компиляции выражения
меньше 1000, что позволяет их отличить от ошибок выполнения выражения.

   CompilerErrorPos : integer; // Позиция в выражении где произошла
последняя ошибка компиляции выражения

 end;

 
<a name="unicode"></>
### Как использовать Unicode

TRegExpr теперь поддерживает работу с UniCode.

Обратите внимание, что этот режим практически неоптимизирован и работает
чрезвычайно медленно (по сравнению со стандартным режимом).

Используйте его только если Вам действительно не обойтись без UniCode (а
лучше примите участие в разработке TRegExpr и оптимизируйте
UniCode-режим).

Чтобы переключить TRegExpr на работу с unicode уберите '.' из {.$DEFINE UniCode} в файле regexpr.pas.

Все строки после этого будут восприниматься как WideString.
