inherited frmRecordatorio: TfrmRecordatorio
  Caption = 'Cotizaciones sin respuesta del cliente'
  ClientHeight = 480
  ClientWidth = 720
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitWidth = 726
  ExplicitHeight = 509
  PixelsPerInch = 96
  TextHeight = 15
  inherited TitleBarPanel1: TTitleBarPanel
    Width = 720
  end
  inherited pnlTitulo: TPanel
    Width = 720
    ExplicitWidth = 720
    inherited lblTitulo: TLabel
      Caption = 'Cotizaciones sin respuesta'
    end
    inherited lblSubtitulo: TLabel
      Top = 40
    end
  end
  inherited pnlPie: TRelativePanel
    Top = 420
    Width = 720
    TabOrder = 1
    ExplicitTop = 420
    ExplicitWidth = 720
    inherited btnGuardar: TPlanoBotonWin
      Left = 580
      OnClick = btnGuardarClick
      ExplicitLeft = 580
    end
    inherited btnCancelar: TPlanoBotonWin
      Left = 454
      ExplicitLeft = 454
    end
  end
  object lblPie: TLabel
    Tag = 13
    AlignWithMargins = True
    Left = 20
    Top = 397
    Width = 680
    Height = 15
    Margins.Left = 20
    Margins.Right = 20
    Margins.Bottom = 8
    Align = alBottom
    AutoSize = False
  end
  object grSinRespuesta: TrDBGrid
    AlignWithMargins = True
    Left = 20
    Top = 98
    Width = 680
    Height = 288
    Margins.Left = 20
    Margins.Top = 8
    Margins.Right = 20
    Margins.Bottom = 8
    Align = alClient
    BorderStyle = bsNone
    DataSource = dmMemoria.dsSinRespuesta
    DefaultDrawing = False
    Options = [dgTitles, dgColumnResize, dgRowLines, dgRowSelect, dgAlwaysShowSelection]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = grSinRespuestaDblClick
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
        FieldName = 'FECHA_ENVIO'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DIAS'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MONTO_TOTAL'
        Visible = True
      end>
  end
end
