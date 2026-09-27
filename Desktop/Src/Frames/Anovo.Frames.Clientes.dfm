inherited fraClientes: TfraClientes
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 175
      Caption = 'Gesti'#243'n de clientes'
    end
    inherited lblSubtitulo: TLabel
      Width = 442
      Caption =
        'Clientes registrados '#183' el consentimiento se otorga en el m'#243'vil y' +
        ' aqu'#237' solo se consulta'
    end
  end
  inherited pnlBarra: TPanel
    DesignSize = (
      954
      52)
    inherited sbBuscar: TSearchBox
      TextHint = 'Nombre, identificaci'#243'n, tel'#233'fono o correo'
    end
    object btnExportar: TPlanoBotonWin
      Left = 658
      Top = 12
      Width = 130
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Exportar listado'
      TabOrder = 2
      StyleElements = []
      OnClick = btnExportarClick
      Kind = fkSecondary
    end
    object btnNuevo: TPlanoBotonWin
      Left = 794
      Top = 12
      Width = 140
      Height = 28
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = '+ Nuevo cliente'
      TabOrder = 3
      StyleElements = []
      OnClick = btnNuevoClick
    end
  end
  inherited pnclient: TRelativePanel
    Top = 175
    Height = 392
    inherited grDatos: TrDBGrid
      Width = 914
      Height = 386
      Margins.Right = 20
      DataSource = dmMemoria.dsClientes
      Columns = <
        item
          Expanded = False
          FieldName = 'IDENTIFICACION'
          Title.Caption = 'Identificaci'#243'n'
          Width = 102
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOMBRE'
          Title.Caption = 'Nombre o raz'#243'n social'
          Width = 205
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TELEFONO'
          Title.Caption = 'Tel'#233'fono'
          Width = 94
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CORREO'
          Title.Caption = 'Correo'
          Width = 154
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CONSENTIMIENTO_ESTADO'
          Title.Caption = 'Consentimiento'
          Width = 102
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCIONES'
          Title.Caption = 'Acciones'
          Width = 240
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
      'Todos'
      'Con consentimiento'
      'Pendientes')
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
