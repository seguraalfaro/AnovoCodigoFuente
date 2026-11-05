object frmConfiguracionInicial: TfrmConfiguracionInicial
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Configuraci'#243'n inicial'
  ClientHeight = 404
  ClientWidth = 560
  Color = 16447477
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 1973276
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object lblIntro: TLabel
    Left = 16
    Top = 16
    Width = 528
    Height = 36
    AutoSize = False
    Caption = 
      'La base no tiene ning'#250'n administrador. Registre el primero y la ' +
      'raz'#243'n social de la empresa para arrancar el servidor; el resto de ' +
      'los datos de la empresa se completa desde el escritorio.'
    WordWrap = True
  end
  object tjAdministrador: TPlanoTarjeta
    Left = 16
    Top = 64
    Width = 528
    Height = 160
    BackColor = clWhite
    CardColor = 16447477
    Caption = 'Administrador'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10510377
    Font.Height = -13
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object edNombre: TLabeledEdit
      Left = 16
      Top = 62
      Width = 240
      Height = 23
      EditLabel.Width = 240
      EditLabel.Height = 15
      EditLabel.Caption = 'Nombre'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = 7500395
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 1973276
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edCorreo: TLabeledEdit
      Left = 272
      Top = 62
      Width = 240
      Height = 23
      EditLabel.Width = 240
      EditLabel.Height = 15
      EditLabel.Caption = 'Correo'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = 7500395
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 1973276
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object edClave: TLabeledEdit
      Left = 16
      Top = 112
      Width = 240
      Height = 23
      EditLabel.Width = 240
      EditLabel.Height = 15
      EditLabel.Caption = 'Clave'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = 7500395
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 1973276
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 2
    end
    object edConfirmar: TLabeledEdit
      Left = 272
      Top = 112
      Width = 240
      Height = 23
      EditLabel.Width = 240
      EditLabel.Height = 15
      EditLabel.Caption = 'Confirmar la clave'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = 7500395
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 1973276
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 3
    end
  end
  object tjEmpresa: TPlanoTarjeta
    Left = 16
    Top = 236
    Width = 528
    Height = 108
    BackColor = clWhite
    CardColor = 16447477
    Caption = 'Empresa'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10510377
    Font.Height = -13
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object edRazonSocial: TLabeledEdit
      Left = 16
      Top = 62
      Width = 240
      Height = 23
      EditLabel.Width = 240
      EditLabel.Height = 15
      EditLabel.Caption = 'Raz'#243'n social'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = 7500395
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 1973276
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edCedula: TLabeledEdit
      Left = 272
      Top = 62
      Width = 240
      Height = 23
      EditLabel.Width = 240
      EditLabel.Height = 15
      EditLabel.Caption = 'C'#233'dula jur'#237'dica'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = 7500395
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Segoe UI'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 1973276
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object btnCancelar: TPlanoBotonWin
    Left = 300
    Top = 356
    Width = 116
    Height = 32
    Cursor = crHandPoint
    Cancel = True
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 3
    StyleElements = []
    Kind = fkSecondary
  end
  object btnGuardar: TPlanoBotonWin
    Left = 428
    Top = 356
    Width = 116
    Height = 32
    Cursor = crHandPoint
    Caption = 'Guardar'
    Default = True
    TabOrder = 2
    StyleElements = []
    OnClick = btnGuardarClick
  end
end
