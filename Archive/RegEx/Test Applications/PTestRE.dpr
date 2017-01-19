program PTestRE;

uses
  Forms,
  UfrmMain in 'UfrmMain.pas' {frmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
