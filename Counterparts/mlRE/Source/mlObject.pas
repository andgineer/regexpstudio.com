unit mlObject;

interface

uses SysUtils, Classes;

type

TmlObject = class;
TmlObservation = class;
TmlList = class;

// ===============================================================================================
// Exception: EmlObjectError
// =========================

{: Exception type for errors within TmlObject instances. }
EmlObjectError = class( Exception);

// ===============================================================================================
// Type: TCharset
// ==============

TCharset = set of char;

// ===============================================================================================
// Object: TmlObject
// =================

{: Reference Counting and Observer aware base class for Markup Library objects.<p>
   Provides an Interface aware reference counted memory management model for the Markup Library
   and implementation of the Observer design pattern.<p>
   <b>Memory Management</b><p>
   Using a standard constructor and <See Method=FreeRefs> (instead of Free) library classes can
   use standard Owner/Owned semantics to control instance lifetime while peacably coexisting with
   other instances which still have references to the object.<p>
   To clarify the expected behaviour, every descendant of TmlObject should include a <b>Memory
   Management</b> section in its documentation to state which other objects may be expected to
   maintain reference to this class, for what reason, and for what lifetime.<p>
   <b>Observer Pattern</b><p>
   The Observer design pattern provides a way in which one object can register an interest
   in the changes occuring in another object.
   @example A classes method can instantiate an object, use it and then discard it as follows:
   <code>
   oInstance := TmlSomeObject.Create;
   try
     ...
   finally
     oInstance.FreeRefs;
   end;</code>
   From the perspective of this code, oInstance is destroyed by FreeRefs and cannot be accessed
   after that line of code - just like calling Free. However, if a method in the try..finally
   block kept a reference to the object (by calling <See Method=AddRef>) then actual destruction
   will be deferred until that object discards its reference (by calling <See Method=Release>.
   @example A classes method can instantiate an object use it, and then destroy it as follows:
   <code>
   oInstance := TmlSomeObject.Create;
   try
     ...
   finally
     oInstance.Free;
   end;</code>
   The difference from the above example is that the destructor on these objects
   makes an Assertion that there are no remaining references, ensuring that the destruction of the
   object will occur at this point. <p>
   The impact of this is that external users of these objects can use them easily, without any
   required knowledge of their reference counting behaviour. However, if they try to destroy an
   object which still has references, the Assertion will let them know of the issue, allowing them
   to take appropriate action - either fixing the bug (if the error is genuine) or switching to
   FreeRefs (if the references are valid).
   }
TmlObject = class(TInterfacedObject)
private

  // Properties

  FoObservations: TmlList;
  FoWatches:      TmlList;

  // Internal Methods

  {: Find index into Observers property of a given Observation.
     @param sObservationClass ObservationClass to search for
     @param oObserver Observing Instance}
  function IndexOfObservation( sObservationClass: string; oObserver: TmlObject): integer;

protected

  // Property Methods

  function GetObservationCount: integer;
  function GetObservationByIndex( iIndex: integer): TmlObservation;

  function GetWatchCount: integer;
  function GetWatchByIndex( iIndex: integer): TmlObservation;

public

  // Standard Methods

  {: Create an object with one reference }
  constructor Create; virtual;

  {: Destroy the object when all references gone }
  destructor Destroy; override;

  {: Free this object. Provides a conventional create/destroy interface to our reference counted
     instances.
     @raises EmlObjectError if additional References still exist }
  procedure Free;

  {: Remove any references to this object which are known about by this object. <p>
     Called by the instance responsible for this instances lifetime to trigger removal of the last
     remaining references. The last thing this method does is a Release to balance the AddRef done
     in the constructor, so the owning instance should consider this instance destroyed when this
     method returns, in exactly the same way as the use of Free in normal circumstances.
     Actual destruction may not occur until other instances release their references. }
  procedure FreeRefs; virtual;

  // Reference Methods

  {: Add one to this objects reference count. Objects which need to ensure this instance is
     not destroyed until they have finished with the instance should call this. }
  procedure AddRef;

  {: Remove one from this objects reference count. Objects which have called AddRef to ensure this
     instance isn't destroyed should call this when they have finished with the instance. }
  procedure Release;

  // Observation Methods

  {: Register another instance as being interested in our changes }
  procedure AddObserver( oObserver: TmlObject; sObservationClass: string);

  {: Remove the registration of another instances interest. }
  procedure RemoveObserver( oObserver: TmlObject; sObservationClass: string);

  {: Send an observation with a related instance. }
  procedure SendObservation( sObservation: string; oInstance: TmlObject);

  {: Receive an observation with a related instance.
     Override this method in a descendant to react to observation messages from an observed instance
     as required.
     @param sObservation Observation message
     @param oInstance TmlObject instance about which the message has been sent }
  procedure ReceiveObservation( sObservation: string; oInstance: TmlObject); virtual;

  // Observer Pattern Properties

  {: Count of observations being made ON this instance. }
  property ObservationCount: integer read GetObservationCount;

  {: Access to observations being made ON this instance. }
  property Observations[ iIndex: integer]: TmlObservation read GetObservationByIndex;

  {: Count of Observations being made BY this instance. }
  property WatchCount: integer read GetWatchCount;

  {: Access to observations being made BY this instance. }
  property Watches[ iIndex: integer]: TmlObservation read GetWatchByIndex;

end;

// ================================================================================================
// Object: TmlObservation
// ======================

{: Record the details of an observation being made of a given TmlObject instance. }

TmlObservation = class( TmlObject)
private

  // Properties

  FoObserver:         TmlObject;
  FoObservee:         TmlObject;
  
  FsObservationClass: string;

  // Internal Methods

  {: Determine whether the passed observation is of relevance to our observer. }
  function IsObservedClass( sObservation: string): boolean;

public

  // Standard Methods

  {: Create an Observation instance. Only observations begining with ObservationClass will be
     sent to the observing instance.
     @param oObserver The instance requiring update information
     @param sObservationClass Class of observations which are of interest. }
  constructor Create( oObserver: TmlObject; oObservee: TmlObject;
                      sObservationClass: string); reintroduce;

  procedure FreeRefs; override;

  // Observation Methods

  {: Send an observation to our Observer.
     @param sObservation The observation to send.
     @param oInstance Instance related to observation }
  procedure SendObservation( sObservation: string; oInstance: TmlObject);

  // Properties

  {: Instance who is making this observation (as opposed to the instance being observed) }
  property Observer:         TmlObject read FoObserver;

  {: Class of observations of interest.
     @see IsObservedClass }
  property ObservationClass: string    read FsObservationClass;

end;

// ================================================================================================
// Object: TmlList
// ===============

{: TList style object to contain a list of TmlObjects and handle appropriate reference
   counting. When an object is added to the list, it's reference count is incremented and when
   removed decremented.
   @todo Add Sorting }

TmlList = class(TObject)
private

  FoList: TList;

protected

  // Property Methods

  function GetCount: integer;
  function GetObjectByIndex( iIndex: integer): TmlObject;

  function GetCapacity: integer;
  procedure SetCapacity( iCapacity: integer);

public

  // Standard methods

  constructor Create;
  destructor Destroy; override;

  // TList Style Methods

  {: Add an interface to the list }
  procedure Add( oInstance: TmlObject);

  {: Delete an item from the list by its index }
  procedure Delete( iIndex: integer);

  {: Remove an item from the list. }
  procedure Remove( oInstance: TmlObject);

  {: Index of an Interface in the list }
  function IndexOf( oInstance: TmlObject): integer;

  {: Clear the list. As a side effect (since references to the listed objects are freed, some
     objects may be destroyed. }
  procedure Clear;

  {: Clear the list and destroy all the contents. Primarily intended for use in the destruction
     sequence of a class to ensure that all owned objects are in fact destroyed, this can be used
     anywhere this behaviour is required. }
  procedure ClearObjects;

  // Properties

  {: Count of Interfaces in the list }
  property Count: integer read GetCount;

  {: Access to the interfaces in the list }
  property Objects[ iIndex: integer]: TmlObject read GetObjectByIndex; default;

  {: Capacity of list }
  property Capacity: integer read GetCapacity write SetCapacity;
end;

implementation

// ===============================================================================================
// Object: TmlObject
// =================

// Standard Methods
// ----------------

constructor TmlObject.Create;
begin
  inherited Create;

  FoObservations := TmlList.Create;
  FoWatches := TmlList.Create;

  // Every instance starts with one reference which is removed by FreeRefs   
  AddRef;
end;

destructor TmlObject.Destroy;
begin
  Assert( RefCount=0, classname+'.Destroy: '
                      +'Attempt to destroy instance with existing references.');

  inherited Destroy;
end;

procedure TmlObject.Free;
begin
  // We add our own reference and then call FreeRefs. If it is truely OK to free, this should
  // leave us with exactly one reference, which the Release gets rid of, triggering the
  // destruction of the instance
  AddRef;
  FreeRefs;
  if RefCount<>1 then
    raise EmlObjectError.CreateFmt( 'Instance of %s still has references when destroyed',
                                    [classname]);
  Release;
end;

procedure TmlObject.FreeRefs;
begin
  Assert( Assigned( self), 'TmlObject.FreeRefs: '
                           +'Cannot remove references unless the instance exists.');

  FoWatches.ClearObjects;
  FoWatches.Free;

  FoObservations.ClearObjects;
  FoObservations.Free;

  Release;
end;

// Reference Methods
// -----------------

procedure TmlObject.AddRef;
begin
  _AddRef;
end;

procedure TmlObject.Release;
begin
  _Release;
end;

// Observation Methods
// -------------------

procedure TmlObject.AddObserver( oObserver: TmlObject; sObservationClass: string);
begin
  if IndexOfObservation( sObservationClass, oObserver)=-1 then begin
    TmlObservation.Create( oObserver, self, sObservationClass);
    Assert( IndexOfObservation( sObservationClass, oObserver)<>-1,
            'TmlObject.AddObserver: Observation not added');
  end;
end;

procedure TmlObject.RemoveObserver( oObserver: TmlObject; sObservationClass: string);
var
  iIndex: integer;
begin
  iIndex := IndexOfObservation( sObservationClass, oObserver);
  Assert( iIndex<>-1, 'TmlObject.RemoveObserver: Observation not present');
  Observations[iIndex].Free;
  Assert( IndexOfObservation( sObservationClass, oObserver)=-1,
          'TmlObject.RemoveObserver: Observation not removed');
end;

procedure TmlObject.SendObservation( sObservation: string; oInstance: TmlObject);
var
  iScan: integer;
begin
  for iScan := 0 to ObservationCount-1 do
    Observations[iScan].SendObservation( sObservation, oInstance);
end;

procedure TmlObject.ReceiveObservation( sObservation: string; oInstance: TmlObject);
begin
  // No action
end;

// Property Methods
// ----------------

function TmlObject.GetObservationCount: integer;
begin
  Result := FoObservations.Count;
end;

function TmlObject.GetObservationByIndex( iIndex: integer): TmlObservation;
begin
  Result := FoObservations.Objects[iIndex] as TmlObservation;
end;

function TmlObject.GetWatchCount: integer;
begin
  Result := FoWatches.Count;
end;

function TmlObject.GetWatchByIndex( iIndex: integer): TmlObservation;
begin
  Result := FoWatches.Objects[iIndex] as TmlObservation;
end;

// Internal Methods
// ----------------

function TmlObject.IndexOfObservation( sObservationClass: string; oObserver: TmlObject): integer;
var
  iScan: integer;
begin
  Result := -1;
  for iScan := 0 to ObservationCount-1 do
    with Observations[iScan] do
      if (ObservationClass=sObservationClass) and (Observer=oObserver) then begin
        Result := iScan;
        break;
      end;
end;

// ================================================================================================
// Object: TmlObservation
// ======================

// Standard Methods
// ----------------

constructor TmlObservation.Create( oObserver: TmlObject; oObservee: TmlObject;
                                   sObservationClass: string);
begin
  inherited Create;

  FoObserver := oObserver;
  FoObservee := oObservee;

  FsObservationClass := sObservationClass;

  FoObservee.FoObservations.Add( self);
  FoObserver.FoWatches.Add( self);

end;

procedure TmlObservation.FreeRefs;
begin

  FoObserver.FoObservations.Remove(self);
  FoObservee.FoWatches.Remove( self);

  inherited FreeRefs;
end;

// Observation Methods
// -------------------

procedure TmlObservation.SendObservation( sObservation: string; oInstance: TmlObject);
begin
  if IsObservedClass( sObservation) then
    Observer.ReceiveObservation( sObservation, oInstance);
end;

// Internal Methods
// ----------------

function TmlObservation.IsObservedClass( sObservation: string): boolean;
begin
  Result := StrLIComp( PChar( FsObservationClass), PChar(sObservation),
                       Length( FsObservationClass))=0;
end;

// ================================================================================================
// Object: TmlInterfaceList
// ========================

// Standard methods
// ----------------

constructor TmlList.Create;
begin
  inherited Create;

  FoList := TList.Create;
end;

destructor TmlList.Destroy;
begin
  Clear;
  FoList.Free;

  inherited Destroy;
end;

// TList Style Methods
// -------------------

procedure TmlList.Add( oInstance: TmlObject);
begin
  oInstance.AddRef;
  FoList.Add( oInstance);
end;

procedure TmlList.Delete( iIndex: integer);
begin
  Objects[iIndex].Release;
  FoList.Delete( iIndex);
end;

procedure TmlList.Remove( oInstance: TmlObject);
begin
  FoList.Remove( oInstance);
  oInstance.Release;
end;

function TmlList.IndexOf( oInstance: TmlObject): integer;
begin
  Result := FoList.IndexOf( oInstance);
end;

procedure TmlList.Clear;
var
  iScan: integer;
begin
  for iScan := Count-1 downto 0 do
    Objects[iScan].Release;
  FoList.Clear;
end;

procedure TmlList.ClearObjects;
var
  iScan:     integer;
  oInstance: TmlObject;
begin
  for iScan := Count-1 downto 0 do begin
    oInstance := Objects[iScan];
    oInstance.Release;
    oInstance.Free;
  end;
  FoList.Clear;
end;

// Property Methods
// ----------------

function TmlList.GetCount: integer;
begin
  Result := FoList.Count;
end;

function TmlList.GetObjectByIndex( iIndex: integer): TmlObject;
begin
  Result := TmlObject(FoList[iIndex]);
end;

function TmlList.GetCapacity: integer;
begin
  Result := FoList.Capacity;
end;

procedure TmlList.SetCapacity( iCapacity: integer);
begin
  FoList.Capacity := iCapacity;
end;

end.

