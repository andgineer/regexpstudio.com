{$D- $L-}
//******************************************************************************
//  SysHeapManager.pas
//  Королев
//  Контроль над выделением памяти из системной кучи
//******************************************************************************
unit SysHeapManager;

interface
uses Windows;

const
  strSystemMemoryLost = 'Потеряна системная память (%d байт)';
  strCaption          = 'Внимание!';
  strLostMemoryMessageFormat = '<<SYSMEN>>: Адрес: %08X, длина - %d байт';

var
 OldMemMgr: TMemoryManager;
 BorlandHeap: THandle;
{$IFDEF DEBUG}
 SysHeapSize: integer = 0;
 ShowMemHandler: procedure(Size: integer); stdcall;
{$ENDIF}


implementation

 //------------------------------------------------------------------------------
function NewGetMem(Size: Integer): Pointer;
begin
 result := HeapAlloc(BorlandHeap, 0, Size);
{$IFDEF DEBUG}
{$IFDEF Win95}
 inc(SysHeapSize,HeapSize(BorlandHeap, 0, result));
{$ELSE}
 inc(SysHeapSize, Size);
{$ENDIF}
 if Assigned(ShowMemHandler) then
  ShowMemHandler(SysHeapSize);

// if (Size = 352) then // and (dword(result) = $e4c880) then
//  OutputDebugString('');
{$ENDIF}
end; // NewGetMem

//------------------------------------------------------------------------------
function NewFreeMem(P: Pointer): Integer;
begin
{$IFDEF DEBUG}
 dec(SysHeapSize, HeapSize(BorlandHeap, 0, p));
 if Assigned(ShowMemHandler) then
  ShowMemHandler(SysHeapSize);
 FillMemory(p, HeapSize(BorlandHeap, 0, p), $FF);
{$ENDIF}
 if HeapFree(BorlandHeap, 0, p) then
  result := 0
 else
  begin
   OutputDebugString('NewFreeMem => HeapFree failed');
   result := 1;
  end;
end; // NewFreeMem

//------------------------------------------------------------------------------
function NewReallocMem(P: Pointer; Size: Integer): Pointer;
begin
{$IFDEF DEBUG}
{$IFDEF Win95}
 dec(SysHeapSize, HeapSize(BorlandHeap, 0, p));
{$ELSE}
 inc(SysHeapSize, Size - integer(HeapSize(BorlandHeap, 0, p)));
 if Assigned(ShowMemHandler) then
  ShowMemHandler(SysHeapSize);
{$ENDIF}
{$ENDIF}
 result := HeapReAlloc(BorlandHeap, 0, p, Size);
{$IFDEF DEBUG}
{$IFDEF Win95}
 inc(SysHeapSize, HeapSize(BorlandHeap, 0, result));
 if Assigned(ShowMemHandler) then
  ShowMemHandler(SysHeapSize);
{$ENDIF}
{$ENDIF}
end; // NewReallocMem


const
 NewMemMgr: TMemoryManager = (
 GetMem: NewGetMem;
 FreeMem: NewFreeMem;
 ReallocMem: NewReallocMem);

{$IFDEF DEBUG}
var
 HE: TProcessHeapEntry;
 P: array[0..255] of Char;
{$ENDIF}


//------------------------------------------------------------------------------
initialization
 IsMultiThread := true;
 BorlandHeap := HeapCreate(0, 0, 0);
 GetMemoryManager(OldMemMgr);
 SetMemoryManager(NewMemMgr);

//------------------------------------------------------------------------------
finalization
 SetMemoryManager(OldMemMgr);

{$IFDEF DEBUG}
 if (SysHeapSize <> 0)
{$IFDEF SEPARATE}
    and (SysHeapSize <> 12)
{$ENDIF}
  then
 begin
   wvsprintf(@P, strSystemMemoryLost, @SysHeapSize);
   MessageBox(0, @P, strCaption, MB_OK or MB_ICONERROR or MB_SETFOREGROUND or MB_TASKMODAL or MB_TOPMOST);
   OutputDebugString(@P);
   HE.lpData := nil;
   while HeapWalk(BorlandHeap, HE) do
    if (HE.wFlags and $4 <> 0 ) then
     begin
      wvsprintf(@P, strLostMemoryMessageFormat, @HE);
      OutputDebugString(p);
     end;
 end;
{$ENDIF}

 HeapDestroy(BorlandHeap);
end.

















