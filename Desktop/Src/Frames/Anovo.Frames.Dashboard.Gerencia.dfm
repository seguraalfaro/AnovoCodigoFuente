object fraDashboardGerencia: TfraDashboardGerencia
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
  object pnlTitulo: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 954
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 10
      Width = 101
      Height = 30
      Caption = 'Dashboard'
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
      Width = 179
      Height = 15
      Caption = 'Lo que hay en curso ahora mismo'
    end
  end
  object RelativePanel1: TRelativePanel
    Left = 0
    Top = 68
    Width = 960
    Height = 125
    Margins.Top = 20
    ControlCollection = <
      item
        Control = Panel1
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = False
      end
      item
        Control = tjBorradores
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = True
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
      end
      item
        Control = tjPendientes
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
        RightOf = tjBorradores
      end
      item
        Control = tjAprobadas
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
        RightOf = tjPendientes
      end
      item
        Control = tjMontoMes
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = True
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
        RightOf = tjAprobadas
      end>
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      960
      125)
    object Panel1: TPanel
      Left = -767
      Top = -21
      Width = 960
      Height = 62
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Tag = 11
        Left = 20
        Top = 10
        Width = 101
        Height = 30
        Caption = 'Dashboard'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Tag = 13
        Left = 20
        Top = 40
        Width = 179
        Height = 15
        Caption = 'Lo que hay en curso ahora mismo'
      end
    end
    object tjBorradores: TPlanoTarjeta
      AlignWithMargins = True
      Left = 20
      Top = 16
      Width = 221
      Height = 92
      Margins.Left = 20
      TitleHeight = 28
      CardColor = 761589
      Caption = 'Cotizado en el mes'
      Anchors = []
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object lblBorradores: TLabel
        Tag = 7
        Left = 16
        Top = 32
        Width = 189
        Height = 34
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
    object tjPendientes: TPlanoTarjeta
      AlignWithMargins = True
      Left = 247
      Top = 16
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 10510377
      Caption = 'Tasa de aprobaci'#243'n'
      Anchors = []
      TabOrder = 2
      object lblPendientes: TLabel
        Tag = 8
        Left = 16
        Top = 32
        Width = 189
        Height = 34
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
    object tjAprobadas: TPlanoTarjeta
      AlignWithMargins = True
      Left = 474
      Top = 16
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 6210850
      Caption = 'Respuesta media'
      Anchors = []
      TabOrder = 3
      object lblAprobadas: TLabel
        Tag = 9
        Left = 16
        Top = 32
        Width = 189
        Height = 34
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
    object tjMontoMes: TPlanoTarjeta
      AlignWithMargins = True
      Left = 701
      Top = 16
      Width = 221
      Height = 92
      Margins.Right = 20
      TitleHeight = 28
      CardColor = 6044186
      Caption = 'Asesores activos'
      Anchors = []
      TabOrder = 4
      object lblMontoMes: TLabel
        Tag = 10
        Left = 16
        Top = 32
        Width = 189
        Height = 34
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
  end
  object RelativePanel2: TRelativePanel
    Left = 0
    Top = 193
    Width = 960
    Height = 427
    ControlCollection = <
      item
        Control = PlanoTarjeta1
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = True
        AlignLeftWithPanel = True
        AlignRightWithPanel = True
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end
      item
        Control = PlanoTarjeta2
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = True
        AlignLeftWithPanel = True
        AlignRightWithPanel = True
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = False
        Below = PlanoTarjeta1
      end>
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object PlanoTarjeta1: TPlanoTarjeta
      AlignWithMargins = True
      Left = 20
      Top = 3
      Width = 920
      Height = 200
      Margins.Left = 20
      Margins.Right = 20
      Caption = 'Productividad por asesor'
      Align = alTop
      Font.Charset = ANSI_CHARSET
      Font.Color = 1973276
      Font.Height = -14
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object grDatos: TrDBGrid
        AlignWithMargins = True
        Left = 10
        Top = 46
        Width = 900
        Height = 144
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        BorderStyle = bsNone
        DefaultDrawing = False
        Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        TabOrder = 0
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = 1973276
        TitleFont.Height = -14
        TitleFont.Name = 'Segoe UI Semibold'
        TitleFont.Style = [fsBold]
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
    object PlanoTarjeta2: TPlanoTarjeta
      AlignWithMargins = True
      Left = 20
      Top = 209
      Width = 920
      Height = 208
      Margins.Left = 20
      Margins.Right = 20
      Caption = 'Cotizaciones por estado'
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = 1973276
      Font.Height = -14
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object rDBGrid1: TrDBGrid
        AlignWithMargins = True
        Left = 10
        Top = 46
        Width = 900
        Height = 152
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        BorderStyle = bsNone
        DefaultDrawing = False
        Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        TabOrder = 0
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = 1973276
        TitleFont.Height = -14
        TitleFont.Name = 'Segoe UI Semibold'
        TitleFont.Style = [fsBold]
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
end
