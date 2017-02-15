unit REProfilerMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, RETestCases, StdCtrls, StopWatch;

type
  TfmREProfilerMain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
   private
   public
    REs : TRETestCases;
    sw : TStopWatch;
  end;

var
  fmREProfilerMain: TfmREProfilerMain;

implementation
{$R *.DFM}

uses
 RegExpr
 ,mlRegularExpression,
 XMLDoc, XMLIntf, TestREs;

procedure TfmREProfilerMain.FormCreate(Sender: TObject);
 var
  i, k : integer;
  reIdx : integer;
  r : TRegExpr;
//  e : TmlRegularExpression;
  Scanned : Int64;

  RegularExpressions : IXMLRegularExpressionsType;
 begin
  Label1.Caption := IntToStr (CPUClockKHz div 1000);

  RegularExpressions := LoadRegularExpressions ('Tests\TestREs.xml');
  for reIdx := 0 to RegularExpressions.Count do
   with RegularExpressions.RegularExpression [reIdx] do begin

   end;
  sw := TStopWatch.Create;

  REs := TRETestCases.Create;
  REs.LoadFromFile (ExtractFilePath (Application.ExeName) + 'Tests\TestREs.txt');

  Scanned := 0;
  r := TRegExpr.Create;
  for k := 1 to 100 do
   // TRegExpr: *5: 960 ms *7: 3380 ms (790 kBytes/sec)
   // 256Mb: *5: 1000 ms *7: 3740
   // ml: 10 sec
  for i := 0 to REs.Count - 1 do begin
    REs [i].InputStringBodyRepN := 5;
    REs [i].AssignToTRegExpr (r);
    sw.Start (False);
    r.ExecPos;
//     e := TmlRegularExpression.Create (REs [i].Expression, [mfLongestMatch]);
//     if e.Match (REs [i].InputString) = mrNone //, mrFail, mrMatch, mrInsufficient
//      then ;
    sw.Stop;
    REs [i].AssignMatchList (r);
    Scanned := Scanned + r.MatchPos [0] + r.MatchLen [0];
   end;
  r.Free;

  if sw.MicroSecs > 0 then
  Label2.Caption := sw.TimeStr + ', '
   + IntToStr (Scanned * 1000000 div sw.MicroSecs div 1024)
    + ' kBytes/sec (' + IntToStr (Scanned div 1024) + ' kBytes scanned)';

//  Label2.Caption := IntToStr (SizeOf (TVarRec));
//  REs.SaveToFile (ExtractFilePath (Application.ExeName) + '1.txt');
 end;

procedure TfmREProfilerMain.FormDestroy(Sender: TObject);
 begin
  sw.Free;
  REs.Free;
 end;

end.
