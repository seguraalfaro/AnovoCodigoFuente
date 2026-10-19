inherited fraSolicitudesAsesor: TfraSolicitudesAsesor
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 136
      Caption = 'Mis solicitudes'
      ExplicitWidth = 136
    end
    inherited lblSubtitulo: TLabel
      Width = 226
      Caption = 'Lo que usted captur'#243' y en qu'#233' va cada una'
      ExplicitWidth = 226
    end
  end
  inherited pnlBarra: TPanel
    inherited sbBuscar: TSearchBox
      TextHint = 'Cliente o descripci'#243'n'
    end
    inherited btnLimpiar: TPlanoBotonWin
      Left = 330
      ExplicitLeft = 330
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
      Width = 914
      Height = 386
      Margins.Right = 20
      DataSource = dmMemoria.dsSeguimiento
      ColumnWidth = cwAutoWidth
      Columns = <
        item
          Expanded = False
          FieldName = 'FECHA_CAPTURA'
          Title.Caption = 'Fecha'
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
          FieldName = 'DESCRIPCION'
          Title.Caption = 'Descripci'#243'n'
          Width = 200
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
          FieldName = 'MONTO_APROBADO'
          Title.Alignment = taRightJustify
          Title.Caption = 'Monto aprobado'
          Width = 100
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
end
