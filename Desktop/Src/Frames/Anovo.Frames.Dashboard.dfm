object fraDashboard: TfraDashboard
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
  object pnlTitulo: TPanel
    Tag = 2
    Left = 0
    Top = 0
    Width = 960
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
  object pnlKpi: TPanel
    Tag = 2
    Left = 0
    Top = 62
    Width = 960
    Height = 108
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object tjBorradores: TPlanoTarjeta
      Tag = 8
      Left = 20
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 761589
      Caption = 'Borradores'
      TabOrder = 0
      object lblBorradores: TLabel
        Tag = 16
        Left = 16
        Top = 32
        Width = 189
        Height = 34
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
    object tjPendientes: TPlanoTarjeta
      Tag = 7
      Left = 253
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 10510377
      Caption = 'Pendientes de aprobar'
      TabOrder = 1
      object lblPendientes: TLabel
        Tag = 16
        Left = 16
        Top = 32
        Width = 189
        Height = 34
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
    object tjAprobadas: TPlanoTarjeta
      Tag = 9
      Left = 486
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 6210850
      Caption = 'Aprobadas este mes'
      TabOrder = 2
      object lblAprobadas: TLabel
        Tag = 16
        Left = 16
        Top = 32
        Width = 189
        Height = 34
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
    object tjMontoMes: TPlanoTarjeta
      Tag = 10
      Left = 719
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 6044186
      Caption = 'Monto aprobado'
      TabOrder = 3
      object lblMontoMes: TLabel
        Tag = 16
        Left = 16
        Top = 32
        Width = 189
        Height = 34
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
  end
  object PlanoTarjeta1: TPlanoTarjeta
    Tag = 3
    AlignWithMargins = True
    Left = 20
    Top = 178
    Width = 920
    Height = 422
    Margins.Left = 20
    Margins.Top = 8
    Margins.Right = 20
    Margins.Bottom = 20
    Caption = 'Cotizaciones recientes     '
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = 1973276
    Font.Height = -15
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object grCotizaciones: TrDBGrid
      AlignWithMargins = True
      Left = 10
      Top = 46
      Width = 900
      Height = 366
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      BorderStyle = bsNone
      DataSource = dsCotizaciones
      DefaultDrawing = False
      Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = 1973276
      TitleFont.Height = -15
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
          Width = 250
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FECHA'
          Title.Caption = 'Fecha'
          Width = 110
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'MONTO'
          Title.Alignment = taRightJustify
          Title.Caption = 'Monto'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ESTADO'
          Title.Caption = 'Estado'
          Width = 130
          Visible = True
        end>
    end
  end
  object dsCotizaciones: TDataSource
    Left = 848
    Top = 230
  end
end
