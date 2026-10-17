inherited frmExportarRejilla: TfrmExportarRejilla
  Caption = 'Exportar'
  ClientHeight = 290
  ClientWidth = 440
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 440
  end
  inherited pnlTitulo: TPanel
    Width = 440
    inherited lblTitulo: TLabel
      Caption = ''
    end
    inherited lblSubtitulo: TLabel
      Caption = ''
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 230
    Width = 440
    TabOrder = 2
    inherited btnGuardar: TPlanoBotonWin
      OnClick = btnGuardarClick
    end
  end
  object pnlCampos: TPanel
    Tag = 2
    Left = 0
    Top = 87
    Width = 440
    Height = 143
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblFormato: TLabel
      Tag = 13
      Left = 20
      Top = 8
      Width = 400
      Height = 15
      AutoSize = False
      Caption = 'Formato'
    end
    object lblNota: TLabel
      Tag = 13
      Left = 20
      Top = 116
      Width = 400
      Height = 15
      AutoSize = False
    end
    object rbExcel: TRadioButton
      Left = 20
      Top = 30
      Width = 400
      Height = 20
      Caption = 'Libro de Excel (.xlsx)'
      TabOrder = 0
    end
    object rbCsv: TRadioButton
      Left = 20
      Top = 54
      Width = 400
      Height = 20
      Caption = 'Texto separado por punto y coma (.csv)'
      TabOrder = 1
    end
    object chkAbrir: TCheckBox
      Left = 20
      Top = 86
      Width = 400
      Height = 20
      Caption = 'Abrir el archivo al terminar'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
end
