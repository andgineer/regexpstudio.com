{$B-}
unit RegularExpressions;

interface

uses
 Classes;

type
  TOnExpression = procedure (Sender: TObject; var Expr: Boolean) of
object;

  TRegularExpressions = class(TComponent)
  private
    FOnExpression: TOnExpression;
    FOnTrue, FOnFalse: TNotifyEvent;
    procedure SetExpression(Value: Boolean);
  protected
    procedure DoOnExpression(var Expr: Boolean); virtual;
    procedure DoOnTrue; virtual;
    procedure DoOnFalse; virtual;
  public
    property Expression: Boolean write SetExpression;
  published
    property OnExpression: TOnExpression read FOnExpression write
FOnExpression;
    property OnTrue: TNotifyEvent read FOnTrue write FOnTrue;
    property OnFalse: TNotifyEvent read FOnfalse write FOnfalse;
  end;

procedure Register;

implementation

uses
 DsgnIntf,
 REDebuggerMain;

type
 TRECompEditor = class (TComponentEditor)
    procedure ExecuteVerb (Index: Integer); override;
    function GetVerb (Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure TRegularExpressions.SetExpression(Value: Boolean);
begin
  DoOnExpression(Value);
  if Value then
    DoOnTrue
  else
    DoOnFalse;   
end;

procedure TRegularExpressions.DoOnExpression(var Expr: Boolean);
begin
  if Assigned(FOnExpression) then
    FOnExpression(Self, Expr);
end;

procedure TRegularExpressions.DoOnTrue;
begin
  if Assigned(FOnTrue) then
    FOnTrue(Self);
end;

procedure TRegularExpressions.DoOnFalse;
begin
  if Assigned(FOnFalse) then
    FOnFalse(Self);
end;


procedure TRECompEditor.ExecuteVerb(Index: Integer);
 procedure DoEdit;
  begin
   with TfmREDebuggerMain.Create (nil)
    do Show;
// (Component as TRegularExpressions).Expression :=
// Designer.Modified := True;
  end;
 begin
  case Index of
    0 : DoEdit;
   end;
 end;

function TRECompEditor.GetVerb(Index: Integer): string;
 begin
  case Index of
    0: Result := 'Select/debug r.e.';
   end;
 end;

function TRECompEditor.GetVerbCount: Integer;
 begin
  Result := 1;
 end;


procedure Register;
 begin
  RegisterComponents('Additional', [TRegularExpressions]);
  RegisterComponentEditor(TRegularExpressions, TRECompEditor);
 end;


end.
