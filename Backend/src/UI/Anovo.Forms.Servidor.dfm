object frmServidor: TfrmServidor
  Left = 0
  Top = 0
  Caption = 'Servidor Anovo'
  ClientHeight = 740
  ClientWidth = 1100
  Color = 16447477
  Constraints.MinHeight = 600
  Constraints.MinWidth = 960
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 1973276
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object pnlEncabezado: TPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 92
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      1100
      92)
    object lblTitulo: TLabel
      Left = 24
      Top = 14
      Width = 133
      Height = 25
      Caption = 'Servidor Anovo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 1973276
      Font.Height = -19
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object fpEstados: TFlowPanel
      Left = 20
      Top = 50
      Width = 760
      Height = 30
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object pasServidor: TPlanoPastilla
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 114
        Height = 24
        Margins.Right = 8
        Status = fsDanger
        Caption = 'Servidor detenido'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
      object pasTunel: TPlanoPastilla
        AlignWithMargins = True
        Left = 128
        Top = 3
        Width = 100
        Height = 24
        Margins.Right = 8
        Caption = 'T'#250'nel detenido'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
      object pasCorreo: TPlanoPastilla
        AlignWithMargins = True
        Left = 239
        Top = 3
        Width = 131
        Height = 24
        Margins.Right = 8
        Caption = 'Correo sin configurar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
    object btnDetener: TPlanoBotonWin
      Left = 866
      Top = 28
      Width = 100
      Height = 34
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Detener'
      Enabled = False
      TabOrder = 1
      StyleElements = []
      OnClick = btnDetenerClick
      Kind = fkSecondary
    end
    object btnIniciar: TPlanoBotonWin
      Left = 976
      Top = 28
      Width = 100
      Height = 34
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Iniciar'
      Default = True
      TabOrder = 2
      StyleElements = []
      OnClick = btnIniciarClick
    end
  end
  object gpContadores: TGridPanel
    Left = 0
    Top = 92
    Width = 1100
    Height = 112
    Align = alTop
    BevelOuter = bvNone
    Color = 16447477
    ColumnCollection = <
      item
        Value = 25.000000000000000000
      end
      item
        Value = 25.000000000000000000
      end
      item
        Value = 25.000000000000000000
      end
      item
        Value = 25.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = tjPeticiones
        Row = 0
      end
      item
        Column = 1
        Control = tjErrores
        Row = 0
      end
      item
        Column = 2
        Control = tjPermisos
        Row = 0
      end
      item
        Column = 3
        Control = tjActivo
        Row = 0
      end>
    Padding.Left = 16
    Padding.Top = 12
    Padding.Right = 16
    ParentBackground = False
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 1
    object tjPeticiones: TPlanoTarjeta
      AlignWithMargins = True
      Left = 40
      Top = 27
      Width = 219
      Height = 82
      Margins.Left = 8
      Margins.Right = 8
      TitleHeight = 30
      Caption = 'Peticiones'
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7500395
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object lblPeticiones: TLabel
        Left = 16
        Top = 28
        Width = 14
        Height = 36
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1973276
        Font.Height = -26
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblPeticionesNota: TLabel
        Left = 16
        Top = 66
        Width = 91
        Height = 13
        Caption = 'servidor detenido'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7500395
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
    end
    object tjErrores: TPlanoTarjeta
      AlignWithMargins = True
      Left = 307
      Top = 27
      Width = 219
      Height = 82
      Margins.Left = 8
      Margins.Right = 8
      TitleHeight = 30
      Caption = 'Errores'
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7500395
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object lblErrores: TLabel
        Left = 16
        Top = 28
        Width = 14
        Height = 36
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1973276
        Font.Height = -26
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblErroresNota: TLabel
        Left = 16
        Top = 66
        Width = 96
        Height = 13
        Caption = '0 en la '#250'ltima hora'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7500395
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
    end
    object tjPermisos: TPlanoTarjeta
      AlignWithMargins = True
      Left = 574
      Top = 27
      Width = 219
      Height = 82
      Cursor = crHandPoint
      Hint = 'Clic para invalidar la cach'#233' de permisos'
      Margins.Left = 8
      Margins.Right = 8
      TitleHeight = 30
      Caption = 'Permisos'
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7500395
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = tjPermisosClick
      object lblPermisos: TLabel
        Left = 16
        Top = 28
        Width = 119
        Height = 36
        Cursor = crHandPoint
        Caption = 'Sin cargar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10510377
        Font.Height = -26
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        OnClick = tjPermisosClick
      end
      object lblPermisosNota: TLabel
        Left = 16
        Top = 66
        Width = 91
        Height = 13
        Cursor = crHandPoint
        Caption = 'Clic para invalidar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7500395
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        OnClick = tjPermisosClick
      end
    end
    object tjActivo: TPlanoTarjeta
      AlignWithMargins = True
      Left = 841
      Top = 27
      Width = 219
      Height = 82
      Margins.Left = 8
      Margins.Right = 8
      TitleHeight = 30
      Caption = 'Activo desde'
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7500395
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      object lblActivo: TLabel
        Left = 16
        Top = 28
        Width = 10
        Height = 36
        Caption = '-'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1973276
        Font.Height = -26
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblActivoNota: TLabel
        Left = 16
        Top = 66
        Width = 91
        Height = 13
        Caption = 'servidor detenido'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 7500395
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
    end
  end
  object pstSecciones: TPlanoPestanas
    AlignWithMargins = True
    Left = 16
    Top = 216
    Width = 1068
    Height = 40
    Margins.Left = 16
    Margins.Top = 12
    Margins.Right = 16
    Margins.Bottom = 0
    Items.Strings = (
      'Registro'
      'Actividad'
      'Errores'
      'T'#250'nel'
      'Configuraci'#243'n')
    CardPanel = cpSecciones
    BackColor = 16447477
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 7500395
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ActiveFont.Charset = DEFAULT_CHARSET
    ActiveFont.Color = 10510377
    ActiveFont.Height = -13
    ActiveFont.Name = 'Segoe UI Semibold'
    ActiveFont.Style = []
    ParentFont = False
  end
  object cpSecciones: TCardPanel
    AlignWithMargins = True
    Left = 16
    Top = 256
    Width = 1068
    Height = 468
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 16
    Margins.Bottom = 16
    Align = alClient
    ActiveCard = crdRegistro
    BevelOuter = bvNone
    Caption = 'cpSecciones'
    Color = clWhite
    ParentBackground = False
    TabOrder = 3
    object crdRegistro: TCard
      Left = 0
      Top = 0
      Width = 1068
      Height = 468
      Caption = 'Registro'
      CardIndex = 0
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object memRegistro: TMemo
        AlignWithMargins = True
        Left = 12
        Top = 12
        Width = 1044
        Height = 444
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Align = alClient
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 1973276
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
    object crdActividad: TCard
      Left = 0
      Top = 0
      Width = 1068
      Height = 468
      Caption = 'Actividad'
      CardIndex = 1
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object pstFiltro: TPlanoPestanas
        AlignWithMargins = True
        Left = 12
        Top = 12
        Width = 1044
        Height = 32
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 4
        Items.Strings = (
          'Todas'
          '2xx y 3xx'
          '4xx'
          '5xx')
        Style = pesPastilla
        Indent = 0
        BackColor = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10510377
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ActiveFont.Charset = DEFAULT_CHARSET
        ActiveFont.Color = clWhite
        ActiveFont.Height = -12
        ActiveFont.Name = 'Segoe UI Semibold'
        ActiveFont.Style = []
        OnChange = pstFiltroChange
        ParentFont = False
      end
      object grActividad: TrDBGrid
        AlignWithMargins = True
        Left = 12
        Top = 52
        Width = 1044
        Height = 404
        Margins.Left = 12
        Margins.Top = 4
        Margins.Right = 12
        Margins.Bottom = 12
        Align = alClient
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = 1973276
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'HORA'
            Title.Caption = 'Hora'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'USUARIO'
            Title.Caption = 'Usuario'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VERBO'
            Title.Caption = 'Verbo'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RUTA'
            Title.Caption = 'Ruta'
            Width = 560
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ESTADO'
            Title.Caption = 'Estado'
            Width = 80
            Visible = True
          end
          item
            Alignment = taRightJustify
            Expanded = False
            FieldName = 'MS'
            Title.Alignment = taRightJustify
            Title.Caption = 'ms'
            Width = 70
            Visible = True
          end>
      end
    end
    object crdErrores: TCard
      Left = 0
      Top = 0
      Width = 1068
      Height = 468
      Caption = 'Errores'
      CardIndex = 2
      Color = clWhite
      ParentBackground = False
      TabOrder = 2
      object grErrores: TrDBGrid
        AlignWithMargins = True
        Left = 12
        Top = 12
        Width = 1044
        Height = 444
        Margins.Left = 12
        Margins.Top = 12
        Margins.Right = 12
        Margins.Bottom = 12
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = 1973276
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'HORA'
            Title.Caption = 'Hora'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'USUARIO'
            Title.Caption = 'Usuario'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VERBO'
            Title.Caption = 'Verbo'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'RUTA'
            Title.Caption = 'Ruta'
            Width = 560
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ESTADO'
            Title.Caption = 'Estado'
            Width = 80
            Visible = True
          end
          item
            Alignment = taRightJustify
            Expanded = False
            FieldName = 'MS'
            Title.Alignment = taRightJustify
            Title.Caption = 'ms'
            Width = 70
            Visible = True
          end>
      end
    end
    object crdTunel: TCard
      Left = 0
      Top = 0
      Width = 1068
      Height = 468
      Caption = 'T'#250'nel'
      CardIndex = 3
      Color = clWhite
      ParentBackground = False
      TabOrder = 3
      ExplicitHeight = 456
      object pnlTunelBarra: TPanel
        Left = 0
        Top = 0
        Width = 1068
        Height = 56
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        DesignSize = (
          1068
          56)
        object lblTunelRuta: TLabel
          Left = 16
          Top = 20
          Width = 60
          Height = 15
          Caption = 'cloudflared'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 7500395
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object btnDetenerTunel: TPlanoBotonWin
          Left = 790
          Top = 12
          Width = 126
          Height = 32
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = 'Detener t'#250'nel'
          Enabled = False
          TabOrder = 0
          StyleElements = []
          OnClick = btnDetenerTunelClick
          Kind = fkSecondary
        end
        object btnIniciarTunel: TPlanoBotonWin
          Left = 926
          Top = 12
          Width = 126
          Height = 32
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = 'Iniciar t'#250'nel'
          TabOrder = 1
          StyleElements = []
          OnClick = btnIniciarTunelClick
        end
      end
      object reTunel: TRichEdit
        AlignWithMargins = True
        Left = 12
        Top = 56
        Width = 1044
        Height = 400
        Margins.Left = 12
        Margins.Top = 0
        Margins.Right = 12
        Margins.Bottom = 12
        Align = alClient
        BorderStyle = bsNone
        Color = 2562065
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 14407121
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        WordWrap = False
        Zoom = 100
      end
    end
    object crdConfiguracion: TCard
      Left = 0
      Top = 0
      Width = 1068
      Height = 468
      Caption = 'Configuraci'#243'n'
      CardIndex = 4
      Color = clWhite
      ParentBackground = False
      TabOrder = 4
      ExplicitHeight = 456
      object sbConfiguracion: TScrollBox
        Left = 0
        Top = 0
        Width = 1068
        Height = 468
        Align = alClient
        BorderStyle = bsNone
        Color = clWhite
        ParentColor = False
        TabOrder = 0
        ExplicitHeight = 456
        object lblNotaConfig: TLabel
          Left = 16
          Top = 414
          Width = 489
          Height = 15
          Caption = 
            'Se guarda en el .env junto al ejecutable. Si el servidor est'#225' co' +
            'rriendo, se reinicia para aplicarla.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 7500395
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object tjServidor: TPlanoTarjeta
          Left = 16
          Top = 12
          Width = 500
          Height = 156
          BackColor = clWhite
          CardColor = 16447477
          Caption = 'Servidor'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10510377
          Font.Height = -13
          Font.Name = 'Segoe UI Semibold'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object lblBase: TLabel
            Left = 16
            Top = 44
            Width = 27
            Height = 15
            Caption = 'Base:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object lblUsuarioBase: TLabel
            Left = 16
            Top = 70
            Width = 43
            Height = 15
            Caption = 'Usuario:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object lblPuerto: TLabel
            Left = 16
            Top = 96
            Width = 38
            Height = 15
            Caption = 'Puerto:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object lblVersion: TLabel
            Left = 16
            Top = 122
            Width = 62
            Height = 15
            Caption = 'Framework:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
        end
        object tjTunel: TPlanoTarjeta
          Left = 16
          Top = 182
          Width = 500
          Height = 212
          BackColor = clWhite
          CardColor = 16447477
          Caption = 'T'#250'nel de Cloudflare'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10510377
          Font.Height = -13
          Font.Name = 'Segoe UI Semibold'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object edTunelExe: TLabeledEdit
            Left = 16
            Top = 62
            Width = 466
            Height = 23
            EditLabel.Width = 133
            EditLabel.Height = 15
            EditLabel.Caption = 'Ejecutable de cloudflared'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = 7500395
            EditLabel.Font.Height = -12
            EditLabel.Font.Name = 'Segoe UI'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnChange = ConfigCambiada
          end
          object edTunelConfig: TLabeledEdit
            Left = 16
            Top = 112
            Width = 466
            Height = 23
            EditLabel.Width = 323
            EditLabel.Height = 15
            EditLabel.Caption = 'Archivo de configuraci'#243'n (vac'#237'o: el de la cuenta de Windows)'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = 7500395
            EditLabel.Font.Height = -12
            EditLabel.Font.Name = 'Segoe UI'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnChange = ConfigCambiada
          end
          object edTunelNombre: TLabeledEdit
            Left = 16
            Top = 162
            Width = 230
            Height = 23
            EditLabel.Width = 150
            EditLabel.Height = 15
            EditLabel.Caption = 'Nombre del t'#250'nel (opcional)'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = 7500395
            EditLabel.Font.Height = -12
            EditLabel.Font.Name = 'Segoe UI'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnChange = ConfigCambiada
          end
          object chkTunelAutomatico: TCheckBox
            Left = 262
            Top = 164
            Width = 220
            Height = 19
            Caption = 'Arrancar junto con el servidor'
            Color = 16447477
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            TabOrder = 3
            OnClick = ConfigCambiada
          end
        end
        object tjCorreo: TPlanoTarjeta
          Left = 532
          Top = 12
          Width = 500
          Height = 340
          BackColor = clWhite
          CardColor = 16447477
          Caption = 'Correo saliente'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 10510377
          Font.Height = -13
          Font.Name = 'Segoe UI Semibold'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object lblModoCorreo: TLabel
            Left = 16
            Top = 44
            Width = 32
            Height = 15
            Caption = 'Modo'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 7500395
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object lblProveedor: TLabel
            Left = 262
            Top = 44
            Width = 54
            Height = 15
            Caption = 'Proveedor'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 7500395
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object lblTokenCorreo: TLabel
            Left = 16
            Top = 262
            Width = 3
            Height = 15
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            Transparent = True
          end
          object cbModoCorreo: TComboBox
            Left = 16
            Top = 62
            Width = 230
            Height = 23
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnChange = cbModoCorreoChange
            Items.Strings = (
              'Sin correo'
              'Contrase'#241'a de aplicaci'#243'n'
              'OAuth2')
          end
          object cbProveedor: TComboBox
            Left = 262
            Top = 62
            Width = 220
            Height = 23
            Style = csDropDownList
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnChange = ConfigCambiada
            Items.Strings = (
              'Google (Gmail)'
              'Microsoft (Outlook)')
          end
          object edCuenta: TLabeledEdit
            Left = 16
            Top = 112
            Width = 230
            Height = 23
            EditLabel.Width = 141
            EditLabel.Height = 15
            EditLabel.Caption = 'Cuenta que env'#237'a el correo'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = 7500395
            EditLabel.Font.Height = -12
            EditLabel.Font.Name = 'Segoe UI'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnChange = ConfigCambiada
          end
          object edNombre: TLabeledEdit
            Left = 262
            Top = 112
            Width = 220
            Height = 23
            EditLabel.Width = 117
            EditLabel.Height = 15
            EditLabel.Caption = 'Nombre del remitente'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = 7500395
            EditLabel.Font.Height = -12
            EditLabel.Font.Name = 'Segoe UI'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnChange = ConfigCambiada
          end
          object edClave: TLabeledEdit
            Left = 16
            Top = 162
            Width = 230
            Height = 23
            EditLabel.Width = 187
            EditLabel.Height = 15
            EditLabel.Caption = 'Contrase'#241'a de aplicaci'#243'n (16 letras)'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = 7500395
            EditLabel.Font.Height = -12
            EditLabel.Font.Name = 'Segoe UI'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            PasswordChar = #9679
            TabOrder = 4
            OnChange = ConfigCambiada
          end
          object edClientId: TLabeledEdit
            Left = 16
            Top = 162
            Width = 466
            Height = 23
            EditLabel.Width = 45
            EditLabel.Height = 15
            EditLabel.Caption = 'Client ID'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = 7500395
            EditLabel.Font.Height = -12
            EditLabel.Font.Name = 'Segoe UI'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
            OnChange = ConfigCambiada
          end
          object edClientSecret: TLabeledEdit
            Left = 16
            Top = 212
            Width = 466
            Height = 23
            EditLabel.Width = 65
            EditLabel.Height = 15
            EditLabel.Caption = 'Client secret'
            EditLabel.Font.Charset = DEFAULT_CHARSET
            EditLabel.Font.Color = 7500395
            EditLabel.Font.Height = -12
            EditLabel.Font.Name = 'Segoe UI'
            EditLabel.Font.Style = []
            EditLabel.ParentFont = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 1973276
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            PasswordChar = #9679
            TabOrder = 6
            OnChange = ConfigCambiada
          end
          object btnAutorizarCorreo: TPlanoBotonWin
            Left = 16
            Top = 286
            Width = 200
            Height = 32
            Cursor = crHandPoint
            Caption = 'Autorizar correo'
            TabOrder = 7
            StyleElements = []
            OnClick = btnAutorizarCorreoClick
          end
        end
        object btnGuardarConfig: TPlanoBotonWin
          Left = 900
          Top = 406
          Width = 132
          Height = 32
          Cursor = crHandPoint
          Caption = 'Guardar'
          Enabled = False
          TabOrder = 3
          StyleElements = []
          OnClick = btnGuardarConfigClick
        end
      end
    end
  end
  object tmrRefresco: TTimer
    Enabled = False
    OnTimer = tmrRefrescoTimer
    Left = 552
    Top = 24
  end
  object tmrVigencias: TTimer
    Enabled = False
    Interval = 3600000
    OnTimer = tmrVigenciasTimer
    Left = 472
    Top = 24
  end
  object tmrTunel: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = tmrTunelTimer
    Left = 632
    Top = 24
  end
end
