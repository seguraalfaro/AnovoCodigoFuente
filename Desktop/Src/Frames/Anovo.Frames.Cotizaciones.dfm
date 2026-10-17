inherited fraCotizaciones: TfraCotizaciones
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 117
      Caption = 'Cotizaciones'
      ExplicitWidth = 117
    end
    inherited lblSubtitulo: TLabel
      Width = 448
      Caption = 
        'Las cotizaciones elaboradas y su estado '#183' abrir para ver el deta' +
        'lle, el croquis y las fotos'
      ExplicitWidth = 448
    end
  end
  inherited pnlBarra: TPanel
    inherited sbBuscar: TSearchBox
      TextHint = 'Cliente o descripci'#243'n'
    end
    object btnPeriodo: TPlanoBotonWin
      Left = 432
      Top = 12
      Width = 330
      Height = 28
      Cursor = crHandPoint
      Caption = 'Todas las fechas'
      TabOrder = 2
      StyleElements = []
      Kind = fkSecondary
    end
  end
  inherited pnclient: TRelativePanel
    Top = 175
    Height = 392
    ExplicitTop = 175
    ExplicitHeight = 392
    inherited grDatos: TrDBGrid
      Height = 386
      DataSource = dmMemoria.dsCotizacionesLista
      OnDblClick = grDatosDblClick
    end
  end
  inherited pnlSinRegistros: TPanel
    Top = 172
    Height = 398
    ExplicitTop = 172
    ExplicitHeight = 398
  end
  object pstFiltros: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 40
    Items.Strings = (
      'Todas'
      'Borrador'
      'En revisi'#243'n'
      'Devueltas'
      'Con visto bueno'
      'Enviadas'
      'Aprobadas'
      'Rechazadas')
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
