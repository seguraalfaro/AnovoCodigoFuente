object frmConexion: TfrmConexion
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Conexi'#243'n con el servidor'
  ClientHeight = 267
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
      Caption = 'Conexi'#243'n con el servidor'
    end
    object lblSubtitulo: TLabel
      Tag = 13
      Left = 20
      Top = 37
      Caption = 'La direcci'#243'n se guarda en este equipo'
    end
  end
  object pnlCampos: TPanel
    Left = 0
    Top = 87
    Width = 440
    Height = 120
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object lblUrl: TLabel
      Tag = 0
      Left = 20
      Top = 12
      Caption = 'Direcci'#243'n del servidor'
    end
    object edUrl: TEdit
      Left = 20
      Top = 30
      Width = 400
      Height = 23
      TabOrder = 0
    end
    object lblNota: TLabel
      Tag = 13
      Left = 20
      Top = 58
      Caption = 'Debe empezar por https://'
    end
    object lblPruebaRot: TLabel
      Tag = 13
      Left = 20
      Top = 86
      Caption = 'Prueba'
    end
    object lblPrueba: TLabel
      Tag = 25
      Left = 120
      Top = 85
      Width = 300
      Height = 15
      AutoSize = False
      Alignment = taRightJustify
      Caption = '-'
      EllipsisPosition = epEndEllipsis
    end
  end
  object pnlPie: TPanel
    Tag = 2
    Left = 0
    Top = 207
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
    object btnProbar: TPlanoBotonWin
      Left = 20
      Top = 14
      Width = 120
      Height = 32
      Cursor = crHandPoint
      Caption = 'Probar'
      TabOrder = 2
      StyleElements = []
      OnClick = btnProbarClick
      Kind = fkSecondary
    end
  end
end
