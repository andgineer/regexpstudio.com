{$B-}
unit TestRE;

{
 Simple test d'expressions régulières

 (c) 1999-2001 Andrey V. Sorokin
  St-Petersburg
  Russia
  anso@mail.ru, anso@usa.net
  http://anso.da.ru
  http://anso.virtualave.net

 Merci à Jon Smith pour les suggestions très pratiques

}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls,
  RegExpr, FileViewer;

type
  TfmTestRE = class(TForm)
    btnClose: TBitBtn;
    grpRegExpr: TGroupBox;
    OpenDialog1: TOpenDialog;
    cbHelpLanguage: TComboBox;
    btnHelp: TSpeedButton;
    lblWWW: TLabel;
    Bevel1: TBevel;
    PageControl1: TPageControl;
    tabExpression: TTabSheet;
    tabSubstitute: TTabSheet;
    pnlSubstitutionComment: TPanel;
    lblSubstitutionComment: TLabel;
    tabReplace: TTabSheet;
    pnlReplaceComment: TPanel;
    lblReplaceComment: TLabel;
    tabSplit: TTabSheet;
    btnSplit: TBitBtn;
    memSplitResult: TMemo;
    pnlSplitComment: TPanel;
    lblSplitComment: TLabel;
    lblSplitResult: TLabel;
    pnlTopExamples: TPanel;
    lblExamples: TLabel;
    btnTemplatePhonePiter: TSpeedButton;
    btnTemplatePhone: TSpeedButton;
    btnTemplatePassport: TSpeedButton;
    btnTemplateMail: TSpeedButton;
    btnTemplateInteger: TSpeedButton;
    btnTemplateRealNumber: TSpeedButton;
    btnTemplateRomanNumber: TSpeedButton;
    btnTemplateURL: TSpeedButton;
    btnSaintPetersburg: TSpeedButton;
    btnBackRef: TSpeedButton;
    btnNonGreedy: TSpeedButton;
    pnlReplaceTemplate: TPanel;
    lblReplaceString: TLabel;
    edReplaceString: TMemo;
    Splitter1: TSplitter;
    pnlReplaceResult: TPanel;
    lblReplaceResult: TLabel;
    memReplaceResult: TMemo;
    btnReplace: TBitBtn;
    pnlSubstitutionTemplate: TPanel;
    lblSubstitutionTemplate: TLabel;
    memSubstitutionTemplate: TMemo;
    Splitter2: TSplitter;
    pnlRegExpr: TPanel;
    gbModifiers: TGroupBox;
    chkModifierI: TCheckBox;
    chkModifierR: TCheckBox;
    chkModifierS: TCheckBox;
    chkModifierG: TCheckBox;
    chkModifierM: TCheckBox;
    lblRegExpr: TLabel;
    lblRegExprUnbalancedBrackets: TLabel;
    edRegExpr: TMemo;
    edSubExprs: TLabel;
    cbSubExprs: TComboBox;
    btnViewPCode: TSpeedButton;
    Splitter3: TSplitter;
    pnlSubstitutionResult: TPanel;
    lblSubstitutionResult: TLabel;
    memSubstitutionResult: TMemo;
    pnlInputStrings: TPanel;
    lblInputString: TLabel;
    edInputString: TMemo;
    lblInputStringPos: TLabel;
    edInputStringPos: TEdit;
    btnTestString: TBitBtn;
    btnExecNext: TBitBtn;
    btnFindRegExprInFile: TBitBtn;
    cbSubStrs: TComboBox;
    lblTestResult: TLabel;
    chkModifierX: TCheckBox;
    procedure btnViewPCodeClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnTestStringClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnTemplatePhonePiterClick(Sender: TObject);
    procedure btnTemplatePhoneClick(Sender: TObject);
    procedure btnTemplatePassportClick(Sender: TObject);
    procedure btnTemplateMailClick(Sender: TObject);
    procedure btnTemplateIntegerClick(Sender: TObject);
    procedure btnTemplateRealNumberClick(Sender: TObject);
    procedure btnTemplateURLClick(Sender: TObject);
    procedure btnFindRegExprInFileClick(Sender: TObject);
    procedure btnExecNextClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure btnSplitClick(Sender: TObject);
    procedure chkModifierIClick(Sender: TObject);
    procedure btnSaintPetersburgClick(Sender: TObject);
    procedure btnTemplateRomanNumberClick(Sender: TObject);
    procedure chkModifierSClick(Sender: TObject);
    procedure chkModifierRClick(Sender: TObject);
    procedure btnBackRefClick(Sender: TObject);
    procedure chkModifierGClick(Sender: TObject);
    procedure edRegExprChange(Sender: TObject);
    procedure cbSubExprsClick(Sender: TObject);
    procedure edInputStringClick(Sender: TObject);
    procedure edInputStringKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edInputStringMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edInputStringMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure edRegExprClick(Sender: TObject);
    procedure lblRegExprUnbalancedBracketsDblClick(Sender: TObject);
    procedure edRegExprKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbSubStrsClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure cbHelpLanguageClick(Sender: TObject);
    procedure chkModifierMClick(Sender: TObject);
    procedure btnNonGreedyClick(Sender: TObject);
    procedure lblWWWClick(Sender: TObject);
    procedure chkModifierXClick(Sender: TObject);
   private
    r : TRegExpr;
    procedure Compile;
    procedure ExecIt (AFindNext : boolean);
    procedure InputStringPosIsChanged;
    procedure RegExprChanged (AShowErrorPos : boolean = false);
    procedure RegExprPosIsChanged;
    procedure SubexprSelected;
    procedure SubStringSelected;
    procedure HelpLanguageSelected;
    procedure GoToRegExprHomePage;
    procedure UpdateModifiers;
   public
    procedure HighlightREInFileViewer (AFileViewer : TfmFileViewer);
  end;

