inherited frmRevision: TfrmRevision
  Caption = 'Revisar cotizaci'#243'n'
  ClientHeight = 620
  ClientWidth = 860
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 860
  end
  inherited pnlTitulo: TPanel
    Width = 860
  end
  inherited pnlPie: TRelativePanel
    Top = 560
    Width = 860
    ControlCollection = <
      item
        Control = btnGuardar
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = True
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
      end
      item
        Control = btnCancelar
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
        LeftOf = btnGuardar
      end
      item
        Control = btnDevolver
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
        LeftOf = btnCancelar
      end>
    TabOrder = 4
    inherited btnGuardar: TPlanoBotonWin
      Tag = 18
      Left = 690
      Width = 150
      Caption = 'Dar visto bueno'
      OnClick = btnGuardarClick
    end
    inherited btnCancelar: TPlanoBotonWin
      Left = 594
      Caption = 'Cerrar'
    end
    object btnDevolver: TPlanoBotonWin
      AlignWithMargins = True
      Left = 468
      Top = 14
      Width = 120
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Devolver'
      TabOrder = 2
      StyleElements = []
      OnClick = btnDevolverClick
      Kind = fkSecondary
    end
  end
  object pnlTotales: TPanel
    Tag = 2
    Left = 0
    Top = 398
    Width = 860
    Height = 162
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object pnlTrabajo: TPanel
      Tag = 2
      Left = 0
      Top = 0
      Width = 460
      Height = 162
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblTrabajoRot: TLabel
        Tag = 12
        Left = 20
        Top = 8
        Width = 45
        Height = 15
        Caption = 'Trabajo'
      end
      object lblTrabajo: TLabel
        Left = 20
        Top = 28
        Width = 420
        Height = 38
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = ''
        WordWrap = True
      end
      object lblMotivoAjusteRot: TLabel
        Tag = 12
        Left = 20
        Top = 76
        Width = 100
        Height = 15
        Caption = 'Motivo del ajuste'
      end
      object lblMotivoAjuste: TLabel
        Left = 20
        Top = 96
        Width = 420
        Height = 38
        AutoSize = False
        Caption = ''
        WordWrap = True
      end
    end
    object lblMaterialesRot: TLabel
      Tag = 13
      Left = 480
      Top = 8
      Width = 200
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Materiales'
    end
    object lblMateriales: TLabel
      Left = 690
      Top = 8
      Width = 150
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = ''
    end
    object lblManoObraRot: TLabel
      Tag = 13
      Left = 480
      Top = 28
      Width = 200
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Mano de obra'
    end
    object lblManoObra: TLabel
      Left = 690
      Top = 28
      Width = 150
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = ''
    end
    object lblMaquinaRot: TLabel
      Tag = 13
      Left = 480
      Top = 48
      Width = 200
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'M'#225'quina'
    end
    object lblMaquina: TLabel
      Left = 690
      Top = 48
      Width = 150
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = ''
    end
    object lblCostoRot: TLabel
      Tag = 13
      Left = 480
      Top = 68
      Width = 200
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Costo'
    end
    object lblCosto: TLabel
      Left = 690
      Top = 68
      Width = 150
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = ''
    end
    object lblAjusteRot: TLabel
      Tag = 13
      Left = 480
      Top = 88
      Width = 200
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Ajuste'
    end
    object lblAjuste: TLabel
      Left = 690
      Top = 88
      Width = 150
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = ''
    end
    object lblIvaRot: TLabel
      Tag = 13
      Left = 480
      Top = 108
      Width = 200
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'IVA'
    end
    object lblIva: TLabel
      Left = 690
      Top = 108
      Width = 150
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = ''
    end
    object lblTotalRot: TLabel
      Tag = 12
      Left = 480
      Top = 134
      Width = 200
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = 'Total'
    end
    object lblTotal: TLabel
      Tag = 12
      Left = 690
      Top = 134
      Width = 150
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = ''
    end
  end
  object grLineas: TrDBGrid
    AlignWithMargins = True
    Left = 20
    Top = 167
    Width = 820
    Height = 223
    Margins.Left = 20
    Margins.Top = 8
    Margins.Right = 20
    Margins.Bottom = 8
    Align = alClient
    BorderStyle = bsNone
    DataSource = dmMemoria.dsRevisionLineas
    DefaultDrawing = False
    Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = 1973276
    TitleFont.Height = -15
    TitleFont.Name = 'Segoe UI Semibold'
    TitleFont.Style = [fsBold]
    StyleElements = [seFont]
    Columns = <
        item
          Expanded = False
          FieldName = 'TIPO'
          Title.Caption = 'Tipo'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRIPCION'
          Title.Caption = 'Descripci'#243'n'
          Width = 300
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UNIDAD_MEDIDA'
          Title.Caption = 'Unidad'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CANTIDAD'
          Title.Alignment = taRightJustify
          Title.Caption = 'Cantidad'
          Width = 80
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
          FieldName = 'SUBTOTAL'
          Title.Alignment = taRightJustify
          Title.Caption = 'Subtotal'
          Width = 110
          Visible = True
        end>
  end
end
