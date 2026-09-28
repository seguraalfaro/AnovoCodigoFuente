inherited fraBandeja: TfraBandeja
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Caption = 'Bandeja de aprobaci'#243'n'
    end
    inherited lblSubtitulo: TLabel
      Caption = 'Cotizaciones a la espera de revisi'#243'n '#183' aprobar, devolver o rechazar'
    end
  end
  object pnlKpi: TPanel
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 71
    Width = 954
    Height = 108
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object tjPendientes: TPlanoTarjeta
      Tag = 8
      Left = 20
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 761589
      Caption = 'Pendientes'
      TabOrder = 0
      object lblPendientes: TLabel
        Tag = 16
        Left = 16
        Top = 32
        Width = 189
        Height = 34
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
    object tjAntigua: TPlanoTarjeta
      Tag = 7
      Left = 253
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 10510377
      Caption = 'M'#225's antigua'
      TabOrder = 1
      object lblAntigua: TLabel
        Tag = 16
        Left = 16
        Top = 32
        Width = 189
        Height = 34
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
    object tjEspera: TPlanoTarjeta
      Tag = 10
      Left = 486
      Top = 8
      Width = 221
      Height = 92
      TitleHeight = 28
      CardColor = 6044186
      Caption = 'Monto en espera'
      TabOrder = 2
      object lblEspera: TLabel
        Tag = 16
        Left = 16
        Top = 32
        Width = 189
        Height = 34
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
      end
    end
  end
  inherited pnlBarra: TPanel
    Top = 185
    inherited sbBuscar: TSearchBox
      TextHint = 'Cliente o descripci'#243'n'
    end
  end
  inherited pnclient: TRelativePanel
    Top = 243
    Height = 324
    inherited grDatos: TrDBGrid
      DataSource = dmMemoria.dsBandeja
      OnDblClick = grDatosDblClick
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
          Width = 220
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ASESOR_NOMBRE'
          Title.Caption = 'Asesor'
          Width = 130
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ELABORADA_POR_NOMBRE'
          Title.Caption = 'Elabor'#243
          Width = 130
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FECHA_MODIFICACION'
          Title.Caption = 'Enviada'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DIAS_EN_ESTADO'
          Title.Alignment = taRightJustify
          Title.Caption = 'D'#237'as'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MONTO_TOTAL'
          Title.Alignment = taRightJustify
          Title.Caption = 'Monto'
          Width = 120
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
