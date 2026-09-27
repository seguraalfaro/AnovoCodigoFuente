object fraConfiguracion: TfraConfiguracion
  Left = 0
  Top = 0
  Width = 960
  Height = 620
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object pnlTitulo: TPanel
    Tag = 2
    Left = 0
    Top = 0
    Width = 960
    Height = 62
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitulo: TLabel
      Tag = 11
      Left = 20
      Top = 10
      Caption = 'Configuraci'#243'n'
    end
    object lblSubtitulo: TLabel
      Tag = 13
      Left = 20
      Top = 40
      Caption = 'Su cuenta, la conexi'#243'n con el servidor y la versi'#243'n del sistema'
    end
  end
  object pnlCuerpo: TPanel
    Tag = 2
    Left = 0
    Top = 62
    Width = 960
    Height = 558
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object tjCuenta: TPlanoTarjeta
      Tag = 3
      Left = 20
      Top = 8
      Width = 300
      Height = 230
      TitleHeight = 36
      Caption = 'Mi cuenta'
      TabOrder = 0
      object lblNombreRot: TLabel
        Tag = 13
        Left = 16
        Top = 49
        Caption = 'Nombre'
      end
      object lblNombre: TLabel
        Tag = 25
        Left = 124
        Top = 48
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblCorreoRot: TLabel
        Tag = 13
        Left = 16
        Top = 77
        Caption = 'Correo'
      end
      object lblCorreo: TLabel
        Tag = 25
        Left = 124
        Top = 76
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblRolRot: TLabel
        Tag = 13
        Left = 16
        Top = 105
        Caption = 'Rol'
      end
      object lblRol: TLabel
        Tag = 25
        Left = 124
        Top = 104
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblClaveRot: TLabel
        Tag = 13
        Left = 16
        Top = 133
        Caption = 'Clave cambiada'
      end
      object lblClave: TLabel
        Tag = 25
        Left = 124
        Top = 132
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object btnCambiarClave: TPlanoBotonWin
        Left = 16
        Top = 180
        Width = 150
        Height = 32
        Cursor = crHandPoint
        Caption = 'Cambiar mi clave'
        TabOrder = 0
        StyleElements = []
        OnClick = btnCambiarClaveClick
      end
    end
    object tjConexion: TPlanoTarjeta
      Tag = 3
      Left = 332
      Top = 8
      Width = 300
      Height = 230
      TitleHeight = 36
      Caption = 'Conexi'#243'n'
      TabOrder = 1
      object lblServidorRot: TLabel
        Tag = 13
        Left = 16
        Top = 49
        Caption = 'Servidor'
      end
      object lblServidor: TLabel
        Tag = 25
        Left = 124
        Top = 48
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblEstadoRot: TLabel
        Tag = 13
        Left = 16
        Top = 77
        Caption = 'Estado'
      end
      object lblEstado: TLabel
        Tag = 25
        Left = 124
        Top = 76
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblRespuestaRot: TLabel
        Tag = 13
        Left = 16
        Top = 105
        Caption = 'Respuesta'
      end
      object lblRespuesta: TLabel
        Tag = 25
        Left = 124
        Top = 104
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object btnProbar: TPlanoBotonWin
        Left = 16
        Top = 180
        Width = 150
        Height = 32
        Cursor = crHandPoint
        Caption = 'Probar conexi'#243'n'
        TabOrder = 0
        StyleElements = []
        OnClick = btnProbarClick
        Kind = fkSecondary
      end
    end
    object tjAcercaDe: TPlanoTarjeta
      Tag = 3
      Left = 644
      Top = 8
      Width = 300
      Height = 230
      TitleHeight = 36
      Caption = 'Acerca de'
      TabOrder = 2
      object lblVerEscritorioRot: TLabel
        Tag = 13
        Left = 16
        Top = 49
        Caption = 'Escritorio'
      end
      object lblVerEscritorio: TLabel
        Tag = 25
        Left = 124
        Top = 48
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblVerServidorRot: TLabel
        Tag = 13
        Left = 16
        Top = 77
        Caption = 'Servidor'
      end
      object lblVerServidor: TLabel
        Tag = 25
        Left = 124
        Top = 76
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblVerMovilRot: TLabel
        Tag = 13
        Left = 16
        Top = 105
        Caption = 'M'#243'vil'
      end
      object lblVerMovil: TLabel
        Tag = 25
        Left = 124
        Top = 104
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
      object lblVerAvisoRot: TLabel
        Tag = 13
        Left = 16
        Top = 133
        Caption = 'Aviso de privacidad'
      end
      object lblVerAviso: TLabel
        Tag = 25
        Left = 124
        Top = 132
        Width = 160
        Height = 15
        AutoSize = False
        Alignment = taRightJustify
        Caption = '-'
        EllipsisPosition = epEndEllipsis
      end
    end
  end
end
