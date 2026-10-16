inherited frmHistorialCotizacion: TfrmHistorialCotizacion
  Caption = 'Historial de la cotizaci'#243'n'
  ClientHeight = 480
  ClientWidth = 760
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 766
  ExplicitHeight = 509
  PixelsPerInch = 96
  TextHeight = 15
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 760
  end
  inherited pnlTitulo: TPanel
    Width = 760
    ExplicitWidth = 760
    inherited lblTitulo: TLabel
      Caption = 'Historial de estados'
    end
    inherited lblSubtitulo: TLabel
      Top = 40
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 420
    Width = 760
    TabOrder = 1
    ExplicitTop = 420
    ExplicitWidth = 760
    inherited btnGuardar: TPlanoBotonWin
      Left = 620
      ExplicitLeft = 620
    end
    inherited btnCancelar: TPlanoBotonWin
      Left = 620
      ExplicitLeft = 620
    end
  end
  object grHistorial: TrDBGrid
    AlignWithMargins = True
    Left = 20
    Top = 98
    Width = 720
    Height = 314
    Margins.Left = 20
    Margins.Top = 8
    Margins.Right = 20
    Margins.Bottom = 8
    Align = alClient
    BorderStyle = bsNone
    DataSource = dmMemoria.dsHistorialEstados
    DefaultDrawing = False
    Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    StyleElements = [seFont]
    Columns = <
      item
        Expanded = False
        FieldName = 'FECHA'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ESTADO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'USUARIO_NOMBRE'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MOTIVO'
        Visible = True
      end>
  end
end
