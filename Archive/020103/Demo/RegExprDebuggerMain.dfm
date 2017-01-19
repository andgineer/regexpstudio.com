object fmRegExprDebugger: TfmRegExprDebugger
  Left = 212
  Top = 64
  Width = 531
  Height = 475
  BorderIcons = [biSystemMenu]
  Caption = 'fmRegExprDebugger'
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 350
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    523
    448)
  PixelsPerInch = 96
  TextHeight = 13
  object btnHelp: TSpeedButton
    Left = 378
    Top = 424
    Width = 23
    Height = 22
    Hint = 'Show help on the'#13#10'selected language'
    Anchors = [akRight, akBottom]
    Flat = True
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333FFFFF3333333333F797F3333333333F737373FF333333BFB999BFB
      33333337737773773F3333BFBF797FBFB33333733337333373F33BFBFBFBFBFB
      FB3337F33333F33337F33FBFBFB9BFBFBF3337333337F333373FFBFBFBF97BFB
      FBF37F333337FF33337FBFBFBFB99FBFBFB37F3333377FF3337FFBFBFBFB99FB
      FBF37F33333377FF337FBFBF77BF799FBFB37F333FF3377F337FFBFB99FB799B
      FBF373F377F3377F33733FBF997F799FBF3337F377FFF77337F33BFBF99999FB
      FB33373F37777733373333BFBF999FBFB3333373FF77733F7333333BFBFBFBFB
      3333333773FFFF77333333333FBFBF3333333333377777333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = btnHelpClick
  end
  object Bevel1: TBevel
    Left = 2
    Top = 434
    Width = 124
    Height = 2
    Anchors = [akLeft, akBottom]
    Shape = bsTopLine
    Style = bsRaised
  end
  object lblWWW: TLabel
    Left = 16
    Top = 427
    Width = 83
    Height = 13
    Cursor = crHandPoint
    Hint = 'Go to TRegExpr web-page in Internet'
    Anchors = [akLeft, akBottom]
    Caption = ' TRegExpr home '
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    OnClick = lblWWWClick
  end
  object btnClose: TBitBtn
    Left = 413
    Top = 424
    Width = 107
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&Exit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnCloseClick
    Glyph.Data = {
      76020000424D7602000000000000760000002800000040000000100000000100
      0400000000000002000000000000000000001000000000000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
      033377777777777F3333330000000000033330000000000033333301BBBBBBBB
      03337F333333337F33333301BBBBBBBB0333301111111110333333011BBBBBBB
      03337F333333337F333333011BBBBBBB03333011111111103333330111BBBBBB
      03337F333333337F3333330111BBBBBB033330111111111033333301110BBBBB
      03337F333333337F33333301110BBBBB033330111111111033333301110BBBBB
      03337F333333337F33333301110BBBBB033330111111111033333301110BBBBB
      03337F3333333F7F33333301110BBBBB033330111111111033333301110BBBBB
      03337F333333737F33333301110BBBBB0333301111111B1033333301110BBBBB
      03337F333333337F33333301110BBBBB033330111111111033333301110BBBBB
      03337F33FFFFF37F33333301110BBBBB03333011111111103333330111B0BBBB
      03337F377777F37F3333330111B0BBBB03333011EEEEE11033333301110BBBBB
      03337F37FFF7F37F33333301110BBBBB03333011EEEEE11033333301110BBBBB
      03337F377777337F33333301110BBBBB03333011EEEEE11033333301E10BBBBB
      03337F333333337F33333301E10BBBBB033330111111111033333301EE0BBBBB
      03337FFFFFFFFF7F33333301EE0BBBBB03333011111111103333330000000000
      0333777777777773333333000000000003333000000000003333}
    NumGlyphs = 4
    Spacing = -1
  end
  object grpRegExpr: TGroupBox
    Left = 2
    Top = 0
    Width = 519
    Height = 420
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 2
      Top = 62
      Width = 515
      Height = 356
      ActivePage = tabExpression
      Align = alClient
      TabIndex = 0
      TabOrder = 0
      object tabExpression: TTabSheet
        Caption = ' &Expression '
        object Splitter3: TSplitter
          Left = 0
          Top = 171
          Width = 507
          Height = 5
          Cursor = crVSplit
          Align = alTop
          AutoSnap = False
          Beveled = True
          MinSize = 120
        end
        object pnlRegExpr: TPanel
          Left = 0
          Top = 0
          Width = 507
          Height = 171
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            507
            171)
          object lblRegExpr: TLabel
            Left = 4
            Top = 48
            Width = 90
            Height = 13
            Caption = 'Regular expression'
            FocusControl = edRegExpr
          end
          object lblRegExprUnbalancedBrackets: TLabel
            Left = 136
            Top = 48
            Width = 180
            Height = 13
            Caption = 'lblRegExprUnbalancedBrackets'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clPurple
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
            OnDblClick = lblRegExprUnbalancedBracketsDblClick
          end
          object edSubExprs: TLabel
            Left = 4
            Top = 146
            Width = 77
            Height = 13
            Anchors = [akLeft, akBottom]
            Caption = 'Subexpressions:'
            FocusControl = cbSubExprs
          end
          object btnViewPCode: TSpeedButton
            Left = 424
            Top = 144
            Width = 82
            Height = 26
            Hint = 
              'View compiled r.e. as "P-code"'#13#10'for TRegExpr debugging and'#13#10'inte' +
              'rnal engine undestanding'
            Anchors = [akRight, akBottom]
            Caption = 'P-code'
            Flat = True
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              04000000000000010000120B0000120B00001000000000000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00370777033333
              3330337F3F7F33333F3787070003333707303F737773333373F7007703333330
              700077337F3333373777887007333337007733F773F333337733700070333333
              077037773733333F7F37703707333300080737F373333377737F003333333307
              78087733FFF3337FFF7F33300033330008073F3777F33F777F73073070370733
              078073F7F7FF73F37FF7700070007037007837773777F73377FF007777700730
              70007733FFF77F37377707700077033707307F37773F7FFF7337080777070003
              3330737F3F7F777F333778080707770333333F7F737F3F7F3333080787070003
              33337F73FF737773333307800077033333337337773373333333}
            NumGlyphs = 2
            ParentShowHint = False
            ShowHint = True
            Spacing = -1
            OnClick = btnViewPCodeClick
          end
          object gbModifiers: TGroupBox
            Left = 2
            Top = 4
            Width = 504
            Height = 36
            Anchors = [akLeft, akTop, akRight]
            Caption = ' Global modifiers '
            TabOrder = 0
            object chkModifierI: TCheckBox
              Left = 8
              Top = 14
              Width = 41
              Height = 17
              Hint = 'Case insensitive'
              TabStop = False
              Caption = '/i'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = chkModifierIClick
            end
            object chkModifierR: TCheckBox
              Left = 256
              Top = 14
              Width = 97
              Height = 17
              TabStop = False
              Caption = 'Russian ranges'
              TabOrder = 5
              OnClick = chkModifierRClick
            end
            object chkModifierS: TCheckBox
              Left = 88
              Top = 14
              Width = 41
              Height = 17
              Hint = 
                'If on then '#39'.'#39' means any char'#13#10'If off then '#39'.'#39' doesn'#39't include l' +
                'ine separators'
              TabStop = False
              Caption = '/s'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = chkModifierSClick
            end
            object chkModifierG: TCheckBox
              Left = 184
              Top = 14
              Width = 65
              Height = 17
              Hint = 
                'If Off then all operators '#13#10'work as non-greedy '#13#10'('#39'*'#39' as '#39'*?'#39', '#39 +
                '+'#39' as '#39'+?'#39' '#13#10'and so on)'
              TabStop = False
              Caption = 'Greedy'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              OnClick = chkModifierGClick
            end
            object chkModifierM: TCheckBox
              Left = 48
              Top = 14
              Width = 41
              Height = 17
              Hint = 
                'If ON then '#39'^'#39' / '#39'$'#39' match'#13#10'every embedded line start / end,'#13#10'if' +
                ' OFF, then only beginning / end'#13#10'of whole text'
              TabStop = False
              Caption = '/m'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = chkModifierMClick
            end
            object chkModifierX: TCheckBox
              Left = 128
              Top = 14
              Width = 41
              Height = 17
              Hint = 'If ON then eXtended comment syntax available'
              TabStop = False
              Caption = '/x'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = chkModifierXClick
            end
          end
          object edRegExpr: TMemo
            Left = 0
            Top = 64
            Width = 507
            Height = 79
            Anchors = [akLeft, akTop, akRight, akBottom]
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Courier New'
            Font.Style = []
            Lines.Strings = (
              'edRegExpr')
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
            WordWrap = False
            OnChange = edRegExprChange
            OnClick = edRegExprClick
            OnKeyDown = edRegExprKeyDown
            OnKeyUp = edRegExprKeyDown
          end
          object cbSubExprs: TComboBox
            Left = 106
            Top = 144
            Width = 315
            Height = 21
            Hint = 'Subexpressions'
            Style = csDropDownList
            Anchors = [akLeft, akRight, akBottom]
            Color = clBtnFace
            ItemHeight = 13
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            TabStop = False
            OnClick = cbSubExprsClick
          end
        end
        object pnlInputStrings: TPanel
          Left = 0
          Top = 176
          Width = 507
          Height = 152
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            507
            152)
          object lblInputString: TLabel
            Left = 4
            Top = 4
            Width = 55
            Height = 13
            Caption = 'Input string:'
            FocusControl = edInputString
          end
          object lblInputStringPos: TLabel
            Left = 344
            Top = 4
            Width = 82
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'Current selection:'
            FocusControl = edInputStringPos
          end
          object lblTestResult: TLabel
            Left = 256
            Top = 109
            Width = 252
            Height = 40
            Hint = 
              'Last Exec* result and'#13#10'positions of r.e. and'#13#10'subexpressions'#13#10'in' +
              ' input string'
            Anchors = [akLeft, akRight, akBottom]
            AutoSize = False
            Caption = 'String is not tested'
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentColor = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            WordWrap = True
          end
          object edInputString: TMemo
            Left = 0
            Top = 24
            Width = 507
            Height = 86
            Anchors = [akLeft, akTop, akRight, akBottom]
            Lines.Strings = (
              'edInputString')
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
            OnChange = edInputStringClick
            OnClick = edInputStringClick
            OnKeyDown = edInputStringKeyDown
            OnKeyUp = edInputStringKeyDown
            OnMouseDown = edInputStringMouseDown
            OnMouseMove = edInputStringMouseMove
            OnMouseUp = edInputStringMouseDown
          end
          object edInputStringPos: TEdit
            Left = 448
            Top = 0
            Width = 49
            Height = 21
            TabStop = False
            Anchors = [akTop, akRight]
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 1
            Text = 'edInputStringPos'
          end
          object btnTestString: TBitBtn
            Left = 0
            Top = 113
            Width = 73
            Height = 33
            Hint = 'Exec r.e. for input string'
            Anchors = [akLeft, akBottom]
            Caption = 'E&xec'
            Default = True
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = btnTestStringClick
            Glyph.Data = {
              66010000424D6601000000000000760000002800000014000000140000000100
              040000000000F000000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              3333333300003333333333333300333300003333333333333333333300003333
              3333333333003333000033033333333333003333000030003333333333300333
              00000F000333333330330033000030F000333333300330030000330F00000007
              3300003300003330F0078887033333330000333300788FF87033333300003333
              0788888F877333330000333308888888F80333330000333307888888F8033333
              00003333078FF8888803333300003333777FF888877333330000333330778888
              7033333300003333330777770333333300003333333700073333333300003333
              33333333333333330000}
            Spacing = -1
          end
          object btnExecNext: TBitBtn
            Left = 73
            Top = 113
            Width = 98
            Height = 33
            Hint = 'Exec from last match'
            Anchors = [akLeft, akBottom]
            Caption = 'Exec&Next'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = btnExecNextClick
            Glyph.Data = {
              66010000424D6601000000000000760000002800000014000000140000000100
              040000000000F000000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              3333333300003333333333333333333300003333333330033003300300003333
              3333300330033003000033303333333333333333000033000333333333333333
              000030F000333333333333330000330F000333333333333300003330F0000000
              73333333000033330F0078887033333300003333300788FF8703333300003333
              30788888F877333300003333308888888F80333300003333307888888F803333
              000033333078FF8888803333000033333777FF88887733330000333333077888
              8703333300003333333077777033333300003333333370007333333300003333
              33333333333333330000}
            Spacing = -1
          end
          object btnFindRegExprInFile: TBitBtn
            Left = 176
            Top = 113
            Width = 75
            Height = 33
            Anchors = [akLeft, akBottom]
            Caption = '&File'
            TabOrder = 4
            OnClick = btnFindRegExprInFileClick
            Glyph.Data = {
              42010000424D4201000000000000760000002800000011000000110000000100
              040000000000CC00000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              77777000000070000000007777777000000070FFFFFFF07777700000000070F7
              7777F07777000000000070F77777F07770007000000070F77780008700077000
              000070F7700FFF0000777000000070F708FFFF0807777000000070F80E000F07
              08777000000070F0EFEFEF0770777000000070F0F0000F077077700000007000
              EFEFFF0770777000000077780000000708777000000077770077777807777000
              0000777770077700777770000000777777800087777770000000777777777777
              777770000000}
            Spacing = -1
          end
          object cbSubStrs: TComboBox
            Left = 256
            Top = 122
            Width = 251
            Height = 21
            Style = csDropDownList
            Anchors = [akLeft, akRight, akBottom]
            Color = clBtnFace
            ItemHeight = 13
            TabOrder = 5
            Visible = False
            OnClick = cbSubStrsClick
          end
        end
      end
      object tabSubstitute: TTabSheet
        Caption = ' &Substitute '
        ImageIndex = 1
        object Splitter2: TSplitter
          Left = 0
          Top = 129
          Width = 507
          Height = 5
          Cursor = crVSplit
          Align = alTop
          AutoSnap = False
          Beveled = True
          MinSize = 50
        end
        object pnlSubstitutionComment: TPanel
          Left = 0
          Top = 0
          Width = 507
          Height = 39
          Align = alTop
          BevelOuter = bvNone
          Color = clBtnShadow
          TabOrder = 0
          DesignSize = (
            507
            39)
          object lblSubstitutionComment: TLabel
            Left = 8
            Top = 6
            Width = 402
            Height = 30
            Anchors = [akLeft, akTop, akRight, akBottom]
            AutoSize = False
            Caption = 
              'Use '#39'$&&'#39' in template for whole r.e. substitution and '#39'$n'#39' or '#39'$' +
              '{n}'#39' for substitute subexpression of r.e. number n.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            WordWrap = True
          end
        end
        object pnlSubstitutionTemplate: TPanel
          Left = 0
          Top = 39
          Width = 507
          Height = 90
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            507
            90)
          object lblSubstitutionTemplate: TLabel
            Left = 4
            Top = 2
            Width = 72
            Height = 13
            Caption = 'Template string'
            FocusControl = memSubstitutionTemplate
          end
          object memSubstitutionTemplate: TMemo
            Left = 1
            Top = 18
            Width = 505
            Height = 71
            Anchors = [akLeft, akTop, akRight, akBottom]
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object pnlSubstitutionResult: TPanel
          Left = 0
          Top = 134
          Width = 507
          Height = 194
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          DesignSize = (
            507
            194)
          object lblSubstitutionResult: TLabel
            Left = 4
            Top = 2
            Width = 83
            Height = 13
            Caption = 'Substitution result'
            FocusControl = memSubstitutionResult
          end
          object memSubstitutionResult: TMemo
            Left = 0
            Top = 19
            Width = 507
            Height = 175
            TabStop = False
            Anchors = [akLeft, akTop, akRight, akBottom]
            Color = clBtnFace
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
      end
      object tabReplace: TTabSheet
        Caption = ' &Replace '
        ImageIndex = 2
        object Splitter1: TSplitter
          Left = 0
          Top = 137
          Width = 507
          Height = 5
          Cursor = crVSplit
          Align = alTop
          AutoSnap = False
          Beveled = True
          MinSize = 50
        end
        object pnlReplaceComment: TPanel
          Left = 0
          Top = 0
          Width = 507
          Height = 39
          Align = alTop
          BevelOuter = bvNone
          Caption = 'pnlReplaceComment'
          Color = clBtnShadow
          TabOrder = 0
          DesignSize = (
            507
            39)
          object lblReplaceComment: TLabel
            Left = 8
            Top = 6
            Width = 497
            Height = 30
            Anchors = [akLeft, akTop, akRight, akBottom]
            AutoSize = False
            Caption = 
              'Replace all entrances of r.e. in input string with another strin' +
              'g (it may be template for substitution).'#13#10'Note: Replace uses Exe' +
              'c* calls, so Match* properties will be undefined after it.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            WordWrap = True
          end
        end
        object pnlReplaceTemplate: TPanel
          Left = 0
          Top = 39
          Width = 507
          Height = 98
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            507
            98)
          object lblReplaceString: TLabel
            Left = 4
            Top = 2
            Width = 80
            Height = 13
            Caption = 'String for replace'
            FocusControl = edReplaceString
          end
          object edReplaceString: TMemo
            Left = 0
            Top = 18
            Width = 507
            Height = 80
            Anchors = [akLeft, akTop, akRight, akBottom]
            ScrollBars = ssVertical
            TabOrder = 0
          end
          object chkUseSubstitution: TCheckBox
            Left = 144
            Top = 0
            Width = 257
            Height = 17
            Caption = 'Use as substitution template'
            TabOrder = 1
          end
        end
        object pnlReplaceResult: TPanel
          Left = 0
          Top = 142
          Width = 507
          Height = 186
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          DesignSize = (
            507
            186)
          object lblReplaceResult: TLabel
            Left = 4
            Top = 0
            Width = 68
            Height = 13
            Caption = 'Replace result'
            FocusControl = memReplaceResult
          end
          object memReplaceResult: TMemo
            Left = 0
            Top = 16
            Width = 507
            Height = 130
            TabStop = False
            Anchors = [akLeft, akTop, akRight, akBottom]
            Color = clBtnFace
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
          object btnReplace: TBitBtn
            Left = 406
            Top = 150
            Width = 97
            Height = 33
            Hint = 'Exec r.e. for input string'
            Anchors = [akRight, akBottom]
            Caption = '&Replace'
            Default = True
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = btnReplaceClick
            Glyph.Data = {
              06020000424D0602000000000000760000002800000028000000140000000100
              0400000000009001000000000000000000001000000010000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              3333333333333333333333333333333333333333333333333333333333333333
              33333333388888888883333333333FFFFFFFFFF3333333330000000000833333
              33338888888888F3333333330FFFFFFFF083333333338F33333F38F333333333
              0FFFF00FF083333333338F33388FF8F3333333330FFF0000F083333333338F33
              8888F8F3333333330FF80000F083333333338F338888F8F3333333330F800000
              0083333333338F38888888F3333333330F000F000083333333338F88838888F3
              333333330F00FFF00083333333338F88333888F3333333330FFFFF0000833333
              33338F33338888FF333333330FFFFF0F0003333333338F33338F888F33333333
              0FFFFF003008333333338FFFFF88388F33333333000000033800333333338888
              88833388F333333333333333330083333333333333333388FF33333333333333
              3330033333333333333333388F33333333333333333303333333333333333333
              8333333333333333333333333333333333333333333333333333333333333333
              33333333333333333333}
            NumGlyphs = 2
            Spacing = -1
          end
        end
      end
      object tabSplit: TTabSheet
        Caption = ' &Split '
        ImageIndex = 3
        DesignSize = (
          507
          328)
        object lblSplitResult: TLabel
          Left = 4
          Top = 40
          Width = 48
          Height = 13
          Caption = 'Split result'
        end
        object btnSplit: TBitBtn
          Left = 406
          Top = 286
          Width = 97
          Height = 33
          Hint = 'Exec r.e. for input string'
          Anchors = [akRight, akBottom]
          Caption = '&Split'
          Default = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = btnSplitClick
          Glyph.Data = {
            06020000424D0602000000000000760000002800000028000000140000000100
            0400000000009001000000000000000000001000000010000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333333333333333333333333333333333333333333333333333333333333333
            33333333388888888883333333333FFFFFFFFFF3333333330000000000833333
            33338888888888F3333333330FFFFFFFF083333333338F33333F38F333333333
            0FFFF00FF083333333338F33388FF8F3333333330FFF0000F083333333338F33
            8888F8F3333333330FF80000F083333333338F338888F8F3333333330F800000
            0083333333338F38888888F3333333330F000F000083333333338F88838888F3
            333333330F00FFF00083333333338F88333888F3333333330FFFFF0000833333
            33338F33338888FF333333330FFFFF0F0003333333338F33338F888F33333333
            0FFFFF003008333333338FFFFF88388F33333333000000033800333333338888
            88833388F333333333333333330083333333333333333388FF33333333333333
            3330033333333333333333388F33333333333333333303333333333333333333
            8333333333333333333333333333333333333333333333333333333333333333
            33333333333333333333}
          NumGlyphs = 2
          Spacing = -1
        end
        object memSplitResult: TMemo
          Left = 0
          Top = 56
          Width = 507
          Height = 226
          TabStop = False
          Anchors = [akLeft, akTop, akRight, akBottom]
          Color = clBtnFace
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 1
        end
        object pnlSplitComment: TPanel
          Left = 0
          Top = 0
          Width = 507
          Height = 39
          Align = alTop
          BevelOuter = bvNone
          Caption = 'pnlReplaceComment'
          Color = clBtnShadow
          TabOrder = 2
          DesignSize = (
            507
            39)
          object lblSplitComment: TLabel
            Left = 8
            Top = 6
            Width = 402
            Height = 30
            Anchors = [akLeft, akTop, akRight, akBottom]
            AutoSize = False
            Caption = 
              'Split input string by r.e. entrances.'#13#10'Note: Split uses Exec* ca' +
              'lls, so Match* properties will be undefined after it.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            WordWrap = True
          end
        end
      end
    end
    object pnlTopExamples: TPanel
      Left = 2
      Top = 15
      Width = 515
      Height = 47
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object lblExamples: TLabel
        Left = 8
        Top = -2
        Width = 215
        Height = 13
        Caption = 'You can select one of ready-to-use examples:'
      end
      object btnTemplatePhonePiter: TSpeedButton
        Left = 8
        Top = 15
        Width = 28
        Height = 28
        Hint = 'Phone number in Saint-Petersburg'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333000000000
          003333377777777777F3333091111111103333F7F3F3F3F3F7F3311098080808
          10333777F737373737F313309999999910337F373F3F3F3F3733133309808089
          03337FFF7F7373737FFF1000109999901000777777FFFFF77777701110000000
          111037F337777777F3373099901111109990373F373333373337330999999999
          99033373FFFFFFFFFF7333310000000001333337777777777733333333333333
          3333333333333333333333333333333333333333333333333333333333333333
          3333333333333333333333333333333333333333333333333333333333333333
          3333333333333333333333333333333333333333333333333333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btnTemplatePhonePiterClick
      end
      object btnTemplatePhone: TSpeedButton
        Left = 36
        Top = 15
        Width = 28
        Height = 28
        Hint = 'International phone number'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333000000000
          003333377777777777F3333091111111103333F7F3F3F3F3F7F3311098080808
          10333777F737373737F313309999999910337F373F3F3F3F3733133309808089
          03337FFF7F7373737FFF1000109999901000777777FFFFF77777701110000000
          111037F337777777F3373099901111109990373F373333373337330999999999
          99033373FFFFFFFFFF7333310000000001333337777777777733333333333333
          3333333333333333333333333333333333333333333333333333333333333333
          3333333333333333333333333333333333333333333333333333333333333333
          3333333333333333333333333333333333333333333333333333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btnTemplatePhoneClick
      end
      object btnTemplatePassport: TSpeedButton
        Left = 64
        Top = 15
        Width = 28
        Height = 28
        Hint = 'Russian passport'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333300000000
          0EEE333377777777777733330FF00FBFB0EE33337F37733F377733330F0BFB0B
          FB0E33337F73FF73337733330FF000BFBFB033337F377733333733330FFF0BFB
          FBF033337FFF733F333733300000BF0FBFB03FF77777F3733F37000FBFB0F0FB
          0BF077733FF7F7FF7337E0FB00000000BF0077F377777777F377E0BFBFBFBFB0
          F0F077F3333FFFF7F737E0FBFB0000000FF077F3337777777337E0BFBFBFBFB0
          FFF077F3333FFFF73FF7E0FBFB00000F000077FF337777737777E00FBFBFB0FF
          0FF07773FFFFF7337F37003000000FFF0F037737777773337F7333330FFFFFFF
          003333337FFFFFFF773333330000000003333333777777777333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btnTemplatePassportClick
      end
      object btnTemplateMail: TSpeedButton
        Left = 92
        Top = 15
        Width = 28
        Height = 28
        Hint = 'e-Mail address'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333333333333333333FFFFFFFFFFFFFFF000000000000
          0000777777777777777707FFFFFFFFFFFF70773FF33333333F770F77FFFFFFFF
          77F07F773FF3333F77370FFF77FFFF77FFF07F33773FFF7733370FFFFF0000FF
          FFF07F333F77773FF3370FFF70EEEE07FFF07F3F773333773FF70F707FFFFFF7
          07F07F77333333337737007EEEEEEEEEE70077FFFFFFFFFFFF77077777777777
          77707777777777777777307EEEEEEEEEE7033773FF333333F77333707FFFFFF7
          0733333773FF33F773333333707EE707333333333773F7733333333333700733
          3333333333377333333333333333333333333333333333333333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btnTemplateMailClick
      end
      object btnTemplateInteger: TSpeedButton
        Left = 120
        Top = 15
        Width = 28
        Height = 28
        Hint = 'Integer number'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00337000000000
          73333337777777773F333308888888880333337F3F3F3FFF7F33330808089998
          0333337F737377737F333308888888880333337F3F3F3F3F7F33330808080808
          0333337F737373737F333308888888880333337F3F3F3F3F7F33330808080808
          0333337F737373737F333308888888880333337F3F3F3F3F7F33330808080808
          0333337F737373737F333308888888880333337F3FFFFFFF7F33330800000008
          0333337F7777777F7F333308000E0E080333337F7FFFFF7F7F33330800000008
          0333337F777777737F333308888888880333337F333333337F33330888888888
          03333373FFFFFFFF733333700000000073333337777777773333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btnTemplateIntegerClick
      end
      object btnTemplateRealNumber: TSpeedButton
        Left = 148
        Top = 15
        Width = 28
        Height = 28
        Hint = 'Real number'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00337000000000
          73333337777777773F333308888888880333337F3F3F3FFF7F33330808089998
          0333337F737377737F333308888888880333337F3F3F3F3F7F33330808080808
          0333337F737373737F333308888888880333337F3F3F3F3F7F33330808080808
          0333337F737373737F333308888888880333337F3F3F3F3F7F33330808080808
          0333337F737373737F333308888888880333337F3FFFFFFF7F33330800000008
          0333337F7777777F7F333308000E0E080333337F7FFFFF7F7F33330800000008
          0333337F777777737F333308888888880333337F333333337F33330888888888
          03333373FFFFFFFF733333700000000073333337777777773333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btnTemplateRealNumberClick
      end
      object btnTemplateRomanNumber: TSpeedButton
        Left = 176
        Top = 15
        Width = 28
        Height = 28
        Hint = 'Roman number'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555775777777
          57705557757777775FF7555555555555000755555555555F777F555555555550
          87075555555555F7577F5555555555088805555555555F755F75555555555033
          805555555555F755F75555555555033B05555555555F755F75555555555033B0
          5555555555F755F75555555555033B05555555555F755F75555555555033B055
          55555555F755F75555555555033B05555555555F755F75555555555033B05555
          555555F75FF75555555555030B05555555555F7F7F75555555555000B0555555
          5555F777F7555555555501900555555555557777755555555555099055555555
          5555777755555555555550055555555555555775555555555555}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btnTemplateRomanNumberClick
      end
      object btnTemplateURL: TSpeedButton
        Left = 204
        Top = 15
        Width = 28
        Height = 28
        Hint = 'Internet URL'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          5555555555FFFFF555555555544C4C5555555555F777775FF5555554C444C444
          5555555775FF55775F55554C4334444445555575577F55557FF554C4C334C4C4
          335557F5577FF55577F554CCC3334444335557555777F555775FCCCCC333CCC4
          C4457F55F777F555557F4CC33333CCC444C57F577777F5F5557FC4333333C3C4
          CCC57F777777F7FF557F4CC33333333C4C457F577777777F557FCCC33CC4333C
          C4C575F7755F777FF5755CCCCC3333334C5557F5FF777777F7F554C333333333
          CC55575777777777F755553333CC3C33C555557777557577755555533CC4C4CC
          5555555775FFFF77555555555C4CCC5555555555577777555555}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btnTemplateURLClick
      end
      object btnSaintPetersburg: TSpeedButton
        Left = 232
        Top = 15
        Width = 28
        Height = 28
        Hint = 'Admirable Saint-Petersburg'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033BBBBBBBBBB
          BB33337777777777777F33BB00BBBBBBBB33337F77333333F37F33BB0BBBBBB0
          BB33337F73F33337FF7F33BBB0BBBB000B33337F37FF3377737F33BBB00BB00B
          BB33337F377F3773337F33BBBB0B00BBBB33337F337F7733337F33BBBB000BBB
          BB33337F33777F33337F33EEEE000EEEEE33337F3F777FFF337F33EE0E80000E
          EE33337F73F77773337F33EEE0800EEEEE33337F37377F33337F33EEEE000EEE
          EE33337F33777F33337F33EEEEE00EEEEE33337F33377FF3337F33EEEEEE00EE
          EE33337F333377F3337F33EEEEEE00EEEE33337F33337733337F33EEEEEEEEEE
          EE33337FFFFFFFFFFF7F33EEEEEEEEEEEE333377777777777773}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = btnSaintPetersburgClick
      end
      object btnBackRef: TSpeedButton
        Left = 260
        Top = 15
        Width = 28
        Height = 28
        Hint = 'Backreference (HTML parsing)'
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000120B0000120B00001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADAD4DADADA
          DADAADAD44ADADADADADDAD444DADADADADAAD44440000000000D44444FFFFFF
          FFF0AD444488888888F0DAD444888F8888F0ADA04477787777F0DAD0F4F7FFF7
          78F0ADA0F887777778F0DAD0FFFF7F778FF0ADA0F8887F7788F0DAD0FFFFF778
          FFF0ADA0F888877888F0DAD0FFFFFFFFFFF0ADA0000000000000}
        ParentShowHint = False
        ShowHint = True
        OnClick = btnBackRefClick
      end
      object btnNonGreedy: TSpeedButton
        Left = 288
        Top = 15
        Width = 28
        Height = 28
        Hint = 'Non-greedy example'
        Flat = True
        Glyph.Data = {
          42010000424D4201000000000000760000002800000011000000110000000100
          040000000000CC00000000000000000000001000000010000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777700000007777777777777777700000007777700000000007700000007777
          7777777777777000000077777777000000077000000077777777777777777000
          0000777777770000000770000000777777777777777770000000777770000000
          0007700000007777777777777777700000007777799999999997700000007777
          7777777777777000000077997999999999977000000077777777777777777000
          0000770000000000000770000000777777777777777770000000777777777777
          777770000000}
        ParentShowHint = False
        ShowHint = True
        OnClick = btnNonGreedyClick
      end
      object btnOpenRegExpr: TSpeedButton
        Left = 344
        Top = 16
        Width = 23
        Height = 22
        OnClick = btnOpenRegExprClick
      end
    end
  end
  object cbHelpLanguage: TComboBox
    Left = 138
    Top = 424
    Width = 239
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akRight, akBottom]
    Color = clBtnFace
    ItemHeight = 13
    TabOrder = 1
    TabStop = False
    OnClick = cbHelpLanguageClick
    Items.Strings = (
      #1056#1091#1089#1089#1082#1072#1103' '#1089#1087#1088#1072#1074#1082#1072' (Russian help)'
      'English help'
      #1055#1086#1084#1086#1097' '#1085#1072' '#1073#1098#1083#1075#1072#1088#1089#1082#1080' (Bulgarian help)'
      'Deutsche Hilfe (German help)'
      'Aide en Fran'#1079'ais (French help)'
      'ayuda en Espa'#1089'ol (Spanish help)')
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'HTML (*.htm; *.html)|*.htm;*.html|Texts (*.txt)|*.txt|All files ' +
      '(*.*)|*.*'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 320
    Top = 80
  end
  object imgsExamples: TImageList
    Left = 232
    Top = 16
    Bitmap = {
      494C01010B000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001001000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E07FE07FE07FE07FE07F
      E07FE07FE07FE07FE07FE07FE07F000000000000000000000000000010000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E07FE07F00000000E07F
      E07FE07FE07FE07FE07FE07FE07F000000000000000000000000100010000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E07FE07F0000E07FE07F
      E07FE07FE07FE07F0000E07FE07F000000000000000000001000100010000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E07FE07FE07F0000E07F
      E07FE07FE07F000000000000E07F000000000000000010001000100010000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E07FE07FE07F00000000
      E07FE07F00000000E07FE07FE07F00000000000010001000100010001000FF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E07FE07FE07FE07F0000
      E07F00000000E07FE07FE07FE07F000000000000000010001000100010000000
      0000000000000000000000000000FF7F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E07FE07FE07FE07F0000
      00000000E07FE07FE07FE07FE07F000000000000000000001000100010000000
      00000000FF7F0000000000000000FF7F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF03FF03FF03FF030000
      00000000FF03FF03FF03FF03FF03000000000000000000000000100010001042
      1042104200001042104210421042FF7F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF03FF030000FF03F75E
      0000000000000000FF03FF03FF03000000000000000000000000FF7F1000FF7F
      1042FF7FFF7FFF7F104210420000FF7F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF03FF03FF030000F75E
      00000000FF03FF03FF03FF03FF03000000000000000000000000FF7F00000000
      1042104210421042104210420000FF7F000000000000000000000000007C007C
      007C007C007C007C007C007C007C007C00000000000000000000000000000000
      00000000000000000000000000000000000000000000FF03FF03FF03FF030000
      00000000FF03FF03FF03FF03FF03000000000000000000000000FF7FFF7FFF7F
      FF7F1042FF7F104210420000FF7FFF7F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF03FF03FF03FF03FF03
      00000000FF03FF03FF03FF03FF03000000000000000000000000FF7F00000000
      00001042FF7F1042104200000000FF7F000000000000007C007C0000007C007C
      007C007C007C007C007C007C007C007C00000000000000000000000000000000
      00000000000000000000000000000000000000000000FF03FF03FF03FF03FF03
      FF0300000000FF03FF03FF03FF03000000000000000000000000FF7FFF7FFF7F
      FF7FFF7F104210420000FF7FFF7FFF7F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF03FF03FF03FF03FF03
      FF0300000000FF03FF03FF03FF03000000000000000000000000FF7F00000000
      0000000010421042000000000000FF7F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF03FF03FF03FF03FF03
      FF03FF03FF03FF03FF03FF03FF03000000000000000000000000FF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF03FF03FF03FF03FF03
      FF03FF03FF03FF03FF03FF03FF03000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000EF3D0000000000000000
      00000000000000000000EF3D00000000000000000000EF3D0000000000000000
      00000000000000000000EF3D000000000000000000000000EF3DEF3D0000EF3D
      EF3DEF3DEF3DEF3DEF3D0000EF3DEF3D00000000000000000000000000000000
      000000000000000000000000000000000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E0000000000000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E00000000000000000000000000000000000000000000
      00000000000000000000000000000000EF3D0000000000000000000010001000
      1F0010001F00000000000000000000000000000000000000F75E0000F75E0000
      F75E007C007C007CF75E0000000000000000000000000000F75E0000F75E0000
      F75E007C007C007CF75E00000000000000000000000000000000000000000000
      00000000000000000000F75EEF3D0000EF3D00000000000010001F0010001000
      10001F001000100010000000000000000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E0000000000000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E00000000000000000000000000000000000000000000
      0000000000000000F75EF75EF75E000000000000000010001F00100000420042
      100010001000100010001000000000000000000000000000F75E0000F75E0000
      F75E0000F75E0000F75E0000000000000000000000000000F75E0000F75E0000
      F75E0000F75E0000F75E00000000000000000000000000000000000000000000
      00000000000000420042F75E000000000000000010001F0010001F0000420042
      10001F0010001F0010000042004200000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E0000000000000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E00000000000000000000000000000000000000000000
      0000000000420042E07F0000000000000000000010001F001F001F0000420042
      004210001000100010000042004200000000000000000000F75E0000F75E0000
      F75E0000F75E0000F75E0000000000000000000000000000F75E0000F75E0000
      F75E0000F75E0000F75E00000000000000000000000000000000000000000000
      000000420042E07F000000000000000000001F001F001F001F001F0000420042
      00421F001F001F0010001F00100010000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E0000000000000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E00000000000000000000000000000000000000000000
      00420042E07F00000000000000000000000010001F001F000042004200420042
      00421F001F001F001000100010001F000000000000000000F75E0000F75E0000
      F75E0000F75E0000F75E0000000000000000000000000000F75E0000F75E0000
      F75E0000F75E0000F75E00000000000000000000000000000000000000000042
      0042E07F00000000000000000000000000001F00100000420042004200420042
      00421F0000421F0010001F001F001F000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E0000000000000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E00000000000000000000000000000000000000420042
      E07F0000000000000000000000000000000010001F001F000042004200420042
      00420042004200421F0010001F0010000000000000000000F75E000000000000
      0000000000000000F75E0000000000000000000000000000F75E000000000000
      0000000000000000F75E0000000000000000000000000000000000420042E07F
      0000000000000000000000000000000000001F001F001F00004200421F001F00
      10000042004200421F001F0010001F000000000000000000F75E000000000000
      FF030000FF030000F75E0000000000000000000000000000F75E000000000000
      FF030000FF030000F75E000000000000000000000000000000420000E07F0000
      00000000000000000000000000000000000000001F001F001F001F001F000042
      0042004200420042004210001F0000000000000000000000F75E000000000000
      0000000000000000F75E0000000000000000000000000000F75E000000000000
      0000000000000000F75E00000000000000000000000000000000E07F00000000
      000000000000000000000000000000000000000010001F000042004200420042
      004200420042004200421F001F0000000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E0000000000000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E000000000000000000000040007C0000000000000000
      0000000000000000000000000000000000000000000000420042004200421F00
      1F0000421F00004200421F00000000000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E0000000000000000000000000000F75EF75EF75EF75E
      F75EF75EF75EF75EF75E00000000000000000000007C007C0000000000000000
      000000000000000000000000000000000000000000000000004200421F001F00
      10001F0010001F001F00000000000000000000000000EF3D0000000000000000
      00000000000000000000EF3D00000000000000000000EF3D0000000000000000
      00000000000000000000EF3D0000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000001F001000
      1F001F001F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF03FF03FF030000000000000000000000000000
      0000000000000000000000000000000000000000000000000000007C00400040
      0040004000400040004000400000000000000000000000000000007C00400040
      00400040004000400040004000000000000000000000000000000000FF7FFF7F
      00000000FF7FE07FFF7FE07F0000FF03FF030000000000000000000000000000
      0000000000000000000000000000000000000000004000400000007CF75E0000
      F75E0000F75E0000F75E00400000000000000000004000400000007CF75E0000
      F75E0000F75E0000F75E004000000000000000000000000000000000FF7F0000
      E07FFF7FE07F0000E07FFF7FE07F0000FF030000000000000000000000000000
      0000000000000000000000000000000000000040000000000000007C007C007C
      007C007C007C007C007C00400000000000000040000000000000007C007C007C
      007C007C007C007C007C004000000000000000000000000000000000FF7FFF7F
      000000000000E07FFF7FE07FFF7FE07F00000000EF3DFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FEF3D000000400000000000000000007CF75E
      0000F75E0000F75E007C000000000000000000400000000000000000007CF75E
      0000F75E0000F75E007C000000000000000000000000000000000000FF7FFF7F
      FF7F0000E07FFF7FE07FFF7FE07FFF7F00000000FF7FEF3DEF3DFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FEF3DEF3DFF7F0000004000000000000000400000007C
      007C007C007C007C00000040000000000000004000000000000000400000007C
      007C007C007C007C000000400000000000000000000000000000000000000000
      0000E07FFF7F0000FF7FE07FFF7FE07F00000000FF7FFF7FFF7FEF3DEF3DFF7F
      FF7FFF7FFF7FEF3DEF3DFF7FFF7FFF7F0000EF3D000000400040004000000000
      000000000000000000000040004000400000EF3D000000400040004000000000
      000000000000000000000040004000400000000000000000FF7FE07FFF7FE07F
      0000FF7F0000FF7FE07F0000E07FFF7F00000000FF7FFF7FFF7FFF7FFF7F0000
      000000000000FF7FFF7FFF7FFF7FFF7F000000000000007C007C007C00000040
      00400040004000400000007C007C007C000000000000007C007C007C00000040
      00400040004000400000007C007C007C0000FF030000FF7FE07F000000000000
      00000000000000000000E07FFF7F000000000000FF7FFF7FFF7FEF3D0000FF03
      FF03FF03FF030000EF3DFF7FFF7FFF7F0000000000000000007C007C007C007C
      007C007C007C007C007C007C007C00000000000000000000007C007C007C007C
      007C007C007C007C007C007C007C00000000FF030000E07FFF7FE07FFF7FE07F
      FF7FE07FFF7FE07F0000FF7F0000FF7F00000000FF7FEF3D0000EF3DFF7FFF7F
      FF7FFF7FFF7FFF7FEF3D0000EF3DFF7F00000000000000000040000000000000
      0000000000000000000000000040000000000000000000000040000000000000
      000000000000000000000000004000000000FF030000FF7FE07FFF7FE07F0000
      000000000000000000000000FF7FFF7F000000000000EF3DFF03FF03FF03FF03
      FF03FF03FF03FF03FF03FF03EF3D000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF030000E07FFF7FE07FFF7FE07F
      FF7FE07FFF7FE07F0000FF7FFF7FFF7F00000000EF3DEF3DEF3DEF3DEF3DEF3D
      EF3DEF3DEF3DEF3DEF3DEF3DEF3DEF3D00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF030000FF7FE07FFF7FE07F0000
      0000000000000000FF7F000000000000000000000000EF3DFF03FF03FF03FF03
      FF03FF03FF03FF03FF03FF03EF3D000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF0300000000FF7FE07FFF7FE07F
      FF7FE07F0000FF7FFF7F0000FF7FFF7F000000000000EF3D0000EF3DFF7FFF7F
      FF7FFF7FFF7FFF7FEF3D0000EF3D000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF7FFF7FFF7F0000FF7F000000000000000000000000EF3D0000EF3D
      FF03FF03EF3D0000EF3D00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF7FFF7F
      FF7FFF7FFF7FFF7FFF7F0000000000000000000000000000000000000000EF3D
      00000000EF3D0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000C003FBFFFFFF0000C003F3FFF8010000
      C003E3FFFFFF0000C003C000FF010000C0038000FFFF0000C003C3FCFF010000
      C003E3BCFFFF0000C003E040F8010000C003E004FFFF0000C003E604F8010000
      C003E008FFFF0000C003E70CC8010000C003E010FFFF0000C003E79CC0010000
      C003E000FFFF0000C003E000FFFF0000C007C007E408FFFFC007C007FFF0F83F
      C007C007FFE0E00FC007C007FFC1C007C007C007FF838003C007C007FF078003
      C007C007FE0F0001C007C007FC1F0001C007C007F83F0001C007C007F07F0001
      C007C007E0FF0001C007C007C1FF8003C007C00783FF8003C007C00707FFC007
      C007C0070FFFE00FC007C0079FFFF83FE003E003F000FFFFE003E003F000FFFF
      80038003F000000060036003F000000070077007F000000000000000E0000000
      00000000000000008000800000000000C001C00100000000E003E00300000000
      FFFFFFFF00000000FFFFFFFF00008001FFFFFFFF0000C003FFFFFFFF2001F00F
      FFFFFFFFF003FC3FFFFFFFFFF007FFFF00000000000000000000000000000000
      000000000000}
  end
end
