inherited fraDashboardAsistente: TfraDashboardAsistente
  inherited pnlTitulo: TPanel
    inherited lblSubtitulo: TLabel
      Caption = 'Solicitudes que esperan cotizaci'#243'n y su trabajo en curso'
    end
  end
  inherited pnlKpi: TPanel
    inherited tjCifra1: TPlanoTarjeta
      Caption = 'Por cotizar'
    end
    inherited tjCifra2: TPlanoTarjeta
      Caption = 'Mis borradores'
    end
    inherited tjCifra3: TPlanoTarjeta
      Caption = 'En aprobaci'#243'n'
    end
    inherited tjCifra4: TPlanoTarjeta
      Caption = 'Aprobadas por enviar'
    end
  end
  inherited tjLista: TPlanoTarjeta
    Caption = 'Solicitudes por cotizar'
    inherited grLista: TrDBGrid
      DataSource = dmMemoria.dsDashboardAsistente
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
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ASESOR_NOMBRE'
          Title.Caption = 'Asesor'
          Width = 150
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
          FieldName = 'DIAS_ESPERA'
          Title.Alignment = taRightJustify
          Title.Caption = 'D'#237'as de espera'
          Width = 110
          Visible = True
        end>
    end
  end
end
