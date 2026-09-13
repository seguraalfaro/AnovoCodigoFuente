object fraBandeja: TfraBandeja
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
      Width = 213
      Height = 30
      Caption = 'Bandeja de aprobaci'#243'n'
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
      Width = 348
      Height = 13
      Caption = 
        'Cotizaciones a la espera de revisi'#243'n '#183' aprobar o devolver con mo' +
        'tivo'
    end
  end
  object pnlBarra: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 176
    Width = 954
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 71
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
    end
  end
  object pnclient: TRelativePanel
    AlignWithMargins = True
    Left = 3
    Top = 234
    Width = 954
    Height = 312
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
    TabOrder = 3
    ExplicitTop = 169
    ExplicitHeight = 377
    object grDatos: TrDBGrid
      Left = 0
      Top = 0
      Width = 954
      Height = 312
      Align = alClient
      BorderStyle = bsNone
      DefaultDrawing = False
      Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = 1973276
      TitleFont.Height = -11
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      StyleElements = [seFont]
      Columns = <
        item
          Expanded = False
          Title.Caption = '#'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CLIENTE'
          Title.Caption = 'Asesor'
          Width = 166
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FECHA'
          Title.Caption = 'Enviada'
          Width = 72
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ASESOR'
          Title.Caption = 'Arm'#243
          Width = 101
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'MONTO'
          Title.Alignment = taRightJustify
          Title.Caption = 'Monto'
          Width = 79
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ESTADO'
          Title.Caption = 'Estado'
          Width = 86
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCIONES'
          Title.Caption = 'Acciones'
          Width = 300
          Visible = True
        end
        item
          Expanded = False
          Visible = True
        end>
    end
  end
  object RelativePanel1: TRelativePanel
    AlignWithMargins = True
    Left = 3
    Top = 71
    Width = 954
    Height = 99
    ControlCollection = <
      item
        Control = tpPendiente
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = True
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
      end
      item
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = True
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
      end
      item
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = True
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
      end>
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      954
      99)
    object tpPendiente: TPlanoTarjeta
      AlignWithMargins = True
      Left = 20
      Top = 0
      Width = 289
      Height = 100
      Margins.Left = 20
      Margins.Right = 20
      Anchors = []
      StyleElements = [seFont, seBorder]
      TabOrder = 0
    end
    object TPlanoTarjeta
      AlignWithMargins = True
      Left = 332
      Top = 0
      Width = 289
      Height = 100
      Margins.Left = 20
      Margins.Right = 20
      Anchors = []
      TabOrder = 1
    end
    object TPlanoTarjeta
      AlignWithMargins = True
      Left = 645
      Top = 0
      Width = 289
      Height = 100
      Margins.Left = 20
      Margins.Right = 20
      Anchors = []
      TabOrder = 2
    end
  end
end
