inherited frmLineaCotizacion: TfrmLineaCotizacion
  Caption = 'L'#237'nea de la cotizaci'#243'n'
  ClientHeight = 600
  ClientWidth = 860
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 876
  ExplicitHeight = 639
  PixelsPerInch = 96
  TextHeight = 15
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 860
    ExplicitWidth = 860
  end
  inherited pnlTitulo: TPanel
    Width = 860
    ExplicitWidth = 860
    inherited lblTitulo: TLabel
      Caption = ''
    end
    inherited lblSubtitulo: TLabel
      Caption = ''
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 540
    Width = 860
    TabOrder = 4
    ExplicitTop = 540
    ExplicitWidth = 860
    inherited btnGuardar: TPlanoBotonWin
      Left = 720
      OnClick = btnGuardarClick
      ExplicitLeft = 720
    end
    inherited btnCancelar: TPlanoBotonWin
      Left = 594
      ExplicitLeft = 594
    end
  end
  object pnlBusqueda: TPanel
    Tag = 2
    Left = 0
    Top = 87
    Width = 860
    Height = 44
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object sbBuscar: TSearchBox
      Left = 20
      Top = 10
      Width = 560
      Height = 23
      BevelInner = bvNone
      BevelOuter = bvNone
      TabOrder = 0
      StyleElements = [seFont]
      OnInvokeSearch = sbBuscarInvokeSearch
    end
    object cbCategoria: TrDBLookupComboBox
      Left = 600
      Top = 10
      Width = 240
      Height = 23
      DropDownRows = 10
      KeyField = 'ID'
      ListField = 'NOMBRE'
      ListSource = dmMemoria.dsCategorias
      TabOrder = 1
      Visible = False
      OnClick = cbCategoriaClick
      ReadOnlyColor = clWindow
    end
  end
  object grItems: TrDBGrid
    AlignWithMargins = True
    Left = 20
    Top = 134
    Width = 820
    Height = 306
    Margins.Left = 20
    Margins.Right = 20
    Align = alClient
    BorderStyle = bsNone
    DataSource = dmMemoria.dsItemsLinea
    DefaultDrawing = False
    Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = 1973276
    TitleFont.Height = -13
    TitleFont.Name = 'Segoe UI Semibold'
    TitleFont.Style = [fsBold]
    StyleElements = [seFont]
    OnCellClick = grItemsCellClick
    OnKeyUp = grItemsKeyUp
  end
  object pnlCantidad: TPanel
    Tag = 2
    Left = 0
    Top = 443
    Width = 860
    Height = 97
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object lblPrecioRot: TLabel
      Tag = 13
      Left = 210
      Top = 8
      Width = 4
      Height = 15
      Caption = 'Precio unitario'
    end
    object lblPrecio: TLabel
      Tag = 25
      Left = 210
      Top = 30
      Width = 4
      Height = 15
    end
    object lblSubtotalRot: TLabel
      Tag = 13
      Left = 400
      Top = 8
      Width = 4
      Height = 15
      Caption = 'Subtotal'
    end
    object lblSubtotal: TLabel
      Tag = 25
      Left = 400
      Top = 30
      Width = 4
      Height = 15
    end
    object lblNota: TLabel
      Tag = 13
      Left = 20
      Top = 64
      Width = 820
      Height = 30
      AutoSize = False
      WordWrap = True
    end
    object edCantidad: TrDBEdit
      Left = 20
      Top = 26
      Width = 160
      Height = 23
      DataField = 'CANTIDAD'
      DataSource = dmMemoria.dsLineaNueva
      TabOrder = 0
      StyleElements = []
      OnChange = edCantidadChange
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Cantidad'
      DBEditLabel.ShowRequiredBold = True
    end
  end
  object pnlNota: TPanel
    Tag = 2
    Left = 0
    Top = 131
    Width = 860
    Height = 30
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object mmNota: TrDBMemo
      AlignWithMargins = True
      Left = 20
      Top = 26
      Width = 820
      Height = 1
      Margins.Left = 20
      Margins.Top = 26
      Margins.Right = 20
      Margins.Bottom = 12
      Align = alClient
      DataField = 'NOTA'
      DataSource = dmMemoria.dsLineaNueva
      ScrollBars = ssVertical
      TabOrder = 0
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Texto de la nota'
      DBEditLabel.ShowRequiredBold = True
    end
  end
end
