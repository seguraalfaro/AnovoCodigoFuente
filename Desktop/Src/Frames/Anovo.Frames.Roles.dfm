object fraRoles: TfraRoles
  AlignWithMargins = True
  Left = 0
  Top = 0
  Width = 960
  Height = 620
  Color = 16447477
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentBackground = False
  ParentColor = False
  ParentFont = False
  TabOrder = 0
  object pnlTitulo: TPanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 954
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 10
      Width = 154
      Height = 30
      Caption = 'Roles y permisos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblSubtitulo: TLabel
      Tag = 13
      Left = 20
      Top = 40
      Width = 741
      Height = 15
      Caption = 
        'Paquete b'#225'sico de cada rol '#183' un cambio rige para todas sus perso' +
        'nas en su siguiente acci'#243'n; los adicionales se dan en la ficha d' +
        'e cada usuario'
    end
  end
  object pnlBarra: TPanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 71
    Width = 954
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      954
      52)
    object pnlRoles: TPanel
      Tag = 1
      Left = 20
      Top = 13
      Width = 620
      Height = 26
      BevelOuter = bvNone
      ParentBackground = True
      ParentColor = True
      TabOrder = 2
      object pstRolAsesor: TPlanoPastilla
        AlignWithMargins = True
        Left = 0
        Top = 2
        Width = 100
        Height = 22
        Margins.Left = 0
        Margins.Top = 2
        Margins.Right = 6
        Margins.Bottom = 2
        Align = alLeft
        Status = fsInfo
        Caption = ''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
      object pstRolAsistente: TPlanoPastilla
        AlignWithMargins = True
        Left = 106
        Top = 2
        Width = 100
        Height = 22
        Margins.Left = 0
        Margins.Top = 2
        Margins.Right = 6
        Margins.Bottom = 2
        Align = alLeft
        Status = fsSuccess
        Caption = ''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
      object pstRolSupervisor: TPlanoPastilla
        AlignWithMargins = True
        Left = 212
        Top = 2
        Width = 100
        Height = 22
        Margins.Left = 0
        Margins.Top = 2
        Margins.Right = 6
        Margins.Bottom = 2
        Align = alLeft
        Status = fsPending
        Caption = ''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
      object pstRolGerencia: TPlanoPastilla
        AlignWithMargins = True
        Left = 318
        Top = 2
        Width = 100
        Height = 22
        Margins.Left = 0
        Margins.Top = 2
        Margins.Right = 6
        Margins.Bottom = 2
        Align = alLeft
        Status = fsNeutral
        Caption = ''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
      object pstRolAdmin: TPlanoPastilla
        AlignWithMargins = True
        Left = 424
        Top = 2
        Width = 100
        Height = 22
        Margins.Left = 0
        Margins.Top = 2
        Margins.Right = 6
        Margins.Bottom = 2
        Align = alLeft
        Status = fsDanger
        Caption = ''
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
    object btnDescartar: TPlanoBotonWin
      Left = 658
      Top = 12
      Width = 130
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Descartar cambios'
      TabOrder = 0
      StyleElements = []
      OnClick = btnDescartarClick
      Kind = fkSecondary
    end
    object btnGuardar: TPlanoBotonWin
      Left = 794
      Top = 12
      Width = 140
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Guardar cambios'
      TabOrder = 1
      StyleElements = []
      OnClick = btnGuardarClick
    end
  end
  object pnclient: TRelativePanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 438
    ControlCollection = <
      item
        Control = grMatriz
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = True
        AlignRightWithPanel = True
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end>
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object grMatriz: TrDBGrid
      AlignWithMargins = True
      Left = 20
      Top = 3
      Width = 914
      Height = 432
      Margins.Left = 20
      Margins.Right = 20
      Align = alClient
      BorderStyle = bsNone
      DataSource = dmMemoria.dsMatrizRoles
      DefaultDrawing = False
      Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      StyleElements = [seFont]
      OnCanEdit = grMatrizCanEdit
      OnBoolClick = grMatrizBoolClick
      OnGetCellParams = grMatrizGetCellParams
      Columns = <
        item
          Expanded = False
          FieldName = 'MODULO'
          Title.Caption = 'M'#243'dulo'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOMBRE'
          Title.Caption = 'Permiso'
          Width = 260
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ASESOR'
          Title.Caption = 'Asesor'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ASISTENTE'
          Title.Caption = 'Asistente'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SUPERVISOR'
          Title.Caption = 'Supervisor'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GERENCIA'
          Title.Caption = 'Gerencia'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ADMIN'
          Title.Caption = 'Administrador'
          Width = 150
          Visible = True
        end>
    end
  end
  object pnlPie: TPanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 573
    Width = 954
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    Color = 16447477
    ParentBackground = False
    TabOrder = 3
    object lblCambios: TLabel
      Tag = 13
      Left = 20
      Top = 14
      Width = 3
      Height = 15
    end
  end
end
