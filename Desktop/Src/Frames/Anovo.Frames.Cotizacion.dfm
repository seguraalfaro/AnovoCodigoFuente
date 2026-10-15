object fraCotizacion: TfraCotizacion
  Left = 0
  Top = 0
  Width = 1180
  Height = 720
  Align = alTop
  OnResize = FrameResize
  TabOrder = 0
  object pnlEncabezado: TPanel
    Tag = 2
    Left = 0
    Top = 0
    Width = 1180
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      1180
      65)
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 8
      Width = 6
      Height = 30
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
      Top = 46
      Width = 3
      Height = 13
    end
    object btnVolver: TPlanoBotonWin
      Left = 690
      Top = 18
      Width = 100
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Volver'
      TabOrder = 0
      StyleElements = []
      OnClick = btnVolverClick
      Kind = fkSecondary
    end
    object btnGuardar: TPlanoBotonWin
      Left = 800
      Top = 18
      Width = 100
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Guardar'
      TabOrder = 1
      StyleElements = []
      OnClick = btnGuardarClick
      Kind = fkSecondary
    end
    object btnPresentar: TPlanoBotonWin
      Tag = 17
      Left = 910
      Top = 18
      Width = 250
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Enviar a revisi'#243'n'
      TabOrder = 2
      StyleElements = []
      OnClick = btnPresentarClick
    end
    object btnEnviar: TPlanoBotonWin
      Tag = 17
      Left = 910
      Top = 18
      Width = 170
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Enviar al cliente'
      TabOrder = 3
      Visible = False
      StyleElements = []
      OnClick = btnEnviarClick
    end
    object btnClienteRechazo: TPlanoBotonWin
      Tag = 19
      Left = 800
      Top = 18
      Width = 170
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'El cliente rechaz'#243
      TabOrder = 4
      Visible = False
      StyleElements = []
      OnClick = btnClienteRechazoClick
    end
    object btnClienteAprobo: TPlanoBotonWin
      Tag = 18
      Left = 980
      Top = 18
      Width = 180
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'El cliente aprob'#243
      TabOrder = 5
      Visible = False
      StyleElements = []
      OnClick = btnClienteAproboClick
    end
    object btnGuardarPdf: TPlanoBotonWin
      Tag = 21
      Left = 400
      Top = 18
      Width = 130
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Guardar PDF'
      TabOrder = 6
      Visible = False
      StyleElements = []
      OnClick = btnGuardarPdfClick
      Kind = fkSecondary
    end
    object btnVistaPrevia: TPlanoBotonWin
      Tag = 21
      Left = 400
      Top = 18
      Width = 130
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Vista previa'
      TabOrder = 7
      Visible = False
      StyleElements = []
      OnClick = btnVistaPreviaClick
      Kind = fkSecondary
    end
  end
  object pnlAviso: TPanel
    Tag = 1
    AlignWithMargins = True
    Left = 20
    Top = 68
    Width = 1140
    Height = 34
    Margins.Left = 20
    Margins.Right = 20
    Align = alTop
    BevelOuter = bvNone
    Color = 14546175
    ParentBackground = False
    TabOrder = 1
    Visible = False
    object lblAviso: TLabel
      Tag = 1
      AlignWithMargins = True
      Left = 12
      Top = 3
      Width = 1116
      Height = 28
      Margins.Left = 12
      Margins.Right = 12
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 19050
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 4
      ExplicitHeight = 17
    end
  end
  object pnlCuerpo: TPanel
    Tag = 2
    Left = 0
    Top = 105
    Width = 1180
    Height = 615
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 20
    Padding.Top = 6
    Padding.Right = 20
    Padding.Bottom = 14
    TabOrder = 2
    object pnlEvidencia: TPanel
      Tag = 2
      Left = 20
      Top = 6
      Width = 420
      Height = 595
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object tjSolicitud: TPlanoTarjeta
        Tag = 3
        Left = 0
        Top = 0
        Width = 420
        Height = 84
        Caption = 'Solicitud'
        Align = alTop
        Padding.Left = 12
        Padding.Top = 4
        Padding.Right = 12
        Padding.Bottom = 12
        TabOrder = 0
        object lblProyectoRot: TLabel
          Tag = 13
          Left = 16
          Top = 40
          Width = 64
          Height = 15
          AutoSize = False
          Caption = 'Proyecto'
        end
        object lblProyecto: TLabel
          Tag = 25
          Left = 84
          Top = 40
          Width = 320
          Height = 15
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          EllipsisPosition = epEndEllipsis
          ShowAccelChar = False
        end
        object lblContactoRot: TLabel
          Tag = 13
          Left = 16
          Top = 60
          Width = 64
          Height = 15
          AutoSize = False
          Caption = 'Contacto'
        end
        object lblContacto: TLabel
          Left = 84
          Top = 60
          Width = 320
          Height = 15
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          EllipsisPosition = epEndEllipsis
          ShowAccelChar = False
        end
      end
      object tjPiezas: TPlanoTarjeta
        Tag = 3
        AlignWithMargins = True
        Left = 0
        Top = 94
        Width = 420
        Height = 128
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = 'Piezas'
        Align = alTop
        Padding.Left = 12
        Padding.Top = 4
        Padding.Right = 12
        Padding.Bottom = 10
        TabOrder = 1
        object grPiezas: TrDBGrid
          Left = 12
          Top = 40
          Width = 396
          Height = 78
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsPiezas
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          StyleElements = [seFont]
          OnCellClick = grPiezasCellClick
          OnKeyUp = grPiezasKeyUp
        end
      end
      object tjCroquis: TPlanoTarjeta
        Tag = 3
        AlignWithMargins = True
        Left = 0
        Top = 232
        Width = 420
        Height = 32
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = 'Croquis'
        Align = alClient
        Padding.Left = 12
        Padding.Top = 4
        Padding.Right = 12
        Padding.Bottom = 12
        TabOrder = 2
        object pbCroquis: TPaintBox
          Left = 12
          Top = 40
          Width = 396
          Height = 118
          Cursor = crHandPoint
          Align = alClient
          OnClick = imgFotoClick
          OnPaint = pbCroquisPaint
        end
        object lblSinCroquis: TLabel
          Tag = 13
          Left = 12
          Top = 40
          Width = 396
          Height = 118
          Align = alClient
          Alignment = taCenter
          AutoSize = False
          Layout = tlCenter
          Visible = False
        end
      end
      object tjFotos: TPlanoTarjeta
        Tag = 3
        AlignWithMargins = True
        Left = 0
        Top = 307
        Width = 420
        Height = 128
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = 'Fotograf'#237'as'
        Align = alBottom
        Padding.Left = 12
        Padding.Top = 4
        Padding.Right = 12
        Padding.Bottom = 6
        TabOrder = 3
        object lblSinFotos: TLabel
          Tag = 13
          Left = 12
          Top = 40
          Width = 396
          Height = 82
          Align = alClient
          Alignment = taCenter
          AutoSize = False
          Layout = tlCenter
          Visible = False
        end
        object sbFotos: TScrollBox
          Tag = 3
          Left = 12
          Top = 40
          Width = 396
          Height = 82
          HorzScrollBar.Tracking = True
          VertScrollBar.Visible = False
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 0
        end
      end
      object tjMedidas: TPlanoTarjeta
        Tag = 3
        AlignWithMargins = True
        Left = 0
        Top = 445
        Width = 420
        Height = 150
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = 'Medidas tomadas en sitio'
        Align = alBottom
        Padding.Left = 12
        Padding.Top = 4
        Padding.Right = 12
        Padding.Bottom = 12
        TabOrder = 4
        object grMedidas: TrDBGrid
          Left = 12
          Top = 40
          Width = 396
          Height = 98
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsMedidas
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect]
          ReadOnly = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          StyleElements = [seFont]
        end
      end
    end
    object pnlDerecha: TPanel
      Tag = 2
      AlignWithMargins = True
      Left = 454
      Top = 6
      Width = 706
      Height = 595
      Margins.Left = 14
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object tjQueSeCotiza: TPlanoTarjeta
        Tag = 3
        Left = 0
        Top = 0
        Width = 796
        Height = 89
        Align = alTop
        TabOrder = 0
        object RelativePanel1: TRelativePanel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 790
          Height = 83
          ControlCollection = <
            item
              Control = lblQueSeCotiza
              AlignBottomWithPanel = False
              AlignHorizontalCenterWithPanel = False
              AlignLeftWithPanel = False
              AlignRightWithPanel = False
              AlignTopWithPanel = True
              AlignVerticalCenterWithPanel = False
            end
            item
              Control = cbTipoTrabajo
              AlignBottomWithPanel = True
              AlignHorizontalCenterWithPanel = False
              AlignLeftWithPanel = False
              AlignRightWithPanel = False
              AlignTopWithPanel = False
              AlignVerticalCenterWithPanel = False
            end
            item
              AlignBottomWithPanel = False
              AlignHorizontalCenterWithPanel = False
              AlignLeftWithPanel = False
              AlignRightWithPanel = False
              AlignTopWithPanel = False
              AlignVerticalCenterWithPanel = False
            end
            item
              AlignBottomWithPanel = False
              AlignHorizontalCenterWithPanel = False
              AlignLeftWithPanel = False
              AlignRightWithPanel = False
              AlignTopWithPanel = False
              AlignVerticalCenterWithPanel = False
            end
            item
              Control = edDescripcion
              AlignBottomWithPanel = True
              AlignHorizontalCenterWithPanel = False
              AlignLeftWithPanel = False
              AlignRightWithPanel = False
              AlignTopWithPanel = False
              AlignVerticalCenterWithPanel = False
            end
            item
              AlignBottomWithPanel = False
              AlignHorizontalCenterWithPanel = False
              AlignLeftWithPanel = False
              AlignRightWithPanel = False
              AlignTopWithPanel = False
              AlignVerticalCenterWithPanel = False
            end
            item
              Control = btnNuevoTipo
              AlignBottomWithPanel = True
              AlignHorizontalCenterWithPanel = False
              AlignLeftWithPanel = False
              AlignRightWithPanel = False
              AlignTopWithPanel = False
              AlignVerticalCenterWithPanel = False
            end
            item
              Control = pstEstado
              AlignBottomWithPanel = False
              AlignHorizontalCenterWithPanel = False
              AlignLeftWithPanel = False
              AlignRightWithPanel = True
              AlignTopWithPanel = True
              AlignVerticalCenterWithPanel = False
            end>
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitHeight = 78
          DesignSize = (
            790
            83)
          object lblQueSeCotiza: TLabel
            Tag = 12
            AlignWithMargins = True
            Left = 13
            Top = 10
            Width = 65
            Height = 13
            Margins.Top = 10
            Caption = 'Qu'#233' se cotiza'
          end
          object cbTipoTrabajo: TrDBLookupComboBox
            AlignWithMargins = True
            Left = 16
            Top = 52
            Width = 226
            Height = 21
            Margins.Bottom = 10
            Anchors = []
            DataField = 'TIPO_TRABAJO_ID'
            DataSource = dmMemoria.dsCotizacionEdicion
            DropDownRows = 10
            KeyField = 'ID'
            ListField = 'NOMBRE'
            ListSource = dmMemoria.dsTiposTrabajoLista
            TabOrder = 0
            ReadOnlyColor = 15987699
            DBEditLabel.OwnCaption = 'Tipo de trabajo'
            BoundLabel.Anchors = []
            BoundLabel.Position = lpTopRight
            EmptyDisplayValue = 'Sin especificar'
            AllowLookupFilter = True
            AutoDropDown = True
          end
          object edDescripcion: TrDBEdit
            AlignWithMargins = True
            Left = 292
            Top = 52
            Width = 488
            Height = 21
            Margins.Bottom = 10
            Anchors = [akLeft, akTop, akRight]
            DataField = 'DESCRIPCION_TRABAJO'
            DataSource = dmMemoria.dsCotizacionEdicion
            TabOrder = 1
            StyleElements = []
            ReadOnlyColor = 15987699
            DBEditLabel.AlignWithMargins = True
            DBEditLabel.Margins.Top = 5
            DBEditLabel.OwnCaption = 'Descripci'#243'n que ver'#225' el cliente'
            DBEditLabel.ShowRequiredBold = True
          end
          object btnNuevoTipo: TPlanoBotonWin
            AlignWithMargins = True
            Left = 246
            Top = 45
            Width = 30
            Height = 28
            Cursor = crHandPoint
            Hint = 'Agregar un tipo de trabajo al cat'#225'logo'
            Margins.Bottom = 10
            Anchors = []
            Caption = '+'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            Visible = False
            StyleElements = []
            OnClick = btnNuevoTipoClick
            Kind = fkSecondary
          end
          object pstEstado: TPlanoPastilla
            AlignWithMargins = True
            Left = 750
            Top = 10
            Width = 20
            Height = 22
            Margins.Top = 10
            Margins.Right = 20
            Anchors = [akTop, akRight]
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Segoe UI Semibold'
            Font.Style = []
            ParentFont = False
          end
        end
      end
      object pnlPie: TPanel
        Tag = 2
        AlignWithMargins = True
        Left = 0
        Top = 389
        Width = 796
        Height = 206
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object tjTotales: TPlanoTarjeta
          Tag = 3
          Left = 486
          Top = 0
          Width = 310
          Height = 206
          Caption = 'Totales'
          Align = alRight
          TabOrder = 1
          object lblMaterialesRot: TLabel
            Tag = 13
            Left = 16
            Top = 40
            Width = 49
            Height = 13
            Caption = 'Materiales'
          end
          object lblManoObraRot: TLabel
            Tag = 13
            Left = 16
            Top = 59
            Width = 66
            Height = 13
            Caption = 'Mano de obra'
          end
          object lblMaquinaRot: TLabel
            Tag = 13
            Left = 16
            Top = 78
            Width = 45
            Height = 13
            Caption = 'M'#225'quinas'
          end
          object lblCostoRot: TLabel
            Tag = 13
            Left = 16
            Top = 97
            Width = 28
            Height = 13
            Caption = 'Costo'
          end
          object lblAjusteRot: TLabel
            Tag = 13
            Left = 16
            Top = 116
            Width = 31
            Height = 13
            Caption = 'Ajuste'
          end
          object lblIvaRot: TLabel
            Tag = 13
            Left = 16
            Top = 135
            Width = 17
            Height = 13
            Caption = 'IVA'
          end
          object lblTotalRot: TLabel
            Tag = 11
            Left = 16
            Top = 160
            Width = 24
            Height = 13
            Caption = 'Total'
          end
          object lblMateriales: TLabel
            Tag = 25
            Left = 130
            Top = 40
            Width = 164
            Height = 15
            Alignment = taRightJustify
            AutoSize = False
          end
          object lblManoObra: TLabel
            Tag = 25
            Left = 130
            Top = 59
            Width = 164
            Height = 15
            Alignment = taRightJustify
            AutoSize = False
          end
          object lblMaquina: TLabel
            Tag = 25
            Left = 130
            Top = 78
            Width = 164
            Height = 15
            Alignment = taRightJustify
            AutoSize = False
          end
          object lblCosto: TLabel
            Tag = 25
            Left = 130
            Top = 97
            Width = 164
            Height = 15
            Alignment = taRightJustify
            AutoSize = False
          end
          object lblAjuste: TLabel
            Tag = 25
            Left = 130
            Top = 116
            Width = 164
            Height = 15
            Alignment = taRightJustify
            AutoSize = False
          end
          object lblIva: TLabel
            Tag = 25
            Left = 130
            Top = 135
            Width = 164
            Height = 15
            Alignment = taRightJustify
            AutoSize = False
          end
          object lblTotal: TLabel
            Tag = 11
            Left = 130
            Top = 160
            Width = 164
            Height = 28
            Alignment = taRightJustify
            AutoSize = False
          end
        end
        object tjAjuste: TPlanoTarjeta
          Tag = 3
          AlignWithMargins = True
          Left = 0
          Top = 0
          Width = 476
          Height = 206
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 0
          Caption = 'Ajuste'
          Align = alClient
          TabOrder = 0
          DesignSize = (
            476
            206)
          object lblAjustePorcentaje: TLabel
            Tag = 25
            Left = 16
            Top = 46
            Width = 3
            Height = 13
          end
          object lblAjusteMotivo: TLabel
            Tag = 13
            Left = 16
            Top = 70
            Width = 444
            Height = 60
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            WordWrap = True
          end
          object btnAjuste: TPlanoBotonWin
            Left = 326
            Top = 4
            Width = 140
            Height = 28
            Cursor = crHandPoint
            Anchors = [akTop, akRight]
            Caption = 'Cambiar ajuste'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            StyleElements = []
            OnClick = btnAjusteClick
            Kind = fkSecondary
          end
        end
        object tjCondiciones: TPlanoTarjeta
          Tag = 3
          AlignWithMargins = True
          Left = 226
          Top = 0
          Width = 250
          Height = 206
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 0
          Caption = 'Condiciones para el cliente'
          Align = alRight
          TabOrder = 2
          object edFormaPago: TrDBEdit
            Left = 16
            Top = 58
            Width = 218
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            DataField = 'FORMA_PAGO'
            DataSource = dmMemoria.dsCotizacionEdicion
            TabOrder = 0
            StyleElements = []
            ReadOnlyColor = 15987699
            DBEditLabel.AlignWithMargins = True
            DBEditLabel.Margins.Top = 5
            DBEditLabel.OwnCaption = 'Forma de pago'
          end
          object edEntrega: TrDBEdit
            Left = 16
            Top = 108
            Width = 218
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            DataField = 'PLAZO_ENTREGA'
            DataSource = dmMemoria.dsCotizacionEdicion
            TabOrder = 1
            StyleElements = []
            ReadOnlyColor = 15987699
            DBEditLabel.AlignWithMargins = True
            DBEditLabel.Margins.Top = 5
            DBEditLabel.OwnCaption = 'Entrega'
          end
          object edGarantia: TrDBEdit
            Left = 16
            Top = 158
            Width = 218
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            DataField = 'GARANTIA'
            DataSource = dmMemoria.dsCotizacionEdicion
            TabOrder = 2
            StyleElements = []
            ReadOnlyColor = 15987699
            DBEditLabel.AlignWithMargins = True
            DBEditLabel.Margins.Top = 5
            DBEditLabel.OwnCaption = 'Garant'#237'a'
          end
        end
      end
      object tjLineas: TPlanoTarjeta
        Tag = 3
        AlignWithMargins = True
        Left = 0
        Top = 99
        Width = 796
        Height = 280
        Margins.Left = 0
        Margins.Top = 10
        Margins.Right = 0
        Margins.Bottom = 0
        Caption = 'L'#237'neas de la cotizaci'#243'n'
        Align = alClient
        Padding.Left = 12
        Padding.Top = 44
        Padding.Right = 12
        Padding.Bottom = 12
        TabOrder = 1
        ExplicitTop = 114
        ExplicitHeight = 265
        DesignSize = (
          796
          280)
        object btnMaterial: TPlanoBotonWin
          Left = 366
          Top = 6
          Width = 96
          Height = 28
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = '+ Material'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          StyleElements = []
          OnClick = btnMaterialClick
          Kind = fkSecondary
        end
        object btnManoObra: TPlanoBotonWin
          Left = 468
          Top = 6
          Width = 122
          Height = 28
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = '+ Mano de obra'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          StyleElements = []
          OnClick = btnManoObraClick
          Kind = fkSecondary
        end
        object btnMaquina: TPlanoBotonWin
          Left = 596
          Top = 6
          Width = 96
          Height = 28
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = '+ M'#225'quina'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          StyleElements = []
          OnClick = btnMaquinaClick
          Kind = fkSecondary
        end
        object btnNota: TPlanoBotonWin
          Left = 698
          Top = 6
          Width = 84
          Height = 28
          Cursor = crHandPoint
          Anchors = [akTop, akRight]
          Caption = '+ Nota'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          StyleElements = []
          OnClick = btnNotaClick
          Kind = fkSecondary
        end
        object grLineas: TrDBGrid
          Left = 12
          Top = 80
          Width = 772
          Height = 188
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsLineasCotizacion
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect]
          ReadOnly = True
          TabOrder = 4
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          StyleElements = [seFont]
        end
      end
    end
  end
end
