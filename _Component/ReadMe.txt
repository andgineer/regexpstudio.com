Carlo Pasolini, Riccione (Italy), e-mail: ccpasolini@libero.it 

This is a VCL version of the class TRegExpr. 

I defined 2 events and 4 more methods (one for match on strings, one
for match on files, one for substitution on strings, one for
substitution on files).

Steps needed to build this component starting from the original class TRegExpr
of Andrey V. Sorokin:

1)Definition of the following 2 types:

 TOnMatch = procedure (const MatchNumber: integer; var GoOn: Boolean) of object;

 TOnMatchReplace = procedure (const MatchNumber: integer; var GoOn: Boolean; 
                              var Replace: Boolean; var ReplaceStr : RegExprString;
                              var AUseSubstitution : boolean) of object;

2)In the private section of TRegExpr add the following 2 fields:

 FOnMatch: TOnMatch;
 FOnMatchReplace: TOnMatchReplace;

3)In the public section add the following 4 method declarations:

 procedure ExecGlobal(const AInputStr : RegExprString);

 procedure ExecGlobalFile(const AFile: string);

 function ReplaceGlobal (AInputStr : RegExprString;
                         const AReplaceStr : RegExprString;
                         AUseSubstitution : boolean{$IFDEF D4_}= False{$ENDIF}) //###0.946
                        : RegExprString;

 procedure ReplaceGlobalFile (InFile, OutFile : string;
                              const AReplaceStr : RegExprString;
                              AUseSubstitution : boolean{$IFDEF D4_}= False{$ENDIF}); //###0.946

4)Create a published section

5)Move the following 2 properties from the public section into the pubished section:

 property Expression : RegExprString read GetExpression write SetExpression;

 property ModifierStr : RegExprString read GetModifierStr write SetModifierStr;

6)Add the following 2 events to the published section:

 property OnMatch: TOnMatch read FOnMatch write FOnMatch;

 property OnMatchReplace: TOnMatchReplace read FOnMatchReplace write FOnMatchReplace;

7)Add the register procedure declaration to the interface section

8)Add the register procedure implementation to the implementation section:

 procedure Register;
 begin
   RegisterComponents('RegExpr', [TRegExpr]);
 end;

9)Modify the constructor declaration:

 constructor Create(AOwner: TComponent); override;

10)Modify the destructor implementation by adding a call to "inherited" at the bottom of the 
   implementation.

11)Modify the implementation of the stand alone procedures (ExecRegExpr, etc..):

Before: 

 {...}
 r := TRegExpr.Create; 
 {...}
 
After:

 {...}
 r := TRegExpr.Create(nil); 
 {...}

12)Define the implementation of the 4 new methods:

//method added by Carlo Pasolini, Riccione (Italy), e-mail: ccpasolini@libero.it
function TRegExpr.ReplaceGlobal (AInputStr : RegExprString; const AReplaceStr : RegExprString;
      AUseSubstitution : boolean{$IFDEF D4_}= False{$ENDIF}) : RegExprString;
 var
   PrevPos : integer;
   MatchNumber: integer;
   BUseSubstitution: Boolean;
   BReplaceStr: RegExprString;
   GoOn, Replace, UseSubstitution, Next: Boolean;
   ReplaceStr: RegExprString;
 begin
  if Expression = '' then
    Exit;
    
  Result := '';
  PrevPos := 1;

  Next := True;
  Replace := True;
  MatchNumber := 0;
  if Exec (AInputStr) then
   repeat
     Inc(MatchNumber);
     ReplaceStr := AReplaceStr;
     UseSubstitution := AUseSubstitution;
     if Assigned(FOnMatchReplace) then
       begin
         GoOn := True;
         Replace := True;
         BUseSubstitution := False;
         FOnMatchReplace(MatchNumber, GoOn, Replace, BReplaceStr, BUseSubstitution);

         if Replace then
           begin
             if BReplaceStr <> '' then
               begin
                 ReplaceStr := BReplaceStr;
                 UseSubstitution := BUseSubstitution;
               end;
           end;

         Next := GoOn;
       end;

    Result := Result + System.Copy (AInputStr, PrevPos,
      MatchPos [0] - PrevPos);

    if Replace then
      begin
        if UseSubstitution //###0.946
          then Result := Result + Substitute (ReplaceStr)
        else Result := Result + ReplaceStr;
      end
    else
      Result := Result + Match[0];

    PrevPos := MatchPos [0] + MatchLen [0];

    if Next then
      Next := ExecNext;
   until not Next;

  Result := Result + System.Copy (AInputStr, PrevPos, MaxInt); // Tail
 end; { of function TRegExpr.ReplaceGlobal
--------------------------------------------------------------}

