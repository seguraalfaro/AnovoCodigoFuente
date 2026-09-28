inherited fraDashboardAsesor: TfraDashboardAsesor
  inherited pnlTitulo: TPanel
    inherited lblSubtitulo: TLabel
      Caption = 'Lo que usted captur'#243' y en qu'#233' va'
    end
  end
  inherited pnlKpi: TPanel
    inherited tjCifra1: TPlanoTarjeta
      Caption = 'Solicitudes del mes'
    end
    inherited tjCifra2: TPlanoTarjeta
      Caption = 'Esperando cotizaci'#243'n'
    end
    inherited tjCifra3: TPlanoTarjeta
      Caption = 'Aprobadas del mes'
    end
    inherited tjCifra4: TPlanoTarjeta
      Caption = 'Monto aprobado'
    end
  end
  inherited tjLista: TPlanoTarjeta
    Caption = 'Mis solicitudes de esta semana'
    inherited grLista: TrDBGrid
      DataSource = dmMemoria.dsDashboardAsesor
      Columns = <
        item
          Expanded = False
          FieldName = 'FECHA_CAPTURA'
          Title.Caption = 'Fecha'
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
          FieldName = 'DESCRIPCION'
          Title.Caption = 'Descripci'#243'n'
          Width = 300
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ESTADO'
          Title.Caption = 'Estado'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MONTO_APROBADO'
          Title.Alignment = taRightJustify
          Title.Caption = 'Monto aprobado'
          Width = 130
          Visible = True
        end>
    end
  end
end
