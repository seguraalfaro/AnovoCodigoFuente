object fraClienteDatos: TfraClienteDatos
  Left = 0
  Top = 0
  Width = 960
  Height = 620
  TabOrder = 0
  object rpTitulo: TRelativePanel
    Tag = 2
    Left = 0
    Top = 0
    Width = 960
    Height = 62
    ControlCollection = <
      item
        Control = PlanoBotonWin1
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = True
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
      end>
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      960
      62)
    object PlanoBotonWin1: TPlanoBotonWin
      AlignWithMargins = True
      Left = 20
      Top = 12
      Width = 120
      Height = 38
      Cursor = crHandPoint
      Margins.Left = 20
      Action = AcRegregsar
      Anchors = []
      ImageIndex = 32
      Images = dmIconos.ViAnovo
      TabOrder = 0
      StyleElements = []
      Kind = fkSecondary
    end
  end
  object pstCliente: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 65
    Width = 954
    Height = 40
    Items.Strings = (
      'Datos'
      'Contactos'
      'Consentimiento'
      'Cotizaciones')
    CardPanel = CardPanel1
    Indent = 20
    BackColor = 16447477
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ActiveFont.Charset = DEFAULT_CHARSET
    ActiveFont.Color = clWindowText
    ActiveFont.Height = -12
    ActiveFont.Name = 'Segoe UI Semibold'
    ActiveFont.Style = []
    OnChange = pstClienteChange
    ParentFont = False
  end
  object pnbottom: TRelativePanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 544
    Width = 954
    Height = 73
    ControlCollection = <
      item
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end
      item
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = True
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end>
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
  end
  object CardPanel1: TCardPanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 111
    Width = 954
    Height = 427
    Align = alClient
    ActiveCard = CarDatos
    BevelOuter = bvNone
    Caption = 'CardPanel1'
    TabOrder = 3
    object CarDatos: TCard
      Tag = 2
      Left = 0
      Top = 0
      Width = 954
      Height = 427
      Caption = 'Card1'
      CardIndex = 0
      TabOrder = 1
      object RelativePanel1: TRelativePanel
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 427
        ControlCollection = <
          item
            Control = tjIdentificacion
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = False
            AlignTopWithPanel = True
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = tjUbicacion
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
            RightOf = tjIdentificacion
          end
          item
            Control = btnAnonimizar
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
            Below = tjUbicacion
            LeftOf = btnEditarCliente
          end
          item
            Control = btnEditarCliente
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
            Below = tjUbicacion
            LeftOf = btnGuardarCliente
          end
          item
            Control = btnGuardarCliente
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
            Below = tjUbicacion
            LeftOf = btnCancelarEdicion
          end
          item
            Control = btnCancelarEdicion
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWith = tjUbicacion
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
            Below = tjUbicacion
          end>
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          954
          427)
        object tjIdentificacion: TPlanoTarjeta
          Tag = 3
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 450
          Height = 374
          Margins.Left = 20
          Caption = 'Informaci'#243'n general'
          Anchors = []
          TabOrder = 0
          object rDBEdit1: TrDBEdit
            Left = 16
            Top = 57
            Width = 353
            Height = 23
            DataField = 'NOMBRE'
            DataSource = dmMemoria.dsClienteDetalle
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
          object rDBEdit2: TrDBEdit
            Left = 16
            Top = 110
            Width = 353
            Height = 23
            DataField = 'IDENTIFICACION'
            DataSource = dmMemoria.dsClienteDetalle
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
            DBEditLabel.OwnCaption = 'Identificaci'#243'n'
            DBEditLabel.Font.Charset = ANSI_CHARSET
            DBEditLabel.Font.Color = clWindowText
            DBEditLabel.Font.Height = -12
            DBEditLabel.Font.Name = 'Segoe UI'
            DBEditLabel.Font.Style = []
            DBEditLabel.ParentFont = False
          end
          object rDBEdit3: TrDBEdit
            Left = 16
            Top = 161
            Width = 353
            Height = 23
            DataField = 'TELEFONO'
            DataSource = dmMemoria.dsClienteDetalle
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
          object rDBMemo1: TrDBMemo
            Left = 16
            Top = 216
            Width = 353
            Height = 80
            BorderStyle = bsNone
            DataField = 'DIRECCION'
            DataSource = dmMemoria.dsClienteDetalle
            PopupMenu = rDBMemo1.pmSearch
            ScrollBars = ssVertical
            TabOrder = 3
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
          object lblUbicacionRot: TLabel
            Tag = 13
            Left = 16
            Top = 310
            Width = 353
            Height = 15
            AutoSize = False
            Caption = 'Ubicaci'#243'n en campo'
          end
          object lblUbicacion: TLabel
            Tag = 25
            Left = 16
            Top = 332
            Width = 240
            Height = 17
            AutoSize = False
            ShowAccelChar = False
          end
          object lblVerMapa: TLabel
            Tag = 15
            Left = 262
            Top = 332
            Width = 107
            Height = 17
            Cursor = crHandPoint
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Ver en el mapa'
            Visible = False
            OnClick = lblVerMapaClick
          end
        end
        object tjUbicacion: TPlanoTarjeta
          Tag = 3
          AlignWithMargins = True
          Left = 476
          Top = 3
          Width = 450
          Height = 374
          Margins.Right = 20
          Caption = 'Informaci'#243'n facturaci'#243'n '
          Anchors = []
          TabOrder = 1
          object rDBLabel1: TrDBLabel
            Left = 376
            Top = 350
            Width = 48
            Height = 13
            Caption = 'rDBLabel1'
            DataField = 'OBJVERSION'
            DataSource = dmMemoria.dsClienteDetalle
          end
          object Label1: TLabel
            Tag = 13
            Left = 32
            Top = 350
            Width = 92
            Height = 13
            Caption = 'Versi'#243'n del registro'
            StyleElements = []
          end
          object rDBEdit6: TrDBEdit
            Left = 24
            Top = 57
            Width = 353
            Height = 23
            DataField = 'CONTACTO'
            DataSource = dmMemoria.dsClienteDetalle
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
            DBEditLabel.OwnCaption = 'Encargado'
            DBEditLabel.Font.Charset = ANSI_CHARSET
            DBEditLabel.Font.Color = clWindowText
            DBEditLabel.Font.Height = -12
            DBEditLabel.Font.Name = 'Segoe UI'
            DBEditLabel.Font.Style = []
            DBEditLabel.ParentFont = False
          end
          object rDBEdit4: TrDBEdit
            Left = 24
            Top = 110
            Width = 353
            Height = 23
            DataField = 'CORREO'
            DataSource = dmMemoria.dsClienteDetalle
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
            DBEditLabel.OwnCaption = 'Correo'
            DBEditLabel.Font.Charset = ANSI_CHARSET
            DBEditLabel.Font.Color = clWindowText
            DBEditLabel.Font.Height = -12
            DBEditLabel.Font.Name = 'Segoe UI'
            DBEditLabel.Font.Style = []
            DBEditLabel.ParentFont = False
          end
          object rDBCheckBox1: TrDBCheckBox
            Left = 24
            Top = 152
            Width = 97
            Height = 17
            Caption = '  Exonerado'
            DataField = 'EXONERADO'
            DataSource = dmMemoria.dsClienteDetalle
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            ReadOnlyColor = 15987699
            ShowFieldCaption = False
          end
          object rDBEdit5: TrDBEdit
            Left = 24
            Top = 200
            Width = 353
            Height = 23
            DataField = 'CODIGO_EXONERACION'
            DataSource = dmMemoria.dsClienteDetalle
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
            DBEditLabel.OwnCaption = 'C'#243'digo de exoneraci'#243'n  '
            DBEditLabel.Font.Charset = ANSI_CHARSET
            DBEditLabel.Font.Color = clWindowText
            DBEditLabel.Font.Height = -12
            DBEditLabel.Font.Name = 'Segoe UI'
            DBEditLabel.Font.Style = []
            DBEditLabel.ParentFont = False
          end
          object separador: TPanel
            Tag = 6
            Left = 32
            Top = 345
            Width = 393
            Height = 1
            TabOrder = 4
          end
        end
        object btnEditarCliente: TPlanoBotonWin
          AlignWithMargins = True
          Left = 524
          Top = 383
          Width = 130
          Height = 30
          Cursor = crHandPoint
          Anchors = []
          Caption = 'Editar datos'
          TabOrder = 2
          Visible = False
          StyleElements = []
          OnClick = btnEditarClienteClick
        end
        object btnGuardarCliente: TPlanoBotonWin
          AlignWithMargins = True
          Left = 660
          Top = 383
          Width = 130
          Height = 30
          Cursor = crHandPoint
          Anchors = []
          Caption = 'Guardar'
          Enabled = False
          TabOrder = 3
          Visible = False
          StyleElements = []
          OnClick = btnGuardarClienteClick
        end
        object btnCancelarEdicion: TPlanoBotonWin
          AlignWithMargins = True
          Left = 796
          Top = 383
          Width = 130
          Height = 30
          Cursor = crHandPoint
          Margins.Right = 120
          Anchors = []
          Caption = 'Cancelar'
          Enabled = False
          TabOrder = 4
          Visible = False
          StyleElements = []
          OnClick = btnCancelarEdicionClick
          Kind = fkSecondary
        end
        object btnAnonimizar: TPlanoBotonWin
          AlignWithMargins = True
          Left = 358
          Top = 383
          Width = 160
          Height = 30
          Cursor = crHandPoint
          Anchors = []
          Caption = 'Anonimizar cliente'
          Enabled = False
          TabOrder = 5
          Visible = False
          StyleElements = []
          OnClick = btnAnonimizarClick
          Kind = fkDanger
        end
      end
    end
    object CarContactos: TCard
      Tag = 2
      Left = 0
      Top = 0
      Width = 954
      Height = 427
      Caption = 'Card1'
      CardIndex = 1
      TabOrder = 2
      object pnlBarra: TPanel
        Tag = 2
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 948
        Height = 52
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          948
          52)
        object sbBuscar: TSearchBox
          Left = 20
          Top = 14
          Width = 300
          Height = 21
          BevelInner = bvNone
          BevelOuter = bvNone
          TabOrder = 0
          TextHint = 'Buscar'
          StyleElements = [seFont]
        end
        object btnNuevo: TPlanoBotonWin
          Left = 810
          Top = 12
          Width = 124
          Height = 28
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = '+ Nuevo contacto'
          TabOrder = 1
          StyleElements = []
          OnClick = btnNuevoClick
        end
      end
      object pnclient: TRelativePanel
        Tag = 2
        AlignWithMargins = True
        Left = 3
        Top = 61
        Width = 948
        Height = 363
        ControlCollection = <
          item
            Control = grContactos
            AlignBottomWithPanel = True
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = True
            AlignTopWithPanel = True
            AlignVerticalCenterWithPanel = False
          end>
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object grContactos: TrDBGrid
          Left = 0
          Top = 0
          Width = 948
          Height = 363
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsContactos
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          StyleElements = [seFont]
          Columns = <
            item
              Expanded = False
              FieldName = 'NOMBRE'
              Title.Caption = 'Nombre'
              Width = 156
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'AREA'
              Title.Caption = 'Departamento'
              Width = 136
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TELEFONO'
              Title.Caption = 'Tel'#233'fono'
              Width = 81
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CORREO'
              Title.Caption = 'Correo'
              Width = 150
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PRINCIPAL'
              Title.Caption = 'Principal'
              Width = 75
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ACCIONES'
              Title.Caption = 'Acciones'
              Width = 300
              Visible = True
            end>
        end
      end
    end
    object CarConsentimiento: TCard
      Tag = 2
      Left = 0
      Top = 0
      Width = 954
      Height = 427
      Caption = 'Card1'
      CardIndex = 2
      TabOrder = 3
      object rpClient: TRelativePanel
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 427
        Margins.Right = 20
        ControlCollection = <
          item
            Control = tjVigente
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = True
            AlignLeftWithPanel = True
            AlignRightWithPanel = True
            AlignTopWithPanel = True
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = tjHistorial
            AlignBottomWithPanel = True
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = True
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
            Below = tjVigente
          end>
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          954
          427)
        object tjVigente: TPlanoTarjeta
          Tag = 3
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 914
          Height = 104
          Margins.Left = 20
          Margins.Right = 20
          Caption = 'Estado vigente'
          Anchors = []
          TabOrder = 0
          object lblVersion: TLabel
            Tag = 13
            Left = 156
            Top = 40
            Width = 130
            Height = 15
            AutoSize = False
            Caption = 'Versi'#243'n del texto'
          end
          object valVersion: TLabel
            Tag = 25
            Left = 156
            Top = 57
            Width = 130
            Height = 18
            AutoSize = False
            Caption = 'v1.1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
          object lblOtorgado: TLabel
            Tag = 13
            Left = 302
            Top = 40
            Width = 190
            Height = 15
            AutoSize = False
            Caption = 'Otorgado el'
          end
          object valOtorgado: TLabel
            Tag = 25
            Left = 302
            Top = 57
            Width = 190
            Height = 18
            AutoSize = False
            Caption = '14/03/2024 09:42'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
          object lblRecogido: TLabel
            Tag = 13
            Left = 508
            Top = 40
            Width = 260
            Height = 15
            AutoSize = False
            Caption = 'Recogido por'
          end
          object valRecogido: TLabel
            Tag = 25
            Left = 508
            Top = 57
            Width = 260
            Height = 18
            AutoSize = False
            Caption = 'R. Sol'#237's (aplicaci'#243'n m'#243'vil)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
          object pstEstado: TPlanoPastilla
            Left = 24
            Top = 46
            Width = 70
            Height = 22
            Status = fsSuccess
            Caption = 'Otorgado'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
          object btnRevocar: TPlanoBotonWin
            Left = 734
            Top = 44
            Width = 170
            Height = 28
            Cursor = crHandPoint
            Caption = 'Registrar revocaci'#243'n'
            TabOrder = 0
            StyleElements = []
            Kind = fkDanger
          end
        end
        object tjHistorial: TPlanoTarjeta
          Tag = 3
          AlignWithMargins = True
          Left = 20
          Top = 130
          Width = 914
          Height = 288
          Margins.Left = 20
          Margins.Top = 20
          Margins.Right = 20
          Margins.Bottom = 20
          Caption = 'Historial'
          Anchors = []
          TabOrder = 1
          object pnlHistorial: TPanel
            Left = 0
            Top = 36
            Width = 914
            Height = 252
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object grHistorial: TrDBGrid
              AlignWithMargins = True
              Left = 10
              Top = 10
              Width = 894
              Height = 232
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alClient
              BorderStyle = bsNone
              DataSource = dmMemoria.dsConsentimientos
              Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'Tahoma'
              TitleFont.Style = []
              StyleElements = [seFont]
              Columns = <
                item
                  ButtonStyle = cbsEllipsis
                  Expanded = False
                  FieldName = 'FECHA'
                  Title.Caption = 'Fecha'
                  Width = 180
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'ACCION'
                  Title.Caption = 'Acci'#243'n'
                  Width = 160
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'VERSION_TEXTO'
                  Title.Caption = 'Versi'#243'n del texto'
                  Width = 180
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'FIRMANTE_NOMBRE'
                  Title.Caption = 'Registrado por'
                  Width = 340
                  Visible = True
                end>
            end
          end
        end
      end
    end
    object CarCotizaciones: TCard
      Tag = 2
      Left = 0
      Top = 0
      Width = 954
      Height = 427
      Caption = 'Card1'
      CardIndex = 3
      StyleElements = [seFont]
      TabOrder = 0
      object RelativePanel2: TRelativePanel
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 427
        ControlCollection = <
          item
            Control = Panel1
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = True
            AlignTopWithPanel = True
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = rpdatos
            AlignBottomWithPanel = True
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = True
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
            Below = Panel1
          end>
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Panel1: TPanel
          Tag = 2
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 948
          Height = 52
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            948
            52)
          object SearchBox1: TSearchBox
            Left = 20
            Top = 14
            Width = 300
            Height = 21
            BevelInner = bvNone
            BevelOuter = bvNone
            TabOrder = 0
            TextHint = 'Descripci'#243'n del trabajo'
            StyleElements = [seFont]
          end
          object btnPeriodo: TPlanoBotonWin
            Left = 332
            Top = 12
            Width = 300
            Height = 28
            Cursor = crHandPoint
            Caption = 'Todas las fechas'
            TabOrder = 1
            StyleElements = []
            Kind = fkSecondary
          end
          object cbFiltro: TComboBox
            Left = 644
            Top = 14
            Width = 160
            Height = 23
            Style = csDropDownList
            ItemIndex = 0
            TabOrder = 3
            Text = 'Todas las cotizaciones'
            OnChange = cbFiltroChange
            Items.Strings = (
              'Todas las cotizaciones'
              'Aprobadas'
              'Enviadas'
              'Rechazadas')
          end
          object btnExportar: TPlanoBotonWin
            Left = 812
            Top = 12
            Width = 130
            Height = 28
            Cursor = crHandPoint
            Anchors = [akTop, akRight]
            Caption = 'Exportar listado'
            TabOrder = 2
            StyleElements = []
            OnClick = btnExportarClick
            Kind = fkSecondary
          end
        end
        object rpdatos: TRelativePanel
          Tag = 2
          AlignWithMargins = True
          Left = 3
          Top = 101
          Width = 948
          Height = 377
          ControlCollection = <
            item
              Control = grCotizaciones
              AlignBottomWithPanel = True
              AlignHorizontalCenterWithPanel = False
              AlignLeftWithPanel = True
              AlignRightWithPanel = True
              AlignTopWithPanel = True
              AlignVerticalCenterWithPanel = False
            end>
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          object grCotizaciones: TrDBGrid
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 942
            Height = 371
            Align = alClient
            BorderStyle = bsNone
            DataSource = dmMemoria.dsClienteCotizaciones
            Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            StyleElements = []
            Columns = <
              item
                Expanded = False
                FieldName = 'NUMERO'
                Title.Caption = 'N'#250'mero'
                Width = 110
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'TIPO_TRABAJO_NOMBRE'
                Title.Caption = 'Tipo de trabajo'
                Width = 320
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'FECHA_ELABORACION'
                Title.Caption = 'Fecha'
                Width = 110
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'ELABORADA_POR_NOMBRE'
                Title.Caption = 'Elaborada por'
                Width = 150
                Visible = True
              end
              item
                Alignment = taRightJustify
                Expanded = False
                FieldName = 'MONTO_TOTAL'
                Title.Alignment = taRightJustify
                Title.Caption = 'Monto'
                Width = 120
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'ESTADO'
                Title.Caption = 'Estado'
                Width = 110
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'ACCIONES'
                Title.Caption = 'Acciones'
                Width = 120
                Visible = True
              end>
          end
        end
      end
    end
  end
  object ActionList1: TActionList
    Images = dmIconos.ViAnovo
    Left = 856
    Top = 256
    object AcRegregsar: TAction
      Caption = 'Regresar'
      ImageIndex = 32
      ImageName = 'Azul\16-volver-azul'
      OnExecute = AcRegregsarExecute
    end
  end
end
