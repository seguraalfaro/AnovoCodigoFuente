object frmServidor: TfrmServidor
  Left = 0
  Top = 0
  Caption = 'Servidor Anovo'
  ClientHeight = 601
  ClientWidth = 904
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object pnlEncabezado: TPanel
    Left = 0
    Top = 0
    Width = 904
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    Padding.Left = 12
    Padding.Top = 8
    Padding.Right = 12
    TabOrder = 0
    DesignSize = (
      904
      97)
    object lblTitulo: TLabel
      Left = 16
      Top = 10
      Width = 119
      Height = 21
      Caption = 'Servidor Anovo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblEstado: TLabel
      Left = 16
      Top = 37
      Width = 52
      Height = 15
      Caption = 'Detenido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblBase: TLabel
      Left = 16
      Top = 57
      Width = 27
      Height = 15
      Caption = 'Base:'
    end
    object lblVersion: TLabel
      Left = 16
      Top = 76
      Width = 119
      Height = 15
      Caption = 'DelphiMVCFramework'
    end
    object btnIniciar: TButton
      Left = 686
      Top = 20
      Width = 95
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Iniciar'
      Default = True
      TabOrder = 0
      OnClick = btnIniciarClick
    end
    object btnDetener: TButton
      Left = 789
      Top = 20
      Width = 95
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Detener'
      Enabled = False
      TabOrder = 1
      OnClick = btnDetenerClick
    end
  end
  object pnlContadores: TPanel
    Left = 0
    Top = 97
    Width = 904
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      904
      41)
    object lblServidas: TLabel
      Left = 16
      Top = 12
      Width = 66
      Height = 15
      Caption = 'Peticiones: 0'
    end
    object lblErrores: TLabel
      Left = 152
      Top = 12
      Width = 48
      Height = 15
      Caption = 'Errores: 0'
    end
    object lblCache: TLabel
      Left = 264
      Top = 12
      Width = 105
      Height = 15
      Caption = 'Permisos: sin cargar'
    end
    object btnInvalidar: TButton
      Left = 719
      Top = 6
      Width = 165
      Height = 27
      Anchors = [akTop, akRight]
      Caption = 'Invalidar cach'#233' de permisos'
      TabOrder = 0
      OnClick = btnInvalidarClick
    end
  end
  object pgc: TPageControl
    Left = 0
    Top = 138
    Width = 904
    Height = 463
    ActivePage = tabRegistro
    Align = alClient
    TabOrder = 2
    object tabRegistro: TTabSheet
      Caption = 'Registro'
      object memRegistro: TMemo
        Left = 0
        Top = 0
        Width = 896
        Height = 433
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
    object tabActividad: TTabSheet
      Caption = 'Actividad'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lvActividad: TListView
        Left = 0
        Top = 0
        Width = 896
        Height = 433
        Align = alClient
        Columns = <
          item
            Caption = 'Hora'
            Width = 80
          end
          item
            Caption = 'Usuario'
            Width = 70
          end
          item
            Caption = 'Verbo'
            Width = 70
          end
          item
            Caption = 'Ruta'
            Width = 460
          end
          item
            Alignment = taRightJustify
            Caption = 'Estado'
            Width = 70
          end
          item
            Alignment = taRightJustify
            Caption = 'ms'
            Width = 70
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
    object tabErrores: TTabSheet
      Caption = 'Errores'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lvErrores: TListView
        Left = 0
        Top = 0
        Width = 896
        Height = 433
        Align = alClient
        Columns = <
          item
            Caption = 'Hora'
            Width = 80
          end
          item
            Caption = 'Usuario'
            Width = 70
          end
          item
            Caption = 'Verbo'
            Width = 70
          end
          item
            Caption = 'Ruta'
            Width = 460
          end
          item
            Alignment = taRightJustify
            Caption = 'Estado'
            Width = 70
          end
          item
            Alignment = taRightJustify
            Caption = 'ms'
            Width = 70
          end>
        GridLines = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object tmrRefresco: TTimer
    Enabled = False
    OnTimer = tmrRefrescoTimer
    Left = 552
    Top = 24
  end
  object tmrVigencias: TTimer
    Enabled = False
    Interval = 3600000
    OnTimer = tmrVigenciasTimer
    Left = 472
    Top = 24
  end
end
