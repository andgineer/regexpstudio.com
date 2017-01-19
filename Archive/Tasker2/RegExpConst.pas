unit RegExpConst;
{$define debug}

interface

uses
  windows,
  classes,
  sysUtils,
  forms,
  PictureChars,
  RegExpr;

//type
//  AlphaNumeric = set of char;

//  commonfunctions
//  genericfunctions
const
//  Digits:AlphaNumeric=['0'..'9'];

  ERRORLOGFILE='ErrorLOG.LOG';


type

  TreCharCase = (reNormal, reUpper, reLower, reProper);

  TreTypeKind =
               (reSByte,
                reUByte,
                reSWord,
                reUWord,
                reSLong,
                reULong,
                reInt64,
                reSingle,
                reDouble,
                reExtended,
                reComp,
                reCurr,
                reDateTime,
                reChar,
                reString
// I don't believe these will be useful in this context
//                reWChar,
//                reLString,
//                reWString,
//                reSet,
//                reClass,
//                reMethod,
//                reVariant,
//                reArray,
//                reRecord,
//                reInterface,
//                reEnumeration,
//                reDynArray
                );

  TWordInfo=record
    wordPos:integer;
    lword:string;
  end;

// this class is derived to add extra functions.

  TPicRegExp=Class(TRegExpr)
  Private
//    Function GetOpName(Value:Char):String;
  public
    function permittedChars:String;
    function literalChars:String;
    procedure Matches (AInputStr : string; APieces : TStrings);
  end;

  TreCollection=Class(TOwnedCollection)
  private
    fRepeating:Boolean;
  public
    Procedure Assign(Source:TPersistent); override;
  published
    Property Repeating:Boolean read fRepeating write fRepeating;
  end;

  TRegExpItem = class(TCollectionItem)
  private
    fOffset:word;
    fExpression:String;
    fminChars:word;
    fmaxChars:word;
    fAlignment:TAlignment;
    procedure SetOffset(Value:word);
    procedure SetExpression(Value:String);
  public
    procedure Assign(Source: TPersistent); override;
    constructor create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property Expression:String read fExpression write SetExpression;
    property Offset:word read fOffset write SetOffset;
    property MinChars:word read fMinChars write fMinChars;
    property MaxChars:word read fMaxChars write fMaxChars;
    property Alignment:TAlignment read fAlignment write fAlignment;
//    property Repeating:Boolean read fRepeating write fRepeating;
  end;

Var
  ApplicationPath:STring;
  LogFile:TStringList;
  reTimeMask,
  reDateMask,
  reMoneyMask : String;

  ErrorBuff:Array[0..999] of char;
  ErrorMessage:pchar;

// Debugging routines.  uses GExperts debug window if present
Procedure TrapException(Value:String);
Procedure WriteErrorLog(Value:String);

// borrowed from esbrtns
{: Returns the String with all specified trailing characters removed. }
function StripTChStr (const S : string; const Ch : Char): string;

// borrowed from esbrtns
{: Returns the String with all specified leading characters removed. }
function StripLChStr (const S : string; const Ch : Char): string;

// borrowed from esbrtns
{: Returns the String with all specified leading and trailing
	characters removed. }
function StripChStr (const S : string; const Ch : Char): string;

// borrowed from esbrtns
{: Returns a string with specified characters added to the beginning and
	end of the string to in effect centre the string within the
	given length. <p>
	If Length (S) >= Len then NO padding occurs, and S is returned. }
function CentreChStr (const S : String; const Ch : Char;
	const Len : Integer): String;

// borrowed from esbrtns
{: Returns a string composed of N occurrences of Ch. }
function FillStr (const Ch : Char; const N : Integer): string;

// from jbstr

Function  WordCount(S:String;WordDelims:TSetOfChar=[' ']):Byte;
Function  ExtractWord(N:Byte;S:String;WordDelims:TSetOfChar=[' ']):String;
Function  ExtractWordAt(lPos:Byte;S:String;WordDelims:TSetOfChar=[' ']):TWordInfo;


Function IsDigitsOnly(Value:String):Boolean;


implementation

uses
//  commonFunctions,
{$ifdef debug}
  dbugintf;
{$else debug}
//  ;
{$endif debug}


////////////////////////////////////////////////////////////////////////////////
//
//                         ExtractWord
//  Extracts the N'th word from a string using WordDelims as the word delimiters
//
////////////////////////////////////////////////////////////////////////////////

Function  ExtractWord(N:Byte;S:String;WordDelims:TSetOfChar=[' ']):String;
  {-zkopiruje na vystup N-te slovo oddelene WordDelims}
