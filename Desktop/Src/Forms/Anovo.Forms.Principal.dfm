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
  Position = poOwnerFormCenter
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
      Tag = 1
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
        Tag = 14
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
    object RelativePanel1: TRelativePanel
      Tag = 1
      Left = 0
      Top = 62
      Width = 200
      Height = 546
      ControlCollection = <
        item
          Control = FnDashboard
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = True
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = FnCotizaciones
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
          Below = FnDashboard
        end
        item
          Control = FnClientes
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = FnReportes
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = FnUsuarios
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = FnRoles
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = FnConfiguracion
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
          Below = FnRoles
        end
        item
          Control = PlanoNavItem1
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = True
          AlignRightWithPanel = True
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end>
      Align = alClient
      BevelOuter = bvNone
      Color = 6044186
      ParentBackground = False
      TabOrder = 2
      StyleElements = []
      DesignSize = (
        200
        546)
      object FnDashboard: TFlatNavItem
        Left = 5
        Top = 0
        Width = 189
        Height = 40
        SelectedColor = clGrayText
        Images = dmIconos.ViAnovo
        ImageIndex = 62
        Action = AcDashboard
        Align = alTop
        ParentShowHint = False
        ShowHint = False
      end
      object FnCotizaciones: TFlatNavItem
        Left = 5
        Top = 40
        Width = 189
        Height = 40
        SelectedColor = clGrayText
        Images = dmIconos.ViAnovo
        ImageIndex = 50
        Action = AcCotizaciones
        Align = alTop
        ParentShowHint = False
        ShowHint = False
      end
      object FnClientes: TFlatNavItem
        Left = 5
        Top = 72
        Width = 189
        Height = 40
        SelectedColor = clGrayText
        Images = dmIconos.ViAnovo
        ImageIndex = 66
        Action = AcClientes
        Align = alTop
        ParentShowHint = False
        ShowHint = False
      end
      object FnReportes: TFlatNavItem
        Left = 5
        Top = 146
        Width = 189
        Height = 40
        SelectedColor = clGrayText
        Images = dmIconos.ViAnovo
        ImageIndex = 60
        Action = AcReportes
        Align = alTop
        ParentShowHint = False
        ShowHint = False
      end
      object FnUsuarios: TFlatNavItem
        Left = 5
        Top = 192
        Width = 189
        Height = 40
        SelectedColor = clGrayText
        Images = dmIconos.ViAnovo
        ImageIndex = 66
        Action = AcUsuarios
        Align = alTop
        ParentShowHint = False
        ShowHint = False
      end
      object FnRoles: TFlatNavItem
        Left = 5
        Top = 222
        Width = 189
        Height = 40
        SelectedColor = clGrayText
        Images = dmIconos.ViAnovo
        ImageIndex = 68
        Action = AcRoles
        Align = alTop
        ParentShowHint = False
        ShowHint = False
      end
      object FnConfiguracion: TFlatNavItem
        Left = 5
        Top = 262
        Width = 189
        Height = 40
        SelectedColor = clGrayText
        Images = dmIconos.ViAnovo
        ImageIndex = 70
        Action = AcConfiguracion
        Align = alTop
        ParentShowHint = False
        ShowHint = False
      end
      object PlanoNavItem1: TPlanoNavItem
        AlignWithMargins = True
        Left = 3
        Top = 106
        Width = 194
        Height = 40
        Images = dmIconos.ViAnovo
        ImageIndex = 58
        Action = AcBandeja
        Anchors = []
      end
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
    object AcDashboard: TAction
      Caption = 'Dashboard'
      ImageIndex = 62
      ImageName = 'Blanco\06-dashboard-blanco'
      OnExecute = AcDashboardExecute
    end
    object AcCotizaciones: TAction
      Caption = 'Cotizaciones'
      ImageIndex = 50
      ImageName = 'Blanco\00-cotizaciones-blanco'
    end
    object acNueva: TAction
      Caption = 'Nueva'
      ImageIndex = 76
      ImageName = 'Blanco\13-agregar-blanco'
    end
    object AcClientes: TAction
      Caption = 'Clientes'
      ImageIndex = 66
      ImageName = 'Blanco\08-usuarios-blanco'
    end
    object AcMateriales: TAction
      Caption = 'AcMateriales'
    end
    object AcReportes: TAction
      Caption = 'Reportes'
      ImageIndex = 60
      ImageName = 'Blanco\05-reportes-blanco'
    end
    object AcBandeja: TAction
      Caption = 'Bandeja'
      ImageIndex = 58
      ImageName = 'Blanco\04-bandeja-blanco'
    end
    object AcSalir: TAction
      Caption = 'Cerrar Sesi'#243'n'
      ImageIndex = 72
      ImageName = 'Blanco\11-salir-blanco'
    end
    object AcConfiguracion: TAction
      Caption = 'Configuraci'#243'n'
      ImageIndex = 70
      ImageName = 'Blanco\10-configuracion-blanco'
    end
    object AcRoles: TAction
      Caption = 'Roles'
      ImageIndex = 68
      ImageName = 'Blanco\09-roles-blanco'
    end
    object AcUsuarios: TAction
      Caption = ' Usuarios'
      ImageIndex = 66
      ImageName = 'Blanco\08-usuarios-blanco'
    end
  end
end
