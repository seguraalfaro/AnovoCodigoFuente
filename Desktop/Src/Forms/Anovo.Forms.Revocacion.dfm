inherited frmRevocacion: TfrmRevocacion
  Caption = 'Revocaci'#243'n'
  ClientHeight = 290
  ClientWidth = 480
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 480
  end
  inherited pnlTitulo: TPanel
    Width = 480
    inherited lblTitulo: TLabel
      Caption = ''
    end
    inherited lblSubtitulo: TLabel
      Caption = ''
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 230
    Width = 480
    TabOrder = 2
    inherited btnGuardar: TPlanoBotonWin
      OnClick = btnGuardarClick
    end
  end
  object pnlCampos: TPanel
    Tag = 2
    Left = 0
    Top = 87
    Width = 480
    Height = 143
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblNombre: TLabel
      Tag = 13
      Left = 20
      Top = 8
      Width = 40
      Height = 15
      Caption = 'Nombre'
    end
    object edNombre: TEdit
      Left = 20
      Top = 28
      Width = 440
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 150
      TabOrder = 0
    end
    object lblIdentificacion: TLabel
      Tag = 13
      Left = 20
      Top = 68
      Width = 80
      Height = 15
      Caption = 'Identificaci'#243'n'
    end
    object edIdentificacion: TEdit
      Left = 20
      Top = 88
      Width = 200
      Height = 23
      MaxLength = 30
      TabOrder = 1
    end
  end
end
