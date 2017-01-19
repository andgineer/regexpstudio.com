{ Tool for timing evaluation of Delphi Pascal code fragments.
  Timing is based on the cpu clock , resolution  ca 10ns (=10^-8 s).
  May , version 2.20 published as freeware by author A. Baars
  , any comments :  antonie.baars@wxs.nl              }

unit Z_prof;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Buttons, ExtCtrls, StdCtrls;

const nmarks=20;
type
markrecord=record
  passes:dword;
  t: comp;
  Ctime,totaltime,fastest,prevtime:extended;
  active:boolean;
  end;

Tprofiler = class(TForm)
    Panel1: TPanel;
    Clearbutton: TSpeedButton;
    DrawGrid1: TDrawGrid;
    RadioGroup1: TRadioGroup;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure ClearbuttonClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
  rmark:array[1..nmarks] of markrecord;
  procedure gettime(nr:integer);
  function gettimediff(nr:integer):extended;
  procedure CorrectForOverhead;
  procedure calibrateCPU;
  procedure tablecontent(Sender: TObject; Col, Row: Longint; Rect: TRect; State: TGridDrawState);
  public
  fdvisible,frvisible :boolean;
  procedure mark(nr:integer;aactive:boolean);
  end;

TZprofiler = class(TComponent)
  private
  profiler: Tprofiler;
  procedure setfdvisible(b1:boolean);
  function getfdvisible:boolean;
  procedure setfrvisible(b1:boolean);
  function getfrvisible:boolean;
  public
  constructor create(aowner:tcomponent);override;
  destructor destroy;override;
  procedure mark(nr:integer;aactive:boolean);
  property Visible:boolean read getfrvisible write setfrvisible;
  published
  property VisibleInDesignmode:boolean read getfdvisible write setfdvisible;
  end;
procedure Register;
var
  profile: Tprofiler;

implementation
{$R *.DFM}

type
  TCompRec = record
    Lo, Hi: DWord;
  end;
const
  installedcount:integer=0;
var
  gridhandle:hwnd;
  m,n: comp;
  lastmark: Integer;
  CPUclock,
  residualtime:extended;

procedure Register;
begin
  RegisterComponents('samples', [TZprofiler]);
end;

constructor TZprofiler.create(aowner:tcomponent);
begin
inherited create(aowner);
if installedcount=0 then profile:=tprofiler.create(application.mainform);
profile.visible:=true;
inc(installedcount);
profiler:=profile;
if (csdesigning in ComponentState) then
   begin
   if visibleindesignmode then profiler.show else profiler.hide;
   end;
end;

destructor TZprofiler.destroy;
begin
dec(installedcount);
if installedcount=0 then profile.free;
inherited destroy;
end;

procedure TZprofiler.setfdvisible(b1:boolean);
begin
profile.fdvisible:=b1;
if ((csdesigning in ComponentState) and not b1) then profiler.hide
                                                else profiler.show;
end;
function TZprofiler.getfdvisible:boolean;
begin
result:=profile.fdvisible;
end;

procedure TZprofiler.setfrvisible(b1:boolean);
begin
profile.frvisible:=b1;
if (csdesigning in ComponentState) then exit;
if b1 then profiler.show else profiler.hide;
end;

function TZprofiler.getfrvisible:boolean;
begin
result:=profile.frvisible;
end;


procedure TZprofiler.mark(nr:integer;aactive:boolean);
begin
profiler.mark(nr,aactive);
end;

procedure tprofiler.tablecontent(Sender: TObject; Col, Row: Longint; Rect: TRect; State: TGridDrawState);
var mtext,mmtext:string;div1:extended;
begin mtext:='';mmtext:='';div1:=1;
case radiogroup1.itemindex of
     0:begin mmtext:='s';div1:=1e-6;end;
     1:begin mmtext:='ms';div1:=1e-3;end;
     2:begin mmtext:='µs';div1:=1;end;
     end;
