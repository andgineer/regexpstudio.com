//CE_Desc_Begin(mkStrUtils.pas)
{
String functions

Author: M.C. van der Kooij (MLWKooij@hetnet.nl)

Last Modification: 19 may 1998}
//CE_Desc_End
unit mkStrUtils;

interface

function FileWithoutExt(const FileName: string): string;
function mkAtoi(str: string): integer;
function mkConvertDos2Ux(strFile: string): string;
function mkIntCompare(int1, int2: integer): integer;
function mkItoa(value : Integer) : string;
function mkStrFileLoad(const aFile: String): String;
procedure mkStrFileSave(const aFile,aString: String);

implementation

uses Classes, SysUtils;

function FileWithoutExt(const FileName: string): string;
var
  I                 : Integer;
begin
  I := LastDelimiter('.', FileName);
  if i > 0 then
    Result := Copy(FileName, 1, I - 1)
  else
    Result := FileName;
end;

function mkAtoi(str: string): integer;
var
  i: integer;
begin
  Result := 0;
  i := 1;
  while not(str[i] in ['0'..'9']) and (i <= length(str)) do inc(i);
  while (str[i] in ['0'..'9'])  and (i <= length(str)) do
  begin
    result := result * 10 + ord(str[i]) - ord('0');
    inc(i);
  end;
end;

//CE_Desc_Begin(mkConvertDos2Ux)
{
A fast way to convert an Dos string (with CR & LF) to an Unix string (only LF)}
//CE_Desc_End
function mkConvertDos2Ux(strFile: string): string;
var
  intPos, intPos2, intLength: integer;
begin
  intPos := 1;
  intPos2 := 1;
  intLength := length(strFile) + 2;
  SetLength(Result, length(strFile) + 2);
  while intPos < intLength do
  begin
    if strFile[intPos] <> #13 then
    begin
      Result[intPos2] := strFile[intPos];
      inc(intPos2);
    end;
    inc(intPos);
  end;
  SetLength(Result, intPos2 - 1);
end;

function mkIntCompare(int1, int2: integer): integer;
begin
  if int1 < int2 then Result := -1
  else
    if int1 > int2 then Result := 1
    else
      Result := 0;
end;

function mkItoa(value : Integer) : string;
var
  i : Integer;
begin
  Result := '';
  repeat
    i := value mod 10;
    value := value div 10;
    Result := char(i + ord('0')) + Result;
  until value = 0;
end;

function mkStrFileLoad(const aFile: String): String;
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(aFile, fmOpenRead);
  try
    Result := StringOfChar(#32, Stream.Size);
    Stream.ReadBuffer(Pointer(Result)^, Stream.Size);
  finally
    Stream.Free;
  end;
end;

procedure mkStrFileSave(const aFile,aString: String);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(aFile, fmCreate);
  try
    Stream.WriteBuffer(Pointer(aString)^,Length(aString));
  finally
    Stream.Free;
  end;
end;

end.
