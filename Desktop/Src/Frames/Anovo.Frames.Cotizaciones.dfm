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
    object lblDesde: TLabel [0]
      Tag = 13
      Left = 440
      Top = 18
      Width = 32
      Height = 15
      Caption = 'Desde'
    end
    object lblHasta: TLabel [1]
      Tag = 13
      Left = 614
      Top = 18
      Width = 30
      Height = 15
      Caption = 'Hasta'
    end
    inherited sbBuscar: TSearchBox
      TextHint = 'Cliente o descripci'#243'n'
    end
    object dtpDesde: TDateTimePicker
      Left = 482
      Top = 14
      Width = 120
      Height = 23
      Date = 46000.000000000000000000
      Format = 'dd/MM/yyyy'
      Time = 46000.000000000000000000
      ShowCheckbox = True
      Checked = False
      TabOrder = 2
      OnChange = FechasChange
    end
    object dtpHasta: TDateTimePicker
      Left = 652
      Top = 14
      Width = 120
      Height = 23
      Date = 46000.000000000000000000
      Format = 'dd/MM/yyyy'
      Time = 46000.000000000000000000
      ShowCheckbox = True
      Checked = False
      TabOrder = 3
      OnChange = FechasChange
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
