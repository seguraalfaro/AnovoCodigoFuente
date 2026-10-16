inherited fraSolicitudesAsesor: TfraSolicitudesAsesor
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 136
      Caption = 'Mis solicitudes'
    end
    inherited lblSubtitulo: TLabel
      Width = 221
      Caption = 'Lo que usted captur'#243' y en qu'#233' va cada una'
    end
  end
  inherited pnlBarra: TPanel
    inherited sbBuscar: TSearchBox
      TextHint = 'Cliente o descripci'#243'n'
    end
    inherited btnLimpiar: TPlanoBotonWin
      Left = 330
    end
    object lblDesde: TLabel
      Tag = 13
      Left = 440
      Top = 18
      Width = 32
      Height = 15
      Caption = 'Desde'
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
    object lblHasta: TLabel
      Tag = 13
      Left = 614
      Top = 18
      Width = 30
      Height = 15
      Caption = 'Hasta'
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
    inherited grDatos: TrDBGrid
      Width = 914
      Height = 386
      Margins.Right = 20
      DataSource = dmMemoria.dsSeguimiento
      ColumnWidth = cwAutoWidth
    end
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
