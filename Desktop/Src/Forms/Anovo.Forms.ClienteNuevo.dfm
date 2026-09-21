object frmClienteNuevo: TfrmClienteNuevo
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cliente nuevo'
  ClientHeight = 592
  ClientWidth = 527
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
  StyleElements = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object pnlTitulo: TPanel
    Left = 0
    Top = 25
    Width = 527
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 518
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 12
      Width = 107
      Height = 25
      Caption = 'Cliente nuevo'
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
      Width = 371
      Height = 15
      Caption = 
        'El consentimiento se otorga en el m'#243'vil, con la firma del repres' +
        'entante'
    end
  end
  object pnlCampos: TPanel
    Left = 0
    Top = 87
    Width = 527
    Height = 447
    Align = alClient
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 518
    ExplicitHeight = 407
    object cbTipoIdentificacion: TrDBLookupComboBox
      Left = 20
      Top = 76
      Width = 230
      Height = 23
      DataField = 'TIPO_IDENTIFICACION'
      DataSource = dmMemoria.dsClienteNuevo
      DropDownRows = 3
      KeyField = 'ID'
      ListField = 'NOMBRE'
      ListSource = dmMemoria.dsTiposIdentificacion
      TabOrder = 1
      ReadOnlyColor = 15987699
      DBEditLabel.OwnCaption = 'Tipo de identificaci'#243'n'
      BoundLabel.Position = lpTopRight
      EmptyDisplayValue = 'Sin especificar'
    end
    object rDBEdit1: TrDBEdit
      Left = 20
      Top = 25
      Width = 480
      Height = 23
      DataField = 'NOMBRE'
      DataSource = dmMemoria.dsClienteNuevo
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
      DBEditLabel.OwnCaption = 'Nombre o raz'#243'n social'
      DBEditLabel.ShowRequiredBold = True
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object rDBEdit2: TrDBEdit
      Left = 270
      Top = 76
      Width = 230
      Height = 23
      DataField = 'IDENTIFICACION'
      DataSource = dmMemoria.dsClienteNuevo
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
      DBEditLabel.OwnCaption = 'Identificaci'#243'n'
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object rDBEdit3: TrDBEdit
      Left = 270
      Top = 126
      Width = 230
      Height = 23
      DataField = 'CORREO'
      DataSource = dmMemoria.dsClienteNuevo
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
    object rDBMemo1: TrDBMemo
      Left = 20
      Top = 289
      Width = 483
      Height = 137
      BevelInner = bvNone
      BevelOuter = bvNone
      DataField = 'DIRECCION'
      DataSource = dmMemoria.dsClienteNuevo
      PopupMenu = rDBMemo1.pmSearch
      ScrollBars = ssVertical
      TabOrder = 7
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Direcci'#243'n'
    end
    object leCodigoExoneracion: TrDBEdit
      Left = 270
      Top = 233
      Width = 230
      Height = 23
      DataField = 'CODIGO_EXONERACION'
      DataSource = dmMemoria.dsClienteNuevo
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'C'#243'digo de exoneraci'#243'n  '
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object rDBEdit4: TrDBEdit
      Left = 20
      Top = 126
      Width = 230
      Height = 23
      DataField = 'TELEFONO'
      DataSource = dmMemoria.dsClienteNuevo
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 15
      ParentFont = False
      TabOrder = 3
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
    object chkExonerado: TrDBCheckBox
      Left = 20
      Top = 217
      Width = 97
      Height = 17
      Caption = 'Exonerado'
      DataField = 'EXONERADO'
      DataSource = dmMemoria.dsClienteNuevo
      TabOrder = 6
      OnClick = chkExoneradoClick
      ReadOnlyColor = 15987699
      ShowFieldCaption = False
    end
    object rDBEdit5: TrDBEdit
      Left = 17
      Top = 177
      Width = 480
      Height = 23
      DataField = 'CONTACTO'
      DataSource = dmMemoria.dsClienteNuevo
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Contacto'
      DBEditLabel.ShowRequiredBold = True
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
  end
  object pnlPie: TPanel
    Left = 0
    Top = 534
    Width = 527
    Height = 58
    Align = alBottom
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 2
    ExplicitTop = 494
    ExplicitWidth = 518
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
    Width = 527
    Height = 25
    CustomButtons = <
      item
        ButtonType = sbCustom
        Enabled = True
        Width = 32
        Visible = True
      end>
    ExplicitWidth = 518
    DesignSize = (
      527
      25)
  end
end
