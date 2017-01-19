program RegExprProfile;

uses
  Forms,
  RegExprProfileMain in 'RegExprProfileMain.pas' {fmRegExprProfileMain},
  Z_prof in 'Z_prof.pas' {profiler},
  mlRegularExpression in '..\mlRE\Source\mlRegularExpression.pas',
  mlObject in '..\mlRE\Source\mlObject.pas',
  TFUS in '..\..\PayCash\INetMart\TFUS.pas',
  RegExpr in '..\RegExpr.pas',
  mkregex in '..\RegEx\mkRegEx.pas',
  AVLtrees in '..\..\AbleBase\AVLtrees.pas',
  Arrays in '..\..\AbleBase\Arrays.pas',
  AbleFile in '..\..\AbleBase\AbleFile.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmRegExprProfileMain, fmRegExprProfileMain);
  Application.Run;
end.
