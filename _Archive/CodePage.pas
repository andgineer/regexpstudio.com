{$B-}
unit CodePage;

{
  Coding/Encoding chars between russian char tables
  (c) 1997 Andrey Sorokin

  2000.02.06 Base64/Quoted-Printable inlines support
}

                              interface

type
 TDECodePage = (c866, c1251, cGOST, cISO, cSS4615, cKOI8);

const
 DECodePageNames : array [TDECodePage] of string[6] = (
  '866', '1251', 'ÃÎÑÒ', 'ISO', 'SS4615', 'ÊÎÈ8');

function StrFromCP (const s : string; CPg : TDECodePage) : string;
function StrToCP (const s : string; CPg : TDECodePage) : string;

function CharFromCP (c : byte; CPg : TDECodePage) : char;
function CharToCP (c : byte; CPg : TDECodePage) : byte;

function GostToCP1251 (s : string) : string;
function CP1251ToGost (s : string) : string;
function GostToCP1251Ch (c : char) : char;
function CP1251ToGostCh (c : char) : char;

function CP866ToCP1251Ch (c : char) : char;
function CP1251ToCP866Ch (c : char) : char;

function Koi8ToCP1251Ch (c : char) : char;
function CP1251ToKoi8Ch (c : char) : char;

function IsoToCP1251Ch (c : char) : char;
function CP1251ToIsoCh (c : char) : char;

function SS4615ToCP1251 (s : string) : string;
function CP1251ToSS4615 (s : string) : string;
function SS4615ToCP1251Ch (c : char) : char;
function CP1251ToSS4615Ch (c : char) : char;


function SevenBit2EightBit (const s : string) : string;
// replace all =?ccc?Q?=xx ... ?=
// and =?ccc?B?z...?= with their 8-bits equivalents
// if ccc = KOI8-R then decode from KOI8-R to Win1251
// else do not other decoding

                            implementation

uses
 Windows, SysUtils, RegExpr;

const
tblGostToCP1251 : array [$80..$ff] of byte = (
$C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF,
$D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $DA, $DB, $DC, $DD, $DE, $DF,
$E0, $E1, $E2, $E3, $E4, $E5, $E6, $E7, $E8, $E9, $EA, $EB, $EC, $ED, $EE, $EF,
$F0, $F1, $F2, $F3, $F4, $F5, $F6, $F7, $F8, $F9, $FA, $FB, $FC, $FD, $FE, $FF,
$20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $B9, $A7, $20, $20, $20, $20, $20, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20);

tblCP1251ToGost : array [$80..$ff] of byte = (
$20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $D6, $85, $20, $20, $20, $20, $20, $20, $20,
$20, $20, $20, $20, $20, $20, $20, $20, $A5, $D5, $20, $20, $20, $20, $20, $20,
$80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $8E, $8F,
$90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $9D, $9E, $9F,
$A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF,
$B0, $B1, $B2, $B3, $B4, $B5, $B6, $B7, $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF);

tblCP866ToCP1251 : array [$80..$ff] of byte = (
192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,
208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,
224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,
136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,
152,153,154,129,156,157,158,159,160,161,162,163,164,165,166,167,
168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,
240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,
130,132,135,134,128,133,131,155,184,185,186,187,188,189,190,191);

tblIsoToCP1251 : array [$80..$ff] of byte = (
128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,
160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,
192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,
208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,
224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,
240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,
176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191);

tblKoi8ToCP1251 : array [$80..$ff] of byte = (
128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,
160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,
176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,
254,224,225,246,228,229,244,227,245,232,233,234,235,236,237,238,
239,255,240,241,242,243,230,226,252,251,231,248,253,249,247,250,
222,192,193,214,196,197,212,195,213,200,201,202,203,204,205,206,
207,223,208,209,210,211,198,194,220,219,199,216,221,217,215,218);

tblCP1251ToCP866 : array [$80..$ff] of byte = (
244,195,240,246,241,245,243,242,176,177,178,179,180,181,182,183,
184,185,186,187,188,189,190,191,192,193,194,247,196,197,198,199,
200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,
216,217,218,219,220,221,222,223,248,249,250,251,252,253,254,255,
128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,
160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,
224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239);

tblCP1251ToIso : array [$80..$ff] of byte = (
128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,
160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,
240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,
176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,
192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,
208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,
224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239);

tblCP1251ToKoi8 : array [$80..$ff] of byte = (
128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,
144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,
160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,
176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,
225,226,247,231,228,229,246,250,233,234,235,236,237,238,239,240,
242,243,244,245,230,232,227,254,251,253,255,249,248,252,224,241,
193,194,215,199,196,197,214,218,201,202,203,204,205,206,207,208,
210,211,212,213,198,200,195,222,219,221,223,217,216,220,192,209);

