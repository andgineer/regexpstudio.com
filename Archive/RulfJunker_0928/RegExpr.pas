{$B-}
unit RegExpr;

(*

     TRegExpr library
     Regular Expressions for Delphi
     v. 0.928 beta

Author:
     Andrey V. Sorokin
     St-Petersburg
     Russia
     anso@mail.ru, anso@usa.net
     http://anso.da.ru
     http://anso.virtualave.net

 v. Changes as by 11.03.2000, Ralf Junker <ralfjunker@gmx.de>
 -=- I commented out the old code and marked both the old and the new code
     with "RJ".

 -=- * Introduced Procedure "CheckProgram". Functionality was encoded three times
       in RegEdit.pas so I copied the three instances into one. This way checking
       the program before execution is easier to maintain and uses less code.
       Simply search for "CheckProgram".

 -=- * New Compiler Directive "ExtendedSyntax". Default is set.
       ExtendedSyntax switches on / off the support for additional Russian ranges.
       This could of course be done (and is still possible)
       by setting RegExprModifierR to False. Using the compiler directive
       however results in faster code for the many languages besides Russian.
       This is probably the best solution for the both the Cyrillic and Roman world.
       Search for "ExtendedSyntax" reveals all changes.

       I have tried to cover as much code as I could find related to the Russian
       syntax. I could, however, just as well have missed some...

 -=- * Changes in String Implementation. Currently, RegExpr allocates new
       memory for the entire inputstring and copies it there. This is not
       necessary, because they already reside entirely in memory.
       So RegExpr can access the Strings where they are actually located.

       So if RegExpr just copies the pointer (which is done by
       saying "string1 := string2") we avoid copying the entire string,
       which can be lots of overhead with large large strings like entire HTML-pages.
       This is what I have tried to implemement whith my changes.
       They mostly apply to the "Exec" and the "ExecPrim" Methods.

       The *best* solution, however, would be to have a ExecPrim method working
       on PChar-Null-Terminated strings only. This is by far the fastest
       implementation.

       Without further analysis, I believe that "RegMatch" is such a function.
       How about making it public for "advanced" users?  (I have not
       changed this).

       I have also applied the above concept to the Expression property.
       As with "RegMatch", maybe the "CompileRegExpr" function could be public
       for advanced users? (I have not changed this).

       This string approach may not be fully compatible with D1 though.
       But I cannot tell, I am usind D4.

 -=- * Replaced the For-Loop to nil the startp and endp with
       only two calls to "FillChar". This should save some time.
       Just search for "FillChar" and you'll find it.

 -=- * Changes to "ExecNext". OffSet now calculates directly and is thus
       much faster because there are no hidden range-check calls anymore.

 -=- * Replaced "System.Copy" with "SetLength" in "GetMatch" Function.
       It is faster.

 -=- * Changed the Implementation of the "UpperCase" Function and the
       "FUpperCaseFunction" member. I store the UpperCase function in
       directly in the "FUpperCaseFunction" variable and call it directly
       throughout the program. So I replaced all calls to "UpperCase" with
       "FUpperCaseFunction". As "FUpperCaseFuntion" defaults to "AnsiUpperCase",
       the behaviour does not change. Only performance increases, because it
       saves us from testing "FupperCaseFunction" against nil in the
       old "UpperCase" function and then deciding which function to call.
       Now we call it directly. That's a lot faster. Find changes with
       searching for "UpperCase".

       In this context I also changed "TRegExpr.StrLIComp" to use the
       AnsiStrLIComp function to deal with Unicode Characters.

 -=- UNICODE-Question: Is there a special reason why you use your own
     implementations of StrLen, StrLComp and StrScan for dealing with
     UNICODE Strings? Delphi provides equivalent functions (AnsiStrLComp
     and AnsiStrScan) already.

 -=- Suggestion: The Delphi Standard "StrLen" Function is quite slow.
     There are much, much faster alternatives (Pascal and Assembler) at
     <http://econos.com/optimize/>. I quote the assembler version. See
     homepage for credits.

        function StrLenASM (tStr: PChar): Integer; // assembler version
        asm
              PUSH    EBX
              MOV     EDX,EAX                   { save pointer }
        @L1:  MOV     EBX,[EAX]                 { read 4 bytes}
              ADD     EAX,4                     { increment pointer}
              LEA     ECX,[EBX-$01010101]       { subtract 1 from each byte}
              NOT     EBX                       { invert all bytes}
              AND     ECX,EBX                   { and these two}
              AND     ECX,$80808080             { test all sign bits}
              JZ      @L1                       { no zero bytes, continue loop}
              TEST    ECX,$00008080             { test first two bytes}
              JZ      @L2
              SHL     ECX,16                    { not in the first 2 bytes}
              SUB     EAX,2
        @L2:  SHL     ECX,9                     { use carry flag to avoid a branch}
              SBB     EAX,EDX                   { compute length}
              POP     EBX
        end;

 -=- Suggestion: Currently case-insensitive comparisons convert all
     strings to uppercase. It is very nice that there is an interface to customize
     this function. Many components just lack this feature.

     As far as I could see, the UpperCase functions are only used to convert strings
     before comparisons.

     For speed reasons I can imagine customizable Compare functions. This can
     be quite a big time-saver, because only characters which would be compared
     would need to be uppercased. The functions would default to standard Delphi
     function calls, but could then as well be customized. I am counting four
     ot them: Case-sensitive and case-insensitve times two for regular
     and Unicode strings.

 -=- Suggestion: Some character-comparisons (like in "RegRepeat" would be faster
     if compared against Sets of Chars. <http://econos.com/optimize/> discusses
     this in more detail.

---------------------------------------------------------------
     History
---------------------------------------------------------------
Legend:
 (+) added feature
 (-) fixed bug
 (^) upgraded implementation

 v. 0.928 2000.03.09
 -=- (^) Fixed case-insensitive implementation

 v. 0.927 2000.03.08
 -=- (+) Functions QuoteRegExprMetaChars (see description)
 -=- (+) UniCode support (you must remove '.' from {.DEFINE UniCode}
     after this comment for compile unicode version of TRegExpr).
     Implemented by Yury Finkel
 -=- (-) Bug with \t and etc macro (they works only in ranges)
     Thanks to Yury Finkel
 -=- (+) property SpaceChars (by default filled with RegExprSpaceChars)
     now you may change chars treated as /s
 -=- (+) property UpperCaseFunction + function UpperCase

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

*)

{$DEFINE DebugRegExpr} // define for dump/trace enabling
{.$DEFINE ComplexBraces}// define for beta-version of braces
// (in stable version it works only for simple cases)
{.$DEFINE UniCode} // define for Unicode support

{$DEFINE ExtendedSyntax} // Extended Syntax for Russian. // RJ 11.03.2000

interface

//###0.81 determine version (for using 'params by default')
{$IFNDEF VER80} { Delphi 1.0}
{$IFNDEF VER90} { Delphi 2.0}
{$IFNDEF VER93} { C++Builder 1.0}
{$IFNDEF VER100} { Borland Delphi 3.0}
{$DEFINE D4_} { Delphi 4.0 or higher}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF}
{.$IFNDEF VER110}{ Borland C++Builder 3.0}
{.$IFNDEF VER120}{Borland Delphi 4.0}

uses Dialogs,
 Classes, // TStrings in Split method
 SysUtils; //###0.90 moved from implementation (Exception type now need in interface section)

type
 {$IFDEF UniCode}
 PRegExprChar = PWideChar;
 RegExprString = WideString;
 REChar = WideChar;
 {$ELSE}
 PRegExprChar = PChar;
 RegExprString = string;
 REChar = Char;
 {$ENDIF}
 
 // RJ 11.03.2000 TRegExprUpperCaseFunction = function (const s: RegExprString): RegExprString;
 TRegExprUpperCaseFunction = function (const s: string): string; // RJ 11.03.2000
 
const
 RegExprModifierI: Boolean = False; //###0.90
 // default value for ModifierI
 
 {$IFDEF ExtendedSyntax} // RJ 11.03.2000
 RegExprModifierR: Boolean = True; //###0.90
 // default value for ModifierR
 {$ENDIF} // RJ 11.03.2000
 
 RegExprModifierS: Boolean = True; //###0.926
 // default value for ModifierS
 
 RegExprSpaceChars: RegExprString = // chars for /s & /S
 ' '#$9#$A#$D#$C; // default for SpaceChars property
 
 // RJ 11.03.2000 RegExprUpperCaseFunction: TRegExprUpperCaseFunction = nil; //###0.927
 RegExprUpperCaseFunction: TRegExprUpperCaseFunction = AnsiUpperCase; // RJ 11.03.2000
 // defaul for UpperCaseFunction property
 
const
 NSUBEXP = 10; // max number of substitutions
 BracesMax = 255; // max value for {n,m} arguments //###0.92
 {$IFDEF ComplexBraces}
 LoopStackMax = 10; // max depth of loops stack //###0.925
 {$ENDIF}
 
type

 TRegExpr = class
 private
  startp: array [0..NSUBEXP - 1] of PRegExprChar; // founded expr starting points
  endp: array [0..NSUBEXP - 1] of PRegExprChar; // founded expr end points

  {$IFDEF ComplexBraces}
  LoopStack: array [1..LoopStackMax] of Integer; // state before entering loop //###0.925
  LoopStackIdx: Integer; // 0 - out of all loops //###0.925
  {$ENDIF}

  // The "internal use only" fields to pass info from compile
  // to execute that permits the execute phase to run lots faster on
  // simple cases.
  regstart: REChar; // char that must begin a match; '\0' if none obvious
  reganch: REChar; // is the match anchored (at beginning-of-line only)?
  regmust: PRegExprChar; // string (pointer into program) that match must include, or nil
  regmlen: Integer; // length of regmust string
  // Regstart and reganch permit very fast decisions on suitable starting points
  // for a match, cutting down the work a lot.  Regmust permits fast rejection
  // of lines that cannot possibly match.  The regmust tests are costly enough
  // that regcomp() supplies a regmust only if the r.e. contains something
  // potentially expensive (at present, the only such thing detected is * or +
  // at the start of the r.e., which can involve a lot of backup).  Regmlen is
  // supplied because the test in regexec() needs it and regcomp() is computing
  // it anyway.

  // work variables for Exec's routins - save stack in recursion}
  RegInput: PRegExprChar; // String-input pointer.
  RegBol: PRegExprChar; // Beginning of input, for ^ check.
  regeol: PRegExprChar; // End of input, for pascal-style string processing //###0.92

  // work variables for compiler's routines
  regparse: PRegExprChar; // Input-scan pointer.
  regnpar: Integer; // count.
  regdummy: Char;
  regcode: PRegExprChar; // Code-emit pointer; @regdummy = don't.
  regsize: Integer; // Code size.

  regexpbeg: PRegExprChar; //##0.90 only for error handling. Contains
  // pointer to beginning of r.e. while compiling
  fExprIsCompiled: Boolean; //###0.90 true if r.e. successfully compiled

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
  programm: PRegExprChar; // Unwarranted chumminess with compiler.

  // RJ 11.03.2000  fExpression: PRegExprChar; // source of compiled r.e.
  FExpression: RegExprString; // RJ 11.03.2000
  // RJ 11.03.2000 FInputString: PRegExprChar; // input string
  FInputString: RegExprString; // RJ 11.03.2000

  FLastError: Integer; // see Error, LastError

  FModifiers: Integer; // modifiers //###0.90
  fCompModifiers: Integer; // compiler's copy of modifiers //###0.90
  fProgModifiers: Integer; // values modifiers from last programm compilation

  FSpaceChars: RegExprString; //###0.927
  FUpperCaseFunction: TRegExprUpperCaseFunction; //###0.927

  procedure CheckProgram; // RJ 11.03.2000

  procedure CheckCompModifiers;
  // if modifiers was changed after programm compilation - recompile it !

