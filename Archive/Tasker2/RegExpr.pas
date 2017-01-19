{$B-}
unit RegExpr;

(*

     TRegExpr library
     Regular Expressions for Delphi
     v. 0.926 beta

Author:
     Andrey V. Sorokin
     St-Petersburg
     Russia
     anso@mail.ru, anso@usa.net
     http://anso.da.ru

This library is derived from Henry Spencer sources.
I translated the C sources into Object Pascal,
implemented object wrapper and some new features.
Many features suggested or partially implemented
by TRegExpr's users (see Gratitude below).


---------------------------------------------------------------
     Legal issues
---------------------------------------------------------------
 Copyright (c) 1999-00 by Andrey V. Sorokin <anso@mail.ru>

 This software is provided as it is, without any kind of warranty
 given. Use it at your own risk.

 You may use this software in any kind of development, including
 comercial, redistribute, and modify it freely, under the
 following restrictions :
 1. The origin of this software may not be mispresented, you must
    not claim that you wrote the original software. If you use
    this software in any kind of product, it would be appreciated
    that there in a information box, or in the documentation would
    be an acknowledgmnent like this
           Partial Copyright (c) 2000 by Andrey V. Sorokin
 2. You may not have any income from distributing this source
    to other developers. When you use this product in a comercial
    package, the source may not be charged seperatly.


---------------------------------------------------------------
     Legal issues for the original C sources:
---------------------------------------------------------------
 *  Copyright (c) 1986 by University of Toronto.
 *  Written by Henry Spencer.  Not derived from licensed software.
 *
 *  Permission is granted to anyone to use this software for any
 *  purpose on any computer system, and to redistribute it freely,
 *  subject to the following restrictions:
 *  1. The author is not responsible for the consequences of use of
 *      this software, no matter how awful, even if they arise
 *      from defects in it.
 *  2. The origin of this software must not be misrepresented, either
 *      by explicit claim or by omission.
 *  3. Altered versions must be plainly marked as such, and must not
 *      be misrepresented as being the original software.


---------------------------------------------------------------
     Gratitudes
---------------------------------------------------------------
  Guido Muehlwitz
    found and fixed ugly bug in big string processing
  Stephan Klimek
    testing in CPPB and suggesting/implementing many features
  Steve Mudford
    implemented Offset parameter
  Martin Baur
    usefull suggetions
  Special thanks to Jon Smith for really great work !
    He corrected my ugly english in this documentation.
    If you see any error - it must be mine 'after Jon' changes ;)

  And many others - for big work of bug hunting !

I am still looking for person who can help me to translate
this documentation into other languages (especially German)


---------------------------------------------------------------
     To do
---------------------------------------------------------------

-=- VCL-version of TRegExpr - for dummies ;) and TRegExprEdit
(replacement for TMaskEdit).
Actually, I am writing non-VCL aplications (with web-based
interfaces), so I don't need VCL's TRegExpr for myself.
Will it be really usefull ?

