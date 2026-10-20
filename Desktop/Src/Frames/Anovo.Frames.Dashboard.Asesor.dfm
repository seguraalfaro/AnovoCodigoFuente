inherited fraDashboardAsesor: TfraDashboardAsesor
  inherited pnlTitulo: TPanel
    inherited lblSubtitulo: TLabel
      Caption = 'C'#243'mo van sus solicitudes este mes'
    end
  end
  inherited pnlKpi: TPanel
    inherited tjCifra1: TPlanoTarjeta
      Tag = 7
      TitleIndent = 36
      CardColor = 10510377
      Caption = 'Solicitudes del mes'
      object lblIcono1: TLabel
        Tag = 1
        Left = 16
        Top = 7
        Width = 16
        Height = 16
        AutoSize = False
        Caption = #59557
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
      Tag = 10
      TitleIndent = 36
      CardColor = 6044186
      Caption = 'Esperando cotizaci'#243'n'
      object lblIcono2: TLabel
        Tag = 1
        Left = 16
        Top = 7
        Width = 16
        Height = 16
        AutoSize = False
        Caption = #59670
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
      Tag = 9
      TitleIndent = 36
      CardColor = 6210850
      Caption = 'Aprobadas del mes'
      object lblIcono3: TLabel
        Tag = 1
        Left = 16
        Top = 7
        Width = 16
        Height = 16
        AutoSize = False
        Caption = #59696
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
      Caption = 'Monto aprobado'
      object lblIcono4: TLabel
        Tag = 1
        Left = 16
        Top = 7
        Width = 16
        Height = 16
        AutoSize = False
        Caption = #59591
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
    Height = 260
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
        Control = tjBarras
        Row = 0
      end
      item
        Column = 1
        Control = tjAvisos
        Row = 0
      end
    >
    RowCollection = <
      item
        SizeStyle = ssPercent
        Value = 100.000000000000000000
      end
    >
    TabOrder = 3
    object tjBarras: TPlanoTarjeta
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
      Caption = 'C'#243'mo van mis solicitudes'
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = 1973276
      Font.Height = -15
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object pbBarras: TPaintBox
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
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Caption = 'Clientes por llamar'
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
        Caption = 'enviadas sin respuesta'
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
  end
end
