inherited fraSolicitudesAsistente: TfraSolicitudesAsistente
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Caption = 'Solicitudes'
    end
    inherited lblSubtitulo: TLabel
      Caption = 'Sin procesar: la cola com'#250'n '#183' Mis solicitudes: las que usted tom'#243
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
    inherited grDatos: TrDBGrid
      DataSource = dmMemoria.dsSolicitudesAsistente
      Columns = <
        item
          Expanded = False
          FieldName = 'NUMERO'
          Title.Alignment = taRightJustify
          Title.Caption = 'N'#250'mero'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FECHA_RECEPCION'
          Title.Caption = 'Recibida'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FECHA_MODIFICACION'
          Title.Caption = 'Actualizada'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CLIENTE_NOMBRE'
          Title.Caption = 'Cliente'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ASESOR_NOMBRE'
          Title.Caption = 'Asesor'
          Width = 130
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRIPCION'
          Title.Caption = 'Descripci'#243'n'
          Width = 260
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRIPCION_TRABAJO'
          Title.Caption = 'Trabajo'
          Width = 260
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DIAS_ESPERA'
          Title.Alignment = taRightJustify
          Title.Caption = 'D'#237'as'
          Width = 60
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
          Width = 220
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCIONES'
          Title.Caption = 'Acciones'
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
