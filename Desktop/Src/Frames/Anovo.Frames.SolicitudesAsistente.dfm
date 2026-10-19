inherited fraSolicitudesAsistente: TfraSolicitudesAsistente
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 99
      Caption = 'Solicitudes'
      ExplicitWidth = 99
    end
    inherited lblSubtitulo: TLabel
      Width = 339
      Caption = 
        'Sin procesar: la cola com'#250'n '#183' Mis solicitudes: las que usted tom' +
        #243
      ExplicitWidth = 339
    end
  end
  inherited pnlBarra: TPanel
    inherited sbBuscar: TSearchBox
      TextHint = 'Cliente o descripci'#243'n'
    end
    object btnPeriodo: TPlanoBotonWin
      Left = 432
      Top = 12
      Width = 330
      Height = 28
      Cursor = crHandPoint
      Caption = 'Todas las fechas'
      TabOrder = 2
      StyleElements = []
      Kind = fkSecondary
    end
  end
  inherited pnclient: TRelativePanel
    ControlCollection = <
      item
        Control = grDatos
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = True
        AlignRightWithPanel = True
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end
      item
        Control = cpModo
        AlignBottomWithPanel = True
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = True
        AlignRightWithPanel = True
        AlignTopWithPanel = True
        AlignVerticalCenterWithPanel = False
      end>
    inherited grDatos: TrDBGrid
      Visible = False
    end
    object cpModo: TCardPanel
      Tag = 2
      Left = 0
      Top = 0
      Width = 954
      Height = 438
      Align = alClient
      ActiveCard = crdCola
      BevelOuter = bvNone
      TabOrder = 1
      object crdCola: TCard
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 438
        CardIndex = 0
        TabOrder = 0
        object grCola: TrDBGrid
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 931
          Height = 432
          Margins.Left = 20
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsSolicitudesCola
          DefaultDrawing = False
          Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          StyleElements = [seFont]
          Columns = <
            item
              ButtonStyle = cbsEllipsis
              Expanded = False
              FieldName = 'FECHA_RECEPCION'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CLIENTE_NOMBRE'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ASESOR_NOMBRE'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DESCRIPCION'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DIAS_ESPERA'
              Title.Alignment = taRightJustify
              Width = 90
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ACCIONES'
              Width = 200
              Visible = True
            end>
        end
      end
    end
  end
end
