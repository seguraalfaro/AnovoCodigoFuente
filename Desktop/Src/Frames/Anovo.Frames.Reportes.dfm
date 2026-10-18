inherited fraReportes: TfraReportes
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 82
      Caption = 'Reportes'
    end
    inherited lblSubtitulo: TLabel
      Width = 330
      Caption = 'Lo que pas'#243' en el periodo: env'#237'os al cliente, respuestas y cada paso del flujo'
    end
  end
  inherited pnlKpi: TPanel
    Top = 114
    inherited tjCifra1: TPlanoTarjeta
      Width = 104
      Caption = 'Enviadas'
      inherited lblCifra1: TLabel
        Width = 72
      end
      object lblDelta1: TLabel
        Left = 16
        Top = 66
        Width = 72
        Height = 16
        AutoSize = False
      end
    end
    inherited tjCifra2: TPlanoTarjeta
      Left = 136
      Width = 220
      Caption = 'Monto enviado'
      inherited lblCifra2: TLabel
        Width = 188
      end
      object lblDelta2: TLabel
        Left = 16
        Top = 66
        Width = 188
        Height = 16
        AutoSize = False
      end
    end
    inherited tjCifra3: TPlanoTarjeta
      Left = 368
      Width = 104
      Caption = 'Aprobadas'
      inherited lblCifra3: TLabel
        Width = 72
      end
      object lblDelta3: TLabel
        Left = 16
        Top = 66
        Width = 72
        Height = 16
        AutoSize = False
      end
    end
    inherited tjCifra4: TPlanoTarjeta
      Left = 716
      Width = 104
      Caption = 'Tasa'
      inherited lblCifra4: TLabel
        Width = 72
      end
      object lblDelta4: TLabel
        Left = 16
        Top = 66
        Width = 72
        Height = 16
        AutoSize = False
      end
    end
    object tjCifra5: TPlanoTarjeta
      Tag = 8
      Left = 832
      Top = 8
      Width = 116
      Height = 92
      TitleHeight = 28
      CardColor = 761589
      Caption = 'Respuesta media'
      TabOrder = 4
      object lblCifra5: TLabel
        Tag = 16
        Left = 16
        Top = 32
        Width = 84
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
      object lblDelta5: TLabel
        Left = 16
        Top = 66
        Width = 84
        Height = 16
        AutoSize = False
      end
    end
    object tjCifra6: TPlanoTarjeta
      Tag = 9
      Left = 484
      Top = 8
      Width = 220
      Height = 92
      TitleHeight = 28
      CardColor = 6210850
      Caption = 'Monto aprobado'
      TabOrder = 5
      object lblCifra6: TLabel
        Tag = 16
        Left = 16
        Top = 32
        Width = 188
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
      object lblDelta6: TLabel
        Left = 16
        Top = 66
        Width = 188
        Height = 16
        AutoSize = False
      end
    end
  end
  inherited tjLista: TPlanoTarjeta
    Top = 230
    Height = 370
    object pstVistas: TPlanoPestanas
      AlignWithMargins = True
      Left = 10
      Top = 40
      Width = 900
      Height = 36
      Margins.Left = 10
      Margins.Top = 4
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alTop
      Items.Strings = (
        'Por estado'
        'Por asesor'
        'Por tipo de trabajo'
        'Por mes'
        'Clientes sin respuesta')
      Style = pesPastilla
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
      OnChange = pstVistasChange
      ParentFont = False
    end
    inherited grLista: TrDBGrid
      Top = 86
      Height = 236
      DataSource = dmMemoria.dsReporteEstados
      OnDblClick = grListaDblClick
    end
    object lblLeyenda: TLabel
      Tag = 13
      AlignWithMargins = True
      Left = 10
      Top = 326
      Width = 900
      Height = 34
      Margins.Left = 10
      Margins.Top = 4
      Margins.Right = 10
      Margins.Bottom = 6
      Align = alBottom
      AutoSize = False
      WordWrap = True
    end
  end
  object pnlFiltros: TPanel
    Tag = 2
    Left = 0
    Top = 62
    Width = 960
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      960
      52)
    object btnPeriodo: TPlanoBotonWin
      Left = 20
      Top = 12
      Width = 330
      Height = 28
      Cursor = crHandPoint
      Caption = 'Todas las fechas'
      TabOrder = 0
      StyleElements = []
      Kind = fkSecondary
    end
    object btnExportar: TPlanoBotonWin
      Left = 822
      Top = 12
      Width = 118
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Exportar'
      TabOrder = 1
      StyleElements = []
      OnClick = btnExportarClick
      Kind = fkSecondary
    end
    object btnPdf: TPlanoBotonWin
      Left = 696
      Top = 12
      Width = 118
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Imprimir / PDF'
      TabOrder = 2
      StyleElements = []
      OnClick = btnPdfClick
      Kind = fkSecondary
    end
  end
end
