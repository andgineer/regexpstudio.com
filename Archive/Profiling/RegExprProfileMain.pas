unit RegExprProfileMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Psock, NMHttp;

type
  TfmRegExprProfileMain = class(TForm)
    BitBtn2: TBitBtn;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    btnReplace: TBitBtn;
    btnSets: TBitBtn;
    btnCaseInvert: TBitBtn;
    btnFileOpen: TBitBtn;
    btnAVLtree: TBitBtn;
    btnStr: TBitBtn;
    btnOverStuffCache: TBitBtn;
    btnThruCache: TBitBtn;
    btnWithOutChache: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure btnSetsClick(Sender: TObject);
    procedure btnCaseInvertClick(Sender: TObject);
    procedure btnFileOpenClick(Sender: TObject);
    procedure btnAVLtreeClick(Sender: TObject);
    procedure btnStrClick(Sender: TObject);
    procedure btnOverStuffCacheClick(Sender: TObject);
    procedure btnWithOutChacheClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRegExprProfileMain: TfmRegExprProfileMain;

implementation
{$R *.DFM}

uses
 Z_prof,
 mlRegularExpression,
 RegExpr, TFUS, mkregex, AVLtrees
;



procedure TfmRegExprProfileMain.FormCreate(Sender: TObject);
 begin
  tzprofiler.create(application.mainform);
  Randomize;
 end;

{$DEFINE LongInput}
{$DEFINE Test1} // iP225MMX ml: 7.12 ms / v.0.926: 19.90 ms
  // ShortInput ml: 6.05 / v.0.926: 0.10
  // CI v.0.926: 0.14 (67. for LongInput)
  // CI v.0.929(inv) 0.09/43.
  // LongInput/FirstCharSet: 6 / CI:12.5 -> v.0.934:4.3/11.5
  // ShortInput/FirstCharSet: 0.14 / 0.13
  // Shrt:iPII450 0.07/CI:0.06 (ml:3.26)
  // Long:iPII450 2.77/5.18 (ml:3.85) -> 2.5/5.15
  // mkr 1.1 / 1.04
{.$DEFINE Test2} // iP225MMX ml: 31.8 ms / v.0.926: 73.7 ms
  // ShortInput ml: 31.6 / v.0.926: 0.22
  // CI v.0.926: 0.29 (243. for LongInput)
  // CI v.0.929(inv) 0.24/205.
  // LongInput/FirstCharSet: 0.8 / 0.6 -> v.0.934:0.65/0.61
  // ShortInput/FirstCharSet: 0.27 / 0.37
  // Shrt:iPII450 0.14/CI:0.18 (ml:17.2) -> 0.12/0.16
  // Long:iPII450 0.3/0.28 (ml:17.6)
  // mkr 1.8 / 1.6
{.$DEFINE Test3} // iP225MMX ml: 16.5 ms / v.0.926: 12.3 ms
  // ShortInput ml: 14.2 / v.0.926: 0.31
  // CI v.0.926: 4.4 (293. for LongInput)
  // CI v.0.929(inv) 0.33/20.6 !!!
  // LongInput/FirstCharSet: 2.6 / 6.4 -> v.0.934:2.1/6.
  // ShortInput/FirstCharSet: 0.34 / 1.35
  // Shrt:iPII450 0.2/CI:0.57 (ml:7.7)
  // Long:iPII450 1.1/2.55 (ml:8.4)
  // mkr - / -
{.$DEFINE Test4} // iP225MMX ml: 15.4 ms / v.0.926: 14.2 ms
  // ShortInput ml: 14.6 / v.0.926: 0.31
  // CI v.0.926: 4.4 (350. for LongInput)
  // CI v.0.929(inv) 0.34/13.5 !!!!
  // LongInput/FirstCharSet: 2.66/6.01 -> v.0.934:2.1/5.4
  // ShortInput/FirstCharSet: 0.47 / 1.54
  // Shrt:iPII450 0.25/CI:0.65 (ml:8.)
  // Long:iPII450 1.2/2.5 (ml:8.5)
  // mkr - / -
{.$DEFINE Test5} // iP225MMX ml: 6.2 ms / v.0.926: 44.56 ms
  // ShortInput ml: 2.3 / v.0.926: 0.18
  // CI v.0.926: 2.3 (6333. for LongInput)
  // v.9.929 long: 9.9
  // CI v.0.929(inv) 0.19/60.8 !!!!
  // LongInput/FirstCharSet: 8.4/60.8
  // ShortInput/FirstCharSet: 0.23/1.15
  // Shrt:iPII450 0.1/CI:0.44 (ml:1.1)
  // Long:iPII450 3./22.8 (ml:3.1)
  // mkr long 1.39/ short 1.2
{.$DEFINE Test6} // iP225MMX ml: 6.9 ms / v.0.926: 11. ms
  // ShortInput ml: 5.6 / v.0.926: 0.14
  // CI v.0.926: 0.20 (25. for LongInput)
  // CI v.0.929(inv) 0.13/19.8 !!!!
  // LongInput/FirstCharSet: 0.50 / 0.38 -> v.0.934:0.4/0.3
  // ShortInput/FirstCharSet: 0.22 /0.20
  // Shrt:iPII450 0.1/CI:0.09 (ml:3.)
  // Long:iPII450 0.2/0.18 (ml:3.3) -> 0.2/0.16
  // mkr long 1.4 / short 1.3

