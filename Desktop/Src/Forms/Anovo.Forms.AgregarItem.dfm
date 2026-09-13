object frmAgregarItem: TfrmAgregarItem
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 387
  ClientWidth = 617
  Color = 16447477
  Font.Charset = ANSI_CHARSET
  Font.Color = 1973276
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Enabled = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  StyleElements = []
  PixelsPerInch = 96
  TextHeight = 15
  object CardPanel1: TCardPanel
    Left = 0
    Top = 0
    Width = 617
    Height = 329
    Align = alClient
    ActiveCard = Card2
    BevelOuter = bvNone
    Caption = 'CardPanel1'
    TabOrder = 0
    ExplicitLeft = 232
    ExplicitTop = 144
    ExplicitWidth = 300
    ExplicitHeight = 200
    object Card1: TCard
      Left = 0
      Top = 0
      Width = 617
      Height = 329
      Caption = 'Card1'
      CardIndex = 0
      TabOrder = 0
      ExplicitWidth = 185
      ExplicitHeight = 41
      object rpTrabajo: TRelativePanel
        Left = 0
        Top = 0
        Width = 617
        Height = 329
        Margins.Bottom = 1
        ControlCollection = <
          item
            Control = leCodigo
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control.Width = 39
            Control.Height = 15
            Control.Caption = 'C'#243'digo'
            Control.Font.Charset = ANSI_CHARSET
            Control.Font.Color = 1973276
            Control.Font.Height = -12
            Control.Font.Name = 'Segoe UI'
            Control.Font.Style = []
            Control.ParentFont = False
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = leNombretrabajo
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWith = leCodigo
            AlignVerticalCenterWithPanel = False
          end
          item
            Control.Width = 103
            Control.Height = 15
            Control.Caption = 'Nombre del trabajo'
            Control.Font.Charset = ANSI_CHARSET
            Control.Font.Color = 1973276
            Control.Font.Height = -12
            Control.Font.Name = 'Segoe UI'
            Control.Font.Style = []
            Control.ParentFont = False
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = rcEstado
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = Label2
            Above = rcEstado
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = rpTop
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = True
            AlignVerticalCenterWithPanel = False
          end>
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitTop = 6
        DesignSize = (
          617
          329)
        object leCodigo: TLabeledEdit
          AlignWithMargins = True
          Left = 20
          Top = 93
          Width = 137
          Height = 23
          Margins.Left = 20
          Anchors = []
          EditLabel.Width = 39
          EditLabel.Height = 15
          EditLabel.Caption = 'C'#243'digo'
          EditLabel.Font.Charset = ANSI_CHARSET
          EditLabel.Font.Color = 1973276
          EditLabel.Font.Height = -12
          EditLabel.Font.Name = 'Segoe UI'
          EditLabel.Font.Style = []
          EditLabel.ParentFont = False
          TabOrder = 0
        end
        object leNombretrabajo: TLabeledEdit
          AlignWithMargins = True
          Left = 196
          Top = 93
          Width = 405
          Height = 23
          Margins.Left = 20
          Anchors = []
          EditLabel.Width = 103
          EditLabel.Height = 15
          EditLabel.Caption = 'Nombre del trabajo'
          EditLabel.Font.Charset = ANSI_CHARSET
          EditLabel.Font.Color = 1973276
          EditLabel.Font.Height = -12
          EditLabel.Font.Name = 'Segoe UI'
          EditLabel.Font.Style = []
          EditLabel.ParentFont = False
          TabOrder = 1
        end
        object rcEstado: TrComboBoxEx
          AlignWithMargins = True
          Left = 20
          Top = 184
          Width = 145
          Height = 23
          Margins.Left = 20
          Anchors = []
          TabOrder = 2
          Text = 'rcEstado'
        end
        object Label2: TLabel
          AlignWithMargins = True
          Left = 20
          Top = 165
          Width = 35
          Height = 15
          Margins.Left = 20
          Margins.Bottom = 1
          Anchors = []
          Caption = 'Estado'
          StyleElements = [seFont, seBorder]
        end
        object rpTop: TRelativePanel
          Left = 0
          Top = 0
          Width = 651
          Height = 41
          ControlCollection = <
            item
              Control = Label1
              AlignBottomWithPanel = False
              AlignHorizontalCenterWithPanel = False
              AlignLeftWithPanel = True
              AlignRightWithPanel = False
              AlignTopWithPanel = False
              AlignVerticalCenterWithPanel = True
            end>
          Align = alTop
          BevelOuter = bvNone
          Color = 6044186
          ParentBackground = False
          TabOrder = 3
          StyleElements = []
          DesignSize = (
            651
            41)
          object Label1: TLabel
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 147
            Height = 20
            Margins.Left = 10
            Anchors = []
            Caption = 'Nuevo tipo de trabajo'
            Color = clWhite
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = 20
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            StyleElements = []
          end
        end
      end
    end
    object Card2: TCard
      Left = 0
      Top = 0
      Width = 617
      Height = 329
      Caption = 'Card2'
      CardIndex = 1
      TabOrder = 1
      ExplicitWidth = 185
      ExplicitHeight = 41
      object rpPrecio: TRelativePanel
        Left = 0
        Top = 0
        Width = 617
        Height = 329
        ControlCollection = <
          item
            Control = RelativePanel1
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = True
            AlignRightWithPanel = True
            AlignTopWithPanel = True
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = Label4
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = LabeledEdit2
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control.Width = 123
            Control.Height = 15
            Control.Caption = 'Precio unitario (cliente)'
            Control.Font.Charset = ANSI_CHARSET
            Control.Font.Color = 1973276
            Control.Font.Height = -12
            Control.Font.Name = 'Segoe UI'
            Control.Font.Style = []
            Control.ParentFont = False
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = LabeledEdit1
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control.Width = 124
            Control.Height = 15
            Control.Caption = 'Costo unitario (interno)'
            Control.Font.Charset = ANSI_CHARSET
            Control.Font.Color = 1973276
            Control.Font.Height = -12
            Control.Font.Name = 'Segoe UI'
            Control.Font.Style = []
            Control.ParentFont = False
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = DateTimePicker1
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = Label5
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end
          item
            Control = PlanoPastilla1
            AlignBottomWithPanel = False
            AlignHorizontalCenterWithPanel = False
            AlignLeftWithPanel = False
            AlignRightWithPanel = False
            AlignTopWithPanel = False
            AlignVerticalCenterWithPanel = False
          end>
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitTop = 4
        DesignSize = (
          617
          329)
        object RelativePanel1: TRelativePanel
          Left = 0
          Top = 0
          Width = 617
          Height = 41
          ControlCollection = <
            item
              Control = Label3
              AlignBottomWithPanel = False
              AlignHorizontalCenterWithPanel = False
              AlignLeftWithPanel = True
              AlignRightWithPanel = False
              AlignTopWithPanel = False
              AlignVerticalCenterWithPanel = True
            end>
          Align = alTop
          BevelOuter = bvNone
          Color = 6044186
          ParentBackground = False
          TabOrder = 0
          StyleElements = []
          DesignSize = (
            617
            41)
          object Label3: TLabel
            AlignWithMargins = True
            Left = 10
            Top = 10
            Width = 149
            Height = 20
            Margins.Left = 10
            Anchors = []
            Caption = 'Registrar precio nuevo'
            Color = clWhite
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = 20
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            StyleElements = []
          end
        end
        object Label4: TLabel
          AlignWithMargins = True
          Left = 28
          Top = 173
          Width = 79
          Height = 15
          Margins.Left = 20
          Margins.Bottom = 1
          Anchors = []
          Caption = 'Rige a partir de'
          StyleElements = [seFont, seBorder]
        end
        object LabeledEdit2: TLabeledEdit
          AlignWithMargins = True
          Left = 324
          Top = 101
          Width = 220
          Height = 23
          Margins.Left = 20
          Anchors = []
          EditLabel.Width = 123
          EditLabel.Height = 15
          EditLabel.Caption = 'Precio unitario (cliente)'
          EditLabel.Font.Charset = ANSI_CHARSET
          EditLabel.Font.Color = 1973276
          EditLabel.Font.Height = -12
          EditLabel.Font.Name = 'Segoe UI'
          EditLabel.Font.Style = []
          EditLabel.ParentFont = False
          TabOrder = 1
        end
        object LabeledEdit1: TLabeledEdit
          AlignWithMargins = True
          Left = 28
          Top = 101
          Width = 220
          Height = 23
          Margins.Left = 20
          Anchors = []
          EditLabel.Width = 124
          EditLabel.Height = 15
          EditLabel.Caption = 'Costo unitario (interno)'
          EditLabel.Font.Charset = ANSI_CHARSET
          EditLabel.Font.Color = 1973276
          EditLabel.Font.Height = -12
          EditLabel.Font.Name = 'Segoe UI'
          EditLabel.Font.Style = []
          EditLabel.ParentFont = False
          TabOrder = 2
        end
        object DateTimePicker1: TDateTimePicker
          Left = 28
          Top = 192
          Width = 220
          Height = 23
          Anchors = []
          Date = 46278.000000000000000000
          Time = 0.407199745372054200
          TabOrder = 3
        end
        object Label5: TLabel
          AlignWithMargins = True
          Left = 324
          Top = 173
          Width = 96
          Height = 15
          Margins.Left = 20
          Margins.Bottom = 1
          Anchors = []
          Caption = 'Margen resultante'
          StyleElements = [seFont, seBorder]
        end
        object PlanoPastilla1: TPlanoPastilla
          Left = 324
          Top = 192
          Width = 96
          Height = 22
          Status = fsSuccess
          AutoWidth = False
          Anchors = []
          Caption = '0  %'
        end
      end
    end
    object Card3: TCard
      Left = 0
      Top = 0
      Width = 617
      Height = 329
      Caption = 'Card3'
      CardIndex = 2
      TabOrder = 2
      ExplicitWidth = 185
      ExplicitHeight = 41
    end
  end
  object rpBotton: TRelativePanel
    Left = 0
    Top = 329
    Width = 617
    Height = 58
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
    TabOrder = 1
    ExplicitTop = 280
    ExplicitWidth = 651
    DesignSize = (
      617
      58)
    object PlanoBotonWin1: TPlanoBotonWin
      AlignWithMargins = True
      Left = 477
      Top = 10
      Width = 120
      Height = 38
      Cursor = crHandPoint
      Margins.Right = 20
      Anchors = []
      Caption = 'Guardar'
      TabOrder = 0
      StyleElements = []
    end
    object PlanoBotonWin2: TPlanoBotonWin
      AlignWithMargins = True
      Left = 351
      Top = 10
      Width = 120
      Height = 38
      Cursor = crHandPoint
      Anchors = []
      Caption = 'Cancelar'
      TabOrder = 1
      StyleElements = []
      Kind = fkSecondary
    end
  end
end
