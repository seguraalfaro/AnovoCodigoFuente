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
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 960
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
  object PestanasPlanas1: TPestanasPlanas
    Left = 0
    Top = 71
    Width = 960
    Height = 56
    Pestanas.Strings = (
      'Materiales'
      'Mano de obra'
      'Maquinas'
      'Tipos de Trabajo')
    PageControl = PageControl1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    FuenteActiva.Charset = DEFAULT_CHARSET
    FuenteActiva.Color = clWindowText
    FuenteActiva.Height = -12
    FuenteActiva.Name = 'Segoe UI Semibold'
    FuenteActiva.Style = []
    ParentFont = False
    ExplicitLeft = -20
    ExplicitTop = 0
    ExplicitWidth = 980
  end
  object PageControl1: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 130
    Width = 954
    Height = 487
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object RelativePanel1: TRelativePanel
        Left = 0
        Top = 0
        Width = 946
        Height = 457
        ControlCollection = <
          item
            Control = RelativePanel2
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = True
            AlignTopWithPanel = True
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = pnData
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end>
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitLeft = 216
        ExplicitTop = 224
        ExplicitWidth = 185
        ExplicitHeight = 41
        DesignSize = (
          946
          457)
        object RelativePanel2: TRelativePanel
          Left = 0
          Top = 0
          Width = 946
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
              AlignRightWithPanel = False
              AlignTopWithPanel = False
              AlignVerticalCenterWithPanel = False
            end>
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            946
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
            Left = 817
            Top = 24
            Width = 120
            Height = 23
            Cursor = crHandPoint
            Anchors = []
            Caption = 'FlatWinButton1'
            TabOrder = 1
            StyleElements = []
            ColorOverride = 6044186
          end
        end
        object pnData: TPanel
          Tag = 3
          Left = 32
          Top = 112
          Width = 881
          Height = 249
          Anchors = []
          TabOrder = 1
          StyleElements = []
          object rDBMateriales: TrDBGrid
            Left = 1
            Top = 1
            Width = 879
            Height = 247
            Align = alClient
            BorderStyle = bsNone
            DefaultDrawing = False
            Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
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
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
    end
  end
end
