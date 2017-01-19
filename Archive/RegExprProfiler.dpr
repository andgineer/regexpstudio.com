program RegExprProfiler;

uses
  Forms,
  RegExprProfilerMain in 'RegExprProfilerMain.pas' {fmRegExprProfilerMain},
  AbleTest in 'AbleTest.pas',
  RegExprProfilerEngine in 'RegExprProfilerEngine.pas',
  AbleTestViewer in 'AbleTestViewer.pas' {frmAbleTestViewer: TFrame};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmRegExprProfilerMain, fmRegExprProfilerMain);
  Application.Run;
end.
