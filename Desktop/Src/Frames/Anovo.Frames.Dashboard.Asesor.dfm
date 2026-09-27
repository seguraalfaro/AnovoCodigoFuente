object fraDashboardAsesor: TfraDashboardAsesor
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
    DesignSize = (
      960
      62)
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
      Width = 175
      Height = 15
      Caption = 'Lo que usted captur'#243' y en qu'#233' va'
    end
    object lblPeriodo: TLabel
      Tag = 13
      Left = 740
      Top = 40
      Width = 200
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Mes en curso'
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
    object tjSolicitudes: TPlanoTarjeta
      Tag = 8
      Left = 20
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 761589
      Caption = 'Solicitudes del mes'
      TabOrder = 0
      object lblSolicitudes: TLabel
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
    object tjEsperando: TPlanoTarjeta
      Tag = 7
      Left = 253
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 10510377
      Caption = 'Esperando cotizaci'#243'n'
      TabOrder = 1
      object lblEsperando: TLabel
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
      Caption = 'Aprobadas del mes'
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
    object tjMonto: TPlanoTarjeta
      Tag = 10
      Left = 719
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 6044186
      Caption = 'Monto aprobado'
      TabOrder = 3
      object lblMonto: TLabel
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
  object tjRecientes: TPlanoTarjeta
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
    Caption = 'Mis solicitudes de esta semana'
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = 1973276
    Font.Height = -15
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object grSolicitudes: TrDBGrid
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
      DataSource = dmMemoria.dsDashboardAsesor
      DefaultDrawing = False
      Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = 1973276
      TitleFont.Height = -15
      TitleFont.Name = 'Segoe UI Semibold'
      TitleFont.Style = [fsBold]
      StyleElements = [seFont]
    end
  end
end
