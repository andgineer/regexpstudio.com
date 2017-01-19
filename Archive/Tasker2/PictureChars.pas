unit PictureChars;

interface

uses
  windows,
  classes,
  stdCtrls,
  dbctrls;

type
  TSetOfChar = Set of AnsiChar;
const
  //Special symbols to represent various character sets for any particular character.
  chrAny='x';  // Allow any character according to the set definition below
  chrUpper='A'; // Uppercase characters only A..Z
  chrlower='a'; // Lowercase characters only a..z
  chrdigit='9'; // Allow only 0..9 characters
  chrdecimal='0'; //Allow 0..9 and .
  chrCurrency='$';

  chrSpecials: TSetOfChar = [chrAny,chrUpper,chrlower,
                             chrdigit,chrdecimal];


  //Allowed characters in predefined pictures;

  AlphaAny       : TSetOfChar = [#32..#255];
  Digits         : TSetOfChar = ['0'..'9'];
  IntegerChars   : TSetOfChar = ['0'..'9','+','-'];
  FloatChars     : TSetOfChar = ['0'..'9','+','-','.'];
  HexChars       : TSetOfChar = ['0'..'9','A'..'F','a'..'f'];
  BinChars       : TSetOfChar = ['0','1'];
  ScientificChars : TSetOfChar= ['0'..'9','.','+','-','E','e'];

  METACHARS:TSetOfChar=['\','.','^','$','*','+','?','(',')','[',']','{','}'];
// Regular expressions

// character is not a (, 0..9, ) or -
// Characters not matching would not be permitted in string
  RENOTPHONEMASK='[^\(&^0-9&^\)&^-]';
// reAustralian Phone Mask
  REPHONEMASK='\(\d{2,3}\)\d{3,4}-\d{3,4}';
  BLANK='_';


var
  AlphaNumeric   : TSetOfChar = [' ','A'..'Z','a'..'z','0'..'9'];
  AlphaAll       : TSetOfChar = [' '..'~'];
  AlphaUpper     : TSetOfChar = ['A'..'Z'];
  AlphaLower     : TSetOfChar = ['a'..'z'];
  Internationals : TSetofChar;
  CurrencyChars  : TSetOfChar ;

type

  TPictureType=(ptAny,         // #32 to #255
                ptAlphaNumeric,// a to z, A to Z, 0 to 9
                ptUpper,       // A to Z
                ptLower,       // a to z
                ptDigits,      // 0 to 9
                ptInteger,     // 0 to 9, +, -
                ptFloat,       // 0 to 9, +, -, .
                ptCurrency,    // $ 0 to 9 . ,
                ptScientific,  // 0 to 9 . - + E
                ptHexadecimal, // 0..9,A..F
                ptBinary,      // 0,1
                ptProper,      // A to Z,a to z, 0 to 9
                ptCustom);     // specialized picture strings.

implementation

//procedure SetPicture(Value:TPictureType);
//begin
//  if Value=fstrPic then
//    exit;
//  CharCase:=ecNormal;
//  case Value of
//  ptAny:           fCharset:=AlphaAny;
//  ptAlphaNumeric:  fCharset:=AlphaNumeric;
//  ptUpper:
//  begin
//    fCharset:=AlphaUpper;
//    charcase:=ecUpperCase;
//  end;
//  ptLower:
//  begin
//    fCharset:=AlphaLower;
//    charcase:=ecLowerCase;
//  end;
//  ptProper:        fCharset:=AlphaAny;
//  ptDigits:        fCharset:=Digits;
//  ptInteger:       fCharset:=IntegerChars;
//  ptFloat:         fCharset:=FloatChars;
//  ptCurrency:      fCharset:=CurrencyChars;
//  ptScientific:    fCharset:=ScientificChars;
//  ptHexadecimal:   fCharset:=HexChars;
//  ptBinary:        fCharset:=BinChars;
//  ptCustom:        fCharset:=AlphaAny;
//  end; // case
//  fstrPic:=Value;
//end;

procedure InitializeAlphas;
var
  lA:AnsiChar;
begin
    {ask windows what other characters are considered alphas}
  Internationals:=[];
  for lA := #128 to #255 do
    if IsCharAlpha(lA) then
      Internationals := Internationals + [lA];
  AlphaAll:=AlphaAll+Internationals;
  AlphaNumeric:=AlphaNumeric+Internationals;
    {ask windows what other characters are considered UpperCase}
  Internationals:=[];
  for lA := #128 to #255 do
    if IsCharUpper(lA) then
      Internationals := Internationals + [lA];
  AlphaUpper:=AlphaUpper+Internationals;
    {ask windows what other characters are considered LowerCase}
  Internationals:=[];
  for lA := #128 to #255 do
    if IsCharLower(lA) then
      Internationals := Internationals + [lA];
  AlphaLower:=AlphaLower+Internationals;
end;

Initialization
  initializeAlphas;
end.


