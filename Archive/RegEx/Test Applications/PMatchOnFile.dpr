program PMatchOnFile;

uses
  Forms,
  UfrmMatchOnFile in 'UfrmMatchOnFile.pas' {frmMatchOnFile},
  mkStrUtils in '..\mkStrUtils.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMatchOnFile, frmMatchOnFile);
  Application.Run;
end.
