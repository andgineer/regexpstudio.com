unit RegExpFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RegExpr, RXCtrls, RXSpin, ComCtrls, EnhListView, Buttons,
  dsgnintf;

type
// This will build two masks
// 1. A complete RE mask that the whole string must match to
//    get past the editing stage.
// 2. A list of sub masks associated with particular sections of the
//    string.  These will be used by the keystroke engine to determine
//    if keystrokes will be accepted or rejected.

  TfrmRegExpressionBuilder = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbResult: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    CharSelect: TRxCheckListBox;
    rxFrom: TRxSpinEdit;
    rxTo: TRxSpinEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Memo1: TMemo;
    btnAdd: TButton;
    edOffset: TEdit;
    edInputString: TEdit;
    edRegExpr: TEdit;
    rxOffset: TRxSpinEdit;
    lstSubMasks: TdfsEnhListView;
    btnClear: TButton;
    BitBtn1: TBitBtn;
    reMask: TEdit;
    btnTest: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rxFromChange(Sender: TObject);
    procedure rxToChange(Sender: TObject);
    procedure rxOffsetChange(Sender: TObject);
    procedure CharSelectClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
  private
    { Private declarations }
    r : TRegExpr;
    procedure Compile;
    procedure ExecIt (AFindNext : boolean);
  public
    { Public declarations }
  end;

var
  frmRegExpressionBuilder: TfrmRegExpressionBuilder;

implementation

uses
  RegExpConst;

{$R *.DFM}

procedure TfrmRegExpressionBuilder.Compile;
 begin
  try
    // r.e. precompilation (then you assign Expression property,
    // TRegExpr automatically compiles the r.e.).
    // Note:
    //   if there are errors in r.e. TRegExpr will raise
    //   exception.

    r.Expression := reMask.Text;

    except on E:Exception do begin // exception during r.e. compilation or execution
      if E is ERegExpr then
       if (E as ERegExpr).CompilerErrorPos > 0 then begin
         // compilation exception - show place of error
         reMask.SetFocus;
         reMask.SelStart := (E as ERegExpr).CompilerErrorPos - 1;
         reMask.SelLength := 1;
        end;
      raise Exception.Create (E.Message); // continue exception processing
     end;
   end;
 end;

procedure TfrmRegExpressionBuilder.ExecIt (AFindNext : boolean);
 var
  i : integer;
  res : boolean;
  off : integer;
  memostr:string;
 begin
  try
    // Assign r.e. to Expression property - it'll be
    // automatically compiled. If any errors occure,
    // ERegExpr will be raised
    Compile;

    // r.e. execution (finding r.e. occurences in input string)
    //
    // There are some examples of r.e. execution technics:
    // 1) Simple case (one r.e., many input strings)
    //      r.Exec (AInputString);
    //  Note
    //   if you don't need r.e. precompilation and only want
    //   to check one input string with one r.e. then you may
    //   use global routine:
    //      ExecRegExpr (ARegularExpression, AInputString);
    // 2) Search next match
    //      if r.Exec (AInputString) then // search first occurence
    //       REPEAT
    //        // loop body
    //       UNTIL not r.ExecNext; // search next occurences
    // 3) Search from any position
    //      r.InputString := AInputString;
    //      r.ExecPos (APositionOffset);

    if AFindNext
     then res := r.ExecNext // search next occurence. raise
                            // exception if no Exec call preceded
     else begin
       off := StrToInt (edOffset.Text); // raise exception if bad Offset
       if off = 1
        then res := r.Exec (edInputString.Text) // search from first position
        else begin // search from off position
          r.InputString := edInputString.Text;
          res := r.ExecPos (off);
         end;
      end;
    if res then begin // r.e. found
       // Show r.e. positions: 0 - whole r.e.,
       // 1 .. SubExprMatchCount - subexpressions.
       memostr := IntToStr (r.MatchPos [0])
        + '-' + IntToStr (r.MatchPos [0] + r.MatchLen [0] - 1);
       memo1.Lines.add(memostr);
       for i := 1 to r.SubExprMatchCount do
        if r.MatchPos [i] > 0
         then memostr := memostr + ', '
           + '\' + IntToStr (i) + ':' + IntToStr (r.MatchPos [i])
           + '-' + IntToStr (r.MatchPos [i] + r.MatchLen [i] - 1);
       memo1.Lines.add(memostr);
       // Mark r.e. in input string
       edInputString.SetFocus;
       edInputString.SelStart := r.MatchPos [0] - 1;
       edInputString.SelLength := r.MatchLen [0];
//       memostr := 'Reg.expr found at '
//        + lblTestResult.Caption;
//       memo1.Lines.add(memostr);
//       lblTestResult.Font.Color := clGreen;
       // Perform substitution - example of fill in template
