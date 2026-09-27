object frmEdicion: TfrmEdicion
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Edici'#243'n'
  ClientHeight = 147
  ClientWidth = 440
  Color = 16447477
  CustomTitleBar.CaptionAlignment = taCenter
  CustomTitleBar.Control = TitleBarPanel1
  CustomTitleBar.Enabled = True
  CustomTitleBar.Height = 26
  CustomTitleBar.BackgroundColor = clWhite
  CustomTitleBar.ForegroundColor = 65793
  CustomTitleBar.InactiveBackgroundColor = clWhite
  CustomTitleBar.InactiveForegroundColor = 10066329
  CustomTitleBar.ButtonForegroundColor = 65793
  CustomTitleBar.ButtonBackgroundColor = clWhite
  CustomTitleBar.ButtonHoverForegroundColor = 65793
  CustomTitleBar.ButtonHoverBackgroundColor = 16053492
  CustomTitleBar.ButtonPressedForegroundColor = 65793
  CustomTitleBar.ButtonPressedBackgroundColor = 15395562
  CustomTitleBar.ButtonInactiveForegroundColor = 10066329
  CustomTitleBar.ButtonInactiveBackgroundColor = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Top = 26
  OldCreateOrder = True
  Position = poOwnerFormCenter
  StyleElements = [seBorder]
  PixelsPerInch = 96
  TextHeight = 15
  object TitleBarPanel1: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 440
    Height = 25
    CustomButtons = <>
  end
  object pnlTitulo: TPanel
    Left = 0
    Top = 25
    Width = 440
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 12
      Width = 31
      Height = 15
      Caption = 'T'#237'tulo'
    end
    object lblSubtitulo: TLabel
      Tag = 13
      Left = 20
      Top = 37
      Width = 48
      Height = 15
      Caption = 'Subt'#237'tulo'
    end
  end
  object pnlPie: TRelativePanel
    Tag = 2
    Left = 0
    Top = 87
    Width = 440
    Height = 60
    ControlCollection = <
      item
        Control = btnGuardar
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = True
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
      end
      item
        Control = btnCancelar
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
        LeftOf = btnGuardar
      end>
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      440
      60)
    object btnGuardar: TPlanoBotonWin
      AlignWithMargins = True
      Left = 300
      Top = 14
      Width = 120
      Height = 32
      Cursor = crHandPoint
      Margins.Right = 20
      Anchors = [akTop, akRight]
      Caption = 'Guardar'
      TabOrder = 0
      StyleElements = []
    end
    object btnCancelar: TPlanoBotonWin
      AlignWithMargins = True
      Left = 174
      Top = 14
      Width = 120
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Cancelar'
      TabOrder = 1
      StyleElements = []
      OnClick = btnCancelarClick
      Kind = fkSecondary
    end
  end
end
