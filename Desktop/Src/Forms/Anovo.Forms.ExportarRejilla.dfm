inherited frmExportarRejilla: TfrmExportarRejilla
  Caption = 'Exportar'
  ClientHeight = 497
  ClientWidth = 460
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 460
  end
  inherited pnlTitulo: TPanel
    Width = 460
    inherited lblTitulo: TLabel
      Caption = ''
    end
    inherited lblSubtitulo: TLabel
      Caption = ''
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 437
    Width = 460
    TabOrder = 2
    inherited btnGuardar: TPlanoBotonWin
      OnClick = btnGuardarClick
    end
  end
  object pnlCampos: TPanel
    Tag = 2
    Left = 0
    Top = 87
    Width = 460
    Height = 350
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblFormato: TLabel
      Tag = 12
      Left = 20
      Top = 8
      Width = 420
      Height = 17
      AutoSize = False
      Caption = 'Formato'
    end
    object lblSeparador: TLabel
      Tag = 13
      Left = 40
      Top = 84
      Width = 70
      Height = 15
      AutoSize = False
      Caption = 'Separador'
    end
    object lblColumnas: TLabel
      Tag = 12
      Left = 20
      Top = 118
      Width = 420
      Height = 17
      AutoSize = False
      Caption = 'Columnas'
    end
    object lblOpciones: TLabel
      Tag = 12
      Left = 20
      Top = 196
      Width = 420
      Height = 17
      AutoSize = False
      Caption = 'Opciones'
    end
    object lblNota: TLabel
      Tag = 13
      Left = 20
      Top = 322
      Width = 420
      Height = 15
      AutoSize = False
    end
    object rbExcel: TRadioButton
      Left = 20
      Top = 32
      Width = 420
      Height = 20
      Caption = 'Libro de Excel (.xlsx)'
      TabOrder = 0
      OnClick = CambioFormato
    end
    object rbCsv: TRadioButton
      Left = 20
      Top = 56
      Width = 420
      Height = 20
      Caption = 'Texto separado (.csv)'
      TabOrder = 1
      OnClick = CambioFormato
    end
    object cbSeparador: TComboBox
      Left = 116
      Top = 80
      Width = 180
      Height = 23
      Style = csDropDownList
      TabOrder = 2
    end
    object rbVisibles: TRadioButton
      Left = 20
      Top = 142
      Width = 420
      Height = 20
      Caption = 'Solo las columnas visibles'
      Checked = True
      TabOrder = 3
      TabStop = True
    end
    object rbTodas: TRadioButton
      Left = 20
      Top = 166
      Width = 420
      Height = 20
      Caption = 'Todas las columnas, tambi'#233'n las ocultas'
      TabOrder = 4
    end
    object chkTitulos: TCheckBox
      Left = 20
      Top = 220
      Width = 420
      Height = 20
      Caption = 'Incluir los t'#237'tulos de columna'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object chkTotales: TCheckBox
      Left = 20
      Top = 244
      Width = 420
      Height = 20
      Caption = 'Agregar una fila de totales (Excel)'
      TabOrder = 6
    end
    object chkFiltro: TCheckBox
      Left = 20
      Top = 268
      Width = 420
      Height = 20
      Caption = 'Poner filtros en los t'#237'tulos (Excel)'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
    object chkAbrir: TCheckBox
      Left = 20
      Top = 292
      Width = 420
      Height = 20
      Caption = 'Abrir el archivo al terminar'
      Checked = True
      State = cbChecked
      TabOrder = 8
    end
  end
end
