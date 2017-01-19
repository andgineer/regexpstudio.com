unit UConsole;

interface

uses
  Classes;

procedure Execute;
procedure DirWithPattern(const asDir: String; const aiAttr: integer;
                         const asPattern: String; ResultList: TStringList);

implementation

uses
  SysUtils, mkregex, mkStrUtils, FileCtrl;

{

When MK_REPROC is defined, no TmkreExpr component is available, use instead of
it those functions:

procedure Init_mkreExpr;               // to initialize regular expressions
procedure DeInit_mkreExpr;             // to deinitialize regular expressions
procedure mkreDoMatch(str: string);    // after patter is set, fill GetMatches
				       // stringlist with matches on str
function mkreDoSearchWithRange(pos, range: integer): integer;
				       // simple wrapper around re_search, set
                                       // pattern before it
function mkreDoSearch(pos: integer): integer;
function mkreGetMatches: TStringList;
procedure mkreSetPattern(pat: string); // set the pattern
procedure mkreSetString(str: string);  // set the string to match
procedure mkreSetSyntaxStyles(NewStyles: TmkreSyntaxStyles);
                                       // change styles, see TmkreExpr for default
                                       // style settings
procedure mkreSetUseFastmap(fstm: boolean);
                                       // default is true, let it that way for
                                       // best performance
// to use those functions pattern and string must be set before, those are the
// lowest search and match routines available
function re_match(pos: integer;
                  old_regs: Pre_registers): integer;
function re_search(pos, range: integer;
                   regs: Pre_registers): integer;

Look at the pconsole test application for an example of those functions
}
procedure Execute;
var
  i: integer;
  showUse: boolean;
  ResultList: TStringList;
begin
  ShowUse := (ParamCount <> 3);
  if ParamStr(1) = 'g' then ShowUse := ShowUse or (not FileExists(ParamStr(3)))
  else
    if ParamStr(1) = 'd' then ShowUse := ShowUse or (not DirectoryExists(ParamStr(3)))
    else
      ShowUse := True;
  if ShowUse then
  begin
    writeln('Mk regular expressions demonstration');
    writeln('');
    writeln('Use:');
    writeln('PConsole <command> <regular expression> <file>/<dir>');
    writeln('');
    writeln('commands: g do EGrep on file');
    writeln('          d do search on file names in dir');
    writeln('');
  end
  else
    if ParamStr(1) = 'g' then
    begin
      Init_mkreExpr;
      mkreSetPattern(ParamStr(2));
      mkreDoMatch(mkConvertDos2Ux(mkStrFileLoad(ParamStr(3))));
      for i := 0 to mkreGetMatches.Count -1 do
        writeln(mkreGetMatches.strings[i]);
      DeInit_mkreExpr;
    end
    else
      begin
        ResultList := TStringList.Create;
        DirWithPattern(ParamStr(3), faAnyFile, ParamStr(2), ResultList);
        for i := 0 to ResultList.Count -1 do
          writeln(ResultList.strings[i]);
      end;
end;


procedure DirWithPattern(const asDir: String; const aiAttr: integer;
                         const asPattern: String; ResultList: TStringList);
var
  MySearchRec: TSearchRec;
  i: Integer;
  lsStr: String;
begin
  Init_mkreExpr;
  mkreSetPattern(asPattern);
  try
    if SysUtils.FindFirst(asDir + '*.*', aiAttr, MySearchRec) = 0 then
    try
      repeat
        //Ignore the dummies!
        if (MySearchRec.Name <> '.') and (MySearchRec.Name <> '..') then
        begin
          mkreSetString(MySearchRec.Name);
          //-- Add this to our list
          if mkreDoSearch(1) > 0 then
            ResultList.Add(MySearchRec.Name);
        end;
          //-- Read next entry until finished
      until SysUtils.FindNext(MySearchRec) <> 0;
    finally
      //-- Brad Stowers says that some people have reportet app crashes/lockups on
      //-- NT machines when they use FindClose on an invalid TSearchRec variable,
      //-- i.e. if FindFirst does not return 0 and then FindClose is called on it.
      SysUtils.FindClose(MySearchRec);
    end;
  finally
    DeInit_mkreExpr;
  end;
end;

end.
