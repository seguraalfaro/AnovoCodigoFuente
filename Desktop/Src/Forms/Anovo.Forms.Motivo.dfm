inherited frmMotivo: TfrmMotivo
  Caption = 'Motivo'
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
    object lblMotivo: TLabel
      Tag = 13
      Left = 20
      Top = 8
      Width = 40
      Height = 15
      Caption = 'Motivo'
    end
    object mmMotivo: TMemo
      Left = 20
      Top = 28
      Width = 440
      Height = 104
      Anchors = [akLeft, akTop, akRight, akBottom]
      MaxLength = 500
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
