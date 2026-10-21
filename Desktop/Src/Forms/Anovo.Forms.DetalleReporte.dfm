inherited frmDetalleReporte: TfrmDetalleReporte
  Caption = 'Cotizaciones de la fila del reporte'
  ClientHeight = 480
  ClientWidth = 1040
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 1046
  ExplicitHeight = 509
  PixelsPerInch = 96
  TextHeight = 15
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 1040
  end
  inherited pnlTitulo: TPanel
    Width = 1040
    ExplicitWidth = 1040
    inherited lblTitulo: TLabel
      Caption = 'Cotizaciones'
    end
    inherited lblSubtitulo: TLabel
      Top = 40
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 420
    Width = 1040
    TabOrder = 1
    ExplicitTop = 420
    ExplicitWidth = 1040
    inherited btnGuardar: TPlanoBotonWin
      Left = 720
      OnClick = btnGuardarClick
      ExplicitLeft = 720
    end
    inherited btnCancelar: TPlanoBotonWin
      Left = 594
      ExplicitLeft = 594
    end
  end
  object lblPie: TLabel
    Tag = 13
    AlignWithMargins = True
    Left = 20
    Top = 397
    Width = 1000
    Height = 15
    Margins.Left = 20
    Margins.Right = 20
    Margins.Bottom = 8
    Align = alBottom
    AutoSize = False
  end
  object grDetalle: TrDBGrid
    AlignWithMargins = True
    Left = 20
    Top = 98
    Width = 1000
    Height = 288
    Margins.Left = 20
    Margins.Top = 8
    Margins.Right = 20
    Margins.Bottom = 8
    Align = alClient
    BorderStyle = bsNone
    DataSource = dmMemoria.dsDetalleReporte
    DefaultDrawing = False
    Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = grDetalleDblClick
    StyleElements = [seFont]
    Columns = <
      item
        Expanded = False
        FieldName = 'NUMERO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CLIENTE_NOMBRE'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DESCRIPCION_TRABAJO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ASESOR_NOMBRE'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FECHA_ENVIO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MONTO_TOTAL'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ESTADO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ACCIONES'
        Visible = True
      end>
  end
end
