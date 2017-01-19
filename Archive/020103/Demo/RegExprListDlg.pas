{$B-}
unit RegExprListDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, RegExprList;

type
  TfmRegExprListDlg = class(TForm)
    ListBox1: TListBox;
    btnOk: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
  public
    RegExprs : TRegExprList;
  end;

var
  fmRegExprListDlg: TfmRegExprListDlg;

implementation

{$R *.dfm}

procedure TfmRegExprListDlg.FormCreate(Sender: TObject);
 begin
  RegExprs := TRegExprList.Create;

 end;

end.
