object frmItemCatalogo: TfrmItemCatalogo
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cat'#225'logo'
  ClientHeight = 560
  ClientWidth = 527
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
    Width = 527
    Height = 25
    CustomButtons = <>
    ExplicitWidth = 314
  end
  object pnlTitulo: TPanel
    Left = 0
    Top = 25
    Width = 527
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
      Caption = 'Nuevo material'
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
  object pnlPie: TPanel
    Left = 0
    Top = 500
    Width = 527
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 4
    DesignSize = (
      527
      60)
    object btnGuardar: TPlanoBotonWin
      Left = 387
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
      Left = 257
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
  object pnlPrecio: TPanel
    Left = 0
    Top = 370
    Width = 527
    Height = 130
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object lblPrecio: TLabel
      Tag = 13
      Left = 20
      Top = 12
      Width = 259
      Height = 15
      Caption = 'Precio inicial (opcional, se puede cargar despu'#233's)'
    end
    object lblNotaVigencia: TLabel
      Left = 20
      Top = 105
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
      Top = 55
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
    end
    object edPrecio: TrDBEdit
      Left = 200
      Top = 55
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
      Top = 55
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
      DBEditLabel.Visible = False
    end
    object chkProgramado: TCheckBox
      Left = 484
      Top = 33
      Width = 16
      Height = 17
      TabOrder = 3
    end
    object edVigencia: TrDBEditDate
      AlignWithMargins = True
      Left = 379
      Top = 55
      Width = 121
      Height = 23
      DataField = 'FECHA_VIGENCIA'
      DataSource = dmMemoria.dsPrecioCatalogo
      Enabled = False
      TabOrder = 4
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Rige desde'
      DateValue = 46291.000000000000000000
    end
  end
  object cpCatalogo: TCardPanel
    Left = 0
    Top = 87
    Width = 527
    Height = 283
    Align = alClient
    ActiveCard = CarManoObra
    BevelOuter = bvNone
    Caption = 'cpCatalogo'
    TabOrder = 2
    object CarMaterial: TCard
      Left = 0
      Top = 0
      Width = 527
      Height = 283
      Caption = 'Material'
      CardIndex = 0
      TabOrder = 0
      object edCodigoMat: TrDBEdit
        Left = 20
        Top = 25
        Width = 200
        Height = 23
        DataField = 'CODIGO'
        DataSource = dmMemoria.dsItemCatalogo
        TabOrder = 0
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'C'#243'digo'
        DBEditLabel.ShowRequiredBold = True
      end
      object cbUnidadMat: TrDBLookupComboBox
        Left = 240
        Top = 25
        Width = 180
        Height = 23
        DataField = 'UNIDAD_MEDIDA'
        DataSource = dmMemoria.dsItemCatalogo
        DropDownRows = 10
        KeyField = 'NOMBRE'
        ListField = 'NOMBRE'
        ListSource = dmMemoria.dsUnidadesMedida
        TabOrder = 1
        ReadOnlyColor = 15987699
        DBEditLabel.OwnCaption = 'Unidad de medida'
        DBEditLabel.ShowRequiredBold = True
        BoundLabel.Position = lpTopRight
        EmptyDisplayValue = 'Sin especificar'
      end
      object edNombreMat: TrDBEdit
        Left = 20
        Top = 88
        Width = 480
        Height = 23
        DataField = 'NOMBRE'
        DataSource = dmMemoria.dsItemCatalogo
        TabOrder = 2
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Nombre'
        DBEditLabel.ShowRequiredBold = True
      end
      object meDescripcionMat: TrDBMemo
        Left = 20
        Top = 148
        Width = 480
        Height = 110
        DataField = 'DESCRIPCION'
        DataSource = dmMemoria.dsItemCatalogo
        PopupMenu = meDescripcionMat.pmSearch
        ScrollBars = ssVertical
        TabOrder = 3
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Descripci'#243'n (opcional)'
      end
    end
    object CarManoObra: TCard
      Left = 0
      Top = 0
      Width = 527
      Height = 283
      Caption = 'Mano de obra'
      CardIndex = 1
      TabOrder = 1
      object lblCategoriaMo: TLabel
        Tag = 13
        Left = 20
        Top = 132
        Width = 51
        Height = 15
        Caption = 'Categor'#237'a'
      end
      object edCodigoMo: TrDBEdit
        Left = 20
        Top = 25
        Width = 200
        Height = 23
        DataField = 'CODIGO'
        DataSource = dmMemoria.dsItemCatalogo
        TabOrder = 0
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'C'#243'digo'
        DBEditLabel.ShowRequiredBold = True
      end
      object cbUnidadMo: TrDBLookupComboBox
        Left = 240
        Top = 25
        Width = 180
        Height = 23
        DataField = 'UNIDAD_MEDIDA'
        DataSource = dmMemoria.dsItemCatalogo
        DropDownRows = 10
        KeyField = 'NOMBRE'
        ListField = 'NOMBRE'
        ListSource = dmMemoria.dsUnidadesMedida
        TabOrder = 1
        ReadOnlyColor = 15987699
        DBEditLabel.OwnCaption = 'Unidad de medida'
        DBEditLabel.ShowRequiredBold = True
        BoundLabel.Position = lpTopRight
        EmptyDisplayValue = 'Sin especificar'
      end
      object edNombreMo: TrDBEdit
        Left = 20
        Top = 88
        Width = 480
        Height = 23
        DataField = 'NOMBRE'
        DataSource = dmMemoria.dsItemCatalogo
        TabOrder = 2
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Nombre'
        DBEditLabel.ShowRequiredBold = True
      end
      object cbCategoriaMo: TComboBox
        Left = 20
        Top = 152
        Width = 300
        Height = 23
        Style = csDropDownList
        TabOrder = 3
      end
      object meDescripcionMo: TrDBMemo
        Left = 20
        Top = 205
        Width = 480
        Height = 70
        DataField = 'DESCRIPCION'
        DataSource = dmMemoria.dsItemCatalogo
        PopupMenu = meDescripcionMo.pmSearch
        ScrollBars = ssVertical
        TabOrder = 4
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Descripci'#243'n (opcional)'
      end
    end
    object CarMaquina: TCard
      Left = 0
      Top = 0
      Width = 527
      Height = 283
      Caption = 'M'#225'quina'
      CardIndex = 2
      TabOrder = 2
      object edCodigoMaq: TrDBEdit
        Left = 20
        Top = 25
        Width = 200
        Height = 23
        DataField = 'CODIGO'
        DataSource = dmMemoria.dsItemCatalogo
        TabOrder = 0
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'C'#243'digo'
        DBEditLabel.ShowRequiredBold = True
      end
      object edNombreMaq: TrDBEdit
        Left = 20
        Top = 88
        Width = 480
        Height = 23
        DataField = 'NOMBRE'
        DataSource = dmMemoria.dsItemCatalogo
        TabOrder = 1
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Nombre'
        DBEditLabel.ShowRequiredBold = True
      end
      object meDescripcionMaq: TrDBMemo
        Left = 20
        Top = 148
        Width = 480
        Height = 110
        DataField = 'DESCRIPCION'
        DataSource = dmMemoria.dsItemCatalogo
        PopupMenu = meDescripcionMaq.pmSearch
        ScrollBars = ssVertical
        TabOrder = 2
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Descripci'#243'n (opcional)'
      end
    end
    object CarTipoTrabajo: TCard
      Left = 0
      Top = 0
      Width = 527
      Height = 283
      Caption = 'Tipo de trabajo'
      CardIndex = 3
      TabOrder = 3
      object edNombreTipo: TrDBEdit
        Left = 20
        Top = 25
        Width = 480
        Height = 23
        DataField = 'NOMBRE'
        DataSource = dmMemoria.dsItemCatalogo
        TabOrder = 0
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Nombre'
        DBEditLabel.ShowRequiredBold = True
      end
    end
  end
end
