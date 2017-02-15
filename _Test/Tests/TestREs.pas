
{***********************************************************}
{                                                           }
{                     XML Data Binding                      }
{                                                           }
{         Generated on: 24.02.2006 13:28:53                 }
{       Generated from: Q:\RegExpr\Test\Tests\TestREs.xml   }
{   Settings stored in: Q:\RegExpr\Test\TestREs.xdb         }
{                                                           }
{***********************************************************}

unit TestREs;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLRegularExpressionsType = interface;
  IXMLRegularExpressionType = interface;
  IXMLRegularExpressionTypeList = interface;
  IXMLTestCaseType = interface;
  IXMLTestCaseTypeList = interface;
  IXMLStringType = interface;
  IXMLStringTypeList = interface;
  IXMLCapturedSubstringsType = interface;
  IXMLCapturedSubstringsTypeList = interface;
  IXMLSubstitutionType = interface;
  IXMLSubstitutionTypeList = interface;
  IXMLReplaceType = interface;
  IXMLReplaceTypeList = interface;

{ IXMLRegularExpressionsType }

  IXMLRegularExpressionsType = interface(IXMLNodeCollection)
    ['{2B0FFC3A-311C-4705-A96F-4B34A416649B}']
    { Property Accessors }
    function Get_RegularExpression(Index: Integer): IXMLRegularExpressionType;
    { Methods & Properties }
    function Add: IXMLRegularExpressionType;
    function Insert(const Index: Integer): IXMLRegularExpressionType;
    property RegularExpression[Index: Integer]: IXMLRegularExpressionType read Get_RegularExpression; default;
  end;

{ IXMLRegularExpressionType }

  IXMLRegularExpressionType = interface(IXMLNode)
    ['{D7E7F11F-0777-495B-BEA6-3D6C48FBE13A}']
    { Property Accessors }
    function Get_Name: Integer;
    function Get_Description: WideString;
    function Get_Comment: WideString;
    function Get_Expression: WideString;
    function Get_TestCase: IXMLTestCaseTypeList;
    procedure Set_Name(Value: Integer);
    procedure Set_Description(Value: WideString);
    procedure Set_Comment(Value: WideString);
    procedure Set_Expression(Value: WideString);
    { Methods & Properties }
    property Name: Integer read Get_Name write Set_Name;
    property Description: WideString read Get_Description write Set_Description;
    property Comment: WideString read Get_Comment write Set_Comment;
    property Expression: WideString read Get_Expression write Set_Expression;
    property TestCase: IXMLTestCaseTypeList read Get_TestCase;
  end;

{ IXMLRegularExpressionTypeList }

  IXMLRegularExpressionTypeList = interface(IXMLNodeCollection)
    ['{DEB97A65-17EB-46CA-B8D0-09D9586880AE}']
    { Methods & Properties }
    function Add: IXMLRegularExpressionType;
    function Insert(const Index: Integer): IXMLRegularExpressionType;
    function Get_Item(Index: Integer): IXMLRegularExpressionType;
    property Items[Index: Integer]: IXMLRegularExpressionType read Get_Item; default;
  end;

{ IXMLTestCaseType }

  IXMLTestCaseType = interface(IXMLNode)
    ['{86A0C71E-BB33-4B1B-9355-CC03FB4EBBC7}']
    { Property Accessors }
    function Get_Modifiers: WideString;
    function Get_String_: IXMLStringTypeList;
    function Get_CapturedSubstrings: IXMLCapturedSubstringsTypeList;
    function Get_Substitution: IXMLSubstitutionTypeList;
    function Get_Replace: IXMLReplaceTypeList;
    procedure Set_Modifiers(Value: WideString);
    { Methods & Properties }
    property Modifiers: WideString read Get_Modifiers write Set_Modifiers;
    property String_: IXMLStringTypeList read Get_String_;
    property CapturedSubstrings: IXMLCapturedSubstringsTypeList read Get_CapturedSubstrings;
    property Substitution: IXMLSubstitutionTypeList read Get_Substitution;
    property Replace: IXMLReplaceTypeList read Get_Replace;
  end;

