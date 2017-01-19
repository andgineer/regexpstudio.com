object frmRegExpressionBuilder: TfrmRegExpressionBuilder
  Left = 140
  Top = 58
  Width = 608
  Height = 479
  Caption = 'Regular Expression Builder (single line)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 136
    Top = 288
    Width = 103
    Height = 13
    Caption = 'Number of Characters'
  end
  object Label2: TLabel
    Left = 8
    Top = 0
    Width = 81
    Height = 13
    Caption = 'Character Range'
  end
  object Label3: TLabel
    Left = 200
    Top = 304
    Width = 9
    Height = 13
    Caption = 'to'
  end
  object Label4: TLabel
    Left = 320
    Top = 0
    Width = 64
    Height = 13
    Caption = 'SubMask List'
  end
  object Label5: TLabel
    Left = 0
    Top = 312
    Width = 28
    Height = 13
    Caption = 'Offset'
  end
  object lbResult: TLabel
    Left = 400
    Top = 312
    Width = 5
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 8
    Top = 384
    Width = 32
    Height = 13
    Caption = 'Label7'
  end
  object Label8: TLabel
    Left = 8
    Top = 400
    Width = 32
    Height = 13
    Caption = 'Label8'
  end
  object Label9: TLabel
    Left = 8
    Top = 416
    Width = 32
    Height = 13
    Caption = 'Label9'
  end
  object CharSelect: TRxCheckListBox
    Left = 8
    Top = 16
    Width = 305
    Height = 257
    AutoScroll = False
    Columns = 3
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 0
    OnClick = CharSelectClick
    InternalVersion = 202
    Strings = (
      '. - Any character'
      0
      True
      '  <Space>'
      0
      True
      '!'
      0
      True
      '"'
      0
      True
      '#'
      0
      True
      '$'
      0
      True
      '%'
      0
      True
      '&'
      0
      True
      #39
      0
      True
      '('
      0
      True
      ')'
      0
      True
      '*'
      0
      True
      '+'
      0
      True
      ','
      0
      True
      '-'
      0
      True
      '.'
      0
      True
      '/'
      0
      True
      '0'
      0
      True
      '1'
      0
      True
      '2'
      0
      True
      '3'
      0
      True
      '4'
      0
      True
      '5'
      0
      True
      '6'
      0
      True
      '7'
      0
      True
      '8'
      0
      True
      '9'
      0
      True
      ':'
      0
      True
      ';'
      0
      True
      '<'
      0
      True
      '='
      0
      True
      '>'
      0
      True
      '?'
      0
      True
      '@'
      0
      True
      'A'
      0
      True
      'B'
      0
      True
      'C'
      0
      True
      'D'
      0
      True
      'E'
      0
      True
      'F'
      0
      True
      'G'
      0
      True
      'H'
      0
      True
      'I'
      0
      True
      'J'
      0
      True
      'K'
      0
      True
      'L'
      0
      True
      'M'
      0
      True
      'N'
      0
      True
      'O'
      0
      True
      'P'
      0
      True
      'Q'
      0
      True
      'R'
      0
      True
      'S'
      0
      True
      'T'
      0
      True
      'U'
      0
      True
      'V'
      0
      True
      'W'
      0
      True
      'X'
      0
      True
      'Y'
      0
      True
      'Z'
      0
      True
      '['
      0
      True
      '\'
      0
      True
      ']'
      0
      True
      '^'
      0
      True
      '_'
      0
      True
      '`'
      0
      True
      'a'
      0
      True
      'b'
      0
      True
      'c'
      0
      True
      'd'
      0
      True
      'e'
      0
      True
      'f'
      0
      True
      'g'
      0
      True
      'h'
      0
      True
      'i'
      0
      True
      'j'
      0
      True
      'k'
      0
      True
      'l'
      0
      True
      'm'
      0
      True
      'n'
      0
      True
      'o'
      0
      True
      'p'
      0
      True
      'q'
      0
      True
      'r'
      0
      True
      's'
      0
      True
      't'
      0
      True
      'u'
      0
      True
      'v'
      0
      True
      'w'
      0
      True
      'x'
      0
      True
      'y'
      0
      True
      'z'
      0
      True
      '{'
      0
      True
      '|'
      0
      True
      '}'
      0
      True
      '~'
      0
      True)
  end
  object rxFrom: TRxSpinEdit
    Left = 136
    Top = 304
    Width = 57
    Height = 21
    TabOrder = 1
    OnChange = rxFromChange
  end
  object rxTo: TRxSpinEdit
    Left = 216
    Top = 304
    Width = 49
    Height = 21
    TabOrder = 2
    OnChange = rxToChange
  end
  object RadioButton1: TRadioButton
    Left = 0
    Top = 280
    Width = 65
    Height = 17
    Caption = 'Include'
    TabOrder = 3
  end
  object RadioButton2: TRadioButton
    Left = 64
    Top = 280
    Width = 65
    Height = 17
    Caption = 'Exclude'
    Checked = True
    TabOrder = 4
    TabStop = True
  end
  object Memo1: TMemo
    Left = 112
    Top = 416
    Width = 105
    Height = 33
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 5
  end
  object btnAdd: TButton
    Left = 320
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Add SubMask'
    TabOrder = 6
    OnClick = btnAddClick
  end
  object edOffset: TEdit
    Left = 247
    Top = 368
    Width = 33
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 7
    Text = '1'
  end
  object edInputString: TEdit
    Left = 112
    Top = 392
    Width = 137
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 8
    Text = 'My e-mails is anso@mail.ru and anso@usa.net'
  end
  object edRegExpr: TEdit
    Left = 120
    Top = 364
    Width = 81
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 9
    Text = '[_a-zA-Z\d\-\.]+@[_a-zA-Z\d\-]+(\.[_a-zA-Z\d\-]+)+'
  end
  object rxOffset: TRxSpinEdit
    Left = 32
    Top = 304
    Width = 97
    Height = 21
    Hint = 'Location in string where this submask will start from'
    MaxValue = 64000
    MinValue = 1
    MaxLength = 5
    TabOrder = 10
    OnChange = rxOffsetChange
  end
  object lstSubMasks: TdfsEnhListView
    Left = 320
    Top = 16
    Width = 273
    Height = 257
    NoColumnResize = False
    Columns = <
      item
        Caption = 'Offset'
        MaxWidth = 15
      end
      item
        Caption = 'Expression'
        MaxWidth = 150
        MinWidth = 50
        Width = 100
      end
      item
        Caption = 'Min'
      end
      item
        Caption = 'Max'
      end>
    ReadOnly = True
    HideSelection = False
    MultiSelect = True
    TabOrder = 11
    ViewStyle = vsReport
  end
  object btnClear: TButton
    Left = 408
    Top = 344
    Width = 81
    Height = 25
    Caption = 'Clear SubMasks'
    TabOrder = 12
    OnClick = btnClearClick
  end
  object BitBtn1: TBitBtn
    Left = 504
    Top = 344
    Width = 75
    Height = 25
    TabOrder = 13
    Kind = bkClose
  end
  object reMask: TEdit
    Left = 320
    Top = 280
    Width = 273
    Height = 21
    TabOrder = 14
  end
  object btnTest: TButton
    Left = 320
    Top = 304
    Width = 75
    Height = 25
    Caption = 'Test Mask'
    TabOrder = 15
    OnClick = btnTestClick
  end
end
