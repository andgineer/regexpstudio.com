unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mkregex, StdCtrls;

type
  TfrmMain = class(TForm)
    btnStart: TButton;
    mmoTestFile: TMemo;
    btnClose: TButton;
    mkreExpr1: TmkreExpr;
    OpenDialog1: TOpenDialog;
    btnLoad: TButton;
    btnSave: TButton;
    SaveDialog1: TSaveDialog;
    mmoResult: TMemo;
    procedure btnCloseClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
  private
    FFileName: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

uses mkStrUtils;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnLoadClick(Sender: TObject);
begin
  OpenDialog1.FileName := FFileName;
  if OpenDialog1.Execute then
  begin
    mmoTestFile.Lines.LoadFromFile(OpenDialog1.FileName);
    FFileName := OpenDialog1.FileName;
  end;
end;

procedure TfrmMain.btnSaveClick(Sender: TObject);
begin
  SaveDialog1.FileName := FFileName;
  if SaveDialog1.Execute then
  begin
    mmoTestFile.Lines.SaveToFile(SaveDialog1.FileName);
    FFileName := SaveDialog1.FileName;
  end;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
var
  i: integer;
  sLine, sLine2: string;
  TestLines, Pattern: String;
begin
  i := 0;
  mmoResult.Lines.Clear;
    while i < mmoTestFile.Lines.Count do
    begin
      while i < mmoTestFile.Lines.Count do
      begin
        sLine := mmoTestFile.Lines[i];
        sLine2 := lowercase(copy(sLine, 2, length(sLine)));
        inc(i);
        if (sLine = '') then continue;
        case sLine[1] of
          ';': ;
          'o','O':
              begin
                if sLine2 = ':cbe' then mkreExpr1.CanBeEmpty := True
                else
                  if sLine2 = ':nfm' then mkreExpr1.UseFastmap := False;
              end;
          's', 'S':
              begin
                if sLine2 = ':nbp' then
                  mkreExpr1.SyntaxStyles := mkreExpr1.SyntaxStyles - [mkre_No_Bk_Parens];
                if sLine2 = ':nbv' then
                  mkreExpr1.SyntaxStyles := mkreExpr1.SyntaxStyles - [mkre_No_Bk_Vbar];
                if sLine2 = ':bpq' then
                  mkreExpr1.SyntaxStyles := mkreExpr1.SyntaxStyles + [mkre_Bk_Plus_Qm];
                if sLine2 = ':tvb' then
                  mkreExpr1.SyntaxStyles := mkreExpr1.SyntaxStyles + [mkre_Tight_Vbar];
                if sLine2 = ':no' then
                  mkreExpr1.SyntaxStyles := mkreExpr1.SyntaxStyles - [mkre_Newline_Or];
                if sLine2 = ':cio' then
                  mkreExpr1.SyntaxStyles := mkreExpr1.SyntaxStyles - [mkre_Context_Indep_Ops];
                if sLine2 = ':ah' then
                  mkreExpr1.SyntaxStyles := mkreExpr1.SyntaxStyles + [mkre_Ansi_Hex];
                if sLine2 = ':nge' then
                  mkreExpr1.SyntaxStyles := mkreExpr1.SyntaxStyles + [mkre_No_Gnu_Extensions];
              end;
            'p','P':
                begin
                  Pattern := '';
                  while (i < mmoTestFile.Lines.Count) and (mmoTestFile.Lines[i] <> '') do
                  begin
                    if Pattern = '' then Pattern := Pattern + mmoTestFile.Lines[i]
                                    else Pattern := Pattern + #10 + mmoTestFile.Lines[i];
                    inc(i);
                  end;
                end;
            'c', 'C':
                begin
                  mkreExpr1.CanBeEmpty := False;
                  mkreExpr1.UseFastmap := True;
                  mkreExpr1.SyntaxStyles := [mkre_No_Bk_Parens,      mkre_No_Bk_Vbar,
                                             mkre_Context_Indep_Ops, mkre_Newline_Or];
                end;
            'l', 'L':
                begin
                  TestLines := '';
                  while (i < mmoTestFile.Lines.Count) and (mmoTestFile.Lines[i] <> '') do
                  begin
                    if TestLines = '' then TestLines := TestLines + mmoTestFile.Lines[i]
                                    else TestLines := TestLines + #10 + mmoTestFile.Lines[i];
                    inc(i);
                  end;
                end;
            'd', 'D':
                begin
                  mkreExpr1.Pattern := Pattern;
                  mkreExpr1.Str := TestLines;
                  mkreExpr1.DoMatch;
                  mmoResult.Lines.AddStrings(mkreExpr1.matches);
                end;
        end;
      end;

    end;

  sLine := mkConvertDos2Ux(mmoResult.Text);
  mkStrFileSave(FFileName + '.out', sLine);
end;

end.
