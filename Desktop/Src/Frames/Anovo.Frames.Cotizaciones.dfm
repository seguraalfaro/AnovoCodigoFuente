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
    object cbEstado: TComboBox
      Left = 772
      Top = 14
      Width = 170
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = 'Mes en curso'
      OnChange = cbEstadoChange
      Items.Strings = (
        'Mes en curso'
        'Todos los estados'
        'Borrador'
        'En revisi'#243'n'
        'Devueltas'
        'Con visto bueno'
        'Enviadas'
        'Aprobadas'
        'Rechazadas'
        'Descartadas')
    end
  end
  inherited pnclient: TRelativePanel
    inherited grDatos: TrDBGrid
      DataSource = dmMemoria.dsCotizacionesLista
      OnDblClick = grDatosDblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'NUMERO'
          Title.Alignment = taRightJustify
          Width = 70
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
          FieldName = 'DESCRIPCION_TRABAJO'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ASESOR_NOMBRE'
          Width = 200
          Visible = True
        end
        item
          ButtonStyle = cbsEllipsis
          Expanded = False
          FieldName = 'FECHA_ELABORACION'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MONTO_TOTAL'
          Title.Alignment = taRightJustify
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ESTADO'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCIONES'
          Width = 120
          Visible = True
        end>
    end
  end
end