//       memSubstitutionResult.Text :=
//        r.Substitute (PChar (memSubstitutionTemplate.Text));
      end
     else begin // r.e. not found
       memo1.Lines.add('Regexpr. not found in string.');
       memo1.Lines.add('Substitution is not performed');
      end;
    except on E:Exception do begin // exception during r.e. compilation or execution
      memo1.Lines.add('Error: "' + E.Message + '"');
//      lblTestResult.Font.Color := clRed;
      memo1.Lines.add('Substitution is not performed');
     end;
   end;
 end;


procedure TfrmRegExpressionBuilder.btnAddClick(Sender: TObject);
var
  noffset,
  i:integer;
  strSub,
  strWork:String;
  memostr:string;
  NewItem:TListItem;

begin

//  memo1.lines.Clear;
//  Execit(False);
//  for i:=0 to R.SubExprMatchCount do
//  begin
//    memostr:=inttostr(R.MatchPos[i])+'  '+ inttostr(R.MatchLen[i])+'  '+R.Match[i];
//    memo1.lines.Add(memostr);
//  end;

//  i:=inttostr(
  if lstSubMasks.Items.count>0 then
  begin
    i:=strtoint(lstSubMasks.Items[lstSubMasks.Items.count-1].caption);
    nOffset:=i+strtoint(lstSubMasks.Items[lstSubMasks.Items.count-1].subitems[2]);
  end
  else
    nOffSet:=1;

// first add offset;
  NewItem:=lstSubMasks.Items.Add;

  strWork:=inttostr(nOffset);
  NewItem.Caption:=strWork;

// Now create the submask;

  strSub:='';
  StrWork:='';
  if charselect.checked[0] then
  begin
    strSub:=CharSelect.Items[1]+'-'+CharSelect.Items[CharSelect.Items.count-1];
    strWork:='['+strSub+']';
  end
  else
  begin
    for i:=0 to pred(CharSelect.Items.count) do
    begin
      if CharSelect.Selected[i] then
        strSub:=StrSub+CharSelect.Items[i]
      else
      begin
        if length(strSub)>1 then
        begin
          if length(strwork)>0 then
            strwork:=strwork+',';
          if strSub[1] in MetaChars then
            strWork:=strWork+'\';
          strWork:=StrWork+strSub[1]+'-';
          if strSub[length(strsub)] in MetaChars then
            strWork:=strWork+'\';
          strWork:=strWork+strSub[length(strsub)];
        end; //if
        if Length(strSub)=1 then
        begin
          if length(strwork)>0 then
            strwork:=strwork+',';
          strWork:=strWork+strSub;
        end;  //if
        strSub:='';
      end;  //else
    end;  //for
    strWork:='['+strWork+']';
  end;
  strwork:=strWork+'{'+inttostr(trunc(rxFrom.value))+
           ','+inttostr(trunc(rxTo.Value))+'}';
  NewItem.SubItems.Add(strWork);
  NewItem.SubItems.Add(inttostr(trunc(rxFrom.value)));
  NewItem.SubItems.Add(inttostr(trunc(rxTo.value)));
  reMask.Text:='';
  for i:=0 to lstSubMasks.Items.count-1 do
  begin
    reMask.Text:=reMask.text+ lstSubMasks.Items[i].subitems[0];
  end;
end;

procedure TfrmRegExpressionBuilder.FormCreate(Sender: TObject);
begin
  r := TRegExpr.Create;
end;

procedure TfrmRegExpressionBuilder.rxFromChange(Sender: TObject);
begin
  if (rxFrom.Value>rxTo.Value) or
     (rxTo.Value=0) then
    rxTo.Value:=rxFrom.Value;
    if rxFrom.Value<0 then
      rxFrom.Value:=0;
end;

procedure TfrmRegExpressionBuilder.rxToChange(Sender: TObject);
begin
  if rxFrom.Value>rxTo.Value then
    rxTo.Value:=rxFrom.Value;
  if rxTo.Value<0 then
    rxTo.Value:=0;
end;

procedure TfrmRegExpressionBuilder.rxOffsetChange(Sender: TObject);
begin
  if rxOffset.Value<>0 then
    rxTo.Value:=rxFrom.Value;
end;

procedure TfrmRegExpressionBuilder.CharSelectClick(Sender: TObject);
var
  i:integer;
begin
  if CharSelect.Checked[0] then
  for i:=1 to pred(CharSelect.Items.Count) do
  begin
    CharSelect.Checked[i]:=false;
    CharSelect.Selected[i]:=false;
  end;
  for i:=0 to pred(CharSelect.Items.count) do
  begin
    CharSelect.Checked[i]:=CharSelect.Selected[i];
  end;
end;

procedure TfrmRegExpressionBuilder.btnClearClick(Sender: TObject);
begin
  lstSubMasks.Items.Clear;
  reMask.Text:='';
end;

procedure TfrmRegExpressionBuilder.btnTestClick(Sender: TObject);
begin
  try
    compile;
    lbResult.Caption:='Sweet Success!';
  except
    lbResult.Caption:='Error!';
    raise;
  end;
end;

end.


