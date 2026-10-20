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
    object cbFiltro: TComboBox
      Left = 428
      Top = 14
      Width = 200
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 4
      Text = 'Todos los usuarios'
      OnChange = cbFiltroChange
      Items.Strings = (
        'Todos los usuarios'
        'Activos'
        'Inactivos'
        'Deben cambiar clave'
        'Con adicionales')
    end
  end
  inherited pnclient: TRelativePanel
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
end