var
  fmTestRE: TfmTestRE;

implementation
{$R *.DFM}

uses
 ShellAPI, // ShellExecute
 PCode;

procedure TfmTestRE.FormCreate(Sender: TObject);
 var
  ExeFolder : string;
 begin

  r := TRegExpr.Create;

  // choisir le fichier d'aide, premièrement essayer les versions non française,
  // si aucune trouvée, le français est choisi.
  ExeFolder := ExtractFilePath (Application.ExeName);
  if FileExists (ExeFolder + 'RegExpRu.hlp')
   then cbHelpLanguage.ItemIndex := 0
  else if FileExists (ExeFolder + 'RegExpBG.hlp')
   then cbHelpLanguage.ItemIndex := 2
  else if FileExists (ExeFolder + 'RegExpG.hlp')
   then cbHelpLanguage.ItemIndex := 3
  else if FileExists (ExeFolder + 'RegExpE.hlp')
   then cbHelpLanguage.ItemIndex := 1
  else
   cbHelpLanguage.ItemIndex := 4;
  HelpLanguageSelected;

  UpdateModifiers;

  btnTemplateMail.Click; // Choisi le test de l'e.r. et modifie les éléments graphiques
  InputStringPosIsChanged;
 end;

procedure TfmTestRE.FormDestroy(Sender: TObject);
 begin
  if Assigned (r)
   then r.Free;
 end;

procedure TfmTestRE.UpdateModifiers;
 begin
  // affiche les valeurs en vigeur des modificateurs
  chkModifierI.Checked := r.ModifierI;
  chkModifierR.Checked := r.ModifierR;
  chkModifierS.Checked := r.ModifierS;
  chkModifierG.Checked := r.ModifierG;
  chkModifierM.Checked := r.ModifierM;
  chkModifierX.Checked := r.ModifierX;
 end;

procedure TfmTestRE.btnViewPCodeClick(Sender: TObject);
 begin
  Compile;
  with TfmPseudoCodeViewer.Create (Application) do begin
    edSource.Text := r.Expression;
    Memo1.Lines.Text := r.Dump;
    ShowModal;
   end;
 end;

procedure TfmTestRE.btnCloseClick(Sender: TObject);
 begin
  Close;
 end;