if row=0 then case col of
                    0:mtext:='marknr';
                    1:mtext:='passes';
                    2:mtext:='time /'+mmtext;
                    3:mtext:='last /'+mmtext;
                    4:mtext:='mean /'+mmtext;
                    5:mtext:='fastest /'+mmtext;
              end
          else with rmark[row] do case col of
                    0:mtext:=inttostr(row);
                    1:mtext:=inttostr(passes);
                    2:mtext:=FloatToStrF(div1*totaltime/cpuclock,fffixed,8,2);
                    3:mtext:=FloatToStrF(div1*Ctime/cpuclock,fffixed,8,2);
		    4:if passes>0 then mtext:=floattostrf(div1*totaltime/(cpuclock*passes),fffixed,8,2);
                    5:if passes>0 then mtext:=FloatToStrF(div1*fastest/cpuclock,fffixed,8,2);
                    end;

with Rect, tdrawgrid(sender).Canvas do
TextRect(Rect, Left + (Right - Left - TextWidth(mtext)) div 2,
               Top + (Bottom - Top - TextHeight(mtext)) div 2, mtext);
end;

procedure mmtime;assembler;
asm
        DB 0FH
	DB 031H
	mov TCompRec(m).hi,edx
	mov TCompRec(m).lo,eax
end;
procedure nntime;assembler;
asm
	DB 0FH
	DB 031H
	mov TCompRec(n).hi,edx
	mov TCompRec(n).lo,eax
end;

procedure Tprofiler.gettime(nr:integer);
begin
       rmark[nr].t:=m;
end;

procedure Tprofiler.CorrectForOverhead;
var i:integer;overheadtime:extended;
begin
overheadtime:=n-rmark[lastmark].t;
for i:=1 to nmarks do with rmark[i] do
    if active then totaltime:=totaltime-overheadtime-residualtime;
end;

function Tprofiler.gettimediff(nr:integer):extended;
begin
  result:=m-rmark[nr].t;
  gettime(nr);
end;

procedure Tprofiler.mark(nr:integer;aactive:boolean);
begin
if rmark[nr].active=aactive then exit;
mmtime;
correctForOverhead;
if aactive then begin
                if(not rmark[nr].active) then with Rmark[nr] do
                begin
                gettime(nr);
                active:=true;
                end;
		end
          else begin
	       if rmark[nr].active then with Rmark[nr] do
               begin
               totaltime:=totaltime+gettimediff(nr);
               Ctime:=totaltime-prevtime;
               prevtime:=totaltime;
               active:=false;
               inc(passes);
               if passes=1 then fastest:=Ctime else
               if Ctime<fastest then fastest:=Ctime;
	       invalidaterect(gridhandle,nil,true);
               end;
               end;
lastmark:=nr; {keep a copy for the overhead time subtraction}
nntime;
 end;

procedure Tprofiler.FormCreate(Sender: TObject);
begin
drawgrid1.ondrawcell:=tablecontent;
drawGrid1.ColWidths[0] := 50;
drawGrid1.ColWidths[1] := 50;
gridhandle:=drawgrid1.handle;
speedbutton1Click(Self);
end;
procedure Tprofiler.calibrateCPU;
var
  t1:dword;
begin
  t1:=gettickcount;
  while t1=gettickcount do;{wait for tickchange}
  mmtime;
  while gettickcount<(t1+400) do;
  nntime;
  CPUclock:=2.5e-6*(n-m);{MHz}
  label1.caption:=Format('clock: %f MHz', [cpuclock]);
end;

procedure Tprofiler.ClearbuttonClick(Sender: TObject);
var i:integer;
begin
for i:=1 to nmarks do with Rmark[i] do
		      begin
                      passes:=0;Ctime:=0;totaltime:=0;fastest:=0;prevtime:=0;
		      active:=false;
                      end;
		      lastmark:=1;
		      invalidaterect(gridhandle,nil,true);
end;

procedure Tprofiler.RadioGroup1Click(Sender: TObject);
begin
invalidaterect(gridhandle,nil,true);
end;

procedure Tprofiler.SpeedButton1Click(Sender: TObject);
var i:integer;
begin
calibrateCPU;
ClearbuttonClick(Self);
residualtime:=0;
for i:=1 to 1000 do begin mark(1,true);mark(1,false);end;
residualtime:=rmark[1].totaltime/1000;
ClearbuttonClick(Self);
end;

procedure Tprofiler.SpeedButton2Click(Sender: TObject);
begin
MessageDlg('Zprofiler 2.2: freeware program timing tool by A.Baars (1998)'
, mtInformation,[mbok], 0);
end;

end.
