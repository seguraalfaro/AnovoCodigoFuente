inherited frmDocumentoEmpresa: TfrmDocumentoEmpresa
  Caption = 'Documento de la cotizaci'#243'n'
  ClientHeight = 560
  ClientWidth = 620
  OnClose = FormClose
  OnCreate = FormCreate
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 620
    CustomButtons = <
      item
        ButtonType = sbCustom
        Enabled = True
        Width = 32
        Visible = True
      end>
  end
  inherited pnlTitulo: TPanel
    Width = 620
    inherited lblTitulo: TLabel
      Caption = 'Documento de la cotizaci'#243'n'
    end
    inherited lblSubtitulo: TLabel
      Top = 40
      Caption = 'Firma, condiciones por defecto y carta de la segunda p'#225'gina'
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 500
    Width = 620
    TabOrder = 2
    inherited btnGuardar: TPlanoBotonWin
      Left = 480
      OnClick = btnGuardarClick
    end
    inherited btnCancelar: TPlanoBotonWin
      Left = 354
    end
  end
  object pnlCampos: TPanel
    Tag = 2
    Left = 0
    Top = 87
    Width = 620
    Height = 413
    Align = alClient
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 1
    object edFirmante: TrDBEdit
      Left = 20
      Top = 26
      Width = 280
      Height = 23
      DataField = 'FIRMANTE'
      DataSource = dmMemoria.dsEmpresa
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
      DBEditLabel.OwnCaption = 'Firma la cotizaci'#243'n'
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object edFormaPago: TrDBEdit
      Left = 320
      Top = 26
      Width = 280
      Height = 23
      DataField = 'FORMA_PAGO'
      DataSource = dmMemoria.dsEmpresa
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
      DBEditLabel.OwnCaption = 'Forma de pago'
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object edEntrega: TrDBEdit
      Left = 20
      Top = 76
      Width = 280
      Height = 23
      DataField = 'PLAZO_ENTREGA'
      DataSource = dmMemoria.dsEmpresa
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
      DBEditLabel.OwnCaption = 'Entrega'
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object edGarantia: TrDBEdit
      Left = 320
      Top = 76
      Width = 280
      Height = 23
      DataField = 'GARANTIA'
      DataSource = dmMemoria.dsEmpresa
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
      DBEditLabel.OwnCaption = 'Garant'#237'a'
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object meCarta: TrDBMemo
      Left = 20
      Top = 126
      Width = 580
      Height = 270
      BevelInner = bvNone
      BevelOuter = bvNone
      DataField = 'CARTA_PRESENTACION'
      DataSource = dmMemoria.dsEmpresa
      ScrollBars = ssVertical
      TabOrder = 4
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Carta de presentaci'#243'n (segunda p'#225'gina)'
    end
  end
end