procedure TfmTestRE.Compile;
 begin
  try
    // Précompilation de l'e.r. (vous appliquez l'expression
    // correctement ensuite TRegExpr compile automatiquement l'e.r.
    // Note:
    //   s'il y a des erreurs dans l'e.r. TRegExpr va lever une
    //   exception.

    r.Expression := edRegExpr.Text;

    except on E:Exception do begin // exception durant la compilation ou l'exécution de l'e.r.
      if E is ERegExpr then
       if (E as ERegExpr).CompilerErrorPos > 0 then begin
         // exception de compilation - affiche l'emplacement de l'erreur
         edRegExpr.SetFocus;
         edRegExpr.SelStart := (E as ERegExpr).CompilerErrorPos - 1;
         edRegExpr.SelLength := 1;
        end;
      raise Exception.Create (E.Message); // continu la procédure d'exception
     end;
   end;
 end;

procedure TfmTestRE.ExecIt (AFindNext : boolean);
 var
  i : integer;
  res : boolean;
  s : string;
 begin
  try
    // Assigne la propriété à l'e.r. - elle sera
    // automatiquement compilée. Si une erreur survient,
    // une exception dans ERegExpr sera levée
    Compile;

    // Exécution de l'e.r. (trouvant les occurences de l'e.r. dans la chaîne
    // de caractères)
    //
    // Ici des exemples techniques de l'exécution de l'e.r.:
    // 1) Simple cas (une e.r., plusieurs lignes d'entrée)
    //      r.Exec (AInputString);
    //  Noter
    //   Si vous n'avez pas besoin de la compilation de l'e.r. et voulez
    //   seulement vérifier la chaîne d'entrée à une e.r. vous pouvez utiliser
    //   utiliser une routine globale:
    //      ExecRegExpr (ARegularExpression, AInputString);
    // 2) Chercher l'occurence suivante
    //      if r.Exec (AInputString) then // Cherche la 1ière occurence
    //       REPEAT
    //        // loop body
    //       UNTIL not r.ExecNext; // Cherche les occurences suivantes
    // 3) Chercher à partir de n'importe quelle position
    //      r.InputString := AInputString;
    //      r.ExecPos (APositionOffset);

    if AFindNext
     then res := r.ExecNext // cherche prochaine occurence. Lève
                            // une exception si l'appel à Exec n'as
                            // pas été fait.
     else res := r.Exec (edInputString.Text); // Cherche à partir de la
                                              // première position
    if res then begin // E.r. trouvé
       // Affiche les positions de l'e.r.: 0 - e.r. complète,
       // 1 .. SubExprMatchCount - sous-expression.
       lblTestResult.Caption := 'Expression Trouvée:';
       lblTestResult.Font.Color := clGreen;

       cbSubStrs.Items.Clear;
       for i := 0 to r.SubExprMatchCount do begin
          s := '$' + IntToStr (i);
          if r.MatchPos [i] > 0
           then s := s + ' [' + IntToStr (r.MatchPos [i]) + ' - '
             + IntToStr (r.MatchPos [i] + r.MatchLen [i] - 1) + ']: '
             + r.Match [i]
           else s := s + ' pas trouvé!';
          cbSubStrs.Items.AddObject (s, TObject (r.MatchPos [i]
           + (r.MatchLen [i] ShL 16)));
         end;
       cbSubStrs.Visible := True;
       cbSubStrs.ItemIndex := 0;
       SubStringSelected;

       // Perform la substitution - example de remplissage dans la gabarit
       memSubstitutionResult.Text :=
        r.Substitute (PChar (memSubstitutionTemplate.Text));
      end
     else begin // e.r. pas trouvée
       cbSubStrs.Visible := False;
       lblTestResult.Caption := 'Expression pas trouvée.';
       lblTestResult.Font.Color := clPurple;
       memSubstitutionResult.Text := 'Substitution pas appliquée';
      end;
    except on E:Exception do begin // exception durant la compilation ou
                                   // exécution de l'e.r.
      cbSubStrs.Visible := False;
      lblTestResult.Caption := 'Erreur: "' + E.Message + '"';
      lblTestResult.Font.Color := clRed;
      memSubstitutionResult.Text := 'Substutition pas appliquée';
     end;
   end;
 end;

procedure TfmTestRE.btnTestStringClick(Sender: TObject);
 begin
  ExecIt (false);
 end;

procedure TfmTestRE.btnExecNextClick(Sender: TObject);
 begin
  ExecIt (true);
 end;

