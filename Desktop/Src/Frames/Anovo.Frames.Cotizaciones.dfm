object fraCotizaciones: TfraCotizaciones
  Left = 0
  Top = 0
  Width = 960
  Height = 620
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlBarra: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 71
    Width = 954
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
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
      TextHint = 'Buscar'
      StyleElements = [seFont]
    end
    object btnExportar: TPlanoBotonWin
      Left = 658
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
      Left = 796
      Top = 12
      Width = 138
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = '+ Nueva cotizaci'#243'n'
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
    TabOrder = 1
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 10
      Width = 117
      Height = 30
      Caption = 'Cotizaciones'
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
      Width = 452
      Height = 15
      Caption = 
        'Todas las cotizaciones del taller '#183' el estado manda lo que se pu' +
        'ede hacer con cada una'
    end
  end
  object pstFiltros: TPlanoPestanas
    Left = 0
    Top = 126
    Width = 960
    Height = 40
    Items.Strings = (
      'Todas'
      'Borrador'
      'Pendiente'
      'Aprobada'
      'Rechazada'
      'Enviada')
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
          Title.Caption = 'N'#250'mero'
          Width = 130
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CLIENTE'
          Title.Caption = 'Cliente'
          Width = 230
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FECHA'
          Title.Caption = 'Fecha'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ASESOR'
          Title.Caption = 'Asesor'
          Width = 140
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'MONTO'
          Title.Alignment = taRightJustify
          Title.Caption = 'Monto'
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ESTADO'
          Title.Caption = 'Estado'
          Width = 120
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
