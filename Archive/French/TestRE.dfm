�
 TFMTESTRE 0�T  TPF0	TfmTestREfmTestRELeft� Top[WidthHeight�BorderIconsbiSystemMenu CaptionProgramme de Test pour TRegExprColor	clBtnFaceConstraints.MinHeight�Constraints.MinWidth^Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder	PositionpoScreenCenterScaledOnCreate
FormCreate	OnDestroyFormDestroyPixelsPerInch`
TextHeight TSpeedButtonbtnHelpLeftzTop�WidthHeightHint&Affiche l'aide dans
la langue choisieAnchorsakRightakBottom Flat	
Glyph.Data
z  v  BMv      v   (                                    �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 33333333333���3333?y33333�77?�33;����3337swsw?33��y��33s3733s�;������37�33�37�?������37337�37?����{���337�33��������337�3��������333w�3��w�y���3?�73����y���s�w�73s?��y��37�w��s7�;������37?7ww3733������33s�ws?s33;����3337s��w3333?��333337ww333	NumGlyphsParentShowHintShowHint	OnClickbtnHelpClick  TBevelBevel1LeftTop�Width|HeightAnchorsakLeftakBottom Shape	bsTopLineStylebsRaised  TLabellblWWWLeftTop�WidthfHeightCursorcrHandPointHint#Go to TRegExpr web-page in InternetAnchorsakLeftakBottom CaptionPage Web TRegExprColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclGrayFont.Height�	Font.NameMS Sans Serif
Font.Style ParentColor
ParentFontParentShowHintShowHint	OnClicklblWWWClick  TBitBtnbtnCloseLeft�Top�WidthkHeightHintQuitte l'applicationAnchorsakRightakBottom Cancel	Caption&QuitterFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontParentShowHintShowHint	TabOrderOnClickbtnCloseClick
Glyph.Data
z  v  BMv      v   (   @                                    �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� 3     3wwwww333     30     333����33333333����30333���33333333���30333���33333333���30333��33333333��30333��33333333��30333��3333?333��30333��3333s333��30333��33333333��30333��33���333��30333���37ww�333���30���333��37���333��30���333��37ww3333��30���333���33333333���30333���3����333���30333     3wwwwws333     30     33	NumGlyphsSpacing�  	TGroupBox
grpRegExprLeftTop WidthHeight�AnchorsakLeftakTopakRightakBottom TabOrder  TPageControlPageControl1LeftTop>WidthHeightd
ActivePagetabExpressionAlignalClientTabOrder  	TTabSheettabExpressionCaption &Expression  	TSplitter	Splitter3Left Top� Width�HeightCursorcrVSplitAlignalTopAutoSnapBeveled	MinSizex  TPanel
pnlRegExprLeft Top Width�Height� AlignalTop
BevelOuterbvNoneTabOrder  TLabel
lblRegExprLeftTop0WidthcHeightCaptionExpression R�guli�reFocusControl	edRegExpr  TLabellblRegExprUnbalancedBracketsLeft� Top0Width� HeightCaptionlblRegExprUnbalancedBracketsFont.CharsetDEFAULT_CHARSET
Font.ColorclPurpleFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontLayouttlCenter
OnDblClick$lblRegExprUnbalancedBracketsDblClick  TLabel
edSubExprsLeftTop� WidthYHeightAnchorsakLeftakBottom CaptionSous-Expressions :FocusControl
cbSubExprs  TSpeedButtonbtnViewPCodeLeft�Top� WidthRHeightHintUAffiche les "P-code" de r.e.
pour d�bugger TRegExpr et
comprendre le moteur interneAnchorsakRightakBottom CaptionP-codeFlat	
Glyph.Data

    BM      v   (   (            �                       �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� 33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333?��3?��333  33  3333ww�3ww�330360363?7�77�730��0��3s7�37�3030��0?�7�7�3��3030?�p?�7�7��ww��03  0   s7�www7wwws00s3330337�s3337?w3733333 337w33333w33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333	NumGlyphsParentShowHintShowHint	Spacing�OnClickbtnViewPCodeClick  	TGroupBoxgbModifiersLeftTopWidth�Height$AnchorsakLeftakTopakRight Caption Modifieurs Globaux TabOrder  	TCheckBoxchkModifierILeftTopWidth)HeightHint'Majuscule et Minuscule non diff�renci�sTabStopCaption/iParentShowHintShowHint	TabOrder OnClickchkModifierIClick  	TCheckBoxchkModifierRLeft TopWidthaHeightTabStopCaptionS�lection RusseTabOrderOnClickchkModifierRClick  	TCheckBoxchkModifierSLeftXTopWidth)HeightHintwSi ACTIF, alors '.' veut dire
n'importe quel caract�re.
Si INACTIF alors '.' n'inclus pas
les s�parateurs de lignes.TabStopCaption/sParentShowHintShowHint	TabOrderOnClickchkModifierSClick  	TCheckBoxchkModifierGLeft� TopWidthAHeightHintnSi ACTIF, l'expression fonctionne
en mode vorace.

Si INACTIF, l'expression fonctionne
en mode non vorace.TabStopCaptionVoraceParentShowHintShowHint	TabOrderOnClickchkModifierGClick  	TCheckBoxchkModifierMLeft0TopWidth)HeightHint�Si ACTIF alors '^' / '$' correspond
� chaque d�but / fin de ligne.

Si INACTIF,  alors correspond seulement
 au d�but / fin du texte complet.TabStopCaption/mParentShowHintShowHint	TabOrderOnClickchkModifierMClick  	TCheckBoxchkModifierXLeft� TopWidth)HeightHint~Si ACTIF, la syntaxe �tendue des
commentaires est disponible.

Si INACTIF,  pas de commentaire
possible dans l'expression.TabStopCaption/xParentShowHintShowHint	TabOrderOnClickchkModifierXClick   TMemo	edRegExprLeft Top@Width�HeightOAnchorsakLeftakTopakRightakBottom Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Style Lines.Strings	edRegExpr 
ParentFont
ScrollBarsssBothTabOrderWordWrapOnChangeedRegExprChangeOnClickedRegExprClick	OnKeyDownedRegExprKeyDownOnKeyUpedRegExprKeyDown  	TComboBox
cbSubExprsLeftjTop� Width;HeightHintSous-ExpressionsTabStopStylecsDropDownListAnchorsakLeftakRightakBottom Color	clBtnFace
ItemHeightParentShowHintShowHint	TabOrderOnClickcbSubExprsClick   TPanelpnlInputStringsLeft Top� Width�Height� AlignalClient
BevelOuterbvNoneTabOrder TLabellblInputStringLeftTopWidthTHeightCaptionCha�ne d'entr�e :FocusControledInputString  TLabellblInputStringPosLeftxTopWidth]HeightCaptionS�lection Courante:FocusControledInputStringPos  TLabellblTestResultLeft TopmWidth� Height(HintXR�sultat de la derni�re ex�cution,
position, et sous-expression de la
cha�ne d'entr�e.AnchorsakLeftakRightakBottom AutoSizeCaptionLa cha�ne n'est pas test�eColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold ParentColor
ParentFontParentShowHintShowHint	WordWrap	  TMemoedInputStringLeft TopWidth�HeightVAnchorsakLeftakTopakRightakBottom Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Lines.StringsedInputString 
ParentFont
ScrollBarsssBothTabOrder WordWrapOnChangeedInputStringClickOnClickedInputStringClick	OnKeyDownedInputStringKeyDownOnKeyUpedInputStringKeyDownOnMouseDownedInputStringMouseDownOnMouseMoveedInputStringMouseMove	OnMouseUpedInputStringMouseDown  TEditedInputStringPosLeft� Top Width� HeightTabStopColor	clBtnFaceReadOnly	TabOrderTextedInputStringPos  TBitBtnbtnTestStringLeft TopqWidthIHeight!Hint(Ex�cure e.r. pour la premi�re recherche.AnchorsakLeftakBottom CaptionE&xecDefault	ParentShowHintShowHint	TabOrderOnClickbtnTestStringClick
Glyph.Data
j  f  BMf      v   (               �                       �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� 3333333333  3333333 33  3333333333  3333333 33  333333 33  0 3333303   33303 3  0� 33300  3   3  3  30���333  33 x��p333  33����s33  33����33  33����33  33����33  33w���s33  330w��p333  333ww333  3337 3333  3333333333  Spacing�  TBitBtnbtnExecNextLeftITopqWidthbHeight!HintEx�cute la recherche suivanteAnchorsakLeftakBottom Caption	Exec&SuivParentShowHintShowHint	TabOrderOnClickbtnExecNextClick
Glyph.Data
j  f  BMf      v   (               �                       �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� 3333333333  3333333333  3333000  3333000  3033333333  3 3333333  0� 3333333  3 333333  30�   s333  33 x�p333  330���33  330x���w33  330�����33  330x����33  330x����33  337w���w33  333x��33  3330wwp333  3333p s333  3333333333  Spacing�  TBitBtnbtnFindRegExprInFileLeft� TopqWidthKHeight!Hint-Ex�cute l'expression r�guli�re sur un fichierAnchorsakLeftakBottom Caption&FichierParentShowHintShowHint	TabOrderOnClickbtnFindRegExprInFileClick
Glyph.Data
F  B  BMB      v   (               �                       �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� wwwwwwwwp   p    wwwp   p����wwp    p�ww�ww     p�ww�wp p   p�w� � p   p�p�  wp   p���wp   p� wp   p����pwp   p�� pwp   p ���pwp   wx   wp   ww wwxwp   wwpw wwp   www� �wwp   wwwwwwwwp   Spacing�  	TComboBox	cbSubStrsLeft TopzWidth� HeightStylecsDropDownListAnchorsakLeftakRightakBottom Color	clBtnFace
ItemHeightTabOrderVisibleOnClickcbSubStrsClick    	TTabSheettabSubstituteCaption &Substitution 
ImageIndex 	TSplitter	Splitter2Left Top� Width�HeightCursorcrVSplitAlignalTopAutoSnapBeveled	MinSize2  TPanelpnlSubstitutionCommentLeft Top Width�Height'AlignalTop
BevelOuterbvNoneColorclBtnShadowTabOrder  TLabellblSubstitutionCommentLeftTopWidth�HeightAnchorsakLeftakTopakRightakBottom AutoSizeCaptionsUtiliser '$&&' dans gabarit de substution at '$n' ou '${n}' pour la substution de num�ros dans la sous-expression .Font.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontWordWrap	   TPanelpnlSubstitutionTemplateLeft Top'Width�HeightZAlignalTop
BevelOuterbvNoneTabOrder TLabellblSubstitutionTemplateLeftTopWidthkHeightCaptionGabarit de SubstutitionFocusControlmemSubstitutionTemplate  TMemomemSubstitutionTemplateLeftTopWidth�HeightGAnchorsakLeftakTopakRightakBottom 
ScrollBars
ssVerticalTabOrder    TPanelpnlSubstitutionResultLeft Top� Width�Height� AlignalClient
BevelOuterbvNoneTabOrder TLabellblSubstitutionResultLeftTopWidth{HeightCaptionR�sultat de la SubstitutionFocusControlmemSubstitutionResult  TMemomemSubstitutionResultLeft TopWidth�Height� TabStopAnchorsakLeftakTopakRightakBottom Color	clBtnFaceReadOnly	
ScrollBars
ssVerticalTabOrder     	TTabSheet
tabReplaceCaption Rem&placement 
ImageIndex 	TSplitter	Splitter1Left Top� Width�HeightCursorcrVSplitAlignalTopAutoSnapBeveled	MinSize2  TPanelpnlReplaceCommentLeft Top Width�Height'AlignalTop
BevelOuterbvNoneCaptionpnlReplaceCommentColorclBtnShadowTabOrder  TLabellblReplaceCommentLeftTopWidth�HeightAnchorsakLeftakTopakRightakBottom AutoSizeCaption�Remplacer toutes les entr�es de r.e. dans la cha�ne d'entr�e avec une autre chaine.
NB: Le remplacement utilise les appels � Exec*. Match* sera ind�finie apr�s.Font.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontWordWrap	   TPanelpnlReplaceTemplateLeft Top'Width�HeightbAlignalTop
BevelOuterbvNoneTabOrder TLabellblReplaceStringLeftTopWidth� HeightCaptionCha�ne pour le remplacementFocusControledReplaceString  TMemoedReplaceStringLeft TopWidth�HeightPAnchorsakLeftakTopakRightakBottom 
ScrollBars
ssVerticalTabOrder    TPanelpnlReplaceResultLeft Top� Width�Height� AlignalClient
BevelOuterbvNoneTabOrder TLabellblReplaceResultLeftTop Width{HeightCaptionR�sultat du remplacementFocusControlmemReplaceResult  TMemomemReplaceResultLeft TopWidth�Height� TabStopAnchorsakLeftakTopakRightakBottom Color	clBtnFaceReadOnly	
ScrollBars
ssVerticalTabOrder   TBitBtn
btnReplaceLeft�Top� WidthaHeight!HintExec r.e. for input stringAnchorsakRightakBottom Caption
&RemplacerDefault	ParentShowHintShowHint	TabOrderOnClickbtnReplaceClick
Glyph.Data

    BM      v   (   (            �                      �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� 3333333333333333333333333333333333333333338�����3333?�����3333     �3333������3333�����3333�33?8�3333����3333�38���3333�  ��3333�3����3333�  ��3333�3����3333�   �3333�8����3333   �3333������3333 �� �3333��38��3333��  �3333�33���3333�� 3333�33���3333�� 03333����8�3333   8 3333����3��33333333 �33333333��333333330333333338�333333333333333333�33333333333333333333333333333333333333333	NumGlyphsSpacing�    	TTabSheettabSplitCaption �&limination 
ImageIndex TLabellblSplitResultLeftTop(WidthcHeightCaptionR�sultat d'�limination  TBitBtnbtnSplitLeft�TopWidthaHeight!HintExec r.e. for input stringAnchorsakRightakBottom Caption	�li&minerDefault	ParentShowHintShowHint	TabOrder OnClickbtnSplitClick
Glyph.Data

    BM      v   (   (            �                      �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� 3333333333333333333333333333333333333333338�����3333?�����3333     �3333������3333�����3333�33?8�3333����3333�38���3333�  ��3333�3����3333�  ��3333�3����3333�   �3333�8����3333   �3333������3333 �� �3333��38��3333��  �3333�33���3333�� 3333�33���3333�� 03333����8�3333   8 3333����3��33333333 �33333333��333333330333333338�333333333333333333�33333333333333333333333333333333333333333	NumGlyphsSpacing�  TMemomemSplitResultLeft Top8Width�Height� TabStopAnchorsakLeftakTopakRightakBottom Color	clBtnFaceReadOnly	
ScrollBars
ssVerticalTabOrder  TPanelpnlSplitCommentLeft Top Width�Height'AlignalTop
BevelOuterbvNoneCaptionpnlReplaceCommentColorclBtnShadowTabOrder TLabellblSplitCommentLeftTopWidth�HeightAnchorsakLeftakTopakRightakBottom AutoSizeCaptionr�limination de la cha�ne par l'e.r.
NB: �liminer (Split) utilise les appels � Exec*. Match* sera ind�finie apr�s.Font.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontWordWrap	     TPanelpnlTopExamplesLeftTopWidthHeight/AlignalTop
BevelOuterbvNoneTabOrder TLabellblExamplesLeftTop�Width� HeightCaption,Vous pouvez choisir un example pr�t � servir  TSpeedButtonbtnTemplatePhonePiterLeftTopWidthHeightHint&Num�ro de t�l�phone � Saint-PetersburgFlat	
Glyph.Data
z  v  BMv      v   (                                       �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 30     337wwwww�30�33�������1�37w�7777�0����37????733	���3�sss� ��� www���wwp   7�7www�70����7?7337373	�����3s�����s31    337wwwww3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333	NumGlyphsParentShowHintShowHint	OnClickbtnTemplatePhonePiterClick  TSpeedButtonbtnTemplatePhoneLeft$TopWidthHeightHint!Num�ro de t�l�phone internationalFlat	
Glyph.Data
z  v  BMv      v   (                                       �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 30     337wwwww�30�33�������1�37w�7777�0����37????733	���3�sss� ��� www���wwp   7�7www�70����7?7337373	�����3s�����s31    337wwwww3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333	NumGlyphsParentShowHintShowHint	OnClickbtnTemplatePhoneClick  TSpeedButtonbtnTemplatePassportLeft@TopWidthHeightHintPasseport RusseFlat	
Glyph.Data
z  v  BMv      v   (                                       �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 33    �33wwwwww33����337s?7w33��33s�s3w33� ���337w33733����33�s?3730  ���?�ww�s?7 �����ws?���s7��    � w�wwww�w࿿�����w�3?���7���   �w�3wwws7࿿�����w�3?��?����    w�3wwsww������ws���37 0  �w7wws3s33��� 333���w333    333wwwws3	NumGlyphsParentShowHintShowHint	OnClickbtnTemplatePassportClick  TSpeedButtonbtnTemplateMailLeft\TopWidthHeightHintAdresse e-MailFlat	
Glyph.Data
z  v  BMv      v   (                                       �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 333333333333333333333333?�������        wwwwwwww������pw?�333?ww����w�w?�3?w7�w��w��3w?�w37��  ���3?ww?�7�p����?w33w?�p����w3333w7 ~����� w������wwwwwwwpwwwwwwww0~�����7s�333�s3p���337s�3�s333p~�33337s�s33333p3333337s3333333333333333333	NumGlyphsParentShowHintShowHint	OnClickbtnTemplateMailClick  TSpeedButtonbtnTemplateIntegerLeftxTopWidthHeightHintNombre entierFlat	
Glyph.Data
z  v  BMv      v   (                                       �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 3p    s337wwww?33����33???�33��33ssws33����33????3333ssss33����33????3333ssss33����33????3333ssss33����33?���33   33www33 33��33   33wwws33����33333333����33s����s33p    s337wwww33	NumGlyphsParentShowHintShowHint	OnClickbtnTemplateIntegerClick  TSpeedButtonbtnTemplateRealNumberLeft� TopWidthHeightHintNombre avec d�cimaleFlat	
Glyph.Data
z  v  BMv      v   (                                       �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 3p    s337wwww?33����33???�33��33ssws33����33????3333ssss33����33????3333ssss33����33????3333ssss33����33?���33   33www33 33��33   33wwws33����33333333����33s����s33p    s337wwww33	NumGlyphsParentShowHintShowHint	OnClickbtnTemplateRealNumberClick  TSpeedButtonbtnTemplateRomanNumberLeft� TopWidthHeightHintChiffre romainFlat	
Glyph.Data
z  v  BMv      v   (                                       �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� UWuwwwWpUWuwww_�UUUUUU UUUUU_wUUUUUP�UUUUU�WUUUUU�UUUU_u_uUUUUP3�UUUUU�U�UUUUU;UUUU_u_uUUUUP3�UUUUU�U�UUUUU;UUUU_u_uUUUUP3�UUUUU�U�UUUUU;UUUU_u_uUUUUP3�UUUUU�_�UUUUUUUUU_uUUUUP �UUUUU�w�UUUUU�UUUUUwwuUUUUU	�UUUUUUwwUUUUUUPUUUUUUWuUUUUUU	NumGlyphsParentShowHintShowHint	OnClickbtnTemplateRomanNumberClick  TSpeedButtonbtnTemplateURLLeft� TopWidthHeightHintLien URL InternetFlat	
Glyph.Data
z  v  BMv      v   (                                       �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� UUUUUUUUUUU���UUUUTLLUUUUU�ww_�UUT�D�DUUUWu�Uw_UULC4DDEUUuWUU�T��4��3UW�W�Uw�T��3DD3UWUWw�Uw_���3���EU�w�UUL�33��D�Www��U�333����www��UL�333<LEWwwwU��<�3<��u�u_w�u\��333LUW��www��T�3333�UWWwwww�UU33�<3�UUwwUuwuUUS<���UUUWu��wUUUU\L�UUUUUWwwUUU	NumGlyphsParentShowHintShowHint	OnClickbtnTemplateURLClick  TSpeedButtonbtnSaintPetersburgLeft� TopWidthHeightHintAdmirable Saint-PetersburgFlat	
Glyph.Data
z  v  BMv      v   (                                       �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 3������33wwwwww3� ����33w333�3�����33s�37�3���� 337�3ws3����3377s33�� ��333w333�� ��333w333�� ��33?w�33�� �33s�ws33�����3377333�� ��333w333�����3337�33��� ��3333w�33��� ��3333w333������33�����3������33wwwwwws	NumGlyphsParentShowHintShowHint	OnClickbtnSaintPetersburgClick  TSpeedButton
btnBackRefLeftTopWidthHeightHintR�f�rence HTMLFlat	
Glyph.Data
�   �   BM�       v   (               �                   �  �   �� �   � � ��  ��� ���   � ���  �� �   ��� ��  ��� �������ڭ�D�������D����ڭDD     �DD�����DD�������D�����Dwxww�������x���wwx�����w����w�������x�����x����������      ParentShowHintShowHint	OnClickbtnBackRefClick  TSpeedButtonbtnNonGreedyLeft TopWidthHeightHintExemple non voraceFlat	
Glyph.Data
F  B  BMB      v   (               �                       �  �   �� �   � � ��  ��� ���   �  �   �� �   � � ��  ��� wwwwwwwwp   wwwwwwwwp   wwp    p   wwwwwwwwp   wwww   p   wwwwwwwwp   wwww   p   wwwwwwwwp   wwp    p   wwwwwwwwp   wwy�����p   wwwwwwwwp   w�y�����p   wwwwwwwwp   w      p   wwwwwwwwp   wwwwwwwwp   ParentShowHintShowHint	OnClickbtnNonGreedyClick    	TComboBoxcbHelpLanguageLeft� Top�Width� HeightTabStopStylecsDropDownListAnchorsakLeftakRightakBottom Color	clBtnFace
ItemHeightTabOrderOnClickcbHelpLanguageClickItems.Strings������� ������� (Russian help)English help#����� �� ��������� (Bulgarian help)Deutsche Hilfe (German help)Aide en Fran�ais (French Help)   TOpenDialogOpenDialog1FilterIHTML (*.htm; *.html)|*.htm;*.html|Texts (*.txt)|*.txt|All files (*.*)|*.*FilterIndex OptionsofHideReadOnlyofFileMustExistofEnableSizing Left�Top8   