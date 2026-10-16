inherited frmColumnas: TfrmColumnas
  Caption = 'Columnas'
  ClientHeight = 447
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
    Top = 387
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
  object pnlCampos: TPanel
    Tag = 2
    Left = 0
    Top = 87
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
