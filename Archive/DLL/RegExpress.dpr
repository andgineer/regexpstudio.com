library RegExpress;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  RegExpr in 'RegExpr.pas';

{$R *.RES}

function QuoteRegExprMetaChars (const AStr,ARes : PChar; aMax: Integer) : Integer;stdcall;
var
    Res: string;
begin
    Res := RegExpr.QuoteRegExprMetaChars(AStr);
    if Length(Res) < aMax then
    begin
        Result := Length(Res);
        Move(Res[1],aRes[0],Result);
        aRes[Result] := #0;
    end
    else
        Result := -1;
end;

function ExecRegExpr (const ARegExpr, AInputStr : PChar) : boolean;stdcall;
begin
    Result := RegExpr.ExecRegExpr(string(ARegExpr),string(AInputStr));
end;

function SplitRegExpr (const ARegExpr, AInputStr : PChar; APieces : PChar; aMax: Integer): Integer;stdcall;
var
    Res: string;
    Pies: TStrings;
begin
    Pies := TStringList.Create;
    try
        try
            RegExpr.SplitRegExpr(string(ARegExpr),string(AInputStr),Pies);
            Res := Pies.Text;
            if Length(Res) < aMax then
            begin
                Result := Length(Res);
                Move(Res[1],APieces[0],Result);
                APieces[Result] := #0;
            end
            else
                Result := -1;
        except
            Result := -1;
        end;
    finally
        Pies.Free;
    end;
end;

function ReplaceRegExpr (const ARegExpr, AInputStr, AReplaceStr,aRes : PChar; aMax: Integer) : Integer;stdcall;
var
    Res: string;
begin
    Res := RegExpr.ReplaceRegExpr(string(ARegExpr),string(AInputStr),string(AReplaceStr));
    if Length(Res) < aMax then
    begin
        Result := Length(Res);
        Move(Res[1],aRes[0],Result);
        aRes[Result] := #0;
    end
    else
        Result := -1;
end;

exports
    ExecRegExpr,
    QuoteRegExprMetaChars,
    SplitRegExpr,
    ReplaceRegExpr;

end.