{ IXMLTestCaseTypeList }

  IXMLTestCaseTypeList = interface(IXMLNodeCollection)
    ['{B44FD942-5016-4B0C-9AE9-A548EB84B179}']
    { Methods & Properties }
    function Add: IXMLTestCaseType;
    function Insert(const Index: Integer): IXMLTestCaseType;
    function Get_Item(Index: Integer): IXMLTestCaseType;
    property Items[Index: Integer]: IXMLTestCaseType read Get_Item; default;
  end;

{ IXMLStringType }

  IXMLStringType = interface(IXMLNode)
    ['{791F58A4-0C97-4DEB-953B-A56C8C58BAD1}']
    { Property Accessors }
    function Get_RepeatCount: Integer;
    procedure Set_RepeatCount(Value: Integer);
    { Methods & Properties }
    property RepeatCount: Integer read Get_RepeatCount write Set_RepeatCount;
  end;

{ IXMLStringTypeList }

  IXMLStringTypeList = interface(IXMLNodeCollection)
    ['{733F9219-F6EA-426E-AA2F-624A901863C0}']
    { Methods & Properties }
    function Add: IXMLStringType;
    function Insert(const Index: Integer): IXMLStringType;
    function Get_Item(Index: Integer): IXMLStringType;
    property Items[Index: Integer]: IXMLStringType read Get_Item; default;
  end;

{ IXMLCapturedSubstringsType }

  IXMLCapturedSubstringsType = interface(IXMLNodeCollection)
    ['{5F323EE3-EA98-4A1E-9487-01608A5D3E2B}']
    { Property Accessors }
    function Get_Substring(Index: Integer): WideString;
    { Methods & Properties }
    function Add(const Substring: WideString): IXMLNode;
    function Insert(const Index: Integer; const Substring: WideString): IXMLNode;
    property Substring[Index: Integer]: WideString read Get_Substring; default;
  end;

{ IXMLCapturedSubstringsTypeList }

  IXMLCapturedSubstringsTypeList = interface(IXMLNodeCollection)
    ['{281B9F34-AD12-46FE-8C2B-8274C642DB77}']
    { Methods & Properties }
    function Add: IXMLCapturedSubstringsType;
    function Insert(const Index: Integer): IXMLCapturedSubstringsType;
    function Get_Item(Index: Integer): IXMLCapturedSubstringsType;
    property Items[Index: Integer]: IXMLCapturedSubstringsType read Get_Item; default;
  end;

{ IXMLSubstitutionType }

  IXMLSubstitutionType = interface(IXMLNode)
    ['{1400A678-BDBB-4192-8277-F686C2B77633}']
    { Property Accessors }
    function Get_Template: WideString;
    function Get_Result: WideString;
    procedure Set_Template(Value: WideString);
    procedure Set_Result(Value: WideString);
    { Methods & Properties }
    property Template: WideString read Get_Template write Set_Template;
    property Result: WideString read Get_Result write Set_Result;
  end;

{ IXMLSubstitutionTypeList }

  IXMLSubstitutionTypeList = interface(IXMLNodeCollection)
    ['{F197FB33-514A-49F7-8387-665514F81D40}']
    { Methods & Properties }
    function Add: IXMLSubstitutionType;
    function Insert(const Index: Integer): IXMLSubstitutionType;
    function Get_Item(Index: Integer): IXMLSubstitutionType;
    property Items[Index: Integer]: IXMLSubstitutionType read Get_Item; default;
  end;

{ IXMLReplaceType }

  IXMLReplaceType = interface(IXMLNode)
    ['{5FD2B4C2-B5AF-4F0C-9AB0-98E29DC151AE}']
    { Property Accessors }
    function Get_Template: WideString;
    function Get_Result: WideString;
    procedure Set_Template(Value: WideString);
    procedure Set_Result(Value: WideString);
    { Methods & Properties }
    property Template: WideString read Get_Template write Set_Template;
    property Result: WideString read Get_Result write Set_Result;
  end;

