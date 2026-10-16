inherited fraDashboardGerencia: TfraDashboardGerencia
  inherited pnlTitulo: TPanel
    inherited lblSubtitulo: TLabel
      Width = 155
      Caption = 'C'#243'mo va el negocio este mes'
      ExplicitWidth = 155
    end
  end
  inherited pnlKpi: TPanel
    inherited tjCifra1: TPlanoTarjeta
      Caption = 'Cotizado en el mes'
    end
    inherited tjCifra2: TPlanoTarjeta
      Caption = 'Tasa de aprobaci'#243'n'
      object lblDecididas: TLabel
        Tag = 13
        Left = 16
        Top = 68
        Width = 189
        Height = 15
        AutoSize = False
      end
    end
    inherited tjCifra3: TPlanoTarjeta
      Caption = 'Respuesta media'
    end
    inherited tjCifra4: TPlanoTarjeta
      Caption = 'Asesores activos'
    end
  end
  inherited tjLista: TPlanoTarjeta
    Width = 568
    Margins.Right = 12
    Caption = 'Productividad por asesor'
    ExplicitHeight = 182
    inherited grLista: TrDBGrid
      Top = 46
      Height = 126
      DataSource = dmMemoria.dsDashboardGerencia
      Columns = <
        item
          Expanded = False
          FieldName = 'ASESOR_NOMBRE'
          Width = 260
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SOLICITUDES_MES'
          Title.Alignment = taRightJustify
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'APROBADAS_MES'
          Title.Alignment = taRightJustify
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MONTO_APROBADO_MES'
          Title.Alignment = taRightJustify
          Width = 140
          Visible = True
        end>
    end
  end
  object tjEstados: TPlanoTarjeta
    Tag = 3
    AlignWithMargins = True
    Left = 600
    Top = 178
    Width = 340
    Height = 422
    Margins.Left = 0
    Margins.Top = 8
    Margins.Right = 20
    Margins.Bottom = 20
    Caption = 'Cotizaciones por estado'
    Align = alRight
    Font.Charset = ANSI_CHARSET
    Font.Color = 1973276
    Font.Height = -15
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object grEstados: TrDBGrid
      AlignWithMargins = True
      Left = 10
      Top = 46
      Width = 900
      Height = 164
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      BorderStyle = bsNone
      DataSource = dmMemoria.dsDashboardEstados
      DefaultDrawing = False
      Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
      TabOrder = 0
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = 1973276
      TitleFont.Height = -15
      TitleFont.Name = 'Segoe UI Semibold'
      TitleFont.Style = [fsBold]
      StyleElements = [seFont]
      Columns = <
        item
          Expanded = False
          FieldName = 'ESTADO'
          Width = 140
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CANTIDAD'
          Title.Alignment = taRightJustify
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MONTO'
          Title.Alignment = taRightJustify
          Width = 140
          Visible = True
        end>
    end
  end
end
