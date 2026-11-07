inherited frmSolicitudNueva: TfrmSolicitudNueva
  Caption = 'Nueva solicitud'
  ClientHeight = 620
  ClientWidth = 700
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 700
    CustomButtons = <
      item
        ButtonType = sbCustom
        Enabled = True
        Width = 32
        Visible = True
      end>
  end
  inherited pnlTitulo: TPanel
    Width = 700
    inherited lblTitulo: TLabel
      Caption = 'Nueva solicitud'
    end
    inherited lblSubtitulo: TLabel
      Top = 40
      Caption = 'Registro en la oficina: la pieza, sus medidas y los planos del cliente'
    end
  end
  inherited pnlPie: TRelativePanel
    TabOrder = 3
    inherited btnGuardar: TPlanoBotonWin
      OnClick = btnGuardarClick
    end
  end
  object pstSecciones: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 90
    Width = 694
    Height = 40
    Items.Strings = (
      'Solicitud'
      'Pieza y medidas'
      'Planos')
    CardPanel = cpSolicitud
    Indent = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ActiveFont.Charset = DEFAULT_CHARSET
    ActiveFont.Color = clWindowText
    ActiveFont.Height = -12
    ActiveFont.Name = 'Segoe UI Semibold'
    ActiveFont.Style = []
    ParentFont = False
  end
  object cpSolicitud: TCardPanel
    Tag = 2
    Left = 0
    Top = 133
    Width = 700
    Height = 427
    Align = alClient
    ActiveCard = crdSolicitud
    BevelOuter = bvNone
    Caption = 'cpSolicitud'
    TabOrder = 2
    object crdSolicitud: TCard
      Tag = 2
      Left = 0
      Top = 0
      Width = 700
      Height = 427
      Caption = 'Solicitud'
      CardIndex = 0
      TabOrder = 0
      object cbContacto: TrDBLookupComboBox
        Left = 20
        Top = 26
        Width = 660
        Height = 23
        DataField = 'CLIENTE_CONTACTO_ID'
        DataSource = dmMemoria.dsSolicitudNueva
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        KeyField = 'ID'
        ListField = 'NOMBRE'
        ListSource = dmMemoria.dsContactosSolicitud
        TabOrder = 0
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Contacto'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
        EmptyDisplayValue = 'Elija el contacto'
        AllowLookupFilter = True
        AutoDropDown = True
      end
      object edProyecto: TrDBEdit
        Left = 20
        Top = 76
        Width = 660
        Height = 23
        DataField = 'NOMBRE_PROYECTO'
        DataSource = dmMemoria.dsSolicitudNueva
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Nombre del proyecto'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object meDescripcion: TrDBMemo
        Left = 20
        Top = 126
        Width = 660
        Height = 160
        BevelInner = bvNone
        BevelOuter = bvNone
        DataField = 'DESCRIPCION'
        DataSource = dmMemoria.dsSolicitudNueva
        ScrollBars = ssVertical
        TabOrder = 2
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Descripci'#243'n del trabajo'
      end
      object meObservaciones: TrDBMemo
        Left = 20
        Top = 316
        Width = 660
        Height = 80
        BevelInner = bvNone
        BevelOuter = bvNone
        DataField = 'OBSERVACIONES'
        DataSource = dmMemoria.dsSolicitudNueva
        ScrollBars = ssVertical
        TabOrder = 3
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Observaciones'
      end
    end
    object crdPieza: TCard
      Tag = 2
      Left = 0
      Top = 0
      Width = 700
      Height = 427
      Caption = 'Pieza y medidas'
      CardIndex = 1
      TabOrder = 1
      object edPieza: TrDBEdit
        Left = 20
        Top = 26
        Width = 660
        Height = 23
        DataField = 'NOMBRE'
        DataSource = dmMemoria.dsPiezaOficina
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Nombre de la pieza'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object cbTrabajo: TrDBLookupComboBox
        Left = 20
        Top = 76
        Width = 210
        Height = 23
        DataField = 'TIPO_TRABAJO_ID'
        DataSource = dmMemoria.dsPiezaOficina
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        KeyField = 'ID'
        ListField = 'NOMBRE'
        ListSource = dmMemoria.dsTiposTrabajoOficina
        TabOrder = 1
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Tipo de trabajo'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
        EmptyDisplayValue = 'Elija'
        AllowLookupFilter = True
        AutoDropDown = True
      end
      object cbMaterial: TrDBLookupComboBox
        Left = 245
        Top = 76
        Width = 210
        Height = 23
        DataField = 'TIPO_MATERIAL_ID'
        DataSource = dmMemoria.dsPiezaOficina
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        KeyField = 'ID'
        ListField = 'NOMBRE'
        ListSource = dmMemoria.dsMaterialesOficina
        TabOrder = 2
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Material'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
        EmptyDisplayValue = 'Elija'
        AllowLookupFilter = True
        AutoDropDown = True
      end
      object cbAcabado: TrDBLookupComboBox
        Left = 470
        Top = 76
        Width = 210
        Height = 23
        DataField = 'ACABADO_ID'
        DataSource = dmMemoria.dsPiezaOficina
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        KeyField = 'ID'
        ListField = 'NOMBRE'
        ListSource = dmMemoria.dsAcabadosOficina
        TabOrder = 3
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Acabado'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
        EmptyDisplayValue = 'Elija'
        AllowLookupFilter = True
        AutoDropDown = True
      end
      object cbTipoMedida: TrDBLookupComboBox
        Left = 20
        Top = 130
        Width = 130
        Height = 23
        DataField = 'TIPO_MEDIDA'
        DataSource = dmMemoria.dsMedidaOficina
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        KeyField = 'CODIGO'
        ListField = 'NOMBRE'
        ListSource = dmMemoria.dsTiposMedidaOficina
        TabOrder = 4
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Medida'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
        EmptyDisplayValue = 'Elija'
        AllowLookupFilter = True
        AutoDropDown = True
      end
      object edValor: TrDBEdit
        Left = 160
        Top = 130
        Width = 80
        Height = 23
        DataField = 'VALOR'
        DataSource = dmMemoria.dsMedidaOficina
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Valor'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object cbUnidad: TrDBLookupComboBox
        Left = 250
        Top = 130
        Width = 110
        Height = 23
        DataField = 'UNIDAD_MEDIDA'
        DataSource = dmMemoria.dsMedidaOficina
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        KeyField = 'ABREVIATURA'
        ListField = 'NOMBRE'
        ListSource = dmMemoria.dsUnidadesOficina
        TabOrder = 6
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Unidad'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
        EmptyDisplayValue = 'Elija'
        AllowLookupFilter = True
        AutoDropDown = True
      end
      object edCantidad: TrDBEdit
        Left = 370
        Top = 130
        Width = 70
        Height = 23
        DataField = 'CANTIDAD'
        DataSource = dmMemoria.dsMedidaOficina
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Cantidad'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object edObservacion: TrDBEdit
        Left = 450
        Top = 130
        Width = 150
        Height = 23
        DataField = 'OBSERVACION'
        DataSource = dmMemoria.dsMedidaOficina
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Observaci'#243'n'
        DBEditLabel.Font.Charset = ANSI_CHARSET
        DBEditLabel.Font.Color = clWindowText
        DBEditLabel.Font.Height = -12
        DBEditLabel.Font.Name = 'Segoe UI'
        DBEditLabel.Font.Style = []
        DBEditLabel.ParentFont = False
      end
      object btnAgregarMedida: TPlanoBotonWin
        Left = 610
        Top = 128
        Width = 70
        Height = 28
        Cursor = crHandPoint
        Caption = 'Agregar'
        TabOrder = 9
        StyleElements = []
        OnClick = btnAgregarMedidaClick
      end
      object grMedidas: TrDBGrid
        Left = 20
        Top = 170
        Width = 580
        Height = 240
        BorderStyle = bsNone
        DataSource = dmMemoria.dsMedidasOficina
        DefaultDrawing = False
        Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        ReadOnly = True
        TabOrder = 10
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        StyleElements = [seFont]
        Columns = <
          item
            Expanded = False
            FieldName = 'TIPO_NOMBRE'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VALOR'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UNIDAD_MEDIDA'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CANTIDAD'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'OBSERVACION'
            Visible = True
          end>
      end
      object btnQuitarMedida: TPlanoBotonWin
        Left = 610
        Top = 170
        Width = 70
        Height = 28
        Cursor = crHandPoint
        Caption = 'Quitar'
        TabOrder = 11
        StyleElements = []
        OnClick = btnQuitarMedidaClick
        Kind = fkSecondary
      end
    end
    object crdPlanos: TCard
      Tag = 2
      Left = 0
      Top = 0
      Width = 700
      Height = 427
      Caption = 'Planos'
      CardIndex = 2
      TabOrder = 2
      object lblPlanos: TLabel
        Tag = 13
        Left = 20
        Top = 16
        Width = 660
        Height = 15
        AutoSize = False
        Caption = 'Im'#225'genes JPG o PNG del plano que mand'#243' el cliente: hasta 3 MB cada una y 20 en total.'
      end
      object btnAdjuntar: TPlanoBotonWin
        Left = 20
        Top = 44
        Width = 150
        Height = 28
        Cursor = crHandPoint
        Caption = '+ Adjuntar planos'
        TabOrder = 0
        StyleElements = []
        OnClick = btnAdjuntarClick
      end
      object btnQuitarPlano: TPlanoBotonWin
        Left = 180
        Top = 44
        Width = 90
        Height = 28
        Cursor = crHandPoint
        Caption = 'Quitar'
        TabOrder = 1
        StyleElements = []
        OnClick = btnQuitarPlanoClick
        Kind = fkSecondary
      end
      object grPlanos: TrDBGrid
        Left = 20
        Top = 86
        Width = 660
        Height = 320
        BorderStyle = bsNone
        DataSource = dmMemoria.dsPlanosOficina
        DefaultDrawing = False
        Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        ReadOnly = True
        TabOrder = 2
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        StyleElements = [seFont]
        Columns = <
          item
            Expanded = False
            FieldName = 'NOMBRE'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TAMANO_KB'
            Visible = True
          end>
      end
    end
  end
  object odPlanos: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Left = 620
    Top = 24
  end
end
