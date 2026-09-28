inherited fraDashboardCuentas: TfraDashboardCuentas
  inherited pnlTitulo: TPanel
    inherited lblSubtitulo: TLabel
      Caption = 'Estado de las cuentas de usuario'
    end
  end
  inherited pnlKpi: TPanel
    inherited tjCifra1: TPlanoTarjeta
      Caption = 'Usuarios activos'
    end
    inherited tjCifra2: TPlanoTarjeta
      Caption = 'Usuarios inactivos'
    end
    inherited tjCifra3: TPlanoTarjeta
      Caption = 'Deben cambiar clave'
    end
    inherited tjCifra4: TPlanoTarjeta
      Caption = 'Cambios en cuentas del mes'
    end
  end
  inherited tjLista: TPlanoTarjeta
    Caption = 'Cambios recientes en cuentas'
    inherited grLista: TrDBGrid
      DataSource = dmMemoria.dsDashboardCuentas
      Columns = <
        item
          Expanded = False
          FieldName = 'FECHA'
          Title.Caption = 'Fecha'
          Width = 130
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'USUARIO_NOMBRE'
          Title.Caption = 'Hecho por'
          Width = 180
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCION'
          Title.Caption = 'Acci'#243'n'
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DETALLE'
          Title.Caption = 'Detalle'
          Width = 400
          Visible = True
        end>
    end
  end
end