//method added by Carlo Pasolini, Riccione (Italy), e-mail: ccpasolini@libero.it
procedure TRegExpr.ReplaceGlobalFile (InFile, OutFile : string;
      const AReplaceStr : RegExprString;
      AUseSubstitution : boolean{$IFDEF D4_}= False{$ENDIF}); //###0.946
var
  InFileStream, OutFileStream: TFileStream;
  AInputStr: string;
  AOutputStr: string;
begin
  //
  if Expression <> '' then
    begin
      if FileExists(InFile) then
        begin
          InFileStream := TFileStream.Create(InFile, fmOpenRead);
          if InFileStream.Size <> 0 then
            begin
              SetLength(AInputStr, InFileStream.Size);
              InFileStream.Read(AInputStr[1], InFileStream.Size);
            end;
          InFileStream.Free;

          AOutputStr := ReplaceGlobal(AInputStr, AReplaceStr, AUseSubstitution);

          OutFileStream := TFileStream.Create(OutFile, fmCreate);
          OutFileStream.Write(AOutputStr[1], Length(AOutputStr));
          OutFileStream.Free;

        end;

    end;

end;

//method added by Carlo Pasolini, Riccione (Italy), e-mail: ccpasolini@libero.it
procedure TRegExpr.ExecGlobal(const AInputStr : RegExprString);
var
  MatchNumber: integer;
  GoOn: Boolean;
  Next: Boolean;
begin
  if Expression <> '' then
    begin
      Next := True;
      MatchNumber := 0;
      if Exec (AInputStr) then
        repeat
          Inc(MatchNumber);
          if Assigned(FOnMatch) then
            begin
              GoOn := True;
              FOnMatch(MatchNumber, GoOn);
              Next := GoOn;
            end;
          if Next then
            Next := ExecNext;
        until not Next;
    end;
end; { of procedure TRegExpr.ExecGlobal
------------------------------------------------------------}

//method added by Carlo Pasolini, Riccione (Italy), e-mail: ccpasolini@libero.it
procedure TRegExpr.ExecGlobalFile(const AFile: string);
var
  FileStream: TFileStream;
  AInputStr: string;
begin
  if Expression <> '' then
    begin
      if FileExists(AFile) then
        begin
          FileStream := TFileStream.Create(AFile, fmOpenRead);
          if FileStream.Size <> 0 then
            begin
              SetLength(AInputStr, FileStream.Size);
              FileStream.Read(AInputStr[1], FileStream.Size);
            end;

          ExecGlobal(AInputStr);

          FileStream.Free;

        end;

    end;
end; { of procedure TRegExpr.ExecGlobalFile
------------------------------------------------------------}

Note that the 2 methods which are file oriented, transfer the content of a file into a string
and then call the corrisponding string oriented method.

I wrote an example program in order to explain the utility of the 4 new methods and the 2 events.

I also built a component editor (TRegExprEdit) based on the example program made 
by Andrey V. Sorokin.


Carlo Pasolini, Riccione (Italy), e-mail: ccpasolini@libero.it 


 



 
    