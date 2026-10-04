inherited fraUsuarios: TfraUsuarios
  inherited pnlTitulo: TPanel
    inherited lblTitulo: TLabel
      Width = 182
      Caption = 'Gesti'#243'n de usuarios'
      ExplicitWidth = 182
    end
    inherited lblSubtitulo: TLabel
      Width = 557
      Caption = 
        'Quien entra al sistema, con qu'#233' rol y qu'#233' permisos adicionales t' +
        'iene '#183' inactivar no borra, conserva el rastro'
      ExplicitWidth = 557
    end
  end
  inherited pnlBarra: TPanel
    DesignSize = (
      954
      52)
    inherited sbBuscar: TSearchBox
      TextHint = 'Nombre o correo'
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
      Caption = '+ Nuevo usuario'
      TabOrder = 3
      StyleElements = []
      OnClick = btnNuevoClick
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
      DataSource = dmMemoria.dsUsuarios
      Columns = <
        item
          Expanded = False
          FieldName = 'NOMBRE'
          Title.Caption = 'Nombre'
          Width = 190
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CORREO'
          Title.Caption = 'Correo'
          Width = 215
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ROL_NOMBRE'
          Title.Caption = 'Rol'
          Width = 155
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EXCEPCIONES'
          Title.Caption = 'Adicionales'
          Width = 75
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ESTADO'
          Width = 105
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACCIONES'
          Title.Caption = 'Acciones'
          Width = 170
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
      'Activos'
      'Inactivos'
      'Deben cambiar clave'
      'Con adicionales')
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
