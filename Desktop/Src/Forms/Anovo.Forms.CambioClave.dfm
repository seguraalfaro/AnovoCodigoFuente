inherited frmCambioClave: TfrmCambioClave
  Caption = 'Cambiar mi clave'
  ClientHeight = 347
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 97
      Caption = 'Cambiar mi clave'
    end
    inherited lblSubtitulo: TLabel
      Width = 119
      Caption = 'Para su propia cuenta'
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 287
    TabOrder = 2
    inherited btnGuardar: TPlanoBotonWin
      OnClick = btnGuardarClick
    end
  end
  object pnlCampos: TPanel
    Left = 0
    Top = 87
    Width = 440
    Height = 200
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblActual: TLabel
      Left = 20
      Top = 12
      Width = 65
      Height = 15
      Caption = 'Clave actual'
    end
    object edActual: TEdit
      Left = 20
      Top = 30
      Width = 400
      Height = 23
      PasswordChar = '*'
      TabOrder = 0
    end
    object lblNueva: TLabel
      Left = 20
      Top = 64
      Width = 65
      Height = 15
      Caption = 'Clave nueva'
    end
    object edNueva: TEdit
      Left = 20
      Top = 82
      Width = 400
      Height = 23
      PasswordChar = '*'
      TabOrder = 1
    end
    object lblRepetir: TLabel
      Left = 20
      Top = 116
      Width = 107
      Height = 15
      Caption = 'Repetir clave nueva'
    end
    object edRepetir: TEdit
      Left = 20
      Top = 134
      Width = 400
      Height = 23
      PasswordChar = '*'
      TabOrder = 2
    end
    object lblRegla: TLabel
      Tag = 13
      Left = 20
      Top = 168
      Width = 243
      Height = 15
      Caption = 'M'#237'nimo 10 caracteres, con letras y n'#250'meros.'
    end
  end
end
