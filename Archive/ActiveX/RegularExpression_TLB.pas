unit RegularExpression_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.88  $
// File generated on 15.08.00 17:25:27 from Type Library described below.

// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
// ************************************************************************ //
// Type Lib: D:\Andrey\RegExpr\ActiveX\RegularExpression.tlb (1)
// IID\LCID: {905B6A52-727D-11D4-82BA-0080ADB053D1}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (D:\W5\System32\StdOle2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  RegularExpressionMajorVersion = 1;
  RegularExpressionMinorVersion = 0;

  LIBID_RegularExpression: TGUID = '{905B6A52-727D-11D4-82BA-0080ADB053D1}';

  IID_IRegularExpression: TGUID = '{905B6A53-727D-11D4-82BA-0080ADB053D1}';
  CLASS_RegularExpression_: TGUID = '{905B6A55-727D-11D4-82BA-0080ADB053D1}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRegularExpression = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RegularExpression_ = IRegularExpression;


// *********************************************************************//
// Interface: IRegularExpression
// Flags:     (256) OleAutomation
// GUID:      {905B6A53-727D-11D4-82BA-0080ADB053D1}
// *********************************************************************//
  IRegularExpression = interface(IUnknown)
    ['{905B6A53-727D-11D4-82BA-0080ADB053D1}']
    function  Get_Expression: PChar; stdcall;
    procedure Set_Expression(Value: PChar); stdcall;
    function  Exec(InputString: PChar): WordBool; stdcall;
    function  ExecNext: WordBool; stdcall;
  end;

// *********************************************************************//
// The Class CoRegularExpression_ provides a Create and CreateRemote method to          
// create instances of the default interface IRegularExpression exposed by              
// the CoClass RegularExpression_. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRegularExpression_ = class
    class function Create: IRegularExpression;
    class function CreateRemote(const MachineName: string): IRegularExpression;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TRegularExpression_
// Help String      : RegularExpression Object
// Default Interface: IRegularExpression
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TRegularExpression_Properties= class;
{$ENDIF}
  TRegularExpression_ = class(TOleServer)
  private
    FIntf:        IRegularExpression;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TRegularExpression_Properties;
    function      GetServerProperties: TRegularExpression_Properties;
{$ENDIF}
    function      GetDefaultInterface: IRegularExpression;
  protected
    procedure InitServerData; override;
    function  Get_Expression: PChar;
    procedure Set_Expression(Value: PChar);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IRegularExpression);
    procedure Disconnect; override;
    function  Exec(InputString: PChar): WordBool;
    function  ExecNext: WordBool;
    property  DefaultInterface: IRegularExpression read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TRegularExpression_Properties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TRegularExpression_
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TRegularExpression_Properties = class(TPersistent)
  private
    FServer:    TRegularExpression_;
    function    GetDefaultInterface: IRegularExpression;
    constructor Create(AServer: TRegularExpression_);
  protected
    function  Get_Expression: PChar;
    procedure Set_Expression(Value: PChar);
  public
    property DefaultInterface: IRegularExpression read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

implementation

uses ComObj;

class function CoRegularExpression_.Create: IRegularExpression;
begin
  Result := CreateComObject(CLASS_RegularExpression_) as IRegularExpression;
end;

class function CoRegularExpression_.CreateRemote(const MachineName: string): IRegularExpression;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RegularExpression_) as IRegularExpression;
end;

procedure TRegularExpression_.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{905B6A55-727D-11D4-82BA-0080ADB053D1}';
    IntfIID:   '{905B6A53-727D-11D4-82BA-0080ADB053D1}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TRegularExpression_.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IRegularExpression;
  end;
end;

procedure TRegularExpression_.ConnectTo(svrIntf: IRegularExpression);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TRegularExpression_.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TRegularExpression_.GetDefaultInterface: IRegularExpression;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TRegularExpression_.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TRegularExpression_Properties.Create(Self);
{$ENDIF}
end;

destructor TRegularExpression_.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TRegularExpression_.GetServerProperties: TRegularExpression_Properties;
begin
  Result := FProps;
end;
{$ENDIF}

function  TRegularExpression_.Get_Expression: PChar;
begin
  Result := DefaultInterface.Get_Expression;
end;

procedure TRegularExpression_.Set_Expression(Value: PChar);
begin
  DefaultInterface.Set_Expression(Value);
end;

function  TRegularExpression_.Exec(InputString: PChar): WordBool;
begin
  Result := DefaultInterface.Exec(InputString);
end;

function  TRegularExpression_.ExecNext: WordBool;
begin
  Result := DefaultInterface.ExecNext;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TRegularExpression_Properties.Create(AServer: TRegularExpression_);
begin
  inherited Create;
  FServer := AServer;
end;

function TRegularExpression_Properties.GetDefaultInterface: IRegularExpression;
begin
  Result := FServer.DefaultInterface;
end;

function  TRegularExpression_Properties.Get_Expression: PChar;
begin
  Result := DefaultInterface.Get_Expression;
end;

procedure TRegularExpression_Properties.Set_Expression(Value: PChar);
begin
  DefaultInterface.Set_Expression(Value);
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents('Servers',[TRegularExpression_]);
end;

end.
