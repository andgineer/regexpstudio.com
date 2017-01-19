program RegExprDebugger;

uses
  Forms,
  RegExprDebuggerMain in 'RegExprDebuggerMain.pas' {fmTestRE},
  PCode in 'PCode.pas' {fmPseudoCodeViewer},
  FileViewer in 'FileViewer.pas' {fmFileViewer},
  RegExpr in '..\Sources\RegExpr.pas',
  RegExprList in 'RegExprList.pas',
  RegExprListDlg in 'RegExprListDlg.pas' {fmRegExprListDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmRegExprDebugger, fmRegExprDebugger);
  Application.Run;
end.
