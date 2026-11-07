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
      Width = 76
      Height = 15
      Caption = 'Configuraci'#243'n'
    end
    object lblSubtitulo: TLabel
      Tag = 13
      Left = 20
      Top = 40
      Width = 399
      Height = 15
      Caption = 
        'Su cuenta, la conexi'#243'n, los datos de la empresa y los par'#225'metros' +
        ' del sistema'
    end
  end
  object sbCuerpo: TScrollBox
    Tag = 2
    Left = 0
    Top = 62
    Width = 960
    Height = 628
    HorzScrollBar.Visible = False
    VertScrollBar.Tracking = True
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 1
    object pnlCuerpo: TGridPanel
      Tag = 2
      Left = 0
      Top = 0
      Width = 960
      Height = 628
      Align = alTop
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 33.333333333333330000
        end
        item
          Value = 33.333333333333330000
        end
        item
          Value = 33.333333333333340000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = tjCuenta
          Row = 0
        end
        item
          Column = 1
          Control = tjConexion
          Row = 0
        end
        item
          Column = 2
          Control = tjAcercaDe
          Row = 0
        end
        item
          Column = 0
          ColumnSpan = 2
          Control = tjEmpresa
          Row = 1
        end
        item
          Column = 2
          Control = tjParametros
          Row = 1
        end>
      Padding.Left = 20
      Padding.Top = 8
      Padding.Right = 8
      RowCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 248.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 372.000000000000000000
        end>
      TabOrder = 0
      OnResize = pnlCuerpoResize
      object tjCuenta: TPlanoTarjeta
        Tag = 3
        AlignWithMargins = True
        Left = 40
        Top = 16
        Width = 271
        Height = 228
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'Mi cuenta'
        Align = alClient
        TabOrder = 0
        DesignSize = (
          271
          228)
        object lblNombreRot: TLabel
          Tag = 13
          Left = 16
          Top = 49
          Width = 44
          Height = 15
          Caption = 'Nombre'
        end
        object lblNombre: TLabel
          Tag = 25
          Left = 124
          Top = 48
          Width = 131
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
        object lblCorreoRot: TLabel
          Tag = 13
          Left = 16
          Top = 77
          Width = 36
          Height = 15
          Caption = 'Correo'
        end
        object lblCorreo: TLabel
          Tag = 25
          Left = 124
          Top = 76
          Width = 131
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
        object lblRolRot: TLabel
          Tag = 13
          Left = 16
          Top = 105
          Width = 17
          Height = 15
          Caption = 'Rol'
        end
        object lblRol: TLabel
          Tag = 25
          Left = 124
          Top = 104
          Width = 131
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
        object lblPermisosRot: TLabel
          Tag = 13
          Left = 16
          Top = 133
          Width = 91
          Height = 15
          Caption = 'Permisos propios'
        end
        object lblPermisos: TLabel
          Tag = 25
          Left = 124
          Top = 132
          Width = 131
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
        object lblClaveRot: TLabel
          Tag = 13
          Left = 16
          Top = 161
          Width = 84
          Height = 15
          Caption = 'Clave cambiada'
        end
        object lblClave: TLabel
          Tag = 25
          Left = 124
          Top = 160
          Width = 131
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
        object btnCambiarClave: TPlanoBotonWin
          Left = 16
          Top = 188
          Width = 150
          Height = 32
          Cursor = crHandPoint
          Caption = 'Cambiar mi clave'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          StyleElements = []
          OnClick = btnCambiarClaveClick
        end
      end
      object tjConexion: TPlanoTarjeta
        Tag = 3
        AlignWithMargins = True
        Left = 351
        Top = 16
        Width = 270
        Height = 228
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'Conexi'#243'n'
        Align = alClient
        TabOrder = 1
        DesignSize = (
          270
          228)
        object lblServidorRot: TLabel
          Tag = 13
          Left = 16
          Top = 49
          Width = 43
          Height = 15
          Caption = 'Servidor'
        end
        object lblServidor: TLabel
          Tag = 25
          Left = 124
          Top = 48
          Width = 130
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
        object lblEstadoRot: TLabel
          Tag = 13
          Left = 16
          Top = 77
          Width = 35
          Height = 15
          Caption = 'Estado'
        end
        object lblEstado: TLabel
          Tag = 25
          Left = 124
          Top = 76
          Width = 130
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
        object lblRespuestaRot: TLabel
          Tag = 13
          Left = 16
          Top = 105
          Width = 53
          Height = 15
          Caption = 'Respuesta'
        end
        object lblRespuesta: TLabel
          Tag = 25
          Left = 124
          Top = 104
          Width = 130
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
        object btnProbar: TPlanoBotonWin
          Left = 16
          Top = 188
          Width = 130
          Height = 32
          Cursor = crHandPoint
          Caption = 'Probar conexi'#243'n'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
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
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          StyleElements = []
          OnClick = btnCambiarServidorClick
          Kind = fkSecondary
        end
      end
      object tjAcercaDe: TPlanoTarjeta
        Tag = 3
        AlignWithMargins = True
        Left = 661
        Top = 16
        Width = 271
        Height = 228
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'Acerca de'
        Align = alClient
        TabOrder = 2
        DesignSize = (
          271
          228)
        object lblVerEscritorioRot: TLabel
          Tag = 13
          Left = 16
          Top = 49
          Width = 49
          Height = 15
          Caption = 'Escritorio'
        end
        object lblVerEscritorio: TLabel
          Tag = 25
          Left = 124
          Top = 48
          Width = 131
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
        object lblVerServidorRot: TLabel
          Tag = 13
          Left = 16
          Top = 77
          Width = 43
          Height = 15
          Caption = 'Servidor'
        end
        object lblVerServidor: TLabel
          Tag = 25
          Left = 124
          Top = 76
          Width = 131
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
        object lblVerBaseRot: TLabel
          Tag = 13
          Left = 16
          Top = 105
          Width = 72
          Height = 15
          Caption = 'Base de datos'
        end
        object lblVerBase: TLabel
          Tag = 25
          Left = 124
          Top = 104
          Width = 131
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
        object lblVerMovilRot: TLabel
          Tag = 13
          Left = 16
          Top = 133
          Width = 30
          Height = 15
          Caption = 'M'#243'vil'
        end
        object lblVerMovil: TLabel
          Tag = 25
          Left = 124
          Top = 132
          Width = 131
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
        object lblVerAvisoRot: TLabel
          Tag = 13
          Left = 16
          Top = 161
          Width = 103
          Height = 15
          Caption = 'Aviso de privacidad'
        end
        object lblVerAviso: TLabel
          Tag = 25
          Left = 124
          Top = 160
          Width = 131
          Height = 15
          Alignment = taRightJustify
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '-'
          EllipsisPosition = epEndEllipsis
          ExplicitWidth = 160
        end
      end
      object tjEmpresa: TPlanoTarjeta
        Tag = 3
        AlignWithMargins = True
        Left = 40
        Top = 264
        Width = 581
        Height = 352
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'Datos de la empresa'
        Align = alClient
        TabOrder = 3
        DesignSize = (
          581
          352)
        object lblNotaIva: TLabel
          Tag = 13
          Left = 424
          Top = 258
          Width = 300
          Height = 44
          AutoSize = False
          Caption = 
            'El IVA nuevo se aplica a las cotizaciones que se elaboren desde ' +
            'ahora; las ya hechas conservan el suyo.'
          WordWrap = True
        end
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
          Width = 549
          Height = 23
          Anchors = [akLeft, akTop, akRight]
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
        object btnDocumentoEmpresa: TPlanoBotonWin
          Tag = 21
          Left = 16
          Top = 312
          Width = 175
          Height = 32
          Cursor = crHandPoint
          Caption = 'Documento de la cotizaci'#243'n'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
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
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
          StyleElements = []
          OnClick = btnConsentimientoClick
          Kind = fkSecondary
        end
        object btnDeshacer: TPlanoBotonWin
          Left = 339
          Top = 312
          Width = 108
          Height = 32
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = 'Deshacer'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          StyleElements = []
          OnClick = btnDeshacerClick
          Kind = fkSecondary
        end
        object btnGuardarEmpresa: TPlanoBotonWin
          Left = 455
          Top = 312
          Width = 110
          Height = 32
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = 'Guardar datos'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          StyleElements = []
          OnClick = btnGuardarEmpresaClick
        end
      end
      object tjParametros: TPlanoTarjeta
        Tag = 3
        AlignWithMargins = True
        Left = 661
        Top = 264
        Width = 271
        Height = 352
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 12
        Caption = 'Par'#225'metros'
        Align = alClient
        TabOrder = 4
        DesignSize = (
          271
          352)
        object lblNotaMinutos: TLabel
          Tag = 13
          Left = 16
          Top = 90
          Width = 239
          Height = 32
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'Preferencia de este equipo; se guarda en esta computadora.'
          WordWrap = True
          ExplicitWidth = 268
        end
        object lblNotaDias: TLabel
          Tag = 13
          Left = 16
          Top = 190
          Width = 239
          Height = 32
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Cotizaciones enviadas que pasan este plazo sin respuesta. Lo cam' +
            'bia gerencia o TI.'
          WordWrap = True
          ExplicitWidth = 268
        end
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
        object btnGuardarParametros: TPlanoBotonWin
          Left = 16
          Top = 312
          Width = 150
          Height = 32
          Cursor = crHandPoint
          Caption = 'Guardar par'#225'metros'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          StyleElements = []
          OnClick = btnGuardarParametrosClick
        end
      end
    end
  end
end
