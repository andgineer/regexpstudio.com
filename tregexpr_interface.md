---
layout: page
title: TRegExr interface
---

[Русский](/tregexpr_interface_ru)

Simple illustrations

If you don't familiar with regular expression, you may learn about it in syntax topic or in any good Perl or Unix book.

## Using global routins
It's simple but not very flexible and effective way

 ExecRegExpr ('\d{3}-(\d{2}-\d{2}|\d{4})', 'Phone: 555-1234');


returns True
 ExecRegExpr ('^\d{3}-(\d{2}-\d{2}|\d{4})', 'Phone: 555-1234');


returns False, because there are some symbols before phone number and we using '^' metasymbol (BeginningOfLine)
 ReplaceRegExpr ('product', 'Take a look at product. product is the best !', 'TRegExpr');


returns 'Take a look at TRegExpr. TRegExpr is the best !'; ;)

## Using TRegExpr class
You have all power of the library

// This simple function extracts all email from input string
// and places list of this emails into result string
function ExtractEmails (const AInputString : string) : string;
const
   EmailRE = '[_a-zA-Z\d\-\.]+@[_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+'
var
   r : TRegExpr;
begin
   Result := '';
   r := TRegExpr.Create; // Create object
   try // ensure memory release
      r.Expression := EmailRE;
      // r.e. automatically compiles in internal structures
      // while Expression property assignment
      if r.Exec (AInputString) then
         REPEAT
            Result := Result + r.Match [0] + ', ';
         UNTIL not r.ExecNext;
      finally r.Free;
   end;
end;
begin
   ExctractEmails ('My e-mails is anso@mail.ru and anso@usa.net');
   // returns 'anso@mail.ru, anso@usa.net, '
end.
// Note: compilation of r.e. performed during Expression assignment
// take some time, so if you will use this function many times
// it will be useless overhead.
// You may significant optimize this if you will create TRegExpr
// and precompile expression during programm initialization.


// This simple example extracts phone number and
// parse it into parts (City and Country code, internal number).
// Then it substitutes this parts into template.
function ParsePhone (const AInputString, ATemplate : string) : string;
const
   IntPhoneRE = '(\+\d *)?(\(\d+\) *)?\d+(-\d*)*';
var
   r : TRegExpr;
begin
   r := TRegExpr.Create; // Create object
   try // ensure memory release
      r.Expression := IntPhoneRE;
      // r.e. automatically compiles in internal structures
      // while Expression property assignment
      if r.Exec (AInputString)
         then Result := r.Substitute (ATemplate)
         else Result := '';
      finally r.Free;
   end;
end;
begin
   ParsePhone ('Phone of AlkorSoft (project PayCash) is +7(812) 329-44-69',
   'Zone code \1, city code \2. Whole phone number is &.');
   // returns 'Zone code +7, city code (812) . Whole phone number is +7(812) 329-44-69.'
end.


