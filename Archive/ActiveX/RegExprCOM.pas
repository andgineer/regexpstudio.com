{$B-}
unit RegExprCOM;

interface

uses
  Windows, ActiveX, Classes, ComObj, RegularExpression_TLB,
  RegExpr;

type
  TRegularExpression = class(TTypedComObject, IRegularExpression)
   private
    fRE : TRegExpr;
   protected
    function  Get_Expression: PChar; stdcall;
    procedure Set_Expression (Value: PChar); stdcall;
    function  Exec (InputString: PChar): WordBool; stdcall;
    function  ExecNext: WordBool; stdcall;
   public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses ComServ;


constructor TRegularExpression.Create;
 begin
  inherited;
  fRE := TRegExpr.Create;
 end; { of constructor TRegularExpression.Create
--------------------------------------------------------------}

destructor TRegularExpression.Destroy;
 begin
  fRE.Free;
  inherited;
 end; { of destructor TRegularExpression.Destroy
--------------------------------------------------------------}

function TRegularExpression.Get_Expression: PChar; stdcall;
 begin
  Result := PChar (fRE.Expression);
 end; { of function Get_Expression
--------------------------------------------------------------}

procedure TRegularExpression.Set_Expression (Value: PChar); stdcall;
 begin
  fRE.Expression := Value;
 end; { of function Set_Expression
--------------------------------------------------------------}

function TRegularExpression.Exec (InputString: PChar): WordBool; stdcall;
 begin
  Result := fRE.Exec (InputString);
 end; { of function TRegularExpression.Exec
--------------------------------------------------------------}

function TRegularExpression.ExecNext: WordBool; stdcall;
 begin
  Result := fRE.ExecNext;
 end; { of function TRegularExpression.ExecNext
--------------------------------------------------------------}



initialization
  TTypedComObjectFactory.Create(ComServer, TRegularExpression, CLASS_RegularExpression_,
    ciMultiInstance, tmApartment);
end.