{ IXMLReplaceTypeList }

  IXMLReplaceTypeList = interface(IXMLNodeCollection)
    ['{9E65DB49-66D9-44EF-994C-40D215743388}']
    { Methods & Properties }
    function Add: IXMLReplaceType;
    function Insert(const Index: Integer): IXMLReplaceType;
    function Get_Item(Index: Integer): IXMLReplaceType;
    property Items[Index: Integer]: IXMLReplaceType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLRegularExpressionsType = class;
  TXMLRegularExpressionType = class;
  TXMLRegularExpressionTypeList = class;
  TXMLTestCaseType = class;
  TXMLTestCaseTypeList = class;
  TXMLStringType = class;
  TXMLStringTypeList = class;
  TXMLCapturedSubstringsType = class;
  TXMLCapturedSubstringsTypeList = class;
  TXMLSubstitutionType = class;
  TXMLSubstitutionTypeList = class;
  TXMLReplaceType = class;
  TXMLReplaceTypeList = class;

{ TXMLRegularExpressionsType }

  TXMLRegularExpressionsType = class(TXMLNodeCollection, IXMLRegularExpressionsType)
  protected
    { IXMLRegularExpressionsType }
    function Get_RegularExpression(Index: Integer): IXMLRegularExpressionType;
    function Add: IXMLRegularExpressionType;
    function Insert(const Index: Integer): IXMLRegularExpressionType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRegularExpressionType }

  TXMLRegularExpressionType = class(TXMLNode, IXMLRegularExpressionType)
  private
    FTestCase: IXMLTestCaseTypeList;
  protected
    { IXMLRegularExpressionType }
    function Get_Name: Integer;
    function Get_Description: WideString;
    function Get_Comment: WideString;
    function Get_Expression: WideString;
    function Get_TestCase: IXMLTestCaseTypeList;
    procedure Set_Name(Value: Integer);
    procedure Set_Description(Value: WideString);
    procedure Set_Comment(Value: WideString);
    procedure Set_Expression(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLRegularExpressionTypeList }

  TXMLRegularExpressionTypeList = class(TXMLNodeCollection, IXMLRegularExpressionTypeList)
  protected
    { IXMLRegularExpressionTypeList }
    function Add: IXMLRegularExpressionType;
    function Insert(const Index: Integer): IXMLRegularExpressionType;
    function Get_Item(Index: Integer): IXMLRegularExpressionType;
  end;

{ TXMLTestCaseType }

  TXMLTestCaseType = class(TXMLNode, IXMLTestCaseType)
  private
    FString_: IXMLStringTypeList;
    FCapturedSubstrings: IXMLCapturedSubstringsTypeList;
    FSubstitution: IXMLSubstitutionTypeList;
    FReplace: IXMLReplaceTypeList;
  protected
    { IXMLTestCaseType }
    function Get_Modifiers: WideString;
    function Get_String_: IXMLStringTypeList;
    function Get_CapturedSubstrings: IXMLCapturedSubstringsTypeList;
    function Get_Substitution: IXMLSubstitutionTypeList;
    function Get_Replace: IXMLReplaceTypeList;
    procedure Set_Modifiers(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTestCaseTypeList }

  TXMLTestCaseTypeList = class(TXMLNodeCollection, IXMLTestCaseTypeList)
  protected
    { IXMLTestCaseTypeList }
    function Add: IXMLTestCaseType;
    function Insert(const Index: Integer): IXMLTestCaseType;
    function Get_Item(Index: Integer): IXMLTestCaseType;
  end;

{ TXMLStringType }

  TXMLStringType = class(TXMLNode, IXMLStringType)
  protected
    { IXMLStringType }
    function Get_RepeatCount: Integer;
    procedure Set_RepeatCount(Value: Integer);
  end;

{ TXMLStringTypeList }

  TXMLStringTypeList = class(TXMLNodeCollection, IXMLStringTypeList)
  protected
    { IXMLStringTypeList }
    function Add: IXMLStringType;
    function Insert(const Index: Integer): IXMLStringType;
    function Get_Item(Index: Integer): IXMLStringType;
  end;

