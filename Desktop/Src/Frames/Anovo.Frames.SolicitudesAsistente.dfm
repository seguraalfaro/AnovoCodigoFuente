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
    Top = 175
    Height = 392
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
    ExplicitTop = 175
    ExplicitHeight = 392
    inherited grDatos: TrDBGrid
      Height = 386
      Visible = False
    end
    object cpModo: TCardPanel
      Tag = 2
      Left = 0
      Top = 0
      Width = 954
      Height = 392
      Align = alClient
      ActiveCard = crdCola
      BevelOuter = bvNone
      Caption = ''
      TabOrder = 1
      object crdCola: TCard
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 392
        Caption = ''
        CardIndex = 0
        TabOrder = 0
        object grCola: TrDBGrid
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 931
          Height = 380
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
              Expanded = False
              FieldName = 'FECHA_RECEPCION'
              Title.Caption = 'Recibida'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CLIENTE_NOMBRE'
              Title.Caption = 'Cliente'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ASESOR_NOMBRE'
              Title.Caption = 'Asesor'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DESCRIPCION'
              Title.Caption = 'Descripci'#243'n'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DIAS_ESPERA'
              Title.Alignment = taRightJustify
              Title.Caption = 'D'#237'as'
              Width = 90
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ACCIONES'
              Title.Caption = 'Acciones'
              Width = 200
              Visible = True
            end>
        end
      end
      object crdEnTrabajo: TCard
        Tag = 2
        Left = 0
        Top = 0
        Width = 954
        Height = 392
        Caption = ''
        CardIndex = 1
        TabOrder = 1
        object grEnTrabajo: TrDBGrid
          AlignWithMargins = True
          Left = 20
          Top = 3
          Width = 931
          Height = 380
          Margins.Left = 20
          Align = alClient
          BorderStyle = bsNone
          DataSource = dmMemoria.dsSolicitudesEnTrabajo
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
              Expanded = False
              FieldName = 'NUMERO'
              Title.Alignment = taRightJustify
              Title.Caption = 'N'#250'mero'
              Width = 90
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FECHA_MODIFICACION'
              Title.Caption = 'Actualizada'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CLIENTE_NOMBRE'
              Title.Caption = 'Cliente'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DESCRIPCION_TRABAJO'
              Title.Caption = 'Trabajo'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ESTADO'
              Title.Caption = 'Estado'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'MOTIVO_RECHAZO'
              Title.Caption = 'Observaci'#243'n'
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ACCIONES'
              Title.Caption = 'Acciones'
              Width = 200
              Visible = True
            end>
        end
      end
    end
  end
  object pstModo: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 40
    Items.Strings = (
      'Sin procesar'
      'Mis solicitudes')
    Style = pesPastilla
    Indent = 20
    BackColor = 16447477
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
    OnChange = pstModoChange
    ParentFont = False
  end
end
