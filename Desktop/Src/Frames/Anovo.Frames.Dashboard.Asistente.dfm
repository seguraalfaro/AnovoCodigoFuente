inherited fraDashboardAsistente: TfraDashboardAsistente
  inherited pnlTitulo: TPanel
    inherited lblSubtitulo: TLabel
      Caption = 'Solicitudes que esperan cotizaci'#243'n y su trabajo en curso'
    end
  end
  inherited pnlKpi: TPanel
    inherited tjCifra1: TPlanoTarjeta
      Caption = 'Por tomar'
      object lblNota1: TLabel
        Left = 16
        Top = 66
        Width = 189
        Height = 18
        AutoSize = False
      end
    end
    inherited tjCifra2: TPlanoTarjeta
      Caption = 'Devueltas'
      object lblNota2: TLabel
        Left = 16
        Top = 66
        Width = 189
        Height = 18
        AutoSize = False
      end
    end
    inherited tjCifra3: TPlanoTarjeta
      Caption = 'Por enviar'
      object lblNota3: TLabel
        Left = 16
        Top = 66
        Width = 189
        Height = 18
        AutoSize = False
      end
    end
    inherited tjCifra4: TPlanoTarjeta
      Caption = 'Sin respuesta'
      object lblNota4: TLabel
        Left = 16
        Top = 66
        Width = 189
        Height = 18
        AutoSize = False
      end
    end
  end
  inherited tjLista: TPlanoTarjeta
    Visible = False
  end
  object gpTarjetas: TGridPanel
    Tag = 2
    AlignWithMargins = True
    Left = 20
    Top = 178
    Width = 920
    Height = 422
    Margins.Left = 20
    Margins.Top = 8
    Margins.Right = 20
    Margins.Bottom = 20
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 33.333333333333336
      end
      item
        Value = 33.333333333333336
      end
      item
        Value = 33.333333333333336
      end>
    ControlCollection = <
      item
        Column = 0
        Control = tjBarras
        Row = 0
      end
      item
        Column = 1
        Control = tjAvisos
        Row = 0
      end
      item
        Column = 2
        Control = tjDatos
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 3
    object tjBarras: TPlanoTarjeta
      Tag = 3
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 300
      Height = 422
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 0
      Caption = 'Mis cotizaciones por etapa'
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = 1973276
      Font.Height = -15
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object grBarras: TrDBGrid
        AlignWithMargins = True
        Left = 10
        Top = 46
        Width = 400
        Height = 300
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        BorderStyle = bsNone
        DataSource = dmMemoria.dsPanelBarras
        DefaultDrawing = False
        Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        ReadOnly = True
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
          FieldName = 'ETIQUETA'
          Title.Caption = 'Etapa'
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CANTIDAD'
          Title.Alignment = taRightJustify
          Title.Caption = 'Cantidad'
          Width = 150
          Visible = True
        end>
      end
    end
    object tjAvisos: TPlanoTarjeta
      Tag = 3
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 300
      Height = 422
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 0
      Caption = 'Para hoy'
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = 1973276
      Font.Height = -15
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object grAvisos: TrDBGrid
        AlignWithMargins = True
        Left = 10
        Top = 46
        Width = 400
        Height = 300
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        BorderStyle = bsNone
        DataSource = dmMemoria.dsPanelAvisos
        DefaultDrawing = False
        Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        ReadOnly = True
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
          Width = 160
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
          FieldName = 'DETALLE'
          Title.Caption = 'Detalle'
          Width = 160
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DIAS'
          Title.Alignment = taRightJustify
          Title.Caption = 'D'#237'as'
          Width = 50
          Visible = True
        end>
      end
    end
    object tjDatos: TPlanoTarjeta
      Tag = 3
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 300
      Height = 422
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Caption = 'Mi mes'
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = 1973276
      Font.Height = -15
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object grDatos: TrDBGrid
        AlignWithMargins = True
        Left = 10
        Top = 46
        Width = 400
        Height = 300
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        BorderStyle = bsNone
        DataSource = dmMemoria.dsPanelDatos
        DefaultDrawing = False
        Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
        ReadOnly = True
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
          FieldName = 'CONCEPTO'
          Title.Caption = 'Concepto'
          Width = 180
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VALOR'
          Title.Alignment = taRightJustify
          Title.Caption = 'Valor'
          Width = 100
          Visible = True
        end>
      end
    end
  end
end