{ TXMLCapturedSubstringsType }

  TXMLCapturedSubstringsType = class(TXMLNodeCollection, IXMLCapturedSubstringsType)
  protected
    { IXMLCapturedSubstringsType }
    function Get_Substring(Index: Integer): WideString;
    function Add(const Substring: WideString): IXMLNode;
    function Insert(const Index: Integer; const Substring: WideString): IXMLNode;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCapturedSubstringsTypeList }

  TXMLCapturedSubstringsTypeList = class(TXMLNodeCollection, IXMLCapturedSubstringsTypeList)
  protected
    { IXMLCapturedSubstringsTypeList }
    function Add: IXMLCapturedSubstringsType;
    function Insert(const Index: Integer): IXMLCapturedSubstringsType;
    function Get_Item(Index: Integer): IXMLCapturedSubstringsType;
  end;

{ TXMLSubstitutionType }

  TXMLSubstitutionType = class(TXMLNode, IXMLSubstitutionType)
  protected
    { IXMLSubstitutionType }
    function Get_Template: WideString;
    function Get_Result: WideString;
    procedure Set_Template(Value: WideString);
    procedure Set_Result(Value: WideString);
  end;

{ TXMLSubstitutionTypeList }

  TXMLSubstitutionTypeList = class(TXMLNodeCollection, IXMLSubstitutionTypeList)
  protected
    { IXMLSubstitutionTypeList }
    function Add: IXMLSubstitutionType;
    function Insert(const Index: Integer): IXMLSubstitutionType;
    function Get_Item(Index: Integer): IXMLSubstitutionType;
  end;

{ TXMLReplaceType }

  TXMLReplaceType = class(TXMLNode, IXMLReplaceType)
  protected
    { IXMLReplaceType }
    function Get_Template: WideString;
    function Get_Result: WideString;
    procedure Set_Template(Value: WideString);
    procedure Set_Result(Value: WideString);
  end;

{ TXMLReplaceTypeList }

  TXMLReplaceTypeList = class(TXMLNodeCollection, IXMLReplaceTypeList)
  protected
    { IXMLReplaceTypeList }
    function Add: IXMLReplaceType;
    function Insert(const Index: Integer): IXMLReplaceType;
    function Get_Item(Index: Integer): IXMLReplaceType;
  end;

{ Global Functions }

function GetregularExpressions(Doc: IXMLDocument): IXMLRegularExpressionsType;
function LoadregularExpressions(const FileName: WideString): IXMLRegularExpressionsType;
function NewregularExpressions: IXMLRegularExpressionsType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetregularExpressions(Doc: IXMLDocument): IXMLRegularExpressionsType;
begin
  Result := Doc.GetDocBinding('regularExpressions', TXMLRegularExpressionsType, TargetNamespace) as IXMLRegularExpressionsType;
end;

function LoadregularExpressions(const FileName: WideString): IXMLRegularExpressionsType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('regularExpressions', TXMLRegularExpressionsType, TargetNamespace) as IXMLRegularExpressionsType;
end;

function NewregularExpressions: IXMLRegularExpressionsType;
begin
  Result := NewXMLDocument.GetDocBinding('regularExpressions', TXMLRegularExpressionsType, TargetNamespace) as IXMLRegularExpressionsType;
end;

{ TXMLRegularExpressionsType }

procedure TXMLRegularExpressionsType.AfterConstruction;
begin
  RegisterChildNode('regularExpression', TXMLRegularExpressionType);
  ItemTag := 'regularExpression';
  ItemInterface := IXMLRegularExpressionType;
  inherited;
end;

function TXMLRegularExpressionsType.Get_RegularExpression(Index: Integer): IXMLRegularExpressionType;
begin
  Result := List[Index] as IXMLRegularExpressionType;
end;

function TXMLRegularExpressionsType.Add: IXMLRegularExpressionType;
begin
  Result := AddItem(-1) as IXMLRegularExpressionType;
end;

function TXMLRegularExpressionsType.Insert(const Index: Integer): IXMLRegularExpressionType;
begin
  Result := AddItem(Index) as IXMLRegularExpressionType;
end;

{ TXMLRegularExpressionType }

procedure TXMLRegularExpressionType.AfterConstruction;
begin
  RegisterChildNode('testCase', TXMLTestCaseType);
  FTestCase := CreateCollection(TXMLTestCaseTypeList, IXMLTestCaseType, 'testCase') as IXMLTestCaseTypeList;
  inherited;
end;

