object frmImportacionCatalogo: TfrmImportacionCatalogo
  Left = 0
  Top = 0
  Caption = 'Importar'
  ClientHeight = 660
  ClientWidth = 1100
  Color = 16447477
  Constraints.MinHeight = 520
  Constraints.MinWidth = 900
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
  Position = poOwnerFormCenter
  StyleElements = [seBorder]
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object TitleBarPanel1: TTitleBarPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 25
    CustomButtons = <>
  end
  object pnlTitulo: TPanel
    Tag = 2
    Left = 0
    Top = 25
    Width = 1100
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 10
      Width = 31
      Height = 15
      Caption = 'Importar'
    end
    object lblSubtitulo: TLabel
      Tag = 13
      Left = 20
      Top = 37
      Width = 400
      Height = 15
      Caption =
        'Solo crea '#237'tems nuevos. Un c'#243'digo que ya existe en el cat'#225'logo n' +
        'o se importa.'
    end
  end
  object pnlArchivo: TPanel
    Tag = 2
    Left = 0
    Top = 87
    Width = 1100
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      1100
      60)
    object lblArchivo: TLabel
      Tag = 13
      Left = 20
      Top = 4
      Width = 120
      Height = 15
      Caption = 'Archivo (.xlsx o .csv)'
    end
    object lblHoja: TLabel
      Tag = 13
      Left = 830
      Top = 4
      Width = 26
      Height = 15
      Anchors = [akTop, akRight]
      Caption = 'Hoja'
    end
    object edArchivo: TEdit
      Left = 20
      Top = 24
      Width = 680
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 0
    end
    object btnAbrir: TPlanoBotonWin
      Left = 710
      Top = 21
      Width = 110
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Abrir archivo'
      TabOrder = 1
      StyleElements = []
      OnClick = btnAbrirClick
      Kind = fkSecondary
    end
    object cbHoja: TComboBox
      Left = 830
      Top = 24
      Width = 250
      Height = 23
      Style = csDropDownList
      Anchors = [akTop, akRight]
      Enabled = False
      TabOrder = 2
      OnChange = cbHojaChange
    end
  end
  object pnlPie: TPanel
    Tag = 2
    Left = 0
    Top = 600
    Width = 1100
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      1100
      60)
    object lblNota: TLabel
      Tag = 13
      Left = 20
      Top = 22
      Width = 400
      Height = 15
      Caption = 'Las filas con error no se env'#237'an. Nada existente se modifica.'
    end
    object btnCancelar: TPlanoBotonWin
      Left = 740
      Top = 14
      Width = 120
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Cancelar'
      TabOrder = 0
      StyleElements = []
      OnClick = btnCancelarClick
      Kind = fkSecondary
    end
    object btnAprobar: TPlanoBotonWin
      Left = 870
      Top = 14
      Width = 210
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Aprobar carga'
      Enabled = False
      TabOrder = 1
      StyleElements = []
      OnClick = btnAprobarClick
    end
  end
  object pnlCampos: TPanel
    Tag = 3
    AlignWithMargins = True
    Left = 840
    Top = 147
    Width = 240
    Height = 453
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 20
    Margins.Bottom = 0
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
    object lblCampos: TLabel
      Tag = 12
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 224
      Height = 15
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Align = alTop
      Caption = 'Columna del archivo para cada campo'
      WordWrap = True
    end
    object lblAyudaCampos: TLabel
      Tag = 13
      AlignWithMargins = True
      Left = 8
      Top = 405
      Width = 224
      Height = 40
      Margins.Left = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alBottom
      AutoSize = False
      Caption =
        'En negrita, los obligatorios. Si el nombre de la columna coincide' +
        ', se escoge solo.'
      WordWrap = True
    end
    object sbCampos: TScrollBox
      Tag = 3
      Left = 0
      Top = 26
      Width = 240
      Height = 373
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 0
    end
  end
  object pnlCentro: TPanel
    Tag = 2
    AlignWithMargins = True
    Left = 20
    Top = 147
    Width = 808
    Height = 453
    Margins.Left = 20
    Margins.Top = 0
    Margins.Right = 12
    Margins.Bottom = 0
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      808
      453)
    object pnlResumen: TPanel
      Tag = 2
      Left = 0
      Top = 0
      Width = 808
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        808
        32)
      object lblResumen: TLabel
        Tag = 13
        Left = 0
        Top = 8
        Width = 300
        Height = 15
        Caption = 'Abra un archivo para empezar.'
      end
      object chkSoloErrores: TCheckBox
        Left = 640
        Top = 7
        Width = 168
        Height = 17
        Anchors = [akTop, akRight]
        Caption = 'Solo filas con error'
        Enabled = False
        TabOrder = 0
        OnClick = chkSoloErroresClick
      end
    end
    object pnlAccionesFila: TPanel
      Tag = 2
      Left = 0
      Top = 409
      Width = 808
      Height = 44
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object btnQuitar: TPlanoBotonWin
        Left = 0
        Top = 8
        Width = 110
        Height = 28
        Cursor = crHandPoint
        Caption = 'Quitar fila'
        Enabled = False
        TabOrder = 0
        StyleElements = []
        OnClick = btnQuitarClick
        Kind = fkSecondary
      end
      object btnExportar: TPlanoBotonWin
        Left = 118
        Top = 8
        Width = 110
        Height = 28
        Cursor = crHandPoint
        Caption = 'Exportar'
        Enabled = False
        TabOrder = 1
        StyleElements = []
        OnClick = btnExportarClick
        Kind = fkSecondary
      end
    end
    object grFilas: TrDBGrid
      Left = 0
      Top = 32
      Width = 808
      Height = 377
      Align = alClient
      BorderStyle = bsNone
      DataSource = dmMemoria.dsImportacion
      DefaultDrawing = False
      Options = [dgEditing, dgTitles, dgColumnResize, dgRowLines, dgTabs, dgAlwaysShowSelection]
      TabOrder = 1
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = 1973276
      TitleFont.Height = -15
      TitleFont.Name = 'Segoe UI Semibold'
      TitleFont.Style = [fsBold]
      StyleElements = [seFont]
      OnCanEdit = grFilasCanEdit
    end
  end
end
