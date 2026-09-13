object fraClientes: TfraClientes
  AlignWithMargins = True
  Left = 0
  Top = 0
  Width = 960
  Height = 620
  Color = 16447477
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentBackground = False
  ParentColor = False
  ParentFont = False
  TabOrder = 0
  object pnlTitulo: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 954
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 10
      Width = 175
      Height = 30
      Caption = 'Gesti'#243'n de clientes'
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
      Width = 442
      Height = 15
      Caption = 
        'Clientes registrados '#183' el consentimiento se otorga en el m'#243'vil y' +
        ' aqu'#237' solo se consulta'
    end
  end
  object pnlBarra: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 71
    Width = 954
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      954
      52)
    object sbBuscar: TSearchBox
      Left = 20
      Top = 14
      Width = 300
      Height = 23
      BevelInner = bvNone
      BevelOuter = bvNone
      TabOrder = 0
      TextHint = 'Nombre o identificaci'#243'n'
      StyleElements = [seFont]
    end
    object btnExportar: TPlanoBotonWin
      Left = 656
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
      Left = 794
      Top = 12
      Width = 140
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = '+ Nuevo cliente'
      TabOrder = 2
      StyleElements = []
    end
  end
  object pnclient: TRelativePanel
    AlignWithMargins = True
    Left = 3
    Top = 175
    Width = 954
    Height = 371
    ControlCollection = <
      item
        Control = grClientes
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
    object grClientes: TrDBGrid
      Left = 0
      Top = 0
      Width = 954
      Height = 371
      Align = alClient
      BorderStyle = bsNone
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
          FieldName = 'IDENTIFICACION'
          Title.Caption = 'Identificaci'#243'n'
          Width = 102
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOMBRE'
          Title.Caption = 'Nombre o raz'#243'n social'
          Width = 205
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TELEFONO'
          Title.Caption = 'Tel'#233'fono'
          Width = 94
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CORREO'
          Title.Caption = 'Correo'
          Width = 154
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CONSENTIMIENTO'
          Title.Caption = 'Consentimiento'
          Width = 102
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCIONES'
          Title.Caption = 'Acciones'
          Width = 240
          Visible = True
        end>
    end
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
    TabOrder = 3
  end
  object pstFiltros: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 40
    Items.Strings = (
      'Todos'
      'Con consentimiento'
      'Pendientes')
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
end
