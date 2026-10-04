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
  end
  inherited pnclient: TRelativePanel
    Top = 175
    Height = 392
    ExplicitTop = 175
    ExplicitHeight = 392
    inherited grDatos: TrDBGrid
      Height = 386
      DataSource = dmMemoria.dsSolicitudesAsistente
      Columns = <
        item
          Expanded = False
          FieldName = 'NUMERO'
          Title.Alignment = taRightJustify
          Width = 70
          Visible = True
        end
        item
          ButtonStyle = cbsEllipsis
          Expanded = False
          FieldName = 'FECHA_RECEPCION'
          Width = 90
          Visible = True
        end
        item
          ButtonStyle = cbsEllipsis
          Expanded = False
          FieldName = 'FECHA_MODIFICACION'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CLIENTE_NOMBRE'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ASESOR_NOMBRE'
          Width = 130
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRIPCION'
          Width = 260
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRIPCION_TRABAJO'
          Width = 260
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DIAS_ESPERA'
          Title.Alignment = taRightJustify
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ESTADO'
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MOTIVO_RECHAZO'
          Width = 220
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCIONES'
          Width = 110
          Visible = True
        end>
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
