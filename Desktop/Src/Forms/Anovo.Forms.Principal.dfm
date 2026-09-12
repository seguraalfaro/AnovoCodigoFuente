object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Sistema de Gesti'#243'n de Cotizaciones '#8212' Anovo'
  ClientHeight = 700
  ClientWidth = 1180
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  CustomTitleBar.Control = TitleBarPanel1
  CustomTitleBar.Enabled = True
  CustomTitleBar.Height = 31
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
  GlassFrame.Top = 31
  OldCreateOrder = False
  Position = poOwnerFormCenter
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object TitleBarPanel1: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 1180
    Height = 55
    CustomButtons = <>
    object VirtualImage1: TVirtualImage
      Left = 3
      Top = 29
      Width = 24
      Height = 24
      Align = alCustom
      ImageCollection = dmIconos.IcAnovo
      ImageWidth = 0
      ImageHeight = 0
      ImageIndex = 175
      ImageName = 'Blanco\25-menu-blanco'
      OnClick = VirtualImage1Click
    end
  end
  object pnlContenido: TPanel
    Tag = 2
    Left = 50
    Top = 55
    Width = 1130
    Height = 645
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 172
    ExplicitTop = 64
    ExplicitWidth = 1008
    ExplicitHeight = 612
  end
  object SV: TSplitView
    Left = 0
    Top = 55
    Width = 50
    Height = 645
    AnimationDelay = 1
    AnimationStep = 400
    CloseStyle = svcCompact
    Color = 6044186
    Opened = False
    OpenedWidth = 200
    Placement = svpLeft
    TabOrder = 2
    StyleElements = [seFont, seBorder]
    ExplicitLeft = 3
    ExplicitTop = 58
    ExplicitHeight = 639
  end
end
