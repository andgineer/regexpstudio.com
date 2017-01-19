{$B-}
unit RETestCases;

{
 Container classes for
 regular expressions test cases.

 Stores regular expression, modifiers, input
 examples (with exec results) and so on.

 (c) 2002 Andrey V. Sorokin
  St-Petersburg, Russia
  anso@mail.ru, anso@paycash.ru
  http://anso.virtualave.net
  http://anso.da.ru
}

interface

uses
 Classes,
 RegExpr,
 tynList;

type
 TMatchRec = packed record
   StartPos : integer;
   EndPos : integer;
  end;

 TRETestCase = class (TtynListItem)
   private
    fName : string;
    fComment : string;
    fDescription : string;
    fExpression : RegExprString;
    fInputStringBeg, fInputStringBody, fInputStringEnd : RegExprString;
    fInputStringBodyRepN : integer;
    fInputFileName : string;
    fModifierStr : string;
    fSubstitutionTemplate : RegExprString;
    fString4Replace : RegExprString;
    fMatchList : array of TMatchRec;

    function GetInputString : RegExprString;
    procedure SetInputString (AInputString : RegExprString);
    procedure SetInputFileName (AInputFileName : string);

    function GetSubExprMatchCount : integer;
    function GetMatchPos (Idx : integer) : integer;
    function GetMatchLen (Idx : integer) : integer;

    function GetMatchList : string;
    procedure SetMatchList (AStr : string);

   public
    constructor Create;
    destructor Destroy; override;

   published
    // I use RTTI to store fields into ini-file
    property Name : string read fName;
    property Comment : string read fComment;
    property Description : string read fDescription;
    property Expression : RegExprString read fExpression;
    property InputString : RegExprString read GetInputString write SetInputString;
    property InputFileName : string read fInputFileName write SetInputFileName;
    property ModifierStr : string read fModifierStr;

    property SubstitutionTemplate : RegExprString read fSubstitutionTemplate;
    property String4Replace : RegExprString read fString4Replace;

    property MatchList : string read GetMatchList write SetMatchList;

   public
    // --- result of Exec
    property SubExprMatchCount : integer read GetSubExprMatchCount;
    property MatchPos [Idx : integer] : integer read GetMatchPos;
    property MatchLen [Idx : integer] : integer read GetMatchLen;

    procedure AssignToTRegExpr (ARegExpr : TRegExpr);
    // Assignes values from the test case to TRegExpr object

    procedure AssignMatchList (ARegExpr : TRegExpr);
    // Assign Exec results (MatchPos etc) from the ARegExpr

  end;

 TRETestCases = class (TtynList)
   private
    fIniFileName : string;
    function GetItem (AIdx : integer) : TRETestCase;
   public
    constructor Create;
    destructor Destroy; override;

    property Items [AIdx : integer] : TRETestCase read GetItem;
     DEFAULT;
    procedure Clear; override;
    function IndexByName (const AName : string) : integer;

    procedure LoadFromFile (const AFileName : string);
    procedure SaveToFile (const AFileName : string);
  end;


implementation

uses
 SysUtils;


{====================== Helper stuff =========================}

