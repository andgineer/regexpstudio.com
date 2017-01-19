{$B-}
unit TFUStr;

{

 Too Frequently Used Strings staff
        * non VCL part *

 (no classes.pas, form.pas etc units needed)

 (c) 2001 Andrey Sorokin, Saint-Petersburg, Russia
  mailto:anso@mail.ru

 v. 3.1 2001.10.04
 -=- in PosOfChar check for StartPos = 0.
 -=- fixed errs in function AddPathTrailer

 v. 3.0 2001.09.30
 -=- Just first release (separated from TFUS.pas)

}


interface

{$IFDEF VER80} { Delphi 1.0}
 Sorry - 32-bits version only (Delphi 2 or later)
{$ENDIF}
{$IFDEF VER90} { Delphi 2.0}
 {$DEFINE NoTSysChar}
{$ENDIF}
{$IFDEF VER100} { Delphi 3.0}
 {$DEFINE NoTSysChar}
{$ENDIF}

{$IFDEF NoTSysChar}
type
 TSysCharSet = set of Char;
{$ELSE}
uses
 SysUtils;
{$ENDIF}

{ ========================= String search ===================}

function PosOfChar (AChar : Char; const AStr : AnsiString; AStartPos : integer) : integer;
// Fast replacement of Pos function for searching one char (1.8 times faster than Pos)
// AStr - input string; AStartPos - start position of search; AChar - char to find.
// Returns pos of char found (first char has pos=1) or 0 if char was not found.
// Input parameters checked for errors (AStartPos > 0 and AStartPost <= length (AStr),
// length (AStr) > 0). If any errors in parameters - returns 0.


{ ================ File names manipulation ==================}

const
 PathTrailer = '\';

function AddPathTrailer (const AStr : string; APathTrailer : char = PathTrailer) : string;
// Adds APathTrailer to the end of AStr, does nothing if AStr
// is empty or already terminated with PathTrailer.
// As default value for APathTrailer used PathTrailer constant.


{ ============== Word manipulation routines =================}
// !!! All word manipulation routines count sequence of delimiters
// !!! as ONE delimiter (for example ExtractWord (3, '1;;2,3', [';']) = '3')

function WordCount (const AStr : string; const AWordDelims : TSysCharSet): Integer;
// Number of words in AStr

function WordPosition (const AIdx : Integer; const AStr : string;
  const AWordDelims : TSysCharSet): Integer;
// Returns start position of word # AIdx in AStr (first word is # 1)

function ExtractWord (AIdx : Integer; const AStr : string;
  const AWordDelims : TSysCharSet): string;
// Returns word # AIdx from AStr


implementation


{ ========================= String search ===================}

// Here how Delphi 4 and Delphi 5 handles open strings
type
  StrRec = packed record
    allocSiz: Longint;
    refCnt: Longint;
    length: Longint;
  end;
const
  skew = sizeof(StrRec);

function PosOfChar (AChar : Char; const AStr : AnsiString; AStartPos : integer) : integer;
asm
    TEST  EDX,EDX
    JZ    @@EmptyString                   // Exit if AStr = nil
    PUSH  EDI
    PUSH  EBX
    MOV   EDI,EDX                         // EDI - holds pointer to AStr
    MOV   EBX,AStartPos                   // EBX - StartPos
    TEST  EBX,EBX
    JZ    @@BadArgs                       // StartPos = 0
    MOV   ECX,[EDI-skew].StrRec.length    // ECX - Length(s)
    SUB   ECX,EBX                         //avs 01.09.25, was: CMP EBX,ECX
    JB    @@BadArgs                       // StartPos>Length or StartPos < 0 //avs 01.09.25, was: JA @@NotFound
    INC   ECX                             //avs 01.09.25
    ADD   EDI,EBX                         // Add StartPos
    DEC   EDI                             // Starts from 1 - we counts from 0
  @@PosLoop:
    CMP   [EDI],al
    JE    @@Bingo
    INC   EDI
    DEC   ECX
    JNZ   @@PosLoop
  @@BadArgs:
    POP   EBX
    POP   EDI
  @@EmptyString:
    XOR   EAX,EAX
    JMP   @@Bye
  @@Bingo:
    SUB   EDI,EDX                         // Now EDI - pos of char !
    MOV   EAX,EDI
    POP   EBX
    POP   EDI
    INC   EAX
  @@Bye :
end;


{ ================ File names manipulation ==================}

function AddPathTrailer (const AStr : string; APathTrailer : char = PathTrailer) : string;
 begin
  if (length (AStr) > 0) and (AStr [length (AStr)] <> APathTrailer)
   then Result := AStr + APathTrailer
   else Result := AStr;
 end; { of function AddPathTrailer
--------------------------------------------------------------}


{ ============== Word manipulation routines =================}

function WordCount (const AStr: string; const AWordDelims: TSysCharSet): Integer;
 var
  Len, i: integer;
 begin
  Result := 0;
  i := 1;
  Len := length (AStr);
  while i <= Len do begin
    while (i <= Len) and (AStr [i] in AWordDelims)
     do inc (i);
    if i <= Len
     then inc (Result);
    while (i <= Len) and not (AStr [i] in AWordDelims)
     do inc (i);
   end;
 end; { of function WordCount
--------------------------------------------------------------}

function WordPosition (const AIdx : Integer; const AStr : string;
  const AWordDelims : TSysCharSet): Integer;
 var
  Count, i, Len : integer;
 begin
  Result := 0;
  Count := 0;
  i := 1;
  Len := length (AStr);
  while (i <= Len) and (Count <> AIdx) do begin
    while (i <= Len) and (AStr [i] in AWordDelims)
     do inc (i);
    if i <= Len
     then inc (Count);
    if Count <> AIdx
     then
      while (i <= Len) and not (AStr [i] in AWordDelims)
       do inc (i)
     else Result := i;
   end;
 end; { of function WordPosition
--------------------------------------------------------------}

function ExtractWord (AIdx : Integer; const AStr : string;
  const AWordDelims : TSysCharSet): string;
 var
  i, WordLen : integer;
 begin
  WordLen := 0;
  i := WordPosition (AIdx, AStr, AWordDelims);
  if i <> 0 then
    while (i <= Length (AStr)) and not (AStr [i] in AWordDelims) do begin
      inc (WordLen);
      SetLength (Result, WordLen);
      Result [WordLen] := AStr [i];
      inc (i);
     end;
  SetLength (Result, WordLen);
 end; { of function ExtractWord
--------------------------------------------------------------}

end.