procedure TfmTestRE.btnTemplatePhonePiterClick(Sender: TObject);
 begin
  edRegExpr.Text :=
   '\d{3}-?\d\d-?\d\d';
  edInputString.Text :=
   'Le numéro de téléphone de AlkorSoft (projet Payer Comptant) est 329-4469 (à St-Petersburg)';
  memSubstitutionTemplate.Text :=
   'Systême de paiement! E-cash est réel ! Numéro de téléphone $&, payer comptant.';
  r.ModifierStr := '-x';
  UpdateModifiers;
 end;

procedure TfmTestRE.btnTemplatePhoneClick(Sender: TObject);
 begin
  edRegExpr.Text :=
   '(\+\d *)?(\(\d+\) *)?\d+(-\d*)*';
  edInputString.Text :=
   'le numéro de téléphone longue distance de AlkorSoft (Payer Comptant) est +7(812) 329-44-69';
  memSubstitutionTemplate.Text :=
   'Si vous appeler à partir de l''extérieur de Saint-Petersburg (indicatif régional $1, indicatif de ville $2), utiliser $& pour appeler.';
  r.ModifierStr := '-x';
  UpdateModifiers;
 end;

procedure TfmTestRE.btnTemplatePassportClick(Sender: TObject);
 begin
  edRegExpr.Text :=
   '([IVXCL]{3}-[à-ß][à-ß] *[N¹]? *)?\d{6}';
  edInputString.Text :=
   'Exemple de numéro de passeport russe: IVX-ÙÀ 123456';
  memSubstitutionTemplate.Text :=
   'Le numéro est: $&';
  r.ModifierStr := '-x';
  UpdateModifiers;
 end;

procedure TfmTestRE.btnTemplateMailClick(Sender: TObject);
 begin
  edRegExpr.Text :=
   '[_a-zA-Z\d\-\.]+@[_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+';
  edInputString.Text :=
   'Mes adresse e-mails sont anso@mail.ru et anso@usa.net';
  memSubstitutionTemplate.Text :=
   'SVP, envoyer toutes suggestions et erreur de programme à'
   + ' $& (Andrey Sorokin).';
  r.ModifierStr := '-x';
  UpdateModifiers;
 end;


procedure TfmTestRE.btnTemplateIntegerClick(Sender: TObject);
 begin
  edRegExpr.Text :=
     '# enlever ''^'' si quelque chose précère le numéro,'#$d#$a
   + '# et ''$'' si quelque chose suit'#$d#$a
   + '^(?# début de ligne BOL)[+\-]?\d+$(?# Fin de ligne EOL)';
  edInputString.Text :=
   'Voici le numéro 123. quelque chose après le numéro.';
  memSubstitutionTemplate.Text :=
   'l''e.r. au-dessus s''attend à seulement des chiffres dans la chaîne,'#$d#$a
   + 'parce que les symboles du départ et de fin de la chaîne sont (''^'' et ''$'').'#$d#$a
   + 'Aussi, vous devez enlever tout les symboles qui ne sont pas des chiffres dans'#$d#$a
   + 'la chaîne d''entrée. Ou enlever les symboles ''^'' et ''$'' dans l''e.r.';
  r.ModifierStr := 'x';
  UpdateModifiers;
 end;

procedure TfmTestRE.btnTemplateRealNumberClick(Sender: TObject);
 begin
  edRegExpr.Text :=
   '^[+\-]?\d+(\.\d+)?([eE][+\-]?\d+)?$';
  edInputString.Text :=
   'Enlever ceci123.0e6et ceci';
  memSubstitutionTemplate.Text :=
   'l''e.r. au dessus vérifie si c''est le début et la fin de la chaîne'
   + ' (symboles ''^'' et ''$'' dans l''e.r.).'#$d#$a
   + 'Aussi, vous devez enlever ces symboles pour que l''e.r. fonctionne. Ou'
   + ' effacer tous les symboles avant et après le nombre dans'
   + ' la chaîne d''entrée.';
  r.ModifierStr := '-x';
  UpdateModifiers;
 end;

