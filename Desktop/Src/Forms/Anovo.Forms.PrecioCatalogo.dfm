inherited frmPrecioCatalogo: TfrmPrecioCatalogo
  Caption = 'Precio'
  ClientHeight = 524
  ClientWidth = 560
  StyleElements = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 566
  ExplicitHeight = 553
  PixelsPerInch = 96
  TextHeight = 15
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 560
    ExplicitWidth = 560
  end
  inherited pnlTitulo: TPanel
    Width = 560
    Color = clWhite
    ParentBackground = False
    ExplicitWidth = 560
    inherited lblTitulo: TLabel
      Width = 111
      Height = 21
      Caption = 'Cambiar precio'
      Font.Height = -16
      Font.Name = 'Segoe UI Semibold'
      ParentFont = False
      ExplicitWidth = 111
      ExplicitHeight = 21
    end
    inherited lblSubtitulo: TLabel
      Width = 3
      Caption = ''
      ExplicitWidth = 3
    end
  end
  inherited pnlPie: TPanel
    Top = 464
    Width = 560
    TabOrder = 4
    ExplicitTop = 464
    inherited btnGuardar: TPlanoBotonWin
      OnClick = btnGuardarClick
    end
  end
  object pnlCampos: TPanel
    Left = 0
    Top = 87
    Width = 560
    Height = 90
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblNotaVigencia: TLabel
      Tag = 13
      Left = 20
      Top = 62
      Width = 130
      Height = 15
      Caption = 'El precio rige de una vez.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
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
    object edVigencia: TrDBEditDate
      AlignWithMargins = True
      Left = 382
      Top = 25
      Width = 139
      Height = 23
      DataField = 'FECHA_VIGENCIA'
      DataSource = dmMemoria.dsPrecioCatalogo
      Enabled = False
      TabOrder = 3
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Rige desde'
      DateValue = 46291.000000000000000000
    end
    object chkProgramado: TCheckBox
      Left = 505
      Top = 2
      Width = 16
      Height = 17
      TabOrder = 4
    end
  end
  object pnlHistorial: TPanel
    Left = 0
    Top = 177
    Width = 560
    Height = 287
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object lblHistorial: TLabel
      Tag = 13
      AlignWithMargins = True
      Left = 20
      Top = 3
      Width = 537
      Height = 15
      Margins.Left = 20
      Align = alTop
      Caption = 'Precios anteriores'
      ExplicitWidth = 93
    end
    object grHistorial: TrDBGrid
      AlignWithMargins = True
      Left = 20
      Top = 24
      Width = 520
      Height = 260
      Margins.Left = 20
      Margins.Right = 20
      Align = alClient
      DataSource = dmMemoria.dsHistorialPrecio
      Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'FECHA_VIGENCIA'
          Title.Caption = 'Vigente desde'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COSTO_UNITARIO'
          Title.Alignment = taRightJustify
          Title.Caption = 'Costo'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PRECIO_UNITARIO'
          Title.Alignment = taRightJustify
          Title.Caption = 'Precio'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COSTO_HORA'
          Title.Alignment = taRightJustify
          Title.Caption = 'Costo por hora'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ESTADO'
          Title.Caption = 'Estado'
          Width = 90
          Visible = True
        end>
    end
  end
end
