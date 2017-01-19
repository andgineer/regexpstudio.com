{: Regular Expression matching library. }
unit mlRegularExpression;

interface

uses SysUtils, Classes,
     mlObject;

type

TmlRegularExpression = class;
TmlRegularExpressionState = class;
TmlRegularExpressionTransition = class;

// ===============================================================================================
// Type: TRegularExpressionParserState
// ===================================

{: Enumerated type to identify what the parser is currently creating.
   @enum psStates Parser is adding states to the NFA
   @enum psCharRange Parser is reading the definition of a Character Range }
TRegularExpressionParserState = (psStates, psCharRange);

// ===============================================================================================
// Type: TRegularExpressionParserFlag
// ==================================

{: A list of possible flags to further identify the nature of a parsed character.
   @enum pfEscaped Character was preceded by '\' in the input stream. <p>
                   If the character normally has a special meaning (eg: ? * [ ] ) then it will be
                   treated simply as a normal character with no special significance.<br>
                   If the character normally has no significance, it may be treated with
                   special significance (eg: \d = [0-9], \t = tab and so on) }
TRegularExpressionParserFlag = (pfEscaped);

// ===============================================================================================
// Type: TRegularExpressionParserFlags
// ===================================

{: A Set of TRegularExpressionParserFlag items }
TRegularExpressionParserFlags = set of TRegularExpressionParserFlag;

// ===============================================================================================
// Object: TmlRegularExpressionStateType
// =====================================

TmlRegularExpressionStateType = (stNormal, stGroupStart, stGroupFinish);

// ===============================================================================================
// Enumeration: TmlRegularExpressionMatchFlag
// ==========================================

