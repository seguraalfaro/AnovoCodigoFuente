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
    object btnExportar: TPlanoBotonWin
      Left = 634
      Top = 12
      Width = 130
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Exportar listado'
      TabOrder = 3
      StyleElements = []
      OnClick = btnExportarClick
      Kind = fkSecondary
    end
    object btnNuevo: TPlanoBotonWin
      Left = 770
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
    object cbCategoria: TComboBox
      Left = 430
      Top = 13
      Width = 180
      Height = 23
      Style = csDropDownList
      TabOrder = 2
      Visible = False
      OnChange = cbCategoriaChange
    end
  end
  inherited pnclient: TRelativePanel
    Top = 175
    Height = 392
    ExplicitTop = 175
    ExplicitHeight = 392
    inherited grDatos: TrDBGrid
      Width = 914
      Height = 386
      Margins.Right = 20
      ColumnWidth = cwAutoWidth
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
      'Tipos de trabajo')
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
