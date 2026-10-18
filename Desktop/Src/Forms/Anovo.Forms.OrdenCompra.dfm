inherited frmOrdenCompra: TfrmOrdenCompra
  Caption = 'Orden de compra'
  ClientHeight = 260
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
    Top = 200
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
    Height = 113
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object lblOrden: TLabel
      Tag = 13
      Left = 20
      Top = 8
      Width = 98
      Height = 15
      Caption = 'Orden de compra'
    end
    object edOrden: TEdit
      Left = 20
      Top = 28
      Width = 440
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 40
      TabOrder = 0
    end
    object lblNota: TLabel
      Tag = 13
      Left = 20
      Top = 60
      Width = 440
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      WordWrap = True
    end
  end
end
