{$B-}
unit FileViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TfmFileViewer = class(TForm)
    RichEdit1: TRichEdit;
    pnlBottom: TPanel;
    btnRefresh: TSpeedButton;
    btnClose: TSpeedButton;
    lblRegExpr: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  end;

implementation
{$R *.DFM}

uses
 TestRE;

procedure TfmFileViewer.FormClose(Sender: TObject;
  var Action: TCloseAction);
 begin
  Action := caFree;
 end;

procedure TfmFileViewer.btnCloseClick(Sender: TObject);
 begin
  Close;
 end;

procedure TfmFileViewer.btnRefreshClick(Sender: TObject);
 begin
  fmTestRE.HighlightREInFileViewer (Self);
 end;

end.