procedure TfmTestRE.btnTemplateURLClick(Sender: TObject);
 begin
  edRegExpr.Text :=
     '(?i)                          # we need caseInsensitive mode'#$d#$a
   + '(FTP|HTTP)://                 # protocol'#$d#$a
   + '([_a-z\d\-]+(\.[_a-z\d\-]+)+) # TCP addr'#$d#$a
   + '((/[ _a-z\d\-\\\.]+)+)*       # unix path';
  edInputString.Text :=
   'Bienvenue à ma page web http://anso.da.ru.'#$d#$a'E-cash http://www.paycash.ru ou http://195.239.62.97/default.htm!';
  memSubstitutionTemplate.Text :=
   'Le protocole est $1'#$d#$a
   + 'L''adresse est $2'#$d#$a
   + 'Le nom URL au complet du site est $&.';
  r.ModifierStr := 'xis-m';
  UpdateModifiers;
 end;

procedure TfmTestRE.btnSaintPetersburgClick(Sender: TObject);
 begin
  edRegExpr.Text :=
     '# Placer le modificateur (?i) avant la sous-expression et'#$d#$a
   + '# l''expression va concorder avec the expression avec la première'#$d#$a
   + '# occurence dans l''exemple'#$d#$a
   + '((?i)Saint-)?Petersburg';
  edInputString.Text :=
   'Bienvenue à petersburg! Saint-Petersburg est une merveilleuse ville'#$d#$a
   + ' - visionner mes photos à mon site web http://anso.da.ru';
  memSubstitutionTemplate.Text := 'Le nom de la ville est $&.';
  r.ModifierStr := 'x-i';
  UpdateModifiers;
 end;

procedure TfmTestRE.btnTemplateRomanNumberClick(Sender: TObject);
 begin
  edRegExpr.Text := '^(?i)M*(D?C{0,3}|C[DM])(L?X{0,3}|X[LC])(V?I{0,3}|I[VX])$';
  edInputString.Text :=
   'MCMXCIX';
  memSubstitutionTemplate.Text := '1999 est $& en chiffres romain.';
  r.ModifierStr := '-x';
  UpdateModifiers;
 end;

procedure TfmTestRE.btnBackRefClick(Sender: TObject);
 begin
  edRegExpr.Text := '(?i)<font size=([''"]?)([+-]?\d+)\1>';
  edInputString.Text :=
   '<font size="+1"> big </font> <font size=1> very small</font>';
  memSubstitutionTemplate.Text := 'font size = $2 (extracted from tag: "$&").';
  r.ModifierStr := '-x';
  UpdateModifiers;
 end;

procedure TfmTestRE.btnNonGreedyClick(Sender: TObject);
 begin
  edRegExpr.Text := '<script([^>]*?)>(.*?)</script>';
  edInputString.Text :=
     '<script param1>Script1</script>'#$d#$a
   + '<script param2>'#$d#$a
   + '  Script2, sera intégré avec Script1'#$d#$a
   + '  if replace "*?" with "*"!'#$d#$a
   + '</script>';
  memSubstitutionTemplate.Text := 'Block de Script:'#$d#$a'"$&"'#$d#$a#$d#$a
  +'Paramêtres: "$1"'#$d#$a'Body: "$2"';
  r.ModifierStr := 's-x';
  UpdateModifiers;
 end;

procedure TfmTestRE.HighlightREInFileViewer (AFileViewer : TfmFileViewer);
 begin
  with AFileViewer do begin
    RichEdit1.SelectAll;
    RichEdit1.SelAttributes.Color := clBlack;
    r.Expression := edRegExpr.Text;
    if r.Exec (RichEdit1.Lines.Text) then
      REPEAT
       RichEdit1.SelStart := r.MatchPos [0] - 1;
       RichEdit1.SelLength := r.MatchLen [0];
       RichEdit1.SelAttributes.Color := clRed;
      UNTIL not r.ExecNext;
    RichEdit1.SelLength := 0;
    lblRegExpr.Caption := r.Expression;
   end;
 end;

procedure TfmTestRE.btnFindRegExprInFileClick(Sender: TObject);
 var
  FV : TfmFileViewer;
 begin
  if OpenDialog1.Execute then begin
    FV := TfmFileViewer.Create (Application);
    with FV do begin
      Caption := Caption + ' - ' + OpenDialog1.FileName;
      RichEdit1.Lines.LoadFromFile (OpenDialog1.FileName);
      Show;
     end;
    HighlightREInFileViewer (FV);
   end;
 end;


procedure TfmTestRE.btnReplaceClick(Sender: TObject);
 begin
  Compile;
  memReplaceResult.Text := r.Replace (edInputString.Text,
   edReplaceString.Text);
 end;

