program Project1;

uses
  Forms,
  RegExpFrm in 'RegExpFrm.pas' {frmRegExpressionBuilder},
  RegExpr in '..\RegExpr.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmRegExpressionBuilder, frmRegExpressionBuilder);
  Application.Run;
end.
