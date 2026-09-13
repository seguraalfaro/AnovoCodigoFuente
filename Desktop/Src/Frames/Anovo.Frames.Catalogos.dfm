object fraCatalogos: TfraCatalogos
  AlignWithMargins = True
  Left = 0
  Top = 0
  Width = 960
  Height = 620
  TabOrder = 0
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
    TabOrder = 0
  end
  object pnlBarra: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 71
    Width = 954
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      954
      52)
    object sbBuscar: TSearchBox
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
      Left = 634
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
    object btnNuevo: TPlanoBotonWin
      Left = 772
      Top = 12
      Width = 162
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = '+ Nuevo material'
      TabOrder = 2
      StyleElements = []
    end
  end
  object pnlTitulo: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 954
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 10
      Width = 177
      Height = 30
      Caption = 'Cat'#225'logos de costo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblSubtitulo: TLabel
      Tag = 13
      Left = 20
      Top = 40
      Width = 455
      Height = 13
      Caption = 
        'Precios y tarifas con que se calculan las cotizaciones '#183' la coti' +
        'zaci'#243'n guarda el vigente al armarla'
    end
  end
  object pstCatalogo: TPlanoPestanas
    Left = 0
    Top = 126
    Width = 960
    Height = 40
    Items.Strings = (
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
    ParentFont = False
  end
  object pnclient: TRelativePanel
    AlignWithMargins = True
    Left = 3
    Top = 169
    Width = 954
    Height = 377
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
    TabOrder = 4
    object grDatos: TrDBGrid
      Left = 0
      Top = 0
      Width = 954
      Height = 377
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
    end
  end
end