Var
  I,J:Word;
  Count:Byte;
  SLen:Integer;
Begin
  Count := 0;
  I := 1;
  Result := '';
  SLen := Length(S);
  While I <= SLen Do Begin
    {preskoc oddelovace}
    While (I <= SLen) And (S[I] In WordDelims) Do Inc(I);
    {neni-li na konci retezce, bude nalezen zacatek slova}
    If I <= SLen Then Inc(Count);
    J := I;
    {a zde je konec slova}
    While (J <= SLen) And Not(S[J] In WordDelims) Do Inc(J);
    {je-li toto n-te slovo, vloz ho na vystup}
    If Count = N Then Begin
      Result := Copy(S,I,J-I);
      Exit
    End;
    I := J;
  End; {while}
End;

////////////////////////////////////////////////////////////////////////////////
//
//                     Extracts a word from a position in a string
//                 lpos = position in string
//                 S = source string
//                 wordDelims = set of chars separating words.
//
////////////////////////////////////////////////////////////////////////////////

Function  ExtractWordAt(lPos:Byte;S:String;WordDelims:TSetOfChar=[' ']):TWordInfo;
  {-zkopiruje na vystup N-te slovo oddelene WordDelims}
Var
  I,J:longword;
  Count:Byte;
  SLen:Integer;
Begin
  result.wordPos:=0;
  result.lword:='';
  if lpos>length(S) then
    exit;
  Count := 0;
  I := lPos;
  SLen := Length(S);
  While I <= SLen Do Begin
    {preskoc oddelovace}
    While (I > 1) And not (S[I] In WordDelims) Do Dec(I);
    result.wordPos:=lpos-i+1;
    {neni-li na konci retezce, bude nalezen zacatek slova}
    If I <= SLen Then Inc(Count);
    J := I;
    {a zde je konec slova}
    While (J <= SLen) And Not(S[J] In WordDelims) Do Inc(J);
    {je-li toto n-te slovo, vloz ho na vystup}
    If J >= lpos Then
    Begin
      Result.lword := Copy(S,I,J-I);
//      if Result.lword='' then
//        Result.wordPos:=lPos;
      Break;
    End;
    I := J;
  End; {while}
End;

////////////////////////////////////////////////////////////////////////////////
//
//                    WordCount
//                    Returns the number of words in a string.
//
////////////////////////////////////////////////////////////////////////////////

Function  WordCount(S:String;WordDelims:TSetOfChar=[' ']):Byte;
  {Count the number of words given a set of delims}
Var
  I:Word;
Begin
  Result := 0;
  I := 1;
  While I <= Length(S) Do Begin
    {skip over all delimiters}
    While (I <= Length(S)) And (S[I] In WordDelims) Do
      Inc(I);
    {increment word count}
    If I <= Length(S) Then Inc(Result);
    {skip over all remaining word chars}
    While (I <= Length(S)) And Not(S[I] In WordDelims) Do
      Inc(I);
  End;
End;


Procedure TreCollection.Assign(Source:TPersistent);
var
  lsrc:TreCollection;
begin
  inherited;
  if source is TreCollection then
  begin
    lsrc:=Source as TreCollection;
    fRepeating:=lsrc.fRepeating;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//                      TRegExpItem.Assign
//
////////////////////////////////////////////////////////////////////////////////

procedure TRegExpItem.Assign(Source: TPersistent);
var
  item:TRegExpItem;
begin
  try
    if source is TRegExpItem then
    begin
      item:=source as TRegExpItem;
      foffset:=item.fOffset;
      fexpression:=item.fExpression;
      fmaxchars:=item.fmaxChars;
      fminchars:=item.fminChars;
      fAlignment:=item.fAlignment;
//      fRepeating:=item.fRepeating;
    end
    else
      inherited;
  except
    trapexception('Assign in ' + classname + ' Failed');
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//                      TPicRegExp.create
//
////////////////////////////////////////////////////////////////////////////////

constructor TRegExpItem.create(Collection: TCollection);
begin
  inherited;
end;

////////////////////////////////////////////////////////////////////////////////
//
//                      TPicRegExp.Destroy
//
////////////////////////////////////////////////////////////////////////////////

destructor TRegExpItem.Destroy;
begin
  inherited;
end;


////////////////////////////////////////////////////////////////////////////////
//
//                      TRegExpItem.SetOffset
//
////////////////////////////////////////////////////////////////////////////////

