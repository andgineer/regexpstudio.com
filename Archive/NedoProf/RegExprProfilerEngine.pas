{$B-}
unit RegExprProfilerEngine;

interface

uses
 Classes;

type
 TTestScriptOperation = integer;

 TRegExprProfiler = class;

 TTestScriptLoader = class
   private
    fFile : TextFile;
    fFileOpened : boolean;
    fFileName : string;
   public
    destructor Destroy; override;
    property FileName : string read fFileName write fFileName;
    procedure Open;
    procedure Close;

    function ReadLn : string;
  end;

 TTestScriptItem = class
   protected
    fProfiler : TRegExprProfiler;
   public
    Operation : TTestScriptOperation;

  end;

 TTestScript = class (TList) // of TTestScriptItem
   public
    constructor Create;
    destructor Destroy; override;

  end;

 TRegExprProfiler = class
   protected
    fScript : TTestScript;
    fScriptLoader : TTestScriptLoader;
   private
    function GetScriptItem (AIdx : integer) : TTestScriptItem;
   public
    constructor Create;
    destructor Destroy; override;

    property Script [AIdx : integer] : TTestScriptItem read GetScriptItem;
    property ScriptLoader : TTestScriptLoader read fScriptLoader;
    procedure Load (const AFileName : string);
  end;

implementation

uses
 SysUtils;


{=================== TTestScriptLoader =======================}

destructor TTestScriptLoader.Destroy;
 begin
  Close;
  inherited;
 end; { of destructor TTestScriptLoader.Destroy
--------------------------------------------------------------}

procedure TTestScriptLoader.Open;
 begin
  System.AssignFile (fFile, fFileName);
  System.Reset (fFile);
  fFileOpened := True;
 end; { of procedure TTestScriptLoader.Open
--------------------------------------------------------------}

procedure TTestScriptLoader.Close;
 begin
  if fFileOpened then begin
    System.CloseFile (fFile);
    fFileOpened := false;
   end;
 end; { of procedure TTestScriptLoader.Close
--------------------------------------------------------------}

function TTestScriptLoader.ReadLn : string;
 var
  s : string;
 begin
  System.Readln (fFile, s);
  Result := s;
 end; { of function TTestScriptLoader.ReadLn
--------------------------------------------------------------}


{====================== TTestScript ==========================}

constructor TTestScript.Create;
 begin
  inherited;
 end; {of constructor TTestScript.Create
--------------------------------------------------------------}

destructor TTestScript.Destroy;
 var
  i : integer;
 begin
  for i := Count downto 0 do begin
    if Assigned (Items [i]) then begin
      TTestScriptItem (Items [i]).Free;
      Items [i] := nil;
     end;
   end;
  inherited;
 end; { destructor TTestScript.Destroy
--------------------------------------------------------------}


{=================== TRegExprProfiler ========================}

function TRegExprProfiler.GetScriptItem (AIdx : integer) : TTestScriptItem;
 begin
  Result := TTestScriptItem (fScript.Items [AIdx]);
 end; { function TRegExprProfiler.GetScriptItem
--------------------------------------------------------------}

constructor TRegExprProfiler.Create;
 begin
  inherited;
  fScript := TTestScript.Create;
  fScriptLoader := TTestScriptLoader.Create;
 end; { of constructor TRegExprProfiler.Create
--------------------------------------------------------------}

destructor TRegExprProfiler.Destroy;
 begin

 end; { of destructor TRegExprProfiler.Destroy
--------------------------------------------------------------}

procedure TRegExprProfiler.Load (const AFileName : string);
 var
  ItemFirstLine : string;
 begin
  ScriptLoader.Close;
  ScriptLoader.FileName := AFileName;
  ScriptLoader.Open;
  REPEAT
   ItemFirstLine := ScriptLoader.ReadLn;
   if (Trim (ItemFirstLine) = '')
       or (ItemFirstLine [1] = ';') // we need $B- to prevent AV
    then BREAK;
  UNTIL False;
 end; { procedure TRegExprProfiler.Load
--------------------------------------------------------------}

function DoRegExprProfiling : boolean;
 begin

 end; { function DoRegExprProfiling
--------------------------------------------------------------}

end.