// RJ 11.03.2000  function GetExpression: RegExprString;
  procedure SetExpression (const s: RegExprString);

  function GetModifierStr: RegExprString; //###0.926
  function SetModifiersInt (const AModifiers: RegExprString; var AModifiersInt: Integer): Boolean; //###0.90
  procedure SetModifierStr (const AModifiers: RegExprString); //###0.926

  function GetModifier (AIndex: Integer): Boolean; //###0.90
  procedure SetModifier (AIndex: Integer; ASet: Boolean); //###0.90

  procedure Error (AErrorID: Integer); virtual; // error handler.
  // Default handler raise exception ERegExpr with
  // Message = ErrorMsg (AErrorID), ErrorCode = AErrorID
  // and CompilerErrorPos = value of property CompilerErrorPos.

  {==================== Compiler section ===================}
  function CompileRegExpr (exp: PRegExprChar): Boolean;
  // compile a regular expression into internal code

  procedure Tail (p: PRegExprChar; Val: PRegExprChar);
  // set the next-pointer at the end of a node chain

  procedure OpTail (p: PRegExprChar; Val: PRegExprChar);
  // regoptail - regtail on operand of first argument; nop if operandless

  function EmitNode (op: REChar): PRegExprChar;
  // regnode - emit a node, return location

  procedure EmitC (b: REChar);
  // emit (if appropriate) a byte of code

  procedure InsertOperator (op: REChar; opnd: PRegExprChar; SZ: Integer); //###0.90
  // insert an operator in front of already-emitted operand
  // Means relocating the operand.

  function ParseReg (paren: Integer; var flagp: Integer): PRegExprChar;
  // regular expression, i.e. main body or parenthesized thing

  function ParseBranch (var flagp: Integer): PRegExprChar;
  // one alternative of an | operator

  function ParsePiece (var flagp: Integer): PRegExprChar;
  // something followed by possible [*+?]

  function ParseAtom (var flagp: Integer): PRegExprChar;
  // the lowest level

  function GetCompilerErrorPos: Integer; //###0.90
  // current pos in r.e. - for error hanling

  {===================== Mathing section ===================}
  function regrepeat (p: PRegExprChar; AMax: Integer): Integer; //###0.92
  // repeatedly match something simple, report how many

  function regnext (p: PRegExprChar): PRegExprChar;
  // dig the "next" pointer out of a node

  function MatchPrim (prog: PRegExprChar): Boolean;
  // recursively matching routine

  function RegMatch (Str: PRegExprChar): Boolean;
  // try match at specific point, uses MatchPrim for real work

  function ExecPrim (AOffset: Integer): Boolean; //###0.90
  // Exec for stored InputString

  {$IFDEF DebugRegExpr}
  function DumpOp (op: REChar): RegExprString;
  {$ENDIF}

  function GetSubExprMatchCount: Integer; //###0.90
  function GetMatchPos (Idx: Integer): Integer;
  function GetMatchLen (Idx: Integer): Integer;
  function GetMatch (Idx: Integer): RegExprString;

  // RJ 11.03.2000  function GetInputString: RegExprString; //###0.90
  procedure SetInputString (const AInputString: RegExprString); //###0.90

  function StrScanCI (s: PRegExprChar; ch: REChar): PRegExprChar; //###0.928
  function StrLIComp (AStr1, AStr2: PRegExprChar; AMaxLen: Cardinal): Integer;

 public
  constructor Create;
  destructor Destroy; override;

  // RJ 11.03.2000  property Expression: RegExprString Read GetExpression Write SetExpression;
  property Expression: RegExprString Read FExpression Write SetExpression;
  // regular expression
  // When you assign r.e. to this property, TRegExpr will automatically
  // compile it and store in internal structures.
  // In case of compilation error, Error method will be called
  // (by default Error method raises exception ERegExpr - see below)

  property ModifierStr: RegExprString Read GetModifierStr Write SetModifierStr; //###0.926
  // Set/get default values of r.e.syntax modifiers. Modifiers in
  // r.e. (?ismx-ismx) will replace this default values.
  // If you try to set unsupported modifier, Error will be called
  // (by defaul Error raises exception ERegExpr).

  property ModifierI: Boolean Index 1 Read GetModifier Write SetModifier; //###0.90
  // Modifier /i - caseinsensitive, false by default

  {$IFDEF ExtendedSyntax} // RJ 11.03.2000
  property ModifierR: Boolean Index 2 Read GetModifier Write SetModifier; //###0.90
  // Modifier /r - use r.e.syntax extended for russian, true by default
  // (was property ExtSyntaxEnabled in previous versions)
  // If true, then à-ÿ  additional include russian letter '¸',
  // À-ß  additional include '¨', and à-ß include all russian symbols.
  // You have to turn it off if it may interfere with you national alphabet.
  {$ENDIF} // RJ 11.03.2000

  property ModifierS: Boolean Index 3 Read GetModifier Write SetModifier; //###0.926
  // Modifier /s - '.' works as any char (else as [^\n]),
  // true by default

  function Exec (const AInputString: RegExprString): Boolean; //###0.90
  // match a programm against a string AInputString
  // !!! Exec store AInputString into InputString property

  function ExecNext: Boolean; //###0.90
  // find next match:
  //    Exec (AString); ExecNext;
  // works same as
  //    Exec (AString);
  //    if MatchLen [0] = 0 then ExecPos (MatchPos [0] + 1)
  //     else ExecPos (MatchPos [0] + MatchLen [0]);
  // but it's more simpler !

  function ExecPos (AOffset: Integer{$IFDEF D4_} = 1{$ENDIF}): Boolean; //###0.90
  // find match for InputString starting from AOffset position
  // (AOffset=1 - first char of InputString)

// RJ 11.03.2000  property InputString: RegExprString Read GetInputString Write SetInputString; //###0.90
  property InputString: RegExprString Read FInputString Write SetInputString; // RJ 11.03.2000
  // returns current input string (from last Exec call or last assign
  // to this property).
  // Any assignment to this property clear Match* properties !

  function Substitute (const ATemplate: RegExprString): RegExprString;
  // Returns ATemplate with '&' replaced by whole r.e. occurence
  // and '/n' replaced by occurence of subexpression #n.

  procedure Split (AInputStr: RegExprString; APieces: TStrings);
  // Split AInputStr into APieces by r.e. occurencies

  function Replace (AInputStr: RegExprString; const AReplaceStr: RegExprString): RegExprString;
  // Returns AInputStr with r.e. occurencies replaced by AReplaceStr

  property SubExprMatchCount: Integer Read GetSubExprMatchCount;
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

  property MatchPos [Idx: Integer]: Integer Read GetMatchPos;
  // pos of entrance subexpr. #Idx into tested in last Exec*
  // string. First subexpr. have Idx=1, last - MatchCount,
  // whole r.e. have Idx=0.
  // Returns -1 if in r.e. no such subexpr. or this subexpr.
  // not found in input string.

  property MatchLen [Idx: Integer]: Integer Read GetMatchLen;
  // len of entrance subexpr. #Idx r.e. into tested in last Exec*
  // string. First subexpr. have Idx=1, last - MatchCount,
  // whole r.e. have Idx=0.
  // Returns -1 if in r.e. no such subexpr. or this subexpr.
  // not found in input string.
  // Remember - MatchLen may be 0 (if r.e. match empty string) !

  property Match [Idx: Integer]: RegExprString Read GetMatch;
  // == copy (InputString, MatchPos [Idx], MatchLen [Idx])
  // Returns '' if in r.e. no such subexpr. or this subexpr.
  // not found in input string.

  function LastError: Integer; //###0.90
  // Returns ID of last error, 0 if no errors (unusable if
  // Error method raises exception) and clear internal status
  // into 0 (no errors).

  function ErrorMsg (AErrorID: Integer): RegExprString; virtual;
  // Returns Error message for error with ID = AErrorID.

  property CompilerErrorPos: Integer Read GetCompilerErrorPos; //###0.90
  // Returns pos in r.e. there compiler stopped.
  // Usefull for error diagnostics

  property SpaceChars: RegExprString Read FSpaceChars Write FSpaceChars; //###0.927
  // Contains chars, treated as /s (initially filled with RegExprSpaceChars
  // global constant)

  property UpperCaseFunction: TRegExprUpperCaseFunction Read FUpperCaseFunction Write FUpperCaseFunction;
  // Set this property if you want to override UpperCase function functionality
  // If nil (by default), then UppeCase uses AnsiUpperCase.
  // In constructor this property initialized with RegExprUpperCaseFunction global constatant

  { // RJ 11.03.2000
  function UpperCase (const s: RegExprString): RegExprString; virtual;
  // Converts S into upper case (uses UpperCaseFunction, if it nil - AnsiUpperCase)
  }

  {$IFDEF DebugRegExpr}
  function Dump: RegExprString;
  // dump a compiled regexp in vaguely comprehensible form
  {$ENDIF}
 end;
 
 ERegExpr = class (Exception)
 public
  ErrorCode: Integer;
  CompilerErrorPos: Integer;
 end;
 
function ExecRegExpr (const ARegExpr, AInputStr: RegExprString): Boolean;
// true if string AInputString match regular expression ARegExpr
// ! will raise exeption if syntax errors in ARegExpr

procedure SplitRegExpr (const ARegExpr, AInputStr: RegExprString; APieces: TStrings);
// Split AInputStr into APieces by r.e. ARegExpr occurencies

function ReplaceRegExpr (const ARegExpr, AInputStr, AReplaceStr: RegExprString): RegExprString;
// Returns AInputStr with r.e. occurencies replaced by AReplaceStr

function QuoteRegExprMetaChars (const AStr: RegExprString): RegExprString; //###0.927
// Replace all metachars with its safe representation,
// for example 'abc$cd.(' converts into 'abc\$cd\.\('
// This function usefull for r.e. autogeneration from
// user input (see function FileMask2RegExpr)

implementation

const
 MaskModI = 1; // modifier /i bit in fModifiers
 {$IFDEF ExtendedSyntax} // RJ 11.03.2000
 MaskModR = 2; // -"- /r
 {$ENDIF} // RJ 11.03.2000
 MaskModS = 4; // -"- /s //###0.926
 
 {=============================================================}
 {==================== WideString functions ====================}
 {=============================================================}

{$IFDEF UniCode}

function StrPCopy (Dest: PRegExprChar; const Source: RegExprString): PRegExprChar;
var
 i: Integer;
begin
 for i := 1 to Length (Source) do
  Dest [i - 1] := Source [i];
 Dest [Length (Source)] := #0;
 Result := Dest;
end; { of function StrPCopy
--------------------------------------------------------------}

function StrLCopy (Dest, Source: PRegExprChar; MaxLen: Cardinal): PRegExprChar;
var
 i: Integer;
begin
 for i := 0 to MaxLen - 1 do
  Dest [i] := Source [i];
 Result := Dest;
end; { of function StrLCopy
--------------------------------------------------------------}

function StrLen (Str: PRegExprChar): Cardinal;
begin
 Result := 0;
 while Str [Result] <> #0
  do
  Inc (Result);
end; { of function StrLen
--------------------------------------------------------------}

function StrPos (Str1, Str2: PRegExprChar): PRegExprChar;
var
 n: Integer;
begin
 Result := nil;
 n := Pos (RegExprString (Str2), RegExprString (Str1));
 if n = 0
  then Exit;
 Result := Str1 + n - 1;
end; { of function StrPos
--------------------------------------------------------------}

function StrLComp (Str1, Str2: PRegExprChar; MaxLen: Cardinal): Integer;
var
 s1, s2: RegExprString;
begin
 s1 := Str1;
 s2 := Str2;
 if Copy (s1, 1, MaxLen) > Copy (s2, 1, MaxLen)
  then
  Result := 1
 else
  if Copy (s1, 1, MaxLen) < Copy (s2, 1, MaxLen)
   then
   Result := -1
  else
   Result := 0;
end; { function StrLComp
--------------------------------------------------------------}

