inherited frmConsentimiento: TfrmConsentimiento
  Caption = 'Texto del consentimiento'
  ClientHeight = 640
  ClientWidth = 760
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 766
  ExplicitHeight = 669
  PixelsPerInch = 96
  TextHeight = 15
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 760
  end
  inherited pnlTitulo: TPanel
    Width = 760
    ExplicitWidth = 760
    inherited lblTitulo: TLabel
      Caption = 'Texto del consentimiento'
    end
    inherited lblSubtitulo: TLabel
      Top = 40
      Caption = 'Lo que lee y firma el cliente en el m'#243'vil (Ley 8968)'
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 580
    Width = 760
    TabOrder = 2
    ExplicitTop = 580
    ExplicitWidth = 760
    inherited btnGuardar: TPlanoBotonWin
      Left = 620
      OnClick = btnGuardarClick
      ExplicitLeft = 620
    end
    inherited btnCancelar: TPlanoBotonWin
      Left = 494
      ExplicitLeft = 494
    end
  end
  object pstSecciones: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 90
    Width = 754
    Height = 40
    Items.Strings = (
      'Versiones'
      'Nueva versi'#243'n')
    CardPanel = cpSecciones
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
    OnChange = pstSeccionesChange
  end
  object cpSecciones: TCardPanel
    Left = 0
    Top = 133
    Width = 760
    Height = 447
    Align = alClient
    ActiveCard = crdVersiones
    BevelOuter = bvNone
    Caption = 'cpSecciones'
    TabOrder = 1
    object crdVersiones: TCard
      Left = 0
      Top = 0
      Width = 760
      Height = 447
      Caption = 'Versiones'
      CardIndex = 0
      TabOrder = 0
      object lblSinVersiones: TLabel
        Tag = 13
        Left = 0
        Top = 0
        Width = 760
        Height = 447
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Layout = tlCenter
        Visible = False
      end
      object grVersiones: TrDBGrid
        AlignWithMargins = True
        Left = 20
        Top = 8
        Width = 720
        Height = 150
        Margins.Left = 20
        Margins.Top = 8
        Margins.Right = 20
        Align = alTop
        BorderStyle = bsNone
        DataSource = dmMemoria.dsTextosConsentimiento
        DefaultDrawing = False
        Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        StyleElements = [seFont]
      end
      object meVersion: TrDBMemo
        AlignWithMargins = True
        Left = 20
        Top = 190
        Width = 720
        Height = 249
        Margins.Left = 20
        Margins.Top = 28
        Margins.Right = 20
        Margins.Bottom = 8
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        DataField = 'CONTENIDO'
        DataSource = dmMemoria.dsTextosConsentimiento
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Texto de la versi'#243'n escogida'
      end
    end
    object crdNueva: TCard
      Left = 0
      Top = 0
      Width = 760
      Height = 447
      Caption = 'Nueva versi'#243'n'
      CardIndex = 1
      TabOrder = 1
      object lblNotaNueva: TLabel
        Tag = 13
        Left = 20
        Top = 10
        Width = 720
        Height = 34
        AutoSize = False
        WordWrap = True
      end
      object edVersion: TrDBEdit
        Left = 20
        Top = 72
        Width = 120
        Height = 23
        DataField = 'VERSION'
        DataSource = dmMemoria.dsConsentimientoNuevo
        TabOrder = 0
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Versi'#243'n'
      end
      object edTituloTexto: TrDBEdit
        Left = 160
        Top = 72
        Width = 580
        Height = 23
        DataField = 'TITULO'
        DataSource = dmMemoria.dsConsentimientoNuevo
        TabOrder = 1
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'T'#237'tulo'
      end
      object meContenido: TrDBMemo
        Left = 20
        Top = 128
        Width = 720
        Height = 305
        BevelInner = bvNone
        BevelOuter = bvNone
        DataField = 'CONTENIDO'
        DataSource = dmMemoria.dsConsentimientoNuevo
        ScrollBars = ssVertical
        TabOrder = 2
        StyleElements = []
        ReadOnlyColor = 15987699
        DBEditLabel.AlignWithMargins = True
        DBEditLabel.Margins.Top = 5
        DBEditLabel.OwnCaption = 'Texto que leer'#225' y firmar'#225' el cliente'
      end
    end
  end
end
