inherited frmClaveTemporal: TfrmClaveTemporal
  Caption = 'Clave temporal'
  ClientHeight = 260
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 86
      Caption = 'Clave temporal'
    end
    inherited lblSubtitulo: TLabel
      Width = 60
      Caption = 'De la cuenta'
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 200
    TabOrder = 2
    inherited btnGuardar: TPlanoBotonWin
      OnClick = btnGuardarClick
    end
  end
  object pnlCampos: TPanel
    Left = 0
    Top = 87
    Width = 440
    Height = 113
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object edClave: TEdit
      Tag = 1
      Left = 20
      Top = 14
      Width = 400
      Height = 33
      Alignment = taCenter
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object lblAviso: TLabel
      Tag = 13
      Left = 20
      Top = 60
      Width = 400
      Height = 30
      AutoSize = False
      Caption = 'Entr'#233'guela en persona.'
      WordWrap = True
    end
  end
end
