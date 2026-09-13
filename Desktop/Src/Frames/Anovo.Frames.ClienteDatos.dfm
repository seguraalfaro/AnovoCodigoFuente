object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 960
  Height = 620
  TabOrder = 0
  object rpTitulo: TRelativePanel
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
    ParentFont = False
  end
  object pnbottom: TRelativePanel
    AlignWithMargins = True
    Left = 3
    Top = 552
    Width = 954
    Height = 65
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
    AlignWithMargins = True
    Left = 3
    Top = 111
    Width = 954
    Height = 435
    Align = alClient
    ActiveCard = CarCotizaciones
    BevelOuter = bvNone
    Caption = 'CardPanel1'
    TabOrder = 3
    object CarCotizaciones: TCard
      Left = 0
      Top = 0
      Width = 954
      Height = 435
      Caption = 'Card1'
      CardIndex = 0
      TabOrder = 0
      object RelativePanel2: TRelativePanel
        Left = 0
        Top = 0
        Width = 954
        Height = 435
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
            Control = pstFiltros
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = True
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
            Below = Panel1
          end
          item
            Control = rpdatos
            AlignBottomWithPanel = True
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = True
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
            Below = pstFiltros
          end>
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitLeft = 424
        ExplicitTop = 208
        ExplicitWidth = 185
        ExplicitHeight = 41
        object Panel1: TPanel
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
            TextHint = 'C'#243'digo o descripci'#243'n'
            StyleElements = [seFont]
          end
          object btnExportar: TPlanoBotonWin
            Left = 812
            Top = 12
            Width = 130
            Height = 28
            Cursor = crHandPoint
            Anchors = [akTop, akRight]
            Caption = 'Exportar listado'
            TabOrder = 1
            StyleElements = []
            Kind = fkSecondary
          end
        end
        object pstFiltros: TPlanoPestanas
          Left = 0
          Top = 58
          Width = 954
          Height = 40
          Items.Strings = (
            'Todas'
            'Aprobadas'
            'Enviadas'
            'Rechazadas')
          Style = pesPastilla
          Indent = 20
          BackColor = 16447477
          ActiveFont.Charset = DEFAULT_CHARSET
          ActiveFont.Color = clWindowText
          ActiveFont.Height = -12
          ActiveFont.Name = 'Segoe UI Semibold'
          ActiveFont.Style = []
          Anchors = []
        end
        object rpdatos: TRelativePanel
          AlignWithMargins = True
          Left = 3
          Top = 101
          Width = 948
          Height = 377
          ControlCollection = <
            item
              Control = rDBGrid1
              AlignBottomWithPanel = True
              AlignHorizontalCenterWithPanel = False
              AlignLeftWithPanel = True
              AlignRightWithPanel = True
              AlignTopWithPanel = False
              AlignVerticalCenterWithPanel = False
            end>
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 2
          object rDBGrid1: TrDBGrid
            Left = 0
            Top = -5
            Width = 948
            Height = 382
            Align = alClient
            BorderStyle = bsNone
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
                FieldName = 'CODIGO'
                Title.Caption = 'N'#250'mero'
                Width = 110
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'TIPO'
                Title.Caption = 'Tipo de trabajo'
                Width = 320
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'FECHA'
                Title.Caption = 'Fecha'
                Width = 110
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'ASESOR'
                Title.Caption = 'Elaborada por'
                Width = 150
                Visible = True
              end
              item
                Alignment = taRightJustify
                Expanded = False
                FieldName = 'MONTO'
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
              end>
          end
        end
      end
    end
    object CarConsentimiento: TCard
      Left = 0
      Top = 0
      Width = 954
      Height = 435
      Caption = 'Card1'
      CardIndex = 1
      TabOrder = 3
      object rpClient: TRelativePanel
        Left = 0
        Top = 0
        Width = 954
        Height = 435
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
        TabOrder = 0
        ExplicitLeft = 336
        ExplicitTop = 208
        ExplicitWidth = 185
        ExplicitHeight = 41
        DesignSize = (
          954
          435)
        object tjVigente: TPlanoTarjeta
          AlignWithMargins = True
          Left = 20
          Top = 4
          Width = 912
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
          AlignWithMargins = True
          Left = 21
          Top = 131
          Width = 912
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
            Width = 912
            Height = 252
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            ExplicitWidth = 920
            object grHistorial: TrDBGrid
              AlignWithMargins = True
              Left = 10
              Top = 10
              Width = 892
              Height = 232
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alClient
              BorderStyle = bsNone
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
                  FieldName = 'MOMENTO'
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
                  FieldName = 'VERSION'
                  Title.Caption = 'Versi'#243'n del texto'
                  Width = 180
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'USUARIO'
                  Title.Caption = 'Registrado por'
                  Width = 340
                  Visible = True
                end>
            end
          end
        end
      end
    end
    object CarContactos: TCard
      Left = 0
      Top = 0
      Width = 954
      Height = 435
      Caption = 'Card1'
      CardIndex = 2
      TabOrder = 2
      object pnlBarra: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 948
        Height = 52
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitLeft = 0
        ExplicitTop = 8
        ExplicitWidth = 954
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
          ExplicitLeft = 816
        end
      end
      object pnclient: TRelativePanel
        AlignWithMargins = True
        Left = 3
        Top = 61
        Width = 948
        Height = 371
        ControlCollection = <
          item
            Control = grDatos
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
        ExplicitTop = 169
        ExplicitWidth = 954
        ExplicitHeight = 377
        object grDatos: TrDBGrid
          Left = 0
          Top = 0
          Width = 948
          Height = 371
          Align = alClient
          BorderStyle = bsNone
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
              FieldName = 'CARGO'
              Title.Caption = 'Cargo'
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
    object CarDatos: TCard
      Left = 0
      Top = 0
      Width = 954
      Height = 435
      Caption = 'Card1'
      CardIndex = 3
      TabOrder = 1
      object RelativePanel1: TRelativePanel
        Left = 0
        Top = 0
        Width = 954
        Height = 435
        ControlCollection = <
          item
            Control = tjIdentificacion
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = True
          end
          item
            Control = tjUbicacion
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = True
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = True
          end>
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitLeft = 232
        ExplicitTop = 184
        ExplicitWidth = 185
        ExplicitHeight = 41
        DesignSize = (
          954
          435)
        object tjIdentificacion: TPlanoTarjeta
          AlignWithMargins = True
          Left = 20
          Top = 67
          Width = 477
          Height = 300
          Margins.Left = 20
          Caption = 'Identificaci'#243'n'
          Anchors = []
          TabOrder = 0
          object lblNombre: TLabel
            Tag = 13
            Left = 16
            Top = 40
            Width = 560
            Height = 15
            AutoSize = False
            Caption = 'Nombre'
          end
          object valNombre: TLabel
            Left = 16
            Top = 57
            Width = 560
            Height = 18
            AutoSize = False
            Caption = 'Talleres Metal'#250'rgicos Vargas'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
          object lblIdentificacion: TLabel
            Tag = 13
            Left = 16
            Top = 90
            Width = 560
            Height = 15
            AutoSize = False
            Caption = 'Identificaci'#243'n'
          end
          object valIdentificacion: TLabel
            Left = 16
            Top = 107
            Width = 560
            Height = 18
            AutoSize = False
            Caption = '3-101-284719'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
          object lblTelefono: TLabel
            Tag = 13
            Left = 16
            Top = 140
            Width = 560
            Height = 15
            AutoSize = False
            Caption = 'Tel'#233'fono'
          end
          object valTelefono: TLabel
            Left = 16
            Top = 157
            Width = 560
            Height = 18
            AutoSize = False
            Caption = '2440-8812'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
          object lblCorreo: TLabel
            Tag = 13
            Left = 16
            Top = 190
            Width = 560
            Height = 15
            AutoSize = False
            Caption = 'Correo'
          end
          object valCorreo: TLabel
            Left = 16
            Top = 207
            Width = 560
            Height = 18
            AutoSize = False
            Caption = 'compras@tmvargas.cr'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
          object lblDireccion: TLabel
            Tag = 13
            Left = 16
            Top = 240
            Width = 560
            Height = 15
            AutoSize = False
            Caption = 'Direcci'#243'n'
          end
          object valDireccion: TLabel
            Left = 16
            Top = 257
            Width = 560
            Height = 18
            AutoSize = False
            Caption = 'San Rafael de Alajuela, 300 m este'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
        end
        object tjUbicacion: TPlanoTarjeta
          AlignWithMargins = True
          Left = 602
          Top = 67
          Width = 332
          Height = 300
          Margins.Right = 20
          Caption = 'Impuesto y ubicaci'#243'n'
          Anchors = []
          TabOrder = 1
          object lblRegimen: TLabel
            Tag = 13
            Left = 16
            Top = 40
            Width = 250
            Height = 15
            AutoSize = False
            Caption = 'R'#233'gimen'
          end
          object valRegimen: TLabel
            Left = 16
            Top = 57
            Width = 250
            Height = 18
            AutoSize = False
            Caption = 'Gravado 13 %'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
          object lblExoneracion: TLabel
            Tag = 13
            Left = 16
            Top = 90
            Width = 250
            Height = 15
            AutoSize = False
            Caption = 'C'#243'digo de exoneraci'#243'n'
          end
          object valExoneracion: TLabel
            Left = 16
            Top = 107
            Width = 250
            Height = 18
            AutoSize = False
            Caption = 'No aplica'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
          object lblLatitud: TLabel
            Tag = 13
            Left = 16
            Top = 140
            Width = 250
            Height = 15
            AutoSize = False
            Caption = 'Latitud'
          end
          object valLatitud: TLabel
            Left = 16
            Top = 157
            Width = 250
            Height = 18
            AutoSize = False
            Caption = '9,995431'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
          object lblLongitud: TLabel
            Tag = 13
            Left = 16
            Top = 190
            Width = 250
            Height = 15
            AutoSize = False
            Caption = 'Longitud'
          end
          object valLongitud: TLabel
            Left = 16
            Top = 207
            Width = 250
            Height = 18
            AutoSize = False
            Caption = '-84,211907'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
          object lblAvisoUbicacion: TLabel
            Tag = 13
            Left = 16
            Top = 244
            Width = 250
            Height = 32
            AutoSize = False
            Caption = 
              'Las coordenadas son de la visita t'#233'cnica, con prop'#243'sito declarad' +
              'o y limitado.'
            WordWrap = True
          end
        end
      end
    end
  end
  object ActionList1: TActionList
    Images = dmIconos.ViAnovo
    Left = 744
    Top = 240
    object AcRegregsar: TAction
      Caption = 'Regresar'
      ImageIndex = 32
      ImageName = 'Azul\16-volver-azul'
    end
  end
end
