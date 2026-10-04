inherited fraCotizaciones: TfraCotizaciones
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Caption = 'Cotizaciones'
    end
    inherited lblSubtitulo: TLabel
      Caption =
        'Las cotizaciones elaboradas y su estado '#183' abrir para ver el det' +
        'alle, el croquis y las fotos'
    end
  end
  inherited pnlBarra: TPanel
    inherited sbBuscar: TSearchBox
      TextHint = 'Cliente o descripci'#243'n'
    end
  end
  inherited pnclient: TRelativePanel
    Top = 175
    Height = 392
    inherited grDatos: TrDBGrid
      DataSource = dmMemoria.dsCotizacionesLista
      OnDblClick = grDatosDblClick
    end
  end
  object pstFiltros: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 40
    Align = alTop
    Items.Strings = (
      'Todas'
      'Borrador'
      'Pendientes'
      'Aprobadas'
      'Enviadas'
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
