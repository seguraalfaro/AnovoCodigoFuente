inherited frmAjusteCotizacion: TfrmAjusteCotizacion
  Caption = 'Ajuste'
  ClientHeight = 400
  ClientWidth = 560
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 576
  ExplicitHeight = 439
  PixelsPerInch = 96
  TextHeight = 15
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 560
    ExplicitWidth = 560
  end
  inherited pnlTitulo: TPanel
    Width = 560
    ExplicitWidth = 560
    inherited lblTitulo: TLabel
      Caption = ''
    end
    inherited lblSubtitulo: TLabel
      Caption = ''
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 340
    Width = 560
    TabOrder = 1
    ExplicitTop = 340
    ExplicitWidth = 560
    inherited btnGuardar: TPlanoBotonWin
      Left = 420
      OnClick = btnGuardarClick
      ExplicitLeft = 420
    end
    inherited btnCancelar: TPlanoBotonWin
      Left = 294
      ExplicitLeft = 294
    end
  end
  object pnlCampos: TPanel
    Tag = 2
    Left = 0
    Top = 87
    Width = 560
    Height = 253
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblCostoRot: TLabel
      Tag = 13
      Left = 20
      Top = 104
      Width = 4
      Height = 15
      Caption = 'Costo'
    end
    object lblAjusteRot: TLabel
      Tag = 13
      Left = 20
      Top = 126
      Width = 4
      Height = 15
      Caption = 'Ajuste'
    end
    object lblIvaRot: TLabel
      Tag = 13
      Left = 20
      Top = 148
      Width = 4
      Height = 15
      Caption = 'IVA'
    end
    object lblTotalRot: TLabel
      Tag = 11
      Left = 20
      Top = 174
      Width = 4
      Height = 15
      Caption = 'Total'
    end
    object lblCosto: TLabel
      Tag = 25
      Left = 340
      Top = 104
      Width = 200
      Height = 15
      Alignment = taRightJustify
      AutoSize = False
    end
    object lblAjuste: TLabel
      Tag = 25
      Left = 340
      Top = 126
      Width = 200
      Height = 15
      Alignment = taRightJustify
      AutoSize = False
    end
    object lblIva: TLabel
      Tag = 25
      Left = 340
      Top = 148
      Width = 200
      Height = 15
      Alignment = taRightJustify
      AutoSize = False
    end
    object lblTotal: TLabel
      Tag = 11
      Left = 340
      Top = 174
      Width = 200
      Height = 20
      Alignment = taRightJustify
      AutoSize = False
    end
    object lblAyuda: TLabel
      Tag = 13
      Left = 20
      Top = 206
      Width = 520
      Height = 40
      AutoSize = False
      WordWrap = True
    end
    object rbDescuento: TRadioButton
      Left = 20
      Top = 10
      Width = 110
      Height = 17
      Caption = 'Descuento'
      TabOrder = 0
      OnClick = CambioAjuste
    end
    object rbRecargo: TRadioButton
      Left = 140
      Top = 10
      Width = 110
      Height = 17
      Caption = 'Recargo'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = CambioAjuste
    end
    object edPorcentaje: TrDBEdit
      Left = 20
      Top = 62
      Width = 120
      Height = 23
      DataField = 'PORCENTAJE'
      DataSource = dmMemoria.dsAjuste
      TabOrder = 2
      StyleElements = []
      OnChange = CambioAjuste
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Porcentaje'
      DBEditLabel.ShowRequiredBold = True
    end
    object edMotivo: TrDBEdit
      Left = 160
      Top = 62
      Width = 380
      Height = 23
      DataField = 'MOTIVO'
      DataSource = dmMemoria.dsAjuste
      TabOrder = 3
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Motivo'
      DBEditLabel.ShowRequiredBold = True
    end
  end
end
