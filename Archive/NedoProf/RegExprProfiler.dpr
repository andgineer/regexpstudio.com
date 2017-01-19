program RegExprProfiler;

uses
  Forms,
  RegExprProfilerMain in 'RegExprProfilerMain.pas' {fmRegExprProfiler},
  RegExpr in '..\RegExpr.pas',
  RegExprProfilerEngine in 'RegExprProfilerEngine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfmRegExprProfiler, fmRegExprProfiler);
  Application.Run;
end.