procedure TRegExpItem.SetOffset(Value:word);
begin
  try
    if (Value<>0) and
       (fMinchars<>fMaxChars) then
      fMaxChars:=fMinChars;
    fOffSet:=Value;
    Changed(false);
  except
    trapException('SetOffset failed '+classname)
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//                      TRegExpItem.SetExpression
//
////////////////////////////////////////////////////////////////////////////////

Procedure TRegExpItem.SetExpression(Value:string);
begin
  try
    if fExpression<>Value then
    begin
      fExpression:=Value;
      Changed(False);
    end;
  except
    trapException('SetExpression failed '+classname)
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//                           TPicRegExp.literalChars
//
////////////////////////////////////////////////////////////////////////////////

function TPicRegExp.literalChars:String;
// dump a regexp in vaguely comprehensible form
var
 s : PChar;
 op : char; // Arbitrary non-END op.
 next : PChar;
 chadd:char;
 i:integer;
begin
  try
    // Check compiled r.e. presence
    if (programm = nil) then
    begin //###0.90
      Error(reeNoExpression);
      EXIT;
     end;

    // Check validity of program.
    if programm [0] <> MAGIC then
    begin //###0.90
      Error (reeCorruptedProgram);
      EXIT;
     end;

    // Exit if previous compilation was finished with error
    if not fExprIsCompiled then
    begin //###0.90
      Error (reeExecAfterCompErr);
      EXIT;
     end;

    op := EXACTLY;
    Result := '';
    s := programm + 1;
    while op <> EEND do
    begin // While that wasn't END last time...
       op := s^;
       next := regnext (s);
       inc (s, 3);
       if op in [EXACTLY,EXACTLYCI] then
       begin //###0.90
         // Literal string, where present.
         while s^ <> #0 do
         begin
           Result := Result + s^;
           if (op = EXACTLYCI) then
           begin
             chadd:=s^;
             if isCharUpper(s^) then
               result:=result+charlower(@chadd);
             if isCharLower(s^) then
               result:=result+charUpper(@chadd);

           end;
           inc (s);
         end;
         inc (s);
       end  // if op in
       else
       if op in [ANYOF] then
       begin //###0.90
         result:=result+' ';
         // Literal string, where present.
         while s^ <> #0 do
         begin
           inc (s);
         end;
         inc (s);
       end;  // if op in

       if op = BRACES then
       begin //###0.90
         for i:=1 to ord(s^)-1 do
           result:=result+' ';
         inc (s, 2);
        end;
     end; { of while}

  except
    trapException('Literalchars failed '+classname)
  end;
end; // of function TRegExpr.Dump

////////////////////////////////////////////////////////////////////////////////
//
//                      TPicRegExp.permittedChars
//
////////////////////////////////////////////////////////////////////////////////


function TPicRegExp.permittedChars:String;
// dump a regexp in vaguely comprehensible form
var
 s : PChar;
 op : char; // Arbitrary non-END op.
 next : PChar;
 chadd:char;
begin
  try
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
      next := regnext (s);
      inc (s, 3);
      if (op = ANYOF) or (op = EXACTLY) or (op = EXACTLYCI) then begin //###0.90
          // Literal string, where present.
          while s^ <> #0 do begin
            Result := Result + s^;
            if (op = EXACTLYCI) then
            begin
              chadd:=s^;
              if isCharUpper(s^) then
                result:=result+charlower(@chadd);
              if isCharLower(s^) then
                result:=result+charUpper(@chadd);

            end;

            inc (s);
           end;
          inc (s);
       end;
      if op = BRACES then begin //###0.90
        // show min/max argument of BRACES operator
        inc (s, 2);
       end;
    end; { of while}

  except
    trapException('permittedChars failed '+classname)
  end;
end; // of function TRegExpr.Dump

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

procedure TPicRegExp.Matches (AInputStr : string; APieces : TStrings);
 var PrevPos : integer; //###0.90 optimized (Exec-ExecNext)
var
  lstr:string;
  lPos,
  lLen:integer;

 begin
  PrevPos := 1;
  if Exec (AInputStr) then
   REPEAT
     lPos:=MatchPos[0];
     lLen:=MatchLen[0];
     lstr:=System.Copy (AInputStr, lPos, lLen);
     APieces.Add(lstr);
    PrevPos := MatchPos [0] + MatchLen [0];
   UNTIL not ExecNext;
 end; { of procedure TRegExpr.Split}

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

function charcount(ch:char;S:String):integer;
var
  i:integer;
begin
  try
    result:=0;
    for i:=1 to length(s) do
    begin
      if upperCase(s[i])=upperCase(ch) then
        inc(result);
    end;
  except
    trapException('charcount failed ')
  end;
end;