function StrScan (Str: PRegExprChar; Chr: WideChar): PRegExprChar;
begin
 Result := nil;
 while (Str^ <> #0) and (Str^ <> Chr)
  do
  Inc (Str);
 if (Str^ <> #0)
  then Result := Str;
end; { of function StrScan
--------------------------------------------------------------}

{$ENDIF}

{=============================================================}
{===================== Global functions ======================}
{=============================================================}

function ExecRegExpr (const ARegExpr, AInputStr: RegExprString): Boolean;
var
 r: TRegExpr;
begin
 r := TRegExpr.Create;
 try
  r.Expression := ARegExpr;
  Result := r.Exec (AInputStr);
 finally r.Free;
 end;
end; { of function ExecRegExpr
--------------------------------------------------------------}

procedure SplitRegExpr (const ARegExpr, AInputStr: RegExprString; APieces: TStrings);
var
 r: TRegExpr;
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

function ReplaceRegExpr (const ARegExpr, AInputStr, AReplaceStr: RegExprString): RegExprString;
var
 r: TRegExpr;
begin
 r := TRegExpr.Create;
 try
  r.Expression := ARegExpr;
  Result := r.Replace (AInputStr, AReplaceStr);
 finally r.Free;
 end;
end; { of function ReplaceRegExpr
--------------------------------------------------------------}

function QuoteRegExprMetaChars (const AStr: RegExprString): RegExprString; //###0.927
const
 RegExprMetaSet: RegExprString = '^$.[()|?+*\{'
  + ']}'; // - this last are additional to META.
 // Very similar to META array, but slighly changed.
 // !Any changes in META array must be synchronized with this set.
var
 i, i0, Len: Integer;
begin
 Result := '';
 Len := Length (AStr);
 i := 1;
 i0 := i;
 while i <= Len do
  begin
   if Pos (AStr [i], RegExprMetaSet) > 0 then
    begin
     Result := Result + System.Copy (AStr, i0, i - i0)
      + '\' + AStr [i];
     i0 := i + 1;
    end;
   Inc (i);
  end;
 Result := Result + System.Copy (AStr, i0, MaxInt); // Tail
end; { of function QuoteRegExprMetaChars
--------------------------------------------------------------}

const
 MAGIC = REChar (156); // programm signature ($9C)
 
 // name   opcode   opnd? meaning
 EEND = REChar (0); // no   End of program
 BOL = REChar (1); // no   Match "" at beginning of line
 EOL = REChar (2); // no   Match "" at end of line
 ANY = REChar (3); // no   Match any one character
 ANYOF = REChar (4); // str  Match any character in this string
 ANYBUT = REChar (5); // str  Match any char. not in this string
 BRANCH = REChar (6); // node Match this alternative, or the next
 Back = REChar (7); // no   Match "", "next" ptr points backward
 EXACTLY = REChar (8); // str  Match this string
 NOTHING = REChar (9); // no   Match empty string
 STAR = REChar (10); // node Match this (simple) thing 0 or more times
 PLUS = REChar (11); // node Match this (simple) thing 1 or more times
 ANYDIGIT = REChar (12); // no   Match any digit (equiv [0-9])
 NOTDIGIT = REChar (13); // no   Match not digit (equiv [0-9])
 ANYLETTER = REChar (14); // no   Match any english letter (equiv [a-zA-Z_])
 NOTLETTER = REChar (15); // no   Match not english letter (equiv [a-zA-Z_])
 ANYSPACE = REChar (16); // no   Match any space char (equiv [ \t]) //###0.8
 NOTSPACE = REChar (17); // no   Match not space char (equiv [ \t]) //###0.8
 BRACES = REChar (18); // node,min,max Match this (simple) thing from min to max times. //###0.90
 COMMENT = REChar (19); // no   Comment //###0.90
 OPEN = REChar (20); // no   Mark this point in input as start of #n
 //      OPEN+1 is number 1, etc.
 Close = REChar (30); // no   Analogous to OPEN.
 EXACTLYCI = REChar (40); // str  Match this string case insensitive //###0.90
 ANYOFCI = REChar (41); // str  Match any character in this string, case insensitive //###0.92
 ANYBUTCI = REChar (42); // str  Match any char. not in this string, case insensitive //###0.92
 {$IFDEF ComplexBraces}
 LOOPENTRY = REChar (43); // node Start of loop (node - LOOP for this loop) //###0.925
 LOOP = REChar (44); // node,min,max,loopentryjmp - back jump for LOOPENTRY. //###0.925
 // node - next node in sequence,loopentryjmp - associated LOOPENTRY node addr
 {$ENDIF}
 
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
 
function TRegExpr.ErrorMsg (AErrorID: Integer): RegExprString;
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
  reeNoHexCodeAfterBSlashX4: Result := 'TRegExpr(comp): No Hex Code After \x';
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
  else
   Result := 'Unknown error';
 end;
end; { of procedure TRegExpr.Error
--------------------------------------------------------------}

procedure TRegExpr.Error (AErrorID: Integer);
var
 e: ERegExpr;
begin
 FLastError := AErrorID; // dummy stub - useless because will raise exception
 if AErrorID < 1000 // compilation error ?
 then
  e := ERegExpr.Create (ErrorMsg (AErrorID) // yes - show error pos
   + ' (pos ' + IntToStr (CompilerErrorPos) + ')')
 else
  e := ERegExpr.Create (ErrorMsg (AErrorID));
 e.ErrorCode := AErrorID;
 e.CompilerErrorPos := CompilerErrorPos;
 raise e;
end; { of procedure TRegExpr.Error
--------------------------------------------------------------}

function TRegExpr.LastError: Integer;
begin
 Result := FLastError;
 FLastError := reeOk;
end; { of function TRegExpr.LastError
--------------------------------------------------------------}

{=============================================================}
{===================== Common section ========================}
{=============================================================}

constructor TRegExpr.Create;
begin
 inherited;
 programm := nil;
 // RJ 11.03.2000 fExpression := nil;
  // RJ 11.03.2000 FInputString := nil;
 
 regexpbeg := nil; //###0.90
 fExprIsCompiled := False; //###0.90
 
 ModifierI := RegExprModifierI; //###0.90
 
 {$IFDEF ExtendedSyntax} // RJ 11.03.2000
 ModifierR := RegExprModifierR; //###0.90
 {$ENDIF} // RJ 11.03.2000
 ModifierS := RegExprModifierS; //###0.926
 
 SpaceChars := RegExprSpaceChars; //###0.927
 // RJ 11.03.2000 UpperCaseFunction := RegExprUpperCaseFunction; //###0.927
 FUpperCaseFunction := RegExprUpperCaseFunction; // RJ 11.03.2000
end; { of constructor TRegExpr.Create
--------------------------------------------------------------}

destructor TRegExpr.Destroy;
begin
 if programm <> nil
  then FreeMem (programm);
 { // RJ 11.03.2000
  if fExpression <> nil
   then FreeMem (fExpression);}
  { // RJ 11.03.2000
  if FInputString <> nil
   then FreeMem (FInputString); }
end; { of destructor TRegExpr.Destroy
--------------------------------------------------------------}

{ // RJ 11.03.2000
function TRegExpr.UpperCase (const s: RegExprString): RegExprString;
begin
 if Assigned (UpperCaseFunction)
  then
  Result := UpperCaseFunction (s)
 else
  Result := AnsiUpperCase (s);
end; { of function TRegExpr.UpperCase
--------------------------------------------------------------}

function TRegExpr.StrLIComp (AStr1, AStr2: PRegExprChar; AMaxLen: Cardinal): Integer;
begin
 // RJ 11.03.2000 Result := StrLComp (PRegExprChar (UpperCase (AStr1)), PRegExprChar (UpperCase (AStr2)), AMaxLen);
 {$IFDEF UniCode} // RJ 11.03.2000
 Result := AnsiStrLComp (PChar (FUpperCaseFunction (AStr1)), PChar (FUpperCaseFunction (AStr2)), AMaxLen); // RJ 11.03.2000
 {$ELSE} // RJ 11.03.2000
 Result := StrLComp (PChar (FUpperCaseFunction (AStr1)), PChar (FUpperCaseFunction (AStr2)), AMaxLen); // RJ 11.03.2000
 {$ENDIF} // RJ 11.03.2000
end; { of function TRegExpr.StrLIComp
--------------------------------------------------------------}

{ // RJ 11.03.2000
function TRegExpr.GetExpression: RegExprString;
begin
 if fExpression <> nil
  then
  Result := fExpression
 else
  Result := '';
end; { of function TRegExpr.GetExpression
--------------------------------------------------------------}

procedure TRegExpr.SetExpression (const s: RegExprString);
begin
 { // RJ 11.03.2000
  if (s <> fExpression) or not fExprIsCompiled then
   begin //###0.90
    fExprIsCompiled := False; //###0.90
    if fExpression <> nil then
     begin
      FreeMem (fExpression);
      fExpression := nil;
     end;
    if s <> '' then
     begin
      GetMem (fExpression, (Length (s) + 1) * SizeOf (REChar));
      CompileRegExpr (StrPCopy (fExpression, s));
     end;
   end;}
 if s <> FExpression then // RJ 11.03.2000
  begin // RJ 11.03.2000
   FExpression := s; // RJ 11.03.2000
   compileregexpr (pregexprchar (s)); // RJ 11.03.2000
  end; // RJ 11.03.2000
end; { of procedure TRegExpr.SetExpression
--------------------------------------------------------------}

function TRegExpr.GetSubExprMatchCount: Integer; //###0.90
begin
 // RJ 11.03.2000 if Assigned (FInputString) then
 if Assigned (RegBol) then // RJ 11.03.2000
  begin
   Result := NSUBEXP - 1;
   while (Result > 0) and ((startp [Result] = nil)
    or (endp [Result] = nil))
    do
    Dec (Result);
  end
 else
  Result := -1;
end; { of function TRegExpr.GetSubExprMatchCount
--------------------------------------------------------------}

function TRegExpr.GetMatchPos (Idx: Integer): Integer;
begin
 { // RJ 11.03.2000
  if (Idx >= 0) and (Idx < NSUBEXP) and Assigned (FInputString)
   and Assigned (startp [Idx]) and Assigned (endp [Idx]) then
   begin
    Result := (startp [Idx] - FInputString) + 1;
   end
  else
   Result := -1;}
 if (Idx >= 0) and (Idx < NSUBEXP) and Assigned (RegBol) // RJ 11.03.2000 FInputString --> RegBol
 and Assigned (startp [Idx]) and Assigned (endp [Idx]) then
  begin
   Result := (startp [Idx] - RegBol) + 1; // RJ 11.03.2000 FInputString --> RegBol
  end
 else
  Result := -1;

end; { of function TRegExpr.GetMatchPos
--------------------------------------------------------------}

function TRegExpr.GetMatchLen (Idx: Integer): Integer;
begin
 { // RJ 11.03.2000
 if (Idx >= 0) and (Idx < NSUBEXP) and Assigned (FInputString)
  and Assigned (startp [Idx]) and Assigned (endp [Idx]) then
  begin
   Result := endp [Idx] - startp [Idx];
  end
 else
  Result := -1;}
 if (Idx >= 0) and (Idx < NSUBEXP) and Assigned (RegBol) // RJ 11.03.2000 FInputString --> RegBol
 and Assigned (startp [Idx]) and Assigned (endp [Idx]) then
  begin
   Result := endp [Idx] - startp [Idx];
  end
 else
  Result := -1;
 
end; { of function TRegExpr.GetMatchLen
--------------------------------------------------------------}

function TRegExpr.GetMatch (Idx: Integer): RegExprString;
begin
 { // RJ 11.03.2000
 if (Idx >= 0) and (Idx < NSUBEXP) and Assigned (FInputString)
  and Assigned (startp [Idx]) and Assigned (endp [Idx])
  then
  Result := Copy (FInputString, MatchPos [Idx], MatchLen [Idx])
 else
  Result := '';}
 if (Idx >= 0) and (Idx < NSUBEXP) and Assigned (RegBol) // RJ 11.03.2000 FInputString --> RegBol
 and Assigned (startp [Idx]) and Assigned (endp [Idx])
  then
  SetString (Result, startp [idx], endp [idx] - startp [idx]) // RJ 11.03.2000
 else
  Result := '';
end; { of function TRegExpr.GetMatch
--------------------------------------------------------------}

procedure TRegExpr.CheckProgram; // RJ 11.03.2000
begin
 // Check compiled r.e. presence
 if programm = nil then
  begin //###0.90
   Error (reeNoExpression);
   Exit;
  end;
 
 // Check validity of program.
 if programm [0] <> MAGIC then
  begin //###0.90
   Error (reeCorruptedProgram);
   Exit;
  end;
 
 // Exit if previous compilation was finished with error
 if not fExprIsCompiled then
  begin //###0.90
   Error (reeExecAfterCompErr);
   Exit;
  end;
end;

procedure TRegExpr.CheckCompModifiers;
begin
 { // RJ 11.03.2000
  if (programm <> nil) and (fExpression <> nil)
   and (fModifiers <> fProgModifiers)
   then CompileRegExpr (fExpression);}
 
 if (programm <> nil) and (FExpression <> '') // RJ 11.03.2000 nil --> ''
 and (FModifiers <> fProgModifiers)
  then CompileRegExpr (PRegExprChar (FExpression)); // RJ 11.03.2000
end; { of TRegExpr.CheckCompModifiers
--------------------------------------------------------------}

function TRegExpr.GetModifierStr: RegExprString; //###0.926
begin
 Result := '-';
 
 if ModifierI
  then
  Result := 'i' + Result
 else
  Result := Result + 'i';
 {$IFDEF ExtendedSyntax} // RJ 11.03.2000
 if ModifierR
  then
  Result := 'r' + Result
 else
  Result := Result + 'r';
 {$ENDIF} // RJ 11.03.2000
 if ModifierS //###0.926
 then
  Result := 's' + Result
 else
  Result := Result + 's';
 
 if Result [Length (Result)] = '-' // remove '-' if all modifiers are 'On'
 then System.Delete (Result, Length (Result), 1);
end; { of function TRegExpr.GetModifierStr
--------------------------------------------------------------}

function TRegExpr.SetModifiersInt (const AModifiers: RegExprString; var AModifiersInt: Integer): Boolean; //###0.90
var
 i: Integer;
 IsOn: Boolean;
 Mask: Integer;
begin
 Result := True;
 IsOn := True;
 Mask := 0; // strange compiler varning
 for i := 1 to Length (AModifiers) do
  if AModifiers [i] = '-'
   then
   IsOn := False
  else
   begin
    if Pos (AModifiers [i], 'iI') > 0
     then
     Mask := MaskModI
    else
     {$IFDEF ExtendedSyntax} // RJ 11.03.2000
     if Pos (AModifiers [i], 'rR') > 0
      then
      Mask := MaskModR
     else
      {$ENDIF} // RJ 11.03.2000
      if Pos (AModifiers [i], 'sS') > 0 //###0.926
      then
       Mask := MaskModS
      else
       begin
        Result := False;
        Exit;
       end;
    if IsOn
     then
     AModifiersInt := AModifiersInt or Mask
    else
     AModifiersInt := AModifiersInt and not Mask;
   end;
end; { of function TRegExpr.SetModifiersInt
--------------------------------------------------------------}

procedure TRegExpr.SetModifierStr (const AModifiers: RegExprString); //###0.926
begin
 if not SetModifiersInt (AModifiers, FModifiers)
  then Error (reeModifierUnsupported);
 CheckCompModifiers;
end; { of procedure TRegExpr.SetModifierStr
--------------------------------------------------------------}

function TRegExpr.GetModifier (AIndex: Integer): Boolean; //###0.90
var
 Mask: Integer;
begin
 Result := False;
 case AIndex of
  1: Mask := MaskModI;
  {$IFDEF ExtendedSyntax} // RJ 11.03.2000
  2: Mask := MaskModR;
  {$ENDIF} // RJ 11.03.2000
  3: Mask := MaskModS; //###0.926
  else
   begin
    Error (reeModifierUnsupported);
    Exit;
   end;
 end;
 Result := (FModifiers and Mask) = Mask;
end; { of function TRegExpr.GetModifier
--------------------------------------------------------------}

procedure TRegExpr.SetModifier (AIndex: Integer; ASet: Boolean); //###0.90
var
 Mask: Integer;
begin
 case AIndex of
  1: Mask := MaskModI;
  {$IFDEF ExtendedSyntax} // RJ 11.03.2000
  2: Mask := MaskModR;
  {$ENDIF} // RJ 11.03.2000
  3: Mask := MaskModS; //###0.926
  else
   begin
    Error (reeModifierUnsupported);
    Exit;
   end;
 end;
 if ASet
  then
  FModifiers := FModifiers or Mask
 else
  FModifiers := FModifiers and not Mask;
 CheckCompModifiers;
end; { of procedure TRegExpr.SetModifier
--------------------------------------------------------------}

{=============================================================}
{==================== Compiler section =======================}
{=============================================================}

function Next (p: PRegExprChar): Word;
begin
 Result := (Ord ((p + 1)^) shl 8) + Ord ((p + 2)^);
end; { of function NEXT
--------------------------------------------------------------}

procedure TRegExpr.Tail (p: PRegExprChar; Val: PRegExprChar);
// set the next-pointer at the end of a node chain
var
 Scan: PRegExprChar;
 Temp: PRegExprChar;
 OffSet: Integer;
begin
 if p = @regdummy
  then Exit;
 // Find last node.
 Scan := p;
 repeat
  Temp := regnext (Scan);
  if Temp = nil
   then Break;
  Scan := Temp;
 until False;
 
 if Scan^ = Back
  then
  OffSet := Scan - Val
 else
  OffSet := Val - Scan;
  (Scan + 1)^ := REChar ((OffSet shr 8) and $FF);
  (Scan + 2)^ := REChar (OffSet and $FF);
end; { of procedure TRegExpr.Tail
--------------------------------------------------------------}

procedure TRegExpr.OpTail (p: PRegExprChar; Val: PRegExprChar);
// regtail on operand of first argument; nop if operandless
begin
 // "Operandless" and "op != BRANCH" are synonymous in practice.
 if (p = nil) or (p = @regdummy) or (p^ <> BRANCH)
  then Exit;
 Tail (p + 3, Val);
end; { of procedure TRegExpr.OpTail
--------------------------------------------------------------}

function TRegExpr.EmitNode (op: REChar): PRegExprChar;
// emit a node, return location
begin
 Result := regcode;
 if Result <> @regdummy then
  begin
   regcode^ := op;
   Inc (regcode);
   regcode^ := #0; // "next" pointer := nil
   Inc (regcode);
   regcode^ := #0;
   Inc (regcode);
  end
 else
  Inc (regsize, 3); // compute code size without code generation
end; { of function TRegExpr.EmitNode
--------------------------------------------------------------}

procedure TRegExpr.EmitC (b: REChar);
// emit (if appropriate) a byte of code
begin
 if regcode <> @regdummy then
  begin
   regcode^ := b;
   Inc (regcode);
  end
 else
  Inc (regsize);
end; { of procedure TRegExpr.EmitC
--------------------------------------------------------------}

procedure TRegExpr.InsertOperator (op: REChar; opnd: PRegExprChar; SZ: Integer); //###0.90
// insert an operator in front of already-emitted operand
// Means relocating the operand.
var
 Src, dst, place: PRegExprChar;
 i: Integer;
begin
 if regcode = @regdummy then
  begin
   Inc (regsize, SZ);
   Exit;
  end;
 Src := regcode;
 Inc (regcode, SZ);
 dst := regcode;
 while Src > opnd do
  begin
   Dec (dst);
   Dec (Src);
   dst^ := Src^;
  end;
 place := opnd; // Op node, where operand used to be.
 place^ := op;
 for i := 2 to SZ do
  begin //###0.90
   Inc (place);
   place^ := #0;
  end;
end; { of procedure TRegExpr.InsertOperator
--------------------------------------------------------------}

function strcspn (s1: PRegExprChar; s2: PRegExprChar): Integer;
// find length of initial segment of s1 consisting
// entirely of characters not from s2
var
 scan1, scan2: PRegExprChar;
begin
 Result := 0;
 scan1 := s1;
 while scan1^ <> #0 do
  begin
   scan2 := s2;
   while scan2^ <> #0 do
    if scan1^ = scan2^
     then
     Exit
    else
     Inc (scan2);
   Inc (Result);
   Inc (scan1)
  end;
end; { of function strcspn
--------------------------------------------------------------}

const
 // Flags to be passed up and down.
 HASWIDTH = 01; // Known never to match nil string.
 SIMPLE = 02; // Simple enough to be STAR/PLUS/BRACES operand.
 SPSTART = 04; // Starts with * or +.
 WORST = 0; // Worst case.
 META: array [0..12] of REChar = (
  '^', '$', '.', '[', '(', ')', '|', '?', '+', '*', '\', '{', #0); //###0.90
 // Any modification must be synchronized with QuoteRegExprMetaChars !!!
 
 {$IFDEF ExtendedSyntax} // RJ 11.03.2000
 
 {$IFDEF UniCode}
 RusRangeLo: array [0..33] of REChar =
   (#$430, #$431, #$432, #$433, #$434, #$435, #$451, #$436, #$437,
  #$438, #$439, #$43A, #$43B, #$43C, #$43D, #$43E, #$43F,
  #$440, #$441, #$442, #$443, #$444, #$445, #$446, #$447,
  #$448, #$449, #$44A, #$44B, #$44C, #$44D, #$44E, #$44F, #0);
 RusRangeHi: array [0..33] of REChar =
   (#$410, #$411, #$412, #$413, #$414, #$415, #$401, #$416, #$417,
  #$418, #$419, #$41A, #$41B, #$41C, #$41D, #$41E, #$41F,
  #$420, #$421, #$422, #$423, #$424, #$425, #$426, #$427,
  #$428, #$429, #$42A, #$42B, #$42C, #$42D, #$42E, #$42F, #0);
 RusRangeLoLow = #$430 {'à'};
 RusRangeLoHigh = #$44F {'ÿ'};
 RusRangeHiLow = #$410 {'À'};
 RusRangeHiHigh = #$42F {'ß'};
 {$ELSE}
 RusRangeLo = 'àáâãäå¸æçèéêëìíîïðñòóôõö÷øùúûüýþÿ';
 RusRangeHi = 'ÀÁÂÃÄÅ¨ÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß';
 RusRangeLoLow = 'à';
 RusRangeLoHigh = 'ÿ';
 RusRangeHiLow = 'À';
 RusRangeHiHigh = 'ß';
 {$ENDIF}
 
 {$ENDIF} // RJ 11.03.2000
 
function TRegExpr.CompileRegExpr (exp: PRegExprChar): Boolean;
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
 Scan, longest: PRegExprChar;
 Len: Cardinal;
 flags: Integer;
begin
 Result := False; // life too dark
 fExprIsCompiled := False; //###0.90
 
 regparse := nil; //###0.90 // for correct error handling
 regexpbeg := exp; //###0.90
 try //###0.90 must clear regexpbeg after compilation

  if programm <> nil then
   begin
    FreeMem (programm);
    programm := nil;
   end;

  if exp = nil then
   begin
    Error (reeCompNullArgument);
    Exit;
   end;

  fProgModifiers := FModifiers; // well, may it's paranoia. I'll check it later, now too late...

  // First pass: determine size, legality.
  fCompModifiers := FModifiers; //###0.90
  regparse := exp;
  regnpar := 1;
  regsize := 0;
  regcode := @regdummy;
  EmitC (MAGIC);
  if ParseReg (0, flags) = nil
   then Exit;

  // Small enough for 2-bytes programm pointers ?
  if regsize >= 64 * 1024 then
   begin
    Error (reeCompRegexpTooBig);
    Exit;
   end;

  // Allocate space.
  GetMem (programm, regsize * SizeOf (REChar));

  // Second pass: emit code.
  fCompModifiers := FModifiers; //###0.90
  regparse := exp;
  regnpar := 1;
  regcode := programm;
  EmitC (MAGIC);
  if ParseReg (0, flags) = nil
   then Exit;

  // Dig out information for optimizations.
  regstart := #0; // Worst-case defaults.
  reganch := #0;
  regmust := nil;
  regmlen := 0;
  Scan := programm + 1; // First BRANCH.
  if regnext (Scan)^ = EEND then
   begin // Only one top-level choice.
    Scan := Scan + 3;

    // Starting-point info.
    if Scan^ = EXACTLY
     then
     regstart := (Scan + 3)^
    else
     if Scan^ = BOL
      then Inc (reganch);

    // If there's something expensive in the r.e., find the longest
    // literal string that must appear and make it the regmust.  Resolve
    // ties in favor of later strings, since the regstart check works
    // with the beginning of the r.e. and avoiding duplication
    // strengthens checking.  Not a strong reason, but sufficient in the
    // absence of others.
    if (flags and SPSTART) <> 0 then
     begin
      longest := nil;
      Len := 0;
      while Scan <> nil do
       begin
        if (Scan^ = EXACTLY)
         and (StrLen (Scan + 3) >= Len) then
         begin
          longest := Scan + 3;
          Len := StrLen (Scan + 3);
         end;
        Scan := regnext (Scan);
       end;
      regmust := longest;
      regmlen := Len;
     end;
   end;

 finally regexpbeg := nil; //###0.90
 end; //###0.90
 
 fExprIsCompiled := True; //###0.90
 Result := True;
end; { of function TRegExpr.CompileRegExpr
--------------------------------------------------------------}

function TRegExpr.ParseReg (paren: Integer; var flagp: Integer): PRegExprChar;
// regular expression, i.e. main body or parenthesized thing
// Caller must absorb opening parenthesis.
// Combining parenthesis handling with the base level of regular expression
// is a trifle forced, but the need to tie the tails of the branches to what
// follows makes it hard to avoid.
var
 ret, br, ender: PRegExprChar;
 parno: Integer;
 flags: Integer;
 SavedModifiers: Integer;
begin
 Result := nil;
 flagp := HASWIDTH; // Tentatively.
 parno := 0; // eliminate compiler stupid warning
 SavedModifiers := fCompModifiers; //###0.90
 
 // Make an OPEN node, if parenthesized.
 if paren <> 0 then
  begin
   if regnpar >= NSUBEXP then
    begin
     Error (reeCompParseRegTooManyBrackets);
     Exit;
    end;
   parno := regnpar;
   Inc (regnpar);
   ret := EmitNode (REChar (Ord (OPEN) + parno));
  end
 else
  ret := nil;
 
 // Pick up the branches, linking them together.
 br := ParseBranch (flags);
 if br = nil then
  begin
   Result := nil;
   Exit;
  end;
 if ret <> nil
  then
  Tail (ret, br) // OPEN -> first.
 else
  ret := br;
 if (flags and HASWIDTH) = 0
  then flagp := flagp and not HASWIDTH;
 flagp := flagp or flags and SPSTART;
 while (regparse^ = '|') do
  begin
   Inc (regparse);
   br := ParseBranch (flags);
   if br = nil then
    begin
     Result := nil;
     Exit;
    end;
   Tail (ret, br); // BRANCH -> BRANCH.
   if (flags and HASWIDTH) = 0
    then flagp := flagp and not HASWIDTH;
   flagp := flagp or flags and SPSTART;
  end;
 
 // Make a closing node, and hook it on the end.
 if paren <> 0
  then
  ender := EmitNode (REChar (Ord (Close) + parno))
 else
  ender := EmitNode (EEND);
 Tail (ret, ender);
 
 // Hook the tails of the branches to the closing node.
 br := ret;
 while br <> nil do
  begin
   OpTail (br, ender);
   br := regnext (br);
  end;
 
 // Check for proper termination.
 if paren <> 0 then
  if regparse^ <> ')' then
   begin
    Error (reeCompParseRegUnmatchedBrackets);
    Exit; //###0.90
   end
  else
   Inc (regparse); // skip trailing ')'
 if (paren = 0) and (regparse^ <> #0) then
  begin
   if regparse^ = ')'
    then
    Error (reeCompParseRegUnmatchedBrackets2)
   else
    Error (reeCompParseRegJunkOnEnd);
   Exit;
  end;
 fCompModifiers := SavedModifiers; // restore modifiers of parent //###0.90
 Result := ret;
end; { of function TRegExpr.ParseReg
--------------------------------------------------------------}

function TRegExpr.ParseBranch (var flagp: Integer): PRegExprChar;
// one alternative of an | operator
// Implements the concatenation operator.
var
 ret, chain, latest: PRegExprChar;
 flags: Integer;
begin
 flagp := WORST; // Tentatively.
 
 ret := EmitNode (BRANCH);
 chain := nil;
 while (regparse^ <> #0) and (regparse^ <> '|')
  and (regparse^ <> ')') do
  begin
   latest := ParsePiece (flags);
   if latest = nil then
    begin
     Result := nil;
     Exit;
    end;
   flagp := flagp or flags and HASWIDTH;
   if chain = nil // First piece.
   then
    flagp := flagp or flags and SPSTART
   else
    Tail (chain, latest);
   chain := latest;
  end;
 if chain = nil // Loop ran zero times.
 then EmitNode (NOTHING);
 Result := ret;
end; { of function TRegExpr.ParseBranch
--------------------------------------------------------------}

function TRegExpr.ParsePiece (var flagp: Integer): PRegExprChar;
// something followed by possible [*+?{]
// Note that the branching code sequences used for ? and the general cases
// of * and + and { are somewhat optimized:  they use the same NOTHING node as
// both the endmarker for their branch list and the body of the last branch.
// It might seem that this node could be dispensed with entirely, but the
// endmarker role is not redundant.

 function parsenum (AStart, AEnd: PRegExprChar): Integer;
 begin
  Result := 0;
  if AEnd - AStart + 1 > 3 then
   begin
    Error (reeBRACESArgTooBig);
    Exit;
   end;
  while AStart <= AEnd do
   //    if not (AStart^ in ['0' .. '9']) then begin //###0.92
   //       Error (reeBRACEBadArg);
   //       EXIT;
   //      end
   //     else
   begin
    Result := Result * 10 + (Ord (AStart^) - Ord ('0'));
    Inc (AStart);
   end;
  if Result > BracesMax then
   begin
    Error (reeBRACESArgTooBig);
    Exit;
   end;
 end;
var
 op: REChar;
 NextNode: PRegExprChar;
 flags: Integer;
 Min, Max: Integer;
 p, savedparse: PRegExprChar;
 {$IFDEF ComplexBraces}
 off: Integer;
 {$ENDIF}
begin
 Result := ParseAtom (flags);
 if Result = nil
  then Exit;
 
 op := regparse^;
 if not ((op = '*') or (op = '+') or (op = '?') or (op = '{')) then
  begin //###0.90
   flagp := flags;
   Exit;
  end;
 if ((flags and HASWIDTH) = 0) and (op <> '?') then
  begin
   Error (reePlusStarOperandCouldBeEmpty);
   Exit;
  end;

 case op of //###0.92
  '*':
   begin
    flagp := WORST or SPSTART; //###0.92
    if (flags and SIMPLE) = 0 then
     begin
      // Emit x* as (x&|), where & means "self".
      InsertOperator (BRANCH, Result, 3); // Either x
      OpTail (Result, EmitNode (Back)); // and loop
      OpTail (Result, Result); // back
      Tail (Result, EmitNode (BRANCH)); // or
      Tail (Result, EmitNode (NOTHING)); // nil.
     end
    else
     InsertOperator (STAR, Result, 3);
   end; { of case '*'}
  '+':
   begin
    flagp := WORST or SPSTART or HASWIDTH; //###0.92
    if (flags and SIMPLE) = 0 then
     begin
      // Emit x+ as x(&|), where & means "self".
      NextNode := EmitNode (BRANCH); // Either
      Tail (Result, NextNode);
      Tail (EmitNode (Back), Result); // loop back
      Tail (NextNode, EmitNode (BRANCH)); // or
      Tail (Result, EmitNode (NOTHING)); // nil.
     end
    else
     InsertOperator (PLUS, Result, 3);
   end; { of case '+'}
  '?':
   begin
    flagp := WORST; //###0.92
    // Emit x? as (x|)
    InsertOperator (BRANCH, Result, 3); // Either x
    Tail (Result, EmitNode (BRANCH)); // or
    NextNode := EmitNode (NOTHING); // nil.
    Tail (Result, NextNode);
    OpTail (Result, NextNode);
   end; { of case '?'}
  '{':
   begin //###0.90 begin
    savedparse := regparse;
    Inc (regparse);
    p := regparse;
    while Pos (regparse^, '0123456789') > 0 //###0.92 <min> must appear
    do
     Inc (regparse);
    if (regparse^ <> '}') and (regparse^ <> ',') or (p = regparse) then
     begin //###0.92
      // Error (reeUmatchedBraces); //###0.92
      regparse := savedparse; //###0.92 - if any error - compile as nonmacro
      flagp := flags;
      Exit;
     end;
    Min := parsenum (p, regparse - 1);
    if regparse^ = ',' then
     begin
      Inc (regparse);
      p := regparse;
      while Pos (regparse^, '0123456789') > 0 //###0.92
      do
       Inc (regparse);
      if regparse^ <> '}' then
       begin
        // Error (reeUmatchedBraces2); //###0.92
        regparse := savedparse;
        Exit;
       end;
      if p = regparse //###0.92
      then
       Max := BracesMax
      else
       Max := parsenum (p, regparse - 1);
     end
    else
     Max := Min; // {n} == {n,n}
    if Min > Max then
     begin
      Error (reeBracesMinParamGreaterMax);
      Exit;
     end;
    if Min > 0 //###0.92
    then flagp := WORST;
    if Max > 0 //###0.92
    then flagp := flagp or HASWIDTH or SPSTART;
    if (flags and SIMPLE) <> 0 then
     begin
      InsertOperator (BRACES, Result, 5);
      if regcode <> @regdummy then
       begin
         (Result + 3)^ := REChar (Min);
         (Result + 4)^ := REChar (Max);
       end;
     end
    else
     begin // Emit complex x{min,max}
      {$IFNDEF ComplexBraces}
      Error (reeComplexBracesNotImplemented); //###0.925
      Exit;
      {$ELSE}
      InsertOperator (LOOPENTRY, Result, 3);
      NextNode := EmitNode (LOOP);
      if regcode <> @regdummy then
       begin
        off := regcode - 3 - (Result + 3); // back to Atom after LOOPENTRY
        regcode^ := REChar (Min);
        Inc (regcode);
        regcode^ := REChar (Max);
        Inc (regcode);
        regcode^ := REChar ((off shr 8) and $FF);
        Inc (regcode);
        regcode^ := REChar (off and $FF);
        Inc (regcode);
       end
      else
       Inc (regsize, 4);
      Tail (Result, NextNode); // LOOPENTRY -> LOOP
      if regcode <> @regdummy then
       Tail (Result + 3, NextNode); // Atom -> LOOP
      {$ENDIF}
     end;
   end; { of case '{'}
  //###0.90 end
//    else // here we can't be
 end; { of case op}
 
 Inc (regparse);
 if (regparse^ = '*') or (regparse^ = '+') or (regparse^ = '?') or (regparse^ = '{') then
  begin //###0.90
   Error (reeNestedSQP);
   Exit;
  end;
end; { of function TRegExpr.ParsePiece
--------------------------------------------------------------}

function TRegExpr.ParseAtom (var flagp: Integer): PRegExprChar;
// the lowest level
// Optimization:  gobbles an entire sequence of ordinary characters so that
// it can turn them into a single node, which is smaller to store and
// faster to run.  Backslashed characters are exceptions, each becoming a
// separate node; the code is simpler that way and it's not worth fixing.
var
 ret: PRegExprChar;
 flags: Integer;
 RangeBeg, RangeEnd: REChar;
 Len: Integer;
 ender: REChar;
 n: Integer;
 begmodfs: PRegExprChar;

 procedure EmitExactly (ch: REChar);
 begin
  if (fCompModifiers and MaskModI) = MaskModI //###0.90
  then
   ret := EmitNode (EXACTLYCI)
  else
   ret := EmitNode (EXACTLY);
  EmitC (ch);
  EmitC (#0);
  flagp := flagp or HASWIDTH or SIMPLE;
 end;
 
 procedure EmitStr (const s: RegExprString);
 var
  i: Integer;
 begin
  for i := 1 to Length (s)
   do
   EmitC (s [i]);
 end;
 
 function HexDig (ch: REChar): Integer;
 begin
  Result := 0;
  if (ch >= 'a') and (ch <= 'f')
   then ch := REChar (Ord (ch) - (Ord ('a') - Ord ('A')));
  if (ch < '0') or (ch > 'F') or ((ch > '9') and (ch < 'A')) then
   begin
    Error (reeBadHexDigit);
    Exit;
   end;
  Result := Ord (ch) - Ord ('0');
  if ch >= 'A'
   then Result := Result - (Ord ('A') - Ord ('9') - 1);
 end;
begin
 Result := nil;
 flagp := WORST; // Tentatively.
 
 Inc (regparse);
 case (regparse - 1)^ of
  '^': ret := EmitNode (BOL);
  '$': ret := EmitNode (EOL);
  '.':
   if (fCompModifiers and MaskModS) = MaskModS then
    begin //###0.926
     ret := EmitNode (ANY);
     flagp := flagp or HASWIDTH or SIMPLE;
    end
   else
    begin // not /s, so emit [^\n]
     ret := EmitNode (ANYBUT);
     EmitC (#$A);
     EmitC (#0);
     flagp := flagp or HASWIDTH or SIMPLE;
    end;
  '[':
   begin
    if regparse^ = '^' then
     begin // Complement of range.
      if (fCompModifiers and MaskModI) = MaskModI //###0.92
      then
       ret := EmitNode (ANYBUTCI)
      else
       ret := EmitNode (ANYBUT);
      Inc (regparse);
     end
    else
     if (fCompModifiers and MaskModI) = MaskModI //###0.92
     then
      ret := EmitNode (ANYOFCI)
     else
      ret := EmitNode (ANYOF);

    if (regparse^ = ']') or (regparse^ = '-') then
     begin
      EmitC (regparse^);
      Inc (regparse);
     end;
    while (regparse^ <> #0) and (regparse^ <> ']') do
     begin
      if regparse^ = '-' then
       begin
        Inc (regparse);
        if (regparse^ = ']') or (regparse^ = #0)
         then
         EmitC ('-')
        else
         begin
          RangeBeg := (regparse - 2)^;
          RangeEnd := regparse^;

          {$IFDEF ExtendedSyntax} // RJ 11.03.2000
          // r.e.ranges extension for russian
          if ((fCompModifiers and MaskModR) = MaskModR)
           and (RangeBeg = RusRangeLoLow) and (RangeEnd = RusRangeLoHigh) then
           begin
            EmitStr (RusRangeLo);
           end
          else
           if ((fCompModifiers and MaskModR) = MaskModR)
            and (RangeBeg = RusRangeHiLow) and (RangeEnd = RusRangeHiHigh) then
            begin
             EmitStr (RusRangeHi);
            end
           else
            if ((fCompModifiers and MaskModR) = MaskModR)
             and (RangeBeg = RusRangeLoLow) and (RangeEnd = RusRangeHiHigh) then
             begin
              EmitStr (RusRangeLo);
              EmitStr (RusRangeHi);
             end
            else
             begin // standard r.e. handling
              {$ENDIF} // RJ 11.03.2000
              if RangeBeg > RangeEnd then
               begin
                Error (reeInvalidRange);
                Exit;
               end;
              Inc (RangeBeg);
              while RangeBeg <= RangeEnd do
               begin
                EmitC (RangeBeg);
                Inc (RangeBeg);
               end;
              {$IFDEF ExtendedSyntax} // RJ 11.03.2000
             end;
          {$ENDIF} // RJ 11.03.2000
          Inc (regparse);
         end;
       end
      else
       begin
        if regparse^ = '\' then
         begin
          Inc (regparse);
          if regparse^ = #0 then
           begin
            Error (reeParseAtomTrailingBackSlash);
            Exit;
           end;
          case regparse^ of // r.e.extensions
           'd': EmitStr ('0123456789');
           'w':
            EmitStr ('abcdefghijklmnopqrstuvwxyz'
             + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ_');
           't': EmitC (#$9); // tab (HT/TAB)
           'n': EmitC (#$A); // newline (NL)
           'r': EmitC (#$D); // car.return (CR)
           'f': EmitC (#$C); // form feed (FF)     //###0.8
           'a': EmitC (#$7); // alarm (bell) (BEL) //###0.8
           'e': EmitC (#$1B); // escape (ESC)
           'x':
            begin // hex char
             Inc (regparse);
             if regparse^ = #0 then
              begin
               Error (reeNoHexCodeAfterBSlashX);
               Exit;
              end;
             n := HexDig (regparse^);
             Inc (regparse);
             if regparse^ = #0 then
              begin
               Error (reeNoHexCodeAfterBSlashX2);
               Exit;
              end;
             n := (n shl 4) or HexDig (regparse^);
             EmitC (REChar (n)); // r.e.extension
            end;
           else
            EmitC (regparse^);
          end; { of case}
         end
        else
         begin
          EmitC (regparse^);
         end;
        Inc (regparse);
       end;
     end; { of while}
    EmitC (#0);
    if regparse^ <> ']' then
     begin
      Error (reeUnmatchedSqBrackets);
      Exit;
     end;
    Inc (regparse);
    flagp := flagp or HASWIDTH or SIMPLE;
   end;
  '(':
   begin
    if regparse^ = '?' then
     begin //###0.90
      // check for extended Perl syntax : (?..)
      if (regparse + 1)^ = '#' then
       begin // (?#comment)
        Inc (regparse, 2); // find closing ')'
        while (regparse^ <> #0) and (regparse^ <> ')')
         do
         Inc (regparse);
        if regparse^ <> ')' then
         begin
          Error (reeUnclosedComment);
          Exit;
         end;
        Inc (regparse); // skip ')'
        ret := EmitNode (COMMENT); // comment
       end
      else
       begin // modifiers ?
        Inc (regparse); // skip '?'
        begmodfs := regparse;
        while (regparse^ <> #0) and (regparse^ <> ')')
         do
         Inc (regparse);
        if (regparse^ <> ')')
         or not SetModifiersInt (Copy (begmodfs, 1, (regparse - begmodfs)), fCompModifiers) then
         begin
          Error (reeUrecognizedModifier);
          Exit;
         end;
        Inc (regparse); // skip ')'
        ret := EmitNode (COMMENT); // comment
        //             Error (reeQPSBFollowsNothing);
        //             EXIT;
       end;
     end
    else
     begin
      ret := ParseReg (1, flags);
      if ret = nil then
       begin
        Result := nil;
        Exit;
       end;
      flagp := flagp or flags and (HASWIDTH or SPSTART);
     end;
   end;
  #0, '|', ')':
   begin // Supposed to be caught earlier.
    Error (reeInternalUrp);
    Exit;
   end;
  '?', '+', '*':
   begin //###0.92
    Error (reeQPSBFollowsNothing);
    Exit;
   end;
  '\':
   begin
    if regparse^ = #0 then
     begin
      Error (reeTrailingBackSlash);
      Exit;
     end;
    case regparse^ of // r.e.extensions
     'd':
      begin // r.e.extension - any digit ('0' .. '9')
       ret := EmitNode (ANYDIGIT);
       flagp := flagp or HASWIDTH or SIMPLE;
      end;
     's':
      begin // r.e.extension - any space char //###0.8
       ret := EmitNode (ANYSPACE);
       flagp := flagp or HASWIDTH or SIMPLE;
      end;
     'w':
      begin // r.e.extension - any english char or '_'
       ret := EmitNode (ANYLETTER);
       flagp := flagp or HASWIDTH or SIMPLE;
      end;
     'D':
      begin // r.e.extension - not digit ('0' .. '9')
       ret := EmitNode (NOTDIGIT);
       flagp := flagp or HASWIDTH or SIMPLE;
      end;
     'S':
      begin // r.e.extension - not space char //###0.8
       ret := EmitNode (NOTSPACE);
       flagp := flagp or HASWIDTH or SIMPLE;
      end;
     'W':
      begin // r.e.extension - not english char or '_'
       ret := EmitNode (NOTLETTER);
       flagp := flagp or HASWIDTH or SIMPLE;
      end;
     't': EmitExactly (#$9); // tab (HT/TAB) //###0.927
     'n': EmitExactly (#$A); // newline (NL) //###0.927
     'r': EmitExactly (#$D); // car.return (CR) //###0.927
     'f': EmitExactly (#$C); // form feed (FF)     //###0.8 //###0.927
     'a': EmitExactly (#$7); // alarm (bell) (BEL) //###0.8 //###0.927
     'e': EmitExactly (#$1B); // escape (ESC) //###0.927
     'x':
      begin
       Inc (regparse);
       if regparse^ = #0 then
        begin
         Error (reeNoHexCodeAfterBSlashX3);
         Exit;
        end;
       n := HexDig (regparse^);
       Inc (regparse);
       if regparse^ = #0 then
        begin
         Error (reeNoHexCodeAfterBSlashX4);
         Exit;
        end;
       n := (n shl 4) or HexDig (regparse^);
       EmitExactly (REChar (n)); // r.e.extension
      end;
     else
      begin
       EmitExactly (regparse^);
       //ret := EmitNode (EXACTLY);
       //EmitC (regparse^);
       //EmitC (#0);
       //flagp := flagp or HASWIDTH or SIMPLE;
      end;
    end; { of case}
    Inc (regparse);
   end;
  else
   begin
    Dec (regparse);
    Len := strcspn (regparse, META);
    if Len <= 0 then //###0.92
     if regparse^ <> '{' then
      begin
       Error (reeRarseAtomInternalDisaster);
       Exit;
      end
     else
      Len := strcspn (regparse + 1, META) + 1; // bad {n,m} - compile as EXATLY
    ender := (regparse + Len)^;
    if (Len > 1)
     and ((ender = '*') or (ender = '+') or (ender = '?') or (ender = '{')) //###0.90
    then Dec (Len); // Back off clear of ?+*{ operand.
    flagp := flagp or HASWIDTH;
    if Len = 1
     then flagp := flagp or SIMPLE;
    if (fCompModifiers and MaskModI) = MaskModI
     then
     ret := EmitNode (EXACTLYCI) //###0.90
    else
     ret := EmitNode (EXACTLY);
    while Len > 0 do
     begin
      EmitC (regparse^);
      Inc (regparse);
      Dec (Len);
     end;
    EmitC (#0);
   end; { of case else}
 end; { of case}
 
 Result := ret;
end; { of function TRegExpr.ParseAtom
--------------------------------------------------------------}

function TRegExpr.GetCompilerErrorPos: Integer; //###0.90
begin
 Result := 0;
 if (regexpbeg = nil) or (regparse = nil)
  then Exit; // not in compiling mode ?
 Result := regparse - regexpbeg;
end; { of function TRegExpr.GetCompilerErrorPos
--------------------------------------------------------------}

{=============================================================}
{===================== Matching section ======================}
{=============================================================}

function TRegExpr.StrScanCI (s: PRegExprChar; ch: REChar): PRegExprChar; //###0.928 - now method of TRegExpr
begin
 // RJ 11.03.2000 while (s^ <> #0) and (UpperCase (s^) <> UpperCase (ch))
 while (s^ <> #0) and (FUpperCaseFunction (s^) <> FUpperCaseFunction (ch)) // RJ 11.03.2000
 do
  Inc (s);
 if s^ <> #0
  then
  Result := s
 else
  Result := nil;
end; { of function TRegExpr.StrScanCI
--------------------------------------------------------------}

function TRegExpr.regrepeat (p: PRegExprChar; AMax: Integer): Integer;
// repeatedly match something simple, report how many
//###0.92 slightly optimized - AMax added, now can proceed pascal-
// -style strings (with #0)
var
 Scan: PRegExprChar;
 opnd: PRegExprChar;
 TheMax: Integer; //###0.92
begin
 Result := 0;
 Scan := RegInput;
 opnd := p + 3; //OPERAND
 TheMax := regeol - Scan; //###0.92
 if TheMax > AMax
  then TheMax := AMax;
 case p^ of
  ANY:
   begin
    Result := TheMax; //###0.92
    Inc (Scan, Result);
   end;
  EXACTLY:
   while (Result < TheMax) and (opnd^ = Scan^) do
    begin //###0.92
     Inc (Result);
     Inc (Scan);
    end;
  EXACTLYCI: //###0.90
   while (Result < TheMax) and //###0.92
   // RJ 11.03.2000 (UpperCase (opnd^) = UpperCase (Scan^)) do
    (FUpperCaseFunction (opnd^) = FUpperCaseFunction (Scan^)) do // RJ 11.03.2000
    begin
     Inc (Result);
     Inc (Scan);
    end;
  ANYLETTER:
   while (Result < TheMax) and //###0.92
    ((Scan^ >= 'a') and (Scan^ <= 'z')
    or (Scan^ >= 'A') and (Scan^ <= 'Z') or (Scan^ = '_')) do
    begin
     Inc (Result);
     Inc (Scan);
    end;
  NOTLETTER:
   while (Result < TheMax) and //###0.92
   not ((Scan^ >= 'a') and (Scan^ <= 'z')
    or (Scan^ >= 'A') and (Scan^ <= 'Z')
    or (Scan^ = '_')) do
    begin
     Inc (Result);
     Inc (Scan);
    end;
  ANYDIGIT:
   while (Result < TheMax) and //###0.92
    (Scan^ >= '0') and (Scan^ <= '9') do
    begin
     Inc (Result);
     Inc (Scan);
    end;
  NOTDIGIT:
   while (Result < TheMax) and //###0.92
    ((Scan^ < '0') or (Scan^ > '9')) do
    begin
     Inc (Result);
     Inc (Scan);
    end;
  ANYSPACE: //###0.8
   while (Result < TheMax) and //###0.92
    (Pos (Scan^, FSpaceChars) > 0) do
    begin
     Inc (Result);
     Inc (Scan);
    end;
  NOTSPACE: //###0.8
   while (Result < TheMax) and //###0.92
    (Pos (Scan^, FSpaceChars) <= 0) do
    begin
     Inc (Result);
     Inc (Scan);
    end;
  ANYOF:
   while (Result < TheMax) and //###0.92
    (StrScan (opnd, Scan^) <> nil) do
    begin
     Inc (Result);
     Inc (Scan);
    end;
  ANYBUT:
   while (Result < TheMax) and //###0.92
    (StrScan (opnd, Scan^) = nil) do
    begin
     Inc (Result);
     Inc (Scan);
    end;
  ANYOFCI: //###0.92
   while (Result < TheMax) and (StrScanCI (opnd, Scan^) <> nil) do
    begin
     Inc (Result);
     Inc (Scan);
    end;
  ANYBUTCI: //###0.92
   while (Result < TheMax) and (StrScanCI (opnd, Scan^) = nil) do
    begin
     Inc (Result);
     Inc (Scan);
    end;
  else
   begin // Oh dear.  Called inappropriately.
    Result := 0; // Best compromise.
    Error (reeRegRepeatCalledInappropriately);
    Exit;
   end;
 end; { of case}
 RegInput := Scan;
end; { of function TRegExpr.regrepeat
--------------------------------------------------------------}

function TRegExpr.regnext (p: PRegExprChar): PRegExprChar;
// dig the "next" pointer out of a node
var
 OffSet: Integer;
begin
 Result := nil;
 if p = @regdummy
  then Exit;
 
 OffSet := Next (p);
 if OffSet = 0
  then Exit;
 
 if p^ = Back
  then
  Result := p - OffSet
 else
  Result := p + OffSet;
end; { of function TRegExpr.regnext
--------------------------------------------------------------}

function TRegExpr.MatchPrim (prog: PRegExprChar): Boolean;
// recursively matching routine
// Conceptually the strategy is simple:  check to see whether the current
// node matches, call self recursively to see whether the rest matches,
// and then act accordingly.  In practice we make some effort to avoid
// recursion, in particular by going through "ordinary" nodes (that don't
// need to know whether the rest of the match failed) by a loop instead of
// by recursion.
var
 Scan: PRegExprChar; // Current node.
 Next: PRegExprChar; // Next node.
 Len: Integer;
 opnd: PRegExprChar;
 no: Integer;
 save: PRegExprChar;
 nextch: REChar;
 Min, Max: Integer;
 {$IFDEF ComplexBraces}
 SavedLoopStack: array [1..LoopStackMax] of Integer; // :(( very bad for recursion //###0.925
 SavedLoopStackIdx: Integer; //###0.925
 {$ENDIF}
begin
 Result := False;
 Scan := prog;
 
 while Scan <> nil do
  begin
   Next := regnext (Scan);
   case Scan^ of
    BOL:
     if RegInput <> RegBol
      then Exit;
    EOL:
     if RegInput^ <> #0
      then Exit;
    ANY:
     begin
      if RegInput^ = #0
       then Exit;
      Inc (RegInput);
     end;
    ANYLETTER:
     begin
      if (RegInput^ = #0) or
       not ((RegInput^ >= 'a') and (RegInput^ <= 'z')
       or (RegInput^ >= 'A') and (RegInput^ <= 'Z')
       or (RegInput^ = '_'))
       then Exit;
      Inc (RegInput);
     end;
    NOTLETTER:
     begin
      if (RegInput^ = #0) or
        (RegInput^ >= 'a') and (RegInput^ <= 'z')
       or (RegInput^ >= 'A') and (RegInput^ <= 'Z')
       or (RegInput^ = '_')
       then Exit;
      Inc (RegInput);
     end;
    ANYDIGIT:
     begin
      if (RegInput^ = #0) or (RegInput^ < '0') or (RegInput^ > '9')
       then Exit;
      Inc (RegInput);
     end;
    NOTDIGIT:
     begin
      if (RegInput^ = #0) or ((RegInput^ >= '0') and (RegInput^ <= '9'))
       then Exit;
      Inc (RegInput);
     end;
    ANYSPACE:
     begin //###0.8
      if (RegInput^ = #0) or not (Pos (Scan^, FSpaceChars) > 0)
       then Exit;
      Inc (RegInput);
     end;
    NOTSPACE:
     begin //###0.8
      if (RegInput^ = #0) or (Pos (Scan^, FSpaceChars) > 0)
       then Exit;
      Inc (RegInput);
     end;
    EXACTLYCI:
     begin //###0.90
      opnd := Scan + 3; // OPERAND
      // Inline the first character, for speed.
      // RJ 11.03.2000 if UpperCase (opnd^) <> UpperCase (RegInput^)
      if FUpperCaseFunction (opnd^) <> FUpperCaseFunction (RegInput^) // RJ 11.03.2000
      then Exit;
      Len := StrLen (opnd);
      if (Len > 1) and (StrLIComp (opnd, RegInput, Len) <> 0)
       then Exit;
      Inc (RegInput, Len);
     end;
    EXACTLY:
     begin
      opnd := Scan + 3; // OPERAND
      // Inline the first character, for speed.
      if opnd^ <> RegInput^
       then Exit;
      Len := StrLen (opnd);
      if (Len > 1) and (StrLComp (opnd, RegInput, Len) <> 0)
       then Exit;
      Inc (RegInput, Len);
     end;
    ANYOF:
     begin
      if (RegInput^ = #0) or (StrScan (Scan + 3, RegInput^) = nil)
       then Exit;
      Inc (RegInput);
     end;
    ANYBUT:
     begin
      if (RegInput^ = #0) or (StrScan (Scan + 3, RegInput^) <> nil)
       then Exit; //###0.7 was skipped (found by Jan Korycan)
      Inc (RegInput);
     end;
    ANYOFCI:
     begin //###0.92
      if (RegInput^ = #0) or (StrScanCI (Scan + 3, RegInput^) = nil)
       then Exit;
      Inc (RegInput);
     end;
    ANYBUTCI:
     begin //###0.92
      if (RegInput^ = #0) or (StrScanCI (Scan + 3, RegInput^) <> nil)
       then Exit;
      Inc (RegInput);
     end;
    NOTHING: ;
    COMMENT: ; //###0.90
    Back: ;
    Succ (OPEN)..REChar (Ord (OPEN) + 9):
     begin
      no := Ord (Scan^) - Ord (OPEN);
      save := RegInput;
      Result := MatchPrim (Next);
      if Result and (startp [no] = nil)
       then startp [no] := save;
      // Don't set startp if some later invocation of the same
      // parentheses already has.
      Exit;
     end;
    Succ (Close)..REChar (Ord (Close) + 9):
     begin
      no := Ord (Scan^) - Ord (Close);
      save := RegInput;
      Result := MatchPrim (Next);
      if Result and (endp [no] = nil)
       then endp [no] := save;
      // Don't set endp if some later invocation of the same
      // parentheses already has.
      Exit;
     end;
    BRANCH:
     begin
      if (Next^ <> BRANCH) // No choice.
      then
       Next := Scan + 3 // Avoid recursion.
      else
       begin
        repeat
         save := RegInput;
         Result := MatchPrim (Scan + 3);
         if Result
          then Exit;
         RegInput := save;
         Scan := regnext (Scan);
        until (Scan = nil) or (Scan^ <> BRANCH);
        Exit;
       end;
     end;
    {$IFDEF ComplexBraces}
    LOOPENTRY:
     begin //###0.925
      no := LoopStackIdx;
      Inc (LoopStackIdx);
      if LoopStackIdx > LoopStackMax then
       begin
        Error (reeLoopStackExceeded);
        Exit;
       end;
      save := RegInput;
      LoopStack [LoopStackIdx] := 0; // init loop counter
      Result := MatchPrim (Next); // execute LOOP
      LoopStackIdx := no; // cleanup
      if Result
       then Exit;
      RegInput := save;
      Exit;
     end;
    LOOP:
     begin //###0.925
      if LoopStackIdx <= 0 then
       begin
        Error (reeLoopWithoutEntry);
        Exit;
       end;
      opnd := Scan - (Ord ((Scan + 5)^) * 256 + Ord ((Scan + 6)^));
      Min := Ord ((Scan + 3)^);
      Max := Ord ((Scan + 4)^);
      save := RegInput;
      if LoopStack [LoopStackIdx] >= Min then
       begin
        // greedy way ;)
        if LoopStack [LoopStackIdx] < Max then
         begin
          Inc (LoopStack [LoopStackIdx]);
          no := LoopStackIdx;
          Result := MatchPrim (opnd);
          LoopStackIdx := no;
          if Result
           then Exit;
          RegInput := save;
         end;
        Dec (LoopStackIdx);
        Result := MatchPrim (Next);
        if not Result
         then RegInput := save;
        Exit;
       end
      else
       begin // first match a min times
        Inc (LoopStack [LoopStackIdx]);
        no := LoopStackIdx;
        Result := MatchPrim (opnd);
        LoopStackIdx := no;
        if Result
         then Exit;
        Dec (LoopStack [LoopStackIdx]);
        RegInput := save;
        Exit;
       end;
     end;
    {$ENDIF}
    STAR, PLUS, BRACES:
     begin //###0.90
      // Lookahead to avoid useless match attempts when we know
      // what character comes next.
      nextch := #0;
      if Next^ = EXACTLY
       then nextch := (Next + 3)^;
      Max := MaxInt; // infinite loop for * and + //###0.92
      if Scan^ = STAR
       then
       Min := 0 // STAR
      else
       if Scan^ = PLUS
        then
        Min := 1 // PLUS
       else
        begin // BRACES //###0.90
         Min := Ord ((Scan + 3)^);
         Max := Ord ((Scan + 4)^);
        end;
      save := RegInput;
      //###0.90 begin
      opnd := Scan + 3;
      if Scan^ = BRACES
       then Inc (opnd, 2);
      no := regrepeat (opnd, Max); //###0.92 don't repeat more than max
      //###0.90 end
      while no >= Min do
       begin
        // If it could work, try it.
        if (nextch = #0) or (RegInput^ = nextch) then
         begin
          {$IFDEF ComplexBraces}
          System.Move (LoopStack, SavedLoopStack, SizeOf (LoopStack)); //###0.925
          SavedLoopStackIdx := LoopStackIdx;
          {$ENDIF}
          if MatchPrim (Next) then
           begin
            Result := True;
            Exit;
           end;
          {$IFDEF ComplexBraces}
          System.Move (SavedLoopStack, LoopStack, SizeOf (LoopStack));
          LoopStackIdx := SavedLoopStackIdx;
          {$ENDIF}
         end;
        Dec (no); // Couldn't or didn't - back up.
        RegInput := save + no;
       end; { of while}
      Exit;
     end;
    EEND:
     begin
      Result := True; // Success!
      Exit;
     end;
    else
     begin
      Error (reeMatchPrimMemoryCorruption);
      Exit;
     end;
   end; { of case scan^}
   Scan := Next;
  end; { of while scan <> nil}
 
 // We get here only if there's trouble -- normally "case EEND" is the
 // terminating point.
 Error (reeMatchPrimCorruptedPointers);
end; { of function TRegExpr.MatchPrim
--------------------------------------------------------------}

function TRegExpr.RegMatch (Str: PRegExprChar): Boolean;
// try match at specific point
var
 i: Integer;
begin
 { // RJ 11.03.2000
 for i := 0 to NSUBEXP - 1 do
  begin
   startp [i] := nil;
   endp [i] := nil;
  end; }
 FillChar (startp, (NSUBEXP) * SizeOf (PRegExprChar), 0); // RJ 11.03.2000
 FillChar (endp, (NSUBEXP) * SizeOf (PRegExprChar), 0); // RJ 11.03.2000
 
 RegInput := Str;
 Result := MatchPrim (programm + 1);
 if Result then
  begin
   startp [0] := Str;
   endp [0] := RegInput;
   //    startp [1] := nil //###0.4 bugfix by Stephan Klimek
  end;
end; { of function TRegExpr.RegMatch
--------------------------------------------------------------}

//###0.90 begin

function TRegExpr.Exec (const AInputString: RegExprString): Boolean; //###0.81 added Offset
begin
 InputString := AInputString;
 Result := ExecPrim (1);
end; { of function TRegExpr.Exec
--------------------------------------------------------------}

function TRegExpr.ExecPrim (AOffset: Integer): Boolean; //###0.90
var
 s: PRegExprChar;
 StartPtr: PRegExprChar; //###0.81 Starting point for search
 InputLen: Integer; //###0.92
begin
 Result := False; // Be paranoid...
 
 { // RJ 11.03.2000.
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
  end;}
 CheckProgram; // RJ 11.03.2000.
 
 // Check InputString presence
 {// RJ 11.03.2000 if not Assigned (FInputString) then
  begin //###0.90
   Error (reeNoInpitStringSpecified);
   Exit;
  end;}
 
 InputLen := Length (FInputString); //###0.92
 
 //###0.81 Start
 //Check that the start position is not negative
 if AOffset < 1 then
  begin
   Error (reeOffsetMustBeGreaterThen0);
   Exit;
  end;
 // Check that the start position is not longer than the line
 // If so then exit with nothing found
 if AOffset > (InputLen + 1) //###0.90 - for matching
 then Exit; // empty string after last char.
 //###0.81 End
 
// RJ 11.03.2000 StartPtr := FInputString + AOffset - 1; //###0.81
 StartPtr := PRegExprChar (FInputString) + AOffset - 1; // RJ 11.03.2000
 
 // If there is a "must appear" string, look for it.
 if regmust <> nil then
  begin
   // s := fInputString; //###0.81
   s := StartPtr; //###0.81
   repeat
    s := StrScan (s, regmust [0]);
    if s <> nil then
     begin
      if StrLComp (s, regmust, regmlen) = 0
       then Break; // Found it.
      Inc (s);
     end;
   until s = nil;
   if s = nil // Not present.
   then Exit;
  end;
 // Mark beginning of line for ^ .
// RJ 11.03.2000 RegBol := FInputString;
 RegBol := PRegExprChar (FInputString); // RJ 11.03.2000
 
 // Pointer to end of input stream - for
 // pascal-style string processing (may include #0)
// RJ 11.03.2000 regeol := FInputString + InputLen;
 regeol := RegBol + InputLen; // RJ 11.03.2000
 
 {$IFDEF ComplexBraces}
 // no loops started
 LoopStackIdx := 0; //###0.925
 {$ENDIF}
 
 // Simplest case:  anchored match need be tried only once.
 if reganch <> #0 then
  begin
   // Result := RegMatch (fInputString); //###0.81
   Result := RegMatch (StartPtr); //###0.81
   Exit;
  end;
 
 // Messy cases:  unanchored match.
 // s := fInputString; //###0.81
 s := StartPtr; //###0.81
 if regstart <> #0 then // We know what char it must start with.
  repeat
   s := StrScan (s, regstart);
   if s <> nil then
    begin
     Result := RegMatch (s);
     if Result
      then Exit;
     Inc (s);
    end;
  until s = nil
 else // We don't - general case.
  repeat
   Result := RegMatch (s);
   if Result
    then Exit;
   Inc (s);
  until s^ = #0;
 // Failure
end; { of function TRegExpr.ExecPrim
--------------------------------------------------------------}

function TRegExpr.ExecNext: Boolean; //###0.90
var
 OffSet: Integer;
begin
 Result := False;
 if not Assigned (startp [0]) or not Assigned (endp [0]) then
  begin
   Error (reeExecNextWithoutExec);
   Exit;
  end;
 // RJ 11.03.2000  Offset := MatchPos [0] + MatchLen [0];
 OffSet := endp [0] - RegBol + 1; // RJ 11.03.2000
 // RJ 11.03.2000 if MatchLen [0] = 0 // prevent infinite looping - thanks Jon Smith
 if endp [0] = startp [0] // RJ 11.03.2000
 then Inc (OffSet);
 Result := ExecPrim (OffSet);
end; { of function TRegExpr.ExecNext
--------------------------------------------------------------}

function TRegExpr.ExecPos (AOffset: Integer{$IFDEF D4_} = 1{$ENDIF}): Boolean; //###0.90
begin
 Result := ExecPrim (AOffset);
end; { of function TRegExpr.ExecPos
--------------------------------------------------------------}

{ // RJ 11.03.2000
function TRegExpr.GetInputString: RegExprString; //###0.90
begin
 if not Assigned (FInputString) then
  begin
   Error (reeGetInputStringWithoutInputString);
   Exit;
  end;
 Result := FInputString;
end; { of function TRegExpr.GetInputString
--------------------------------------------------------------}

procedure TRegExpr.SetInputString (const AInputString: RegExprString); //###0.90
var
 Len: Integer;
 i: Integer;
begin
 // clear Match* - before next Exec* call it's undefined
 { // RJ 11.03.2000
 for i := 0 to NSUBEXP - 1 do
  begin
   startp [i] := nil;
   endp [i] := nil;
  end;}
 FillChar (startp, (NSUBEXP) * SizeOf (PRegExprChar), 0); // RJ 11.03.2000
 FillChar (endp, (NSUBEXP) * SizeOf (PRegExprChar), 0); // RJ 11.03.2000
 
 { // RJ 11.03.2000
 // need reallocation of input string buffer ?
 Len := Length (AInputString);
 if Assigned (FInputString) and (Length (FInputString) <> Len) then
  begin
   FreeMem (FInputString);
   FInputString := nil;
  end;
 // buffer [re]allocation
 if not Assigned (FInputString)
  then GetMem (FInputString, (Len + 1) * SizeOf (REChar));
  }
 
 // copy input string into buffer
 {$IFDEF UniCode}
 // RJ 11.03.2000 StrPCopy (FInputString, Copy (AInputString, 1, Len)); //###0.927
 {$ELSE}
 // RJ 11.03.2000 StrLCopy (FInputString, PRegExprChar (AInputString), Len);
 {$ENDIF}
 
 FInputString := AInputString; // RJ 11.03.2000
 
end; { of procedure TRegExpr.SetInputString
--------------------------------------------------------------}
//###0.90 end

function TRegExpr.Substitute (const ATemplate: RegExprString): RegExprString;
// perform substitutions after a regexp match
var
 Src: Integer; // PRegExprChar; //###0.927
 c, c2: REChar;
 no: Integer;
begin
 Result := '';
 
 { // RJ 11.03.2000
  if programm = nil then
   begin
    Error (reeSubstNoExpression);
    Exit;
   end;
  // Check validity of program.
  if programm [0] <> MAGIC then
   begin
    Error (reeSubstCorruptedProgramm);
    Exit;
   end;
  // Exit if previous compilation was finished with error
  if not fExprIsCompiled then
   begin //###0.90
    Error (reeExecAfterCompErr);
    Exit;
   end;}
 CheckProgram; // RJ 11.03.2000
 
 Src := 1; // PRegExprChar (ATemplate); //###0.927
 while Src <= Length (ATemplate) { ^ <> #0} do
  begin //###0.927
   c := ATemplate [Src]; // src^; //###0.927
   Inc (Src);
   c2 := ATemplate [Src]; //###0.927
   if c = '&'
    then
    no := 0
   else
    if (c = '\') and ('0' <= c2) and (c2 <= '9')
     then
     begin
      no := Ord (c2) - Ord ('0');
      Inc (Src);
     end
    else
     no := -1;

   if no < 0 then
    begin // Ordinary character.
     if (c = '\') and ((c2 = '\') or (c2 = '&')) then
      begin
       c := c2; // src^;
       Inc (Src);
      end;
     Result := Result + c;
    end
   else
    Result := Result + Match [no]; //###0.90
  end;
end; { of function TRegExpr.Substitute
--------------------------------------------------------------}

procedure TRegExpr.Split (AInputStr: RegExprString; APieces: TStrings);
var
 PrevPos: Integer; //###0.90 optimized (Exec-ExecNext)
begin
 PrevPos := 1;
 if Exec (AInputStr) then
  repeat
   APieces.Add (System.Copy (AInputStr, PrevPos, MatchPos [0] - PrevPos));
   PrevPos := MatchPos [0] + MatchLen [0];
  until not ExecNext;
 APieces.Add (System.Copy (AInputStr, PrevPos, MaxInt)); // Tail
end; { of procedure TRegExpr.Split
--------------------------------------------------------------}

function TRegExpr.Replace (AInputStr: RegExprString; const AReplaceStr: RegExprString): RegExprString;
var
 PrevPos: Integer; //###0.90 optimized (Exec-ExecNext)
begin
 Result := '';
 PrevPos := 1;
 if Exec (AInputStr) then
  repeat
   Result := Result + System.Copy (AInputStr, PrevPos,
    MatchPos [0] - PrevPos) + AReplaceStr;
   PrevPos := MatchPos [0] + MatchLen [0];
  until not ExecNext;
 Result := Result + System.Copy (AInputStr, PrevPos, MaxInt); // Tail
end; { of function TRegExpr.Replace
--------------------------------------------------------------}

{=============================================================}
{====================== Debug section ========================}
{=============================================================}

{$IFDEF DebugRegExpr}

function TRegExpr.DumpOp (op: REChar): RegExprString;
// printable representation of opcode
begin
 case op of
  BOL: Result := 'BOL';
  EOL: Result := 'EOL';
  ANY: Result := 'ANY';
  ANYLETTER: Result := 'ANYLETTER';
  NOTLETTER: Result := 'NOTLETTER';
  ANYDIGIT: Result := 'ANYDIGIT';
  NOTDIGIT: Result := 'NOTDIGIT';
  ANYSPACE: Result := 'ANYSPACE';
  NOTSPACE: Result := 'NOTSPACE';
  ANYOF: Result := 'ANYOF';
  ANYBUT: Result := 'ANYBUT';
  ANYOFCI: Result := 'ANYOF/CI'; //###0.92
  ANYBUTCI: Result := 'ANYBUT/CI'; //###0.92
  BRANCH: Result := 'BRANCH';
  EXACTLY: Result := 'EXACTLY';
  EXACTLYCI: Result := 'EXACTLY/CI';
  NOTHING: Result := 'NOTHING';
  COMMENT: Result := 'COMMENT'; //###0.90
  Back: Result := 'BACK';
  EEND: Result := 'END';
  Succ (OPEN)..REChar (Ord (OPEN) + 9):
   Result := Format ('OPEN%d', [Ord (op) - Ord (OPEN)]);
  Succ (Close)..REChar (Ord (Close) + 9):
   Result := Format ('CLOSE%d', [Ord (op) - Ord (Close)]);
  STAR: Result := 'STAR';
  PLUS: Result := 'PLUS';
  BRACES: Result := 'BRACES'; //###0.90
  {$IFDEF ComplexBraces}
  LOOPENTRY: Result := 'LOOPENTRY'; //###0.925
  LOOP: Result := 'LOOP'; //###0.925
  {$ENDIF}
  else
   Error (reeDumpCorruptedOpcode);
 end; {of case op}
 Result := ':' + Result;
end; { of function TRegExpr.DumpOp
--------------------------------------------------------------}

function TRegExpr.Dump: RegExprString;
// dump a regexp in vaguely comprehensible form
var
 s: PRegExprChar;
 op: REChar; // Arbitrary non-END op.
 Next: PRegExprChar;
begin
 
 { // RJ 11.03.2000
 // Check compiled r.e. presence
 if programm = nil then
  begin //###0.90
   Error (reeNoExpression);
   Exit;
  end;
 
 // Check validity of program.
 if programm [0] <> MAGIC then
  begin //###0.90
   Error (reeCorruptedProgram);
   Exit;
  end;
 
 // Exit if previous compilation was finished with error
 if not fExprIsCompiled then
  begin //###0.90
   Error (reeExecAfterCompErr);
   Exit;
  end;}
 CheckProgram; // RJ 11.03.2000
 
 op := EXACTLY;
 Result := '';
 s := programm + 1;
 while op <> EEND do
  begin // While that wasn't END last time...
   op := s^;
   Result := Result + Format ('%2d%s', [s - programm, DumpOp (s^)]); // Where, what.
   Next := regnext (s);
   if Next = nil // Next ptr.
   then
    Result := Result + '(0)'
   else
    Result := Result + Format ('(%d)', [ (s - programm) + (Next - s)]);
   Inc (s, 3);
   if (op = ANYOF) or (op = ANYOFCI) or (op = ANYBUT) or (op = ANYBUTCI)
    or (op = EXACTLY) or (op = EXACTLYCI) then
    begin //###0.92
     // Literal string, where present.
     while s^ <> #0 do
      begin
       Result := Result + s^;
       Inc (s);
      end;
     Inc (s);
    end;
   if (op = BRACES)
    {$IFDEF ComplexBraces} or (op = LOOP){$ENDIF} //###0.925
   then
    begin //###0.90
     // show min/max argument of BRACES operator
     Result := Result + Format ('{%d,%d}', [Ord (s^), Ord ((s + 1)^)]);
     Inc (s, 2);
    end;
   {$IFDEF ComplexBraces}
   if op = LOOP then
    begin //###0.925
     Result := Result + Format ('/(%d)', [ (s - programm - 5)
      - (Ord (s^) * 256 + Ord ((s + 1)^))]);
     Inc (s, 2);
    end;
   {$ENDIF}
   Result := Result + #$D#$A;
  end; { of while}
 
 // Header fields of interest.
 
 if regstart <> #0
  then Result := Result + 'start ' + regstart;
 if reganch <> #0
  then Result := Result + 'anchored ';
 if regmust <> nil
  then Result := Result + 'must have ' + regmust;
 Result := Result + #$D#$A;
end; { of function TRegExpr.Dump
--------------------------------------------------------------}
{$ENDIF}

end.