-=- full functionallity of braces {}
(I think this will be macrosubstitution so
size of r.e. will be extremly big  :((( )

-=- working with pascal-style string.
Now pascal-strings converted into PChar, so
you can't find r.e. in strings with #0 -chars.
(suggested by Pavel O).

-=- non-greedy style (suggested by Martin Baur)

I need your suggestions !
What are more importent in this list ?
Did I forgot anything ?


---------------------------------------------------------------
     History
---------------------------------------------------------------
Legend:
 (+) added feature
 (-) fixed bug
 (^) upgraded implementation

 v. 0.926 2000.02.26
 -=- (-) Old bug derived from H.Spencer sources - SPSTART was
     set for '?' and '*' instead of '*', '{m,n}' and '+'.
 -=- (-^) Now {m,n} works like Perl's one - error occures only
     if m > n or n > BracesMax (BracesMax = 255 in this version).
     In other cases (no m or nondigit symbols in m or n values,
     or no '}') symbol '{' will be compiled as literal.
     Note: so, you must include m value (use {0,n} instead of {,n}).
     Note: {m,} will be compiled as {m,BracesMax}.
 -=- (-^) CaseInsensitive mode now support ranges
     '(?i)[a]' == '[aA]'
 -=- (^) Roman-number template in TestRExp ;)
 -=- (+^) Beta version of complex-braces - like ((abc){1,2}|d){3}
     By default its turned off. If you want take part in beta-testing,
     please, remove '.' from {.$DEFINE ComplexBraces} below this comments.
 -=- (-^) Removed \b metachar (in Perl it isn't BS as in my implementation,
     but word bound)
 -=- (+) Add /s modifier. Bu I am not sure that it's ok for Windows.
     I implemented it as [^\n] for '.' metachar in non-/s mode.
     But lines separated by \n\r in windows. I need you suggestions !
 -=- (^) Sorry, but I had to rename Modifiers to ModifierStr
     (ModifierS uses for /s now)

 v. 0.91 2000.02.02
 -=- (^) some changes in documentation and demo-project.

 v. 0.90 2000.01.31
 -=- (+) implemented braces repetitions {min,max}.
     Sorry - only simple cases now - like '\d{2,3}'
     or '[a-z1-9]{,7}', but not (abc){2,3} ..
     I still too short in time.
     Wait for future versions of TRegExpr or
     implement it by youself and share with me ;)
 -=- (+) implemented case-insensitive modifier and way
     to work with other modifiers - see properties
     Modifiers, Modifier, ModifierI
     and (?ismx-ismx) Perl extension.
     You may use global variables RegExpr* for assigning
     default modifier values.
 -=- (+) property ExtSyntaxEnabled changed to 'r'-modifier
     (russian extensions - see documentation)
 -=- (+) implemented (?#comment) Perl extension - very hard
     and usefull work ;)
 -=- (^) property MatchCount renamed to SubExprMatchCount.
     Sorry for any inconvenients, but it's because new
     version works slightly different and if you used
     MatchCount in your programms you have to rethink
     it ! (see comments to this property)
 -=- (+) add InputString property - stores input string
     from last Exec call. You may directly assign values
     to this property for using in ExecPos method.
 -=- (+) add ExecPos method - for working with assigned
     to InputString property. You may use it like this
        InputString := AString;
        ExecPos;
     or this
        InputString := AString;
        ExecPos (AOffset);
     Note: ExecPos without parameter works only in
     Delphi 4 or higher.
 -=- (+) add ExecNext method - simple and fast (!) way to finding
     multiple occurences of r.e. in big input string.
 -=- (^) Offset parameter removed from Exec method, if you
     used it in your programs, please replace all
        Exec (AString, AOffset)
     with combination
        InputString := AString; ExecPos (AOffset)
     Sorry for any inconvenients, but old design
     (see v.0.81) was too ugly :(
     In addition, multiple Exec calls with same input
     string produce fool overhead because each Exec
     reallocate input string buffer.
 -=- (^) optimized implementation of Substitution,
     Replace and Split methods
 -=- (-) fixed minor bug - if r.e. compilation raise error
     during second pass (!!! I think it's impossible
     in really practice), TRegExpr stayed in 'compiled'
     state.
 -=- (-) fixed bug - Dump method didn't check program existance
     and raised 'access violation' if previouse Exec
     was finished with error.
 -=- (+) changed error handling (see functions Error, ErrorMsg,
     LastError, property CompilerErrorPos, type ERegExpr).
 -=- (-^) TRegExpr.Replace, Split and ExecNext made a infinite
     loop in case of r.e. match empty-string.
     Now ExecNext moves by MatchLen if MatchLen <> 0
     and by +1 if MatchLen = 0
     Thanks to Jon Smith and George Tasker for bugreports.
 -=- (-) While playing with null-matchs I discovered, that
     null-match at tail of input string is never found.
     Well, I fixed this, but I am not sure this is safe
     (MatchPos[0]=length(AInputString)+1, MatchLen = 0).
     Any suggetions are very appreciated.
 -=- (^) Demo project and documentation was upgraded
 -=- (^) Documentation and this version was published on my home page
     http://anso.da.ru


 v. 0.81 1999.12.25 // Merry Christmas ! :)
 -=- added \s (AnySpace) and \S (NotSpace) meta-symbols
     - implemented by Stephan Klimek with minor fixes by AVS
 -=- added \f, \a and \b chars (translates into FF, BEL, BS)
 -=- removed meta-symbols 'ö' & 'Ö' - sorry for any inconvenients
 -=- added Match property (== copy (InputStr, MatchPos [Idx], MatchLen [Idx]))
 -=- added extra parameter Offset to Exec method
     (thanks to Steve Mudford)

 v. 0.7 1999.08.22
 -=- fixed bug - in some cases the r.e. [^...]
     incorrectly processed (as any symbol)
     (thanks to Jan Korycan)
 -=- Some changes and improvements in TestRExp.dpr

 v. 0.6 1999.08.13 (Friday 13 !)
 -=- changed header of TRegExpr.Substitute
 -=- added Split, Replace & appropriate
     global wrappers (thanks to Stephan Klimek for suggetions)

 v. 0.5 1999.08.12
 -=- TRegExpr.Substitute routine added
 -=- Some changes and improvements in TestRExp.dpr
 -=- Fixed bug in english version of documentation
     (Thanks to Jon Buckheit)

 v. 0.4 1999.07.20
 -=- Fixed bug with parsing of strings longer then 255 bytes
     (thanks to Guido Muehlwitz)
 -=- Fixed bug in RegMatch - mathes only first occurence of r.e.
     (thanks to Stephan Klimek)

 v. 0.3 1999.06.13
 -=- ExecRegExpr function

 v. 0.2 1999.06.10
 -=- packed into object-pascal class
 -=- code slightly rewriten for pascal
 -=- now macro correct proceeded in ranges
 -=- r.e.ranges syntax extended for russian letters ranges:
     à-ÿ - replaced with all small russian letters (Win1251)
     À-ß - replaced with all capital russian letters (Win1251)
     à-ß - replaced with all russian letters (Win1251)
 -=- added macro '\d' (opcode ANYDIGIT) - match any digit
 -=- added macro '\D' (opcode NOTDIGIT) - match not digit
 -=- added macro '\w' (opcode ANYLETTER) - match any english letter or '_'
 -=- added macro '\W' (opcode NOTLETTER) - match not english letter or '_'
 (all r.e.syntax extensions may be turned off by flag ExtSyntax)

 v. 0.1 1999.06.09
 first version, with bugs, without help => must die :(

*)

{$DEFINE DebugRegExpr} // define for dump/trace enabling
{.$DEFINE ComplexBraces} // define for beta-version of braces
// (in stable version it works only for simple cases)

interface

//###0.81 determine version (for using 'params by default')
{$IFNDEF VER80}         { Delphi 1.0}
 {$IFNDEF VER90}        { Delphi 2.0}
  {$IFNDEF VER93}       { C++Builder 1.0}
    {$IFNDEF VER100}    { Borland Delphi 3.0}
        {$DEFINE D4_}   { Delphi 4.0 or higher}
    {$ENDIF}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}
{.$IFNDEF VER110}  { Borland C++Builder 3.0}
{.$IFNDEF VER120}  {Borland Delphi 4.0}


uses
 Classes, // TStrings in Split method
 SysUtils; //###0.90 moved from implementation (Exception type now need in interface section)


type
 TRegExprCharSet = set of char;

const
  RegExprModifierI : boolean = False; //###0.90
  // default value for ModifierI

  RegExprModifierR : boolean = True; //###0.90
  // default value for ModifierR

  RegExprModifierS : boolean = True; //###0.926
  // default value for ModifierS

{=============================================================}
{================== Error handling section ===================}
{=============================================================}

const
 reeOk = 0;
 reeCompNullArgument = 100;
 reeCompRegexpTooBig = 101;
 reeCompParseRegTooManyBrackets = 102;
 reeCompParseRegUnmatchedBrackets = 103;
 reeCompParseRegUnmatchedBrackets2 = 104;
 reeCompParseRegJunkOnEnd = 105;
 reePlusStarOperandCouldBeEmpty = 106;
 reeNestedSQP = 107;
 reeBadHexDigit = 108;
 reeInvalidRange = 109;
 reeParseAtomTrailingBackSlash = 110;
 reeNoHexCodeAfterBSlashX = 111;
 reeNoHexCodeAfterBSlashX2 = 112;
 reeUnmatchedSqBrackets = 113;
 reeInternalUrp = 114;
 reeQPSBFollowsNothing = 115;
 reeTrailingBackSlash = 116;
 reeNoHexCodeAfterBSlashX3 = 117;
 reeNoHexCodeAfterBSlashX4 = 118;
 reeRarseAtomInternalDisaster = 119;
// reeUmatchedBraces = 120; //###0.92
// reeUmatchedBraces2 = 121; //###0.92
 reeBRACESArgTooBig = 122;
// reeBRACEBadArg = 123; //###0.92
 reeBracesMinParamGreaterMax = 124;
 reeUnclosedComment = 125;
 reeComplexBracesNotImplemented = 126;
 reeUrecognizedModifier = 127;
 reeRegRepeatCalledInappropriately = 1000;
 reeMatchPrimMemoryCorruption = 1001;
 reeMatchPrimCorruptedPointers = 1002;
 reeNoExpression = 1003;
 reeCorruptedProgram = 1004;
 reeNoInpitStringSpecified = 1005;
 reeOffsetMustBeGreaterThen0 = 1006;
 reeExecNextWithoutExec = 1007;
 reeGetInputStringWithoutInputString = 1008;
 reeSubstNoExpression = 1009;
 reeSubstCorruptedProgramm = 1010;
 reeDumpCorruptedOpcode = 1011;
 reeExecAfterCompErr = 1012;
 reeModifierUnsupported = 1013;
 reeLoopStackExceeded = 1014;
 reeLoopWithoutEntry = 1015;

const
 NSUBEXP = 10; // max number of substitutions
 BracesMax = 255; // max value for {n,m} arguments //###0.92
 {$IFDEF ComplexBraces}
 LoopStackMax = 10; // max depth of loops stack //###0.925
 {$ENDIF}

 RegExprSpaceCharSet : TRegExprCharSet = // chars for /s & /S
  [' ', #$9, #$A, #$D, #$C]; // (typed const for customization purpose)

const
 MAGIC = #156; // programm signature ($9C)

// name   opcode   opnd? meaning
 EEND    = #0;   // no   End of program
 BOL     = #1;   // no   Match "" at beginning of line
 EOL     = #2;   // no   Match "" at end of line
 ANY     = #3;   // no   Match any one character
 ANYOF   = #4;   // str  Match any character in this string
 ANYBUT  = #5;   // str  Match any char. not in this string
 BRANCH  = #6;   // node Match this alternative, or the next
 BACK    = #7;   // no   Match "", "next" ptr points backward
 EXACTLY = #8;   // str  Match this string
 NOTHING = #9;   // no   Match empty string
 STAR    = #10;  // node Match this (simple) thing 0 or more times
 PLUS    = #11;  // node Match this (simple) thing 1 or more times
 ANYDIGIT= #12;  // no   Match any digit (equiv [0-9])
 NOTDIGIT= #13;  // no   Match not digit (equiv [0-9])
 ANYLETTER=#14;  // no   Match any english letter (equiv [a-zA-Z_])
 NOTLETTER=#15;  // no   Match not english letter (equiv [a-zA-Z_])
 ANYSPACE =#16;  // no   Match any space char (equiv [ \t]) //###0.8
 NOTSPACE =#17;  // no   Match not space char (equiv [ \t]) //###0.8
 BRACES  = #18;  // node,min,max Match this (simple) thing from min to max times. //###0.90
 COMMENT = #19;  // no   Comment //###0.90
 OPEN    = #20;  // no   Mark this point in input as start of #n
                 //      OPEN+1 is number 1, etc.
 CLOSE   = #30;  // no   Analogous to OPEN.
 EXACTLYCI = #40;// str  Match this string case insensitive //###0.90
 ANYOFCI = #41;  // str  Match any character in this string, case insensitive //###0.92
 ANYBUTCI= #42;  // str  Match any char. not in this string, case insensitive //###0.92
 {$IFDEF ComplexBraces}
 LOOPENTRY= #43; // node Start of loop (node - LOOP for this loop) //###0.925
 LOOP    = #44;  // node,min,max,loopentryjmp - back jump for LOOPENTRY. //###0.925
 // node - next node in sequence,loopentryjmp - associated LOOPENTRY node addr
 {$ENDIF}
 
type
 TRegExpr = class
   private
    startp : array [0 .. NSUBEXP - 1] of PChar; // founded expr starting points
    endp : array [0 .. NSUBEXP - 1] of PChar; // founded expr end points

    {$IFDEF ComplexBraces}
    LoopStack : array [1 .. LoopStackMax] of integer; // state before entering loop //###0.925
    LoopStackIdx : integer; // 0 - out of all loops //###0.925
    {$ENDIF}

    // The "internal use only" fields to pass info from compile
    // to execute that permits the execute phase to run lots faster on
    // simple cases.
    regstart : char; // char that must begin a match; '\0' if none obvious
    reganch : char; // is the match anchored (at beginning-of-line only)?
    regmust : PChar; // string (pointer into program) that match must include, or nil
    regmlen : integer; // length of regmust string
    // Regstart and reganch permit very fast decisions on suitable starting points
    // for a match, cutting down the work a lot.  Regmust permits fast rejection
    // of lines that cannot possibly match.  The regmust tests are costly enough
    // that regcomp() supplies a regmust only if the r.e. contains something
    // potentially expensive (at present, the only such thing detected is * or +
    // at the start of the r.e., which can involve a lot of backup).  Regmlen is
    // supplied because the test in regexec() needs it and regcomp() is computing
    // it anyway.

    // work variables for Exec's routins - save stack in recursion}
    reginput : PChar; // String-input pointer.
    regbol : PChar; // Beginning of input, for ^ check.
    regeol : PChar; // End of input, for pascal-style string processing //###0.92

    // work variables for compiler's routines
    regparse : PChar;  // Input-scan pointer.
    regnpar : integer; // count.
    regdummy : char;
    regcode : PChar;   // Code-emit pointer; @regdummy = don't.
    regsize : integer; // Code size.

    regexpbeg : PChar; //##0.90 only for error handling. Contains


    fExpression : PChar; // source of compiled r.e.
    fInputString : PChar; // input string

    fLastError : integer; // see Error, LastError

    fModifiers : integer; // modifiers //###0.90
    fCompModifiers : integer; // compiler's copy of modifiers //###0.90
    fProgModifiers : integer; // values modifiers from last programm compilation

    procedure CheckCompModifiers;
    // if modifiers was changed after programm compilation - recompile it !

    function GetExpression : string;
    procedure SetExpression (const s : string);

    function GetModifierStr : string; //###0.926
    function SetModifiersInt (const AModifiers : string; var AModifiersInt : integer) : boolean; //###0.90
    procedure SetModifierStr (const AModifiers : string); //###0.926

    function GetModifier (AIndex : integer) : boolean; //###0.90
    procedure SetModifier (AIndex : integer; ASet : boolean); //###0.90


    {==================== Compiler section ===================}
    function CompileRegExpr (exp : PChar) : boolean;
    // compile a regular expression into internal code

    procedure Tail (p : PChar; val : PChar);
    // set the next-pointer at the end of a node chain

    procedure OpTail (p : PChar; val : PChar);
    // regoptail - regtail on operand of first argument; nop if operandless

    function EmitNode (op : char) : PChar;
    // regnode - emit a node, return location

    procedure EmitC (b : char);
    // emit (if appropriate) a byte of code

    procedure InsertOperator (op : char; opnd : PChar; sz : integer); //###0.90
    // insert an operator in front of already-emitted operand
    // Means relocating the operand.

    function ParseReg (paren : integer; var flagp : integer) : PChar;
    // regular expression, i.e. main body or parenthesized thing

    function ParseBranch (var flagp : integer) : PChar;
    // one alternative of an | operator

    function ParsePiece (var flagp : integer) : PChar;
    // something followed by possible [*+?]

    function ParseAtom (var flagp : integer) : PChar;
    // the lowest level

    function GetCompilerErrorPos : integer; //###0.90
    // current pos in r.e. - for error hanling

    {===================== Mathing section ===================}
    function regrepeat (p : PChar; AMax : integer) : integer; //###0.92
    // repeatedly match something simple, report how many


    function MatchPrim (prog : PChar) : boolean;
    // recursively matching routine

    function RegMatch (str : PChar) : boolean;
    // try match at specific point, uses MatchPrim for real work

    function ExecPrim (AOffset: integer) : boolean; //###0.90
    // Exec for stored InputString

    {$IFDEF DebugRegExpr}
    function DumpOp (op : char) : string;
    {$ENDIF}

    function GetSubExprMatchCount : integer; //###0.90
    function GetMatchPos (Idx : integer) : integer;
    function GetMatchLen (Idx : integer) : integer;
    function GetMatch (Idx : integer) : string;

    function GetInputString : string; //###0.90
    procedure SetInputString (const AInputString : string); //###0.90

   protected
    // pointer to beginning of r.e. while compiling
    fExprIsCompiled : boolean; //###0.90 true if r.e. successfully compiled
    // programm is essentially a linear encoding
    // of a nondeterministic finite-state machine (aka syntax charts or
    // "railroad normal form" in parsing technology).  Each node is an opcode
    // plus a "next" pointer, possibly plus an operand.  "Next" pointers of
    // all nodes except BRANCH implement concatenation; a "next" pointer with
    // a BRANCH on both ends of it is connecting two alternatives.  (Here we
    // have one of the subtle syntax dependencies:  an individual BRANCH (as
    // opposed to a collection of them) is never concatenated with anything
    // because of operator precedence.)  The operand of some types of node is
    // a literal string; for others, it is a node leading into a sub-FSM.  In
    // particular, the operand of a BRANCH node is the first node of the branch.
    // (NB this is *not* a tree structure:  the tail of the branch connects
    // to the thing following the set of BRANCHes.)  The opcodes are:
    programm : PChar; // Unwarranted chumminess with compiler.

    function regnext (p : PChar) : PChar;
    // dig the "next" pointer out of a node
    procedure Error (AErrorID : integer); virtual; // error handler.
    // Default handler raise exception ERegExpr with
    // Message = ErrorMsg (AErrorID), ErrorCode = AErrorID
    // and CompilerErrorPos = value of property CompilerErrorPos.

   public
    constructor Create;
    destructor Destroy; override;

    property Expression : string read GetExpression write SetExpression;
    // regular expression
    // When you assign r.e. to this property, TRegExpr will automatically
    // compile it and store in internal structures.
    // In case of compilation error, Error method will be called
    // (by default Error method raises exception ERegExpr - see below)

    property ModifierStr : string read GetModifierStr write SetModifierStr; //###0.926
    // Set/get default values of r.e.syntax modifiers. Modifiers in
    // r.e. (?ismx-ismx) will replace this default values.
    // If you try to set unsupported modifier, Error will be called
    // (by defaul Error raises exception ERegExpr).

    property ModifierI : boolean index 1 read GetModifier write SetModifier; //###0.90
    // Modifier /i - caseinsensitive, false by default

    property ModifierR : boolean index 2 read GetModifier write SetModifier; //###0.90
    // Modifier /r - use r.e.syntax extended for russian, true by default
    // (was property ExtSyntaxEnabled in previous versions)
    // If true, then à-ÿ  additional include russian letter '¸',
    // À-ß  additional include '¨', and à-ß include all russian symbols.
    // You have to turn it off if it may interfere with you national alphabet.

    property ModifierS : boolean index 3 read GetModifier write SetModifier; //###0.926
    // Modifier /s - '.' works as any char (else as [^\n]),
    // true by default

    function Exec (const AInputString : string) : boolean; //###0.90
    // match a programm against a string AInputString
    // !!! Exec store AInputString into InputString property

    function ExecNext : boolean; //###0.90
    // find next match:
    //    Exec (AString); ExecNext;
    // works same as
    //    Exec (AString);
    //    if MatchLen [0] = 0 then ExecPos (MatchPos [0] + 1) 
    //     else ExecPos (MatchPos [0] + MatchLen [0]);
    // but it's more simpler !

    function ExecPos (AOffset: integer {$IFDEF D4_}= 1{$ENDIF}) : boolean; //###0.90
    // find match for InputString starting from AOffset position
    // (AOffset=1 - first char of InputString)

    property InputString : string read GetInputString write SetInputString; //###0.90
    // returns current input string (from last Exec call or last assign
    // to this property).
    // Any assignment to this property clear Match* properties !

    function Substitute (const ATemplate : string) : string;
    // Returns ATemplate with '&' replaced by whole r.e. occurence
    // and '/n' replaced by occurence of subexpression #n.

    procedure Split (AInputStr : string; APieces : TStrings);
    // Split AInputStr into APieces by r.e. occurencies

    function Replace (AInputStr : string; const AReplaceStr : string) : string;
    // Returns AInputStr with r.e. occurencies replaced by AReplaceStr

    property SubExprMatchCount : integer read GetSubExprMatchCount;
    // Number of subexpressions has been found in last Exec* call.
    // If there are no subexpr. but whole expr was found (Exec* returned True),
    // then SubExprMatchCount=0, if no subexpressions nor whole
    // r.e. found (Exec* returned false) then SubExprMatchCount=-1.
    // Note, that some subexpr. may be not found and for such
    // subexpr. MathPos=MatchLen=-1 and Match=''.
    // For example: Expression := '(1)?2(3)?';
    //  Exec ('123'): SubExprMatchCount=2, Match[0]='123', [1]='1', [2]='3'
    //  Exec ('12'): SubExprMatchCount=1, Match[0]='23', [1]='1'
    //  Exec ('23'): SubExprMatchCount=2, Match[0]='23', [1]='', [2]='3'
    //  Exec ('2'): SubExprMatchCount=0, Match[0]='2'
    //  Exec ('7') - return False: SubExprMatchCount=-1

    property MatchPos [Idx : integer] : integer read GetMatchPos;
    // pos of entrance subexpr. #Idx into tested in last Exec*
    // string. First subexpr. have Idx=1, last - MatchCount,
    // whole r.e. have Idx=0.
    // Returns -1 if in r.e. no such subexpr. or this subexpr.
    // not found in input string.

    property MatchLen [Idx : integer] : integer read GetMatchLen;
    // len of entrance subexpr. #Idx r.e. into tested in last Exec*
    // string. First subexpr. have Idx=1, last - MatchCount,
    // whole r.e. have Idx=0.
    // Returns -1 if in r.e. no such subexpr. or this subexpr.
    // not found in input string.
    // Remember - MatchLen may be 0 (if r.e. match empty string) !

    property Match [Idx : integer] : string read GetMatch;
    // == copy (InputString, MatchPos [Idx], MatchLen [Idx])
    // Returns '' if in r.e. no such subexpr. or this subexpr.
    // not found in input string.

    function LastError : integer; //###0.90
    // Returns ID of last error, 0 if no errors (unusable if
    // Error method raises exception) and clear internal status
    // into 0 (no errors).

    function ErrorMsg (AErrorID : integer) : string; virtual;
    // Returns Error message for error with ID = AErrorID.

    property CompilerErrorPos : integer read GetCompilerErrorPos; //###0.90
    // Returns pos in r.e. there compiler stopped.
    // Usefull for error diagnostics

    {$IFDEF DebugRegExpr}
    function Dump : string;
    // dump a compiled regexp in vaguely comprehensible form
    {$ENDIF}
  end;

 ERegExpr = class (Exception)
   public
    ErrorCode : integer;
    CompilerErrorPos : integer;
  end;

function ExecRegExpr (const ARegExpr, AInputStr : string) : boolean;
// true if string AInputString match regular expression ARegExpr
// ! will raise exeption if syntax errors in ARegExpr

procedure SplitRegExpr (const ARegExpr, AInputStr : string; APieces : TStrings);
// Split AInputStr into APieces by r.e. ARegExpr occurencies

function ReplaceRegExpr (const ARegExpr, AInputStr, AReplaceStr : string) : string;
// Returns AInputStr with r.e. occurencies replaced by AReplaceStr


implementation

const
 MaskModI = 1; // modifier /i bit in fModifiers
 MaskModR = 2; // -"- /r
 MaskModS = 4; // -"- /s //###0.926

{=============================================================}
{===================== Global functions ======================}
{=============================================================}

function ExecRegExpr (const ARegExpr, AInputStr : string) : boolean;
 var r : TRegExpr;
 begin
  r := TRegExpr.Create;
  try
    r.Expression := ARegExpr;
    Result := r.Exec (AInputStr);
    finally r.Free;
   end;
 end; { of function ExecRegExpr
--------------------------------------------------------------}

procedure SplitRegExpr (const ARegExpr, AInputStr : string; APieces : TStrings);
 var r : TRegExpr;
 begin
  APieces.Clear;
  r := TRegExpr.Create;
  try
    r.Expression := ARegExpr;
    r.Split (AInputStr, APieces);
    finally r.Free;
   end;
 end; { of procedure SplitRegExpr
--------------------------------------------------------------}

function ReplaceRegExpr (const ARegExpr, AInputStr, AReplaceStr : string) : string;
 var r : TRegExpr;
 begin
  r := TRegExpr.Create;
  try
    r.Expression := ARegExpr;
    Result := r.Replace (AInputStr, AReplaceStr);
    finally r.Free;
   end;
 end; { of function ReplaceRegExpr
--------------------------------------------------------------}



// A node is one char of opcode followed by two chars of "next" pointer.
// "Next" pointers are stored as two 8-bit pieces, high order first.  The
// value is a positive offset from the opcode of the node containing it.
// An operand, if any, simply follows the node.  (Note that much of the
// code generation knows about this implicit relationship.)
// Using two bytes for the "next" pointer is vast overkill for most things,
// but allows patterns to get big without disasters.

// Opcodes description:
//
// BRANCH The set of branches constituting a single choice are hooked
//      together with their "next" pointers, since precedence prevents
//      anything being concatenated to any individual branch.  The
//      "next" pointer of the last BRANCH in a choice points to the
//      thing following the whole choice.  This is also where the
//      final "next" pointer of each individual branch points; each
//      branch starts with the operand node of a BRANCH node.
// BACK Normal "next" pointers all implicitly point forward; BACK
//      exists to make loop structures possible.
// STAR,PLUS '?', and complex '*' and '+', are implemented as circular
//      BRANCH structures using BACK.  Simple cases (one character
//      per match) are implemented with STAR and PLUS for speed
//      and to minimize recursive plunges.
// BRACES {min,max} are implemented as special pair LOOPENTRY-LOOP.
//      Each LOOPENTRY initialize loopstack for current level.
//      Simple cases (one
//      character per match) are implemented with BRACES for speed and
//      to minimize recursive plunges and size of 'programm'.
// OPEN,CLOSE   ...are numbered at compile time.


function TRegExpr.ErrorMsg (AErrorID : integer) : string;
 begin
  case AErrorID of
    reeOk: Result := 'No errors';
    reeCompNullArgument: Result := 'TRegExpr(comp): Null Argument';
    reeCompRegexpTooBig: Result := 'TRegExpr(comp): Regexp Too Big';
    reeCompParseRegTooManyBrackets: Result := 'TRegExpr(comp): ParseReg Too Many ()';
    reeCompParseRegUnmatchedBrackets: Result := 'TRegExpr(comp): ParseReg Unmatched ()';
    reeCompParseRegUnmatchedBrackets2: Result := 'TRegExpr(comp): ParseReg Unmatched ()';
    reeCompParseRegJunkOnEnd: Result := 'TRegExpr(comp): ParseReg Junk On End';
    reePlusStarOperandCouldBeEmpty: Result := 'TRegExpr(comp): *+ Operand Could Be Empty';
    reeNestedSQP: Result := 'TRegExpr(comp): Nested *?+';
    reeBadHexDigit: Result := 'TRegExpr(comp): Bad Hex Digit';
    reeInvalidRange: Result := 'TRegExpr(comp): Invalid [] Range';
    reeParseAtomTrailingBackSlash: Result := 'TRegExpr(comp): Parse Atom Trailing \';
    reeNoHexCodeAfterBSlashX: Result := 'TRegExpr(comp): No Hex Code After \x';
    reeNoHexCodeAfterBSlashX2: Result := 'TRegExpr(comp): No Hex Code After \x';
    reeUnmatchedSqBrackets: Result := 'TRegExpr(comp): Unmatched []';
    reeInternalUrp: Result := 'TRegExpr(comp): Internal Urp';
    reeQPSBFollowsNothing: Result := 'TRegExpr(comp): ?+*{ Follows Nothing';
    reeTrailingBackSlash: Result := 'TRegExpr(comp): Trailing \';
    reeNoHexCodeAfterBSlashX3: Result := 'TRegExpr(comp): No Hex Code After \x';
    reeNoHexCodeAfterBSlashX4 : Result := 'TRegExpr(comp): No Hex Code After \x';
    reeRarseAtomInternalDisaster: Result := 'TRegExpr(comp): RarseAtom Internal Disaster';
//    reeUmatchedBraces: Result := 'TRegExpr(comp): Umatched Braces'; //###0.92
//    reeUmatchedBraces2: Result := 'TRegExpr(comp): Umatched Braces'; //###0.92
    reeBRACESArgTooBig: Result := 'TRegExpr(comp): BRACES Argument Too Big';
//    reeBRACEBadArg: Result := 'TRegExpr(comp): BRACE Bad Argument'; //###0.92
    reeBracesMinParamGreaterMax: Result := 'TRegExpr(comp): BRACE Min Param Greater then Max';
    reeUnclosedComment: Result := 'TRegExpr(comp): Unclosed (?#Comment)';
    reeComplexBracesNotImplemented: Result := 'TRegExpr(comp): If you want take part in beta-testing BRACES ''{min,max}'' for complex cases - remove ''.'' from {.$DEFINE ComplexBraces}';
    reeUrecognizedModifier: Result := 'TRegExpr(comp): Urecognized Modifier';

    reeRegRepeatCalledInappropriately: Result := 'TRegExpr(exec): RegRepeat Called Inappropriately';
    reeMatchPrimMemoryCorruption: Result := 'TRegExpr(exec): MatchPrim Memory Corruption';
    reeMatchPrimCorruptedPointers: Result := 'TRegExpr(exec): MatchPrim Corrupted Pointers';
    reeNoExpression: Result := 'TRegExpr(exec): Not Assigned Expression Property';
    reeCorruptedProgram: Result := 'TRegExpr(exec): Corrupted Program';
    reeNoInpitStringSpecified: Result := 'TRegExpr(exec): No Inpit String Specified';
    reeOffsetMustBeGreaterThen0: Result := 'TRegExpr(exec): Offset Must Be Greater Then 0';
    reeExecNextWithoutExec: Result := 'TRegExpr(exec): ExecNext Without Exec[Pos]';
    reeGetInputStringWithoutInputString: Result := 'TRegExpr(exec): GetInputString Without InputString';
    reeSubstNoExpression: Result := 'TRegExpr(subst): Not Assigned Expression Property';
    reeSubstCorruptedProgramm: Result := 'TRegExpr(subst): Corrupted Programm';
    reeDumpCorruptedOpcode: Result := 'TRegExpr(dump): Corrupted Opcode';
    reeExecAfterCompErr: Result := 'TRegExpr(exec): Exec After Compilation Error';
    reeLoopStackExceeded: Result := 'TRegExpr(exec): Loop Stack Exceeded';
    reeLoopWithoutEntry: Result := 'TRegExpr(exec): Loop Without LoopEntry !';
    else Result := 'Unknown error';
   end;
 end; { of procedure TRegExpr.Error
--------------------------------------------------------------}

procedure TRegExpr.Error (AErrorID : integer);
 var
  e : ERegExpr;
 begin
  fLastError := AErrorID; // dummy stub - useless because will raise exception
  if AErrorID < 1000 // compilation error ?
   then e := ERegExpr.Create (ErrorMsg (AErrorID) // yes - show error pos
             + ' (pos ' + IntToStr (CompilerErrorPos) + ')')
   else e := ERegExpr.Create (ErrorMsg (AErrorID));
  e.ErrorCode := AErrorID;
  e.CompilerErrorPos := CompilerErrorPos;
  raise e;
 end; { of procedure TRegExpr.Error
--------------------------------------------------------------}

function TRegExpr.LastError : integer;
 begin
  Result := fLastError;
  fLastError := reeOk;
 end; { of function TRegExpr.LastError
--------------------------------------------------------------}


{=============================================================}
{===================== Common section ========================}
{=============================================================}

constructor TRegExpr.Create;
 begin
  inherited;
  programm := nil;
  fExpression := nil;
  fInputString := nil;

  regexpbeg := nil; //###0.90
  fExprIsCompiled := false; //###0.90

  ModifierI := RegExprModifierI; //###0.90
  ModifierR := RegExprModifierR; //###0.90
  ModifierS := RegExprModifierS; //###0.926
 end; { of constructor TRegExpr.Create
--------------------------------------------------------------}

destructor TRegExpr.Destroy;
 begin
  if programm <> nil
   then FreeMem (programm);
  if fExpression <> nil
   then FreeMem (fExpression);
  if fInputString <> nil
   then FreeMem (fInputString);
 end; { of destructor TRegExpr.Destroy
--------------------------------------------------------------}

function TRegExpr.GetExpression : string;
 begin
  if fExpression <> nil
   then Result := fExpression
   else Result := '';
 end; { of function TRegExpr.GetExpression
--------------------------------------------------------------}

procedure TRegExpr.SetExpression (const s : string);
 begin
  if (s <> fExpression) or not fExprIsCompiled then begin //###0.90
    fExprIsCompiled := false; //###0.90
    if fExpression <> nil then begin
      FreeMem (fExpression);
      fExpression := nil;
     end;
    if s <> '' then begin
      GetMem (fExpression, length (s) + 1);
      CompileRegExpr (StrPCopy (fExpression, s));
     end;
   end;
 end; { of procedure TRegExpr.SetExpression
--------------------------------------------------------------}

function TRegExpr.GetSubExprMatchCount : integer; //###0.90
 begin
  if Assigned (fInputString) then begin
     Result := NSUBEXP - 1;
     while (Result > 0) and ((startp [Result] = nil)
                             or (endp [Result] = nil))
      do dec (Result);
    end
   else Result := -1;
 end; { of function TRegExpr.GetSubExprMatchCount
--------------------------------------------------------------}

function TRegExpr.GetMatchPos (Idx : integer) : integer;
 begin
  if (Idx >= 0) and (Idx < NSUBEXP) and Assigned (fInputString)
     and Assigned (startp [Idx]) and Assigned (endp [Idx]) then begin
     Result := (startp [Idx] - fInputString) + 1;
    end
   else Result := -1;
 end; { of function TRegExpr.GetMatchPos
--------------------------------------------------------------}

function TRegExpr.GetMatchLen (Idx : integer) : integer;
 begin
  if (Idx >= 0) and (Idx < NSUBEXP) and Assigned (fInputString)
     and Assigned (startp [Idx]) and Assigned (endp [Idx]) then begin
     Result := endp [Idx] - startp [Idx];
    end
   else Result := -1;
 end; { of function TRegExpr.GetMatchLen
--------------------------------------------------------------}

function TRegExpr.GetMatch (Idx : integer) : string;
 begin
  if (Idx >= 0) and (Idx < NSUBEXP) and Assigned (fInputString)
     and Assigned (startp [Idx]) and Assigned (endp [Idx])
   then Result := copy (fInputString, MatchPos [Idx], MatchLen [Idx])
   else Result := '';
 end; { of function TRegExpr.GetMatch
--------------------------------------------------------------}

procedure TRegExpr.CheckCompModifiers;
 begin
  if (programm <> nil) and (fExpression <> nil)
     and (fModifiers <> fProgModifiers)
   then CompileRegExpr (fExpression);
 end; { of TRegExpr.CheckCompModifiers
--------------------------------------------------------------}

function TRegExpr.GetModifierStr : string; //###0.926
 begin
  Result := '-';

  if ModifierI
   then Result := 'i' + Result
   else Result := Result + 'i';
  if ModifierR
   then Result := 'r' + Result
   else Result := Result + 'r';
  if ModifierS //###0.926
   then Result := 's' + Result
   else Result := Result + 's';

  if Result [length (Result)] = '-' // remove '-' if all modifiers are 'On'
   then System.Delete (Result, length (Result), 1);
 end; { of function TRegExpr.GetModifierStr
--------------------------------------------------------------}

function TRegExpr.SetModifiersInt (const AModifiers : string; var AModifiersInt : integer) : boolean; //###0.90
 var
  i : integer;
  IsOn : boolean;
  Mask : integer;
 begin
  Result := true;
  IsOn := true;
  Mask := 0; // strange compiler varning
  for i := 1 to length (AModifiers) do
   if AModifiers [i] = '-'
    then IsOn := false
    else begin
      if AModifiers [i] in ['i', 'I']
       then Mask := MaskModI
      else if AModifiers [i] in ['r', 'R']
       then Mask := MaskModR
      else if AModifiers [i] in ['s', 'S'] //###0.926
       then Mask := MaskModS
      else begin
        Result := false;
        EXIT;
       end;
      if IsOn
       then AModifiersInt := AModifiersInt or Mask
       else AModifiersInt := AModifiersInt and not Mask;
     end;
 end; { of function TRegExpr.SetModifiersInt
--------------------------------------------------------------}

procedure TRegExpr.SetModifierStr (const AModifiers : string); //###0.926
 begin
  if not SetModifiersInt (AModifiers, fModifiers)
   then Error (reeModifierUnsupported);
  CheckCompModifiers;
 end; { of procedure TRegExpr.SetModifierStr
--------------------------------------------------------------}

function TRegExpr.GetModifier (AIndex : integer) : boolean; //###0.90
 var
  Mask : integer;
 begin
  Result := false;
  case AIndex of
    1: Mask := MaskModI;
    2: Mask := MaskModR;
    3: Mask := MaskModS; //###0.926
    else begin
      Error (reeModifierUnsupported);
      EXIT;
     end;
   end;
  Result := (fModifiers and Mask) = Mask;
 end; { of function TRegExpr.GetModifier
--------------------------------------------------------------}

procedure TRegExpr.SetModifier (AIndex : integer; ASet : boolean); //###0.90
 var
  Mask : integer;
 begin
  case AIndex of
    1: Mask := MaskModI;
    2: Mask := MaskModR;
    3: Mask := MaskModS; //###0.926
    else begin
      Error (reeModifierUnsupported);
      EXIT;
     end;
   end;
  if ASet
   then fModifiers := fModifiers or Mask
   else fModifiers := fModifiers and not Mask;
  CheckCompModifiers;
 end; { of procedure TRegExpr.SetModifier
--------------------------------------------------------------}


{=============================================================}
{==================== Compiler section =======================}
{=============================================================}

function NEXT (p : PChar) : word;
 begin
  Result := (ord ((p + 1)^) ShL 8) + ord ((p + 2)^);
 end; { of function NEXT
--------------------------------------------------------------}

procedure TRegExpr.Tail (p : PChar; val : PChar);
// set the next-pointer at the end of a node chain
 var
  scan : PChar;
  temp : PChar;
  offset : integer;
 begin
  if p = @regdummy
   then EXIT;
  // Find last node.
  scan := p;
  REPEAT
   temp := regnext (scan);
   if temp = nil
    then BREAK;
   scan := temp;
  UNTIL false;

  if scan^ = BACK
   then offset := scan - val
   else offset := val - scan;
  (scan + 1)^ := Char ((offset ShR 8) and $FF);
  (scan + 2)^ := Char (offset and $FF);
 end; { of procedure TRegExpr.Tail
--------------------------------------------------------------}

procedure TRegExpr.OpTail (p : PChar; val : PChar);
// regtail on operand of first argument; nop if operandless
 begin
  // "Operandless" and "op != BRANCH" are synonymous in practice.
  if (p = nil) or (p = @regdummy) or (p^ <> BRANCH)
   then EXIT;
  Tail (p + 3, val);
 end; { of procedure TRegExpr.OpTail
--------------------------------------------------------------}

function TRegExpr.EmitNode (op : char) : PChar;
// emit a node, return location
 begin
  Result := regcode;
  if Result <> @regdummy then begin
     regcode^ := op;
     inc (regcode);
     regcode^ := #0; // "next" pointer := nil
     inc (regcode);
     regcode^ := #0;
     inc (regcode);
    end
   else inc (regsize, 3); // compute code size without code generation
 end; { of function TRegExpr.EmitNode
--------------------------------------------------------------}

procedure TRegExpr.EmitC (b : char);
// emit (if appropriate) a byte of code
 begin
  if regcode <> @regdummy then begin
     regcode^ := b;
     inc (regcode);
    end
   else inc (regsize);
 end; { of procedure TRegExpr.EmitC
--------------------------------------------------------------}

procedure TRegExpr.InsertOperator (op : char; opnd : PChar; sz : integer); //###0.90
// insert an operator in front of already-emitted operand
// Means relocating the operand.
 var
  src, dst, place : PChar;
  i : integer;
 begin
  if regcode = @regdummy then begin
    inc (regsize, sz);
    EXIT;
   end;
  src := regcode;
  inc (regcode, sz);
  dst := regcode;
  while src > opnd do begin
    dec (dst);
    dec (src);
    dst^ := src^;
   end;
  place := opnd; // Op node, where operand used to be.
  place^ := op;
  for i := 2 to sz do begin //###0.90
    inc (place);
    place^ := #0;
   end;
 end; { of procedure TRegExpr.InsertOperator
--------------------------------------------------------------}

function strcspn (s1 : PChar; s2 : PChar) : integer;
// find length of initial segment of s1 consisting
// entirely of characters not from s2
 var scan1, scan2 : PChar;
 begin
  Result := 0;
  scan1 := s1;
  while scan1^ <> #0 do begin
    scan2 := s2;
    while scan2^ <> #0 do
     if scan1^ = scan2^
      then EXIT
      else inc (scan2);
    inc (Result);
    inc (scan1)
   end;
 end; { of function strcspn
--------------------------------------------------------------}

const
// Flags to be passed up and down.
 HASWIDTH =   01; // Known never to match nil string.
 SIMPLE   =   02; // Simple enough to be STAR/PLUS/BRACES operand.
 SPSTART  =   04; // Starts with * or +.
 WORST    =   0;  // Worst case.
 META : array [0 .. 12] of char = (
  '^', '$', '.', '[', '(', ')', '|', '?', '+', '*', '\', '{', #0); //###0.90

function TRegExpr.CompileRegExpr (exp : PChar) : boolean;
// compile a regular expression into internal code
// We can't allocate space until we know how big the compiled form will be,
// but we can't compile it (and thus know how big it is) until we've got a
// place to put the code.  So we cheat:  we compile it twice, once with code
// generation turned off and size counting turned on, and once "for real".
// This also means that we don't allocate space until we are sure that the
// thing really will compile successfully, and we never have to move the
// code and thus invalidate pointers into it.  (Note that it has to be in
// one piece because free() must be able to free it all.)
// Beware that the optimization-preparation code in here knows about some
// of the structure of the compiled regexp.
 var
  scan, longest : PChar;
  len : cardinal;
  flags : integer;
 begin
  Result := false; // life too dark
  fExprIsCompiled := false; //###0.90

  regparse := nil; //###0.90 // for correct error handling
  regexpbeg := exp; //###0.90
  try //###0.90 must clear regexpbeg after compilation

  if programm <> nil then begin
    FreeMem (programm);
    programm := nil;
   end;

  if exp = nil then begin
    Error (reeCompNullArgument);
    EXIT;
   end;

  fProgModifiers := fModifiers; // well, may it's paranoia. I'll check it later, now too late...

  // First pass: determine size, legality.
  fCompModifiers := fModifiers; //###0.90
  regparse := exp;
  regnpar := 1;
  regsize := 0;
  regcode := @regdummy;
  EmitC (MAGIC);
  if ParseReg (0, flags) = nil
   then EXIT;

  // Small enough for 2-bytes programm pointers ?
  if regsize >= 64 * 1024 then begin
    Error (reeCompRegexpTooBig);
    EXIT;
   end;

  // Allocate space.
  GetMem (programm, regsize);

  // Second pass: emit code.
  fCompModifiers := fModifiers; //###0.90
  regparse := exp;
  regnpar := 1;
  regcode := programm;
  EmitC (MAGIC);
  if ParseReg (0, flags) = nil
   then EXIT;

  // Dig out information for optimizations.
  regstart := #0; // Worst-case defaults.
  reganch := #0;
  regmust := nil;
  regmlen := 0;
  scan := programm + 1; // First BRANCH.
  if regnext (scan)^ = EEND then begin // Only one top-level choice.
    scan := scan + 3;

    // Starting-point info.
    if scan^ = EXACTLY
     then regstart := (scan + 3)^
     else if scan^ = BOL
           then inc (reganch);

    // If there's something expensive in the r.e., find the longest
    // literal string that must appear and make it the regmust.  Resolve
    // ties in favor of later strings, since the regstart check works
    // with the beginning of the r.e. and avoiding duplication
    // strengthens checking.  Not a strong reason, but sufficient in the
    // absence of others.
    if (flags and SPSTART) <> 0 then begin
        longest := nil;
        len := 0;
        while scan <> nil do begin
          if (scan^ = EXACTLY)
             and (strlen (scan + 3) >= len) then begin
              longest := scan + 3;
              len := strlen (scan + 3);
           end;
          scan := regnext (scan);
         end;
        regmust := longest;
        regmlen := len;
     end;
   end;

  finally regexpbeg := nil; //###0.90
  end; //###0.90

  fExprIsCompiled := true; //###0.90
  Result := true;
 end; { of function TRegExpr.CompileRegExpr
--------------------------------------------------------------}

function TRegExpr.ParseReg (paren : integer; var flagp : integer) : PChar;
// regular expression, i.e. main body or parenthesized thing
// Caller must absorb opening parenthesis.
// Combining parenthesis handling with the base level of regular expression
// is a trifle forced, but the need to tie the tails of the branches to what
// follows makes it hard to avoid.
 var
  ret, br, ender : PChar;
  parno : integer;
  flags : integer;
  SavedModifiers : integer;
 begin
  Result := nil;
  flagp := HASWIDTH; // Tentatively.
  parno := 0; // eliminate compiler stupid warning
  SavedModifiers := fCompModifiers; //###0.90

  // Make an OPEN node, if parenthesized.
  if paren <> 0 then begin
      if regnpar >= NSUBEXP then begin
        Error (reeCompParseRegTooManyBrackets);
        EXIT;
       end;
      parno := regnpar;
      inc (regnpar);
      ret := EmitNode (char (ord (OPEN) + parno));
    end
   else ret := nil;

  // Pick up the branches, linking them together.
  br := ParseBranch (flags);
  if br = nil then begin
    Result := nil;
    EXIT;
   end;
  if ret <> nil
   then Tail (ret, br) // OPEN -> first.
   else ret := br;
  if (flags and HASWIDTH) = 0
   then flagp := flagp and not HASWIDTH;
  flagp := flagp or flags and SPSTART;
  while (regparse^ = '|') do begin
    inc (regparse);
    br := ParseBranch (flags);
    if br = nil then begin
       Result := nil;
       EXIT;
      end;
    Tail (ret, br); // BRANCH -> BRANCH.
    if (flags and HASWIDTH) = 0
     then flagp := flagp and not HASWIDTH;
    flagp := flagp or flags and SPSTART;
   end;

  // Make a closing node, and hook it on the end.
  if paren <> 0
   then ender := EmitNode (char (ord (CLOSE) + parno))
   else ender := EmitNode (EEND);
  Tail (ret, ender);

  // Hook the tails of the branches to the closing node.
  br := ret;
  while br <> nil do begin
    OpTail (br, ender);
    br := regnext (br);
   end;

  // Check for proper termination.
  if paren <> 0 then
   if regparse^ <> ')' then begin
      Error (reeCompParseRegUnmatchedBrackets);
      EXIT; //###0.90
     end
    else inc (regparse); // skip trailing ')'
  if (paren = 0) and (regparse^ <> #0) then begin
      if regparse^ = ')'
       then Error (reeCompParseRegUnmatchedBrackets2)
       else Error (reeCompParseRegJunkOnEnd);
      EXIT;
    end;
  fCompModifiers := SavedModifiers; // restore modifiers of parent //###0.90
  Result := ret;
 end; { of function TRegExpr.ParseReg
--------------------------------------------------------------}

function TRegExpr.ParseBranch (var flagp : integer) : PChar;
// one alternative of an | operator
// Implements the concatenation operator.
 var
  ret, chain, latest : PChar;
  flags : integer;
 begin
  flagp := WORST; // Tentatively.

  ret := EmitNode (BRANCH);
  chain := nil;
  while (regparse^ <> #0) and (regparse^ <> '|')
        and (regparse^ <> ')') do begin
    latest := ParsePiece (flags);
    if latest = nil then begin
      Result := nil;
      EXIT;
     end;
    flagp := flagp or flags and HASWIDTH;
    if chain = nil // First piece.
     then flagp := flagp or flags and SPSTART
     else Tail (chain, latest);
    chain := latest;
   end;
  if chain = nil // Loop ran zero times.
   then EmitNode (NOTHING);
  Result := ret;
 end; { of function TRegExpr.ParseBranch
--------------------------------------------------------------}

function TRegExpr.ParsePiece (var flagp : integer) : PChar;
// something followed by possible [*+?{]
// Note that the branching code sequences used for ? and the general cases
// of * and + and { are somewhat optimized:  they use the same NOTHING node as
// both the endmarker for their branch list and the body of the last branch.
// It might seem that this node could be dispensed with entirely, but the
// endmarker role is not redundant.
 function parsenum (AStart, AEnd : PChar) : integer;
  begin
   Result := 0;
   if AEnd - AStart + 1 > 3 then begin
     Error (reeBRACESArgTooBig);
     EXIT;
    end;
   while AStart <= AEnd do
//    if not (AStart^ in ['0' .. '9']) then begin //###0.92
//       Error (reeBRACEBadArg);
//       EXIT;
//      end
//     else
    begin
       Result := Result * 10 + (ord (AStart^) - ord ('0'));
       inc (AStart);
      end;
   if Result > BracesMax then begin
     Error (reeBRACESArgTooBig);
     EXIT;
    end;
  end;
 var
  op : char;
  NextNode : PChar;
  flags : integer;
  min, max : integer;
  p, savedparse : PChar;
  {$IFDEF ComplexBraces}
  off : integer;
  {$ENDIF}
 begin
  Result := ParseAtom (flags);
  if Result = nil
   then EXIT;

  op := regparse^;
  if not ((op = '*') or (op = '+') or (op = '?') or (op = '{')) then begin //###0.90
    flagp := flags;
    EXIT;
   end;
  if ((flags and HASWIDTH) = 0) and (op <> '?') then begin
    Error (reePlusStarOperandCouldBeEmpty);
    EXIT;
   end;

  case op of //###0.92
    '*': begin
      flagp := WORST or SPSTART; //###0.92
      if (flags and SIMPLE) = 0 then begin
         // Emit x* as (x&|), where & means "self".
         InsertOperator (BRANCH, Result, 3); // Either x
         OpTail (Result, EmitNode (BACK)); // and loop
         OpTail (Result, Result); // back
         Tail (Result, EmitNode (BRANCH)); // or
         Tail (Result, EmitNode (NOTHING)); // nil.
        end
       else InsertOperator (STAR, Result, 3);
     end; { of case '*'}
    '+': begin
      flagp := WORST or SPSTART or HASWIDTH; //###0.92
      if (flags and SIMPLE) = 0 then begin
         // Emit x+ as x(&|), where & means "self".
         NextNode := EmitNode (BRANCH); // Either
         Tail (Result, NextNode);
         Tail (EmitNode (BACK), Result);    // loop back
         Tail (NextNode, EmitNode (BRANCH)); // or
         Tail (Result, EmitNode (NOTHING)); // nil.
        end
       else InsertOperator (PLUS, Result, 3);
     end; { of case '+'}
    '?': begin
      flagp := WORST; //###0.92
      // Emit x? as (x|)
      InsertOperator (BRANCH, Result, 3); // Either x
      Tail (Result, EmitNode (BRANCH));  // or
      NextNode := EmitNode (NOTHING); // nil.
      Tail (Result, NextNode);
      OpTail (Result, NextNode);
     end; { of case '?'}
   '{': begin //###0.90 begin
      savedparse := regparse;
      inc (regparse);
      p := regparse;
      while regparse^ in ['0' .. '9']  //###0.92 <min> must appear
       do inc (regparse);
      if (regparse^ <> '}') and (regparse^ <> ',') or (p = regparse) then begin //###0.92
        // Error (reeUmatchedBraces); //###0.92
        regparse := savedparse; //###0.92 - if any error - compile as nonmacro
        flagp := flags;
        EXIT;
       end;
      min := parsenum (p, regparse - 1);
      if regparse^ = ',' then begin
         inc (regparse);
         p := regparse;
         while regparse^ in ['0' .. '9'] //###0.92
          do inc (regparse);
         if regparse^ <> '}' then begin
           // Error (reeUmatchedBraces2); //###0.92
           regparse := savedparse;
           EXIT;
          end;
         if p = regparse //###0.92
          then max := BracesMax
          else max := parsenum (p, regparse - 1);
        end
       else max := min; // {n} == {n,n}
      if min > max then begin
        Error (reeBracesMinParamGreaterMax);
        EXIT;
       end;
      if min > 0 //###0.92
       then flagp := WORST;
      if max > 0 //###0.92
       then flagp := flagp or HASWIDTH or SPSTART;
      if (flags and SIMPLE) <> 0 then begin
         InsertOperator (BRACES, Result, 5);
         if regcode <> @regdummy then begin
           (Result + 3)^ := char (min);
           (Result + 4)^ := char (max);
          end;
        end
       else begin // Emit complex x{min,max}
         {$IFNDEF ComplexBraces}
         Error (reeComplexBracesNotImplemented); //###0.925
         EXIT;
         {$ELSE}
         InsertOperator (LOOPENTRY, Result, 3);
         NextNode := EmitNode (LOOP);
         if regcode <> @regdummy then begin
            off := regcode - 3 - (Result + 3); // back to Atom after LOOPENTRY
            regcode^ := char (min);
            inc (regcode);
            regcode^ := char (max);
            inc (regcode);
            regcode^ := Char ((off ShR 8) and $FF);
            inc (regcode);
            regcode^ := Char (off and $FF);
            inc (regcode);
           end
          else inc (regsize, 4);
         Tail (Result, NextNode); // LOOPENTRY -> LOOP
         if regcode <> @regdummy then
          Tail (Result + 3, NextNode); // Atom -> LOOP
         {$ENDIF}
        end;
     end; { of case '{'}
    //###0.90 end
//    else // here we can't be
   end; { of case op}

  inc (regparse);
  if (regparse^ = '*') or (regparse^ = '+') or (regparse^ = '?') or (regparse^ = '{') then begin //###0.90
    Error (reeNestedSQP);
    EXIT;
   end;
 end; { of function TRegExpr.ParsePiece
--------------------------------------------------------------}

function TRegExpr.ParseAtom (var flagp : integer) : PChar;
// the lowest level
// Optimization:  gobbles an entire sequence of ordinary characters so that
// it can turn them into a single node, which is smaller to store and
// faster to run.  Backslashed characters are exceptions, each becoming a
// separate node; the code is simpler that way and it's not worth fixing.
 var
  ret : PChar;
  flags : integer;
  RangeBeg, RangeEnd : char;
  len : integer;
  ender : char;
  n : integer;
  begmodfs : PChar;
 procedure EmitExactly (ch : char);
  begin
   if (fCompModifiers and MaskModI) = MaskModI //###0.90
    then ret := EmitNode (EXACTLYCI)
    else ret := EmitNode (EXACTLY);
   EmitC (ch);
   EmitC (#0);
   flagp := flagp or HASWIDTH or SIMPLE;
  end;
 procedure EmitStr (const s : string);
  var i : integer;
  begin
   for i := 1 to length (s)
    do EmitC (s [i]);
  end;
 function HexDig (ch : char) : integer;
  begin
   Result := 0;
   if (ch >= 'a') and (ch <= 'f')
    then ch := char (ord (ch) - (ord ('a') - ord ('A')));
   if (ch < '0') or (ch > 'F') or ((ch > '9') and (ch < 'A')) then begin
     Error (reeBadHexDigit);
     EXIT;
    end;
   Result := ord (ch) - ord ('0');
   if ch >= 'A'
    then Result := Result - (ord ('A') - ord ('9') - 1);
  end;
 begin
  Result := nil;
  flagp := WORST; // Tentatively.

  inc (regparse);
  case (regparse - 1)^ of
    '^': ret := EmitNode (BOL);
    '$': ret := EmitNode (EOL);
    '.':
       if (fCompModifiers and MaskModS) = MaskModS then begin //###0.926
          ret := EmitNode (ANY);
          flagp := flagp or HASWIDTH or SIMPLE;
         end
        else begin // not /s, so emit [^\n]
          ret := EmitNode (ANYBUT);
          EmitC (#$a);
          EmitC (#0);
          flagp := flagp or HASWIDTH or SIMPLE;
         end;
    '[': begin
            if regparse^ = '^' then begin // Complement of range.
               if (fCompModifiers and MaskModI) = MaskModI //###0.92
                then ret := EmitNode (ANYBUTCI)
                else ret := EmitNode (ANYBUT);
               inc (regparse);
              end
             else
              if (fCompModifiers and MaskModI) = MaskModI //###0.92
               then ret := EmitNode (ANYOFCI)
               else ret := EmitNode (ANYOF);

            if (regparse^ = ']') or (regparse^ = '-') then begin
              EmitC (regparse^);
              inc (regparse);
             end;
            while (regparse^ <> #0) and (regparse^ <> ']') do begin
                if regparse^ = '-' then begin
                   inc (regparse);
                   if (regparse^ = ']') or (regparse^ = #0)
                    then EmitC ('-')
                    else begin
                      RangeBeg := (regparse - 2)^;
                      RangeEnd := regparse^;

                      // r.e.ranges extension for russian
                      if ((fCompModifiers and MaskModR) = MaskModR)
                         and (RangeBeg = 'à') and (RangeEnd = 'ÿ') then begin
                        EmitStr ('àáâãäå¸æçèéêëìíîïðñòóôõö÷øùúûüýþÿ');
                       end
                      else if ((fCompModifiers and MaskModR) = MaskModR)
                          and (RangeBeg = 'À') and (RangeEnd = 'ß') then begin
                        EmitStr ('ÀÁÂÃÄÅ¨ÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß');
                       end
                      else if ((fCompModifiers and MaskModR) = MaskModR)
                           and (RangeBeg = 'à') and (RangeEnd = 'ß') then begin
                        EmitStr ('àáâãäå¸æçèéêëìíîïðñòóôõö÷øùúûüýþÿ');
                        EmitStr ('ÀÁÂÃÄÅ¨ÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß');
                       end
                      else begin // standard r.e. handling
                        if RangeBeg > RangeEnd then begin
                          Error (reeInvalidRange);
                          EXIT;
                         end;
                        inc (RangeBeg);
                        while RangeBeg <= RangeEnd do begin
                          EmitC (RangeBeg);
                          inc (RangeBeg);
                         end;
                       end;
                      inc (regparse);
                     end;
                  end
                 else begin
                   if regparse^ = '\' then begin
                      inc (regparse);
                      if regparse^ = #0 then begin
                        Error (reeParseAtomTrailingBackSlash);
                        EXIT;
                       end;
                      case regparse^ of // r.e.extensions
                        'd': EmitStr ('0123456789');
                        'w': EmitStr ('abcdefghijklmnopqrstuvwxyz'
                              + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ_');
                        't': EmitC (#$9);  // tab (HT/TAB)
                        'n': EmitC (#$a);  // newline (NL)
                        'r': EmitC (#$d);  // car.return (CR)
                        'f': EmitC (#$c);  // form feed (FF)     //###0.8
                        'a': EmitC (#$7);  // alarm (bell) (BEL) //###0.8
                        'e': EmitC (#$1b); // escape (ESC)
                        'x': begin // hex char
                              inc (regparse);
                              if regparse^ = #0 then begin
                                Error (reeNoHexCodeAfterBSlashX);
                                EXIT;
                               end;
                              n := HexDig (regparse^);
                              inc (regparse);
                              if regparse^ = #0 then begin
                                Error (reeNoHexCodeAfterBSlashX2);
                                EXIT;
                               end;
                              n := (n ShL 4) or HexDig (regparse^);
                              EmitC (char (n)); // r.e.extension
                          end;
                        else EmitC (regparse^);
                       end; { of case}
                     end
                    else begin
                      EmitC (regparse^);
                     end;
                   inc (regparse);
                  end;
             end; { of while}
            EmitC (#0);
            if regparse^ <> ']' then begin
              Error (reeUnmatchedSqBrackets);
              EXIT;
             end;
            inc (regparse);
            flagp := flagp or HASWIDTH or SIMPLE;
      end;
    '(': begin
        if regparse^ = '?' then begin //###0.90
           // check for extended Perl syntax : (?..)
           if (regparse + 1)^ = '#' then begin // (?#comment)
              inc (regparse, 2); // find closing ')'
              while (regparse^ <> #0) and (regparse^ <> ')')
               do inc (regparse);
              if regparse^ <> ')' then begin
                Error (reeUnclosedComment);
                EXIT;
               end;
              inc (regparse); // skip ')'
              ret := EmitNode (COMMENT); // comment
             end
           else begin // modifiers ?
             inc (regparse); // skip '?'
             begmodfs := regparse;
             while (regparse^ <> #0) and (regparse^ <> ')')
              do inc (regparse);
             if (regparse^ <> ')')
                or not SetModifiersInt (copy (begmodfs, 1, (regparse - begmodfs)), fCompModifiers) then begin
               Error (reeUrecognizedModifier);
               EXIT;
              end;
             inc (regparse); // skip ')'
             ret := EmitNode (COMMENT); // comment
//             Error (reeQPSBFollowsNothing);
//             EXIT;
            end;
          end
         else begin
           ret := ParseReg (1, flags);
           if ret = nil then begin
             Result := nil;
             EXIT;
            end;
           flagp := flagp or flags and (HASWIDTH or SPSTART);
          end;
      end;
    #0, '|', ')': begin // Supposed to be caught earlier.
       Error (reeInternalUrp);
       EXIT;
      end;
    '?', '+', '*': begin //###0.92
       Error (reeQPSBFollowsNothing);
       EXIT;
      end;
    '\': begin
        if regparse^ = #0 then begin
          Error (reeTrailingBackSlash);
          EXIT;
         end;
        case regparse^ of // r.e.extensions
          'd': begin // r.e.extension - any digit ('0' .. '9')
             ret := EmitNode (ANYDIGIT);
             flagp := flagp or HASWIDTH or SIMPLE;
            end;
          's': begin // r.e.extension - any space char //###0.8
             ret := EmitNode (ANYSPACE);
             flagp := flagp or HASWIDTH or SIMPLE;
            end;
          'w': begin // r.e.extension - any english char or '_'
             ret := EmitNode (ANYLETTER);
             flagp := flagp or HASWIDTH or SIMPLE;
            end;
          'D': begin // r.e.extension - not digit ('0' .. '9')
             ret := EmitNode (NOTDIGIT);
             flagp := flagp or HASWIDTH or SIMPLE;
            end;
          'S': begin // r.e.extension - not space char //###0.8
             ret := EmitNode (NOTSPACE);
             flagp := flagp or HASWIDTH or SIMPLE;
            end;
          'W': begin // r.e.extension - not english char or '_'
             ret := EmitNode (NOTLETTER);
             flagp := flagp or HASWIDTH or SIMPLE;
            end;
          't': EmitC (#$9);  // tab (HT/TAB)
          'n': EmitC (#$a);  // newline (NL)
          'r': EmitC (#$d);  // car.return (CR)
          'f': EmitC (#$c);  // form feed (FF)     //###0.8
          'a': EmitC (#$7);  // alarm (bell) (BEL) //###0.8
          'e': EmitC (#$1b); // escape (ESC)
          'x': begin
             inc (regparse);
             if regparse^ = #0 then begin
               Error (reeNoHexCodeAfterBSlashX3);
               EXIT;
              end;
             n := HexDig (regparse^);
             inc (regparse);
             if regparse^ = #0 then begin
               Error (reeNoHexCodeAfterBSlashX4);
               EXIT;
              end;
             n := (n ShL 4) or HexDig (regparse^);
             EmitExactly (char (n)); // r.e.extension
            end;
          else begin
            EmitExactly (regparse^);
            //ret := EmitNode (EXACTLY);
            //EmitC (regparse^);
            //EmitC (#0);
            //flagp := flagp or HASWIDTH or SIMPLE;
           end;
         end; { of case}
        inc (regparse);
      end;
    else begin
        dec (regparse);
        len := strcspn (regparse, META);
        if len <= 0 then //###0.92
         if regparse^ <> '{' then begin
            Error (reeRarseAtomInternalDisaster);
            EXIT;
           end
          else len := strcspn (regparse + 1, META) + 1; // bad {n,m} - compile as EXATLY
        ender := (regparse + len)^;
        if (len > 1)
           and ((ender = '*') or (ender = '+') or (ender = '?') or (ender = '{')) //###0.90
         then dec (len); // Back off clear of ?+*{ operand.
        flagp := flagp or HASWIDTH;
        if len = 1
         then flagp := flagp or SIMPLE;
        if (fCompModifiers and MaskModI) = MaskModI
         then ret := EmitNode (EXACTLYCI) //###0.90
         else ret := EmitNode (EXACTLY);
        while len > 0 do begin
          EmitC (regparse^);
          inc (regparse);
          dec (len);
         end;
        EmitC (#0);
      end; { of case else}
   end; { of case}

  Result := ret;
 end; { of function TRegExpr.ParseAtom
--------------------------------------------------------------}

function TRegExpr.GetCompilerErrorPos : integer; //###0.90
 begin
  Result := 0;
  if (regexpbeg = nil) or (regparse = nil)
   then EXIT; // not in compiling mode ?
  Result := regparse - regexpbeg;
 end; { of function TRegExpr.GetCompilerErrorPos
--------------------------------------------------------------}


{=============================================================}
{===================== Matching section ======================}
{=============================================================}

function StrScanCI (s : PChar; ch : char) : PChar;
 begin
  while (s^ <> #0) and (AnsiUpperCase (s^) <> AnsiUpperCase (ch))
   do inc (s);
  if s^ <> #0
   then Result := s
   else Result := nil;
 end; { of function StrScanCI
--------------------------------------------------------------}

function TRegExpr.regrepeat (p : PChar; AMax : integer) : integer;
// repeatedly match something simple, report how many
//###0.92 slightly optimized - AMax added, now can proceed pascal-
// -style strings (with #0)
 var
  scan : PChar;
  opnd : PChar;
  TheMax : integer; //###0.92
 begin
  Result := 0;
  scan := reginput;
  opnd := p + 3; //OPERAND
  TheMax := regeol - scan; //###0.92
  if TheMax > AMax
   then TheMax := AMax;
  case p^ of
    ANY: begin
      Result := TheMax; //###0.92
      inc (scan, Result);
     end;
    EXACTLY:
      while (Result < TheMax) and (opnd^ = scan^) do begin //###0.92
        inc (Result);
        inc (scan);
       end;
    EXACTLYCI: //###0.90
      while (Result < TheMax) and //###0.92
            (UpperCase (opnd^) = UpperCase (scan^)) do begin
        inc (Result);
        inc (scan);
       end;
    ANYLETTER:
      while (Result < TheMax) and //###0.92
       ((scan^ >= 'a') and (scan^ <= 'z')
       or (scan^ >= 'A') and (scan^ <= 'Z') or (scan^ = '_')) do begin
        inc (Result);
        inc (scan);
       end;
    NOTLETTER:
      while (Result < TheMax) and //###0.92
        not ((scan^ >= 'a') and (scan^ <= 'z')
         or (scan^ >= 'A') and (scan^ <= 'Z')
         or (scan^ = '_')) do begin
        inc (Result);
        inc (scan);
       end;
    ANYDIGIT:
      while (Result < TheMax) and //###0.92
         (scan^ >= '0') and (scan^ <= '9') do begin
        inc (Result);
        inc (scan);
       end;
    NOTDIGIT:
      while (Result < TheMax) and //###0.92
         ((scan^ < '0') or (scan^ > '9')) do begin
        inc (Result);
        inc (scan);
       end;
    ANYSPACE: //###0.8
      while (Result < TheMax) and //###0.92
         (scan^ in RegExprSpaceCharSet) do begin
        inc (Result);
        inc (scan);
       end;
    NOTSPACE: //###0.8
      while (Result < TheMax) and //###0.92
         not (scan^ in RegExprSpaceCharSet) do begin
        inc (Result);
        inc (scan);
       end;
    ANYOF:
      while (Result < TheMax) and //###0.92
         (StrScan (opnd, scan^) <> nil) do begin
        inc (Result);
        inc (scan);
       end;
    ANYBUT:
      while (Result < TheMax) and //###0.92
         (StrScan (opnd, scan^) = nil) do begin
        inc (Result);
        inc (scan);
       end;
    ANYOFCI: //###0.92
      while (Result < TheMax) and (StrScanCI (opnd, scan^) <> nil) do begin
        inc (Result);
        inc (scan);
       end;
    ANYBUTCI: //###0.92
      while (Result < TheMax) and (StrScanCI (opnd, scan^) = nil) do begin
        inc (Result);
        inc (scan);
       end;
    else begin // Oh dear.  Called inappropriately.
      Result := 0; // Best compromise.
      Error (reeRegRepeatCalledInappropriately);
      EXIT;
     end;
   end; { of case}
  reginput := scan;
 end; { of function TRegExpr.regrepeat
--------------------------------------------------------------}

function TRegExpr.regnext (p : PChar) : PChar;
// dig the "next" pointer out of a node
 var offset : integer;
 begin
  Result := nil;
  if p = @regdummy
   then EXIT;

  offset := NEXT (p);
  if offset = 0
   then EXIT;

  if p^ = BACK
   then Result := p - offset
   else Result := p + offset;
 end; { of function TRegExpr.regnext
--------------------------------------------------------------}

function TRegExpr.MatchPrim (prog : PChar) : boolean;
// recursively matching routine
// Conceptually the strategy is simple:  check to see whether the current
// node matches, call self recursively to see whether the rest matches,
// and then act accordingly.  In practice we make some effort to avoid
// recursion, in particular by going through "ordinary" nodes (that don't
// need to know whether the rest of the match failed) by a loop instead of
// by recursion.
 var
  scan : PChar; // Current node.
  next : PChar; // Next node.
  len : integer;
  opnd : PChar;
  no : integer;
  save : PChar;
  nextch : char;
  min, max : integer;
  {$IFDEF ComplexBraces}
  SavedLoopStack : array [1 .. LoopStackMax] of integer; // :(( very bad for recursion //###0.925
  SavedLoopStackIdx : integer; //###0.925
  {$ENDIF}
 begin
  Result := false;
  scan := prog;

  while scan <> nil do begin
     next := regnext (scan);
     case scan^ of
         BOL: if reginput <> regbol
               then EXIT;
         EOL: if reginput^ <> #0
               then EXIT;
         ANY: begin
            if reginput^ = #0
             then EXIT;
            inc (reginput);
           end;
         ANYLETTER: begin
            if (reginput^ = #0) or
             not ((reginput^ >= 'a') and (reginput^ <= 'z')
                 or (reginput^ >= 'A') and (reginput^ <= 'Z')
                 or (reginput^ = '_'))
             then EXIT;
            inc (reginput);
           end;
         NOTLETTER: begin
            if (reginput^ = #0) or
               (reginput^ >= 'a') and (reginput^ <= 'z')
                 or (reginput^ >= 'A') and (reginput^ <= 'Z')
                 or (reginput^ = '_')
             then EXIT;
            inc (reginput);
           end;
         ANYDIGIT: begin
            if (reginput^ = #0) or (reginput^ < '0') or (reginput^ > '9')
             then EXIT;
            inc (reginput);
           end;
         NOTDIGIT: begin
            if (reginput^ = #0) or ((reginput^ >= '0') and (reginput^ <= '9'))
             then EXIT;
            inc (reginput);
           end;
         ANYSPACE: begin //###0.8
            if (reginput^ = #0) or not (reginput^ in RegExprSpaceCharSet)
             then EXIT;
            inc (reginput);
           end;
         NOTSPACE: begin //###0.8
            if (reginput^ = #0) or (reginput^ in RegExprSpaceCharSet)
             then EXIT;
            inc (reginput);
           end;
         EXACTLYCI: begin //###0.90
            opnd := scan + 3; // OPERAND
            // Inline the first character, for speed.
            if UpperCase (opnd^) <> UpperCase (reginput^)
             then EXIT;
            len := strlen (opnd);
            if (len > 1) and (StrLIComp (opnd, reginput, len) <> 0)
             then EXIT;
            inc (reginput, len);
           end;
         EXACTLY: begin
            opnd := scan + 3; // OPERAND
            // Inline the first character, for speed.
            if opnd^ <> reginput^
             then EXIT;
            len := strlen (opnd);
            if (len > 1) and (StrLComp (opnd, reginput, len) <> 0)
             then EXIT;
            inc (reginput, len);
           end;
         ANYOF: begin
            if (reginput^ = #0) or (StrScan (scan + 3, reginput^) = nil)
             then EXIT;
            inc (reginput);
           end;
         ANYBUT: begin
            if (reginput^ = #0) or (StrScan (scan + 3, reginput^) <> nil)
             then EXIT; //###0.7 was skipped (found by Jan Korycan)
            inc (reginput);
           end;
         ANYOFCI: begin //###0.92
            if (reginput^ = #0) or (StrScanCI (scan + 3, reginput^) = nil)
             then EXIT;
            inc (reginput);
           end;
         ANYBUTCI: begin //###0.92
            if (reginput^ = #0) or (StrScanCI (scan + 3, reginput^) <> nil)
             then EXIT;
            inc (reginput);
           end;
         NOTHING: ;
         COMMENT: ; //###0.90
         BACK: ;
         Succ (OPEN) .. Char (Ord (OPEN) + 9) : begin
            no := ord (scan^) - ord (OPEN);
            save := reginput;
            Result := MatchPrim (next);
            if Result and (startp [no] = nil)
             then startp [no] := save;
             // Don't set startp if some later invocation of the same
             // parentheses already has.
            EXIT;
           end;
         Succ (CLOSE) .. Char (Ord (CLOSE) + 9): begin
            no := ord (scan^) - ord (CLOSE);
            save := reginput;
            Result := MatchPrim (next);
            if Result and (endp [no] = nil)
             then endp [no] := save;
             // Don't set endp if some later invocation of the same
             // parentheses already has.
            EXIT;
           end;
         BRANCH: begin
            if (next^ <> BRANCH) // No choice.
             then next := scan + 3 // Avoid recursion.
             else begin
               REPEAT
                save := reginput;
                Result := MatchPrim (scan + 3);
                if Result
                 then EXIT;
                reginput := save;
                scan := regnext(scan);
               UNTIL (scan = nil) or (scan^ <> BRANCH);
               EXIT;
              end;
           end;
         {$IFDEF ComplexBraces}
         LOOPENTRY: begin //###0.925
           no := LoopStackIdx;
           inc (LoopStackIdx);
           if LoopStackIdx > LoopStackMax then begin
             Error (reeLoopStackExceeded);
             EXIT;
            end;
           save := reginput;
           LoopStack [LoopStackIdx] := 0; // init loop counter
           Result := MatchPrim (next); // execute LOOP
           LoopStackIdx := no; // cleanup
           if Result
            then EXIT;
           reginput := save;
           EXIT;
          end;
         LOOP: begin //###0.925
           if LoopStackIdx <= 0 then begin
             Error (reeLoopWithoutEntry);
             EXIT;
            end;
           opnd := scan - (ord ((scan + 5)^) * 256 + ord ((scan + 6)^));
           min := ord ((scan + 3)^);
           max := ord ((scan + 4)^);
           save := reginput;
           if LoopStack [LoopStackIdx] >= min then begin
              // greedy way ;)
              if LoopStack [LoopStackIdx] < max then begin
                inc (LoopStack [LoopStackIdx]);
                no := LoopStackIdx;
                Result := MatchPrim (opnd);
                LoopStackIdx := no;
                if Result
                 then EXIT;
                reginput := save;
               end;
              dec (LoopStackIdx);
              Result := MatchPrim (next);
              if not Result
               then reginput := save;
              EXIT;
             end
            else begin // first match a min times
              inc (LoopStack [LoopStackIdx]);
              no := LoopStackIdx;
              Result := MatchPrim (opnd);
              LoopStackIdx := no;
              if Result
               then EXIT;
              dec (LoopStack [LoopStackIdx]);
              reginput := save;
              EXIT;
             end;
          end;
         {$ENDIF} 
         STAR, PLUS, BRACES: begin //###0.90
                // Lookahead to avoid useless match attempts when we know
                // what character comes next.
                nextch := #0;
                if next^ = EXACTLY
                 then nextch := (next + 3)^;
                max := MaxInt; // infinite loop for * and + //###0.92
                if scan^ = STAR
                 then min := 0  // STAR
                 else if scan^ = PLUS
                  then min := 1 // PLUS
                  else begin // BRACES //###0.90
                    min := ord ((scan + 3)^);
                    max := ord ((scan + 4)^);
                   end;
                save := reginput;
                //###0.90 begin
                opnd := scan + 3;
                if scan^ = BRACES
                 then inc (opnd, 2);
                no := regrepeat (opnd, max); //###0.92 don't repeat more than max
                //###0.90 end
                while no >= min do begin
                  // If it could work, try it.
                  if (nextch = #0) or (reginput^ = nextch) then begin
                    {$IFDEF ComplexBraces}
                    System.Move (LoopStack, SavedLoopStack, SizeOf (LoopStack)); //###0.925
                    SavedLoopStackIdx := LoopStackIdx;
                    {$ENDIF}
                    if MatchPrim (next) then begin
                      Result := true;
                      EXIT;
                     end;
                    {$IFDEF ComplexBraces}
                    System.Move (SavedLoopStack, LoopStack, SizeOf (LoopStack));
                    LoopStackIdx := SavedLoopStackIdx;
                    {$ENDIF}
                   end;
                  dec (no); // Couldn't or didn't - back up.
                  reginput := save + no;
                 end; { of while}
                EXIT;
           end;
         EEND: begin
            Result := true;  // Success!
            EXIT;
           end;
        else begin
            Error (reeMatchPrimMemoryCorruption);
            EXIT;
          end;
        end; { of case scan^}
        scan := next;
    end; { of while scan <> nil}

  // We get here only if there's trouble -- normally "case EEND" is the
  // terminating point.
  Error (reeMatchPrimCorruptedPointers);
 end; { of function TRegExpr.MatchPrim
--------------------------------------------------------------}

function TRegExpr.RegMatch (str : PChar) : boolean;
// try match at specific point
 var i : integer;
 begin
  for i := 0 to NSUBEXP - 1 do begin
    startp [i] := nil;
    endp [i] := nil;
   end;
  reginput := str;
  Result := MatchPrim (programm + 1);
  if Result then begin
    startp [0] := str;
    endp [0] := reginput;
//    startp [1] := nil //###0.4 bugfix by Stephan Klimek
   end;
 end; { of function TRegExpr.RegMatch
--------------------------------------------------------------}

//###0.90 begin
function TRegExpr.Exec (const AInputString : string) : boolean; //###0.81 added Offset
 begin
  InputString := AInputString;
  Result := ExecPrim (1);
 end; { of function TRegExpr.Exec
--------------------------------------------------------------}

function TRegExpr.ExecPrim (AOffset: integer) : boolean; //###0.90
 var
  s : PChar;
  StartPtr: PChar; //###0.81 Starting point for search
  InputLen : integer; //###0.92
 begin
  Result := false; // Be paranoid...

  // Check compiled r.e. presence
  if programm = nil then begin
    Error (reeNoExpression);
    EXIT;
   end;

  // Check validity of program.
  if programm [0] <> MAGIC then begin
    Error (reeCorruptedProgram);
    EXIT;
   end;

  // Exit if previous compilation was finished with error
  if not fExprIsCompiled then begin //###0.90
    Error (reeExecAfterCompErr);
    EXIT;
   end;

  // Check InputString presence
  if not Assigned (fInputString) then begin //###0.90
    Error (reeNoInpitStringSpecified);
    EXIT;
   end;

  InputLen := length (fInputString); //###0.92

  //###0.81 Start
  //Check that the start position is not negative
  if AOffset < 1 then begin
    Error (reeOffsetMustBeGreaterThen0);
    EXIT;
   end;
  // Check that the start position is not longer than the line
  // If so then exit with nothing found
  if AOffset > (InputLen + 1) //###0.90 - for matching
   then EXIT;                 // empty string after last char.
  //###0.81 End

  StartPtr := fInputString + AOffset - 1; //###0.81

  // If there is a "must appear" string, look for it.
  if regmust <> nil then begin
    // s := fInputString; //###0.81
    s := StartPtr; //###0.81
    REPEAT
     s := StrScan (s, regmust [0]);
     if s <> nil then begin
       if StrLComp (s, regmust, regmlen) = 0
        then BREAK; // Found it.
       inc (s);
      end;
    UNTIL s = nil;
    if s = nil // Not present.
     then EXIT;
   end;
  // Mark beginning of line for ^ .
  regbol := fInputString;

  // Pointer to end of input stream - for
  // pascal-style string processing (may include #0)
  regeol := fInputString + InputLen;

  {$IFDEF ComplexBraces}
  // no loops started
  LoopStackIdx := 0; //###0.925
  {$ENDIF}

  // Simplest case:  anchored match need be tried only once.
  if reganch <> #0 then begin
    // Result := RegMatch (fInputString); //###0.81
    Result := RegMatch (StartPtr); //###0.81
    EXIT;
   end;

  // Messy cases:  unanchored match.
  // s := fInputString; //###0.81
  s := StartPtr; //###0.81
  if regstart <> #0 then // We know what char it must start with.
    REPEAT
     s := StrScan (s, regstart);
     if s <> nil then begin
       Result := RegMatch (s);
       if Result
        then EXIT;
       inc (s);
      end;
    UNTIL s = nil
   else // We don't - general case.
    REPEAT
     Result := RegMatch (s);
     if Result
      then EXIT;
     inc (s);
    UNTIL s^ = #0;
  // Failure
 end; { of function TRegExpr.ExecPrim
--------------------------------------------------------------}

function TRegExpr.ExecNext : boolean; //###0.90
 var offset : integer;
 begin
  Result := false;
  if not Assigned (startp[0]) or not Assigned (endp[0]) then begin
    Error (reeExecNextWithoutExec);
    EXIT;
   end;
  Offset := MatchPos [0] + MatchLen [0];
  if MatchLen [0] = 0 // prevent infinite looping - thanks Jon Smith
   then inc (Offset);
  Result := ExecPrim (Offset);
 end; { of function TRegExpr.ExecNext
--------------------------------------------------------------}

function TRegExpr.ExecPos (AOffset: integer {$IFDEF D4_}= 1{$ENDIF}) : boolean; //###0.90
 begin
  Result := ExecPrim (AOffset);
 end; { of function TRegExpr.ExecPos
--------------------------------------------------------------}

function TRegExpr.GetInputString : string; //###0.90
 begin
  if not Assigned (fInputString) then begin
    Error (reeGetInputStringWithoutInputString);
    EXIT;
   end;
  Result := fInputString;
 end; { of function TRegExpr.GetInputString
--------------------------------------------------------------}

procedure TRegExpr.SetInputString (const AInputString : string); //###0.90
 var
  Len : integer;
  i : integer;
 begin
  // clear Match* - before next Exec* call it's undefined
  for i := 0 to NSUBEXP - 1 do begin
    startp [i] := nil;
    endp [i] := nil;
   end;

  // need reallocation of input string buffer ?
  Len := length (AInputString);
  if Assigned (fInputString) and (Length (fInputString) <> Len) then begin
    FreeMem (fInputString);
    fInputString := nil;
   end;
  // buffer [re]allocation
  if not Assigned (fInputString)
   then GetMem (fInputString, Len + 1);

  // copy input string into buffer
  StrLCopy (fInputString, PChar (AInputString), Len);
 end; { of procedure TRegExpr.SetInputString
--------------------------------------------------------------}
//###0.90 end

function TRegExpr.Substitute (const ATemplate : string) : string;
// perform substitutions after a regexp match
 var
  src : PChar;
  c : char;
  no : integer;
 begin
  Result := '';

  if programm = nil then begin
    Error (reeSubstNoExpression);
    EXIT;
  end;
  // Check validity of program.
  if programm [0] <> MAGIC then begin
    Error (reeSubstCorruptedProgramm);
    EXIT;
   end;
  // Exit if previous compilation was finished with error
  if not fExprIsCompiled then begin //###0.90
    Error (reeExecAfterCompErr);
    EXIT;
   end;

  src := PChar (ATemplate);
  while src^ <> #0 do begin
    c := src^;
    inc (src);
    if c = '&'
     then no := 0
     else if (c = '\') and ('0' <= src^) and (src^ <= '9')
	   then begin
              no := ord (src^) - ord ('0');
              inc (src);
             end
	   else no := -1;

    if no < 0 then begin // Ordinary character.
       if (c = '\') and ((src^ = '\') or (src^ = '&')) then begin
         c := src^;
         inc (src);
        end;
       Result := Result + c;
      end
     else Result := Result + Match [no]; //###0.90
   end;
 end; { of function TRegExpr.Substitute
--------------------------------------------------------------}

procedure TRegExpr.Split (AInputStr : string; APieces : TStrings);
 var PrevPos : integer; //###0.90 optimized (Exec-ExecNext)
var
  lstr:string;
  lPos,
  lLen:integer;

 begin
  PrevPos := 1;
  if Exec (AInputStr) then
   REPEAT
    lstr:=System.Copy (AInputStr, PrevPos, MatchPos [0] - PrevPos);
    if length(lstr)>0 then
      APieces.Add(lstr);
//    APieces.Add (System.Copy (AInputStr, PrevPos, MatchPos [0] - PrevPos));
    PrevPos := MatchPos [0] + MatchLen [0];
   UNTIL not ExecNext;
  APieces.Add (System.Copy (AInputStr, PrevPos, MaxInt)); // Tail
 end; { of procedure TRegExpr.Split
--------------------------------------------------------------}

function TRegExpr.Replace (AInputStr : string; const AReplaceStr : string) : string;
 var PrevPos : integer; //###0.90 optimized (Exec-ExecNext)
 begin
  Result := '';
  PrevPos := 1;
  if Exec (AInputStr) then
   REPEAT
    Result := Result + System.Copy (AInputStr, PrevPos,
      MatchPos [0] - PrevPos) + AReplaceStr;
    PrevPos := MatchPos [0] + MatchLen [0];
   UNTIL not ExecNext;
  Result := Result + System.Copy (AInputStr, PrevPos, MaxInt); // Tail
 end; { of function TRegExpr.Replace
--------------------------------------------------------------}


{=============================================================}
{====================== Debug section ========================}
{=============================================================}

{$IFDEF DebugRegExpr}
function TRegExpr.DumpOp (op : char) : string;
// printable representation of opcode
 begin
  case op of
    BOL:     Result := 'BOL';
    EOL:     Result := 'EOL';
    ANY:     Result := 'ANY';
    ANYLETTER:Result := 'ANYLETTER';
    NOTLETTER:Result := 'NOTLETTER';
    ANYDIGIT:Result := 'ANYDIGIT';
    NOTDIGIT:Result := 'NOTDIGIT';
    ANYSPACE:Result := 'ANYSPACE';
    NOTSPACE:Result := 'NOTSPACE';
    ANYOF:   Result := 'ANYOF';
    ANYBUT:  Result := 'ANYBUT';
    ANYOFCI:   Result := 'ANYOF/CI'; //###0.92
    ANYBUTCI:  Result := 'ANYBUT/CI'; //###0.92
    BRANCH:  Result := 'BRANCH';
    EXACTLY: Result := 'EXACTLY';
    EXACTLYCI:Result := 'EXACTLY/CI';
    NOTHING: Result := 'NOTHING';
    COMMENT: Result := 'COMMENT'; //###0.90
    BACK:    Result := 'BACK';
    EEND:    Result := 'END';
    Succ (OPEN) .. Char (Ord (OPEN) + 9):
      Result := Format ('OPEN%d', [ord (op) - ord (OPEN)]);
    Succ (CLOSE) .. Char (Ord (CLOSE) + 9):
      Result := Format ('CLOSE%d', [ord (op) - ord (CLOSE)]);
    STAR:    Result := 'STAR';
    PLUS:    Result := 'PLUS';
    BRACES:  Result := 'BRACES'; //###0.90
    {$IFDEF ComplexBraces}
    LOOPENTRY: Result := 'LOOPENTRY'; //###0.925
    LOOP: Result := 'LOOP'; //###0.925
    {$ENDIF}
    else Error (reeDumpCorruptedOpcode);
   end; {of case op}
  Result := ':' + Result;
 end; { of function TRegExpr.DumpOp
--------------------------------------------------------------}

function TRegExpr.Dump : string;
// dump a regexp in vaguely comprehensible form
 var
  s : PChar;
  op : char; // Arbitrary non-END op.
  next : PChar;
 begin
  // Check compiled r.e. presence
  if programm = nil then begin //###0.90
    Error (reeNoExpression);
    EXIT;
   end;

  // Check validity of program.
  if programm [0] <> MAGIC then begin //###0.90
    Error (reeCorruptedProgram);
    EXIT;
   end;

  // Exit if previous compilation was finished with error
  if not fExprIsCompiled then begin //###0.90
    Error (reeExecAfterCompErr);
    EXIT;
   end;

  op := EXACTLY;
  Result := '';
  s := programm + 1;
  while op <> EEND do begin // While that wasn't END last time...
     op := s^;
     Result := Result + Format ('%2d%s', [s - programm, DumpOp (s^)]); // Where, what.
     next := regnext (s);
     if next = nil // Next ptr.
      then Result := Result + '(0)'
      else Result := Result + Format ('(%d)', [(s - programm) + (next - s)]);
     inc (s, 3);
     if op in [ANYOF, ANYOFCI, ANYBUT, ANYBUTCI, EXACTLY, EXACTLYCI] then begin //###0.92
         // Literal string, where present.
         while s^ <> #0 do begin
           Result := Result + s^;
           inc (s);
          end;
         inc (s);
      end;
     if (op = BRACES)
       {$IFDEF ComplexBraces} or (op = LOOP){$ENDIF} //###0.925
        then begin //###0.90
       // show min/max argument of BRACES operator
       Result := Result + Format ('{%d,%d}', [ord (s^), ord ((s + 1)^)]);
       inc (s, 2);
      end;
     {$IFDEF ComplexBraces}
     if op = LOOP then begin //###0.925
       Result := Result + Format ('/(%d)', [(s - programm - 5)
       - (ord (s^) * 256 + ord ((s + 1)^)) ]);
       inc (s, 2);
      end;
     {$ENDIF}
     Result := Result + #$d#$a;
   end; { of while}

  // Header fields of interest.

  if regstart <> #0
   then Result := Result + 'start ' + regstart;
  if reganch <> #0
   then Result := Result + 'anchored ';
  if regmust <> nil
   then Result := Result + 'must have ' + regmust;
  Result := Result + #$d#$a;
 end; { of function TRegExpr.Dump
--------------------------------------------------------------}
{$ENDIF}

end.

