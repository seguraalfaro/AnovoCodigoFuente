object fraConfiguracion: TfraConfiguracion
  Left = 0
  Top = 0
  Width = 960
  Height = 690
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlTitulo: TPanel
    Tag = 2
    Left = 0
    Top = 0
    Width = 960
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 10
      Caption = 'Configuraci'#243'n'
    end
    object lblSubtitulo: TLabel
      Tag = 13
      Left = 20
      Top = 40
      Caption = 'Su cuenta, la conexi'#243'n, los datos de la empresa y los par'#225'metros del sistema'
    end
  end
  object pnlCuerpo: TPanel
    Tag = 2
    Left = 0
    Top = 62
    Width = 960
    Height = 628
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object tjCuenta: TPlanoTarjeta
      Tag = 3
      Left = 20
      Top = 8
      Width = 300
      Height = 236
      TitleHeight = 36
      Caption = 'Mi cuenta'
      TabOrder = 0
      object lblNombreRot: TLabel
        Tag = 13
        Left = 16
        Top = 49
        Caption = 'Nombre'
      end
      object lblNombre: TLabel
        Tag = 25
        Left = 124
        Top = 48
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblCorreoRot: TLabel
        Tag = 13
        Left = 16
        Top = 77
        Caption = 'Correo'
      end
      object lblCorreo: TLabel
        Tag = 25
        Left = 124
        Top = 76
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblRolRot: TLabel
        Tag = 13
        Left = 16
        Top = 105
        Caption = 'Rol'
      end
      object lblRol: TLabel
        Tag = 25
        Left = 124
        Top = 104
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblPermisosRot: TLabel
        Tag = 13
        Left = 16
        Top = 133
        Caption = 'Permisos propios'
      end
      object lblPermisos: TLabel
        Tag = 25
        Left = 124
        Top = 132
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblClaveRot: TLabel
        Tag = 13
        Left = 16
        Top = 161
        Caption = 'Clave cambiada'
      end
      object lblClave: TLabel
        Tag = 25
        Left = 124
        Top = 160
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object btnCambiarClave: TPlanoBotonWin
        Left = 16
        Top = 188
        Width = 150
        Height = 32
        Cursor = crHandPoint
        Caption = 'Cambiar mi clave'
        TabOrder = 0
        StyleElements = []
        OnClick = btnCambiarClaveClick
      end
    end
    object tjConexion: TPlanoTarjeta
      Tag = 3
      Left = 332
      Top = 8
      Width = 300
      Height = 236
      TitleHeight = 36
      Caption = 'Conexi'#243'n'
      TabOrder = 1
      object lblServidorRot: TLabel
        Tag = 13
        Left = 16
        Top = 49
        Caption = 'Servidor'
      end
      object lblServidor: TLabel
        Tag = 25
        Left = 124
        Top = 48
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblEstadoRot: TLabel
        Tag = 13
        Left = 16
        Top = 77
        Caption = 'Estado'
      end
      object lblEstado: TLabel
        Tag = 25
        Left = 124
        Top = 76
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblRespuestaRot: TLabel
        Tag = 13
        Left = 16
        Top = 105
        Caption = 'Respuesta'
      end
      object lblRespuesta: TLabel
        Tag = 25
        Left = 124
        Top = 104
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object btnProbar: TPlanoBotonWin
        Left = 16
        Top = 188
        Width = 130
        Height = 32
        Cursor = crHandPoint
        Caption = 'Probar conexi'#243'n'
        TabOrder = 0
        StyleElements = []
        OnClick = btnProbarClick
        Kind = fkSecondary
      end
      object btnCambiarServidor: TPlanoBotonWin
        Left = 154
        Top = 188
        Width = 130
        Height = 32
        Cursor = crHandPoint
        Caption = 'Cambiar servidor'
        TabOrder = 1
        StyleElements = []
        OnClick = btnCambiarServidorClick
        Kind = fkSecondary
      end
    end
    object tjAcercaDe: TPlanoTarjeta
      Tag = 3
      Left = 644
      Top = 8
      Width = 300
      Height = 236
      TitleHeight = 36
      Caption = 'Acerca de'
      TabOrder = 2
      object lblVerEscritorioRot: TLabel
        Tag = 13
        Left = 16
        Top = 49
        Caption = 'Escritorio'
      end
      object lblVerEscritorio: TLabel
        Tag = 25
        Left = 124
        Top = 48
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblVerServidorRot: TLabel
        Tag = 13
        Left = 16
        Top = 77
        Caption = 'Servidor'
      end
      object lblVerServidor: TLabel
        Tag = 25
        Left = 124
        Top = 76
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblVerBaseRot: TLabel
        Tag = 13
        Left = 16
        Top = 105
        Caption = 'Base de datos'
      end
      object lblVerBase: TLabel
        Tag = 25
        Left = 124
        Top = 104
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblVerMovilRot: TLabel
        Tag = 13
        Left = 16
        Top = 133
        Caption = 'M'#243'vil'
      end
      object lblVerMovil: TLabel
        Tag = 25
        Left = 124
        Top = 132
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblVerAvisoRot: TLabel
        Tag = 13
        Left = 16
        Top = 161
        Caption = 'Aviso de privacidad'
      end
      object lblVerAviso: TLabel
        Tag = 25
        Left = 124
        Top = 160
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
    end
    object tjEmpresa: TPlanoTarjeta
      Tag = 3
      Left = 20
      Top = 256
      Width = 612
      Height = 360
      TitleHeight = 36
      Caption = 'Datos de la empresa'
      TabOrder = 3
      object edRazonSocial: TrDBEdit
        Left = 16
        Top = 62
        Width = 280
        Height = 23
        DataField = 'RAZON_SOCIAL'
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
        DBEditLabel.OwnCaption = 'Raz'#243'n social'
        DBEditLabel.ShowRequiredBold = True
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object edCedula: TrDBEdit
        Left = 316
        Top = 62
        Width = 280
        Height = 23
        DataField = 'CEDULA_JURIDICA'
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
        DBEditLabel.OwnCaption = 'C'#233'dula jur'#237'dica'
        DBEditLabel.ShowRequiredBold = True
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object edRepresentante: TrDBEdit
        Left = 16
        Top = 112
        Width = 280
        Height = 23
        DataField = 'REPRESENTANTE_LEGAL'
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
        DBEditLabel.OwnCaption = 'Representante legal'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object edCorreoEmpresa: TrDBEdit
        Left = 316
        Top = 112
        Width = 280
        Height = 23
        DataField = 'CORREO'
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
        DBEditLabel.OwnCaption = 'Correo'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object edTelefono: TrDBEdit
        Left = 16
        Top = 162
        Width = 280
        Height = 23
        DataField = 'TELEFONO_FIJO'
        DataSource = dmMemoria.dsEmpresa
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
        DBEditLabel.OwnCaption = 'Tel'#233'fono fijo'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object edCelular: TrDBEdit
        Left = 316
        Top = 162
        Width = 280
        Height = 23
        DataField = 'CELULAR'
        DataSource = dmMemoria.dsEmpresa
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
        DBEditLabel.OwnCaption = 'Celular'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object edDireccion: TrDBEdit
        Left = 16
        Top = 212
        Width = 580
        Height = 23
        DataField = 'DIRECCION'
        DataSource = dmMemoria.dsEmpresa
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Direcci'#243'n'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object edCuenta: TrDBEdit
        Left = 16
        Top = 262
        Width = 280
        Height = 23
        DataField = 'CUENTA_BANCARIA'
        DataSource = dmMemoria.dsEmpresa
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Cuenta bancaria'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object edIva: TrDBEdit
        Left = 316
        Top = 262
        Width = 100
        Height = 23
        DataField = 'PORCENTAJE_IVA'
        DataSource = dmMemoria.dsEmpresa
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
        DBEditLabel.OwnCaption = 'IVA (%)'
        DBEditLabel.ShowRequiredBold = True
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object lblNotaIva: TLabel
        Tag = 13
        Left = 424
        Top = 258
        Width = 172
        Height = 44
        AutoSize = False
        Caption = 'El IVA nuevo se aplica a las cotizaciones que se elaboren desde ahora; '#13#10'las ya hechas conservan el suyo.'
        WordWrap = True
      end
      object btnDocumentoEmpresa: TPlanoBotonWin
        Tag = 21
        Left = 16
        Top = 312
        Width = 175
        Height = 32
        Cursor = crHandPoint
        Caption = 'Documento de la cotizaci'#243'n'
        TabOrder = 11
        StyleElements = []
        OnClick = btnDocumentoEmpresaClick
        Kind = fkSecondary
      end
      object btnConsentimiento: TPlanoBotonWin
        Tag = 21
        Left = 199
        Top = 312
        Width = 163
        Height = 32
        Cursor = crHandPoint
        Caption = 'Texto del consentimiento'
        TabOrder = 12
        StyleElements = []
        OnClick = btnConsentimientoClick
        Kind = fkSecondary
      end
      object btnDeshacer: TPlanoBotonWin
        Left = 370
        Top = 312
        Width = 108
        Height = 32
        Cursor = crHandPoint
        Caption = 'Deshacer'
        TabOrder = 9
        StyleElements = []
        OnClick = btnDeshacerClick
        Kind = fkSecondary
      end
      object btnGuardarEmpresa: TPlanoBotonWin
        Left = 486
        Top = 312
        Width = 110
        Height = 32
        Cursor = crHandPoint
        Caption = 'Guardar datos'
        TabOrder = 10
        StyleElements = []
        OnClick = btnGuardarEmpresaClick
      end
    end
    object tjParametros: TPlanoTarjeta
      Tag = 3
      Left = 644
      Top = 256
      Width = 300
      Height = 360
      TitleHeight = 36
      Caption = 'Par'#225'metros'
      TabOrder = 4
      object edMinutos: TrDBEdit
        Left = 16
        Top = 62
        Width = 100
        Height = 23
        DataField = 'MINUTOS_AVISOS'
        DataSource = dmMemoria.dsParametros
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
        DBEditLabel.OwnCaption = 'Revisar avisos cada (minutos)'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object lblNotaMinutos: TLabel
        Tag = 13
        Left = 16
        Top = 90
        Width = 268
        Height = 32
        AutoSize = False
        Caption = 'Preferencia de este equipo; se guarda en esta computadora.'
        WordWrap = True
      end
      object edDias: TrDBEdit
        Left = 16
        Top = 162
        Width = 100
        Height = 23
        DataField = 'DIAS_SIN_RESPUESTA'
        DataSource = dmMemoria.dsParametros
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
        DBEditLabel.OwnCaption = 'D'#237'as para '#171'sin respuesta'#187' del cliente'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object lblNotaDias: TLabel
        Tag = 13
        Left = 16
        Top = 190
        Width = 268
        Height = 32
        AutoSize = False
        Caption = 'Cotizaciones enviadas que pasan este plazo sin respuesta. ''Lo cambia gerencia o TI.'
        WordWrap = True
      end
      object btnGuardarParametros: TPlanoBotonWin
        Left = 16
        Top = 312
        Width = 150
        Height = 32
        Cursor = crHandPoint
        Caption = 'Guardar par'#225'metros'
        TabOrder = 2
        StyleElements = []
        OnClick = btnGuardarParametrosClick
      end
    end
  end
end
