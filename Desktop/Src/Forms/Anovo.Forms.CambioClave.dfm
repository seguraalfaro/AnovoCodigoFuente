object frmCambioClave: TfrmCambioClave
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cambiar mi clave'
  ClientHeight = 347
  ClientWidth = 440
  Color = 16447477
  CustomTitleBar.CaptionAlignment = taCenter
  CustomTitleBar.Control = TitleBarPanel1
  CustomTitleBar.Enabled = True
  CustomTitleBar.Height = 26
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Top = 26
  OldCreateOrder = True
  Position = poOwnerFormCenter
  StyleElements = [seBorder]
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object TitleBarPanel1: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 440
    Height = 25
    CustomButtons = <>
  end
  object pnlTitulo: TPanel
    Left = 0
    Top = 25
    Width = 440
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 12
      Caption = 'Cambiar mi clave'
    end
    object lblSubtitulo: TLabel
      Tag = 13
      Left = 20
      Top = 37
      Caption = 'Para su propia cuenta'
    end
  end
  object pnlCampos: TPanel
    Left = 0
    Top = 87
    Width = 440
    Height = 200
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object lblActual: TLabel
      Tag = 0
      Left = 20
      Top = 12
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
      Tag = 0
      Left = 20
      Top = 64
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
      Tag = 0
      Left = 20
      Top = 116
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
      Caption = 'M'#237'nimo 10 caracteres, con letras y n'#250'meros.'
    end
  end
  object pnlPie: TPanel
    Tag = 2
    Left = 0
    Top = 287
    Width = 440
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object btnGuardar: TPlanoBotonWin
      Left = 300
      Top = 14
      Width = 120
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Guardar'
      TabOrder = 0
      StyleElements = []
      OnClick = btnGuardarClick
    end
    object btnCancelar: TPlanoBotonWin
      Left = 170
      Top = 14
      Width = 120
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Cancelar'
      TabOrder = 1
      StyleElements = []
      OnClick = btnCancelarClick
      Kind = fkSecondary
    end
  end
end
