inherited fraCatalogos: TfraCatalogos
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 177
      Caption = 'Cat'#225'logos de costo'
      ExplicitWidth = 177
    end
    inherited lblSubtitulo: TLabel
      Width = 498
      Caption = 
        'Precios y tarifas con que se calculan las cotizaciones '#183' la coti' +
        'zaci'#243'n guarda el vigente al armarla'
      ExplicitWidth = 498
    end
  end
  inherited pnlBarra: TPanel
    DesignSize = (
      954
      52)
    inherited sbBuscar: TSearchBox
      TextHint = 'C'#243'digo o descripci'#243'n'
    end
    inherited btnLimpiar: TPlanoBotonWin
      Left = 330
      ExplicitLeft = 330
    end
    object btnImportar: TPlanoBotonWin
      Left = 568
      Top = 12
      Width = 96
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Importar'
      Enabled = False
      TabOrder = 5
      StyleElements = []
      OnClick = btnImportarClick
      Kind = fkSecondary
    end
    object btnExportar: TPlanoBotonWin
      Left = 670
      Top = 12
      Width = 96
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Exportar'
      TabOrder = 3
      StyleElements = []
      OnClick = btnExportarClick
      Kind = fkSecondary
    end
    object btnNuevo: TPlanoBotonWin
      Left = 772
      Top = 12
      Width = 162
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = '+ Nuevo material'
      TabOrder = 4
      StyleElements = []
      OnClick = btnNuevoClick
    end
    object cbCategoria: TrDBLookupComboBox
      Left = 430
      Top = 13
      Width = 130
      Height = 23
      DropDownRows = 10
      KeyField = 'ID'
      ListField = 'NOMBRE'
      ListSource = dmMemoria.dsCategorias
      TabOrder = 2
      Visible = False
      OnClick = cbCategoriaClick
      ReadOnlyColor = clWindow
    end
  end
  inherited pnclient: TRelativePanel
    Top = 175
    Height = 392
    ControlCollection = <
      item
        Control = grDatos
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = True
        AlignRightWithPanel = True
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end
      item
        Control = cpCatalogo
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = True
        AlignRightWithPanel = True
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end>
    ExplicitTop = 175
    ExplicitHeight = 392
    inherited grDatos: TrDBGrid
      Width = 914
      Height = 386
      Margins.Right = 20
      Visible = False
    end
    object cpCatalogo: TCardPanel
      Tag = 2
      Left = 0
      Top = 0
      Width = 954
      Height = 392
      Align = alClient
      ActiveCard = crdTodos
      BevelOuter = bvNone
      Caption = ''
      TabOrder = 1
      object crdTodos: TCard
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 392
        Caption = ''
        CardIndex = 0
        TabOrder = 0
        object grTodos: TrDBGrid
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 931
          Height = 380
          Margins.Left = 20
        Margins.Right = 20
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsTodos
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          StyleElements = [seFont]
          Columns = <
            item
              Expanded = False
              FieldName = 'TIPO'
              Title.Caption = 'Tipo'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CODIGO'
              Title.Caption = 'C'#243'digo'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NOMBRE'
              Title.Caption = 'Nombre'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'UNIDAD_MEDIDA'
              Title.Caption = 'Unidad'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'COSTO'
              Title.Alignment = taRightJustify
              Title.Caption = 'Costo'
              Width = 90
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PRECIO_UNITARIO'
              Title.Alignment = taRightJustify
              Title.Caption = 'P. venta'
              Width = 90
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
              Width = 200
              Visible = True
            end>
        end
      end
      object crdMateriales: TCard
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 392
        Caption = ''
        CardIndex = 1
        TabOrder = 1
        object grMateriales: TrDBGrid
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 931
          Height = 380
          Margins.Left = 20
        Margins.Right = 20
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsMateriales
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          StyleElements = [seFont]
          Columns = <
            item
              Expanded = False
              FieldName = 'CODIGO'
              Title.Caption = 'C'#243'digo'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NOMBRE'
              Title.Caption = 'Nombre'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'UNIDAD_MEDIDA'
              Title.Caption = 'Unidad'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'COSTO_UNITARIO'
              Title.Alignment = taRightJustify
              Title.Caption = 'Costo'
              Width = 90
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PRECIO_UNITARIO'
              Title.Alignment = taRightJustify
              Title.Caption = 'Precio'
              Width = 90
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FECHA_VIGENCIA'
              Title.Caption = 'Vigente desde'
              Width = 100
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
              Width = 200
              Visible = True
            end>
        end
      end
      object crdManoObra: TCard
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 392
        Caption = ''
        CardIndex = 2
        TabOrder = 2
        object grManoObra: TrDBGrid
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 931
          Height = 380
          Margins.Left = 20
        Margins.Right = 20
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsManoObra
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          StyleElements = [seFont]
          Columns = <
            item
              Expanded = False
              FieldName = 'CODIGO'
              Title.Caption = 'C'#243'digo'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NOMBRE'
              Title.Caption = 'Nombre'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CATEGORIA_NOMBRE'
              Title.Caption = 'Categor'#237'a'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'UNIDAD_MEDIDA'
              Title.Caption = 'Unidad'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'COSTO_UNITARIO'
              Title.Alignment = taRightJustify
              Title.Caption = 'Costo'
              Width = 90
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FECHA_VIGENCIA'
              Title.Caption = 'Vigente desde'
              Width = 100
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
              Width = 200
              Visible = True
            end>
        end
      end
      object crdMaquinas: TCard
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 392
        Caption = ''
        CardIndex = 3
        TabOrder = 3
        object grMaquinas: TrDBGrid
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 931
          Height = 380
          Margins.Left = 20
        Margins.Right = 20
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsMaquinas
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          StyleElements = [seFont]
          Columns = <
            item
              Expanded = False
              FieldName = 'CODIGO'
              Title.Caption = 'C'#243'digo'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NOMBRE'
              Title.Caption = 'Nombre'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DESCRIPCION'
              Title.Caption = 'Descripci'#243'n'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'COSTO_HORA'
              Title.Alignment = taRightJustify
              Title.Caption = 'Costo por hora'
              Width = 90
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FECHA_VIGENCIA'
              Title.Caption = 'Vigente desde'
              Width = 100
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
              Width = 200
              Visible = True
            end>
        end
      end
      object crdTiposTrabajo: TCard
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 392
        Caption = ''
        CardIndex = 4
        TabOrder = 4
        object grTiposTrabajo: TrDBGrid
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 931
          Height = 380
          Margins.Left = 20
        Margins.Right = 20
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsTiposTrabajo
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          StyleElements = [seFont]
          Columns = <
            item
              Expanded = False
              FieldName = 'NOMBRE'
              Title.Caption = 'Nombre'
              Width = 160
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
              Width = 200
              Visible = True
            end>
        end
      end
      object crdUnidades: TCard
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 392
        Caption = ''
        CardIndex = 5
        TabOrder = 5
        object grUnidades: TrDBGrid
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 931
          Height = 380
          Margins.Left = 20
        Margins.Right = 20
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsUnidadesLista
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          StyleElements = [seFont]
          Columns = <
            item
              Expanded = False
              FieldName = 'NOMBRE'
              Title.Caption = 'Nombre'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ABREVIATURA'
              Title.Caption = 'Abreviatura'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'MAGNITUD'
              Title.Caption = 'Magnitud'
              Width = 160
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
              Width = 200
              Visible = True
            end>
        end
      end
      object crdSimples: TCard
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 392
        Caption = ''
        CardIndex = 6
        TabOrder = 6
        object grSimples: TrDBGrid
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 931
          Height = 380
          Margins.Left = 20
        Margins.Right = 20
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsCatalogoSimple
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          StyleElements = [seFont]
          Columns = <
            item
              Expanded = False
              FieldName = 'NOMBRE'
              Title.Caption = 'Nombre'
              Width = 160
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
              Width = 200
              Visible = True
            end>
        end
      end
    end
  end
  object pstCatalogo: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 40
    Items.Strings = (
      'Todos'
      'Materiales'
      'Mano de obra'
      'M'#225'quinas'
      'Tipos de trabajo'
      'Unidades de medida'
      'Tipos de material'
      'Acabados'
      'Formas de pago')
    Style = pesPastilla
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
    OnChange = pstCatalogoChange
    ParentFont = False
  end
end