tblSS4615ToCP1251 : array [1..122] of char = (
'Ú','Û','Ü','Ý','Þ','ß',#168,'ú','û','ý','ü','þ','ÿ','å','^','D',
'F','G','I','J','L','N','Q','R','S','U','V','W','Y','Z','b',' ',
'!','"','#','$','%','&','''','(',')','*','+',',','-','.','/','0',
'1','2','3','4','5','6','7','8','9',':',';','<','=','>','?','@',
'À','Á','Â','Ã','Ä','Å','Æ','Ç','È','É','Ê','Ë','Ì','Í','Î','Ï',
'Ð','Ñ','Ò','Ó','Ô','Õ','Ö','×','Ø','Ù',' ','l','f','c',' ','k',
'à','á','â','ã','ä','å','æ','ç','è','é','ê','ë','ì','í','î','ï',
'ð','ñ','ò','ó','ô','õ','ö','÷','ø','ù');

function SS4615ToCP1251Ch (c : char) : char;
 begin
  if c > #127 then c := char (ord (c) and $7f);
  if (c <= #122) and (c > #0) then Result := tblSS4615ToCP1251 [ord (c)]
   else Result := ' ';
 end;

function CP1251ToSS4615Ch (c : char) : char;
 var i : integer;
 begin
  Result := ' ';
  for i := 1 to 122 do if tblSS4615ToCP1251 [i] = c then begin
    Result := char (i);
    BREAK;
   end;
 end;

function SS4615ToCP1251 (s : string) : string;
 var i : word;
 begin
  for i := 1 to length(s) do s[i] := SS4615ToCP1251Ch (s[i]);
  Result := s;
 end;

function CP1251ToSS4615 (s : string) : string;
 var i : word;
 begin
  for i := 1 to length(s) do s[i] := CP1251ToSS4615Ch (s[i]);
  Result := s;
 end;

function GostToCP1251Ch (c : char) : char;
 begin
  if c < #$80 then Result := c
   else Result := char (tblGostToCP1251 [ord (c)]);
 end;

function CP1251ToGostCh (c : char) : char;
 begin
  if c < #$80 then Result := c
   else Result := char (tblCP1251ToGost [ord (c)]);
 end;

function Koi8ToCP1251Ch (c : char) : char;
 begin
  if c < #$80 then Result := c
   else Result := char (tblKoi8ToCP1251 [ord (c)]);
 end;

function CP1251ToKoi8Ch (c : char) : char;
 begin
  if c < #$80 then Result := c
   else Result := char (tblCP1251ToKoi8 [ord (c)]);
 end;

function IsoToCP1251Ch (c : char) : char;
 begin
  if c < #$80 then Result := c
   else Result := char (tblIsoToCP1251 [ord (c)]);
 end;

function CP1251ToIsoCh (c : char) : char;
 begin
  if c < #$80 then Result := c
   else Result := char (tblCP1251ToIso [ord (c)]);
 end;

function GostToCP1251 (s : string) : string;
 var
{ sz : array [0..255] of char;}
  i : word;
 begin
  for i := 1 to length(s) do if s[i] >= #$80
    then s[i] := char (tblGostToCP1251 [ord (s[i])]);
  Result := s; {}
{   do if s[i] >= #$b0 then
    if s[i] >= #$d0 then dec (s[i], $20)
     else inc (s[i], $30);
  StrPCopy (sz, s);
  OemToAnsi (sz, sz);
  Result := StrPas (sz);}
 end;

function CP1251ToGost (s : string) : string;
 var
{ sz : array [0..255] of char;}
  i : word;
 begin
{  StrPCopy (sz, s);
  AnsiToOem (sz, sz);
  s := StrPas (sz);}
  for i := 1 to length(s) do if s[i] >= #$80
   then s[i] := char (tblCP1251ToGost [ord (s[i])]);
  Result := s; {}
{   do if s[i] >= #$b0 then
    if s[i] >= #$e0 then dec (s[i], $30)
     else inc (s[i], $20);
  Result := s;}
 end;

function CP866ToCP1251Ch (c : char) : char;
 var s : word;
 begin
  s := ord (c);
  OemToCharBuff (@s, @s, 1);
  Result := char (s);
 end;

function CP1251ToCP866Ch (c : char) : char;
 var s : word;
 begin
  s := ord (c);
  CharToOemBuff (@s, @s, 1);
  Result := char (s);
 end;


function CharFromCP (c : byte; CPg : TDECodePage) : char;
 begin
  case CPg of
    cGOST: Result := GostToCP1251Ch (char (c));
    c866: Result := CP866ToCP1251Ch (Char (c));
    cKOI8: Result := Koi8ToCP1251Ch (Char (c));
    cISO: Result := IsoToCP1251Ch (Char (c));
    cSS4615: Result := SS4615ToCP1251Ch (Char (c));
    else Result := char (c);
   end;
 end;

function CharToCP (c : byte; CPg : TDECodePage) : byte;
 begin
  case CPg of
    cGOST: Result := ord (CP1251ToGostCh (char (c)));
    c866: Result := ord (CP1251ToCP866Ch (char (c)));
    cKOI8: Result := ord (CP1251ToKoi8Ch (char (c)));
    cISO: Result := ord (CP1251ToIsoCh (char (c)));
    cSS4615: Result := ord (CP1251ToSS4615Ch (char (c)));
    else Result := ord (c);
   end;
 end;

function StrFromCP (const s : string; CPg : TDECodePage) : string;
 var i : integer;
 begin
  Result := '';
  for i := 1 to length (s)
   do Result := Result + CharFromCP (Ord (s[i]), CPg);
 end;

function StrToCP (const s : string; CPg : TDECodePage) : string;
 var i : integer;
 begin
  Result := '';
  for i := 1 to length (s)
   do Result := Result + Char (CharToCP (Ord (s[i]), CPg));
 end;

const
Base64In: array [#0 .. #127] of Byte = (
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255,  62, 255, 255, 255,  63,  52,  53,  54,  55,
     56,  57,  58,  59,  60,  61, 255, 255, 255,  64, 255, 255, 255,
      0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,
     13,  14,  15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,
    255, 255, 255, 255, 255, 255,  26,  27,  28,  29,  30,  31,  32,
     33,  34,  35,  36,  37,  38,  39,  40,  41,  42,  43,  44,  45,
     46,  47,  48,  49,  50,  51, 255, 255, 255, 255, 255
);

const
 InlineFinder : TRegExpr = nil;

function SevenBit2EightBit (const s : string) : string;
// replace all =?ccc?Q?=xx ... ?=
// and =?ccc?B?z...?= with their 8-bits equivalents
// if ccc = KOI8-R then decode from KOI8-R to Win1251
// else do not other decoding
 var
  PrevPos, BodyLen : integer;
  body, qs : string;
  i : integer;
  DataIn0, DataIn1, DataIn2, DataIn3 : byte;
 begin
  Result := '';
  PrevPos := 1;
  if InlineFinder.Exec (s) then
   REPEAT
    Body := InlineFinder.Match [3]; // inline body
    BodyLen := length (Body);
    qs := '';
    if UpperCase (InlineFinder.Match [2]) = 'Q' then begin // quoted printable
       i := 1;
       while i <= BodyLen do begin
         if Body [i] = '=' then begin
            qs := qs + char (StrToIntDef ('$' + copy (Body, i + 1, 2), $20));
            inc (i, 2);
           end
          else qs := qs + Body [i];
         inc (i);
        end;
      end
     else begin // Base64 ('B') ?
       i := 1;
       while i <= BodyLen do begin
         DataIn0 := Base64In [Body [i + 0]];
         if i + 1 <= BodyLen
          then DataIn1 := Base64In [Body [i + 1]]
          else DataIn1 := $40;
         if i + 2 <= BodyLen
          then DataIn2 := Base64In [Body [i + 2]]
          else DataIn2 := $40;
         if i + 3 <= BodyLen
          then DataIn3 := Base64In [Body [i + 3]]
          else DataIn3 := $40;
         qs := qs + char ((DataIn0 and $3F) shl 2 + (DataIn1 and $30) shr 4);
         if DataIn2 <> $40 then begin
           qs := qs + char ((DataIn1 and $0F) shl 4 + (DataIn2 and $3C) shr 2);
           if DataIn3 <> $40
            then qs := qs + char ((DataIn2 and $03) shl 6 + (DataIn3 and $3F));
          end;
         inc (i, 4); 
        end;
      end;
    if UpperCase (InlineFinder.Match [1]) = 'KOI8-R'
     then qs := StrFromCP (qs, cKOI8);
    Result := Result + System.Copy (s, PrevPos,
      InlineFinder.MatchPos [0] - PrevPos) + qs;
    PrevPos := InlineFinder.MatchPos [0]
     + InlineFinder.MatchLen [0];
   UNTIL not InlineFinder.ExecNext;
  Result := Result + System.Copy (s, PrevPos, MaxInt);
 end;

initialization

 InlineFinder := TRegExpr.Create;
 InlineFinder.Expression :=
  '=\?([\w\d-]+)\?([BbQq])\?([\w\d=+/-]+)\?=';


finalization

 InlineFinder.Free;

end.

