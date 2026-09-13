object fraCatalogos: TfraCatalogos
  AlignWithMargins = True
  Left = 0
  Top = 0
  Width = 960
  Height = 620
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 954
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 0
      Width = 92
      Height = 30
      Caption = 'Cat'#225'logos'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 8
      Top = 36
      Width = 504
      Height = 15
      Caption = 
        'Precios y tarifas base con que se calculan las cotizaciones '#183' la' +
        ' vigente es la marcada como activa'
    end
  end
  object PlanoPestanas1: TPlanoPestanas
    Left = 0
    Top = 71
    Width = 960
    Height = 42
    Items.Strings = (
      'Materiales'
      'Mano de obra'
      'Maquinas'
      'Tipos de Trabajo')
    CardPanel = CpMain
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
  object CpMain: TCardPanel
    Left = 0
    Top = 113
    Width = 960
    Height = 507
    Align = alClient
    ActiveCard = CardMateriales
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    StyleElements = [seFont, seBorder]
    object CardMateriales: TCard
      Left = 0
      Top = 0
      Width = 960
      Height = 507
      Caption = 'Materiales'
      CardIndex = 0
      TabOrder = 0
      object pnclient: TRelativePanel
        AlignWithMargins = True
        Left = 3
        Top = 52
        Width = 954
        Height = 355
        ControlCollection = <
          item
            Control = rDBMateriales
            AlignBottomWithPanel = True
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = True
            AlignTopWithPanel = True
            AlignVerticalCenterWithPanel = False
          end>
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object rDBMateriales: TrDBGrid
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 948
          Height = 349
          Align = alBottom
          BorderStyle = bsNone
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          StyleElements = [seFont]
          OptionsEx2.Appearance.TitleColLineStyle = psClear
        end
      end
      object pnbottom: TRelativePanel
        AlignWithMargins = True
        Left = 3
        Top = 413
        Width = 954
        Height = 91
        ControlCollection = <
          item
            Control = PlanoBotonWin3
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = True
            AlignVerticalCenterWith = PlanoBotonWin1
            AlignVerticalCenterWithPanel = False
            LeftOf = PlanoBotonWin1
          end
          item
            Control = PlanoBotonWin1
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = True
            AlignTopWithPanel = True
            AlignVerticalCenterWithPanel = False
          end>
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          954
          91)
        object PlanoBotonWin3: TPlanoBotonWin
          Left = 691
          Top = 3
          Width = 120
          Height = 30
          Cursor = crHandPoint
          Anchors = []
          Caption = 'PlanoBotonWin3'
          TabOrder = 0
          StyleElements = []
          Kind = fkSecondary
        end
        object PlanoBotonWin1: TPlanoBotonWin
          AlignWithMargins = True
          Left = 814
          Top = 3
          Width = 120
          Height = 30
          Cursor = crHandPoint
          Margins.Right = 20
          Anchors = []
          Caption = 'PlanoBotonWin3'
          TabOrder = 1
          StyleElements = []
        end
      end
      object pnTop: TRelativePanel
        Left = 0
        Top = 0
        Width = 960
        Height = 49
        ControlCollection = <
          item
            Control = SearchBox1
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = True
          end
          item
            Control = FlatWinButton1
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = True
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = True
          end
          item
            Control = PlanoPestanas2
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = True
            RightOf = SearchBox1
          end>
        Align = alTop
        BevelOuter = bvNone
        Color = 16447477
        ParentBackground = False
        TabOrder = 2
        DesignSize = (
          960
          49)
        object SearchBox1: TSearchBox
          Left = 4
          Top = 13
          Width = 317
          Height = 23
          Anchors = []
          BevelInner = bvNone
          BevelOuter = bvNone
          TabOrder = 0
          Text = 'SearchBox1'
          StyleElements = [seFont]
        end
        object FlatWinButton1: TFlatWinButton
          AlignWithMargins = True
          Left = 820
          Top = 9
          Width = 120
          Height = 30
          Cursor = crHandPoint
          Margins.Right = 20
          Anchors = []
          Caption = 'Agregar'
          TabOrder = 1
          StyleElements = []
          ColorOverride = 6044186
        end
        object PlanoPestanas2: TPlanoPestanas
          Left = 321
          Top = 9
          Width = 400
          Height = 30
          Items.Strings = (
            'Activos'
            'Inactivos'
            'Todos')
          Style = pesPastilla
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
          Anchors = []
          ParentFont = False
        end
      end
    end
    object CardManoObra: TCard
      Left = 0
      Top = 0
      Width = 960
      Height = 507
      Caption = 'Mano de obra'
      CardIndex = 1
      TabOrder = 1
    end
    object CardMaquinas: TCard
      Left = 0
      Top = 0
      Width = 960
      Height = 507
      Caption = 'Maquinas'
      CardIndex = 2
      TabOrder = 2
    end
    object CardTipos: TCard
      Left = 0
      Top = 0
      Width = 960
      Height = 507
      Caption = 'Tipos de Trabajo'
      CardIndex = 3
      TabOrder = 3
    end
  end
end
