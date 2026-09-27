object fraAuditoria: TfraAuditoria
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
      Width = 85
      Height = 30
      Caption = 'Auditor'#237'a'
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
      Width = 153
      Height = 15
      Caption = 'Qui'#233'n cambi'#243' qu'#233' y cu'#225'ndo.'
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
    object lblDesde: TLabel
      Tag = 13
      Left = 20
      Top = 18
      Width = 32
      Height = 15
      Caption = 'Desde'
    end
    object lblHasta: TLabel
      Tag = 13
      Left = 176
      Top = 18
      Width = 30
      Height = 15
      Caption = 'Hasta'
    end
    object dtpDesde: TDateTimePicker
      Left = 60
      Top = 14
      Width = 106
      Height = 23
      Date = 46000.000000000000000000
      Format = 'dd/MM/yyyy'
      Time = 46000.000000000000000000
      TabOrder = 0
      OnChange = PeriodoChange
    end
    object dtpHasta: TDateTimePicker
      Left = 213
      Top = 14
      Width = 106
      Height = 23
      Date = 46000.000000000000000000
      Format = 'dd/MM/yyyy'
      Time = 46000.000000000000000000
      TabOrder = 1
      OnChange = PeriodoChange
    end
    object sbBuscar: TSearchBox
      Left = 335
      Top = 14
      Width = 300
      Height = 23
      BevelInner = bvNone
      BevelOuter = bvNone
      TabOrder = 2
      TextHint = 'Texto del detalle'
      StyleElements = [seFont]
      OnInvokeSearch = sbBuscarInvokeSearch
    end
    object btnLimpiar: TPlanoBotonWin
      Left = 643
      Top = 12
      Width = 90
      Height = 28
      Cursor = crHandPoint
      Caption = 'Limpiar'
      Enabled = False
      TabOrder = 3
      StyleElements = []
      OnClick = btnLimpiarClick
      Kind = fkSecondary
    end
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
        Control = grAuditoria
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
    object grAuditoria: TrDBGrid
      AlignWithMargins = True
      Left = 20
      Top = 3
      Width = 931
      Height = 386
      Margins.Left = 20
      Align = alClient
      BorderStyle = bsNone
      DataSource = dmMemoria.dsAuditoria
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
          FieldName = 'FECHA'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'USUARIO'
          Width = 160
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCION'
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ENTIDAD'
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ENTIDAD_ID'
          Title.Alignment = taRightJustify
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DETALLE'
          Width = 300
          Visible = True
        end>
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
  object pstFiltros: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 40
    Items.Strings = (
      'Todo'
      'Clientes'
      'Cotizaciones'
      'Cuentas')
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
    OnChange = pstFiltrosChange
    ParentFont = False
  end
end
