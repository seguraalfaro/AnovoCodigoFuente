inherited frmBuscarRejilla: TfrmBuscarRejilla
  Caption = 'Buscar'
  ClientHeight = 300
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
    Top = 240
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
    Height = 153
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblColumna: TLabel
      Tag = 13
      Left = 20
      Top = 8
      Width = 400
      Height = 15
      AutoSize = False
      Caption = 'Columna'
    end
    object lblTexto: TLabel
      Tag = 13
      Left = 20
      Top = 64
      Width = 400
      Height = 15
      AutoSize = False
      Caption = 'Texto que contiene'
    end
    object lblResultado: TLabel
      Tag = 13
      Left = 20
      Top = 122
      Width = 400
      Height = 15
      AutoSize = False
    end
    object cbColumna: TComboBox
      Left = 20
      Top = 28
      Width = 400
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
    object edTexto: TEdit
      Left = 20
      Top = 84
      Width = 400
      Height = 23
      TabOrder = 1
      OnChange = edTextoChange
    end
  end
end
