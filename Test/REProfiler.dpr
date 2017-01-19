program REProfiler;

uses
  Forms,
  REProfilerMain in 'REProfilerMain.pas' {fmREProfilerMain},
  RegExpr in '..\Source\RegExpr.pas',
  mlRegularExpression in '..\Counterparts\mlRE\Source\mlRegularExpression.pas',
  mlObject in '..\Counterparts\mlRE\Source\mlObject.pas',
  RETestCases in '..\Source\REStudio\RETestCases.pas',
  tynList in '..\Source\REStudio\Persistence\tynList.pas',
  ansoStrings in '..\Source\REStudio\Persistence\ansoStrings.pas',
  ansoRTTIHook in '..\Source\REStudio\Persistence\ansoRTTIHook.pas',
  StopWatch in '..\Source\REStudio\StopWatch\StopWatch.pas',
  TestREs in 'Tests\TestREs.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmREProfilerMain, fmREProfilerMain);
  Application.Run;
end.
