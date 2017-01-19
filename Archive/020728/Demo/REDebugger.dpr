{$I REDebugger_inc}
program REDebugger;

{
 Visual debugger for regular expressions

 (c) 1999-2002 Andrey V. Sorokin
  St-Petersburg, Russia
  anso@mail.ru, anso@paycash.ru
  http://anso.virtualave.net
  http://anso.da.ru
}

uses
  Forms,
  REDebuggerMain in 'REDebuggerMain.pas' {fmREDebuggerMain},
  PCode in 'PCode.pas' {fmPseudoCodeViewer},
  FileViewer in 'FileViewer.pas' {fmFileViewer},
  RegExpr in '..\Source\RegExpr.pas',
  RETestCases in 'RETestCases.pas',
  StopWatch in '..\StopWatch\StopWatch.pas',
  RETestCasesDlg in 'RETestCasesDlg.pas' {fmRETestCasesDlg},
  tynList in '..\Persistence\tynList.pas',
  ansoRTTIHook in '..\Persistence\ansoRTTIHook.pas',
  ansoStrings in '..\Persistence\ansoStrings.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmREDebuggerMain, fmREDebuggerMain);
  Application.CreateForm(TfmRETestCasesDlg, fmRETestCasesDlg);
  Application.Run;
end.