{: Possible flags governing Regular Expression Matching.<p>
   Combining mfAllMatches with mvOverlapMatches may result in a large number of results.<br>
   Combinging mfStartOnly with mfFinishOnly requires that the entire line match the expression.<p>
   mfStartOnly can be specified by begining the Regular Expression with '^'<br>
   mfFinishOnly can be specified by ending the Regular Expression with '$'<br>
   @enum mfCaseInsensitive Matches don't depend on case<br>(default case is case sensitive)
   @enum mfLongestMatch Find the longest possible match to the RE<br>(default is to find the
                        shortest)
   @enum mfAllMatches Find all matches<br>(default is to find only the first)
   @enum mfStartOnly Only match at the start of the string<br>(default is to find a match
                     anywhere)
   @enum mfFinishOnly Match must terminate at the end of the string<br>(default is to permit a
                      match finishing anywhere)
   @enum mfOverlapMatches Allow overlapping matches to be returned<br>(default is to return
                          matches which do not overlap }
TmlRegularExpressionMatchFlag = ( mfCaseInsensitive, mfLongestMatch, mfAllMatches, mfStartOnly,
                                  mfFinishOnly, mfOverlapMatches);

// ===============================================================================================
// Set: TmlRegularExpressionMatchFlags
// ===================================

{: Set of <See TmlRegularExpressionMatchFlag> values. }
TmlRegularExpressionMatchFlags = set of TmlRegularExpressionMatchFlag;

// ===============================================================================================
// Enumeration: TmlRegularExpressionMatchResult
// ============================================

{: Possible results from a Regular Expression Match.
   @enum mrNone No match attempted yet
   @enum mrFail No accepted Match
   @enum mrMatch Match Found
   @enum mrInsufficient Ran out of string while matching }
TmlRegularExpressionMatchResult = (mrNone, mrFail, mrMatch, mrInsufficient);

// ===============================================================================================
// Exception: EmlRegularExpressionError
// ====================================

{: Exception type raised for problems within a Regular Expression }
EmlRegularExpressionError = class(Exception);

// ===============================================================================================
// Object: TmlRegularExpression
// ============================

{: Regular Expression Matching object.<p>
   This class provides easy to use Regular Expression string matching for use in wider
   applications.  Use includes language lexers & parsers, searching tools and so on. <p>
   <b>Operation</b><br>
   Developed from first principals and NFA theory, this object works as follows (note that this
   description uses terminology which should be confined to a Computer Science paper):<br>
   <ol>
   <li> Parse Regular Expression into a Non-deterministic Finite State Automata (NFA) with
        lambda transitions
   <li> Merge identical states
   <li> Eliminate Lambda transitions
   <li> Merge identical states<br>
        (The Removal of lambda transitions can reveal that two transitions are actually identical
        when they didn't appear so initially)
   <li> Remove of unreachable states
   <li> Use the resultant NFA to match an input stream
   </ol>
   Note that some Computer Science courses and textbooks use the term "epsilon transition" instead
   of "lambda transition" - in both cases the meaning is the same: A transition in the NFA which
   does not consume any characters of input. }

TmlRegularExpression = class(TmlObject)
private

  // Internal Variables

  FoStates: TmlList;
  FeState:  TRegularExpressionParserState;
  FxFlags:  TmlRegularExpressionMatchFlags;

  FoCurrentState: TmlRegularExpressionState;

  FxCharRange:    TCharSet;
  FbInvertedSet:  boolean;
  FsPartialChars: string;
  FbIsRange:      boolean;

  FaoStartStack:  array of TmlRegularExpressionState;         // Stack of Group start states
  FaoFinishStack: array of TmlRegularExpressionState;         // Stack of Group finish states
  FiStack:        integer;                                    // Size of Stack

  // Properties

  FoMatches: TmlList;

  FoStartState: TmlRegularExpressionState;

  // Internal Methods

  {: Parse a regular expression and create a state machine for recognition.
     @param sRule Regular Expression to parse
     @raises EmlRegularExpressionError If a syntax error is encountered in the expression }
  procedure ParseExpression( sRule: string);

  {: Parse a single character when creating states }
  procedure ParseForState( cCharacter: char; xFlags: TRegularExpressionParserFlags);

  {: Parse a single character when creating a Character Range }
  procedure ParseForRange( cCharacter: char; xFlags: TRegularExpressionParserFlags);

  {: Add a transition to a state and set that new state as the current state.
     @param oNewState State to transition to. If nil, creates a new ordinary state to use.
     @param xCharacters Set of characters to transition upon
     @returns New value of FoCurrentState }
  function AddTransition( oNewState:   TmlRegularExpressionState;
                          xCharacters: TCharSet): TmlRegularExpressionState;

  // State machine methods

  {: Start a New Group. Groups are enclosed in regular expressions by '(' and ')'. }
  procedure BeginGroup;

  {: Finish a Group. Groups are enclosed in regular expressions by '(' and ')'. }
  procedure FinishGroup;

  {: Start another branch }
  procedure AddBranch;

  {: Add Repeating to the last state }
  procedure AddRepetition;

  {: Add Optionality to the last state }
  procedure AddOptional;

  {: Initialise for parsing a Character Range }
  procedure StartRange;

  // Optimization Methods

  {: Optimize the NFA into a DFA for efficient use.<p>
     @see MakeCaseInsensitive
     @see PropagateAcceptedFlags
     @see RemoveRedundantStates
     @see CollapseIdenticalStates
     @see RemoveLambdaTransitions }
  procedure Optimize;

  {: Modify the NFA to be Case Insensitive }
  procedure MakeCaseInsensitive;

  {: Do some basic simplifications to the NFA }
  procedure Simplify;

  {: Transform the NFA into an equivilent DFA. This is less space efficient than the NFA but
     much much faster to handle. }
  procedure MakeDeterministic;

  {: Determine all the Accept states of the NFA.<p>
     We begin with a single acceptance state in the NFA built by the parsing routine. To allow for
     the elimination of lambda rules (which are expensive to retain when matching) we need to find
     the other states which should also accept. These are states which have a lambda transition
     (or a series of lambda transitions) to any accepting state. }
  procedure PropagateAcceptedFlags;

  {: Find and remove any states which are not reachable from our start state. }
  procedure RemoveRedundantStates( oStart: TmlRegularExpressionState);

  {: Find and merge any states which are semantically identical - states which add no information
     to the NFA.<p>
     If states (A) and (B) both have identical sets of exit transitions, then we gain no
     additional information by having them as separate states - and they can be merged. This is
     achieved by changing all entry transitions to (B) to instead go to (A). Note that this
     process will result in (B) being unreachable - a subsequent call to <See
     Method=RemoveRedundantStates> will clean this up. }
  procedure CollapseIdenticalStates;

  {: Remove lambda transitions from the NFA.<p>
     Lambda transitions are a powerful expressive tool - but they are expensive to use when
     recognising a Regular Expression. By removing lambda transitions, it becomes more efficient
     to use the NFA.<p>
     This works as follows: If State A has a lambda transition to B, and B has a transition to C
     on [a-z], then the lambda transition A->B can be replaced with a normal transition A to C on
     [a-z]<p>
     ie:  (A) ---lambda--> (B) ---[a-z]--> (C) == (A) ---[a-z]-> (C) }
  procedure RemoveLambdaTransitions;

  {: Calculate the First sets of each transition - the possible characters which may result in
     a transition from a given state. }
  procedure CalculateFirstSets;

  // Property Methods

  function GetStateCount: integer;
  function GetStateByIndex( iIndex: integer): TmlRegularExpressionState;

  function GetMatchCount: integer;
  function GetMatchStartByIndex( iIndex: integer): integer;
  function GetMatchFinishByIndex( iIndex: integer): integer;
  function GetMatchSizeByIndex( iIndex: integer): integer;

public

  // Standard methods

  {: Create a new Regular Expression object to match a given RE.
     @param sExpression Text form of the Regular Expression to match
     @param xFlags Options to use for matching (See <See type=TmlRegularExpressionMatchFlags>) }
  constructor Create( sRule: string; xFlags: TmlRegularExpressionMatchFlags); reintroduce;

  {: Destroy this instance. }
  destructor Destroy; override;

  // Operation Methods

  {: Search for a match in a given string.
     @param sString The string to search for matches
     @param xFlags Options for the search from <See type=TmlRegularExpressionMatchFlag>
     @returns Result of search <See type=TmlRegularExpressionMatchResult> }
  function Match( sString: string): TmlRegularExpressionMatchResult;

  // Description Methods

  {: Add details of this Regular Expressions state table to the give TStrings instance.
     Intended mostly for debugging changes and bug fixes. }
  procedure DumpStateTable( oStrings: TStrings);

  // Internal Methods

  {: Create a new state and return it }
  function NewState( eType: TmlRegularExpressionStateType): TmlRegularExpressionState;

  {: Get the composite state representing the list of states passed }
  function GetDFAState( oStates: TList): TmlRegularExpressionState;

  {: Get a fingerprint number to use for this set of states }
  function CalculateDFAFingerprint( oStates: TList): integer;

  // State Properties

  {: Count of states in this Regular expression }
  property StateCount: integer read GetStateCount;

  {: Access to states in this regular expression }
  property States[ iIndex: integer]: TmlRegularExpressionState read GetStateByIndex;

  // Match Properties

  {: Count of how many matches we found }
  property MatchCount: integer read GetMatchCount;

  {: Start position of match iIndex }
  property MatchStart[iIndex: integer]: integer read GetMatchStartByIndex;

  {: Finish position of match iIndex }
  property MatchFinish[iIndex: integer]: integer read GetMatchFinishByIndex;

  {: Size of match iIndex }
  property MatchSize[iIndex: integer]: integer read GetMatchSizeByIndex;

  {: The state from which matching should begin }
  property StartState: TmlRegularExpressionState read FoStartState;

end;

// ===============================================================================================
// Object: TmlRegularExpressionMatcher
// ===================================

{: Execute the DFA contained by a TmlRegularExpression object and check for a match to the
   RegularExpression encoded by the DFA. }

TmlRegularExpressionMatcher = class(TmlObject)
private

  // Internal Variables

  FoExpression: TmlRegularExpression;
  FoStates:     TList;

  FabFirstSet:  array[char] of boolean;

  // Properties

  FeStatus: TmlRegularExpressionMatchResult;
  FiStart:  integer;
  FiFinish: integer;
  FxFlags:  TmlRegularExpressionMatchFlags;

public

  // Standard Methods

  constructor Create( oOwner: TmlRegularExpression;
                      xFlags: TmlRegularExpressionMatchFlags); reintroduce;
  destructor Destroy; override;

  // TmlRegularExpression Methods

  {: Check for a match in sString starting at position iStart.
     @returns mrMatch If a match is found. }
  function Match( sString: string; iStart: integer): TmlRegularExpressionMatchResult;

  // Properties

  property Status: TmlRegularExpressionMatchResult read FeStatus;
  property Start:  integer                         read FiStart;
  property Finish: integer                         read FiFinish;

  property Flags:  TmlRegularExpressionMatchFlags  read FxFlags write FxFlags;

end;

// ===============================================================================================
// Object: TmlRegularExpressionState
// =================================

{: Encapsulation of a single state in the NFA or DFA used to parse regular expressions }
TmlRegularExpressionState = class(TmlObject)
private

  // Internal Variables

  FoTransitions:        TmlList;          // List of transitions out of this state
  FbFindingTransitions: boolean;

  FoPriorStates:        TmlList;          // List of states with transitions TO this state

  {: Array of flags indicating what characters can start this state }
  FabFirstSet:          array[char] of boolean;

  FaoSuccessor: array[char] of TmlRegularExpressionState;  // Cache of next states

  FoExpression:         TmlObject;

  FoStates:             TmlList;          // List of NFA states contained by this DFA state

  // Properties

  FeStateType:   TmlRegularExpressionStateType;
  FoGroupStart:  TmlRegularExpressionState;
  FoGroupFinish: TmlRegularExpressionState;
  FiStateNumber: integer;
  FbAccept:      boolean;
  FbModified:    boolean;
  FbReachable:   boolean;
  FbMarked:      boolean;
  FiFingerPrint: integer;

protected

  // Property Methods

  procedure SetGroupStart( oGroupStart: TmlRegularExpressionState);
  procedure SetGroupFinish( oGroupFinish: TmlRegularExpressionState);

  function GetPriorState( iIndex: integer): TmlRegularExpressionState;
  function GetPriorStateCount: integer;

  function GetTransitionCount: integer;
  function GetTransitionByIndex( iIndex: integer): TmlRegularExpressionTransition;

  function GetStateCount: integer;

  // Internal Methods

  procedure ConstructTransition( xSet: TCharSet);

public

  // Standard Methods

  constructor Create( oExpression: TmlObject;
                      eType: TmlRegularExpressionStateType = stNormal); reintroduce;
  destructor Destroy; override;
  procedure FreeRefs; override;

  // Transition Methods

  {: Add a transition to the passed state from this state.
     @param oState Destination state of transition
     @param xCharacters Set of characters on which to create the transition }
  procedure AddTransitionTo( oState: TmlRegularExpressionState; xCharacters: TCharset);

  {: Add a lambda transition to the given state.
     A lambda transition is one which does not require any matching input characters
     @param oState Destination state of the transition }
  procedure AddLambdaTransitionTo( oState: TmlRegularExpressionState);

  {: Remove transition to the passed state from this state on these characters.
     If there are no other characters left, the old transition will be removed.
     @param oState Destination state
     @param xCharacters Characters to remove from the transition }
  procedure RemoveTransitionTo( oState: TmlRegularExpressionState; xCharacters: TCharset);

  {: Get all the transitions we can make on this character.
     If this state is the start of any lambda transitions, we implicitly follow them to find
     any additional destinations which are possible for this character. oTransitionList is
     <b>not</b> cleared prior to adding our transitions.
     @param cChar Character of input to recognise
     @param oTransitionList List to receive possible transitions }
  procedure GetTransitionsOn( cChar: char; oStateList: TList);

  {: Get the transition we make on this character, if there is only one. If there is no
     possible transition, or if there are several, return nil. }
  function GetOnlyTransitionOn( cChar: char): TmlRegularExpressionState;

  {: Find a transition which can be made on the given characer.
     If no, or multiple, transition(s) can be made, returns nil }
  function FindImmediateTransitionOn( cChar: char): TmlRegularExpressionState;

  // Optimization Methods

  {: Make all the exit transitions of this state Case insensitive }
  procedure MakeCaseInsensitive;

  {: Check to see if we should be an Accept state. If we have a lambda transition to an
     accept state, then we are also }
  procedure CheckIfAccept;

  {: Do some simple optimization by removing lambda rules from our state }
  procedure RemoveLambdaTransitions( var bChanged: boolean);

  {: Remove nondeterminism from this node by creating successor nodes with lambda transitions. }
  procedure MakeDeterministic( var bChanged: boolean);

  {: Mark all the states reachable from this one }
  procedure MarkReachable;

  {: Check to see if another state is the same as us.
     This is defined as another state having an exactly identical set of exit transitions.
     @param oState The state to compare against }
  function EqualState( oState: TmlRegularExpressionState): boolean;

  {: Check to see if this state contains a transition identical to this one.
     @param oTransition Transition to check for }
  function ContainsTransition( oTransition: TmlRegularExpressionTransition): boolean;

  {: Change all our entry transitions to point to another state }
  procedure ChangeEntryTransitions( oNewState: TmlRegularExpressionState);

  {: Redirect our transition to oOldState to move to oNewState instead }
  procedure RedirectTransition( oOldState: TmlRegularExpressionState;
                                oNewState: TmlRegularExpressionState);

  {: Calculate our set of transition characters }
  procedure CalculateFirstSet;

  // Operation Methods

  {: Return the successor to the given state }
  function GetSuccessor( cChar: char): TmlRegularExpressionState;

  {: Can the given character cause a transition from this state?
     @param cChar Character to test
     @returns True if there is an exit transition for that character }
  function CanStart( cChar: char): boolean;

  // Description Methods

  function Name: string;
  procedure DumpDescription( oStrings: TStrings);

  // DFA Production Methods

  procedure AddState( oState: TmlRegularExpressionState);
  procedure Closure;

  function ContainsState( oState: TmlRegularExpressionState): boolean;

  // Properties

  property StateType: TmlRegularExpressionStateType read FeStateType;

  property GroupStart: TmlRegularExpressionState  read FoGroupStart write SetGroupStart;
  property GroupFinish: TmlRegularExpressionState read FoGroupFinish write SetGroupFinish;

  property StateNumber: integer read FiStateNumber;

  property PriorStateCount: integer read GetPriorStateCount;
  property PriorStates[iIndex: integer]: TmlRegularExpressionState read GetPriorState;

  {: Does reaching this state indicate acceptance of the RE? }
  property Accept: boolean read FbAccept write FbAccept;

  {: Indicates whether this state has been modified }
  property Modified: boolean read FbModified write FbModified;

  {: Can this state be reached from the start state }
  property Reachable: boolean read FbReachable write FbReachable;

  {: Count of Exit transitions }
  property TransitionCount: integer read GetTransitionCount;

  {: Our Exit Transitions }
  property Transitions[iIndex: integer]: TmlRegularExpressionTransition read GetTransitionByIndex;

  {: Marking flag used by Matchers }
  property Marked: boolean read FbMarked write FbMarked;

  {: Fingerprint used to find states rapidly when converting to DFA }
  property FingerPrint: integer read FiFingerPrint write FiFingerPrint;

  {: Return count of states contained in this state. This is used when constructing the DFA }
  property StateCount: integer read GetStateCount;

end;

// ===============================================================================================
// Object: TmlRegularExpressionTransition
// ======================================

TmlRegularExpressionTransition = class(TmlObject)
private

  // Internal Variables

  FoSource:      TmlRegularExpressionState;
  FoDestination: TmlRegularExpressionState;
  FxCharSet:     TCharSet;
  FbLambda:      boolean;

public

  // Standard Methods

  {: Create the transition.
     @param oSource The start state (and owner) of the transition
     @param oDestination The finish state of the transition
     @param xCharacters The characters on which to take this transition
     @param bLambda Is this transition also a lambda transition? }
  constructor Create( oSource:      TmlRegularExpressionState;
                      oDestination: TmlRegularExpressionState;
                      xCharacters:  TCharSet;
                      bLambda:      boolean); reintroduce;
  procedure FreeRefs; override;

  // Transition modification Methods

  {: Add additional characters to this transition }
  procedure AddCharacters( xCharacters: TCharSet);

  // Description Methods

  function Description: string;

  // Properties

  property Source:      TmlRegularExpressionState read FoSource;
  property Destination: TmlRegularExpressionState read FoDestination;
  property Characters:  TCharSet                  read FxCharSet write FxCharSet;
  property Lambda:      boolean                   read FbLambda write FbLambda;

end;

implementation

//uses mlUtilities;

function StrEmpty (const s : string) : boolean;
 begin
  Result := s = '';
 end;

var
  GiStateCount: integer;

// ===============================================================================================
// Object: TmlRegularExpression
// ============================

// Standard methods
// ----------------

constructor TmlRegularExpression.Create( sRule: string;
                                         xFlags: TmlRegularExpressionMatchFlags);
begin
  inherited Create;

  FoStates := TmlList.Create;
  FoMatches := TmlList.Create;
  FxFlags := xFlags;

  ParseExpression( sRule);
  Optimize;
end;

destructor TmlRegularExpression.Destroy;
begin

  // States in this list are freed by reference count
  FoStates.Free;

  // Matches in this list are freed because we own them
  FoMatches.Free;
  
  inherited Destroy;
end;

// Operation Methods
// -----------------

function TmlRegularExpression.Match( sString: string): TmlRegularExpressionMatchResult;
var
  oMatcher: TmlRegularExpressionMatcher;
  iCursor:  integer;
  iLength:  integer;
  eMatch:   TmlRegularExpressionMatchResult;

  bAllMatches:     boolean;
  bOverlapMatches: boolean;

begin

  // Prepare for Matching

  FoMatches.Clear;

  oMatcher := TmlRegularExpressionMatcher.Create( self, FxFlags);

  if mfStartOnly in FxFlags then begin
    // Search for start of string
    eMatch := oMatcher.Match( sString, 1);
    if eMatch = mrMatch then begin
      FoMatches.Add( oMatcher);
      oMatcher := nil;
    end;
  end
  else begin
    // Search for anywhere in string
    iLength := Length( sString);
    iCursor := 1;
    bAllMatches := mfAllMatches in FxFlags;
    bOverlapMatches := mfOverlapMatches in FxFlags;
    repeat
      eMatch := oMatcher.Match( sString, iCursor);
      if eMatch = mrMatch then begin
        FoMatches.Add( oMatcher);
        if not bOverlapMatches then
          iCursor := oMatcher.Finish;
        oMatcher := TmlRegularExpressionMatcher.Create( self, FxFlags);
        if not bAllMatches then
          break;
      end;
      Inc( iCursor);
    until iCursor>iLength;
  end;

  if FoMatches.Count>0 then
    Result := mrMatch
  else begin
    Assert( Assigned( oMatcher),
            'TmlRegularExpression.Match: oMatcher is not assigned (nil value)');
    Result := oMatcher.Status;
  end;
  if Assigned( oMatcher) then
    oMatcher.FreeRefs;
end;

// Internal Methods
// ----------------

procedure TmlRegularExpression.ParseExpression( sRule: string);
const
  ciStartStackSize = 10;
  csSyntaxError = 'Syntax Error: %s (Position %d)';
var
  iScan:         integer;
  cChar:         char;
  xFlags:        TRegularExpressionParserFlags;
begin

  // Strip leading ^ or Trailing $ and set flags as required

  if not StrEmpty(sRule) and (sRule[1]='^') then begin
    Include( FxFlags, mfStartOnly);
    sRule := Copy( sRule, 2, Length( sRule)-1);
  end;

  if not StrEmpty(sRule) and (sRule[Length(sRule)]='$') then begin
    Include( FxFlags, mfFinishOnly);
    sRule := Copy( sRule, 1, Length( sRule)-1);
  end;

  if StrEmpty( sRule) then
    raise EmlRegularExpressionError.Create( 'Empty regular expression not allowed');

  FiStack := -1;
  FoCurrentState := nil;
  iScan := 1;

  // Parse expression

  BeginGroup;
  FoCurrentState.GroupFinish.Accept := true;
  BeginGroup;

  while iScan<=Length( sRule) do begin
    xFlags := [];
    cChar := sRule[iScan];
    if cChar='\' then begin
      Include( xFlags, pfEscaped);
      Inc( iScan);
      if iScan>Length( sRule) then
        raise EmlRegularExpressionError.Create('Empty Escape at end of string');
      cChar := sRule[iScan];
    end;
    case FeState of
      psStates:    ParseForState( cChar, xFlags);
      psCharRange: ParseForRange( cChar, xFlags);
    end;
    Inc( iScan);
  end;
  FinishGroup;
  FinishGroup;
end;

procedure TmlRegularExpression.ParseForState( cCharacter: char;
                                              xFlags: TRegularExpressionParserFlags);
var
  oNewState: TmlRegularExpressionState;
begin
  if (pfEscaped in xFlags) then
    case cCharacter of
      'd': AddTransition( nil, ['0'..'9']);
      'a': AddTransition( nil, ['A'..'Z', 'a'..'z']);
      'w': AddTransition( nil, ['0'..'9', 'A'..'Z', 'a'..'z']);
      't': AddTransition( nil, [#9]);
      'n': AddTransition( nil, [#10,#13]);
    else
      oNewState := FoCurrentState.FindImmediateTransitionOn( cCharacter);
      AddTransition( oNewState, [cCharacter]);
    end
  else
    case cCharacter of
      '(': begin
             // We use two layers to separate transitions within the group from those without
             BeginGroup;
             BeginGroup;
           end;
      ')': begin
             // We use two layers to separate transitions within the group from those without
             FinishGroup;
             FinishGroup;
           end;
      '|': begin
             FinishGroup;
             AddBranch;
             BeginGroup;
           end;
      '*': begin
             AddRepetition;
             AddOptional;
           end;
      '+': AddRepetition;
      '?': AddOptional;
      '[': StartRange;
      '.': AddTransition( nil, ['!'..'~']);
    else
      oNewState := FoCurrentState.FindImmediateTransitionOn( cCharacter);
      AddTransition( oNewState, [cCharacter]);
    end;
end;

procedure TmlRegularExpression.ParseForRange( cCharacter: char;
                                              xFlags: TRegularExpressionParserFlags);
var
  bEscaped: boolean;
  bDone:    boolean;
  oState:   TmlRegularExpressionState;
begin
  bEscaped := pfEscaped in xFlags;

  if bEscaped then begin
    bDone := true;
    case cCharacter of
      'd': FxCharRange := FxCharRange + ['0'..'9'];
      'a': FxCharRange := FxCharRange + ['A'..'Z', 'a'..'z'];
      'w': FxCharRange := FxCharRange + ['0'..'9', 'A'..'Z', 'a'..'z'];
      't': FxCharRange := FxCharRange + [#9];
      'n': FxCharRange := FxCharRange + [#10,#13];
    else
      bDone := false;
    end
  end
  else begin
    bDone := true;
    case cCharacter of
      '^': // '^' Means invert iff present at start of range before other characters
           if FxCharRange=[] then 
             FbInvertedSet := true;
      ']': begin
             // ']' means end of range unless escaped or first character
             if (FxCharRange<>[]) or (FsPartialChars<>'') then begin
               if FsPartialChars<>'' then
                 FxCharRange := FxCharRange + [FsPartialChars[1]];
               if FbIsRange then
                 FxCharRange := FxCharRange+['-'];
               if FbInvertedSet then
                 FxCharRange := [' '..'~'] - FxCharRange;
               oState := NewState( stNormal);
               FoCurrentState.AddTransitionTo( oState, FxCharRange);
               FoCurrentState := oState;
               FeState := psStates;
             end
           end;
      '-': // '-' Means range unless first or last
           if (FsPartialChars<>'') then
             FbIsRange := true;
    else
      bDone := false;
    end;
  end;

  if not bDone then begin
    if FbIsRange then begin
      FxCharRange := FxCharRange + [FsPartialChars[1]..cCharacter];
      FsPartialChars := '';
      FbIsRange := false;
    end
    else begin
      if FsPartialChars<>'' then
        FxCharRange := FxCharRange + [FsPartialChars[1]];
      FsPartialChars := cCharacter;
    end;
  end;
end;

function TmlRegularExpression.AddTransition( oNewState:   TmlRegularExpressionState;
                                             xCharacters: TCharSet): TmlRegularExpressionState;
begin
  if not Assigned( oNewState) then
    oNewState := NewState(stNormal);
  FoCurrentState.AddTransitionTo( oNewState, xCharacters);
  FoCurrentState := oNewState;
  Result := FoCurrentState;
end;

function TmlRegularExpression.NewState( eType: TmlRegularExpressionStateType): TmlRegularExpressionState;
begin
  Result := TmlRegularExpressionState.Create( self, eType);
  FoStates.Add( Result);
end;

function TmlRegularExpression.GetDFAState( oStates: TList): TmlRegularExpressionState;
var
  iScan:        integer;
  iFingerPrint: integer;
  oState:       TmlRegularExpressionState;
  iIndex:       integer;
begin
  Assert( Assigned( oStates), 'TmlRegularExpression.GetDFAState: '
                              +'oStates not assigned (nil value)');
  Assert( oStates.Count>0, 'TmlRegularExpression.GetDFAState: '
                           +'oStates is empty');
  if oStates.Count=1 then
    Result := TmlObject(oStates[0]) as TmlRegularExpressionState
  else begin
    oState := nil;
    iFingerPrint := CalculateDFAFingerprint( oStates);
    for iScan := 0 to StateCount-1 do begin
      if (States[iScan].FingerPrint = iFingerPrint)
         and (States[iScan].StateCount=oStates.Count) then begin
        oState := States[iScan];
        for iIndex := 0 to oStates.Count-1 do begin
          if not oState.ContainsState( TmlObject(oStates[iIndex])
                                      as TmlRegularExpressionState) then begin
            oState := nil;
            break;
          end;
        end;
        if Assigned( oState) then
          break;
      end;
    end;
    if Assigned( oState) then
      Result := oState
    else begin
      Result := NewState( stNormal);
      for iIndex := 0 to oStates.Count-1 do
        Result.AddState( TmlObject(oStates[iIndex]) as TmlRegularExpressionState);
      Result.FingerPrint := iFingerPrint;
      Result.Closure;
      //**
    end;
  end;
end;

function TmlRegularExpression.CalculateDFAFingerprint( oStates: TList): integer;
const
  ciLimit = (13*17*19*23*29)-1;
var
  iScan: integer;
begin
  Result := 1;
  for iScan := 0 to oStates.Count-1 do
    Result := (Result * (TmlObject( oStates[iScan]) as TmlRegularExpressionState).StateNumber)
              mod ciLimit;
end;

procedure TmlRegularExpression.BeginGroup;
begin
  Inc( FiStack);
  if Length( FaoStartStack)<=FiStack then begin
    SetLength( FaoStartStack, FiStack+4);
    SetLength( FaoFinishStack, FiStack+4);
  end;

  FaoStartStack[FiStack] := NewState( stGroupStart);
  FaoFinishStack[FiStack] := NewState( stGroupFinish);
  FaoStartStack[FiStack].GroupFinish := FaoFinishStack[FiStack];

  if Assigned( FoCurrentState) then
    FoCurrentState.AddLambdaTransitionTo( FaoStartStack[FiStack]);
  FoCurrentState := FaoStartStack[FiStack];
end;

procedure TmlRegularExpression.FinishGroup;
begin
  if FiStack<0 then
    raise EmlRegularExpressionError.Create('Extra '')'' found');

  FoCurrentState.AddLambdaTransitionTo( FaoFinishStack[FiStack]);
  FoCurrentState := FaoFinishStack[FiStack];
  Dec( FiStack);
end;

procedure TmlRegularExpression.AddBranch;
begin
  FoCurrentState.AddLambdaTransitionTo( FaoFinishStack[FiStack]);
  FoCurrentState := FaoStartStack[FiStack];
end;

procedure TmlRegularExpression.AddRepetition;
var
  iIndex: integer;
begin
  if FoCurrentState.StateType=stGroupFinish then
    FoCurrentState.AddLambdaTransitionTo( FoCurrentState.GroupStart)
  else if FoCurrentState.StateType=stGroupStart then
    raise EmlRegularExpressionError.Create( '''+'' and ''*'' cannot occur at the start of an expression or follow ''(''')
  else with FoCurrentState do
    for iIndex := 0 to PriorStateCount-1 do
      AddLambdaTransitionTo( PriorStates[iIndex]);
end;

procedure TmlRegularExpression.AddOptional;
var
  iIndex: integer;
begin
  if FoCurrentState.StateType=stGroupFinish then
    FoCurrentState.GroupStart.AddLambdaTransitionTo( FoCurrentState)
  else if FoCurrentState.StateType=stGroupStart then
    raise EmlRegularExpressionError.Create( '''?'' and ''*'' cannot follow ''(''')
  else with FoCurrentState do
    for iIndex := 0 to PriorStateCount-1 do
      PriorStates[iIndex].AddLambdaTransitionTo( FoCurrentState);
end;

procedure TmlRegularExpression.StartRange;
begin
  FxCharRange := [];
  FbInvertedSet := false;
  FsPartialChars := '';
  FbIsRange := false;
  FeState := psCharRange;
end;

// Optimization Methods
// --------------------

procedure TmlRegularExpression.Optimize;
begin
  if mfCaseInsensitive in FxFlags then
    MakeCaseInsensitive;
  Simplify;
  CalculateFirstSets;
  MakeDeterministic;
  CalculateFirstSets;
end;

procedure TmlRegularExpression.MakeCaseInsensitive;
var
  iScan: integer;
begin
  for iScan := 0 to StateCount-1 do
    States[iScan].MakeCaseInsensitive;
end;

procedure TmlRegularExpression.Simplify;
begin
  PropagateAcceptedFlags;
  CollapseIdenticalStates;
  RemoveLambdaTransitions;
  CollapseIdenticalStates;
  if Assigned( StartState) then
    RemoveRedundantStates( StartState)
  else RemoveRedundantStates( States[0]);
end;

procedure TmlRegularExpression.MakeDeterministic;
begin
  FoStartState := NewState( stNormal);
  FoStartState.AddState( States[0]);
  FoStartState.Closure;
  CollapseIdenticalStates;
  RemoveRedundantStates( FoStartState);
end;

procedure TmlRegularExpression.PropagateAcceptedFlags;
var
  iScan:    integer;
  oState:   TmlRegularExpressionState;
  bDone:    boolean;
begin
  repeat
    bDone := true;
    for iScan := 0 to FoStates.Count-1 do begin
      oState := FoStates[iScan] as TmlRegularExpressionState;
      if not oState.Accept then begin
        oState.CheckIfAccept;
        bDone := bDone and not oState.Accept;
      end;
    end;
  until bDone;
end;

procedure TmlRegularExpression.RemoveRedundantStates( oStart: TmlRegularExpressionState);
var
  iScan:    integer;
  oState:   TmlRegularExpressionState;
begin
  // Remove any redundant states
  for iScan := 0 to StateCount-1 do
    States[iScan].Reachable := false;
  oStart.MarkReachable;

  for iScan := StateCount-1 downto 0 do begin
    oState := States[iScan];
    if not oState.Reachable then
      FoStates.Remove( oState);
  end;
end;

procedure TmlRegularExpression.CollapseIdenticalStates;
var
  iScan:    integer;
  bDone:    boolean;
  iIndex:   integer;
begin
  repeat
    bDone := true;
    for iScan := 0 to StateCount-1 do begin
      for iIndex := iScan+1 to StateCount-1 do begin
        if States[iScan].EqualState( States[iIndex])
           and (States[iScan].TransitionCount>0) then begin
          // Two states are identical - replace entry transitions to State[iIndex] with
          // entry transitions to States[iScan]
          States[iIndex].ChangeEntryTransitions( States[iScan]);
          if StartState = States[iIndex] then
            FoStartState := States[iScan];
          bDone := false;
        end;
      end;
    end;
    if Assigned( StartState) then
      RemoveRedundantStates(StartState)
    else RemoveRedundantStates(States[0]);
  until bDone;
end;

procedure TmlRegularExpression.RemoveLambdaTransitions;
var
  iScan:    integer;
  oState:   TmlRegularExpressionState;
  bDone:    boolean;
  bChanged: boolean;
begin
  repeat
    bDone := true;
    for iScan := 0 to FoStates.Count-1 do begin
      oState := FoStates[iScan] as TmlRegularExpressionState;
      bChanged := false;
      oState.RemoveLambdaTransitions( bChanged);
      bDone := bDone and not bChanged;
    end;
  until bDone;
end;

procedure TmlRegularExpression.CalculateFirstSets;
var
  iScan: integer;
begin
  for iScan := 0 to StateCount-1 do
    States[iScan].CalculateFirstSet;
end;

// Property Methods
// ----------------

function TmlRegularExpression.GetStateCount: integer;
begin
  Result := FoStates.Count;
end;

function TmlRegularExpression.GetStateByIndex( iIndex: integer): TmlRegularExpressionState;
begin
  Result := FoStates[iIndex] as TmlRegularExpressionState;
end;

function TmlRegularExpression.GetMatchCount: integer;
begin
  Result := FoMatches.Count;
end;

function TmlRegularExpression.GetMatchStartByIndex( iIndex: integer): integer;
begin
  Result := TmlRegularExpressionMatcher( FoMatches[iIndex]).Start;
end;

function TmlRegularExpression.GetMatchFinishByIndex( iIndex: integer): integer;
begin
  Result := TmlRegularExpressionMatcher( FoMatches[iIndex]).Finish;
end;

function TmlRegularExpression.GetMatchSizeByIndex( iIndex: integer): integer;
begin
  with TmlRegularExpressionMatcher( FoMatches[iIndex]) do
    Result := Finish - Start +1;
end;

// Description Methods
// -------------------

procedure TmlRegularExpression.DumpStateTable( oStrings: TStrings);
var
  iScan:  integer;
  oState: TmlRegularExpressionState;
begin
  oStrings.Append('Start from '+ StartState.Name);
  oStrings.Append('');
  for iScan := 0 to FoStates.Count-1 do begin
    oState := FoStates[iScan] as TmlRegularExpressionState;
    oState.DumpDescription( oStrings);
  end;
end;

// ===============================================================================================
// Object: TmlRegularExpressionMatcher
// ===================================

constructor TmlRegularExpressionMatcher.Create( oOwner: TmlRegularExpression;
                                                xFlags: TmlRegularExpressionMatchFlags);
var
  eScan:  char;
  oState: TmlRegularExpressionState;
begin
  inherited Create;

  FoExpression := oOwner;
  FeStatus := mrNone;
  FxFlags := xFlags;
  FoStates := TList.Create;
  FoStates.Capacity := oOwner.StateCount;

  oState := oOwner.StartState;
  for eScan := Low(char) to High(char) do
    FabFirstSet[eScan] := oState.CanStart( eScan);
end;

destructor TmlRegularExpressionMatcher.Destroy;
begin
  FoStates.Free;

  inherited Destroy;
end;

function TmlRegularExpressionMatcher.Match( sString: string;
                                            iStart: integer): TmlRegularExpressionMatchResult;
var
  bDone:   boolean;
  iCursor: integer;
  iLength: integer;
  oState:  TmlRegularExpressionState;

  bLongestMatch: boolean;
  bFinishOnly:   boolean;
begin
  if (Length( sString)>iStart-1) and FabFirstSet[ sString[iStart]] then begin
    FiStart := iStart;
    iCursor := iStart;
    iLength := Length( sString);

    bLongestMatch := mfLongestMatch in FxFlags;
    bFinishOnly := mfFinishOnly in FxFlags;
    
    oState := FoExpression.StartState;

    bDone := false;
    while not bDone and (iCursor<=iLength) do begin

      oState := oState.GetSuccessor( sString[iCursor]);

      if Assigned( oState) then begin
        if oState.Accept and (not bFinishOnly or (iCursor=iLength)) then begin
          FiFinish := iCursor;
          FeStatus := mrMatch;
          bDone := not bLongestMatch;
        end
      end
      else begin
        if FeStatus=mrNone then
          FeStatus := mrFail;
        bDone := true;
      end;
      
      Inc( iCursor);
    end;

    if FeStatus=mrNone then
      FeStatus := mrInsufficient;
    Result := FeStatus;
  end
  else
    Result := mrFail;
end;

// ===============================================================================================
// Object: TmlRegularExpressionState
// =================================

// Standard Methods
// ----------------

constructor TmlRegularExpressionState.Create( oExpression: TmlObject;
                                              eType: TmlRegularExpressionStateType = stNormal);
var
  cScan: char;
begin
  inherited Create;

  FoExpression := oExpression;

  FoTransitions := TmlList.Create;
  FbFindingTransitions := false;

  FoPriorStates := TmlList.Create;

  FeStateType := eType;

  Inc( GiStateCount);
  FiStateNumber := GiStateCount;
  FbAccept := false;
  FbReachable := false;

  for cScan := Low(char) to High(char) do
    FaoSuccessor[cScan] := nil;

  FoStates := TmlList.Create;
end;

destructor TmlRegularExpressionState.Destroy;
begin

  // Transitions in this list are reference counted
  FoTransitions.Free;

  // States in this list are reference counted
  FoPriorStates.Free;

  // Will discard references to our contained states
  FoStates.Free;

  inherited Destroy;
end;

procedure TmlRegularExpressionState.FreeRefs;
begin

  inherited FreeRefs;
end;

// Transition Methods
// ------------------

procedure TmlRegularExpressionState.AddTransitionTo( oState: TmlRegularExpressionState;
                                                     xCharacters: TCharset);
var
  oTransition: TmlRegularExpressionTransition;
  iScan:       integer;
  bFound:       boolean;
begin
  bFound := false;
  for iScan := 0 to TransitionCount-1 do begin
    oTransition := Transitions[iScan];
    if oTransition.Destination = oState then begin
      if (xCharacters - oTransition.Characters)<>[] then begin
        // We have new information, so add it to the transition
        oTransition.AddCharacters( xCharacters);
        Modified := true;
      end;
      bFound := true;
    end;
  end;

  if not bFound then begin
    TmlRegularExpressionTransition.Create( self, oState, xCharacters, false);
    Modified := true;
  end;
end;

procedure TmlRegularExpressionState.AddLambdaTransitionTo( oState: TmlRegularExpressionState);
var
  oTransition: TmlRegularExpressionTransition;
  iScan:       integer;
  bFound:       boolean;
begin
  bFound := (oState=self);
  if not bFound then
    for iScan := 0 to TransitionCount-1 do begin
      oTransition := Transitions[iScan];
      if oTransition.Destination = oState then begin
        if not oTransition.Lambda then begin
          oTransition.Lambda := true;
          Modified := true;
        end;
        bFound := true;
      end;
    end;

  if not bFound then begin
    TmlRegularExpressionTransition.Create( self, oState, [], true);
    Modified := true;
  end;
end;

procedure TmlRegularExpressionState.RemoveTransitionTo( oState: TmlRegularExpressionState;
                                                        xCharacters: TCharset);
var
  oTransition: TmlRegularExpressionTransition;
  iScan:       integer;
begin
  for iScan := 0 to TransitionCount-1 do begin
    oTransition := Transitions[iScan];
    if oTransition.Destination = oState then begin
      // Found the transition - remove the characters required
      oTransition.Characters := oTransition.Characters - xCharacters;
      if oTransition.Characters=[] then begin
        // Nothing left of this transition
        oTransition.FreeRefs;
        Modified := true;
      end;
      break;
    end;
  end;
end;

procedure TmlRegularExpressionState.GetTransitionsOn( cChar: char; oStateList: TList);
var
  iScan: integer;
  oTransition: TmlRegularExpressionTransition;
begin
  if not FbFindingTransitions then begin
    FbFindingTransitions := true;
    try
      for iScan := 0 to TransitionCount-1 do begin
        oTransition := Transitions[iScan];
        if cChar in oTransition.Characters then
          if oStateList.IndexOf( oTransition.Destination)=-1 then
            oStateList.Add( oTransition.Destination);
        if oTransition.Lambda then
          oTransition.Destination.GetTransitionsOn( cChar, oStateList);
      end;
    finally
      FbFindingTransitions := false;
    end;
  end;
end;

function TmlRegularExpressionState.GetOnlyTransitionOn( cChar: char): TmlRegularExpressionState;
var
  oList: TList;
begin
  oList := TList.Create;
  try
    GetTransitionsOn( cChar, oList);
    if oList.Count=1 then
      Result := TObject(oList.First) as TmlRegularExpressionState
    else Result := nil;
  finally
    oList.Free;
  end;
end;

function TmlRegularExpressionState.FindImmediateTransitionOn( cChar: char): TmlRegularExpressionState;
var
  iScan: integer;
  oTransition: TmlRegularExpressionTransition;
begin
  Result := nil;
  for iScan := 0 to TransitionCount-1 do begin
    oTransition := Transitions[iScan];
    if cChar in oTransition.Characters then
      if Result=nil then
        // On first match, remember it
        Result := oTransition.Destination
      else begin
        // On second match, return nil and break loop
        Result := nil;
        break;
      end;
  end;
end;

// Optimization Methods
// --------------------

procedure TmlRegularExpressionState.MakeCaseInsensitive;
var
  iScan: integer;
  cScan: char;
begin
  for iScan := 0 to TransitionCount-1 do
    with Transitions[iScan] do begin
      for cScan := 'A' to 'Z' do
        if cScan in Characters then
          AddCharacters( [Char( Ord(cScan) + 32)]);
      for cScan := 'a' to 'z' do
        if cScan in Characters then
          AddCharacters( [Char( Ord(cScan) - 32)]);
    end;
end;

procedure TmlRegularExpressionState.CheckIfAccept;
var
  iScan: integer;
begin
  for iScan := 0 to TransitionCount-1 do begin
    if Transitions[iScan].Lambda and Transitions[iScan].Destination.Accept then
      Accept := true;
  end;
end;

procedure TmlRegularExpressionState.RemoveLambdaTransitions( var bChanged: boolean);
var
  iScan:           integer;
  oTransition:     TmlRegularExpressionTransition;
  iIndex:          integer;
  oLambdaState:    TmlRegularExpressionState;
  oExitTransition: TmlRegularExpressionTransition;
begin
  CheckIfAccept;
  // First add all the transitions available by taking the lambda transitions from here
  repeat
    // Modified is automatically changed whenever an exit transition is changed or added
    Modified := false;
    iScan := 0;
    while iScan<=TransitionCount-1 do begin
      oTransition := Transitions[iScan];
      if oTransition.Lambda then begin
        // Replace this lambda transition with direct transitions to the states accessible
        // from this transitions target
        oLambdaState := oTransition.Destination;
        for iIndex := 0 to oLambdaState.TransitionCount-1 do begin
          oExitTransition := oLambdaState.Transitions[iIndex];
          if oExitTransition.Characters<>[] then
            AddTransitionTo( oExitTransition.Destination, oExitTransition.Characters);
          if oExitTransition.Lambda then
            AddLambdaTransitionTo( oExitTransition.Destination);
        end;
        Inc( iScan);
        bChanged := true;
      end
      else
        Inc( iScan);
    end;
  until not Modified;

  // Now remove the lambda transitions themselves

  for iScan := TransitionCount-1 downto 0 do begin
    oTransition := Transitions[iScan];
    if oTransition.Lambda then
      if oTransition.Characters<>[] then
        oTransition.Lambda := false
      else oTransition.FreeRefs;
  end;
end;

procedure TmlRegularExpressionState.MakeDeterministic( var bChanged: boolean);
var
  iScan:   integer;
  iIndex:  integer;
  xCommon: TCharSet;
  oState:  TmlRegularExpressionState;
  oScanTransition: TmlRegularExpressionTransition;
  oIndexTransition: TmlRegularExpressionTransition;
begin
  iScan := 0;
  // Scan through all but 1 transition - we compare all the others to iScan
  while iScan < TransitionCount-1 do begin
    oScanTransition := Transitions[iScan];
    for iIndex := TransitionCount-1 downto iScan+1 do begin
      oIndexTransition := Transitions[iIndex];
      xCommon := oScanTransition.Characters * oIndexTransition.Characters;
      if xCommon<>[] then begin
        // Found nondeterministic characters
        oState := (FoExpression as TmlRegularExpression).NewState( stNormal);
        oState.AddLambdaTransitionTo( oScanTransition.Destination);
        RemoveTransitionTo( oScanTransition.Destination, xCommon);
        oState.AddLambdaTransitionTo( oIndexTransition.Destination);
        RemoveTransitionTo( oIndexTransition.Destination, xCommon);
        AddTransitionTo( oState, xCommon);
        oState.RemoveLambdaTransitions( bChanged);
      end;
    end;
    Inc( iScan);
  end;
end;

procedure TmlRegularExpressionState.MarkReachable;
var
  iScan: integer;
begin
  if not FbReachable then begin
    FbReachable := true;
    for iScan := 0 to TransitionCount-1 do
      Transitions[iScan].Destination.MarkReachable;
  end;
end;

function TmlRegularExpressionState.EqualState( oState: TmlRegularExpressionState): boolean;
var
  iScan: integer;
begin
  Result := (oState.TransitionCount = TransitionCount)
            and (oState.Accept=Accept);
  if Result then
    for iScan := 0 to TransitionCount-1 do begin
      if not oState.ContainsTransition( Transitions[iScan]) then begin
        Result := false;
        break;
      end;
    end;
end;

function TmlRegularExpressionState.ContainsTransition( oTransition: TmlRegularExpressionTransition): boolean;
var
  iScan: integer;
  oOurTransition: TmlRegularExpressionTransition;
begin
  if oTransition.Lambda then
    Result := false
  else begin
    oOurTransition := nil;
    for iScan := 0 to TransitionCount-1 do
      if Transitions[iScan].Destination = oTransition.Destination then begin
        oOurTransition := Transitions[iScan];
        break;
      end;

    if Assigned( oOurTransition) and not oOurTransition.Lambda then
      Result := oOurTransition.Characters = oTransition.Characters
    else
      Result := false;
  end;
end;

procedure TmlRegularExpressionState.ChangeEntryTransitions( oNewState: TmlRegularExpressionState);
var
  iScan: integer;
begin
  for iScan := FoPriorStates.Count-1 downto 0 do
    (FoPriorStates[iScan] as TmlRegularExpressionState).RedirectTransition( self, oNewState);
end;

procedure TmlRegularExpressionState.RedirectTransition( oOldState: TmlRegularExpressionState;
                                                        oNewState: TmlRegularExpressionState);
var
  iScan:       integer;
  oTransition: TmlRegularExpressionTransition;
begin
  oTransition := nil;
  for iScan := 0 to TransitionCount-1 do
    if Transitions[iScan].Destination=oOldState then begin
      oTransition := Transitions[iScan];
      break;
    end;
  Assert( Assigned( oTransition), 'TmlRegularExpressionState.RedirectTransition '
                                  +'Could not find required transition.');
  AddTransitionTo( oNewState, oTransition.Characters);
  if oTransition.Lambda then
    AddLambdaTransitionTo( oNewState);

  Assert( oOldState.FoPriorStates.IndexOf(self)<>-1, 'TmlRegularExpressionState.RedirectTransition: '
                                                     +' No reference to self as prior state');
  oTransition.FreeRefs;
end;

procedure TmlRegularExpressionState.CalculateFirstSet;
var
  iScan: integer;
  cScan: char;
  xFirstSet: set of char;
begin
  xFirstSet := [];
  for iScan := 0 to TransitionCount-1 do
    xFirstSet := xFirstSet + Transitions[iScan].Characters;

  for cScan := Low(char) to High(char) do
    FabFirstSet[cScan] := cScan in xFirstSet;
end;

// Operation Methods
// -----------------

function TmlRegularExpressionState.GetSuccessor( cChar: char): TmlRegularExpressionState;
var
  iScan: integer;
begin
  if FabFirstSet[cChar] then begin
    if not Assigned( FaoSuccessor[cChar]) then begin
      for iScan := 0 to TransitionCount-1 do
        if cChar in Transitions[iScan].Characters then begin
          FaoSuccessor[cChar] := Transitions[iScan].Destination;
          break;
        end;
    end;
    Assert( Assigned( FaoSuccessor[cChar]), 'TmlRegularExpressionState.GetSuccessor: '
                                            +'No state found for character in first set');
    Result := FaoSuccessor[cChar];
  end
  else
    Result := nil;
end;

function TmlRegularExpressionState.CanStart( cChar: char): boolean;
begin
  Result := FabFirstSet[cChar];
end;

// Description Methods
// -------------------

function TmlRegularExpressionState.Name: string;
begin
  if Accept then
    Result := Format('[[%d]]', [StateNumber])
  else
    Result := Format('(%d)', [StateNumber])
end;

procedure TmlRegularExpressionState.DumpDescription( oStrings: TStrings);
var
  iScan: integer;
  oTransition: TmlRegularExpressionTransition;
begin
  oStrings.Append( Name);
  for iScan := 0 to FoTransitions.Count-1 do begin
    oTransition :=  FoTransitions[iScan] as TmlRegularExpressionTransition;
    oStrings.Append( oTransition.Description);
  end;
  oStrings.Append('');
end;

// DFA Production Methods
// ----------------------

procedure TmlRegularExpressionState.AddState( oState: TmlRegularExpressionState);
begin
  FoStates.Add( oState);
  if oState.Accept then
    Accept := true;
end;

procedure TmlRegularExpressionState.Closure;
var
  axTransitionSets: array of TCharSet;
  iSetCount:        integer;

  procedure AddSet( xSet: TCharSet);
  begin
    if iSetCount>=Length( axTransitionSets) then
      SetLength( axTransitionSets, iSetCount + 25);
    axTransitionSets[iSetCount] := xSet;
    Inc( iSetCount);
  end;

var
  iState:            integer;
  oState:            TmlRegularExpressionState;
  iTransition:       integer;
  oTransition:       TmlRegularExpressionTransition;
  xSet:              TCharSet;
  iScan:             integer;
  iIndex:            integer;
begin
  iSetCount := 0;

  // First work out the disjoint sets of exit transitions

  for iState := 0 to FoStates.Count-1 do begin
    oState := FoStates[iState] as TmlRegularExpressionState;
    for iTransition := 0 to oState.TransitionCount-1 do begin
      oTransition := oState.Transitions[iTransition];
      AddSet( oTransition.Characters);
    end;
  end;

  iScan := 0;
  while iScan < iSetCount do begin
    iIndex := iScan+1;
    while iIndex < iSetCount do begin
      xSet := axTransitionSets[iScan] * axTransitionSets[iIndex];
      if xSet<>[] then begin
        AddSet( xSet);
        axTransitionSets[iIndex] := axTransitionSets[iIndex] - xSet;
        axTransitionSets[iScan] := axTransitionSets[iScan] - xSet;
      end;
      Inc( iIndex);
    end;
    Inc( iScan);
  end;

  iScan := 0;
  iIndex := 0;
  while iScan < iSetCount do begin
    if axTransitionSets[iScan] <> [] then begin
      axTransitionSets[iIndex] := axTransitionSets[iScan];
      Inc( iIndex);
    end;
    Inc( iScan);
  end;
  iSetCount := iIndex;

  SetLength( axTransitionSets, iSetCount);

  // For each set we have, find the new state to move to and create the transition

  for iScan := 0 to iSetCount-1 do
    ConstructTransition( axTransitionSets[iScan]);
end;

function TmlRegularExpressionState.ContainsState( oState: TmlRegularExpressionState): boolean;
begin
  Result := FoStates.IndexOf( oState)<>-1; 
end;

// Property Methods
// ----------------

procedure TmlRegularExpressionState.SetGroupStart( oGroupStart: TmlRegularExpressionState);
begin
  Assert( StateType=stGroupFinish, 'TmlRegularExpressionState.SetGroupStart: '
                                   +'Can only set GroupStart on Group Finish states');
  if FoGroupStart<>oGroupStart then begin
    FoGroupStart := oGroupStart;
    FoGroupStart.GroupFinish := self;
  end;
end;

procedure TmlRegularExpressionState.SetGroupFinish( oGroupFinish: TmlRegularExpressionState);
begin
  Assert( StateType=stGroupStart, 'TmlRegularExpressionState.SetGroupFinish: '
                                  +'Can only set GroupFinish on Group Start states');
  if FoGroupFinish<>oGroupFinish then begin
    FoGroupFinish := oGroupFinish;
    FoGroupFinish.GroupStart := self;
  end;
end;

function TmlRegularExpressionState.GetPriorState( iIndex: integer): TmlRegularExpressionState;
begin
  Result := FoPriorStates[iIndex] as TmlRegularExpressionState;
end;

function TmlRegularExpressionState.GetPriorStateCount: integer;
begin
  Result := FoPriorStates.Count;
end;

function TmlRegularExpressionState.GetTransitionCount: integer;
begin
  Result := FoTransitions.Count;
end;

function TmlRegularExpressionState.GetTransitionByIndex( iIndex: integer): TmlRegularExpressionTransition;
begin
  Result := FoTransitions[iIndex] as TmlRegularExpressionTransition;
end;

function TmlRegularExpressionState.GetStateCount: integer;
begin
  Result := FoStates.Count;
end;

// Internal Methods
// ----------------

procedure TmlRegularExpressionState.ConstructTransition( xSet: TCharSet);
var
  cScan:   char;
  oStates: TList;
  oState:  TmlRegularExpressionState;
  iScan:   integer;
begin
  oStates := TList.Create;
  try
    for cScan := Low(Char) to High(Char) do
      if cScan in xSet then begin
        for iScan := 0 to FoStates.Count-1 do
          (FoStates[iScan] as TmlRegularExpressionState).GetTransitionsOn( cScan, oStates);
      end;
    oState := (FoExpression as TmlRegularExpression).GetDFAState( oStates);
    AddTransitionTo( oState, xSet);
  finally
    oStates.Free;
  end;
end;

// ===============================================================================================
// Object: TmlRegularExpressionTransition
// ======================================

// Standard Methods
// ----------------

constructor TmlRegularExpressionTransition.Create( oSource:      TmlRegularExpressionState;
                                                   oDestination: TmlRegularExpressionState;
                                                   xCharacters:  TCharSet;
                                                   bLambda:      boolean);
begin
  inherited Create;

  FoSource := oSource;
  FoDestination := oDestination;
  FxCharSet := xCharacters;
  FbLambda := bLambda;

  oSource.FoTransitions.Add( self);
  Assert( oDestination.FoPriorStates.IndexOf( oSource)=-1,
          'TmlRegularExpressionTransition.Create: Transition created for established link');
  oDestination.FoPriorStates.Add( oSource);
end;

procedure TmlRegularExpressionTransition.FreeRefs;
begin
  Source.FoTransitions.Remove( self);
  Destination.FoPriorStates.Remove( Source);

  inherited FreeRefs;
end;

procedure TmlRegularExpressionTransition.AddCharacters( xCharacters: TCharSet);
begin
  FxCharSet := FxCharSet + xCharacters;
end;

// Description Methods
// -------------------

function TmlRegularExpressionTransition.Description: string;
var
  eScan: char;
begin
  Result := '    To '+Destination.Name+' on [';
  for eScan := Low(char) to High(char) do
    if eScan in Characters then
      Result := Result + eScan;
  Result := Result + ']';
  if Lambda then
    Result := Result + '/Lambda';
end;

// ===============================================================================================

initialization
  GiStateCount := 0;

end.
