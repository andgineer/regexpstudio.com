program TestRExp;

uses
  Forms,
  TestRE in 'TestRE.pas' {fmTestRE},
  RegExpr in 'RegExpr.pas',
  PCode in 'PCode.pas' {fmPseudoCodeViewer},
  FileViewer in 'FileViewer.pas' {fmFileViewer},
  HyperLinksDecorator in 'HyperLinksDecorator.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Programme de Test pour TRegExpr';
  Application.CreateForm(TfmTestRE, fmTestRE);
  Application.Run;
end.