procedure TfmTestRE.btnSplitClick(Sender: TObject);
 begin
  Compile;
  memSplitResult.Lines.Clear;
  r.Split (edInputString.Text, memSplitResult.Lines);
 end;

procedure TfmTestRE.chkModifierIClick(Sender: TObject);
 begin
  r.ModifierI := chkModifierI.Checked;
  // Vous pouvez aussi utiliser
  //   r.ModifierStr := 'i';
  // ou
  //   r.ModifierStr := '-i';
 end;

procedure TfmTestRE.chkModifierRClick(Sender: TObject);
 begin
  r.ModifierR := chkModifierR.Checked;
 end;

procedure TfmTestRE.chkModifierSClick(Sender: TObject);
 begin
  r.ModifierS := chkModifierS.Checked;
 end;

procedure TfmTestRE.chkModifierGClick(Sender: TObject);
 begin
  r.ModifierG := chkModifierG.Checked;
 end;

procedure TfmTestRE.chkModifierMClick(Sender: TObject);
 begin
  r.ModifierM := chkModifierM.Checked;
 end;

procedure TfmTestRE.chkModifierXClick(Sender: TObject);
 begin
  r.ModifierX := chkModifierX.Checked;
 end;

procedure TfmTestRE.InputStringPosIsChanged;
 begin
  if edInputString.SelLength <= 0
   then edInputStringPos.Text := IntToStr (edInputString.SelStart + 1)
   else edInputStringPos.Text := IntToStr (edInputString.SelStart + 1)
      + ' - ' + IntToStr (edInputString.SelStart + edInputString.SelLength);
 end;

procedure TfmTestRE.RegExprChanged (AShowErrorPos : boolean = false);
 var
  i : integer;
  n : integer;
  s : string;
 begin
  n := RegExprSubExpressions (edRegExpr.Text, cbSubExprs.Items);
  case n of //###0.942
    0: lblRegExprUnbalancedBrackets.Caption := ''; // Pas d'erreurs
   -1: lblRegExprUnbalancedBrackets.Caption := 'Pas Assez de ")"';
    else begin
      if n < 0 then begin
         s := 'Pas trouvé "]" pour "["';
         n := Abs (n) - 1;
        end
       else s := ' ")" non attendu';
      if AShowErrorPos then begin
         s := s + ' at pos ' + IntToStr (n);
         edRegExpr.SetFocus;
         edRegExpr.SelStart := n - 1;
         edRegExpr.SelLength := 1;
        end
       else s := s + '. Double-clicquer ici pour info!';
      lblRegExprUnbalancedBrackets.Caption := s;
     end;
   end;
  with cbSubExprs.Items do
   for i := 0 to Count - 1 do
    Strings [i] := '$' + IntToStr (i) + ': ' + Strings [i];

  RegExprPosIsChanged;
 end;

procedure TfmTestRE.RegExprPosIsChanged;
 var
  i : integer;
  CurrentPos : integer;
  SEStart, SELen : integer;
  MinSEIdx : integer;
  MinSELen : integer;
 begin
  MinSEIdx := -1;
  MinSELen := MaxInt;
  CurrentPos := edRegExpr.SelStart + 1;
  with cbSubExprs.Items do begin
    for i := 0 to Count - 1 do begin
      SEStart := integer (Objects [i]) and $FFFF;
      SELen := (integer (Objects [i]) ShR 16) and $FFFF;
      if (SEStart <= CurrentPos) and (SEStart + SELen > CurrentPos)
        and (MinSELen > SELen)
       then begin
         MinSEIdx := i;
         MinSELen := SELen;
        end;
     end;
    if (MinSEIdx >= 0) and (MinSEIdx < Count)
     then cbSubExprs.ItemIndex := MinSEIdx;
   end;
 end;

procedure TfmTestRE.SubexprSelected;
 var
  n : integer;
 begin
  if cbSubExprs.ItemIndex < cbSubExprs.Items.Count then begin
    n := integer (cbSubExprs.Items.Objects [cbSubExprs.ItemIndex]);
    edRegExpr.SetFocus;
    edRegExpr.SelStart := n and $FFFF - 1;
    edRegExpr.SelLength := (n ShR 16) and $FFFF;
   end;
 end;