procedure TfmRegExprProfileMain.BitBtn2Click(Sender: TObject);
 var
  e : TmlRegularExpression;
  AExpression, InputString : string;
  i : integer;
  r : TRegExpr;
  mkr : TmkreExpr;
 begin
  {$IFDEF Test1}
   AExpression := '((\.|,)|r)*mp\d';
   InputString := '123.mprgt.mfwefewrfgerwfq3wff343efr43';
   for i := 0 to 5
    do InputString := InputString + InputString;
   InputString := {$IFDEF LongInput}InputString +{$ENDIF} '.mp4';
  {$ENDIF}
  {$IFDEF Test2}
   {$IFDEF Test1} !!! {$ENDIF}
   AExpression := 'M*(D?C?C?C?|C[DM])(L?X?X?X?|X[LC])(V?I?I?I?|I[VX])$';
   InputString := 'trwhytrhrhrhrhrhrhrhrhr328475923745120';//III';
   for i := 0 to 5
    do InputString := InputString + InputString;
   InputString := {$IFDEF LongInput}InputString +{$ENDIF} 'CLX';//III';
  {$ENDIF}
  {$IFDEF Test3}
   {$IFDEF Test1} !!! {$ENDIF}
   {$IFDEF Test2} !!! {$ENDIF}
   AExpression := '(ftp|http)://(' // Protocol
   + '[\w\d\-]+(\.[\w\d\-]+)+' // TCP addr / domain name
   + ')((/[ \w\d\-\\\.]+)+)*' // unix path
   + '(\?[^ =&]+=[^ =&]+(&[^ =&]+=[^ =&]+)*)?'; // request params
   InputString := 'klwjfo;3jf90c234rxm3429pz,http://123imz4';
   for i := 0 to 5
    do InputString := InputString + InputString;
   InputString := {$IFDEF LongInput}InputString +{$ENDIF} 'http://anso.virtualave.net?ID=2';
  {$ENDIF}
  {$IFDEF Test4}
   {$IFDEF Test1} !!! {$ENDIF}
   {$IFDEF Test2} !!! {$ENDIF}
   {$IFDEF Test3} !!! {$ENDIF}
   AExpression := '([Ff][Tt][Pp]|[Hh][Tt][Tt][Pp])://(' // Protocol
   + '[\w\d\-]+(\.[\w\d\-]+)+' // TCP addr / domain name
   + ')((/[ \w\d\-\\\.]+)+)*' // unix path
   + '(\?[^ =&]+=[^ =&]+(&[^ =&]+=[^ =&]+)*)?'; // request params
   InputString := 'klwjfo;3jf90c234rxm3429pz,http://123imz4';
   for i := 0 to 5
    do InputString := InputString + InputString;
   InputString := {$IFDEF LongInput}InputString +{$ENDIF} 'http://anso.virtualave.net?ID=2';
  {$ENDIF}
  {$IFDEF Test5}
   {$IFDEF Test1} !!! {$ENDIF}
   {$IFDEF Test2} !!! {$ENDIF}
   {$IFDEF Test3} !!! {$ENDIF}
   {$IFDEF Test4} !!! {$ENDIF}
   AExpression := '[_a-zA-Z\d\-\.]+@[_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+';
   InputString := 'klwjfo;3jf90c234rxm3429pz,htt.imz4';
   for i := 0 to 5
    do InputString := InputString + InputString;
   InputString := {$IFDEF LongInput}InputString +{$ENDIF} 'anso@mailbox.alkor.ru';
  {$ENDIF}
  {$IFDEF Test6}
   {$IFDEF Test1} !!! {$ENDIF}
   {$IFDEF Test2} !!! {$ENDIF}
   {$IFDEF Test3} !!! {$ENDIF}
   {$IFDEF Test4} !!! {$ENDIF}
   {$IFDEF Test5} !!! {$ENDIF}
   AExpression := '(\+\d *)?(\(\d+\) *)?\d+(-\d*)*';
   InputString := 'klwjfo;jfcrxmpz,htt@.@imz';
   for i := 0 to 5
    do InputString := InputString + InputString;
   InputString := {$IFDEF LongInput}InputString +{$ENDIF} '+7(812) 157-37-52';
  {$ENDIF}

  profile.mark (1, true);
   e := TmlRegularExpression.Create (AExpression, [mfLongestMatch]
    { mfCaseInsensitive, mfAllMatches, mfStartOnly,
                                  mfFinishOnly, mfOverlapMatches});
   if e.Match (InputString) = mrNone //, mrFail, mrMatch, mrInsufficient
    then ;
  profile.mark (1, false);

  mkr := TmkreExpr.Create (nil);
  profile.mark (2, true);