function TXMLRegularExpressionType.Get_Name: Integer;
begin
  Result := AttributeNodes['name'].NodeValue;
end;

procedure TXMLRegularExpressionType.Set_Name(Value: Integer);
begin
  SetAttribute('name', Value);
end;

function TXMLRegularExpressionType.Get_Description: WideString;
begin
  Result := ChildNodes['Description'].Text;
end;

procedure TXMLRegularExpressionType.Set_Description(Value: WideString);
begin
  ChildNodes['Description'].NodeValue := Value;
end;

function TXMLRegularExpressionType.Get_Comment: WideString;
begin
  Result := ChildNodes['Comment'].Text;
end;

procedure TXMLRegularExpressionType.Set_Comment(Value: WideString);
begin
  ChildNodes['Comment'].NodeValue := Value;
end;

function TXMLRegularExpressionType.Get_Expression: WideString;
begin
  Result := ChildNodes['Expression'].Text;
end;

procedure TXMLRegularExpressionType.Set_Expression(Value: WideString);
begin
  ChildNodes['Expression'].NodeValue := Value;
end;

function TXMLRegularExpressionType.Get_TestCase: IXMLTestCaseTypeList;
begin
  Result := FTestCase;
end;

{ TXMLRegularExpressionTypeList }

function TXMLRegularExpressionTypeList.Add: IXMLRegularExpressionType;
begin
  Result := AddItem(-1) as IXMLRegularExpressionType;
end;

function TXMLRegularExpressionTypeList.Insert(const Index: Integer): IXMLRegularExpressionType;
begin
  Result := AddItem(Index) as IXMLRegularExpressionType;
end;
function TXMLRegularExpressionTypeList.Get_Item(Index: Integer): IXMLRegularExpressionType;
begin
  Result := List[Index] as IXMLRegularExpressionType;
end;

{ TXMLTestCaseType }

procedure TXMLTestCaseType.AfterConstruction;
begin
  RegisterChildNode('string', TXMLStringType);
  RegisterChildNode('capturedSubstrings', TXMLCapturedSubstringsType);
  RegisterChildNode('substitution', TXMLSubstitutionType);
  RegisterChildNode('replace', TXMLReplaceType);
  FString_ := CreateCollection(TXMLStringTypeList, IXMLStringType, 'string') as IXMLStringTypeList;
  FCapturedSubstrings := CreateCollection(TXMLCapturedSubstringsTypeList, IXMLCapturedSubstringsType, 'capturedSubstrings') as IXMLCapturedSubstringsTypeList;
  FSubstitution := CreateCollection(TXMLSubstitutionTypeList, IXMLSubstitutionType, 'substitution') as IXMLSubstitutionTypeList;
  FReplace := CreateCollection(TXMLReplaceTypeList, IXMLReplaceType, 'replace') as IXMLReplaceTypeList;
  inherited;
end;

function TXMLTestCaseType.Get_Modifiers: WideString;
begin
  Result := AttributeNodes['Modifiers'].Text;
end;

procedure TXMLTestCaseType.Set_Modifiers(Value: WideString);
begin
  SetAttribute('Modifiers', Value);
end;

function TXMLTestCaseType.Get_String_: IXMLStringTypeList;
begin
  Result := FString_;
end;

function TXMLTestCaseType.Get_CapturedSubstrings: IXMLCapturedSubstringsTypeList;
begin
  Result := FCapturedSubstrings;
end;

function TXMLTestCaseType.Get_Substitution: IXMLSubstitutionTypeList;
begin
  Result := FSubstitution;
end;

function TXMLTestCaseType.Get_Replace: IXMLReplaceTypeList;
begin
  Result := FReplace;
end;

{ TXMLTestCaseTypeList }

function TXMLTestCaseTypeList.Add: IXMLTestCaseType;
begin
  Result := AddItem(-1) as IXMLTestCaseType;
end;

function TXMLTestCaseTypeList.Insert(const Index: Integer): IXMLTestCaseType;
begin
  Result := AddItem(Index) as IXMLTestCaseType;
end;
function TXMLTestCaseTypeList.Get_Item(Index: Integer): IXMLTestCaseType;
begin
  Result := List[Index] as IXMLTestCaseType;
end;

