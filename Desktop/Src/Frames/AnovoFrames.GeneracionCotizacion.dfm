object Frame2: TFrame2
  Left = 0
  Top = 0
  Width = 980
  Height = 670
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 1973276
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object rpTop: TRelativePanel
    AlignWithMargins = True
    Left = 3
    Top = 629
    Width = 974
    Height = 38
    ControlCollection = <
      item
        Control = PlanoBotonWin1
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = True
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
      end
      item
        Control = PlanoBotonWin2
        AlignBottomWithPanel = False
        AlignHorizontalCenterWithPanel = False
        AlignLeftWithPanel = False
        AlignRightWithPanel = False
        AlignTopWithPanel = False
        AlignVerticalCenterWithPanel = True
        LeftOf = PlanoBotonWin1
      end>
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 632
    DesignSize = (
      974
      38)
    object PlanoBotonWin1: TPlanoBotonWin
      AlignWithMargins = True
      Left = 808
      Top = 4
      Width = 146
      Height = 30
      Cursor = crHandPoint
      Margins.Right = 20
      Anchors = []
      Caption = 'Enviar a aprobaci'#243'n '
      TabOrder = 0
      StyleElements = []
      ColorOverride = 6044186
    end
    object PlanoBotonWin2: TPlanoBotonWin
      Left = 685
      Top = 4
      Width = 120
      Height = 30
      Cursor = crHandPoint
      Anchors = []
      Caption = 'Guardar borrador'
      TabOrder = 1
      StyleElements = []
      Kind = fkSecondary
    end
  end
  object tjCabecera: TPlanoTarjeta
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 974
    Height = 100
    Margins.Bottom = 8
    Caption = 'Datos de la cotizaci'#243'n'
    Align = alTop
    TabOrder = 1
    object lblCliente: TLabel
      Tag = 13
      Left = 16
      Top = 40
      Width = 33
      Height = 13
      Caption = 'Cliente'
    end
    object lblContacto: TLabel
      Tag = 13
      Left = 288
      Top = 40
      Width = 44
      Height = 13
      Caption = 'Contacto'
    end
    object lblTipo: TLabel
      Tag = 13
      Left = 500
      Top = 40
      Width = 73
      Height = 13
      Caption = 'Tipo de trabajo'
    end
    object lblFecha: TLabel
      Tag = 13
      Left = 692
      Top = 40
      Width = 29
      Height = 13
      Caption = 'Fecha'
    end
    object lblValidez: TLabel
      Tag = 13
      Left = 814
      Top = 40
      Width = 63
      Height = 13
      Caption = 'Validez (d'#237'as)'
    end
    object cboCliente: TComboBox
      Left = 16
      Top = 58
      Width = 260
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object cboContacto: TComboBox
      Left = 288
      Top = 58
      Width = 200
      Height = 21
      Style = csDropDownList
      TabOrder = 1
    end
    object cboTipo: TComboBox
      Left = 500
      Top = 58
      Width = 180
      Height = 21
      Style = csDropDownList
      TabOrder = 2
    end
    object dtpFecha: TDateTimePicker
      Left = 692
      Top = 58
      Width = 110
      Height = 23
      Date = 45900.000000000000000000
      Format = 'dd/MM/yyyy'
      Time = 45900.000000000000000000
      TabOrder = 3
    end
    object edtValidez: TEdit
      Left = 814
      Top = 58
      Width = 90
      Height = 21
      TabOrder = 4
      Text = '15'
    end
  end
end
