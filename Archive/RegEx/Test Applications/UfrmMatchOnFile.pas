unit UfrmMatchOnFile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, mkRegEx, Buttons;

type
  TfrmMatchOnFile = class(TForm)
    btnMatch: TButton;
    Label1: TLabel;
    cbxPattern: TComboBox;
    Memo1: TMemo;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    Load1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Memo2: TMemo;
    Label3: TLabel;
    Button1: TButton;
    mkreExpr1: TmkreExpr;
    btnSearch: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    Label4: TLabel;
    CheckBox9: TCheckBox;
    SpeedButton1: TSpeedButton;
    Label5: TLabel;
    procedure btnMatchClick(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure mkreExpr1Match(Sender: TObject; str: String; pos,
      ret: Integer; re_registers: Tmkre_registers);
    procedure mkreExpr1Search(Sender: TObject; str: String; pos: Integer;
      re_registers: Tmkre_registers);
    procedure btnSearchClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mkreExpr1StartMatch(Sender: TObject);
    procedure mkreExpr1EndMatch(Sender: TObject);
  private
    procedure GetSyntaxOps;
    procedure SetSyntaxOps;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMatchOnFile: TfrmMatchOnFile;

implementation

{$R *.DFM}

uses registry, mkStrUtils;

function itoa(value: integer): string;
var
  i: integer;
begin
  Result := '';
  repeat
    i := value mod 10;
    value := value div 10;
    Result := char(i + ord('0')) + Result;
  until value = 0;
end;

procedure TfrmMatchOnFile.GetSyntaxOps;
begin
  CheckBox1.Checked := mkre_No_Bk_Parens in mkreExpr1.SyntaxStyles;
  CheckBox2.Checked := mkre_No_Bk_Vbar in mkreExpr1.SyntaxStyles;
  CheckBox3.Checked := mkre_Bk_Plus_Qm in mkreExpr1.SyntaxStyles;
  CheckBox4.Checked := mkre_Tight_Vbar in mkreExpr1.SyntaxStyles;
  CheckBox5.Checked := mkre_Newline_Or in mkreExpr1.SyntaxStyles;
  CheckBox6.Checked := mkre_Context_Indep_Ops in mkreExpr1.SyntaxStyles;
  CheckBox7.Checked := mkre_Ansi_Hex in mkreExpr1.SyntaxStyles;
  CheckBox8.Checked := mkre_No_Gnu_Extensions in mkreExpr1.SyntaxStyles;
  CheckBox9.Checked := mkreExpr1.UseFastmap;
end;

procedure TfrmMatchOnFile.SetSyntaxOps;
var
  SyntaxStyles: TmkreSyntaxStyles;
begin
  include(SyntaxStyles, mkre_No_Bk_Parens);
  if CheckBox1.Checked then include(SyntaxStyles, mkre_No_Bk_Parens)
                       else exclude(SyntaxStyles, mkre_No_Bk_Parens);
  if CheckBox2.Checked then include(SyntaxStyles, mkre_No_Bk_Vbar)
                       else exclude(SyntaxStyles, mkre_No_Bk_Vbar);
  if CheckBox3.Checked then include(SyntaxStyles, mkre_Bk_Plus_Qm)
                       else exclude(SyntaxStyles, mkre_Bk_Plus_Qm);
  if CheckBox4.Checked then include(SyntaxStyles, mkre_Tight_Vbar)
                       else exclude(SyntaxStyles, mkre_Tight_Vbar);
  if CheckBox5.Checked then include(SyntaxStyles, mkre_Newline_Or)
                       else exclude(SyntaxStyles, mkre_Newline_Or);
  if CheckBox6.Checked then include(SyntaxStyles, mkre_Context_Indep_Ops)
                       else exclude(SyntaxStyles, mkre_Context_Indep_Ops);
  if CheckBox7.Checked then include(SyntaxStyles, mkre_Ansi_Hex)
                       else exclude(SyntaxStyles, mkre_Ansi_Hex);
  if CheckBox8.Checked then include(SyntaxStyles, mkre_No_Gnu_Extensions)
                       else exclude(SyntaxStyles, mkre_No_Gnu_Extensions);
  mkreExpr1.SyntaxStyles := SyntaxStyles;
  mkreExpr1.UseFastmap := CheckBox9.Checked;
end;

procedure TfrmMatchOnFile.btnMatchClick(Sender: TObject);
var
  pattern: string;
begin
  if btnMatch.Caption = 'Match' then
  begin
    btnMatch.Caption := 'Stop';
    SetSyntaxOps;
    pattern := cbxPattern.Text;
    if pattern = '' then Exit;
    mkreExpr1.Pattern := pattern;
    mkreExpr1.Active := True;
    mkreExpr1.str := mkConvertDos2Ux(memo1.Lines.Text);
  end
  else
    begin
      mkreExpr1.Stop;
    end;
end;

procedure TfrmMatchOnFile.Load1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    memo1.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfrmMatchOnFile.FormCreate(Sender: TObject);
var
  registry: Tregistry;
  delphisource: string;
  c: integer;
  translate: string;
begin
  // I want a Biiiiig text file
  // so lets's search one windows.pas is great for our purpose
  registry := Tregistry.Create;
  try
    try
      registry.RootKey := HKEY_LOCAL_MACHINE;
      if not registry.OpenKey('SOFTWARE\Borland\Delphi\3.0', False) then
        registry.OpenKey('SOFTWARE\Borland\Delphi\2.0', False);
      delphisource := registry.ReadString('RootDir');
      delphisource := delphisource + '\source\rtl\win\windows.pas';
      if not FileExists(delphisource) then raise Exception.Create('Delphi vcl source not found. Ignore this error!');
      memo1.Lines.LoadFromFile(delphisource);
    except
      // no file found, take this one
      memo1.Lines.LoadFromFile('testfile1.txt');
    end;
  finally
    registry.Free;
  end;
{  //Ignore case
  SetLength(translate, 256);
  for c := 0 to 255 do
    translate[c] := char(c);
  for c := ord('a') to ord('z') do
    translate[c] := char(c - 32);
  mkreExpr1.translate := translate; }
end;

procedure TfrmMatchOnFile.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMatchOnFile.mkreExpr1Match(Sender: TObject; str: String; pos,
  ret: Integer; re_registers: Tmkre_registers);
begin
  memo2.Lines.Add('Pos: ' + itoa(pos) + #9 + str);//Format('Pos: %08d - %s', [pos, str]));
end;

procedure TfrmMatchOnFile.mkreExpr1Search(Sender: TObject; str: String;
  pos: Integer; re_registers: Tmkre_registers);
begin
  memo2.Lines.Add(Format('Pos: %08d - %s', [pos, str]));
end;

procedure TfrmMatchOnFile.btnSearchClick(Sender: TObject);
var
  pattern: string;
const
  pos: integer = 0;
begin
  Memo2.Lines.Clear;
  SetSyntaxOps;
  pattern := cbxPattern.Text;
  if pattern = '' then Exit;
  mkreExpr1.Pattern := pattern;
  mkreExpr1.Active := False;
  mkreExpr1.str := mkConvertDos2Ux(memo1.Lines.Text);
  if SpeedButton1.Down then
  begin
    if pos < 1 then pos := Length(mkreExpr1.str) + 1;
    pos := mkreExpr1.DoSearchWithRange(pos - 1, 1 - pos);
  end
  else
  begin
    pos := mkreExpr1.DoSearch(pos + 1);
    if pos < 0 then pos := 0;
  end;
end;

procedure TfrmMatchOnFile.FormShow(Sender: TObject);
begin
  Label5.Caption := '';
  GetSyntaxOps;
end;

procedure TfrmMatchOnFile.mkreExpr1StartMatch(Sender: TObject);
begin
  Memo2.Lines.Clear;
//  mwFastTime1.Start;
end;

procedure TfrmMatchOnFile.mkreExpr1EndMatch(Sender: TObject);
begin
//  mwFastTime1.Stop;
//  Label5.Caption := mwFastTime1.ElapsedTime;
  btnMatch.Caption := 'Match';
end;

end.
