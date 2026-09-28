inherited fraDashboardSupervisor: TfraDashboardSupervisor
  inherited pnlTitulo: TPanel
    inherited lblSubtitulo: TLabel
      Caption = 'Cotizaciones que esperan su aprobaci'#243'n'
    end
  end
  inherited pnlKpi: TPanel
    inherited tjCifra1: TPlanoTarjeta
      Caption = 'Por aprobar'
    end
    inherited tjCifra2: TPlanoTarjeta
      Caption = 'Pendiente m'#225's antigua'
    end
    inherited tjCifra3: TPlanoTarjeta
      Caption = 'Aprobadas del mes'
      object lblMontoAprobado: TLabel
        Tag = 13
        Left = 16
        Top = 68
        Width = 189
        Height = 15
        AutoSize = False
        Caption = ''
      end
    end
    inherited tjCifra4: TPlanoTarjeta
      Caption = 'Rechazadas del mes'
    end
  end
  inherited tjLista: TPlanoTarjeta
    Caption = 'Cotizaciones por aprobar'
    inherited grLista: TrDBGrid
      DataSource = dmMemoria.dsDashboardSupervisor
      OnDblClick = grListaDblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'NUMERO'
          Title.Alignment = taRightJustify
          Title.Caption = 'N'#250'mero'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FECHA_MODIFICACION'
          Title.Caption = 'Presentada'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CLIENTE_NOMBRE'
          Title.Caption = 'Cliente'
          Width = 220
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ELABORADA_POR_NOMBRE'
          Title.Caption = 'Elaborada por'
          Width = 160
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MONTO_TOTAL'
          Title.Alignment = taRightJustify
          Title.Caption = 'Monto'
          Width = 130
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DIAS_EN_ESTADO'
          Title.Alignment = taRightJustify
          Title.Caption = 'D'#237'as de espera'
          Width = 110
          Visible = True
        end>
    end
  end
end
