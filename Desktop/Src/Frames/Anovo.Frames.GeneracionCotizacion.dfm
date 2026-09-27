object fraGeneracionCotizacion: TfraGeneracionCotizacion
  Left = 0
  Top = 0
  Width = 980
  Height = 670
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 1973276
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object rpTop: TRelativePanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 629
    Width = 974
    Height = 38
    ControlCollection = <
      item
        Control = PlanoBotonWin1
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = True
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
      end
      item
        Control = PlanoBotonWin2
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
        LeftOf = PlanoBotonWin1
      end>
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      974
      38)
    object PlanoBotonWin1: TPlanoBotonWin
      AlignWithMargins = True
      Left = 808
      Top = 4
      Width = 146
      Height = 30
      Cursor = crHandPoint
      Margins.Right = 20
      Anchors = []
      Caption = 'Enviar a aprobaci'#243'n '
      TabOrder = 0
      StyleElements = []
      ColorOverride = 6044186
    end
    object PlanoBotonWin2: TPlanoBotonWin
      Left = 685
      Top = 4
      Width = 120
      Height = 30
      Cursor = crHandPoint
      Anchors = []
      Caption = 'Guardar borrador'
      TabOrder = 1
      StyleElements = []
      Kind = fkSecondary
    end
  end
  object tjCabecera: TPlanoTarjeta
    Tag = 3
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 974
    Height = 100
    Margins.Bottom = 8
    Caption = 'Datos de la cotizaci'#243'n'
    Align = alTop
    TabOrder = 1
    object lblCliente: TLabel
      Tag = 13
      Left = 16
      Top = 40
      Width = 33
      Height = 13
      Caption = 'Cliente'
    end
    object lblContacto: TLabel
      Tag = 13
      Left = 288
      Top = 40
      Width = 44
      Height = 13
      Caption = 'Contacto'
    end
    object lblTipo: TLabel
      Tag = 13
      Left = 500
      Top = 40
      Width = 73
      Height = 13
      Caption = 'Tipo de trabajo'
    end
    object lblFecha: TLabel
      Tag = 13
      Left = 692
      Top = 40
      Width = 29
      Height = 13
      Caption = 'Fecha'
    end
    object lblValidez: TLabel
      Tag = 13
      Left = 814
      Top = 40
      Width = 63
      Height = 13
      Caption = 'Validez (d'#237'as)'
    end
    object cboCliente: TComboBox
      Left = 16
      Top = 58
      Width = 260
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object cboContacto: TComboBox
      Left = 288
      Top = 58
      Width = 200
      Height = 21
      Style = csDropDownList
      TabOrder = 1
    end
    object cboTipo: TComboBox
      Left = 500
      Top = 58
      Width = 180
      Height = 21
      Style = csDropDownList
      TabOrder = 2
    end
    object dtpFecha: TDateTimePicker
      Left = 692
      Top = 58
      Width = 110
      Height = 23
      Date = 45900.000000000000000000
      Format = 'dd/MM/yyyy'
      Time = 45900.000000000000000000
      TabOrder = 3
    end
    object edtValidez: TEdit
      Left = 814
      Top = 58
      Width = 90
      Height = 21
      TabOrder = 4
      Text = '15'
    end
  end
  object Panel1: TPanel
    Tag = 2
    Left = 0
    Top = 111
    Width = 425
    Height = 515
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 2
    ExplicitLeft = -3
    ExplicitTop = 108
    object PlanoTarjeta1: TPlanoTarjeta
      Tag = 3
      AlignWithMargins = True
      Left = 3
      Top = 331
      Width = 419
      Height = 181
      Caption = 'Medidas tomadas en sitio  '
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = 1973276
      Font.Height = -14
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = []
      TabOrder = 0
      ExplicitTop = 3
      ExplicitWidth = 484
      ExplicitHeight = 158
    end
    object PlanoTarjeta2: TPlanoTarjeta
      Tag = 3
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 419
      Height = 158
      Caption = 'Croquis'
      Align = alTop
      Font.Charset = ANSI_CHARSET
      Font.Color = 1973276
      Font.Height = -14
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      ExplicitLeft = 6
      ExplicitTop = 11
      ExplicitWidth = 484
    end
    object PlanoTarjeta3: TPlanoTarjeta
      Tag = 3
      AlignWithMargins = True
      Left = 3
      Top = 167
      Width = 419
      Height = 158
      Caption = 'Fotograf'#237'as'
      Align = alTop
      Font.Charset = ANSI_CHARSET
      Font.Color = 1973276
      Font.Height = -14
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      ExplicitTop = 3
      ExplicitWidth = 484
    end
  end
  object PlanoTarjeta4: TPlanoTarjeta
    Tag = 3
    AlignWithMargins = True
    Left = 428
    Top = 114
    Width = 549
    Height = 509
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = 1973276
    Font.Height = -14
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    ExplicitLeft = 431
    ExplicitTop = 90
    object grLineas: TrDBGrid
      AlignWithMargins = True
      Left = 10
      Top = 51
      Width = 529
      Height = 346
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      BorderStyle = bsNone
      DefaultDrawing = False
      Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = 1973276
      TitleFont.Height = -14
      TitleFont.Name = 'Segoe UI Semibold'
      TitleFont.Style = [fsBold]
      StyleElements = [seFont]
      Columns = <
        item
          Expanded = False
          FieldName = 'CODIGO'
          Title.Caption = 'C'#243'digo'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRIPCION'
          Title.Caption = 'Descripci'#243'n'
          Width = 270
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UNIDAD'
          Title.Caption = 'Unidad'
          Width = 80
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'CANTIDAD'
          Title.Alignment = taRightJustify
          Title.Caption = 'Cantidad'
          Width = 80
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'PRECIO'
          Title.Alignment = taRightJustify
          Title.Caption = 'Precio'
          Width = 100
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'SUBTOTAL'
          Title.Alignment = taRightJustify
          Title.Caption = 'Subtotal'
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCIONES'
          Title.Caption = 'Acciones'
          Width = 160
          Visible = True
        end>
    end
    object RelativePanel1: TRelativePanel
      Left = 0
      Top = 0
      Width = 549
      Height = 41
      ControlCollection = <
        item
          Control = lblLineas
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = True
        end
        item
          Control = btnNota
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = True
        end
        item
          Control = btnAjuste
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = True
        end
        item
          Control = btnAgregar
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = True
        end>
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      DesignSize = (
        549
        41)
      object lblLineas: TLabel
        Tag = 12
        Left = 20
        Top = 11
        Width = 142
        Height = 19
        Anchors = []
        Caption = 'L'#237'neas de la cotizaci'#243'n'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
      object btnNota: TPlanoBotonWin
        Left = 239
        Top = 6
        Width = 100
        Height = 28
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = 'Nota'
        TabOrder = 0
        StyleElements = []
        Kind = fkSecondary
      end
      object btnAjuste: TPlanoBotonWin
        Left = 345
        Top = 6
        Width = 100
        Height = 28
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = 'Ajuste'
        TabOrder = 1
        StyleElements = []
        Kind = fkSecondary
      end
      object btnAgregar: TPlanoBotonWin
        Left = 451
        Top = 6
        Width = 86
        Height = 28
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = '+ '#205'tem'
        TabOrder = 2
        StyleElements = []
      end
    end
    object RelativePanel2: TRelativePanel
      AlignWithMargins = True
      Left = 3
      Top = 410
      Width = 543
      Height = 96
      ControlCollection = <
        item
          Control = lblSubtotalRot
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = lblAjusteRot
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = lblImpuestoRot
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = lblTotalRot
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = lblTotal
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = lblImpuesto
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = lblAjuste
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end
        item
          Control = lblSubtotal
          AlignBottomWithPanel = False
          AlignHorizontalCenterWithPanel = False
          AlignLeftWithPanel = False
          AlignRightWithPanel = False
          AlignTopWithPanel = False
          AlignVerticalCenterWithPanel = False
        end>
      Align = alBottom
      Color = clActiveCaption
      ParentBackground = False
      TabOrder = 2
      ExplicitLeft = 0
      ExplicitTop = 468
      ExplicitWidth = 549
      DesignSize = (
        543
        96)
      object lblSubtotalRot: TLabel
        Tag = 13
        Left = 334
        Top = 10
        Width = 69
        Height = 15
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = 'Subtotal'
      end
      object lblAjusteRot: TLabel
        Tag = 13
        Left = 345
        Top = 31
        Width = 44
        Height = 15
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = 'Ajuste'
      end
      object lblImpuestoRot: TLabel
        Tag = 13
        Left = 328
        Top = 52
        Width = 85
        Height = 15
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = 'IVA 13 %'
      end
      object lblTotalRot: TLabel
        Tag = 12
        Left = 325
        Top = 73
        Width = 64
        Height = 18
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = 'Total'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
      object lblTotal: TLabel
        Tag = 16
        Left = 357
        Top = 73
        Width = 160
        Height = 18
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = '0,00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
      object lblImpuesto: TLabel
        Left = 339
        Top = 52
        Width = 140
        Height = 15
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = '0,00'
      end
      object lblAjuste: TLabel
        Left = 345
        Top = 29
        Width = 140
        Height = 15
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = '0,00'
      end
      object lblSubtotal: TLabel
        Left = 401
        Top = 9
        Width = 140
        Height = 15
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = '0,00'
      end
    end
  end
end
