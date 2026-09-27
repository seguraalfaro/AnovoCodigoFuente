inherited frmContactoNuevo: TfrmContactoNuevo
  Caption = 'Contacto nuevo'
  ClientHeight = 365
  ClientWidth = 514
  OnDestroy = FormDestroy
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 514
    CustomButtons = <
      item
        ButtonType = sbCustom
        Enabled = True
        Width = 32
        Visible = True
      end>
  end
  inherited pnlTitulo: TPanel
    Width = 514
    inherited lblTitulo: TLabel
      Caption = 'Contacto nuevo'
    end
    inherited lblSubtitulo: TLabel
      Top = 40
      Caption = 'Un solo contacto puede ser el principal del cliente'
    end
  end
  inherited pnlPie: TRelativePanel
    TabOrder = 2
    inherited btnGuardar: TPlanoBotonWin
      OnClick = btnGuardarClick
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
end
