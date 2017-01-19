library RegularExpression;

uses
  ComServ,
  RegularExpression_TLB in 'RegularExpression_TLB.pas',
  RegExprCOM in 'RegExprCOM.pas' {RegularExpression: CoClass},
  RegExpr in '..\RegExpr.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
