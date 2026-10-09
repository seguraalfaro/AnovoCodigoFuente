inherited frmEnvioCotizacion: TfrmEnvioCotizacion
  Caption = 'Enviar al cliente'
  ClientHeight = 640
  ClientWidth = 620
  OnDestroy = FormDestroy
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
      Caption = 'Enviar al cliente'
    end
    inherited lblSubtitulo: TLabel
      Top = 40
      Caption = 'El correo lleva la cotizaci'#243'n en PDF y la marca como enviada'
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 580
    Width = 620
    TabOrder = 2
    inherited btnGuardar: TPlanoBotonWin
      Left = 420
      Width = 180
      Caption = 'Enviar desde el servidor'
      Enabled = False
      OnClick = btnGuardarClick
    end
    inherited btnCancelar: TPlanoBotonWin
      Left = 294
    end
  end
  object pnlCampos: TPanel
    Tag = 2
    Left = 0
    Top = 87
    Width = 620
    Height = 493
    Align = alClient
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 1
    object edPara: TrDBEdit
      Left = 20
      Top = 26
      Width = 580
      Height = 23
      DataField = 'PARA'
      DataSource = dmMemoria.dsEnvioCorreo
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
      DBEditLabel.OwnCaption = 'Para (separe varios correos con coma)'
      DBEditLabel.ShowRequiredBold = True
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object edCopia: TrDBEdit
      Left = 20
      Top = 76
      Width = 580
      Height = 23
      DataField = 'CC'
      DataSource = dmMemoria.dsEnvioCorreo
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
      DBEditLabel.OwnCaption = 'Con copia (opcional)'
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object edAsunto: TrDBEdit
      Left = 20
      Top = 126
      Width = 580
      Height = 23
      DataField = 'ASUNTO'
      DataSource = dmMemoria.dsEnvioCorreo
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
      DBEditLabel.OwnCaption = 'Asunto'
      DBEditLabel.ShowRequiredBold = True
      DBEditLabel.Font.Charset = ANSI_CHARSET
      DBEditLabel.Font.Color = clWindowText
      DBEditLabel.Font.Height = -12
      DBEditLabel.Font.Name = 'Segoe UI'
      DBEditLabel.Font.Style = []
      DBEditLabel.ParentFont = False
    end
    object meMensaje: TrDBMemo
      Left = 20
      Top = 176
      Width = 580
      Height = 200
      BevelInner = bvNone
      BevelOuter = bvNone
      DataField = 'MENSAJE'
      DataSource = dmMemoria.dsEnvioCorreo
      ScrollBars = ssVertical
      TabOrder = 3
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Mensaje'
    end
    object lblAdjunto: TLabel
      Tag = 13
      Left = 20
      Top = 386
      Width = 580
      Height = 17
      AutoSize = False
      WordWrap = True
    end
    object lblVia: TLabel
      Tag = 13
      Left = 20
      Top = 408
      Width = 580
      Height = 36
      AutoSize = False
      WordWrap = True
    end
    object btnVistaPrevia: TPlanoBotonWin
      Tag = 21
      Left = 20
      Top = 450
      Width = 140
      Height = 32
      Cursor = crHandPoint
      Caption = 'Vista previa'
      TabOrder = 4
      StyleElements = []
      OnClick = btnVistaPreviaClick
      Kind = fkSecondary
    end
    object btnManual: TPlanoBotonWin
      Tag = 21
      Left = 170
      Top = 450
      Width = 170
      Height = 32
      Cursor = crHandPoint
      Caption = 'Enviar manualmente'
      TabOrder = 5
      StyleElements = []
      OnClick = btnManualClick
      Kind = fkSecondary
    end
  end
end
