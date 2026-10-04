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
  GlassFrame.Enabled = True
  GlassFrame.Top = 31
  OldCreateOrder = False
  Position = poDesktopCenter
  StyleElements = [seFont]
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object TitleBarPanel1: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 1180
    Height = 30
    CustomButtons = <>
    object VirtualImage1: TVirtualImage
      Left = 10
      Top = 28
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
    Left = 200
    Top = 30
    Width = 980
    Height = 670
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
  end
  object SV: TSplitView
    Left = 0
    Top = 30
    Width = 200
    Height = 670
    AnimationDelay = 1
    AnimationStep = 400
    CloseStyle = svcCompact
    Color = 6044186
    CompactWidth = 40
    OpenedWidth = 200
    Placement = svpLeft
    TabOrder = 2
    StyleElements = [seFont, seBorder]
    object pnlUsuario: TRelativePanel
      Tag = 5
      Left = 0
      Top = 0
      Width = 200
      Height = 41
      ControlCollection = <
        item
          Control = lblRol
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = lblUsuario
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = pnlAvatar
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end>
      Align = alTop
      BevelOuter = bvNone
      Color = 6044186
      ParentBackground = False
      TabOrder = 0
      StyleElements = []
      DesignSize = (
        200
        41)
      object lblRol: TLabel
        Tag = 23
        Left = 50
        Top = 26
        Width = 150
        Height = 15
        Anchors = []
        AutoSize = False
        Caption = 'rol'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 15260880
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblUsuario: TLabel
        Tag = 24
        Left = 50
        Top = 12
        Width = 150
        Height = 16
        Anchors = []
        AutoSize = False
        Caption = 'Usuario'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object pnlAvatar: TPanel
        Tag = 1
        Left = 5
        Top = 5
        Width = 36
        Height = 36
        Anchors = []
        BevelOuter = bvNone
        Color = 9067566
        ParentBackground = False
        TabOrder = 0
        StyleElements = []
        object lblIniciales: TLabel
          Tag = 1
          Left = 0
          Top = 0
          Width = 36
          Height = 36
          Align = alClient
          Alignment = taCenter
          Caption = 'MS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'Segoe UI Semibold'
          Font.Style = []
          ParentFont = False
          Transparent = True
          Layout = tlCenter
          StyleElements = [seFont, seBorder]
          ExplicitWidth = 19
          ExplicitHeight = 17
        end
      end
    end
    object pnsep: TRelativePanel
      Tag = 6
      AlignWithMargins = True
      Left = 3
      Top = 51
      Width = 194
      Height = 1
      Margins.Top = 10
      Margins.Bottom = 10
      ControlCollection = <>
      Align = alTop
      Color = 14999257
      ParentBackground = False
      TabOrder = 1
      StyleElements = []
    end
    object pnlMenu: TPanel
      Tag = 1
      Left = 0
      Top = 62
      Width = 200
      Height = 546
      Align = alClient
      BevelOuter = bvNone
      Color = 6044186
      Padding.Left = 5
      Padding.Right = 6
      ParentBackground = False
      TabOrder = 2
      StyleElements = []
    end
    object pnlBottom: TRelativePanel
      Tag = 1
      Left = 0
      Top = 629
      Width = 200
      Height = 41
      ControlCollection = <
        item
          Control = FlatNavItem1
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = True
          AlignVerticalCenterWithPanel = False
        end>
      Align = alBottom
      BevelOuter = bvNone
      Color = 6044186
      ParentBackground = False
      TabOrder = 3
      StyleElements = []
      object FlatNavItem1: TFlatNavItem
        Left = 5
        Top = 0
        Width = 189
        Height = 40
        SelectedColor = clGrayText
        Images = dmIconos.ViAnovo
        ImageIndex = 72
        Action = AcSalir
        Align = alTop
        ParentShowHint = False
        ShowHint = False
      end
    end
    object pnlsepBottom: TRelativePanel
      Tag = 6
      AlignWithMargins = True
      Left = 3
      Top = 618
      Width = 194
      Height = 1
      Margins.Top = 10
      Margins.Bottom = 10
      ControlCollection = <>
      Align = alBottom
      Color = 14999257
      ParentBackground = False
      TabOrder = 4
      StyleElements = []
    end
  end
  object ActionList1: TActionList
    Images = dmIconos.ViAnovo
    Left = 824
    Top = 366
    object AcSalir: TAction
      Caption = 'Cerrar sesi'#243'n'
      ImageIndex = 72
      ImageName = 'Blanco\11-salir-blanco'
      OnExecute = AcSalirExecute
    end
  end
  object tmrAvisos: TTimer
    Enabled = False
    OnTimer = tmrAvisosTimer
    Left = 824
    Top = 430
  end
end
