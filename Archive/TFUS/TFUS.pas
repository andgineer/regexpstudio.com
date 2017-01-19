{$B-}
unit TFUS;

{

 Too Frequently Used Staff
 v. 2.0 16.08.1999

 Andrey Sorokin, Saint-Petersburg, Russia
 (anso@mail.ru, anso@usa.net)

 some ideas derived from RX Lib (http://rx.demo.ru)

}

interface

uses
 Windows, Classes, Controls, Comctrls, SysUtils, Dialogs, StdCtrls;

{$IFDEF VER80} { Delphi 1.0}
 Sorry - 32-bits version only (Delphi 2 or later)
{$ENDIF}
{$IFDEF VER90} { Delphi 2.0}
 {$DEFINE _D2}
 {$DEFINE D2}
 {$DEFINE D2_}
{$ENDIF}
{$IFDEF VER100} { Delphi 3.0}
 {$DEFINE D2_}
 {$DEFINE _D3}
 {$DEFINE D3}
 {$DEFINE D3_}
{$ENDIF}
{$IFDEF VER120} { Delphi 4.0}
 {$DEFINE D2_}
 {$DEFINE D3_}
 {$DEFINE _D4}
 {$DEFINE D4}
 {$DEFINE D4_}
{$ENDIF}
{$IFDEF VER130} { Delphi 5.0}
 {$DEFINE D2_}
 {$DEFINE D3_}
 {$DEFINE D4_}
 {$DEFINE _D5}
 {$DEFINE D5}
 {$DEFINE D5_}
{$ENDIF}

{$IFDEF _D3}
type TSysCharSet = set of Char;
{$ENDIF}


{ ================== Date/time routines =====================}

function GMTNow: TDateTime;
// wrapper, fix bug in GetSystemTime

function GMT2Local (GMTTime : TDateTime) : TDateTime;
// ! WinNT only ! converts GMT-time to local system time

function GMTBias : TDateTime;
// return bias from GMT to local time (GMT = local + bias)

function Date2Str (d : TDateTime) : string;
// d -> dd.mm.yyyy - for storing in text format

function Str2Date (const s : string) : TDateTime;
// dd.mm.yyyy -> TDateTime
// !! if errors, then raise exceptions

function Slices2Date (const AYear, AMonth, ADay : string) : TDateTime;
// convert date part strings into TDateTime
// !! if errors, then raise exceptions

function Time2Str (d : TDateTime) : string;
// d -> hh:mm:ss.ms - for storing in text format

function Str2Time (const s : string) : TDateTime;
// hh:mm:ss.ms -> TDateTime
// !! if errors, then raise exceptions

function TimeDiffInSec (t1, t2 : TDateTime) : integer;
// (t2 - t1) -> seconds
// if t2 <= t1 then return 0 !!! don't change this !!!
// if more then 68 years, then return 68 years (68*365*24*60*60),

function Seconds2Time (s : integer) : TDateTime;
// s (as seconds) -> TDateTime

procedure Delay (MSecs: LongInt);
// Call ProcessMessages during MSecs ms

function FormatInterDateTime (const s : string; d : TDateTime) : string;
// convert d into string representation using template from s.
// '@' trigger timezones: '@10+' GMT+10 hours
// '%yyyy', '%yy' - year
// '%mm', '%m' - month
// '%dd', '%d' - day
// '%hh', '%h' - hour
// '%nn', '%n' - minutes
// '%cc', '%c' - seconds (not 's' for prevents misplacing with
//  Format's template '%s')
// Example:
// '%yyyy.%mm.%dd %hh:%nn:%cc GMT, @3+%d.%mm.%yyyy %h:%nn:%cc MSK'
// - show date/time for GMT and Moscow time zones

function IBDateStr (d : TDateTime) : string;
// returns d converted into InterBase format (dd.mm.yyyy)

{ ==================== String routines ======================}
function Bool2Char (AValue : boolean) : string;
// returns "T" for True and "F" for False

function Char2Bool (AChar : string) : boolean;
// Returns True for "T"/"1"/"ON" and False for
// "F"/"0"/"OFF"/"" (caseinsens.).
// Raise exception for other input string !

function RandomHex (ALen : integer) : string;
// Random HEX-"number" (ALen chars length)

function RandomStr (ALen : integer) : string;
// Random strings (ALen chars from ['0'..'9',
// 'A'..'Z'(except 'I', 'J', 'L' - seems '1', 'O' - seems '0')])
// works more faster then RandomString

function CheckCharsInString (const s : string; const ACharSet : TSysCharSet) : boolean;
// false if in s exists chars not from ACharSet

function AddCharL (C: Char; const S: string; N: Integer): string;
// AddChar return a string left-padded to length N with characters C.

function AddCharR (C: Char; const S: string; N: Integer): string;
// AddCharR return a string right-padded to length N with characters C.

function cmpURIRoot (const Name, URI : string) : boolean;

function CmpIPStr (const IP1, IP2 : string) : integer;
// Возвращает сколько октетов совпало в передаваемых
// в текст виде IP-адресах (если 4 - то полное совпадение.).

function sCmp (const s1, s2 : string) : boolean;
// AnsiCompareText wrapper

function sCmpBeg (const s1, s2 : string) : boolean;
// same as sCmp, but truncate s2 to length of s1

function StrPosCI (AStr1, AStr2 : PChar) : PChar;
// StrPosCI returns a pointer to the first occurance
// of AStr2 in AStr1. Search performed in case-insensitive
// mode (using CharUpper).

function ReplaceStr (const S, Srch, Replace: string): string;
// Returns string with every occurrence of Srch string replaced with
//  Replace string.

function SelectComboBoxItem (AComboBox : TCustomComboBox; AID : integer) : boolean;
// Select item of AComboBox with integer(Object)= AID
// returns false if no such item.

function ProperCase(const S: string; const WordDelims: TSysCharSet): string;
{ Returns string, with the first letter of each word in uppercase,
  all other letters in lowercase. Words are delimited by WordDelims. }

function EMailAddressString (const AName, AAddr : string) : string;

function PeelQuotes (const s : string) : string;

function TrimLines (const ALines : string) : string;
// Remove leading and trailing empty lines (parts of string,
// separated by #$d#$a or #$d or #$a).
// If there are only spaces, #$d and #$a, returns empty string

function InitialsFromName (const AName : string; AMaxNum : integer = 3) : string;

function LimitLinesLen (const AText : string;
  const APrefix : string; AMaxLineLen, AMaxErr : integer) : string;

function TruncateString (const AStr : string; AMaxLen : integer) : string;
// Truncate AStr up to AMaxLen chars
// (if length (AStr) <= AMaxLen then returns AStr, else - copy (AStr, 1, AMaxLen))

{ ============== Word manipulation routines =================}
function WordCount (const S: string; const WordDelims: TSysCharSet): Integer;
// Number of words in S (separated by WordDelims)

function WordPosition (const N: Integer; const S: string;
  const WordDelims: TSysCharSet): Integer;
// Start position of word # N in strins S (separators from WordDelims)

function ExtractWord (N: Integer; const S: string;
  const WordDelims: TSysCharSet): string;
// Return word # N from string S (separators from WordDelims)

function ExtractWordPos (N: Integer; const S: string;
  const WordDelims: TSysCharSet; var Pos: Integer): string;
// Same as ExtractWord, but returns at Pos Word's posirion


{ ================== File names routines ====================}

const
 AppBasePath : string = ''; // initialized as ExeFolder
 UseAppRelPath : boolean = true;
 // if true then RelPath by default work with AppBasePath
 // if false then RelPath == AddBSlash

function ExeFolder : string;
// determine application start folder

function AddBSlash (const AFilePath : string) : string;
// Add back slash at end of AFileName, prevent dupl

function DelBSlash (const AFilePath : string) : string;
// Remove back slash from end of AFileName (if it exists)

function SetFileExt (const AFileName, AExt : string) : string;
// change (or add) file extention ot AFileName to AExt

function AbsPath (const AFilePath : string; const ABasePath, ASubBasePath : string) : string;
{$IFDEF D4_} overload;
function AbsPath (const AFilePath : string; const ABasePath : string = '') : string; overload;
{$ENDIF}
// if AFilePath starts from '.\' then replace '.' with ABasePath
// if ABasePath undefined (= '') then replace it with AppBasePath

function AbsPathWBS (const AFilePath : string; const ABasePath : string {$IFDEF D4_}= ''{$ENDIF}) : string;
// equiv AddBSlash (AbsPath (..))

function RelPath (const AFilePath : string; const ABasePath, ASubBasePath : string) : string;
{$IFDEF D4_} overload;
function RelPath (const AFilePath : string; const ABasePath : string = '') : string; overload;
{$ENDIF}
// if AFilePath starts from ABasePath then replace this part with '.\'
// if ABasePath undefined (= '')
// then if UseAppRelPath = true then uses AppBasePath instead ABasePath
//       else simply copy AFilePath

function GetFileSize (const FileName: string): {$IFDEF D4_}Int64{$ELSE}integer{$ENDIF};
// Return size of file FileName

function MakeTempFileName (const FilePath : string {$IFDEF D4_}= ''{$ENDIF}; const FileNamePref : string {$IFDEF D4_}= ''{$ENDIF}; const FileExt : string {$IFDEF D4_}= '.$$$'{$ENDIF}) : string;
// Create new temp.file and return his stream handler
// if FilePath = '' then create file in temp-folder,
// if FileExt = '' then create file with '.$$$' extension

function UnixDirEntryStr (const AFilePath, AFileName : string) : String;
// file description in Unix format (for FTP & etc.)

function MatchFileNameTemplate (AFileName, ATemplate: string): Boolean;
// true if AFileName match ATemplate

{ ==================== System routines ======================}

function MsgBox (const Caption, Text: string; Flags: Integer): Integer;
// Message box

function MsgDlg (const Msg: string; AType: TMsgDlgType;
  AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
// Message dialog

{$IFDEF D4_}
type
 DynamicArrayOfInteger = array of integer;
 DynamicArrayOfString = array of string;
function MakeDynamicArrayOfInteger (AInts : array of integer) : DynamicArrayOfInteger;
function MakeDynamicArrayOfString (AStrs : array of string) : DynamicArrayOfString;
// Fill Result array with strings from AStrs.
{$ENDIF}

function GetVersionStr : string;
// Returns 'file version' parameter of VersionInfo resource

function CheckAppAlreadyRunning (const AppSign : string;
           BringToFront : boolean {$IFDEF D4_}= true{$ENDIF}; DestroyOnExit : boolean {$IFDEF D4_}= false{$ENDIF}) : boolean;
// prevent double-starting of application. AppSign
// - unique identifier of application (this function
// will make file in mem with this name)
// If BringToFront then send th prev instance msg RESTORE.
// If DestroyOnExit, then mapview will be closed (only for presence check,
// will not prevent starting apps with this AppSign).

function ExecuteFile (const FileName, Params, DefaultDir: string; ShowCmd: Integer) : THandle;
// Wrapper for ShellExecute

function ShellFolder (FolderID : integer) : string;
// Wrapper for SHGetSpecialFolderLocation

function ProgramFilesFolder : string;
// HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ProgramFilesDir

function CreateShortCut (const CmdLine, Args, WorkDir,
  LinkFile : string) : boolean;

procedure CopyFile(const FileName, DestName: string;
  ProgressControl: TProgressBar);

procedure CopyDirectory (const SourcePath, DestPath : string);

function MakeUnInstallEntry (const KeyName, DisplayStr, UnInstallerName : string) : boolean;

function RemoveUnInstallEntry (const KeyName : string) : boolean;

procedure Suicide;
// uses MoveFileAfterReboot for deleting this app's .exe

procedure MoveFileAfterReboot (const Source, Dest : string);
// move locked files (MoveFileEx in NT, wininit.ini in Win9x)

procedure GetOSVerInfo (var OSID : DWORD; var OSStr : string);

function OSisNT : boolean;
// True, if app is running under Windows NT

procedure GetCPUInfo (var CPUID : DWORD; var CPUStr : string);

procedure GetMemInfo (var MemStr : string);



implementation

uses
 ShellAPI, Messages, Consts, shlObj, ComObj, ActiveX, RegStr,
 Registry, Forms, FileCtrl, IniFiles;

{ ================== Date/time routines =====================}

function GMTNow;
 var
  lpSystemTime: TSystemTime;
  lpFileTime, lpLocalFileTime: TFileTime;
 begin
  { fix bug of GetSystemTime (on some systems it returns LocalTime)}
  GetLocalTime (lpSystemTime);
  with lpSystemTime do begin
    if SystemTimeToFileTime (lpSystemTime, lpLocalFileTime) then
    if LocalFileTimeToFileTime (lpLocalFileTime, lpFileTime) then
    if FileTimeToSystemTime (lpFileTime, lpSystemTime) then begin
      Result := EncodeDate (wYear, wMonth, wDay) +
                EncodeTime (wHour, wMinute, wSecond, wMilliseconds);
      Exit;
     end;
   end;
  GetSystemTime (lpSystemTime);
  with lpSystemTime do
   Result := EncodeDate (wYear, wMonth, wDay) +
             EncodeTime (wHour, wMinute, wSecond, wMilliseconds);
 end; { of function GMTNow
--------------------------------------------------------------}

{$IFDEF _D3}
const
 TIME_ZONE_ID_STANDARD = 1;
 TIME_ZONE_ID_DAYLIGHT = 2;
{$ENDIF}
function GMTBias : TDateTime;
 var tz : TTimeZoneInformation;
 begin
  case GetTimeZoneInformation (tz) of
    TIME_ZONE_ID_STANDARD : Result := Seconds2Time ((tz.Bias + tz.StandardBias) * 60);
    TIME_ZONE_ID_DAYLIGHT : Result := Seconds2Time ((tz.Bias + tz.DayLightBias) * 60);
    else raise Exception.Create ('GMTBias: GetTimeZoneInformation fail.');
   end;
 end; { of function GMTBias
--------------------------------------------------------------}

function GMT2Local (GMTTime : TDateTime) : TDateTime;
 var
  lpLocalTime, lpUniversalTime : TSystemTime;
 begin
  with lpUniversalTime do begin
    DecodeDate (Trunc (GMTTime), wYear, wMonth, wDay);
    DecodeTime (Frac (GMTTime), wHour, wMinute, wSecond, wMilliseconds);
   end;
  if SystemTimeToTzSpecificLocalTime (
    nil, // pointer to time zone of interest, local system if nil
    lpUniversalTime, // pointer to universal time of interest
    lpLocalTime) // pointer to structure to receive local time
   then with lpLocalTime do
         Result := EncodeDate (wYear, wMonth, wDay)
         + EncodeTime (wHour, wMinute, wSecond, wMilliseconds)
   else raise Exception.Create ('GMT2Local: SystemTimeToTzSpecificLocalTime fail.');
 end; { of function GMT2Local
--------------------------------------------------------------}

function i2s (n, d : integer) : string;
 begin
  Result := IntToStr (n);
  while length (Result) < d do
   Result := '0' + Result;
 end; { of function i2s
--------------------------------------------------------------}

function Date2Str (d : TDateTime) : string;
 var yy, mm, dd : word;
 begin
  DecodeDate (d, yy, mm, dd);
  Result := i2s(dd, 2) + '.' + i2s(mm, 2) + '.' + i2s(yy, 4);
 end; { of function Date2Str
--------------------------------------------------------------}

function Slices2Date (const AYear, AMonth, ADay : string) : TDateTime;
 var dd, mm, yy : word;
 begin
  if (length (AYear) = 0) or (length (AMonth) = 0) or (length (ADay) = 0)
   then raise Exception.Create (
    'Str2Date: Wrong date string format "'
     + AYear + '.' + AMonth + '.' + ADay + '"');
  dd := StrToInt (ADay); // !!! Can produce EConvertError
  mm := StrToInt (AMonth);
  yy := StrToInt (AYear);
  Result := EncodeDate (yy, mm, dd); // !!! can produce EConvertError
 end; { of function Slices2Date
--------------------------------------------------------------}

function Str2Date (const s : string) : TDateTime;
 begin
  Result := Slices2Date ( //###00.08.17
   ExtractWord (3, s, ['.']),
   ExtractWord (2, s, ['.']),
   ExtractWord (1, s, ['.']) );
 end; { of function Str2Date
--------------------------------------------------------------}

function Time2Str (d : TDateTime) : string;
 var hh, mm, ss, ms : word;
 begin
  DecodeTime (d, hh, mm, ss, ms);
  Result := i2s(hh, 2) + ':' + i2s(mm, 2)
   + ':' + i2s(ss, 2) + '.' + IntToStr (ms);
 end; { of function Time2Str
--------------------------------------------------------------}

function Str2Time (const s : string) : TDateTime;
 var
  hh, mm, ss, ms : word;
  ts : string;
 begin
  if s = '' then raise Exception.Create (
   'Str2Time: Wrong time string format "' + s + '"');
  hh := StrToInt (ExtractWord (1, s, [':']));
  mm := StrToInt (ExtractWord (2, s, [':']));
  ts := ExtractWord (3, s, [':']);
  ss := StrToInt (ExtractWord (1, ts, ['.']));
  ms := StrToInt (ExtractWord (2, ts, ['.']));
  Result := EncodeTime (hh, mm, ss, ms); // EConvertError
 end; { of function Str2Time
--------------------------------------------------------------}

function TimeDiffInSec (t1, t2 : TDateTime) : integer;
// var hh, mm, ss, ms : word;
 begin
  if t2 <= t1 then Result := 0
   else begin
//     DecodeTime (t2 - t1, hh, mm, ss, ms);
//     Result := (hh * 60 + mm) * 60 + ss;
     if Round (t2 - t1) div (365 * 68) > 0
      then Result := 68 * 365 * 60 * 60 * 24
      else Result := Round ((t2 - t1) * 60 * 60 * 24);
    end;
 end; { of function TimeDiffInSec
--------------------------------------------------------------}

function Seconds2Time (s : integer) : TDateTime;
// var d : integer;
 begin
//  d := s div (24 * 60 * 60);
  Result := s / (24.0 * 60 * 60)
//   EncodeTime ((s div 60) div 60 mod 24, (s div 60) mod 60, s mod 60, 0)
//   + EncodeDate ((d div 12) div 30, (d div 30) mod 12, d mod 30);
 end; { of function Seconds2Time
--------------------------------------------------------------}

procedure Delay (MSecs: LongInt);
 var FirstTickCount, Now: Longint;
 begin
  FirstTickCount := GetTickCount;
  repeat
    Application.ProcessMessages;
    { allowing access to other controls, etc. }
    Now := GetTickCount;
  until (Now - FirstTickCount >= MSecs) or (Now < FirstTickCount);
 end; { of procedure Delay
--------------------------------------------------------------}

function FormatInterDateTime (const s : string; d : TDateTime) : string;
 var
  i, j, n, dt : integer;
  d2 : TDateTime;
  w : string;
  yy, mm, dd, hh, nn, ss, ms : word;
  yyyy : string;
 begin
  Result := '';
  d2 := d;
  n := WordCount (s, ['@']);
  for i := 1 to n do begin
    w := ExtractWord (i, s, ['@']);
    if (length (w) > 1) and (w [2] in ['+', '-'])
     then j := 3
     else if (length (w) > 2) and (w [3] in ['+', '-'])
      then j := 4
      else j := 1;
    if j > 1 then begin
      dt := StrToIntDef (copy (w, 1, j - 2), -1);
      if dt < 0 then j := 1
       else begin
         if w [j - 1] = '-'
          then dt := - dt;
         d2 := d + dt / 24;
        end;
     end;
    w := copy (w, j, length (w) - j + 1);
    DecodeDate (d2, yy, mm, dd);
    DecodeTime (d2, hh, nn, ss, ms);
    yyyy := IntToStr (yy);

    w := ReplaceStr (w, '%yyyy', yyyy);
    w := ReplaceStr (w, '%yy', copy (yyyy, 3, 2));
    w := ReplaceStr (w, '%mm', AddCharL ('0', IntToStr (mm), 2));
    w := ReplaceStr (w, '%m', IntToStr (mm));
    w := ReplaceStr (w, '%dd', AddCharL ('0', IntToStr (dd), 2));
    w := ReplaceStr (w, '%d', IntToStr (dd));
    w := ReplaceStr (w, '%hh', AddCharL ('0', IntToStr (hh), 2));
    w := ReplaceStr (w, '%h', IntToStr (hh));
    w := ReplaceStr (w, '%nn', AddCharL ('0', IntToStr (nn), 2));
    w := ReplaceStr (w, '%n', IntToStr (nn));
    w := ReplaceStr (w, '%cc', AddCharL ('0', IntToStr (ss), 2));
    w := ReplaceStr (w, '%c', IntToStr (ss));
    Result := Result + w;
   end;
 end; { of function FormatInterDateTime
--------------------------------------------------------------}

function IBDateStr (d : TDateTime) : string;
 var
  dd, mm, yy : word;
 begin
  DecodeDate (d, yy, mm, dd);
  Result := IntToStr (dd) + '.' + IntToStr (mm) + '.' + IntToStr (yy);
 end; { of function IBDateStr
--------------------------------------------------------------}

{ ==================== String routines ======================}

function Bool2Char (AValue : boolean) : string;
 begin
  if AValue
   then Result := 'T'
   else Result := 'F';
 end; { of function Bool2Char
--------------------------------------------------------------}

function Char2Bool (AChar : string) : boolean;
 begin
  if sCmp (AChar, 'T') or (AChar = '1')
     or sCmp (AChar, 'ON')
   then Result := true
  else if sCmp (AChar, 'F') or (AChar = '0')
     or sCmp (AChar, 'OFF') or (length (AChar) <= 0)
   then Result := false
  else raise Exception.Create (
   'TFUS.Char2Bool: bad input parameter "' + AChar + '"');
 end; { of function Char2Bool
--------------------------------------------------------------}

function RandomHex (ALen : integer) : string;
 var n, k : integer;
 begin
  Result := '';
  n := ALen;
  while n > 0 do begin
    if n > 7 then k := 7
     else k := n;
    Result := Result + IntToHex (Random (1 shl (4 * k) - 1), k);
    dec (n, k)
   end;
 end; { of function RandomHex
--------------------------------------------------------------}

function RandomStr (ALen : integer) : string;
 const Tbl : array [0 .. $1F] of char = (
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B',
  'C', 'D', 'E', 'F', 'G', 'H', 'K', 'M', 'N', 'P', 'Q', 'R',
  'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z');
 var i, n, k, x, j : integer;
 begin
  SetString (Result, nil, ALen);
  n := ALen * 5; // bits in random number
  j := 1;
  while n > 0 do begin
    if n > 30 then k := 30 // work with 32-bits numbers
     else k := n;
    x := Random (1 shl k - 1);
    for i := 1 to k div 5 do begin
      Result [j] := Tbl [x and $1F];
      inc (j);
      x := x ShR 5;
     end;
    dec (n, k)
   end;
 end; { of function RandomStr
--------------------------------------------------------------}

function CheckCharsInString (const s : string; const ACharSet : TSysCharSet) : boolean;
 var i : integer;
 begin
  Result := false;
  for i := 1 to length (s) do
   if not (s [i] in ACharSet)
    then EXIT;
  Result := true;
 end; { of function CheckCharsInString
--------------------------------------------------------------}

function MakeStr (C: Char; N: Integer): string;
 begin
  if N < 1 then Result := ''
  else begin
{$IFNDEF WIN32}
    if N > 255 then N := 255;
{$ENDIF WIN32}
    SetLength (Result, N);
    FillChar (Result [1], Length (Result), C);
   end;
 end; { of function MakeStr
--------------------------------------------------------------}

function AddCharL (C: Char; const S: string; N: Integer): string;
 begin
  if Length (S) < N
   then Result := MakeStr (C, N - Length(S)) + S
   else Result := S;
 end; { of function AddCharL
--------------------------------------------------------------}

function AddCharR (C: Char; const S: string; N: Integer): string;
 begin
  if Length (S) < N
   then Result := S + MakeStr (C, N - Length(S))
   else Result := S;
 end; { of function AddCharR
--------------------------------------------------------------}

function cmpURIRoot (const Name, URI : string) : boolean;
 begin
  Result :=
   (
    (length (URI) = length (Name))
     or (
         (length (URI) > length (Name))
          and (URI [length (Name) + 1]
               in ['\','/','?'])
        )
   )
   and sCmp (copy (URI, 1, length (Name)), Name);
 end; { of function cmpURIRoot
--------------------------------------------------------------}

function CmpIPStr (const IP1, IP2 : string) : integer;
 var
  i : integer;
  a1, a2 : string;
 begin
  Result := 0;
  // на всякий случай вырубаем номер порта (если указан)
  a1 := Trim (IP1);
  if pos (':', a1) > 0
   then a1 := ExtractWord (1, a1, [':']);
  a2 := Trim (IP2);
  if pos (':', a2) > 0
   then a2 := ExtractWord (1, a2, [':']);
  for i := 1 to 4 do
   if StrToIntDef (ExtractWord (i, a1, ['.']), -1)
    = StrToIntDef (ExtractWord (i, a2, ['.']), -2)
    then inc (Result)
    else EXIT;
 end; { of function CmpIPStr
--------------------------------------------------------------}

function sCmp (const s1, s2 : string) : boolean;
 begin
  Result := AnsiCompareText (s1, s2) = 0;
 end; { of function sCmp
--------------------------------------------------------------}

function sCmpBeg (const s1, s2 : string) : boolean;
 begin
  Result := AnsiCompareText (s1, copy (s2, 1, length (s1))) = 0;
 end; { of function sCmpBeg
--------------------------------------------------------------}

function StrPosCI (AStr1, AStr2 : PChar) : PChar;
 var
  p, p2 : PChar;
  chs : set of char;
 begin
  Result := nil;
  // prevent AV
  if AStr2^ = #0
   then EXIT;
  // inline first char for speed
  chs := [AStr2^, char (CharUpper (pointer (AStr2^))),
          char (CharLower (pointer (AStr2^))), #0];
  REPEAT
    // fast scan for first char
    while not (AStr1^ in chs)
     do inc (AStr1^);
    // full compare
    if AStr1^ <> #0 then begin
      p := AStr1 + 1;
      p2 := AStr2 + 1;
      while (p^ <> #0) and (p2^ <> #0)
         and (CharUpper (pointer (p^)) = CharUpper (pointer (p2^))) do begin
        inc (p);
        inc (p2);
       end;
      if p2^ = #0 then begin // Gotcha !
        Result := AStr1;
        EXIT;
       end;
     end;
  UNTIL AStr1^ = #0;
 end; { of function StrPosCI
--------------------------------------------------------------}

function ReplaceStr (const S, Srch, Replace: string): string;
 var
  i : integer;
  Source: string;
 begin
  Source := S;
  Result := '';
  REPEAT
    i := Pos (Srch, Source);
    if i > 0 then begin
      Result := Result + Copy (Source, 1, i - 1) + Replace;
      Source := Copy (Source, i + Length (Srch), MaxInt);
     end
    else Result := Result + Source;
  UNTIL i <= 0;
 end; { of function ReplaceStr
--------------------------------------------------------------}

function SelectComboBoxItem (AComboBox : TCustomComboBox; AID : integer) : boolean;
 var i : integer;
 begin
  i := AComboBox.Items.IndexOfObject (TObject (AID));
  Result := i >= 0;
  if Result
   then AComboBox.ItemIndex := i;
 end; { of function SelectComboBoxItem
--------------------------------------------------------------}

function ProperCase (const S: string; const WordDelims: TSysCharSet): string;
 var
  SLen, i : Cardinal;
 begin
  Result := AnsiLowerCase (S);
  i := 1;
  SLen := Length (Result);
  while i <= SLen do begin
    while (i <= SLen) and (Result[i] in WordDelims)
     do Inc (i);
    if i <= SLen
     then Result [i] := AnsiUpperCase (Result [i]) [i];
    while (i <= SLen) and not (Result [i] in WordDelims)
     do Inc (i);
   end;
 end; { of function ProperCase
--------------------------------------------------------------}

function EMailAddressString (const AName, AAddr : string) : string;
 begin
  Result := '';
  if AName <> '' then
   if pos ('"', AName) <= 0
    then Result := '"' + AName + '"'
    else Result := AName;
  if AAddr <> '' then begin
    if Result <> ''
     then Result := Result + ' ';
    Result := Result + '<' + AAddr + '>';
   end;
 end; { of function EMailAddressString
--------------------------------------------------------------}

function PeelQuotes (const s : string) : string;
 var
  Len : integer;
 begin
  Result := Trim (s);
  Len := length (Result);
  if (len > 1) and (Result [1] = '"')
      and (Result [len] = '"')
   then Result := System.Copy (Result, 2, Len - 2);
 end; { of function PeelQuotes
--------------------------------------------------------------}

function TrimLines (const ALines : string) : string;
 const
  LfCrSet = [#$d, #$a];
  LfCrSpaceSet = LfCrSet + [' ', #$9, #$c];
 var
  i, n0, nZ, Len : integer;
 begin
  Len := length (ALines);
  // skip leading blank lines
  n0 := 1; // will contain start pos of first non-empty line
  i := n0;
  while (i <= Len) and (ALines [i] in LfCrSpaceSet) do begin
    if ALines [i] in LfCrSet
     then n0 := i + 1;
    inc (i);
   end;
  // skip trailing blank lines
  nZ := Len;
  i := nZ;
  while (i >= n0) and (ALines [i] in LfCrSpaceSet) do begin
    if ALines [i] in LfCrSet
     then nZ := i;
    dec (i);
   end;
  // if #$d / #$a found, check for pair #$a / #$d
  if (nZ < Len) and (
      (ALines [nZ] = #$d) and (ALines [nZ + 1] = #$a)
      or (ALines [nZ] = #$a) and (ALines [nZ + 1] = #$d))
   then inc (nZ);
  // Return result
  if (n0 = 1) and (nZ = Len)
   then Result := ALines // no empty lines found
  else if (n0 <= nZ) and (n0 <= Len)
   then Result := copy (ALines, n0, nZ - n0 + 1)
  else Result := ''; // no non-empty lines found
 end; { of function TrimLines
--------------------------------------------------------------}



{ ============== Word manipulation routines =================}

function WordCount (const S: string; const WordDelims: TSysCharSet): Integer;
 var SLen, i: Cardinal;
 begin
  Result := 0;
  i := 1;
  SLen := Length (S);
  while i <= SLen do begin
    while (i <= SLen) and (S [i] in WordDelims)
     do Inc (i);
    if i <= SLen
     then Inc (Result);
    while (i <= SLen) and not(S [i] in WordDelims)
     do Inc (i);
   end;
 end; { of function WordCount
--------------------------------------------------------------}

function WordPosition (const N: Integer; const S: string;
  const WordDelims: TSysCharSet): Integer;
 var Count, i : Integer;
 begin
  Count := 0;
  i := 1;
  Result := 0;
  while (i <= Length (S)) and (Count <> N) do begin
    while (i <= Length (S)) and (S [i] in WordDelims)
     do Inc (i);
    if i <= Length (S)
     then Inc (Count);
    if Count <> N then
      while (i <= Length (S)) and not (S [i] in WordDelims)
       do Inc (i)
    else Result := i;
   end;
 end; { of function WordPosition
--------------------------------------------------------------}

function ExtractWord (N: Integer; const S: string;
  const WordDelims: TSysCharSet): string;
 var i, Len : Integer;
 begin
  Len := 0;
  i := WordPosition (N, S, WordDelims);
  if i <> 0 then
    while (i <= Length (S)) and not(S [i] in WordDelims) do begin
      Inc (Len);
      SetLength (Result, Len);
      Result [Len] := S [i];
      Inc (i);
     end;
  SetLength (Result, Len);
 end; { of function ExtractWord
--------------------------------------------------------------}

function ExtractWordPos (N: Integer; const S: string;
  const WordDelims: TSysCharSet; var Pos: Integer): string;
 var i, Len: Integer;
 begin
  Len := 0;
  i := WordPosition (N, S, WordDelims);
  Pos := i;
  if i <> 0 then
    while (i <= Length (S)) and not (S [i] in WordDelims) do begin
      Inc (Len);
      SetLength (Result, Len);
      Result [Len] := S [i];
      Inc (i);
    end;
  SetLength (Result, Len);
 end; { of function ExtractWordPos
--------------------------------------------------------------}

{ ================== File names routines ====================}

function ExeFolder : string;
 var
  s : string [255];
  i : integer;
 begin
  i := GetModuleFileName (hInstance, @s[1], SizeOf (s) - 2);
  if (i = 0) or (i > 255)
   then raise Exception.Create ('internal error: GetModuleFileName')
   else s [0] := char (i);
  Result := AddBSlash (ExtractFilePath (s));
 end; { of function ExeFolder
--------------------------------------------------------------}

function AddBSlash (const AFilePath : string) : string;
 begin
  Result := AFilePath;
  if (length (Result) > 0) and (Result [length (Result)] <> '\')
   then Result := Result + '\';
 end; { of function AddBSlash
--------------------------------------------------------------}

function DelBSlash (const AFilePath : string) : string;
 begin
  Result := AFilePath;
  if (length (Result) > 0) and ((Result [length (Result)] = '\')
                               or (Result [length (Result)] = '/'))
   then Result := copy (Result, 1, length (Result) - 1);
 end; { of function DelBSlash
--------------------------------------------------------------}

function SetFileExt (const AFileName, AExt : string) : string;
 begin
  Result := Trim (AFileName);
  if Result = ''
   then EXIT;
  if pos ('.', Result) > 0 then begin
    while Result [length (result)] <> '.'
     do Result := copy (Result, 1, length (Result) - 1);
    Result := copy (Result, 1, length (Result) - 1);
   end;
  if Trim (AExt) <> '' then
   if AExt [1] = '.'
    then Result := Result + AExt
    else Result := Result + '.' + AExt;
 end; { of function SetFileExt
--------------------------------------------------------------}

{$IFDEF D4_}
function AbsPath (const AFilePath : string; const ABasePath : string = '') : string;
{$ELSE}
function AbsPathPrim (const AFilePath : string; const ABasePath : string) : string;
{$ENDIF}
 begin
  Result := AFilePath;
  if (length (Result) > 1) and (Result [1] in ['.', ','])
     and (Result [2] in ['\', '/']) then
    if ABasePath = ''
     then Result := AddBSlash (AppBasePath) + copy (Result, 3, MaxInt)
     else Result := AddBSlash (ABasePath) + copy (Result, 3, MaxInt);
 end; { of function AbsPath
--------------------------------------------------------------}

function AbsPath (const AFilePath : string; const ABasePath, ASubBasePath : string) : string;
 begin
  if length (AFilePath) > 1
   then if AFilePath [1] = ','
         then Result := {$IFDEF D4_}AbsPath{$ELSE}AbsPathPrim{$ENDIF} (AFilePath, ASubBasePath)
         else Result := {$IFDEF D4_}AbsPath{$ELSE}AbsPathPrim{$ENDIF} (AFilePath, ABasePath)
   else Result := AFilePath;
 end; { of function AbsPath
--------------------------------------------------------------}

function AbsPathWBS (const AFilePath : string; const ABasePath : string {$IFDEF D4_}= ''{$ENDIF}) : string;
 begin
  Result := AddBSlash (AbsPath (AFilePath, ABasePath{$IFNDEF D4_}, ''{$ENDIF}));
 end; { of function AbsPathWBS
--------------------------------------------------------------}

{$IFDEF D4_}
function RelPath (const AFilePath : string; const ABasePath : string = '') : string;
{$ELSE}
function RelPathPrim (const AFilePath : string; const ABasePath : string) : string;
{$ENDIF}
 var s : string;
 begin
  Result := AFilePath;
  if (ABasePath = '') and UseAppRelPath
   then s := DelBSlash (AppBasePath)
   else s := DelBSlash (ABasePath);
  if (length (s) > 0)
     and ((length (Result) = length (s))
          or ((length (Result) > length (s))
              and (Result [length (s) + 1] in ['\', '/'])))
     and sCmp (copy (Result, 1, length (s)), s)
   then Result := '.\' + copy (Result, length (s) + 2, MaxInt);
 end; { of function RelPath
--------------------------------------------------------------}

function RelPath (const AFilePath : string; const ABasePath, ASubBasePath : string) : string;
 begin
  if AFilePath <> '' then begin
     if ASubBasePath <> ''
      then Result := {$IFDEF D4_}RelPath{$ELSE}RelPathPrim{$ENDIF} (AFilePath, ExtractFilePath (ASubBasePath))
      else Result := AFilePath;
     if length (Result) > 1
      then if Result [1] = '.'
            then Result [1] := ','
            else Result := {$IFDEF D4_}RelPath{$ELSE}RelPathPrim{$ENDIF} (AFilePath, ABasePath);
    end
   else Result := ''
 end; { of function RelPath
--------------------------------------------------------------}

function MakeTempFileName (const FilePath : string {$IFDEF D4_}= ''{$ENDIF}; const FileNamePref : string {$IFDEF D4_}= ''{$ENDIF}; const FileExt : string {$IFDEF D4_}= '.$$$'{$ENDIF}) : string;
 var
  a : array [0 .. MAX_PATH] of char;
  n : integer;
  path : string;
 begin
  path := FilePath;
  if path = '' then
   if GetTempPath (SizeOf (a), a) > 0
    then path := StrPas (a);
  REPEAT
   n := Random (MaxInt);
   Result := AddBSlash (path) + FileNamePref + IntToHex (n, 1) + FileExt;
  UNTIL not FileExists (Result);
 end; { of function MakeTempFileName
--------------------------------------------------------------}

function UnixDirEntryStr (const AFilePath, AFileName : string) : String;
 var
    Attr : String;
    Ext  : String;
    Day, Month, Year : Integer;
    Hour, Min        : Integer;
    ThisYear, ThisMonth, ThisDay : Word;
    f      : TSearchRec;
 const
    StrMonth : array [1..12] of String =
        ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
 begin
  if FindFirst (AFilePath + AFileName, faAnyFile, f) = 0 then try
    DecodeDate(Now, ThisYear, ThisMonth, ThisDay);

    if ((F.Attr and faVolumeID) <> 0) or
       ((F.Attr and faHidden)   <> 0) then begin
        { Ignore hidden files and volume ID entries }
        Result := '';
        Exit;
    end;

    Attr := '-rw-rw-rw-';
    if (F.Attr and faDirectory) <> 0 then
        Attr[1] := 'd';

    if (F.Attr and faReadOnly) <> 0 then begin
        Attr[3] := '-';
        Attr[6] := '-';
        Attr[9] := '-';
    end;

    Ext := UpperCase(ExtractFileExt(F.Name));
    if (Ext = '.EXE') or (Ext = '.COM') or (Ext = '.BAT') then begin
        Attr[4]  := 'x';
        Attr[7]  := 'x';
        Attr[10] := 'x';
    end;

    Day   := (HIWORD(F.Time) and $1F);
    Month := ((HIWORD(F.Time) shr 5) and $0F);
    Year  := ((HIWORD(F.Time) shr 9) and $3F) + 1980;
{   Sec   := ((F.Time and $1F) shl 1); }
    Min   := ((F.Time shr 5) and $3F);
    Hour  := ((F.Time shr 11) and $1F);

    Result := Attr + '   1 ftp      ftp  ' + Format('%11d ', [F.Size]);

    Result := Result + Format('%s %2.2d ', [StrMonth[Month], Day]);
    if Year = ThisYear then
        Result := Result + Format('%2.2d:%2.2d ', [Hour, Min])
    else
        Result := Result + Format('%5d ', [Year]);

    Result := Result + AFileName { f.Name} + #13#10;

    finally SysUtils.FindClose (f);
    end
   else Result := '';
  end; { of function UnixDirEntryStr
--------------------------------------------------------------}

function FindPart (const ATemplate, InputStr: string): Integer;
 var
  i, j : integer;
  Diff : integer;
 begin
  i := Pos ('?', ATemplate);
  if i = 0 then begin
    { if no '?' in ATemplate }
    Result := Pos (ATemplate, InputStr);
    EXIT;
   end;
  { '?' in ATemplate }
  Diff := Length (InputStr) - Length (ATemplate);
  if Diff < 0 then begin
    Result := 0;
    EXIT;
   end;
  { now move ATemplate over InputStr }
  for i := 0 to Diff do begin
    for j := 1 to Length (ATemplate) do begin
      if (InputStr [i + j] = ATemplate [j])
         or (ATemplate [j] = '?') then begin
         if j = Length (ATemplate) then begin
           Result := i + 1;
           EXIT;
         end;
        end
      else BREAK;
     end;
   end;
  Result := 0;
 end; { of function FindPart
--------------------------------------------------------------}

function MatchFileNameTemplate (AFileName, ATemplate: string): Boolean;

 function SearchNextStar (var ATemplate: string): Integer;
  begin
   Result := Pos ('*', ATemplate);
   if Result > 0
    then ATemplate := Copy (ATemplate, 1, Result - 1);
  end;

 var
  TemplateIdx, FileNameIdx: integer;
  i : integer;
  FileNameLen, TemplateLen, TemplatePartLen : integer;
  TemplatePart: string;
 begin
  Result := True;
  REPEAT { delete double stars}
   i := Pos ('**', ATemplate);
   if i > 0
    then System.Delete (ATemplate, i, 1);
  UNTIL i = 0;
  if ATemplate = '*'
   then EXIT; // optimization
  AFileName := AnsiUpperCase (AFileName);
  ATemplate := AnsiUpperCase (ATemplate);
  if ATemplate = AFileName
   then EXIT; // optimization
  FileNameLen := Length (AFileName);
  TemplateLen := Length (ATemplate);
  if (TemplateLen = 0) or (FileNameLen = 0) then begin
    Result := False;
    EXIT;
   end;

  FileNameIdx := 1;
  TemplateIdx := 1;
  REPEAT
    if AFileName [FileNameIdx] = ATemplate [TemplateIdx] then begin
      Inc (TemplateIdx);
      Inc (FileNameIdx);
      CONTINUE;
     end;
    if ATemplate [TemplateIdx] = '?' then begin
      Inc (TemplateIdx);
      Inc (FileNameIdx);
      CONTINUE;
     end;
    if ATemplate [TemplateIdx] = '*' then begin
      TemplatePart := Copy (ATemplate, TemplateIdx + 1, TemplateLen);
      i := SearchNextStar (TemplatePart);
      TemplatePartLen := Length (TemplatePart);
      if i = 0 then begin { no '*' in the rest, compare the ends }
        if TemplatePart = ''
         then EXIT; { '*' is the last letter }
        { check the rest for equal Length and no '?' }
        for i := 0 to TemplatePartLen - 1 do begin
         if (TemplatePart [TemplatePartLen - i] <> AFileName [FileNameLen - i])
            and (TemplatePart [TemplatePartLen - I] <> '?') then begin
           Result := False;
           EXIT;
          end;
         end;
        EXIT;
       end;
      { handle all to the next '*' }
      Inc (TemplateIdx, 1 + TemplatePartLen);
      i := FindPart (TemplatePart, Copy (AFileName, FileNameIdx, MaxInt));
      if i = 0 then begin
        Result := False;
        EXIT;
       end;
      FileNameIdx := i + TemplatePartLen;
      CONTINUE;
     end;
    Result := False;
    EXIT;
  UNTIL (FileNameIdx > FileNameLen) or (TemplateIdx > TemplateLen);
  { no completed evaluation }
  if FileNameIdx <= FileNameLen
   then Result := False;
  if (TemplateIdx <= TemplateLen) and (ATemplate [TemplateLen] <> '*')
   then Result := False;
 end; { of function MatchFileNameTemplate
--------------------------------------------------------------}


{ ==================== System routines ======================}

function MsgBox (const Caption, Text: string; Flags: Integer): Integer;
 begin
  SetAutoSubClass(True);
  try
    Result := Application.MessageBox (PChar (Text), PChar (Caption), Flags);
   finally SetAutoSubClass (False);
  end;
 end; { of function MsgBox
--------------------------------------------------------------}

function MsgDlg (const Msg: string; AType: TMsgDlgType;
  AButtons: TMsgDlgButtons; HelpCtx: Longint): Word;
 begin
  Result := MessageDlg (Msg, AType, AButtons, HelpCtx);
 end; { of function MsgDlg
--------------------------------------------------------------}

{$IFDEF D4_}
function MakeDynamicArrayOfInteger (AInts : array of integer) : DynamicArrayOfInteger;
 var i : integer;
 begin
  SetLength (Result, Length (AInts));
  for i := Low (AInts) to High (AInts) do
   Result [i - Low (AInts)] := AInts [i];
 end; { of function MakeDynamicArrayOfInteger
--------------------------------------------------------------}

function MakeDynamicArrayOfString (AStrs : array of string) : DynamicArrayOfString;
 var i : integer;
 begin
  SetLength (Result, Length (AStrs));
  for i := Low (AStrs) to High (AStrs) do
   Result [i - Low (AStrs)] := AStrs [i];
 end; { of function MakeDynamicArrayOfString
--------------------------------------------------------------}
{$ENDIF}

function GetVersionStr : string;
 var
  VersionSize, Dummy : DWORD;
  VersionBuffer : AnsiString;
  v : pointer;
  TransStr, ValueName : string;
 begin
  Result := '';
  VersionSize := GetFileVersionInfoSize
                  (PChar (Application.ExeName),  Dummy);
  if VersionSize <> 0 then try
    SetLength (VersionBuffer, VersionSize);
    if GetFileVersionInfo (PChar (Application.ExeName), Dummy,
          VersionSize, PChar(VersionBuffer)) then begin
      v := nil;
      VerQueryValue(PChar (VersionBuffer),
                    '\VarFileInfo\Translation', v, VersionSize);
      TransStr := IntToHex (MakeLong(HiWord(Longint(v^)),
                                     LoWord(Longint(v^))), 8);
      ValueName := 'StringFileInfo\' + TransStr + '\FileVersion';
      if VerQueryValue (PChar(VersionBuffer), PChar (ValueName),
                        v, VersionSize)
       then Result := PChar (v);
     end; { of if GetFileVersionInfo}
   except // hide exceptions
   end;
 end; { of function GetVersionStr
--------------------------------------------------------------}

const
 CheckAppRunningMFile : THandle = 0;

function CheckAppAlreadyRunning (const AppSign : string;
  BringToFront : boolean {$IFDEF D4_}= true{$ENDIF}; DestroyOnExit : boolean {$IFDEF D4_}= false{$ENDIF}) : boolean;
 var
  p : Pointer;
  AppWnd, TopWnd: HWND;
 begin
  Result := false;
  if Result then ; // Kill compiler's stupid hint !!!

  CheckAppRunningMFile := CreateFileMapping (
    THandle ($FFFFFFFF), // use paging file
    nil,                 // no security attributes
    PAGE_READWRITE,      // read/write access
    0,                   // size: high 32 bits
    4096,                // size: low 32 bits
    PChar(AppSign)       // name of map object
  );

  if CheckAppRunningMFile = 0 then raise Exception.Create (
   'CheckAppAlreadyRunning: can''t create file mapping');

  try { close CheckAppRunningMFile if DestroyOnExit}
  Result := GetLastError() = ERROR_ALREADY_EXISTS;

  p := MapViewOfFile (
    CheckAppRunningMFile, // object to map view of
    FILE_MAP_WRITE,       // read/write access
    0,                    // high offset: map from
    0,                    // low offset:  beginning
    0                     // default: map entire file
  );

  if p = nil then  raise Exception.Create (
   'CheckAppAlreadyRunning: can''t create map view of file.');

  try { p must die}
    if Result then begin  // already running
       if BringToFront then begin
         Move (p^, AppWnd, SizeOf (AppWnd));
         if AppWnd <> 0 then begin
           if IsIconic (AppWnd)
            then SendMessage (AppWnd, WM_SYSCOMMAND, SC_RESTORE, 0);
           TopWnd := GetLastActivePopup (AppWnd);
           if (TopWnd <> 0) and (TopWnd <> AppWnd)
              and IsWindowVisible (TopWnd)
              and IsWindowEnabled (TopWnd)
            then SetForegroundWindow (TopWnd);
          end;
        end;
      end
     else begin // first instance
       AppWnd := Application.Handle;
       Move (AppWnd, p^, SizeOf (AppWnd));
      end;
   finally UnmapViewOfFile (p);
  end; { of try p must die}
  finally if DestroyOnExit and (CheckAppRunningMFile <> 0) then begin
    CloseHandle (CheckAppRunningMFile);
    CheckAppRunningMFile := 0;
   end
  end; { of try 'close CheckAppRunningMFile if DestroyOnExit'}
 end; { of function CheckAppAlreadyRunning
--------------------------------------------------------------}

function ExecuteFile (const FileName, Params, DefaultDir: string; ShowCmd: Integer) : THandle;
 var
  zFileName, zParams, zDir: array [0 .. MAX_PATH] of Char;
 begin
  Result := ShellExecute (Application.MainForm.Handle, nil, StrPCopy(zFileName, FileName),
                         StrPCopy(zParams, Params), StrPCopy(zDir, DefaultDir), ShowCmd);
 end; { of function ExecuteFile
--------------------------------------------------------------}

function ShellFolder (FolderID : integer) : string;
 var
  ShMalloc : IMalloc;
  Id : PItemIdList;
  buf: PChar;
 begin
  Result := '';
  if (ShGetMalloc(ShMalloc) = S_OK) and (ShMalloc <> nil) then begin
    buf := ShMalloc.Alloc (MAX_PATH);
    try
      if SHGetSpecialFolderLocation (Application.Handle,
          FolderID, Id) = NOERROR then try
        SHGetPathFromIDList (Id, Buf);
        finally ShMalloc.Free (Id);
       end;
      Result := AddBSlash (StrPas (Buf));
      finally ShMalloc.Free (buf);
     end;
   end;
 end; { of function ShellFolder
--------------------------------------------------------------}

function ProgramFilesFolder : string;
 var r : TRegistry;
 begin
  Result := '';
  try
  r := TRegistry.Create;
  try
     r.RootKey := HKEY_LOCAL_MACHINE;
     {$IFDEF D4_}r.OpenKeyReadOnly{$ELSE}r.OpenKey{$ENDIF} ('SOFTWARE\Microsoft\Windows\CurrentVersion'{$IFNDEF D4_},False{$ENDIF}); // REGSTR_PATH_SETUP ???
     Result := AddBSlash (r.ReadString ('ProgramFilesDir'));
    finally r.Free;
   end;
  except ;
  end;
  if Result = ''
   then Result := 'C:\Program Files\';
 end; { of function ProgramFilesFolder
--------------------------------------------------------------}

function CreateShortCut (const CmdLine, Args, WorkDir,
  LinkFile : string) : boolean;
 var
  ShLink : IShellLink;
  PersistFile: IPersistFile;
  wsz : array [0 .. MAX_PATH * 2] of WideChar;
 begin
  Result := true;
  try
    ShLink := CreateComObject (CLSID_ShellLink) as IShellLink;
    OleCheck (ShLink.SetPath (PChar (CmdLine)));
//    OleCheck (ShLink.SetHotKey (FHotKey));
    OleCheck (ShLink.SetArguments (PChar (Args)));
    OleCheck (ShLink.SetWorkingDirectory (PChar (WorkDir)));
    OleCheck (ShLink.QueryInterface (IPersistFile, PersistFile));
    MultiByteToWideChar (CP_ACP, 0, PChar (LinkFile), -1, wsz, MAX_PATH);
    OleCheck (PersistFile.Save (wsz, TRUE));
    except Result := false;
   end;
 end; { of function CreateShortCut
--------------------------------------------------------------}

function HasAttr (const FileName: string; Attr: Integer): Boolean;
 var
  FileAttr: Integer;
 begin
  FileAttr := FileGetAttr (FileName);
  Result := (FileAttr >= 0) and (FileAttr and Attr = Attr);
 end; { of function HasAttr
--------------------------------------------------------------}

function NormalDir (const DirName: string): string;
 begin
  Result := DirName;
  if (Result <> '') and
    not (AnsiLastChar (Result)^ in [':', '\']) then begin
    if (Length (Result) = 1) and (UpCase (Result [1]) in ['A' .. 'Z'])
     then Result := Result + ':\'
     else Result := Result + '\';
  end;
 end; { of function NormalDir
--------------------------------------------------------------}

function GetFileSize (const FileName: string): {$IFDEF D4_}Int64{$ELSE}integer{$ENDIF};
 var
  Handle: THandle;
  FindData: TWin32FindData;
 begin
  Handle := FindFirstFile (PChar (FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then begin
    Windows.FindClose (Handle);
    if (FindData.dwFileAttributes
        and FILE_ATTRIBUTE_DIRECTORY) = 0 then begin
      {$IFDEF D4_}
      Int64Rec (Result).Lo := FindData.nFileSizeLow;
      Int64Rec (Result).Hi := FindData.nFileSizeHigh;
      {$ELSE}
      Result := FindData.nFileSizeLow;
      {$ENDIF}
      Exit;
     end;
   end;
  Result := -1;
 end; { of function GetFileSize
--------------------------------------------------------------}

procedure CopyFile (const FileName, DestName: string;
  ProgressControl: TProgressBar);
 var
  CopyBuffer: Pointer;
  Source, Dest: Integer;
  Destination: TFileName;
  FSize, BytesCopied, TotalCopied: Longint;
 const
  ChunkSize: Longint = 8192;
 begin
  Destination := DestName;
  if HasAttr (Destination, faDirectory)
   then Destination := NormalDir (Destination)
        + ExtractFileName (FileName);
  GetMem (CopyBuffer, ChunkSize);
  try
    TotalCopied := 0;
    FSize := GetFileSize (FileName);
    Source := FileOpen (FileName, fmShareDenyWrite);
    if Source < 0
     then raise EFOpenError.CreateFmt (SFOpenError, [FileName]);
    try
      if ProgressControl <> nil then begin
        ProgressControl.Max := FSize;
        ProgressControl.Min := 0;
        ProgressControl.Position := 0;
       end;
      ForceDirectories (ExtractFilePath (Destination));
      Dest := FileCreate (Destination);
      if Dest < 0
       then raise EFCreateError.CreateFmt (SFCreateError, [Destination]);
      try
        REPEAT
          BytesCopied := FileRead (Source, CopyBuffer^, ChunkSize);
          if BytesCopied = -1
           then raise EReadError.Create (SReadError);
          TotalCopied := TotalCopied + BytesCopied;
          if BytesCopied > 0 then begin
            if FileWrite (Dest, CopyBuffer^, BytesCopied) = -1
             then raise EWriteError.Create (SWriteError);
           end;
          if ProgressControl <> nil
           then ProgressControl.Position := TotalCopied;
        UNTIL BytesCopied < ChunkSize;
        FileSetDate (Dest, FileGetDate (Source));
       finally FileClose (Dest);
      end;
     finally FileClose (Source);
    end;
   finally
    FreeMem (CopyBuffer, ChunkSize);
    if ProgressControl <> nil
     then ProgressControl.Position := 0;
  end;
 end; { of procedure CopyFile
--------------------------------------------------------------}

procedure CopyDirectory (const SourcePath, DestPath : string);
 var SR : TSearchRec;
 begin
  if FindFirst (SourcePath + '*.*', faAnyFile - faVolumeID, SR) = 0 then try
     REPEAT
      if Trim (SR.Name) <> '' then
        if (SR.Attr and faDirectory) = 0 then begin
           CopyFile (SourcePath + SR.Name, DestPath + SR.Name, nil);
          end
         else if SR.Name [1] <> '.'
               then CopyDirectory (AddBSlash (SourcePath + SR.Name),
                                   AddBSlash (DestPath + SR.Name));
     UNTIL FindNext (SR) <> 0;
    finally FindClose (SR);
   end;
 end; { of procedure CopyDirectory
--------------------------------------------------------------}

function MakeUnInstallEntry (const KeyName, DisplayStr, UnInstallerName : string) : boolean;
 var r : TRegistry;
 begin
  Result := true;
  try
    r := TRegistry.Create;
    try
      r.RootKey := HKEY_LOCAL_MACHINE;
      r.OpenKey (REGSTR_PATH_UNINSTALL + '\' + KeyName, True);
      r.WriteString (REGSTR_VAL_UNINSTALLER_DISPLAYNAME,
          DisplayStr); // DisplayName
      r.WriteString (REGSTR_VAL_UNINSTALLER_COMMANDLINE,
          UnInstallerName); // UninstallString
      finally r.Free;
     end;
    except Result := false;
   end;
 end; { of function MakeUnInstallEntry
--------------------------------------------------------------}

function RemoveUnInstallEntry (const KeyName : string) : boolean;
 var r : TRegistry;
 begin
  try
    r := TRegistry.Create;
    try
      r.RootKey := HKEY_LOCAL_MACHINE;
      Result := r.DeleteKey (REGSTR_PATH_UNINSTALL + '\' + KeyName);
      finally r.Free;
     end;
    except Result := false;
   end;
 end; { of function RemoveUnInstallEntry
--------------------------------------------------------------}

procedure Suicide; // i now about wininit.bat/MoveFileEx, but i want kill myself now and with my directory !
{ var
  pi : TProcessInformation;
  si : TStartupInfo;}
 begin
  MoveFileAfterReboot (ParamStr (0), '');
{
    FillChar (si, SizeOf (si), 0);
    si.dwFlags := STARTF_USESHOWWINDOW;
    si.wShowWindow := SW_HIDE;

    if CreateProcess ( nil, PChar (bfn), nil, nil, False,
        IDLE_PRIORITY_CLASS, nil, nil, si, pi ) then begin
      CloseHandle (pi.hThread);
      CloseHandle (pi.hProcess);
     end;
    except ;
   end;}
 end; { of procedure Suicide
--------------------------------------------------------------}


procedure MoveFileAfterReboot (const Source, Dest : string);
 var
  i : integer;
  f : TIniFile;
  TempSource : string;
  ShortSource, ShortDest : array [0 .. MAX_PATH] of Char;
{  bfn : string;
  bf : TextFile;}
 begin
  if Dest <> '' then begin
    i := 0; // find temp file name (before reboot) for Source
    REPEAT
     inc (i);
     TempSource := ChangeFileExt (Dest, '.' + IntToStr (i));
    UNTIL not FileExists (TempSource);
    Windows.CopyFile (PChar (Source), PChar (TempSource), True);
   end;
  if OSisNT then begin
     if Dest <> ''
      then MoveFileEx (PChar (TempSource), PChar (Dest),
             MOVEFILE_DELAY_UNTIL_REBOOT)
      else MoveFileEx (PChar (Source), nil,
             MOVEFILE_DELAY_UNTIL_REBOOT);
     // HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\
     // Control\Session Manager\PendingFileRenameOperations
{     bfn := ExeFolder?? + '$$$$$$$$.bat'; // our last chance !
     AssignFile (bf, bfn);
     Rewrite (bf);
     writeln (bf, 'erase ' + StrPas (ShortDest));
     writeln (bf, 'move ' + StrPas (ShortSource) + ' ' + StrPas (ShortDest));
     writeln (bf, 'erase "' + bfn + '"');
     CloseFile (bf);
     if not RegisterRunOnce ('AnSoBatFile', bfn, True) then ;}
    end
   else begin // must die 9x - use WinInit.ini
      if Dest <> '' then begin
         GetShortPathName (PChar (ExtractFilePath (Dest)),
          ShortDest, SizeOf (ShortDest));
         StrPCopy (ShortSource, StrPas (ShortDest) + ExtractFileName (TempSource));
         StrPCopy (ShortDest, StrPas (ShortDest) + ExtractFileName (Dest));
        end
       else begin // no Dest - remove only
         StrPCopy (ShortDest, 'NUL');
         GetShortPathName (PChar (ExtractFilePath (Source)),
          ShortSource, SizeOf (ShortSource));
         StrPCopy (ShortSource, StrPas (ShortSource) + ExtractFileName (Source));
        end;
      f := TIniFile.Create ('WININIT.INI');
      try
        f.WriteString ('Rename', StrPas (ShortDest), StrPas (ShortSource));
        finally f.Free;
       end;
    end; { else if OSisNT}
 end; { of procedure MoveFileAfterReboot
--------------------------------------------------------------}

procedure GetOSVerInfo (var OSID : DWORD; var OSStr : string);
 var
  OSVerInfo : TOSVersionInfo;
  Reg : TRegistry;
  s : string;
 begin
  OSVerInfo.dwOSVersionInfoSize := SizeOf (OSVerInfo);
  GetVersionEx (OSVerInfo);
  OSID := OSVerInfo.dwPlatformID;
  case OSID of
    VER_PLATFORM_WIN32S : OSStr := 'Windows 3+';
    VER_PLATFORM_WIN32_WINDOWS : OSStr := 'Windows 95+';
    VER_PLATFORM_WIN32_NT : begin
      OSStr := 'Windows NT';
      Reg := TRegistry.Create;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKey ('SYSTEM\CurrentControlSet\Control\', False)
        then try
         s := Reg.ReadString ('ProductOptions')
        except s := ''
       end;
      if s = 'WINNT' then OSStr := OSStr + ' WorkStation'
      else if s = 'SERVERNT' then OSStr := OSStr + ' Server 3.5 & hi'
      else if s = 'LANMANNT' then OSStr := OSStr + ' Advanced server 3.1';
      Reg.Free;
     end;
   end;
  with OSVerInfo do OSStr := OSStr + Format (' %d.%d (выпуск %d)',
   [dwMajorVersion, dwMinorVersion, LoWord(dwBuildNumber)]);
{  GetComputerName ();
  GetUserName() }
 end; { of procedure GetOSVerInfo
--------------------------------------------------------------}

function OSisNT : boolean;
 var
  s : string;
  i : DWORD;
 begin
  GetOSVerInfo (i, s);
  Result := (i = VER_PLATFORM_WIN32_NT);
 end; { of function OSisNT
--------------------------------------------------------------}

procedure GetCPUInfo (var CPUID : DWORD; var CPUStr : string);
 var SI : TSystemInfo;
 begin
  GetSystemInfo (SI);
  CPUID := SI.dwProcessorType;
  case CPUID of
    386: CPUStr := '80386-совместимый процессор';
    486: CPUStr := '80486-совместимый процессор';
    586: CPUStr := 'Pentium-совместимый процессор';
    else CPUStr := 'Неизвестный процессор';
   end;
{  case SI.wProcessorArchitecture of
    PROCESSOR_ARCHITECTURE_INTEL: ;
    MIPS
    ALPHA
    PPC
    UNKNOWN
   end;}
 end; { of procedure GetCPUInfo
--------------------------------------------------------------}

procedure GetMemInfo (var MemStr : string);
 var MemInfo : TMemoryStatus;
 begin
  MemInfo.dwLength := SizeOf (MemInfo);
  GlobalMemoryStatus (MemInfo);
  with MemInfo do MemStr := Format ('ОЗУ: %0.2f M (свободно %0.2f M)'#$d+
   ' Файл подкачки: %0.2f M (свободно: %0.2f M)'#$d,
   [(dwTotalPhys div 1024) / 1024,
    (dwAvailPhys div 1024) / 1024,
    (dwTotalPageFile div 1024) / 1024,
    (dwAvailPageFile div 1024) / 1024]);
 end; { of procedure GetMemInfo
--------------------------------------------------------------}

function InitialsFromName (const AName : string; AMaxNum : integer = 3) : string;
 const
  NameDelims = [' ', '.', #9, #$d, #$a];
 var
  i, Len, n : integer;
 begin
  Result := '';
  n := AMaxNum;
  Len := length (AName);
  i := 1;
  while (i <= Len) and (n > 0) do begin
    while (i <= Len) and (AName [i] in NameDelims)
     do inc (i);
    if i <= Len then begin
      Result := Result + AnsiUpperCase (AName [i]);
      dec (n);
      while (i <= Len) and not (AName [i] in NameDelims)
       do inc (i);
     end;
   end;
 end; { of function InitialsFromName
--------------------------------------------------------------}

function LimitLinesLen (const AText : string;
  const APrefix : string; AMaxLineLen, AMaxErr : integer) : string;
 var
  ss : TStrings;
  i, i0, p0, Len : integer;
 begin
  dec (AMaxLineLen, length (APrefix));
  if AMaxLineLen < 1
   then AMaxLineLen := 1;
  if AMaxErr >= AMaxLineLen
   then AMaxErr := AMaxLineLen div 8;
  ss := TStringList.Create;
  try
     Len := length (AText);
     i0 := 1;
     i := i0;
     while i <= Len do begin
       p0 := i0;
       while (i <= Len) and not (AText [i] in [#$d, #$a]) do begin
         if (i > 1)
            and (AText [i - 1] in ['-', '.', ',', ';', ':', '!', '?', ')',
                                   ' ', #9, #$d, #$a])
            and not (AText [i] in ['-', '.', ',', ';', ':', '!', '?', ')'])
          then p0 := i;
         if i - i0 >= AMaxLineLen then begin
           if i - p0 <= AMaxErr
            then i := p0;
           BREAK;
          end;
         inc (i);
        end;
       ss.Add (APrefix + copy (AText, i0, i - i0));
       if (i <= Len) then //###00.08.03
        if AText [i] = #$d then begin
           inc (i);
           if (i <= Len) and (AText [i] = #$a)
            then inc (i);
          end
         else if AText [i] = #$a
          then inc (i);
//       while (i <= Len) and (AText [i] in [#$d, #$a, #9, ' ']) //###00.08.03 removed
//        do inc (i);
       i0 := i;
      end;
     Result := ss.Text;
    finally ss.Free;
   end;
 end; { of function LimitLinesLen
--------------------------------------------------------------}

function TruncateString (const AStr : string; AMaxLen : integer) : string;
 begin
  if length (AStr) > AMaxLen
   then Result := System.Copy (AStr, 1, AMaxLen)
   else Result := AStr;
 end; { of function TruncateString
--------------------------------------------------------------}


initialization

Randomize;

CheckAppRunningMFile := 0;

AppBasePath := ExeFolder;

finalization

if CheckAppRunningMFile <> 0
 then CloseHandle (CheckAppRunningMFile);

end.

