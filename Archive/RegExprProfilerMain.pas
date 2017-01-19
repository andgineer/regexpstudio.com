unit RegExprProfilerMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AbleTestViewer;

type
  TfmRegExprProfilerMain = class(TForm)
    frmAbleTestViewer1: TfrmAbleTestViewer;
   private
    { Private declarations }
   public
    { Public declarations }
  end;

var
  fmRegExprProfilerMain: TfmRegExprProfilerMain;

implementation
{$R *.DFM}

uses
 AbleTest;

end.