//  mkr.UseFastmap := true;
  mkr.Pattern := AExpression;
  mkr.Str := InputString;
  mkr.DoMatch;
  profile.mark (2, false);
  Memo1.Lines.AddStrings (mkr.Matches);
  for i := 0 to mkr.Matches.Count -1 do
   Memo1.Lines.Add (mkr.Matches.strings [i]);

{  Init_mkreExpr;
  profile.mark (2, true);
  mkreSetPattern (AExpression);
  mkreDoMatch (InputString);
  profile.mark (2, false);
  for i := 0 to mkreGetMatches.Count -1 do
   Memo1.Add (mkreGetMatches.strings [i]);
  DeInit_mkreExpr;}

  r := TRegExpr.Create;
  profile.mark (3, true);
  r.Expression := AExpression;
  r.InputString := InputString;
  r.ExecPos;
  profile.mark (3, false);

   Label1.Caption := IntToStr (r.MatchPos [0])
    + ' - ' + IntToStr (r.MatchLen [0]);
  profile.mark (4, true);
  r.ModifierI := True;
  r.ExecPos;
  profile.mark (4, false);

//   for i := 0 to e.MatchCount - 1 do begin
//     Label1.Caption := IntToStr (e.MatchStart [i])
//      + ' - ' + IntToStr (e.MatchSize [i]);
//    end;

   Label2.Caption := IntToStr (r.MatchPos [0])
    + ' - ' + IntToStr (r.MatchLen [0]);
  end;

