inherited frmLineaCotizacion: TfrmLineaCotizacion
  Caption = 'L'#237'nea de la cotizaci'#243'n'
  ClientHeight = 600
  ClientWidth = 860
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 866
  ExplicitHeight = 629
  PixelsPerInch = 96
  TextHeight = 15
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 860
  end
  inherited pnlTitulo: TPanel
    Width = 860
    TabOrder = 5
    ExplicitWidth = 860
    inherited lblTitulo: TLabel
      Width = 3
      Caption = ''
      ExplicitWidth = 3
    end
    inherited lblSubtitulo: TLabel
      Width = 3
      Caption = ''
      ExplicitWidth = 3
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
    end
    object cbCategoria: TrDBLookupComboBox
      Left = 600
      Top = 10
      Width = 240
      Height = 23
      DataField = ''
      DropDownRows = 10
      KeyField = 'ID'
      ListField = 'NOMBRE'
      ListSource = dmMemoria.dsCategorias
      TabOrder = 1
      Visible = False
      OnClick = cbCategoriaClick
      ReadOnlyColor = clWindow
      DBEditLabel.Visible = False
      BoundLabel.Visible = False
      BoundLabel.Position = lpTopRight
    end
  end
  object grItems: TrDBGrid
    AlignWithMargins = True
    Left = 20
    Top = 134
    Width = 820
    Height = 283
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
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    StyleElements = [seFont]
    OnCellClick = grItemsCellClick
    OnKeyUp = grItemsKeyUp
    Columns = <
      item
        Expanded = False
        FieldName = 'CODIGO'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOMBRE'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CATEGORIA'
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'UNIDAD_MEDIDA'
        Width = 90
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PRECIO'
        Title.Alignment = taRightJustify
        Width = 100
        Visible = True
      end
      item
        ButtonStyle = cbsEllipsis
        Expanded = False
        FieldName = 'PROGRAMADO_FECHA'
        Width = 90
        Visible = True
      end>
  end
  object pnlCantidad: TPanel
    Tag = 2
    Left = 0
    Top = 420
    Width = 860
    Height = 120
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 443
    object lblPrecioRot: TLabel
      Tag = 13
      Left = 470
      Top = 8
      Width = 77
      Height = 15
      Caption = 'Precio unitario'
    end
    object lblPrecio: TLabel
      Tag = 25
      Left = 470
      Top = 30
      Width = 3
      Height = 15
    end
    object lblSubtotalRot: TLabel
      Tag = 13
      Left = 600
      Top = 8
      Width = 44
      Height = 15
      Caption = 'Subtotal'
    end
    object lblSubtotal: TLabel
      Tag = 25
      Left = 600
      Top = 30
      Width = 3
      Height = 15
    end
    object lblNota: TLabel
      Tag = 13
      Left = 20
      Top = 84
      Width = 820
      Height = 30
      AutoSize = False
      WordWrap = True
    end
    object lblAgregada: TLabel
      Tag = 13
      Left = 20
      Top = 60
      Width = 820
      Height = 18
      AutoSize = False
    end
    object edCantidad: TrDBEdit
      Left = 340
      Top = 26
      Width = 110
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
    object edSeleccion: TrDBEdit
      Left = 20
      Top = 26
      Width = 300
      Height = 23
      TabStop = False
      DataField = 'NOMBRE'
      DataSource = dmMemoria.dsItemsLinea
      ReadOnly = True
      TabOrder = 1
      StyleElements = []
      ReadOnlyColor = 15987699
      DBEditLabel.AlignWithMargins = True
      DBEditLabel.Margins.Top = 5
      DBEditLabel.OwnCaption = 'Seleccionado'
    end
    object btnAgregar: TPlanoBotonWin
      Left = 720
      Top = 22
      Width = 120
      Height = 30
      Cursor = crHandPoint
      Caption = 'Agregar l'#237'nea'
      TabOrder = 2
      StyleElements = []
      OnClick = btnAgregarClick
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
      PopupMenu = mmNota.pmSearch
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
