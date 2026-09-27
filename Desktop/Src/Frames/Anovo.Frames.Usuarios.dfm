object fraUsuarios: TfraUsuarios
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
      Left = 676
      Top = 12
      Width = 130
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Exportar listado'
      TabOrder = 1
      StyleElements = []
      Kind = fkSecondary
      ExplicitLeft = 682
    end
    object btnNuevo: TPlanoBotonWin
      Left = 814
      Top = 12
      Width = 120
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = '+ Nuevo usuario'
      TabOrder = 2
      StyleElements = []
      ExplicitLeft = 820
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
    ExplicitLeft = 0
    ExplicitTop = 8
    ExplicitWidth = 960
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 10
      Width = 182
      Height = 30
      Caption = 'Gesti'#243'n de usuarios'
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
      Width = 397
      Height = 15
      Caption = 
        'Quien entra al sistema y con qu'#233' rol '#183' desactivar no borra, cons' +
        'erva el rastro'
    end
  end
  object pstFiltros: TPlanoPestanas
    Left = 0
    Top = 126
    Width = 960
    Height = 40
    Items.Strings = (
      'Todos'
      'Activos'
      'Inactivos')
    Style = pesPastilla
    Indent = 20
    BackColor = 16447477
    ActiveFont.Charset = DEFAULT_CHARSET
    ActiveFont.Color = clWindowText
    ActiveFont.Height = -12
    ActiveFont.Name = 'Segoe UI Semibold'
    ActiveFont.Style = []
    ExplicitTop = 114
  end
  object pnbottom: TRelativePanel
    Tag = 2
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
  object rpCliente: TRelativePanel
    Tag = 2
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
    ExplicitLeft = 432
    ExplicitTop = 320
    ExplicitWidth = 185
    ExplicitHeight = 41
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
      TitleFont.Color = 1973276
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      StyleElements = [seFont]
      Columns = <
        item
          Expanded = False
          FieldName = 'USUARIO'
          Title.Caption = 'Usuario'
          Width = 82
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOMBRE'
          Title.Caption = 'Nombre'
          Width = 144
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CORREO'
          Title.Caption = 'Correo'
          Width = 137
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ROL'
          Title.Caption = 'Rol'
          Width = 75
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ULTIMO_ACCESO'
          Title.Caption = #218'ltimo acceso'
          Width = 82
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ESTADO'
          Title.Caption = 'Estado'
          Width = 75
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
