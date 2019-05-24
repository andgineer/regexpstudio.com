{$I REStudio_inc}
program REStudio;

{
 Visual debugger for regular expressions

 (c) 1999-2004 Andrey V. Sorokin
  Saint Petersburg, Russia
  anso@mail.ru, anso@paycash.ru
  https://regex.sorokin.engineer
  http://anso.da.ru
}

uses
  Forms,
  REStudioMain in 'REStudioMain.pas' {fmREStudioMain},
  PCode in 'PCode.pas' {fmPseudoCodeViewer},
  FileViewer in 'FileViewer.pas' {fmFileViewer},
  RegExpr in '..\RegExpr.pas',
  RETestCases in 'RETestCases.pas',
  StopWatch in 'StopWatch\StopWatch.pas',
  tynList in 'Persistence\tynList.pas',
  ansoRTTIHook in 'Persistence\ansoRTTIHook.pas',
  ansoStrings in 'Persistence\ansoStrings.pas',
  RETestCasesFm in 'RETestCasesFm.pas' {fmTestCases},
  RegularExpressionsXMLBind in 'RegularExpressionsXMLBind.pas',
  RegularExpressionList in 'RegularExpressionList.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmREDebuggerMain, fmREDebuggerMain);
  Application.CreateForm(TfmTestCases, fmTestCases);
  Application.Run;
end.

