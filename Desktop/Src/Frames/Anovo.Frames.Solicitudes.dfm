object fraSolicitudes: TfraSolicitudes
  AlignWithMargins = True
  Left = 0
  Top = 0
  Width = 960
  Height = 620
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 1973276
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlBarra: TPanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 71
    Width = 954
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object sbBuscar: TSearchBox
      Left = 20
      Top = 14
      Width = 300
      Height = 21
      BevelInner = bvNone
      BevelOuter = bvNone
      TabOrder = 0
      TextHint = 'Cliente o descripci'#243'n'
      StyleElements = [seFont]
      OnInvokeSearch = sbBuscarInvokeSearch
    end
    object btnLimpiar: TPlanoBotonWin
      Left = 330
      Top = 12
      Width = 90
      Height = 28
      Cursor = crHandPoint
      Caption = 'Limpiar'
      TabOrder = 1
      Visible = False
      StyleElements = []
      OnClick = btnLimpiarClick
      Kind = fkSecondary
    end
  end
  object pnlTitulo: TPanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 954
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 10
      Width = 136
      Height = 30
      Caption = 'Mis solicitudes'
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
      Width = 221
      Height = 13
      Caption = 'Lo que usted captur'#243' y en qu'#233' va cada una'
    end
  end
  object pstPeriodo: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 40
    Items.Strings = (
      'Este mes'
      'Historial completo')
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
    OnChange = pstPeriodoChange
    ParentFont = False
  end
  object pnclient: TRelativePanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 175
    Width = 954
    Height = 392
    ControlCollection = <
      item
        Control = grSolicitudes
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
    object grSolicitudes: TrDBGrid
      AlignWithMargins = True
      Left = 20
      Top = 3
      Width = 914
      Height = 386
      Margins.Left = 20
      Margins.Right = 20
      Align = alClient
      BorderStyle = bsNone
      DataSource = dmMemoria.dsSeguimiento
      DefaultDrawing = False
      Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = 1973276
      TitleFont.Height = -11
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      StyleElements = [seFont]
      ColumnWidth = cwAutoWidth
    end
  end
  object pnlPie: TPanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 573
    Width = 954
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 3
    DesignSize = (
      954
      44)
    object lblPaginacion: TLabel
      Tag = 13
      Left = 20
      Top = 14
      Width = 3
      Height = 13
    end
    object btnAnterior: TPlanoBotonWin
      Left = 700
      Top = 8
      Width = 110
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Anterior'
      Enabled = False
      TabOrder = 0
      StyleElements = []
      OnClick = btnAnteriorClick
      Kind = fkSecondary
    end
    object btnSiguiente: TPlanoBotonWin
      Left = 824
      Top = 8
      Width = 110
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Siguiente'
      Enabled = False
      TabOrder = 1
      StyleElements = []
      OnClick = btnSiguienteClick
      Kind = fkSecondary
    end
  end
end
