object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 560
  ClientWidth = 900
  Color = clBtnFace
  CustomTitleBar.Control = TitleBarPanel1
  CustomTitleBar.Enabled = True
  CustomTitleBar.Height = 26
  CustomTitleBar.BackgroundColor = clWhite
  CustomTitleBar.ForegroundColor = 65793
  CustomTitleBar.InactiveBackgroundColor = clWhite
  CustomTitleBar.InactiveForegroundColor = 10066329
  CustomTitleBar.ButtonForegroundColor = 65793
  CustomTitleBar.ButtonBackgroundColor = clWhite
  CustomTitleBar.ButtonHoverForegroundColor = 65793
  CustomTitleBar.ButtonHoverBackgroundColor = 16053492
  CustomTitleBar.ButtonPressedForegroundColor = 65793
  CustomTitleBar.ButtonPressedBackgroundColor = 15395562
  CustomTitleBar.ButtonInactiveForegroundColor = 10066329
  CustomTitleBar.ButtonInactiveBackgroundColor = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Top = 26
  OldCreateOrder = False
  Position = poDesktopCenter
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TitleBarPanel1: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 25
    CustomButtons = <
      item
        ButtonType = sbCustom
        Enabled = True
        Width = 32
        Visible = True
      end>
    ExplicitWidth = 701
    DesignSize = (
      900
      25)
  end
  object pnlForm: TPanel
    Left = 420
    Top = 25
    Width = 480
    Height = 535
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 426
    object imgFiligrana: TImage
      Left = 288
      Top = -2
      Width = 190
      Height = 190
      Center = True
    end
    object lblTitulo: TLabel
      Left = 56
      Top = 56
      Width = 300
      Height = 40
      AutoSize = False
      Caption = 'Ingreso'
      Transparent = True
    end
    object lblAyuda: TLabel
      Left = 56
      Top = 100
      Width = 380
      Height = 16
      AutoSize = False
      Transparent = True
    end
    object lblUsuario: TLabel
      Left = 56
      Top = 140
      Width = 36
      Height = 13
      Caption = 'Usuario'
      Transparent = True
    end
    object lblClave: TLabel
      Left = 56
      Top = 208
      Width = 56
      Height = 13
      Caption = 'Contrase'#241'a'
      Transparent = True
    end
    object lblOlvido: TLabel
      Left = 244
      Top = 274
      Width = 180
      Height = 15
      Alignment = taRightJustify
      AutoSize = False
      Caption = #191'Olvid'#243' su contrase'#241'a?'
      Transparent = True
    end
    object lblMensaje: TLabel
      Left = 56
      Top = 358
      Width = 368
      Height = 32
      AutoSize = False
      Transparent = True
      WordWrap = True
    end
    object lblConfigurar: TLabel
      Left = 82
      Top = 502
      Width = 66
      Height = 13
      Caption = 'Configuraci'#243'n'
      Transparent = True
    end
    object lblVersion: TLabel
      Left = 324
      Top = 502
      Width = 100
      Height = 15
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'v0.1.0'
      Transparent = True
    end
    object pbIconoConfig: TPaintBox
      Left = 56
      Top = 501
      Width = 18
      Height = 18
    end
    object SpeedButton1: TSpeedButton
      Left = 184
      Top = 432
      Width = 23
      Height = 22
      Flat = True
    end
    object pnlCampoUsuario: TPanel
      Left = 56
      Top = 160
      Width = 368
      Height = 34
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 0
      object pbIconoUsuario: TPaintBox
        Left = 10
        Top = 7
        Width = 20
        Height = 20
      end
      object edtUsuario: TEdit
        Left = 38
        Top = 6
        Width = 322
        Height = 20
        BorderStyle = bsNone
        MaxLength = 60
        TabOrder = 0
        TextHint = 'usuario'
      end
    end
    object pnlCampoClave: TPanel
      Left = 56
      Top = 228
      Width = 368
      Height = 34
      BevelOuter = bvNone
      BorderStyle = bsSingle
      TabOrder = 1
      object pbIconoClave: TPaintBox
        Left = 10
        Top = 7
        Width = 20
        Height = 20
      end
      object pbOjo: TPaintBox
        Left = 336
        Top = 7
        Width = 20
        Height = 20
        Cursor = crHandPoint
      end
      object edtClave: TEdit
        Left = 38
        Top = 6
        Width = 290
        Height = 20
        BorderStyle = bsNone
        MaxLength = 60
        PasswordChar = '*'
        TabOrder = 0
      end
    end
    object pnlIngresar: TPanel
      Left = 56
      Top = 295
      Width = 368
      Height = 42
      Cursor = crHandPoint
      BevelOuter = bvNone
      TabOrder = 2
      object pbIconoEntrar: TPaintBox
        Left = 138
        Top = 11
        Width = 20
        Height = 20
      end
      object lblIngresar: TLabel
        Left = 166
        Top = 0
        Width = 120
        Height = 42
        AutoSize = False
        Caption = 'Ingresar'
        Transparent = True
        Layout = tlCenter
      end
    end
    object aiCargando: TActivityIndicator
      Left = 224
      Top = 358
    end
  end
  object pnlMarca: TPanel
    Left = 0
    Top = 25
    Width = 420
    Height = 535
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 8
    ExplicitTop = 0
    ExplicitHeight = 560
    object ImgFondo: TImage
      Left = 0
      Top = 0
      Width = 420
      Height = 535
      Align = alClient
      Proportional = True
      Stretch = True
      ExplicitLeft = 120
      ExplicitTop = 384
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
    object ImgLogo: TImage
      Left = 63
      Top = 88
      Width = 218
      Height = 153
      Center = True
      Proportional = True
      Stretch = True
      Transparent = True
    end
  end
end
