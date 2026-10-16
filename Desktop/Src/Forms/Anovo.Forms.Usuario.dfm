inherited frmUsuario: TfrmUsuario
  Caption = 'Usuario'
  ClientHeight = 560
  ClientWidth = 640
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 646
  ExplicitHeight = 589
  PixelsPerInch = 96
  TextHeight = 15
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 640
  end
  inherited pnlTitulo: TPanel
    Width = 640
    ExplicitWidth = 640
    inherited lblTitulo: TLabel
      Left = 68
      Width = 40
      Caption = 'Usuario'
      ExplicitLeft = 68
      ExplicitWidth = 40
    end
    inherited lblSubtitulo: TLabel
      Left = 68
      Width = 3
      Caption = ''
      ExplicitLeft = 68
      ExplicitWidth = 3
    end
    object pnlAvatar: TPanel
      Tag = 1
      Left = 20
      Top = 13
      Width = 36
      Height = 36
      BevelOuter = bvNone
      Color = 9067566
      ParentBackground = False
      TabOrder = 0
      StyleElements = []
      object lblIniciales: TLabel
        Tag = 1
        Left = 0
        Top = 0
        Width = 36
        Height = 36
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        StyleElements = [seFont, seBorder]
      end
    end
    object pstEstado: TPlanoPastilla
      Left = 140
      Top = 12
      Width = 52
      Height = 22
      Status = fsSuccess
      Caption = 'Activo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 500
    Width = 640
    TabOrder = 3
    ExplicitTop = 500
    ExplicitWidth = 640
    inherited btnGuardar: TPlanoBotonWin
      Left = 500
      OnClick = btnGuardarClick
      ExplicitLeft = 500
    end
    inherited btnCancelar: TPlanoBotonWin
      Left = 374
      ExplicitLeft = 374
    end
  end
  object pstSecciones: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 90
    Width = 634
    Height = 40
    Items.Strings = (
      'Datos'
      'Tel'#233'fonos'
      'Permisos')
    CardPanel = cpUsuario
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
  object cpUsuario: TCardPanel
    Left = 0
    Top = 133
    Width = 640
    Height = 367
    Align = alClient
    ActiveCard = crdDatos
    BevelOuter = bvNone
    Caption = 'cpUsuario'
    TabOrder = 1
    object crdDatos: TCard
      Left = 0
      Top = 0
      Width = 640
      Height = 367
      Caption = 'Datos'
      CardIndex = 0
      TabOrder = 0
      object lblPaquete: TLabel
        Tag = 13
        Left = 330
        Top = 116
        Width = 290
        Height = 34
        AutoSize = False
        WordWrap = True
      end
      object lblAviso: TLabel
        Tag = 14
        Left = 20
        Top = 116
        Width = 290
        Height = 34
        AutoSize = False
        Caption = 'Al cambiar de rol se quitan sus permisos adicionales.'
        WordWrap = True
      end
      object lblFechas: TLabel
        Tag = 13
        Left = 20
        Top = 330
        Width = 600
        Height = 15
        AutoSize = False
      end
      object edNombre: TrDBEdit
        Left = 20
        Top = 25
        Width = 600
        Height = 23
        DataField = 'NOMBRE'
        DataSource = dmMemoria.dsUsuario
        TabOrder = 0
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Nombre completo'
        DBEditLabel.ShowRequiredBold = True
      end
      object edCorreo: TrDBEdit
        Left = 20
        Top = 88
        Width = 290
        Height = 23
        DataField = 'CORREO'
        DataSource = dmMemoria.dsUsuario
        TabOrder = 1
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Correo'
        DBEditLabel.ShowRequiredBold = True
      end
      object cbRol: TrDBLookupComboBox
        Left = 330
        Top = 88
        Width = 290
        Height = 23
        DataField = 'ROL_ID'
        DataSource = dmMemoria.dsUsuario
        DropDownRows = 6
        KeyField = 'ID'
        ListField = 'NOMBRE'
        ListSource = dmMemoria.dsRoles
        TabOrder = 2
        OnClick = cbRolClick
        ReadOnlyColor = 15987699
        DBEditLabel.OwnCaption = 'Rol'
        DBEditLabel.ShowRequiredBold = True
        BoundLabel.Position = lpTopRight
        EmptyDisplayValue = 'Sin especificar'
      end
      object tjClave: TPlanoTarjeta
        Tag = 3
        Left = 20
        Top = 156
        Width = 600
        Height = 164
        Caption = 'Clave de acceso'
        TabOrder = 3
        object lblClaveEstado: TLabel
          Tag = 13
          Left = 124
          Top = 52
          Width = 160
          Height = 15
          AutoSize = False
        end
        object lblClaveNota: TLabel
          Tag = 13
          Left = 16
          Top = 124
          Width = 568
          Height = 32
          AutoSize = False
          WordWrap = True
        end
        object pstClave: TPlanoPastilla
          Left = 16
          Top = 48
          Width = 59
          Height = 22
          Status = fsInfo
          Caption = 'Vigente'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = []
          ParentFont = False
        end
        object btnPedirCambio: TPlanoBotonWin
          Left = 290
          Top = 44
          Width = 160
          Height = 28
          Cursor = crHandPoint
          Caption = 'Pedir cambio al entrar'
          TabOrder = 0
          StyleElements = []
          OnClick = btnPedirCambioClick
          Kind = fkSecondary
        end
        object btnGenerar: TPlanoBotonWin
          Left = 460
          Top = 44
          Width = 124
          Height = 28
          Cursor = crHandPoint
          Caption = 'Generar clave'
          TabOrder = 1
          StyleElements = []
          OnClick = btnGenerarClick
          Kind = fkSecondary
        end
        object edClave: TrDBEdit
          Tag = 1
          Left = 16
          Top = 82
          Width = 436
          Height = 28
          DataField = 'CLAVE_TEMPORAL'
          DataSource = dmMemoria.dsUsuario
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 2
          StyleElements = []
          ReadOnlyColor = 15987699
          DBEditLabel.Visible = False
        end
        object btnCopiar: TPlanoBotonWin
          Left = 460
          Top = 84
          Width = 124
          Height = 28
          Cursor = crHandPoint
          Caption = 'Copiar'
          TabOrder = 3
          StyleElements = []
          OnClick = btnCopiarClick
          Kind = fkSecondary
        end
      end
    end
    object crdTelefonos: TCard
      Left = 0
      Top = 0
      Width = 640
      Height = 367
      Caption = 'Tel'#233'fonos'
      CardIndex = 1
      TabOrder = 1
      object lblTelefonosNota: TLabel
        Tag = 13
        AlignWithMargins = True
        Left = 20
        Top = 11
        Width = 600
        Height = 32
        Margins.Left = 20
        Margins.Top = 8
        Margins.Right = 20
        Align = alTop
        AutoSize = False
        WordWrap = True
      end
      object lblSinTelefonos: TLabel
        Tag = 13
        Left = 0
        Top = 46
        Width = 640
        Height = 321
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Layout = tlCenter
        Visible = False
      end
      object grTelefonos: TrDBGrid
        AlignWithMargins = True
        Left = 20
        Top = 49
        Width = 600
        Height = 310
        Margins.Left = 20
        Margins.Right = 20
        Margins.Bottom = 8
        Align = alClient
        BorderStyle = bsNone
        DataSource = dmMemoria.dsTelefonos
        DefaultDrawing = False
        Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        TabOrder = 0
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        StyleElements = [seFont]
        OnCanEdit = grTelefonosCanEdit
        OnBoolClick = grTelefonosBoolClick
      end
    end
    object crdPermisos: TCard
      Left = 0
      Top = 0
      Width = 640
      Height = 367
      Caption = 'Permisos'
      CardIndex = 2
      TabOrder = 2
      object lblResumen: TLabel
        Tag = 13
        AlignWithMargins = True
        Left = 20
        Top = 42
        Width = 600
        Height = 15
        Margins.Left = 20
        Margins.Top = 8
        Margins.Right = 20
        Align = alTop
        ExplicitWidth = 3
      end
      object lblSinPermisos: TLabel
        Tag = 13
        AlignWithMargins = True
        Left = 20
        Top = 63
        Width = 600
        Height = 296
        Margins.Left = 20
        Margins.Right = 20
        Margins.Bottom = 8
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Layout = tlCenter
        Visible = False
        WordWrap = True
        ExplicitTop = 60
        ExplicitHeight = 299
      end
      object pnlResumen: TPanel
        Tag = 1
        AlignWithMargins = True
        Left = 20
        Top = 8
        Width = 600
        Height = 26
        Margins.Left = 20
        Margins.Top = 8
        Margins.Right = 20
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object pstDelRol: TPlanoPastilla
          AlignWithMargins = True
          Left = 0
          Top = 2
          Width = 62
          Height = 22
          Margins.Left = 0
          Margins.Top = 2
          Margins.Right = 6
          Margins.Bottom = 2
          Status = fsInfo
          Align = alLeft
          Caption = '0 del rol'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = []
          ParentFont = False
        end
        object pstAdicionales: TPlanoPastilla
          AlignWithMargins = True
          Left = 86
          Top = 2
          Width = 86
          Height = 22
          Margins.Left = 0
          Margins.Top = 2
          Margins.Right = 6
          Margins.Bottom = 2
          Status = fsSuccess
          Align = alLeft
          Caption = '0 adicionales'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = []
          ParentFont = False
        end
        object pstQuitados: TPlanoPastilla
          AlignWithMargins = True
          Left = 172
          Top = 2
          Width = 74
          Height = 22
          Margins.Left = 0
          Margins.Top = 2
          Margins.Right = 6
          Margins.Bottom = 2
          Status = fsDanger
          Align = alLeft
          Caption = '0 quitados'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = []
          ParentFont = False
        end
        object pstSinGuardar: TPlanoPastilla
          AlignWithMargins = True
          Left = 258
          Top = 2
          Width = 86
          Height = 22
          Margins.Left = 0
          Margins.Top = 2
          Margins.Right = 6
          Margins.Bottom = 2
          Status = fsPending
          Align = alLeft
          Caption = '0 sin guardar'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI Semibold'
          Font.Style = []
          ParentFont = False
        end
        object chkSoloExcepciones: TCheckBox
          Left = 410
          Top = 0
          Width = 190
          Height = 26
          Align = alRight
          Caption = 'Solo adicionales y quitados'
          TabOrder = 0
          OnClick = chkSoloExcepcionesClick
        end
      end
      object grPermisos: TrDBGrid
        AlignWithMargins = True
        Left = 20
        Top = 63
        Width = 600
        Height = 296
        Margins.Left = 20
        Margins.Right = 20
        Margins.Bottom = 8
        Align = alClient
        BorderStyle = bsNone
        DataSource = dmMemoria.dsPermisosUsuario
        DefaultDrawing = False
        Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        TabOrder = 0
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        StyleElements = [seFont]
        OnCanEdit = grPermisosCanEdit
        OnBoolClick = grPermisosBoolClick
        OnGetCellParams = grPermisosGetCellParams
        Columns = <
          item
            Expanded = False
            FieldName = 'MODULO'
            Title.Caption = 'M'#243'dulo'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TIENE'
            Title.Caption = 'Tiene'
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOMBRE'
            Title.Caption = 'Permiso'
            Width = 190
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ORIGEN'
            Title.Caption = 'Origen'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'MOTIVO'
            Title.Caption = 'Motivo'
            Width = 150
            Visible = True
          end>
      end
    end
  end
end
