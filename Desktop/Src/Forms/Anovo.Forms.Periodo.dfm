inherited frmPeriodo: TfrmPeriodo
  Caption = 'Periodo'
  ClientHeight = 300
  ClientWidth = 560
  OnCreate = FormCreate
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 560
  end
  inherited pnlTitulo: TPanel
    Width = 560
    inherited lblTitulo: TLabel
      Caption = ''
    end
    inherited lblSubtitulo: TLabel
      Caption = ''
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 240
    Width = 560
    TabOrder = 2
    inherited btnGuardar: TPlanoBotonWin
      Caption = 'Aplicar'
      OnClick = btnGuardarClick
    end
  end
  object pnlCampos: TPanel
    Tag = 2
    Left = 0
    Top = 87
    Width = 560
    Height = 153
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblAtajos: TLabel
      Tag = 13
      Left = 20
      Top = 8
      Width = 35
      Height = 15
      Caption = 'Atajos'
    end
    object lblFechas: TLabel
      Tag = 13
      Left = 20
      Top = 88
      Width = 37
      Height = 15
      Caption = 'Fechas'
    end
    object lblDesde: TLabel
      Tag = 13
      Left = 20
      Top = 116
      Width = 32
      Height = 15
      Caption = 'Desde'
    end
    object lblHasta: TLabel
      Tag = 13
      Left = 210
      Top = 116
      Width = 30
      Height = 15
      Caption = 'Hasta'
    end
    object rbHoy: TRadioButton
      Left = 20
      Top = 30
      Width = 125
      Height = 17
      Caption = 'Hoy'
      TabOrder = 0
      OnClick = AtajoClick
    end
    object rbEstaSemana: TRadioButton
      Left = 150
      Top = 30
      Width = 125
      Height = 17
      Caption = 'Esta semana'
      TabOrder = 1
      OnClick = AtajoClick
    end
    object rbEsteMes: TRadioButton
      Left = 280
      Top = 30
      Width = 125
      Height = 17
      Caption = 'Este mes'
      TabOrder = 2
      OnClick = AtajoClick
    end
    object rbMesAnterior: TRadioButton
      Left = 410
      Top = 30
      Width = 130
      Height = 17
      Caption = 'Mes anterior'
      TabOrder = 3
      OnClick = AtajoClick
    end
    object rbTresMeses: TRadioButton
      Left = 20
      Top = 56
      Width = 125
      Height = 17
      Caption = #218'ltimos tres meses'
      TabOrder = 4
      OnClick = AtajoClick
    end
    object rbEsteAnio: TRadioButton
      Left = 150
      Top = 56
      Width = 125
      Height = 17
      Caption = 'Este a'#241'o'
      TabOrder = 5
      OnClick = AtajoClick
    end
    object rbPersonalizado: TRadioButton
      Left = 280
      Top = 56
      Width = 125
      Height = 17
      Caption = 'Personalizado'
      TabOrder = 6
      OnClick = AtajoClick
    end
    object rbTodas: TRadioButton
      Left = 410
      Top = 56
      Width = 130
      Height = 17
      Caption = 'Todas las fechas'
      TabOrder = 7
      OnClick = AtajoClick
    end
    object dtpDesde: TDateTimePicker
      Left = 62
      Top = 112
      Width = 130
      Height = 23
      Date = 46000.000000000000000000
      Format = 'dd/MM/yyyy'
      Time = 46000.000000000000000000
      ShowCheckbox = True
      TabOrder = 8
      OnChange = FechasChange
    end
    object dtpHasta: TDateTimePicker
      Left = 250
      Top = 112
      Width = 130
      Height = 23
      Date = 46000.000000000000000000
      Format = 'dd/MM/yyyy'
      Time = 46000.000000000000000000
      ShowCheckbox = True
      TabOrder = 9
      OnChange = FechasChange
    end
  end
end