function SubstituteVars (const ATemplate : string; const AVars : array of string) : string;
 // Replace all occurences of '$n' with AVars [n]
 var
  TemplateLen : integer;
  TemplateBeg, TemplateEnd : PChar;
  MinVarIdx, MaxVarIdx : integer;
  p, p0, pZ, ResultPtr : PChar;
  ResultLen : integer;
  n : integer;
  Ch : Char;
  VarLengths : array of integer;
 function ParseVarName (var APtr : PChar) : integer;
  // extract name of variable (digits, may be enclosed with
  // curly braces) from APtr^, uses TemplateEnd !!!
  const
   Digits = ['0' .. '9'];
  var
   p : PChar;
   Delimited : boolean;
  begin
   Result := 0;
   p := APtr;
   Delimited := (p < TemplateEnd) and (p^ = '{');
   if Delimited
    then inc (p); // skip left curly brace
   if (p < TemplateEnd) and (p^ = '&')
    then inc (p) // this is '$&' or '${&}'
    else
     while (p < TemplateEnd) and (p^ in Digits) do begin
       inc (Result, ord (p^) - ord ('0'));
       inc (p);
      end;
   if Delimited then
    if (p < TemplateEnd) and (p^ = '}')
     then inc (p) // skip right curly brace
     else p := APtr; // isn't properly terminated
   if p = APtr
    then Result := -1; // no valid digits found or no right curly brace
   APtr := p;
  end;
 begin
  // Prepare for working
  TemplateLen := length (ATemplate);
  if TemplateLen = 0 then begin // prevent nil pointers
    Result := '';
    EXIT;
   end;
  MinVarIdx := Low (AVars);
  MaxVarIdx := High (AVars);
  SetLength (VarLengths, MaxVarIdx - MinVarIdx + 1);
  for n := MinVarIdx to MaxVarIdx
   do VarLengths [n] := length (AVars [n]);
  TemplateBeg := pointer (ATemplate);
  TemplateEnd := TemplateBeg + TemplateLen;
  // Count result length for speed optimization.
  ResultLen := 0;
  p := TemplateBeg;
  while p < TemplateEnd do begin
    Ch := p^;
    inc (p);
    if Ch = '$'
     then n := ParseVarName (p)
     else n := -1;
    if n >= 0 then begin
       if (n >= MinVarIdx) and (n <= MaxVarIdx)
        then inc (ResultLen, VarLengths [n]);
      end
     else begin
       if (Ch = '\') and (p < TemplateEnd)
        then inc (p); // quoted or special char followed
       inc (ResultLen);
      end;
   end;
  // Get memory. We do it once and it significant speed up work !
  if ResultLen = 0 then begin
    Result := '';
    EXIT;
   end;
  SetString (Result, nil, ResultLen);
  // Fill Result
  ResultPtr := pointer (Result);
  p := TemplateBeg;
  while p < TemplateEnd do begin
    Ch := p^;
    inc (p);
    if Ch = '$'
     then n := ParseVarName (p)
     else n := -1;
    if n >= 0 then begin
       p0 := pointer (AVars [n]);
       pZ := p0 + VarLengths [n];
       if (n >= MinVarIdx) and (n <= MaxVarIdx) and (VarLengths [n] > 0) then
        while p0 < pZ do begin
          ResultPtr^ := p0^;
          inc (ResultPtr);
          inc (p0);
         end;
      end
     else begin
       if (Ch = '\') and (p < TemplateEnd) then begin // quoted or special char followed
         Ch := p^;
         inc (p);
        end;
       ResultPtr^ := Ch;
       inc (ResultPtr);
      end;
   end;
 end; { of function SubstituteVars
--------------------------------------------------------------}

procedure TfmRegExprProfileMain.btnReplaceClick(Sender: TObject);
 const
  MaxV = 2;
 var
  Template : string;
  v : array [0 .. MaxV - 1] of string;
  i : integer;
 begin
  Template := 'This$0 simply${1}';
  for i := 1 to 5 do
   Template := Template + Template;
  v [0] := '<0>';
  v [1] := '<Second(index=1)>';

  profile.mark (1, true);
  for i := 1 to 100 do
   SubstituteVars (Template, v);
  profile.mark (1, False);

  profile.mark (2, true);
  for i := 1 to 100 do
   ReplaceStr (ReplaceStr (Template, '$0', v [0]), '${1}', v [1]);
  profile.mark (2, False);

  Label1.Caption := SubstituteVars (Template, v);
  Label2.Caption := ReplaceStr (ReplaceStr (Template, '$0', v [0]), '$1', v [1]);
 end;

procedure TfmRegExprProfileMain.btnSetsClick(Sender: TObject);
 const
  SetsN = 100;
 type
  PSetOfChar = ^TSetOfChar;
  TSetOfChar = set of char;
 var
  i, j{, k} : integer;
  Template, Template2, p, p0 : PChar;
  InputString : string;
  ChSet : TSetOfChar;
  Cnt : integer;
  ChSetStr : string;
  Off : byte;
  Max : Char;
  Ch : Char;
 begin
  ChSetStr := '31245';
  ChSet := [];
  for i := 1 to length (ChSetStr) do
   Include (ChSet, ChSetStr [i]);

  GetMem (Template, (SizeOf (ChSet) + 2) * SetsN);
  p := Template;
  for i := 1 to SetsN do begin
    p^ := #0;
    inc (p);
    p^ := #$ff;
    inc (p);
    move (ChSet, p^, SizeOf (ChSet));
    inc (p, SizeOf (ChSet));
   end;

  GetMem (Template2, (length (ChSetStr) + 1) * SetsN);
  p := Template2;
  for i := 1 to SetsN do begin
    move (pointer (ChSetStr)^, p^, length (ChSetStr));
    inc (p, length (ChSetStr));
    p^ := #0;
    inc (p);
   end;

  InputString := '0123456789';
  for i := 1 to 1 do
   InputString := InputString + InputString;

  profile.mark (1, true);
  Cnt := 0;
  for j := 1 to length (InputString) do begin
    p := Template;
    for i := 1 to SetsN do begin
      Off := ord (p^);
      inc (p);
      Max := p^;
      inc (p);
      Ch := InputString [j];
      if (Ch <= Max) and (Ch >= Char (Off))
         and (Char (Ord (Ch) - Off) in PSetOfChar (p)^)
       then inc (Cnt);
      inc (p, SizeOf (ChSet));
     end;
   end;
  profile.mark (1, False);

  Label1.Caption := IntToStr (cnt);

  profile.mark (2, true);
  Cnt := 0;
  for j := 1 to length (InputString) do begin
    p0 := Template2;
    for i := 1 to SetsN do begin
      p := p0;
//     if StrScan (p, InputString [j]) <> nil
//      for k := 1 to length (ChSetStr) do begin
//        if p^ = InputString [j]
        Ch := InputString [j];
        if (p^ = Ch) or ((p+1)^ = Ch)
        or ((p+2)^ = Ch) or ((p+3)^ = Ch) or ((p+4)^ = Ch)
         then inc (Cnt);
        inc (p, 5);
//        inc (p);
//       end;
//      inc (p, length (ChSetStr) + 1);
      inc (p);
      p0 := p;
     end;
   end;
  profile.mark (2, False);

  Label2.Caption := IntToStr (cnt);
 end;

procedure TfmRegExprProfileMain.btnCaseInvertClick(Sender: TObject);
 var
  InputString, Template : string;
  i, j : integer;
  cnt : integer;
   a : array [0 .. 255] of char;
 function ChUp (Ch : char) : char;
  begin
   Result := char (CharUpper (pointer (Ch)));
  end;
 function InvCh (Ch : char) : char;
  begin
//   Result := char (CharUpper (pointer (Ch)));
//   if Result = Ch
//    then Result := char (CharLower (pointer (Ch)));
   Result := a [ord (Ch)];
  end;
 begin
  for i := 0 to 255 do
   a [i] := char (i);

  Template := '1234567890';
  InputString := 'klwjfo;3jf90c234rxm3429pz,http://123imz4';
  for i := 0 to 5
   do InputString := InputString + InputString;

  cnt := 0;
  profile.mark (1, True);
  for i := 1 to length (Template) do
   for j := 1 to length (InputString) do
    if Template [i] = InputString [j]
     then inc (cnt);
  profile.mark (1, False);
  Label1.Caption := IntToStr (cnt);

  cnt := 0;
  profile.mark (2, True);
  for i := 1 to length (Template) do
   for j := 1 to length (InputString) do
    if (Template [i] = InputString [j])
       or (InvCh (Template [i]) = InputString [j])
     then inc (cnt);
  profile.mark (2, False);
  Label2.Caption := IntToStr (cnt);
 end;

procedure TfmRegExprProfileMain.btnFileOpenClick(Sender: TObject);
 const
  n = 100;
 var
  f : File;
  s : TStream;
  i : integer;
  b : array [0 .. 200] of byte;
 begin
  profile.mark (1, True);
  AssignFile (f, 'c:\config.sys');
  FileMode := fmOpenRead;
  for i := 0 to n do begin
    Reset (f, 1);
    BlockRead (f, b, 200);
    Seek (f, 0);
    CloseFile (f);
   end;
  profile.mark (1, False);

  FileMode := fmOpenReadWrite;
  profile.mark (2, True);
  Reset (f, 1);
  for i := 0 to n do begin
    BlockRead (f, b, 200);
    Seek (f, 0);
   end;
  CloseFile (f);
  profile.mark (2, False);

  profile.mark (3, True);
    s := TFileStream.Create ('c:\config.sys', fmOpenRead);
  for i := 0 to n do begin
    s.Read (b, 200);
    s.Position := 0;
   end;
    s.Free;
  profile.mark (3, False);

 end;

var nn : integer;
function PrintTree (ANode : TBalancedTree; AParm : Pointer) : boolean;
 begin
  fmRegExprProfileMain.Memo1.Lines.Add (IntToStr (TIntKeyAVLtreeNode (ANode).Key));
  Result := false;
  inc (nn);
 end;

const
 AbleArrayMinPageSize = 64; // 4K items

type
 PPointer = ^pointer;
 TAbleArray = class
   private
    fRoot : pointer;
    fItemSize : integer;
    fPageSize : integer;
    function GetItems (AIdx : integer) : pointer;
    procedure SetItems (AIdx : integer; AItem : pointer);
   public
    constructor Create (ACapacity : integer; AItemSize : integer);
    destructor Destroy; override;

    property Items [AIdx : integer] : pointer read GetItems write SetItems; Default;
  end;

constructor TAbleArray.Create (ACapacity : integer; AItemSize : integer);
 begin
  inherited Create;
  fItemSize := AItemSize;
  fPageSize := AbleArrayMinPageSize;
  while fPageSize * fPageSize < ACapacity
   do fPageSize := fPageSize * 2;
  GetMem (fRoot, fPageSize * SizeOf (pointer));
  FillChar (fRoot^, fPageSize * SizeOf (pointer), 0);
 end; { of constructor TAbleArray.Create
--------------------------------------------------------------}

destructor TAbleArray.Destroy;
 var
  i : integer;
  p : pointer;
 begin
  for i := 0 to fPageSize - 1 do begin
   p := PPointer (PChar (fRoot) + i * SizeOf (integer))^;
   if p <> nil
    then FreeMem (p);
   end;
  FreeMem (fRoot);
  inherited;
 end; { of destructor TAbleArray.Destroy
--------------------------------------------------------------}

function TAbleArray.GetItems (AIdx : integer) : pointer;
 var
  p : pointer;
 begin
//  p := PChar (fRoot) + (AIdx div fPageSize) * SizeOf (pointer);
  p := PChar (fRoot) + (AIdx ShR 8) ShL 2;
  if PPointer (p)^ <> nil
//   then Result := PPointer (PChar (PPointer (p)^) + (AIdx mod fPageSize) * fItemSize)^
   then Result := PPointer (PChar (PPointer (p)^) + (AIdx and $FF) ShL 2)^
   else begin
     GetMem (PPointer (p)^, fPageSize * fItemSize);
     FillChar (PPointer (p)^^, fPageSize * fItemSize, 0);
     Result := nil;
    end;
 end; { of function TAbleArray.GetItems
--------------------------------------------------------------}

procedure TAbleArray.SetItems (AIdx : integer; AItem : pointer);
 var
  p : pointer;
 begin
  p := PChar (fRoot) + (AIdx div fPageSize) * SizeOf (pointer);
  if PPointer (p)^ <> nil
   then PPointer (PChar (PPointer (p)^) + (AIdx mod fPageSize) * fItemSize)^ := AItem
   else begin
     GetMem (PPointer (p)^, fPageSize * fItemSize);
     FillChar (PPointer (p)^^, fPageSize * fItemSize, 0);
     PPointer (PChar (PPointer (p)^) + (AIdx mod fPageSize) * fItemSize)^ := AItem;
    end;
 end; { of procedure TAbleArray.SetItems
--------------------------------------------------------------}


procedure TfmRegExprProfileMain.btnAVLtreeClick(Sender: TObject);
 const
  NodeN = 256 * 4 * 10;
 var
  tree : TIntKeyAVLtree;
  p : array [1 .. NodeN] of TIntKeyAVLtreeNode;
  i, n, n2, n3 : integer;
  a : TAbleArray;
 begin
  Memo1.Lines.Add ('-----------');
  a := TAbleArray.Create (64*1024, 4);
  tree := TIntKeyAVLtree.Create;
  for i := 1 to NodeN do begin
    REPEAT
     p [i] := TIntKeyAVLtreeNode.Create;
     p [i].Key := Random (60000);
     tree.AddNode (p [i]);
     a [p [i].Key] := p [i];
    UNTIL p [i] <> nil;
   end;

  n := p [Random (NodeN) + 1].Key;
  Memo1.Lines.Add ('Search ' + IntToStr (n));

  profile.mark (1, True);
//  i := 1;
//  while p [i].Key <> n do inc (i);
//  n2 := p [i].Key;
  n2 := TIntKeyAVLtreeNode (a [n]).Key;
  profile.mark (1, False);

  profile.mark (2, True);
  for i := 1 to 10
  do n3 := tree.Find (n).Key;
  profile.mark (2, False);

  Memo1.Lines.Add ('Seq Found ' + IntToStr (n2));
  Memo1.Lines.Add ('AVL Found ' + IntToStr (n3));
  exit;
  nn := 0;
  tree.Root.RecursiveBeat (PrintTree, nil);
  n := nn;
  Memo1.Lines.Add ('----------- ' + IntToStr (n));
  p [3].Free;
  nn := 0;
  tree.Root.RecursiveBeat (PrintTree, nil);
  if nn <> (n - 1)
   then Memo1.Lines.Add ('----------- !!! ' + IntToStr (n))
   else Memo1.Lines.Add ('----------- Ok');
  tree.Free;
 end;

type
 string10 = string [10];
 PString10 = ^string10;

procedure TfmRegExprProfileMain.btnStrClick(Sender: TObject);
 var
  p : pointer;
  c : char;
  Len : integer;
  s : string;
 begin
  p := nil; // ??????????
  Len := length (PString10 (p)^);
  c := PString10 (p)^[2];
  s := PString10 (p)^;
  Memo1.Lines.Add (c + IntToStr (Len) + s);
 end;


function FileOpen(const FileName: string; Mode: LongWord): Integer;
{ FileOpen opens the specified file using the specified access mode. The
  access mode value is constructed by OR-ing one of the fmOpenXXXX constants
  with one of the fmShareXXXX constants. If the return value is positive,
  the function was successful and the value is the file handle of the opened
  file. A return value of -1 indicates that an error occurred. }
const
  AccessMode: array[0..2] of LongWord = (
    GENERIC_READ,
    GENERIC_WRITE,
    GENERIC_READ or GENERIC_WRITE);
  ShareMode: array[0..4] of LongWord = (
    0,
    0,
    FILE_SHARE_READ,
    FILE_SHARE_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE);
begin
  Result := Integer(CreateFile(PChar(FileName), AccessMode[Mode and 3],
    ShareMode[(Mode and $F0) shr 4], nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0));
end;

function FileCreate(const FileName: string): Integer;
{ FileCreate creates a new file by the specified name. If the return value
  is positive, the function was successful and the value is the file handle
  of the new file. A return value of -1 indicates that an error occurred. }
begin
  Result := Integer(CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE,
    0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0));
end;

type
  TAbleFileStream = class (THandleStream)
   public
    constructor Create (const FileName: string; Mode: Word);
    // Use afmXXX constants in Mode instead of fmCreate !
    destructor Destroy; override;
  end;

const
 afmCreateNew    = $0000; // Creates a new file. The function fails
                          // if the specified file already exists.
 afmCreateAlways = $0100; // Creates a new file. The function
                          // overwrites the file if it exists.
 afmOpenExisting = $0200; // Opens the file. The function fails
                          // if the file does not exist.
 afmOpenAlways   = $0300; // Opens the file, if it exists. If the
                          // file does not exist, the function
                          // creates the file as afmCreateNew.

 afmWriteThrough = $1000; // Instructs the operating system to write
                          // through any intermediate cache and go
                          // directly to disk. The operating system
                          // can still cache write operations, but
                          // cannot lazily flush them.
 afmNoBuffering =  $2000; // Instructs the operating system to open
                          // the file with no intermediate buffering.
 // This can provide performance gains in some situations. An
 // application must meet certain requirements when working with
 // files opened with afmNoBuffering:
 // -=- File access must begin at byte offsets within the file
 // that are integer multiples of the volume's sector size.
 // -=- File access must be for numbers of bytes that are integer
 // multiples of the volume's sector size.
 // -=- Buffer addresses for read and write operations must be
 // aligned on addresses in memory that are integer multiples of
 // the volume's sector size.
 // One way to align buffers on integer multiples of the volume
 // sector size is to use VirtualAlloc to allocate the buffers.
 // It allocates memory that is aligned on addresses that are
 // integer multiples of the operating system's memory page size.
 // Since both memory page and volume sector sizes are powers of
 // 2, this memory is also aligned on addresses that are integer
 // multiples of a volume's sector size.
 afmRandomAccess = $4000; // Indicates that the file is accessed
                          // randomly. Windows can use this as a
                          // hint to optimize file caching.
 afmSequentialScan =$8000;// Indicates that the file is to be
                          // accessed sequentially from beginning
                          // to end. Windows can use this as a
                          // hint to optimize file caching. If an
                          // application moves the file pointer
                          // for random access, optimum caching
                          // may not occur; however, correct
                          // operation is still guaranteed.

// !!!!!! Be careful !!!!!!!
// It's the hack ! We use knowledge about fmXXX constants values !
constructor TAbleFileStream.Create (const FileName: string; Mode: Word);
 const
  AccessMode: array [0..2] of DWORD = (
    GENERIC_READ,
    GENERIC_WRITE,
    GENERIC_READ or GENERIC_WRITE);
  ShareMode: array [0..4] of DWORD = (
    0,
    0,
    FILE_SHARE_READ,
    FILE_SHARE_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE);
  CreationDistribution : array [0 .. 3] of DWORD = (
    CREATE_NEW,
    CREATE_ALWAYS,
    OPEN_EXISTING,
    OPEN_ALWAYS);
 var
  DesiredAccess, FileFlags : DWORD;
 begin
  DesiredAccess := AccessMode [Mode and 3];
// Fool proof
//  if ((Mode and $F00) = afmCreateNew)
//     or ((Mode and $F00) = afmCreateAlways)
//     or ((Mode and $F00) = afmOpenAlways)
//   then DesiredAccess := DesiredAccess or GENERIC_WRITE;
  FileFlags := 0;
  if (Mode and afmWriteThrough) <> 0
   then FileFlags := FileFlags or FILE_FLAG_WRITE_THROUGH;
  if (Mode and afmNoBuffering) <> 0
   then FileFlags := FileFlags or FILE_FLAG_NO_BUFFERING;
  if (Mode and afmRandomAccess) <> 0
   then FileFlags := FileFlags or FILE_FLAG_RANDOM_ACCESS;
  if (Mode and afmSequentialScan) <> 0
   then FileFlags := FileFlags or FILE_FLAG_SEQUENTIAL_SCAN;
  inherited Create (Integer (CreateFile (
    PChar (FileName),
    DesiredAccess,
    ShareMode [(Mode and $F0) shr 4],
    nil,
    CreationDistribution [(Mode and $F00) shr 8],
    FILE_ATTRIBUTE_NORMAL or FileFlags, 0)));
  if Handle < 0
   then raise EFCreateError.CreateFmt ('TAbleFileStream.Create error: "%s"', [FileName]);
 end; { of constructor TAbleFileStream.Create
--------------------------------------------------------------}

destructor TAbleFileStream.Destroy;
 begin
  if Handle >= 0
   then FileClose (Handle);
 end; { of destructor TAbleFileStream.Destroy
--------------------------------------------------------------}


procedure TfmRegExprProfileMain.btnOverStuffCacheClick(Sender: TObject);
 var
  SectorsPerCluster, BytesPerSector, NumberOfFreeClusters,
  TotalNumberOfClusters : DWORD;
 begin
  if GetDiskFreeSpace ('f:\', SectorsPerCluster, BytesPerSector,
      NumberOfFreeClusters, TotalNumberOfClusters)
   then begin
    Memo1.Lines.Add (Format ('%d %d %d %d', [SectorsPerCluster, BytesPerSector,
      NumberOfFreeClusters, TotalNumberOfClusters]));
   end;
  // Drive 0
  // c: 32x512 (1G, FAT16)
  // f: 8x512  (8G, FAT32)
  // Drive 1
  // g: 16x512 (259M, FAT16)
  // l: 8x512  (2G, FAT32)
  
  Memo1.Lines.Add (IntToStr (TMemo.InstanceSize));
  // TPersistent   4
  // TComponent   36
  // TControl    288
  // TWinControl 492
  // TCustomEdit 520
  // TMemo       536
 end;


procedure TfmRegExprProfileMain.btnWithOutChacheClick(Sender: TObject);
 type
  PWord = ^word;
 const
  BufSz = 1024 * 400; // 512 * 8;
 var
  s : TAbleFileStream;
  Sz : integer;
  i : integer;
  {$A+}
  b : array [0 .. BufSz - 1 + 512] of byte;
  p : PChar;
 begin
     profile.mark (1, True);
     for i := 0 to 1000 do
      GetMem (p, 25);
{     p := @b;
     Sz := 0;
     for i := 0 to BufSz div 6 - 1 do begin
       if PWord (p + 4)^ = 0
        then inc (Sz);
       inc (p, 6);
      end;}
     profile.mark (1, False);
     
     EXIT;

  s := TAbleFileStream.Create ('f:\pofme.jbc',
        fmOpenRead or afmOpenExisting
//afmRandomAccess
//or afmSequentialScan
or afmNoBuffering
//afmWriteThrough
        );
  try
     Sz := s.Size div BufSz;
     s.Position := 0;
     profile.mark (1, True);
     for i := 0 to Sz - 1 do
      s.Read (b, BufSz);
     profile.mark (1, False);
    finally s.Free;
   end;
 end;

end.

