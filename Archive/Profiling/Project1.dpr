program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Z_prof in 'Z_prof.pas' {profiler},
  mlRegularExpression in '..\mlRE\Source\mlRegularExpression.pas',
  mlObject in '..\mlRE\Source\mlObject.pas',
  RegExpr in '..\0926Published\RegExpr.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
