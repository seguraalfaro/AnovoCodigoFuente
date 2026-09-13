object fraAuditoria: TfraAuditoria
  Left = 0
  Top = 0
  Width = 960
  Height = 620
  Font.Charset = ANSI_CHARSET
  Font.Color = 1973276
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  StyleElements = [seFont, seBorder]
  object pnlBarra: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 71
    Width = 954
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 0
    ExplicitTop = 62
    ExplicitWidth = 960
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
      Left = 804
      Top = 12
      Width = 130
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Exportar listado'
      TabOrder = 1
      StyleElements = []
      Kind = fkSecondary
      ExplicitLeft = 810
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
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 960
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
      Width = 371
      Height = 15
      Caption = 
        'Rastro de lo que cada usuario hizo '#183' solo lectura, no se edita n' +
        'i se borra'
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
      'Cotizaciones'
      'Cat'#225'logos'
      'Usuarios')
    Style = pesPastilla
    Indent = 20
    BackColor = 16447477
    ActiveFont.Charset = DEFAULT_CHARSET
    ActiveFont.Color = clWindowText
    ActiveFont.Height = -12
    ActiveFont.Name = 'Segoe UI Semibold'
    ActiveFont.Style = []
    ExplicitLeft = 0
    ExplicitTop = 114
    ExplicitWidth = 960
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
    Top = 175
    Width = 954
    Height = 371
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
    ExplicitTop = 169
    ExplicitHeight = 377
    object grDatos: TrDBGrid
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
      TitleFont.Color = 1973276
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      StyleElements = [seFont]
      Columns = <
        item
          Expanded = False
          FieldName = 'MOMENTO'
          Title.Caption = 'Fecha y hora'
          Width = 131
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'USUARIO'
          Title.Caption = 'Usuario'
          Width = 103
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCION'
          Title.Caption = 'Acci'#243'n'
          Width = 168
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ENTIDAD'
          Title.Caption = 'Entidad'
          Width = 121
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'REFERENCIA'
          Title.Caption = 'Referencia'
          Width = 131
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ORIGEN'
          Title.Caption = 'Origen'
          Width = 103
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCIONES'
          Title.Caption = 'Acciones'
          Width = 140
          Visible = True
        end>
    end
  end
end
