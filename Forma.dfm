object Form1: TForm1
  Left = 230
  Top = 52
  Width = 1032
  Height = 738
  Caption = 'Form1'
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 521
    Height = 515
    Align = alLeft
    TabOrder = 0
    object DgPole: TDrawGrid
      Left = 1
      Top = 1
      Width = 519
      Height = 513
      Align = alClient
      BorderStyle = bsNone
      Color = clInfoBk
      ColCount = 9
      DefaultColWidth = 60
      DefaultRowHeight = 60
      RowCount = 9
      ScrollBars = ssNone
      TabOrder = 0
      OnMouseUp = DgPoleMouseUp
      ColWidths = (
        60
        60
        60
        60
        60
        60
        60
        60
        60)
    end
    object DgKill: TDrawGrid
      Left = 1
      Top = 1
      Width = 519
      Height = 513
      Align = alClient
      BorderStyle = bsNone
      Color = clInfoBk
      ColCount = 9
      DefaultColWidth = 60
      DefaultRowHeight = 60
      RowCount = 9
      ScrollBars = ssNone
      TabOrder = 1
      ColWidths = (
        60
        60
        60
        60
        60
        60
        60
        60
        60)
    end
  end
  object Panel2: TPanel
    Left = 521
    Top = 0
    Width = 503
    Height = 515
    Align = alClient
    TabOrder = 1
    object LbKol: TLabel
      Left = 24
      Top = 304
      Width = 139
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1093#1086#1076#1086#1074' '#1074' '#1076#1077#1088#1077#1074#1077
    end
    object LbZnat: TLabel
      Left = 24
      Top = 358
      Width = 139
      Height = 13
      Caption = #1059#1088#1086#1074#1077#1085#1100' '#1087#1086#1075#1088#1077#1096#1085#1086#1089#1090#1080' '#1093#1086#1076#1072
    end
    object RgWhite: TRadioGroup
      Left = 24
      Top = 8
      Width = 89
      Height = 65
      Caption = #1041#1077#1083#1099#1077
      ItemIndex = 0
      Items.Strings = (
        #1048#1075#1088#1086#1082
        #1050#1086#1084#1087#1100#1102#1090#1077#1088)
      TabOrder = 0
    end
    object RgBlack: TRadioGroup
      Left = 144
      Top = 8
      Width = 89
      Height = 65
      Caption = #1063#1077#1088#1085#1099#1077
      ItemIndex = 0
      Items.Strings = (
        #1048#1075#1088#1086#1082
        #1050#1086#1084#1087#1100#1102#1090#1077#1088)
      TabOrder = 1
    end
    object RgRastanovka: TRadioGroup
      Left = 24
      Top = 80
      Width = 209
      Height = 81
      Caption = #1056#1072#1089#1089#1090#1072#1085#1086#1074#1082#1072' '#1092#1080#1075#1091#1088
      Items.Strings = (
        #1057#1090#1072#1085#1076#1072#1088#1090#1085#1072#1103' '#1088#1072#1089#1090#1072#1085#1086#1074#1082#1072
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1091#1102' '#1088#1072#1089#1090#1072#1085#1086#1074#1082#1091
        #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1088#1072#1089#1090#1072#1085#1086#1074#1082#1091)
      TabOrder = 2
      OnClick = RgRastanovkaClick
    end
    object BtBeginGame: TButton
      Left = 24
      Top = 488
      Width = 75
      Height = 25
      Caption = #1053#1072#1095#1072#1090#1100' '#1080#1075#1088#1091
      Enabled = False
      TabOrder = 3
      Visible = False
      OnClick = BtBeginGameClick
    end
    object MTest: TMemo
      Left = 256
      Top = 16
      Width = 209
      Height = 505
      Lines.Strings = (
        #1058#1077#1089#1090)
      ScrollBars = ssBoth
      TabOrder = 4
    end
    object RgDoskKill: TRadioGroup
      Left = 24
      Top = 416
      Width = 209
      Height = 57
      Caption = #1044#1086#1089#1082#1072'/'#1055#1086#1090#1077#1088#1080
      Items.Strings = (
        #1044#1086#1089#1082#1072
        #1055#1086#1090#1077#1088#1080)
      TabOrder = 5
      OnClick = RgDoskKillClick
    end
    object RgBlackWhite: TRadioGroup
      Left = 25
      Top = 169
      Width = 209
      Height = 65
      Caption = #1060#1080#1075#1091#1088#1072' '#1041#1077#1083#1072#1103'/'#1063#1077#1088#1085#1072#1103
      Enabled = False
      ItemIndex = 0
      Items.Strings = (
        #1041#1077#1083#1072#1103
        #1063#1077#1088#1085#1072#1103)
      TabOrder = 6
      Visible = False
      OnClick = RgBlackWhiteClick
    end
    object MTest1: TMemo
      Left = 240
      Top = 16
      Width = 113
      Height = 249
      Lines.Strings = (
        #1058#1077#1089#1090' 1')
      ScrollBars = ssBoth
      TabOrder = 7
      Visible = False
    end
    object MTest2: TMemo
      Left = 352
      Top = 16
      Width = 113
      Height = 249
      Lines.Strings = (
        #1058#1077#1089#1090' 2')
      ScrollBars = ssBoth
      TabOrder = 8
      Visible = False
    end
    object RgHod: TRadioGroup
      Left = 24
      Top = 240
      Width = 209
      Height = 57
      Caption = #1061#1086#1076
      ItemIndex = 0
      Items.Strings = (
        #1041#1077#1083#1099#1077
        #1063#1077#1088#1085#1099#1077)
      TabOrder = 9
      Visible = False
    end
    object Mtest3: TMemo
      Left = 240
      Top = 264
      Width = 113
      Height = 249
      Lines.Strings = (
        #1058#1077#1089#1090' 3')
      ScrollBars = ssBoth
      TabOrder = 10
      Visible = False
    end
    object Mtest4: TMemo
      Left = 352
      Top = 264
      Width = 113
      Height = 249
      Lines.Strings = (
        #1058#1077#1089#1090' 4')
      ScrollBars = ssBoth
      TabOrder = 11
      Visible = False
    end
    object SeKol: TSpinEdit
      Left = 24
      Top = 320
      Width = 121
      Height = 22
      MaxValue = 8
      MinValue = 1
      TabOrder = 12
      Value = 2
    end
    object SeZnat: TSpinEdit
      Left = 24
      Top = 377
      Width = 121
      Height = 22
      MaxValue = 1000
      MinValue = 0
      TabOrder = 13
      Value = 20
      OnChange = SeZnatChange
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 515
    Width = 1024
    Height = 196
    Align = alBottom
    TabOrder = 2
    object LbProc: TLabel
      Left = 32
      Top = 16
      Width = 526
      Height = 37
      Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1080#1087' '#1088#1072#1089#1089#1090#1072#1085#1086#1074#1082#1080' '#1080' '#1080#1075#1088#1086#1082#1086#1074
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object LbHax: TLabel
      Left = 34
      Top = 56
      Width = 9
      Height = 37
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object BtHod: TButton
      Left = 32
      Top = 120
      Width = 177
      Height = 25
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1074#1086#1080' '#1093#1086#1076#1099
      TabOrder = 0
      OnClick = BtHodClick
    end
    object BtHodProt: TButton
      Left = 32
      Top = 152
      Width = 177
      Height = 25
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1093#1086#1076#1099' '#1087#1088#1086#1090#1080#1074#1085#1080#1082#1072
      TabOrder = 1
      OnClick = BtHodProtClick
    end
    object MMaxHod: TMemo
      Left = 776
      Top = 8
      Width = 209
      Height = 169
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object RgViborHoda: TRadioGroup
      Left = 545
      Top = 59
      Width = 209
      Height = 57
      Caption = #1042#1099#1073#1086#1088' '#1093#1086#1076#1072
      ItemIndex = 0
      Items.Strings = (
        #1051#1091#1095#1096#1080#1081' '#1093#1086#1076
        #1057#1083#1091#1095#1072#1081#1085#1099#1081' '#1080#1079' '#1083#1091#1095#1096#1080#1093' '#1093#1086#1076#1086#1074)
      TabOrder = 3
    end
  end
end
