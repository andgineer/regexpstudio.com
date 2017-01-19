unit RegExpConst;

interface

type
  CharSet=Set of Char;

const
  MetaChars:CharSet=['.','^','$','*','+','?','(',')','[',']','{','}'];
// Regular expressions

// character is not a (, 0..9, ) or -
// Characters not matching would not be permitted in string
  reNotPhoneMask='[^\(&^0-9&^\)&^-]';
// reAustralian Phone Mask
  rePhoneMask='\(\d{2,3}\)\d{3,4}-\d{3,4}';

type
  TRegExpDetails=Class
  private
    fOffset:word;
    fExpression:String;
    fminChars:word;
    fmaxChars:word;
    procedure SetOffset(Value:word);
    procedure SetMinChars(Value:word);
    procedure SetMaxChars(Value:word);
  published
    property Expression:String read fExpression write fExpression;
    property Offset:word read fOffset write SetOffset;
    property MinChars:word read fMinChars write SetMinChars;
    property MaxChars:word read fMaxChars write SetMaxChars;
  end;

Var
  reTimeMask,
  reDateMask,
  reMoneyMask : String;

implementation

procedure TRegExpDetails.SetOffset(Value:word);
begin
  if (Value<>0) and
     (fMinchars<>fMaxChars) then
    fMaxChars:=fMinChars;
  fOffSet:=Value;
end;

procedure TRegExpDetails.SetMinChars(Value:word);
begin
  if (Value<=fMaxChars) then
    fMinChars:=Value;
end;

procedure TRegExpDetails.SetMaxChars(Value:word);
begin
  if (Value>=fMinChars) then
    fMaxChars:=Value;
end;

end.



