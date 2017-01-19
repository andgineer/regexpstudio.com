{$B-}
unit SharConverter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
 var
  inF : file;
  outF : TextFile;
  s : string;
  outOpened : boolean;
  LineN : integer;
 procedure CloseOutFile;
  begin
   if outOpened
    then CloseFile (outF);
  end;
 procedure CreateOutFile (const AFileName : string);
  begin
   CloseOutFile;
   Memo1.Lines.Add (IntToStr (LineN) + ': ' + AFileName);
   AssignFile (outF, AFileName);
   Rewrite (outF);
   outOpened := true;
  end;
 function GetLine : string;
  var
   b : byte;
  begin
   Result := '';
   while not EoF (inF) do begin
     BlockRead (inF, b, 1);
     if b <> $a
      then Result := Result + char (b)
      else BREAK;
    end;
   inc (LineN);
  end;

 begin
  LineN := 0;
  outOpened := false;
  AssignFile (inF, 'D:\Andrey\RegExpr\Spencer99\RegEx.shar');
  Reset (inF, 1);
  while not EoF (inF) do begin
    s := GetLine;
    if length (s) > 0 then begin
      if s [1] <> 'X' then begin
         while not EoF (inF)
          and (length (s) > 0) and (s[1] <> 'X')
          and (copy (s, 1, 4) <> 'echo') do
         s := GetLine;
         if copy (s, 1, 4) = 'echo' then begin
           s := copy (s, 7, MaxInt);
           s := copy (s, 1, pos ('''', s) - 1);
           if pos ('/', s) > 0
            then s := copy (s, 1, pos ('/', s) - 1) + '\'
             + copy (s, pos ('/', s) + 1, MaxInt);
           CreateOutFile ('D:\Andrey\RegExpr\Spencer99\' + s);
           while not EoF (inF) and (s[1] <> 'X')
            do s := GetLine;
           System.Delete (s, 1, 1); 
          end;
        end
       else System.Delete (s, 1, 1);
     end;
    writeln (outF, s);
   end;
  CloseOutFile;
  CloseFile (inF);
 end;

end.
