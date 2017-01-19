{$B-}
unit RegExprList;

interface

uses
 Classes;

type
 TRegExprItem = class (TCollectionItem)
   end;

 TRegExprList = class (TCollection)
   private
    function GetItem (Index : integer): TRegExprItem;
    procedure SetItem (Index : integer; Value: TRegExprItem);
   public
    constructor Create;
    property Items [Index : integer] : TRegExprItem read GetItem write SetItem;
    function Add : TRegExprItem;
  end;

implementation


{======================= TRegExprList ========================}

constructor TRegExprList.Create;
 begin
  inherited Create (TRegExprItem);
 end; { of constructor TRegExprList.Create
--------------------------------------------------------------}

function TRegExprList.GetItem (Index: Integer): TRegExprItem;
 begin
  Result := TRegExprItem (inherited GetItem (Index));
 end; { of function TRegExprList.GetItem
--------------------------------------------------------------}

procedure TRegExprList.SetItem (Index: Integer; Value: TRegExprItem);
 begin
  inherited SetItem (Index, Value);
 end; { of procedure TRegExprList.SetItem
--------------------------------------------------------------}

function TRegExprList.Add : TRegExprItem;
 begin
  Result := TRegExprItem (inherited Add);
 end; { of function TRegExprList.Add
--------------------------------------------------------------}


end.
