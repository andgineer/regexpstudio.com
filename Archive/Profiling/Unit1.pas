unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Psock, NMHttp;

type
  TForm1 = class(TForm)
    BitBtn2: TBitBtn;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    btnReplace: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

uses
 Z_prof,
 mlRegularExpression,
 RegExpr
;



procedure TForm1.FormCreate(Sender: TObject);
 begin
  tzprofiler.create(application.mainform);
  Randomize;
 end;

procedure TForm1.BitBtn2Click(Sender: TObject);
 var
  e : TmlRegularExpression;
  AExpression, InputString : string;
  i : integer;
  r : TRegExpr;
 begin
//   AExpression := '((\.|,)|r)*mp\d';
   AExpression := '^M*(D?C?C?C?|C[DM])(L?X?X?X?|X[LC])(V?I?I?I?|I[VX])$';
//   AExpression := '(ftp|http)://(' + '[_a-z\d\-]+(\.[_a-z\d\-]+)+'
//   + ')((/[ _a-z\d\-\\\.]+)+)*'; // url 0.13/0.07
//   '^[+\-]?\d+(\.\d+)?([eE][+\-]?\d+)?$';
//   AExpression := '[_a-zA-Z\d\-\.]+@[_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+'; // email 0.13/0.07
//   AExpression := '(\+\d *)?(\(\d+\) *)?\d+(-\d*)*'; // phone 0.17/0.05
//   '([IVXCL]{3}-[à-ß][à-ß] *[N¹]? *)?\d{6}';

   InputString := '123mprgtmfwefewrfgerwfq3wff343efr43';
//   InputString := '123.mprgt.mfwefewrfgerwfq3wff343efr43';
//   for i := 0 to 10
//    do InputString := InputString + InputString;

//   InputString := InputString + '123.mprgt.mfwefewrfger.mp4wfq3wff343efr43';
   InputString := 'CLX';//III';
//   InputString := '+7(812) 157-37-52';
//   InputString := 'anso@mailbox.alkor.ru';
//   InputString := 'http://anso.virtualave.net';
   e := TmlRegularExpression.Create (AExpression, [mfLongestMatch]
    { mfCaseInsensitive, mfAllMatches, mfStartOnly,
                                  mfFinishOnly, mfOverlapMatches});
  profile.mark (1, true);
   if e.Match (InputString) = mrNone //, mrFail, mrMatch, mrInsufficient
    then ;
  profile.mark (1, false);

   r := TRegExpr.Create;
   r.Expression := AExpression;
  profile.mark (2, true);
  r.InputString := InputString;
  r.ExecPos;
  profile.mark (2, false);

   for i := 0 to e.MatchCount - 1 do begin
     Label1.Caption := IntToStr (e.MatchStart [i])
      + ' - ' + IntToStr (e.MatchSize [i]);
    end;

   Label2.Caption := IntToStr (r.MatchPos [0])
    + ' - ' + IntToStr (r.MatchLen [0]);
  end;

end.

