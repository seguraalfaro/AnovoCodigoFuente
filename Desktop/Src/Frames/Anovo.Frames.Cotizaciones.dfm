inherited fraCotizaciones: TfraCotizaciones
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 117
      Caption = 'Cotizaciones'
      ExplicitWidth = 117
    end
    inherited lblSubtitulo: TLabel
      Width = 448
      Caption = 
        'Las cotizaciones elaboradas y su estado '#183' abrir para ver el deta' +
        'lle, el croquis y las fotos'
      ExplicitWidth = 448
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
    ExplicitTop = 175
    ExplicitHeight = 392
    inherited grDatos: TrDBGrid
      Height = 386
      DataSource = dmMemoria.dsCotizacionesLista
      OnDblClick = grDatosDblClick
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
          FieldName = 'CLIENTE_NOMBRE'
          Title.Caption = 'Cliente'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DESCRIPCION_TRABAJO'
          Title.Caption = 'Trabajo'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ASESOR_NOMBRE'
          Title.Caption = 'Asesor'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FECHA_ELABORACION'
          Title.Caption = 'Elaborada'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MONTO_TOTAL'
          Title.Alignment = taRightJustify
          Title.Caption = 'Total'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ESTADO'
          Title.Caption = 'Estado'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCIONES'
          Title.Caption = 'Acciones'
          Width = 120
          Visible = True
        end>
    end
  end
  object pstFiltros: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 40
    Items.Strings = (
      'Todas'
      'Borrador'
      'En revisi'#243'n'
      'Devueltas'
      'Con visto bueno'
      'Enviadas'
      'Aprobadas'
      'Rechazadas')
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
    OnChange = pstFiltrosChange
    ParentFont = False
  end
end
