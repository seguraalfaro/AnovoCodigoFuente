object frmContactoNuevo: TfrmContactoNuevo
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Contacto nuevo'
  ClientHeight = 365
  ClientWidth = 514
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
  Font.Color = 1973276
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Top = 26
  OldCreateOrder = True
  Position = poOwnerFormCenter
  StyleElements = []
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object pnlTitulo: TPanel
    Left = 0
    Top = 25
    Width = 514
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 0
    ExplicitTop = 0
    ExplicitWidth = 520
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 12
      Width = 126
      Height = 25
      Caption = 'Contacto nuevo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblSubtitulo: TLabel
      Tag = 13
      Left = 20
      Top = 40
      Width = 262
      Height = 15
      Caption = 'Un solo contacto puede ser el principal del cliente'
    end
  end
  object pnlCampos: TPanel
    Left = 0
    Top = 87
    Width = 514
    Height = 212
    Align = alClient
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 1
    ExplicitTop = 62
    ExplicitWidth = 520
    ExplicitHeight = 238
    object edNombre: TrDBEdit
      Left = 20
      Top = 26
      Width = 480
      Height = 23
      DataField = 'NOMBRE'
      DataSource = dmMemoria.dsContactoNuevo
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Nombre'
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object edArea: TrDBEdit
      Left = 20
      Top = 76
      Width = 230
      Height = 23
      DataField = 'AREA'
      DataSource = dmMemoria.dsContactoNuevo
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Departamento'
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object edTelefono: TrDBEdit
      Left = 270
      Top = 76
      Width = 230
      Height = 23
      DataField = 'TELEFONO'
      DataSource = dmMemoria.dsContactoNuevo
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Tel'#233'fono'
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object edCelular: TrDBEdit
      Left = 20
      Top = 126
      Width = 230
      Height = 23
      DataField = 'CELULAR'
      DataSource = dmMemoria.dsContactoNuevo
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Celular'
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object edCorreo: TrDBEdit
      Left = 270
      Top = 126
      Width = 230
      Height = 23
      DataField = 'CORREO'
      DataSource = dmMemoria.dsContactoNuevo
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Correo'
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object chkPrincipal: TrDBCheckBox
      Left = 20
      Top = 172
      Width = 240
      Height = 17
      Caption = 'Es el contacto principal'
      DataField = 'PRINCIPAL'
      DataSource = dmMemoria.dsContactoNuevo
      TabOrder = 5
      ReadOnlyColor = 15987699
      ShowFieldCaption = False
    end
  end
  object pnlPie: TPanel
    Left = 0
    Top = 299
    Width = 514
    Height = 66
    Align = alBottom
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 2
    ExplicitTop = 300
    ExplicitWidth = 520
    object btnGuardar: TPlanoBotonWin
      Left = 380
      Top = 18
      Width = 120
      Height = 30
      Cursor = crHandPoint
      Caption = 'Guardar'
      TabOrder = 0
      StyleElements = []
      OnClick = btnGuardarClick
    end
    object btnCancelar: TPlanoBotonWin
      Left = 250
      Top = 18
      Width = 120
      Height = 30
      Cursor = crHandPoint
      Caption = 'Cancelar'
      TabOrder = 1
      StyleElements = []
      OnClick = btnCancelarClick
      Kind = fkSecondary
    end
  end
  object TitleBarPanel1: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 514
    Height = 25
    CustomButtons = <
      item
        ButtonType = sbCustom
        Enabled = True
        Width = 32
        Visible = True
      end>
    ExplicitLeft = -8
    ExplicitTop = -19
    DesignSize = (
      514
      25)
  end
end
