object FFigyra: TFFigyra
  Left = 741
  Top = 235
  Width = 262
  Height = 161
  Caption = 'FFigyra'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DgNewFigyre: TDrawGrid
    Left = 0
    Top = 0
    Width = 254
    Height = 134
    Align = alClient
    ColCount = 4
    DefaultColWidth = 60
    DefaultRowHeight = 60
    FixedCols = 0
    RowCount = 2
    FixedRows = 0
    TabOrder = 0
    OnDrawCell = DgNewFigyreDrawCell
    OnMouseUp = DgNewFigyreMouseUp
  end
end
