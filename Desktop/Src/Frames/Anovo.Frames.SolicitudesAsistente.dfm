inherited fraSolicitudesAsistente: TfraSolicitudesAsistente
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 99
      Caption = 'Solicitudes'
      ExplicitWidth = 99
    end
    inherited lblSubtitulo: TLabel
      Width = 339
      Caption = 
        'Sin procesar: la cola com'#250'n '#183' Mis solicitudes: las que usted tom' +
        #243
      ExplicitWidth = 339
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
    ExplicitTop = 175
    ExplicitHeight = 392
    inherited grDatos: TrDBGrid
      Height = 386
      DataSource = dmMemoria.dsSolicitudesCola
    end
  end
  object pstModo: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 40
    Items.Strings = (
      'Sin procesar'
      'Mis solicitudes')
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
    OnChange = pstModoChange
    ParentFont = False
  end
end
