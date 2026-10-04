object fraListado: TfraListado
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
    Tag = 2
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
      Width = 52
      Height = 30
      Caption = 'T'#237'tulo'
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
      Width = 48
      Height = 15
      Caption = 'Subt'#237'tulo'
    end
  end
  object pnlBarra: TPanel
    Tag = 2
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
    object sbBuscar: TSearchBox
      Left = 20
      Top = 14
      Width = 300
      Height = 23
      BevelInner = bvNone
      BevelOuter = bvNone
      TabOrder = 0
      StyleElements = [seFont]
      OnInvokeSearch = sbBuscarInvokeSearch
    end
    object btnLimpiar: TPlanoBotonWin
      Left = 328
      Top = 12
      Width = 90
      Height = 28
      Cursor = crHandPoint
      Caption = 'Limpiar'
      Enabled = False
      TabOrder = 1
      StyleElements = []
      OnClick = btnLimpiarClick
      Kind = fkSecondary
    end
  end
  object pnclient: TRelativePanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 438
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
    TabOrder = 2
    object grDatos: TrDBGrid
      AlignWithMargins = True
      Left = 20
      Top = 3
      Width = 931
      Height = 432
      Margins.Left = 20
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
    end
  end
  object pnlSinRegistros: TPanel
    Tag = 1
    Left = 3
    Top = 129
    Width = 954
    Height = 438
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = True
    ParentColor = True
    TabOrder = 4
    Visible = False
    object pnlVacio: TPanel
      Tag = 1
      Left = 267
      Top = 109
      Width = 420
      Height = 200
      Anchors = []
      BevelOuter = bvNone
      ParentBackground = True
      ParentColor = True
      TabOrder = 0
      object shpVacio: TShape
        Tag = 1
        Left = 166
        Top = 0
        Width = 88
        Height = 88
        Brush.Color = 16114902
        Pen.Style = psClear
        Shape = stCircle
      end
      object imgVacio: TVirtualImage
        Tag = 1
        Left = 182
        Top = 16
        Width = 56
        Height = 56
        ImageCollection = dmIconos.IcAnovo
        ImageWidth = 0
        ImageHeight = 0
        ImageIndex = 112
        ImageName = 'Marca\12-buscar-marca'
      end
      object lblVacioTitulo: TLabel
        Tag = 11
        Left = 0
        Top = 104
        Width = 420
        Height = 25
        Alignment = taCenter
        AutoSize = False
      end
      object lblSinRegistros: TLabel
        Tag = 13
        Left = 0
        Top = 136
        Width = 420
        Height = 40
        Alignment = taCenter
        AutoSize = False
        WordWrap = True
      end
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
      Height = 15
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
