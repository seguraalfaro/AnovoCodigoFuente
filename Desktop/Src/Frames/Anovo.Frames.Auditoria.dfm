inherited fraAuditoria: TfraAuditoria
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 85
      Caption = 'Auditor'#237'a'
    end
    inherited lblSubtitulo: TLabel
      Width = 153
      Caption = 'Qui'#233'n cambi'#243' qu'#233' y cu'#225'ndo.'
    end
  end
  inherited pnlBarra: TPanel
    inherited sbBuscar: TSearchBox
      Left = 335
      TabOrder = 2
      TextHint = 'Texto del detalle'
    end
    inherited btnLimpiar: TPlanoBotonWin
      Left = 643
      TabOrder = 3
    end
    object btnPeriodo: TPlanoBotonWin
      Left = 20
      Top = 12
      Width = 300
      Height = 28
      Cursor = crHandPoint
      Caption = 'Todas las fechas'
      TabOrder = 0
      StyleElements = []
      Kind = fkSecondary
    end
  end
  inherited pnclient: TRelativePanel
    Top = 175
    Height = 392
    inherited grDatos: TrDBGrid
      Height = 386
      DataSource = dmMemoria.dsAuditoria
      Columns = <
        item
          Expanded = False
          FieldName = 'FECHA'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'USUARIO'
          Width = 160
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCION'
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ENTIDAD'
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ENTIDAD_ID'
          Title.Alignment = taRightJustify
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DETALLE'
          Width = 300
          Visible = True
        end>
    end
  end
  object pstFiltros: TPlanoPestanas
    AlignWithMargins = True
    Left = 3
    Top = 129
    Width = 954
    Height = 40
    Items.Strings = (
      'Todo'
      'Clientes'
      'Cotizaciones'
      'Cuentas')
    Style = pesPastilla
    Indent = 20
    BackColor = 16447477
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ActiveFont.Charset = DEFAULT_CHARSET
    ActiveFont.Color = clWindowText
    ActiveFont.Height = -12
    ActiveFont.Name = 'Segoe UI Semibold'
    ActiveFont.Style = []
    OnChange = pstFiltrosChange
    ParentFont = False
  end
end
