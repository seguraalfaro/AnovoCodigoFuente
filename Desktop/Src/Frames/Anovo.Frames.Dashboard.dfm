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
      Caption = ''
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
      Caption = ''
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
    object tjCifra1: TPlanoTarjeta
      Tag = 8
      Left = 20
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 761589
      Caption = ''
      TabOrder = 0
      object lblCifra1: TLabel
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
    object tjCifra2: TPlanoTarjeta
      Tag = 7
      Left = 253
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 10510377
      Caption = ''
      TabOrder = 1
      object lblCifra2: TLabel
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
    object tjCifra3: TPlanoTarjeta
      Tag = 9
      Left = 486
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 6210850
      Caption = ''
      TabOrder = 2
      object lblCifra3: TLabel
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
    object tjCifra4: TPlanoTarjeta
      Tag = 10
      Left = 719
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 6044186
      Caption = ''
      TabOrder = 3
      object lblCifra4: TLabel
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
  object tjLista: TPlanoTarjeta
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
    Caption = ''
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = 1973276
    Font.Height = -15
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object grLista: TrDBGrid
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