procedure TfmTestRE.SubStringSelected;
 var
  n : integer;
 begin
  if cbSubStrs.ItemIndex < cbSubStrs.Items.Count then begin
    n := integer (cbSubStrs.Items.Objects [cbSubStrs.ItemIndex]);
    edInputString.SetFocus;
    edInputString.SelStart := n and $FFFF - 1;
    edInputString.SelLength := (n ShR 16) and $FFFF;
    InputStringPosIsChanged;
   end;
 end;

procedure TfmTestRE.edRegExprChange(Sender: TObject);
 begin
  RegExprChanged;
 end;

procedure TfmTestRE.cbSubExprsClick(Sender: TObject);
 begin
  SubexprSelected;
 end;

procedure TfmTestRE.edInputStringClick(Sender: TObject);
 begin
  InputStringPosIsChanged;
 end;

procedure TfmTestRE.edInputStringKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
 begin
  InputStringPosIsChanged;
 end;

procedure TfmTestRE.edInputStringMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
 begin
  InputStringPosIsChanged;
 end;

procedure TfmTestRE.edInputStringMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
 begin
  InputStringPosIsChanged;
 end;

procedure TfmTestRE.edRegExprClick(Sender: TObject);
 begin
  RegExprPosIsChanged;
 end;

procedure TfmTestRE.lblRegExprUnbalancedBracketsDblClick(Sender: TObject);
 begin
  RegExprChanged (True);
 end;

procedure TfmTestRE.edRegExprKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
 begin
  RegExprPosIsChanged;
 end;

procedure TfmTestRE.cbSubStrsClick(Sender: TObject);
 begin
  SubStringSelected;
 end;

procedure TfmTestRE.GoToRegExprHomePage;
 var
  zFileName, zParams, zDir: array [0 .. MAX_PATH] of Char;
 begin
  ShellExecute (
    Application.MainForm.Handle,
    nil,
    StrPCopy (zFileName, 'http://anso.virtualave.net/'),
    StrPCopy (zParams, ''),
    StrPCopy (zDir, ''), SW_SHOWNOACTIVATE);
 end;

procedure TfmTestRE.HelpLanguageSelected;
 var
  ExeFolder : string;
 begin
  ExeFolder := ExtractFilePath (Application.ExeName);
  case cbHelpLanguage.ItemIndex of
    0: Application.HelpFile := ExeFolder + 'RegExpRu.hlp';
    1: Application.HelpFile := ExeFolder + 'RegExpE.hlp';
    2: Application.HelpFile := ExeFolder + 'RegExpBG.hlp';
    3: Application.HelpFile := ExeFolder + 'RegExpG.hlp';
    4: Application.HelpFile := ExeFolder + 'RegExpF.hlp';
   end;
 end;

procedure TfmTestRE.btnHelpClick(Sender: TObject);
 begin
  HelpLanguageSelected;
  if not FileExists (Application.HelpFile) then begin
    case Application.MessageBox (
     PChar ('La langue choisie pour le fichier d''aide n''as pas été trouvé'
     + ' dans "' + ExtractFilePath (Application.HelpFile) + '".'#$d#$a#$d#$a
     + 'Choisir OUI si vous voulez aller à mon site Web pour l''obtenir,'
     + ' ou choisir NON s''il est stocké dans un répertoire différent,'
     + ' ou choisir ANNULER pour annuler l''action.'),
     PChar ('Incapable de trouver le fichier d''aide "' + Application.HelpFile + '"'),
     MB_YESNOCANCEL or MB_ICONQUESTION) of
      IDYES: begin
        GoToRegExprHomePage;
        EXIT;
       end;
      IDNO:; // juste aller à la fonction d'aide de windows - il
             // demandera à l'utilisateur le chemin.
      else EXIT; // doit-être annuler ou erreur en affichant le message
                 // dans une boîte.
     end;
   end;
  Application.HelpCommand (HELP_FINDER, 0);
 end;

procedure TfmTestRE.cbHelpLanguageClick(Sender: TObject);
 begin
  HelpLanguageSelected;
 end;

procedure TfmTestRE.lblWWWClick(Sender: TObject);
 begin
  GoToRegExprHomePage;
 end;


end.

