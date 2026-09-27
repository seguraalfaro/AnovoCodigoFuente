inherited frmClienteNuevo: TfrmClienteNuevo
  Caption = 'Cliente nuevo'
  ClientHeight = 592
  ClientWidth = 527
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 527
    CustomButtons = <
      item
        ButtonType = sbCustom
        Enabled = True
        Width = 32
        Visible = True
      end>
  end
  inherited pnlTitulo: TPanel
    Width = 527
    inherited lblTitulo: TLabel
      Caption = 'Cliente nuevo'
    end
    inherited lblSubtitulo: TLabel
      Top = 40
      Caption = 
        'El consentimiento se otorga en el m'#243'vil, con la firma del repres' +
        'entante'
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
    Width = 527
    Height = 447
    Align = alClient
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 1
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
end