{ TXMLStringType }

function TXMLStringType.Get_RepeatCount: Integer;
begin
  Result := AttributeNodes['repeatCount'].NodeValue;
end;

procedure TXMLStringType.Set_RepeatCount(Value: Integer);
begin
  SetAttribute('repeatCount', Value);
end;

{ TXMLStringTypeList }

function TXMLStringTypeList.Add: IXMLStringType;
begin
  Result := AddItem(-1) as IXMLStringType;
end;

function TXMLStringTypeList.Insert(const Index: Integer): IXMLStringType;
begin
  Result := AddItem(Index) as IXMLStringType;
end;
function TXMLStringTypeList.Get_Item(Index: Integer): IXMLStringType;
begin
  Result := List[Index] as IXMLStringType;
end;

{ TXMLCapturedSubstringsType }

procedure TXMLCapturedSubstringsType.AfterConstruction;
begin
  ItemTag := 'substring';
  ItemInterface := IXMLNode;
  inherited;
end;

function TXMLCapturedSubstringsType.Get_Substring(Index: Integer): WideString;
begin
  Result := List[Index].Text;
end;

function TXMLCapturedSubstringsType.Add(const Substring: WideString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Substring;
end;

function TXMLCapturedSubstringsType.Insert(const Index: Integer; const Substring: WideString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Substring;
end;

{ TXMLCapturedSubstringsTypeList }

function TXMLCapturedSubstringsTypeList.Add: IXMLCapturedSubstringsType;
begin
  Result := AddItem(-1) as IXMLCapturedSubstringsType;
end;

function TXMLCapturedSubstringsTypeList.Insert(const Index: Integer): IXMLCapturedSubstringsType;
begin
  Result := AddItem(Index) as IXMLCapturedSubstringsType;
end;
function TXMLCapturedSubstringsTypeList.Get_Item(Index: Integer): IXMLCapturedSubstringsType;
begin
  Result := List[Index] as IXMLCapturedSubstringsType;
end;

{ TXMLSubstitutionType }

function TXMLSubstitutionType.Get_Template: WideString;
begin
  Result := ChildNodes['template'].Text;
end;

procedure TXMLSubstitutionType.Set_Template(Value: WideString);
begin
  ChildNodes['template'].NodeValue := Value;
end;

function TXMLSubstitutionType.Get_Result: WideString;
begin
  Result := ChildNodes['result'].Text;
end;

procedure TXMLSubstitutionType.Set_Result(Value: WideString);
begin
  ChildNodes['result'].NodeValue := Value;
end;

{ TXMLSubstitutionTypeList }

function TXMLSubstitutionTypeList.Add: IXMLSubstitutionType;
begin
  Result := AddItem(-1) as IXMLSubstitutionType;
end;

function TXMLSubstitutionTypeList.Insert(const Index: Integer): IXMLSubstitutionType;
begin
  Result := AddItem(Index) as IXMLSubstitutionType;
end;
function TXMLSubstitutionTypeList.Get_Item(Index: Integer): IXMLSubstitutionType;
begin
  Result := List[Index] as IXMLSubstitutionType;
end;

{ TXMLReplaceType }

function TXMLReplaceType.Get_Template: WideString;
begin
  Result := ChildNodes['template'].Text;
end;

procedure TXMLReplaceType.Set_Template(Value: WideString);
begin
  ChildNodes['template'].NodeValue := Value;
end;

function TXMLReplaceType.Get_Result: WideString;
begin
  Result := ChildNodes['result'].Text;
end;

procedure TXMLReplaceType.Set_Result(Value: WideString);
begin
  ChildNodes['result'].NodeValue := Value;
end;

{ TXMLReplaceTypeList }

function TXMLReplaceTypeList.Add: IXMLReplaceType;
begin
  Result := AddItem(-1) as IXMLReplaceType;
end;

function TXMLReplaceTypeList.Insert(const Index: Integer): IXMLReplaceType;
begin
  Result := AddItem(Index) as IXMLReplaceType;
end;
function TXMLReplaceTypeList.Get_Item(Index: Integer): IXMLReplaceType;
begin
  Result := List[Index] as IXMLReplaceType;
end;

end. 