////////////////////////////////////////////////////////////////////////////////
//
// writes an entry into the error log file.
// this file is always in the same directory as the
// executable.  It grows without limit so it is necessary
// to either trim or delete it periodically.
// Turn off the debugging when putting out to production.
// This will then delete any existing errorlogs before
// starting the new one.
//
////////////////////////////////////////////////////////////////////////////////


Procedure WriteErrorLog(Value:String);
Var
  CurrentTime:String;
begin
  try
    {$ifdef debug}
      SendDebug(Value);
    {$endif debug}
    if assigned(pchar(value)) and
      (Value>'') then
    begin
      CurrentTime:=FormatDateTime('yy-mm-dd hh:nn:ss',now);
      Logfile.Add(CurrentTime+'  '+Value);
      Logfile.SaveToFile(ApplicationPath+ERRORLOGFILE);
    end;
  except
  {$ifdef debug}
    SendDebug('WriteErrorLog Failed');
  {$endif debug}
  end;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

Procedure TrapException(Value:String);
begin
  try
    WriteErrorLog(Value);
    ExceptionErrorMessage(ExceptObject, ExceptAddr, ErrorMessage, 1000);
    WriteErrorLog(ErrorMessage);
  except
    SendDebug('TrapException failed');
  end;
end;


////////////////////////////////////////////////////////////////////////////////
//
//             Borrowed from esbrtns
//
////////////////////////////////////////////////////////////////////////////////

function StripChStr (const S : string; const Ch: Char): string;
begin
	Result := StripTChStr (StripLChStr (S, Ch), Ch);
end;

////////////////////////////////////////////////////////////////////////////////
//
//             Borrowed from esbrtns
//
////////////////////////////////////////////////////////////////////////////////

function StripTChStr (const S : string; const Ch: Char): string;
var
	Len: Integer;
begin
	Len := Length (S);
	while (Len > 0) and (S [Len] = Ch) do
		Dec (Len);
	if Len = 0 then
		Result := ''
	else
		Result := Copy (S, 1, Len);
end;

////////////////////////////////////////////////////////////////////////////////
//
//             Borrowed from esbrtns
//
////////////////////////////////////////////////////////////////////////////////

function StripLChStr (const S : string; const Ch: Char): string;
var
	I, Len: Integer;
begin
	Len := Length (S);
	I := 1;
	while (I <= Len) and (S [I] = Ch) do
		Inc (I);
	if (I > Len) then
		Result := ''
	else
		Result := Copy (S, I, Len - I + 1);
end;

////////////////////////////////////////////////////////////////////////////////
//
//             Borrowed from esbrtns
//
////////////////////////////////////////////////////////////////////////////////

function FillStr (const Ch : Char; const N : Integer): string;
begin
	SetLength (Result, N);
	FillChar (Result [1], N, Ch);
end;

////////////////////////////////////////////////////////////////////////////////
//
//             Borrowed from esbrtns
//
////////////////////////////////////////////////////////////////////////////////

function CentreChStr (const S : String; const Ch : Char;
	const Len : Integer): String;
var
	N, M: Integer;
begin
	N := Length (S);
	if N < Len then
	begin
		M := Len - N;
		if Odd (M) then
			Result := FillStr (Ch, M div 2) + S
				+ FillStr (Ch, M div 2 + 1)
		else
			Result := FillStr (Ch, M div 2) + S
				+ FillStr (Ch, M div 2);
	end
	else
		Result := S;
end;

////////////////////////////////////////////////////////////////////////////////
//
//
//
////////////////////////////////////////////////////////////////////////////////

Function IsDigitsOnly(Value:String):Boolean;
var
  i:integer;
begin
  result:=False;
  if length(Value)=0 then
    exit;
  for i:=1 to length(Value) do
  begin
    if not (value[i] in Digits) then
      exit;
  end;
  result:=true;
end;


var
  i:integer;
  lDateFormat:String;

Initialization
  lDateFormat:=ShortDateFormat;
  i:=charcount('d',lDateFormat);
  if i=1 then
    insert('d',lDateFormat,Pos('d',lDateFormat));
  i:=charcount('m',lDateFormat);
  if i=1 then
    insert('m',lDateFormat,Pos('m',lDateFormat));
  ApplicationPath:=ExtractfilePath(Application.Exename);
  Logfile:=TStringList.Create;
{$ifdef debug}
  if fileexists(ApplicationPath+ERRORLOGFILE) then
    LogFile.LoadFromFile(ApplicationPath+ERRORLOGFILE);
{$endif debug}
  ErrorMessage:=@ErrorBuff;
Finalization
  LogFile.Free;
end.