const
 // Section and keys names for storing in ini-file
 rtkSectionNamePrefix = 're_';
 rtkSectionNamePrefixLength = length (rtkSectionNamePrefix);
 rtkDescription = 'Description';
 rtkComment = 'Comment';
 rtkExpression = 'Expression';
 rtkInputStringBeg = 'InputStringBeg';
 rtkInputStringBody = 'InputStringBody';
 rtkInputStringEnd = 'InputStringEnd';
 rtkInputStringBodyRepN = 'InputStringBodyRepN';
 rtkInputFileName = 'InputFileName';
 rtkModifierStr = 'ModifierStr';
 rtkSubstitutionTemplate = 'SubstitutionTemplate';
 rtkString4Replace = 'String4Replace';
 rtkMatchList = 'MatchList';

 // delimiters inside MatchList:
 REMatchDelim = ','; // between subexpressions !!! now is 'hard-coded' (used TStrings.CommaText)
 REPosDelim   = '-'; // between positions
 REListBlanks = [' ', #9]; // allowed inside 'blank' chars
 // for example: MatchList='1-10, 2-3' - r.e. match substring
 // from 1 to 10 character of input string and first
 // subexpression match from 2 to 3 characters of input string.


{====================== TRETestCase ==========================}

constructor TRETestCase.Create;
 begin
  inherited;
 end; { of constructor TRETestCase.Create
--------------------------------------------------------------}

destructor TRETestCase.Destroy;
 begin
  inherited;
 end; { of destructor TRETestCase.Destroy
--------------------------------------------------------------}

function TRETestCase.GetInputString : RegExprString;
 var
  i : integer;
  Stream : TFileStream;
 begin
  if (length (fInputFileName) > 0) then begin
     Stream := TFileStream.Create (fInputFileName, fmOpenRead or fmShareDenyWrite);
     try
        if Stream.Size > 0 then begin
           SetString (Result, nil, Stream.Size);
           Stream.Read (PChar (Result)^, Stream.Size);
          end
         else Result := '';
       finally Stream.Free;
      end;
    end
  else if (fInputStringBodyRepN > 0)
          and (length (fInputStringBody) > 0) then begin
     Result := fInputStringBody;
     for i := 1 to fInputStringBodyRepN
      do Result := Result + Result;
     Result := fInputStringBeg + Result + fInputStringEnd;
    end
   else Result := fInputStringBeg + fInputStringBody + fInputStringEnd;
 end; { of function TRETestCase.GetInputString
--------------------------------------------------------------}

procedure TRETestCase.SetInputString (AInputString : RegExprString);
 begin
  fInputFileName := '';
  fInputStringBeg := '';
  fInputStringBody := AInputString;
  fInputStringBodyRepN := 0;
  fInputStringEnd := '';
 end; { of procedure TRETestCase.SetInputString
--------------------------------------------------------------}

procedure TRETestCase.SetInputFileName (AInputFileName : string);
 begin
  fInputFileName := AInputFileName;
  fInputStringBeg := '';
  fInputStringBody := '';
  fInputStringBodyRepN := 0;
  fInputStringEnd := '';
 end; { of procedure TRETestCase.SetInputFileName
--------------------------------------------------------------}

function TRETestCase.GetSubExprMatchCount : integer;
 begin
  Result := High (fMatchList) - Low (fMatchList); // we do not count last item
 end; { of function TRETestCase.GetSubExprMatchCount
--------------------------------------------------------------}

function TRETestCase.GetMatchPos (Idx : integer) : integer;
 begin
  Result := fMatchList [Idx].StartPos;
 end; { of function TRETestCase.GetMatchPos
--------------------------------------------------------------}

function TRETestCase.GetMatchLen (Idx : integer) : integer;
 begin
  with fMatchList [Idx] do
    Result := EndPos - StartPos + 1;
 end; { of function TRETestCase.GetMatchLen
--------------------------------------------------------------}

procedure TRETestCase.AssignToTRegExpr (ARegExpr : TRegExpr);
 begin
  ARegExpr.Expression := Expression;
  ARegExpr.InputString := InputString;
  ARegExpr.ModifierStr := ModifierStr;
 end; { of procedure TRETestCase.AssignToTRegExpr
--------------------------------------------------------------}

function TRETestCase.GetMatchList : string;
 var
  i : integer;
 begin
  Result := '';
  for i := Low (fMatchList) to High (fMatchList) do begin
    if fMatchList [i].StartPos > 0 then
     Result := Result
      + IntToStr (fMatchList [i].StartPos)
      + REPosDelim
      + IntToStr (fMatchList [i].EndPos);
    Result := Result + REMatchDelim + ' ';
   end;
  if length (Result) > 0 // remove trailing REMatchDelim and space
   then Delete (Result, length (Result) - 1, 2);
 end; { of function TRETestCase.GetMatchList
--------------------------------------------------------------}

procedure TRETestCase.SetMatchList (AStr : string);
 var
  i, i0 : integer;
  AStrLen : integer;
  Num : integer;
  Match : string;
 begin
  // I know, I could use TStrings.CommaText, but
  // I like full control ;)

  AStrLen := length (AStr);

  // Calculate items number
  Num := 1; // assume one item if no delimiters
  i := 1;
  while i <= AStrLen do begin
    if AStr [i] = REMatchDelim
     then inc (Num);
    inc (i);
   end;

  // Get memory for results of parsing and clear it
  SetLength (fMatchList, Num);
  for i := 0 to Num - 1 do begin
    fMatchList [i].StartPos := -1;
    fMatchList [i].EndPos := -1;
   end;

  // Do the parsing
  Num := 0;
  i := 1;
  while i <= AStrLen do begin
    // skip blanks:
    while (i <= AStrLen) and (AStr [i] in REListBlanks)
     do inc (i);

    // scan the item
    i0 := i;
    while (i <= AStrLen) and (AStr [i] <> REMatchDelim)
     do inc (i);
    Match := Copy (AStr, i0, i - i0);

    // remove blanks inside the item
    for i0 := length (Match) downto 1 do
     if Match [i0] in REListBlanks
      then Delete (Match, i0, 1);

    // parse the item and add to results
    if (Match <> '') and (Match <> '-1') and (Match <> REPosDelim) then
     with fMatchList [Num] do begin
       StartPos := StrToIntDef (Copy (Match, 1, pos (REPosDelim, Match) - 1), -1);
       EndPos := StrToIntDef (Copy (Match, pos (REPosDelim, Match) + 1, MaxInt), -1);
       if EndPos = -1
        then StartPos := -1;
       if StartPos = -1
        then EndPos := -1;
      end;
    inc (Num);

    // skip blanks:
    REPEAT
     inc (i);
    UNTIL (i > AStrLen) or not (AStr [i] in REListBlanks);
   end;

  // remove trailing empty items
  while (Num > 0)
        and (fMatchList [Num - 1].StartPos = -1)
   do dec (Num);
  SetLength (fMatchList, Num);
 end; { of procedure TRETestCase.SetMatchList
--------------------------------------------------------------}

procedure TRETestCase.AssignMatchList (ARegExpr : TRegExpr);
 var
  i : integer;
 begin
  SetLength (fMatchList, ARegExpr.SubExprMatchCount + 1);
  for i := 0 to ARegExpr.SubExprMatchCount do
   with fMatchList [i] do begin
     StartPos := ARegExpr.MatchPos [i];
     EndPos := ARegExpr.MatchPos [i] + ARegExpr.MatchLen [i] - 1;
     if EndPos = -1
      then StartPos := -1;
     if StartPos = -1
      then EndPos := -1;
    end;
 end; { of procedure TRETestCase.AssignMatchList
--------------------------------------------------------------}



{====================== TRETestCases =========================}

constructor TRETestCases.Create;
 begin
  inherited;
  StorageIDPrefix := 're_';
 end; { of constructor TRETestCases.Create
--------------------------------------------------------------}

destructor TRETestCases.Destroy;
 begin
  Clear;
  inherited;
 end; { of destructor TRETestCases.Destroy
--------------------------------------------------------------}

procedure TRETestCases.Clear;
 begin
  while Count > 0 do
   if Assigned (Items [Count - 1]) then begin
     Items [Count - 1].Free;
     Delete (Count - 1);
    end;
 end; { of procedure TRETestCases.Clear
--------------------------------------------------------------}

function TRETestCases.GetItem (AIdx : integer) : TRETestCase;
 begin
  Result := TRETestCase (inherited Get (AIdx));
 end; { of function TRETestCases.GetItem
--------------------------------------------------------------}

function TRETestCases.IndexByName (const AName : string) : integer;
 begin
  Result := 0;
  while (Result < Count) and (Items [Result].Name <> AName)
   do inc (Result);
  if Result >= Count
   then Result := -1;
 end; { of function TRETestCases.IndexByName
--------------------------------------------------------------}

procedure TRETestCases.LoadFromFile (const AFileName : string);
 var
  ss : TStrings;
  i : integer;
  TestCase : TRETestCase;
  kn, kv : string;
 begin
  Clear;
  fIniFileName := AFileName;
  ss := nil;
  try
    ss := TStringList.Create;
    ss.LoadFromFile (AFileName);

    i := 0;
    REPEAT
      while (i < ss.Count)
          and ((length (ss [i]) < rtkSectionNamePrefixLength + 1)
               or (LowerCase (Copy (ss [i], 1, rtkSectionNamePrefixLength + 1))
         <> '[' + rtkSectionNamePrefix))
       do inc (i);
      if i < ss.Count then begin
        TestCase := TRETestCase.Create;
        with TestCase do try
          fName := Copy (ss [i], rtkSectionNamePrefixLength + 2, MaxInt);
          System.Delete (fName, length (fName), 1);
         REPEAT
          inc (i);
          if i >= ss.Count
           then BREAK;
          if (length (Trim (ss [i])) > 0) and (ss [i][1] in ['a'..'z', 'A'..'Z', '_', '$'])
            and (pos ('=', ss [i]) > 1)
            then begin
           kn := Copy (ss [i], 1, pos ('=', ss [i]) - 1);
           kv := Copy (ss [i], pos ('=', ss [i]) + 1, MaxInt);
           while (i < ss.Count - 1) and (length (ss [i + 1]) > 0)
                 and (ss [i + 1][1] in ['-', '=']) do begin
             if ss [i + 1][1] = '='
              then kv := kv + #$d#$a;
             kv := kv + Copy (ss [i + 1], 2, MaxInt);
             inc (i);
            end;
           if kn = rtkDescription
            then fDescription := kv
           else if kn = rtkComment
            then fComment := kv
           else if kn = rtkExpression
            then fExpression := kv
           else if kn = rtkInputStringBeg
            then fInputStringBeg := kv
           else if kn = rtkInputStringBody
            then fInputStringBody := kv
           else if kn = rtkInputStringEnd
            then fInputStringEnd := kv
           else if kn = rtkInputStringBodyRepN
            then fInputStringBodyRepN := StrToIntDef (kv, 0)
           else if kn = rtkInputFileName
            then fInputFileName := kv
           else if kn = rtkModifierStr
            then fModifierStr := kv
           else if kn = rtkSubstitutionTemplate
            then fSubstitutionTemplate := kv
           else if kn = rtkString4Replace
            then fString4Replace := kv
           else if kn = rtkMatchList
            then MatchList := kv
           end;
         UNTIL (i >= ss.Count) or ((length (ss [i]) > 0) and (ss [i][1] = '['));
        finally Add (pointer (TestCase));
       end;
     end;
    UNTIL i >= ss.Count;
    finally begin
      ss.Free;
     end;
   end;
 end; { of procedure TRETestCases.LoadFromFile
--------------------------------------------------------------}

procedure TRETestCases.SaveToFile (const AFileName : string);
 var
  ss : TStrings;
  i : integer;
 procedure PutStringKey (const AKeyName : string; const AKeyValue : RegExprString);
  var
   i, i0 : integer;
   First : boolean;
  begin
   First := True;
   i := 1;
   i0 := i;
   while (i <= length (AKeyValue)) do begin
     while (i <= length (AKeyValue))
           and not (AKeyValue [i] in [#$d, #$a])
      do inc (i);
     if First then begin
        ss.Add (AKeyName + '=' + copy (AKeyValue, 1, i - 1));
        First := False;
       end
      else ss.Add ('=' + copy (AKeyValue, i0, i - i0));
     REPEAT
      inc (i);
     UNTIL (i > length (AKeyValue))
           or not (AKeyValue [i] in [#$d, #$a]);
     i0 := i;
    end;
  end;
 begin
  ss := nil;
  try
    ss := TStringList.Create;

    for i := 0 to Count -1 do
     with Items [i] do begin
       ss.Add ('[' + rtkSectionNamePrefix + fName + ']');
       PutStringKey (rtkDescription, fDescription);
       PutStringKey (rtkComment, fComment);
       PutStringKey (rtkExpression, fExpression);
       PutStringKey (rtkInputStringBeg, fInputStringBeg);
       PutStringKey (rtkInputStringBody, fInputStringBody);
       PutStringKey (rtkInputStringEnd, fInputStringEnd);
       PutStringKey (rtkInputStringBodyRepN, IntToStr (fInputStringBodyRepN));
       PutStringKey (rtkInputFileName, fInputFileName);
       PutStringKey (rtkModifierStr, fModifierStr);
       PutStringKey (rtkSubstitutionTemplate, fSubstitutionTemplate);
       PutStringKey (rtkString4Replace, fString4Replace);
       PutStringKey (rtkMatchList, MatchList);
       ss.Add ('');
      end;

    ss.SaveToFile (AFileName);
    finally begin
      ss.Free;
     end;
   end;
 end; { of procedure TRETestCases.SaveToFile
--------------------------------------------------------------}


initialization
 tynList.RegisterItemClass (TRETestCase);

end.

