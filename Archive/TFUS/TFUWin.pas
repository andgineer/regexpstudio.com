{$B-}
unit TFUWin;

{

 Too Frequently Used Win-API staff
        * non VCL part *

 (no classes.pas, form.pas etc units needed)

 (c) 2001 Andrey Sorokin, Saint-Petersburg, Russia
  mailto:anso@mail.ru

 v. 3.0 2001.09.30
 -=- Just first release (separated from TFUS.pas)

}

interface


function ExeFullName : string;
// Returns full path and name of the process executable file
// (I don't want to use Forms.pas and it seems pretty ugly
// to use ParamStr(0) to obtain module name).

function ExeFolder : string;
// Returns path to the process executable file.


{=============================================================}
// Routines to work with variables from environment
// block of the process.

function EnvironmentVar (const AName : string) : string;
// Wrapper for API function GetEnvironmentVariable to hide memory allocation.
// Returns environment variable with the name specified,
// or empty string if no such variable defined in environment
// block for the current process.

function ParseEnvironmentVars (const AStr : string; const AQuoteCh : char = '%') : string;
// Replaces all environment variables entries (like %variable_name%)
// from AStr with values of this variables from environment block
// for the current process.
// AQuoteCh - entries delimiter ('%' by default).
// Doubled delimiter treated as 'escaped': 'abc%%def' -> 'abcd%efd'.
// ! Unclosed entries IGNORED ('abc%def' -> 'abc%def').
// ! All undefined variables entries will be replaced with empty
//   strings: 'First%unknown_var%Second' -> 'FirstSecond'

implementation

uses
 Windows,
 SysUtils,
 TFUStr;

function ExeFullName : string;
 var
  Buf : array [0 .. 260] of char;
 begin
  SetString (Result, Buf, GetModuleFileName (0, Buf, SizeOf (Buf)));
 end; { of function ExeFullName
--------------------------------------------------------------}

function ExeFolder : string;
 begin
  Result := AddPathTrailer (ExtractFilePath (ExeFullName));
 end; { of function ExeFolder
--------------------------------------------------------------}


{=============================================================}
// Routines to work with variables from environment
// block of the process.

function EnvironmentVar (const AName : string) : string;
 const
  StaticBufSz = 512; // In-stack buf size
 var
  StaticBuf : array [0 .. StaticBufSz - 1] of char; // In-stack buffer for speed sake
  Res : integer;
 begin
  // Generally it's faster to get env.var into in-stack buffer
  // and copy into Result than call GetEnvironmentVariable (PChar (AName), nil, 0)
  // and allocate Result with appropriate size for subsequent GetEnvironmentVariable.
  Res := GetEnvironmentVariable (PChar (AName), StaticBuf, StaticBufSz);
  if Res <= StaticBufSz then begin
    // Static buffer is enough or no such env.var was found
    SetString (Result, StaticBuf, Res);
    EXIT;
   end;

  // we have to allocate appropriate buffer because static buffer is too small :(
  REPEAT
   // Lets be paranoid ;) - may be the env.var will be increased between
   // prev.and next GetEnvironmentVariable, so we need this loop
   SetString (Result, nil, Res);
   Res := GetEnvironmentVariable (PChar (AName), PChar (Result), Res);
  UNTIL Res < length (Result);
  SetLength (Result, Res); // Omit traling #0
 end; { of function EnvironmentVar
--------------------------------------------------------------}

function ParseEnvironmentVars (const AStr : string; const AQuoteCh : char = '%') : string;
 var
  n0, n, n2 : integer;
 begin
  n0 := 1;
  // First of all - may be we don't need to do anything. Check that.
  n := PosOfChar (AQuoteCh, AStr, n0); // PosOfChar is much faster that byte by byte scanning in Pascal loop
  if n <= 0 then begin
    Result := AStr;
    EXIT;
   end;

  Result := '';
  while n > 0 do begin
    Result := Result + Copy (AStr, n0, n - n0); // Substring before var tag
    n2 := PosOfChar (AQuoteCh, AStr, n + 1); // end of var tag
    if n2 > 0 then begin
       if n2 = n + 1 // 'Escaped' delimiter, replace with delimiter (for example 'abc%%def' -> 'abc%def')
        then Result := Result + AQuoteCh
        else Result := Result + EnvironmentVar (copy (AStr, n + 1, n2 - n - 1));
      end
     else n2 := n; // Error in AStr - unclosed var name. !IGNORE!
    n0 := n2 + 1;
    n := PosOfChar (AQuoteCh, AStr, n0);
   end; { of while n}
  Result := Result + Copy (AStr, n0, MaxInt); // Tail
 end; { of function ParseEnvironmentVars
--------------------------------------------------------------}

end.

