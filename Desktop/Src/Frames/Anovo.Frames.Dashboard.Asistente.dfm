inherited fraDashboardAsistente: TfraDashboardAsistente
  inherited pnlTitulo: TPanel
    inherited lblSubtitulo: TLabel
      Caption = 'Su trabajo en curso'
    end
  end
  inherited pnlKpi: TPanel
    inherited tjCifra1: TPlanoTarjeta
      Tag = 7
      TitleIndent = 36
      CardColor = 10510377
      Caption = 'Por tomar (cola)'
      object lblIcono1: TLabel
        Tag = 1
        Left = 16
        Top = 7
        Width = 16
        Height = 16
        AutoSize = False
        Caption = #59157
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe MDL2 Assets'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblNota1: TLabel
        Left = 16
        Top = 66
        Width = 189
        Height = 18
        AutoSize = False
      end
    end
    inherited tjCifra2: TPlanoTarjeta
      Tag = 26
      TitleIndent = 36
      CardColor = 4474095
      Caption = 'Devueltas'
      object lblIcono2: TLabel
        Tag = 1
        Left = 16
        Top = 7
        Width = 16
        Height = 16
        AutoSize = False
        Caption = #59303
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe MDL2 Assets'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblNota2: TLabel
        Left = 16
        Top = 66
        Width = 189
        Height = 18
        AutoSize = False
      end
    end
    inherited tjCifra3: TPlanoTarjeta
      Tag = 10
      TitleIndent = 36
      CardColor = 6044186
      Caption = 'Por enviar'
      object lblIcono3: TLabel
        Tag = 1
        Left = 16
        Top = 7
        Width = 16
        Height = 16
        AutoSize = False
        Caption = #59172
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe MDL2 Assets'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblNota3: TLabel
        Left = 16
        Top = 66
        Width = 189
        Height = 18
        AutoSize = False
      end
    end
    inherited tjCifra4: TPlanoTarjeta
      Tag = 8
      TitleIndent = 36
      CardColor = 761589
      Caption = 'Sin respuesta'
      object lblIcono4: TLabel
        Tag = 1
        Left = 16
        Top = 7
        Width = 16
        Height = 16
        AutoSize = False
        Caption = #59159
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe MDL2 Assets'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
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
    Height = 340
    Margins.Left = 20
    Margins.Top = 8
    Margins.Right = 20
    Margins.Bottom = 20
    Align = alTop
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        ColumnSpan = 2
        Control = tjEtapas
        Row = 0
      end
      item
        Column = 0
        Control = tjAvisos
        Row = 1
      end
      item
        Column = 1
        Control = tjDatos
        Row = 1
      end
    >
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 110.000000000000000000
      end
      item
        SizeStyle = ssPercent
        Value = 100.000000000000000000
      end
    >
    TabOrder = 3
    object tjEtapas: TPlanoTarjeta
      Tag = 3
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 454
      Height = 240
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 12
      Caption = 'Mis cotizaciones por etapa'
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = 1973276
      Font.Height = -15
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object pbEtapas: TPaintBox
        Tag = 1
        AlignWithMargins = True
        Left = 16
        Top = 46
        Width = 422
        Height = 182
        Margins.Left = 16
        Margins.Top = 10
        Margins.Right = 16
        Margins.Bottom = 12
        Align = alClient
      end
    end
    object tjAvisos: TPlanoTarjeta
      Tag = 3
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 454
      Height = 240
      Margins.Left = 0
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
      object lblCabeceraAvisos: TLabel
        Tag = 15
        Left = 200
        Top = 11
        Width = 240
        Height = 18
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = 'abrir'
      end
      object pbAvisos: TPaintBox
        Tag = 1
        AlignWithMargins = True
        Left = 16
        Top = 46
        Width = 422
        Height = 182
        Margins.Left = 16
        Margins.Top = 10
        Margins.Right = 16
        Margins.Bottom = 12
        Align = alClient
      end
    end
    object tjDatos: TPlanoTarjeta
      Tag = 3
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 454
      Height = 240
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
      object pbDatos: TPaintBox
        Tag = 1
        AlignWithMargins = True
        Left = 16
        Top = 46
        Width = 422
        Height = 182
        Margins.Left = 16
        Margins.Top = 10
        Margins.Right = 16
        Margins.Bottom = 12
        Align = alClient
      end
    end
  end
end
