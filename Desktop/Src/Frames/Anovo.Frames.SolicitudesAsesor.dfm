inherited fraSolicitudesAsesor: TfraSolicitudesAsesor
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 136
      Caption = 'Mis solicitudes'
      ExplicitWidth = 136
    end
    inherited lblSubtitulo: TLabel
      Width = 226
      Caption = 'Lo que usted captur'#243' y en qu'#233' va cada una'
      ExplicitWidth = 226
    end
  end
  inherited pnlBarra: TPanel
    inherited sbBuscar: TSearchBox
      TextHint = 'Cliente o descripci'#243'n'
    end
    inherited btnLimpiar: TPlanoBotonWin
      Left = 330
      ExplicitLeft = 330
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
      Width = 914
      Height = 386
      Margins.Right = 20
      DataSource = dmMemoria.dsSeguimiento
      ColumnWidth = cwAutoWidth
    end
  end
  inherited pnlSinRegistros: TPanel
    Top = 172
    Height = 398
    ExplicitTop = 172
    ExplicitHeight = 398
  end
  object pstPeriodo: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 40
    Items.Strings = (
      'Este mes'
      'Historial completo')
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
    OnChange = pstPeriodoChange
    ParentFont = False
  end
end
