object frmPrecioCatalogo: TfrmPrecioCatalogo
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Precio'
  ClientHeight = 470
  ClientWidth = 560
  Color = 16447477
  CustomTitleBar.CaptionAlignment = taCenter
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
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Top = 26
  OldCreateOrder = True
  Position = poOwnerFormCenter
  StyleElements = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object TitleBarPanel1: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 560
    Height = 25
    CustomButtons = <>
  end
  object pnlTitulo: TPanel
    Left = 0
    Top = 25
    Width = 560
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 12
      Width = 111
      Height = 21
      Caption = 'Cambiar precio'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object lblSubtitulo: TLabel
      Tag = 13
      Left = 20
      Top = 37
      Width = 3
      Height = 15
    end
  end
  object pnlCampos: TPanel
    Left = 0
    Top = 87
    Width = 560
    Height = 110
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object edCosto: TrDBEdit
      Left = 20
      Top = 25
      Width = 160
      Height = 23
      DataField = 'COSTO_UNITARIO'
      DataSource = dmMemoria.dsPrecioCatalogo
      TabOrder = 0
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Costo unitario'
      DBEditLabel.ShowRequiredBold = True
    end
    object edPrecio: TrDBEdit
      Left = 200
      Top = 25
      Width = 160
      Height = 23
      DataField = 'PRECIO_UNITARIO'
      DataSource = dmMemoria.dsPrecioCatalogo
      TabOrder = 1
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Precio de venta'
      DBEditLabel.ShowRequiredBold = True
    end
    object edCostoHora: TrDBEdit
      Left = 20
      Top = 25
      Width = 160
      Height = 23
      DataField = 'COSTO_HORA'
      DataSource = dmMemoria.dsPrecioCatalogo
      TabOrder = 2
      Visible = False
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Costo por hora'
      DBEditLabel.ShowRequiredBold = True
      DBEditLabel.Visible = False
    end
    object edVigencia: TrDBEdit
      Left = 380
      Top = 25
      Width = 160
      Height = 23
      DataField = 'FECHA_VIGENCIA'
      DataSource = dmMemoria.dsPrecioCatalogo
      TabOrder = 3
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Vigente desde'
    end
  end
  object pnlHistorial: TPanel
    Left = 0
    Top = 197
    Width = 560
    Height = 213
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object lblHistorial: TLabel
      Tag = 13
      Left = 20
      Top = 8
      Width = 93
      Height = 15
      Caption = 'Precios anteriores'
    end
    object grHistorial: TrDBGrid
      AlignWithMargins = True
      Left = 20
      Top = 30
      Width = 520
      Height = 170
      DataSource = dmMemoria.dsHistorialPrecio
      Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
  end
  object pnlPie: TPanel
    Left = 0
    Top = 410
    Width = 560
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 4
    DesignSize = (
      560
      60)
    object btnGuardar: TPlanoBotonWin
      Left = 416
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
      Left = 290
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
  end
end