See also [article](http://masterandrey.com/text_processing_from_birds_eye_view/).


## Public methods and properties of TRegExpr:

property Expression : string;
// regular expression.
// When you assign r.e. to this property, TRegExpr will automatically
// compile it and store in internal structures.
// In case of compilation error, Error method will be called
// (by default Error method raises exception ERegExpr - see below)

property Modifiers : string; //###0.90
// Set/get default values of r.e.syntax modifiers. Modifiers in
// r.e. (?ismx-ismx) will replace this default values.
// If you try to set unsupported modifier, Error will be called
// (by defaul Error raises exception ERegExpr).

property ModifierI : boolean; //###0.90
// Modifier /i - caseinsensitive, false by default

property ModifierR : boolean; //###0.90
// Modifier /r - use r.e.syntax extended for russian, true by default
// (was property ExtSyntaxEnabled in previous versions)

function Exec (const AInputString : string) : boolean;
// match a programm against a string AInputString
// !!! Exec store AInputString into InputString property

function ExecNext : boolean;
// find next match:
// Exec (AString); ExecNext;
// works same as
// Exec (AString); ExecPos (MatchPos [0] + MatchLen [0]);
// but it's more simpler !

function ExecPos (AOffset: integer = 1) : boolean;
// find match for InputString starting from AOffset position
// (AOffset=1 - first char of InputString)

property InputString : string;
// returns current input string (from last Exec call or last assign
// to this property).
// Any assignment to this property clear Match* properties !

function Substitute (const ATemplate : string) : string;
// Returns ATemplate with '&' replaced by whole r.e. occurence
// and '/n' replaced by occurence of subexpression #n.

procedure Split (AInputStr : string; APieces : TStrings);
// Split ASearchText into APieces by r.e. occurencies

function Replace (AInputStr : string; const AReplaceStr : string) : string;
// Returns AInputStr with r.e. occurencies replaced by AReplaceStr

property SubExprMatchCount : integer; // ReadOnly
// Number of subexpressions has been found in last Exec* call.
// If there are no subexpr. but whole expr was found (Exec* returned True),
// then SubExprMatchCount=0, if no subexpressions nor whole
// r.e. found (Exec* returned false) then SubExprMatchCount=-1.
// Note, that some subexpr. may be not found and for such
// subexpr. MathPos=MatchLen=-1 and Match=''.
// For example: Expression := '(1)?2(3)?';
// Exec ('123'): SubExprMatchCount=2, Match[0]='123', [1]='1', [2]='3'
// Exec ('12'): SubExprMatchCount=1, Match[0]='23', [1]='1'
// Exec ('23'): SubExprMatchCount=2, Match[0]='23', [1]='', [2]='3'
// Exec ('2'): SubExprMatchCount=0, Match[0]='2'
// Exec ('7') - return False: SubExprMatchCount=-1

property MatchPos [Idx : integer] : integer; // ReadOnly
// pos of entrance subexpr. #Idx into tested in last Exec*
// string. First subexpr. have Idx=1, last - MatchCount,
// whole r.e. have Idx=0.
// Returns -1 if in r.e. no such subexpr. or this subexpr.
// not found in input string.

property MatchLen [Idx : integer] : integer; // ReadOnly
// len of entrance subexpr. #Idx r.e. into tested in last Exec*
// string. First subexpr. have Idx=1, last - MatchCount,
// whole r.e. have Idx=0.
// Returns -1 if in r.e. no such subexpr. or this subexpr.
// not found in input string.

property Match [Idx : integer] : string; // ReadOnly
// == copy (InputString, MatchPos [Idx], MatchLen [Idx])
// Returns '' if in r.e. no such subexpr. or this subexpr.
// not found in input string.

function LastError : integer; //###0.90
// Returns ID of last error, 0 if no errors (unusable if
// Error method raises exception) and clear internal
// status into 0 (no errors).

function ErrorMsg (AErrorID : integer) : string; virtual;
// Returns Error message for error with ID = AErrorID.

property CompilerErrorPos : integer; // ReadOnly
// Returns pos in r.e. there compiler stopped.
// Usefull for error diagnostics

function Dump : string;
// dump a compiled regexp in vaguely comprehensible form


Global constants

RegExprModifierI : boolean = False;
// default value for ModifierI

RegExprModifierR : boolean = True;
// default value for ModifierR


Usefull global functions

function ExecRegExpr (const ARegExpr, AInputStr : string) : boolean;
// true if string AInputString match regular expression ARegExpr
// ! will raise exeption if syntax errors in ARegExpr

procedure SplitRegExpr (const ARegExpr, AInputStr : string; APieces : TStrings);
// Split ASearchText into APieces by r.e. ARegExpr occurencies

function ReplaceRegExpr (const ARegExpr, AInputStr, AReplaceStr : string) : string;
// Returns AInputStr with r.e. occurencies replaced by AReplaceStr


Exception type

Default error handler of TRegExpr raise exception:

ERegExpr = class (Exception)
public
ErrorCode : integer; // error code. Compilation error codes are before 1000.
CompilerErrorPos : integer; // Position in r.e. where compilation error occured
end;


