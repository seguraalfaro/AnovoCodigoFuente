inherited frmColumnas: TfrmColumnas
  Caption = 'Columnas'
  ClientHeight = 487
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
    Top = 427
    Width = 440
    ControlCollection = <
      item
        Control = btnGuardar
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = True
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
      end
      item
        Control = btnCancelar
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
        LeftOf = btnGuardar
      end
      item
        Control = btnRestablecer
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = True
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
      end>
    TabOrder = 2
    inherited btnGuardar: TPlanoBotonWin
      OnClick = btnGuardarClick
    end
    object btnRestablecer: TPlanoBotonWin
      Tag = 21
      AlignWithMargins = True
      Left = 20
      Top = 14
      Width = 120
      Height = 32
      Cursor = crHandPoint
      Margins.Left = 20
      Caption = 'Restablecer'
      TabOrder = 2
      StyleElements = []
      OnClick = btnRestablecerClick
      Kind = fkSecondary
    end
  end
  object pstConfig: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 87
    Width = 434
    Height = 40
    Align = alTop
    Items.Strings = (
      'Columnas'
      'Vista')
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
    OnChange = pstConfigChange
  end
  object pnlVista: TPanel
    Tag = 2
    Left = 0
    Top = 130
    Width = 440
    Height = 297
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object chkFilasAlternas: TCheckBox
      Left = 20
      Top = 12
      Width = 380
      Height = 20
      Caption = 'Filas alternas de color'
      TabOrder = 0
    end
    object chkDegradado: TCheckBox
      Left = 20
      Top = 40
      Width = 380
      Height = 20
      Caption = 'Degradado en la fila elegida'
      TabOrder = 1
    end
    object chkOrdenarTitulo: TCheckBox
      Left = 20
      Top = 68
      Width = 380
      Height = 20
      Caption = 'Ordenar al hacer clic en el t'#237'tulo'
      TabOrder = 2
    end
    object chkEmbudo: TCheckBox
      Left = 20
      Top = 96
      Width = 380
      Height = 20
      Caption = 'Embudo de filtro en los t'#237'tulos'
      TabOrder = 3
    end
    object chkTotales: TCheckBox
      Left = 20
      Top = 124
      Width = 380
      Height = 20
      Caption = 'Fila de totales al pie'
      TabOrder = 4
    end
    object lblAltoFila: TLabel
      Tag = 13
      Left = 20
      Top = 162
      Width = 280
      Height = 15
      AutoSize = False
      Caption = 'Alto de cada fila'
    end
    object speAltoFila: TSpinEdit
      Left = 20
      Top = 182
      Width = 80
      Height = 24
      MaxValue = 48
      MinValue = 24
      TabOrder = 5
      Value = 34
    end
  end
  object pnlCampos: TPanel
    Tag = 2
    Left = 0
    Top = 130
    Width = 440
    Height = 300
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblColumnas: TLabel
      Tag = 13
      Left = 20
      Top = 8
      Width = 280
      Height = 15
      AutoSize = False
      Caption = 'Columnas visibles y su orden'
    end
    object lblAlineacion: TLabel
      Tag = 13
      Left = 20
      Top = 252
      Width = 280
      Height = 15
      AutoSize = False
      Caption = 'Alineaci'#243'n de la columna elegida'
    end
    object clbColumnas: TCheckListBox
      Left = 20
      Top = 28
      Width = 280
      Height = 214
      ItemHeight = 17
      TabOrder = 0
      OnClick = clbColumnasClick
      OnClickCheck = clbColumnasClickCheck
    end
    object btnSubir: TPlanoBotonWin
      Tag = 21
      Left = 312
      Top = 28
      Width = 108
      Height = 32
      Cursor = crHandPoint
      Caption = 'Subir'
      TabOrder = 1
      StyleElements = []
      OnClick = btnSubirClick
      Kind = fkSecondary
    end
    object btnBajar: TPlanoBotonWin
      Tag = 21
      Left = 312
      Top = 68
      Width = 108
      Height = 32
      Cursor = crHandPoint
      Caption = 'Bajar'
      TabOrder = 2
      StyleElements = []
      OnClick = btnBajarClick
      Kind = fkSecondary
    end
    object rbIzquierda: TRadioButton
      Left = 20
      Top = 272
      Width = 90
      Height = 17
      Caption = 'Izquierda'
      TabOrder = 3
      OnClick = rbAlineacionClick
    end
    object rbCentro: TRadioButton
      Left = 120
      Top = 272
      Width = 90
      Height = 17
      Caption = 'Centro'
      TabOrder = 4
      OnClick = rbAlineacionClick
    end
    object rbDerecha: TRadioButton
      Left = 220
      Top = 272
      Width = 90
      Height = 17
      Caption = 'Derecha'
      TabOrder = 5
      OnClick = rbAlineacionClick
    end
    object btnAplicarTodas: TPlanoBotonWin
      Tag = 21
      Left = 312
      Top = 264
      Width = 108
      Height = 32
      Cursor = crHandPoint
      Caption = 'Aplicar a todas'
      TabOrder = 6
      StyleElements = []
      OnClick = btnAplicarTodasClick
      Kind = fkSecondary
    end
  end
end
