unit Anovo.Forms.AgregarItem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXPanels, Vcl.WinXCtrls, VclPlano.Tarjeta, VclPlano.BotonWin,
  rImprovedComps, Vcl.ComCtrls, VclPlano.Pastilla;

type
  TfrmAgregarItem = class(TForm)
    CardPanel1: TCardPanel;
    Card1: TCard;
    rpBotton: TRelativePanel;
    PlanoBotonWin1: TPlanoBotonWin;
    PlanoBotonWin2: TPlanoBotonWin;
    rpTrabajo: TRelativePanel;
    leCodigo: TLabeledEdit;
    leNombretrabajo: TLabeledEdit;
    rcEstado: TrComboBoxEx;
    Label2: TLabel;
    rpTop: TRelativePanel;
    Label1: TLabel;
    Card2: TCard;
    Card3: TCard;
    rpPrecio: TRelativePanel;
    RelativePanel1: TRelativePanel;
    Label3: TLabel;
    Label4: TLabel;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit1: TLabeledEdit;
    DateTimePicker1: TDateTimePicker;
    Label5: TLabel;
    PlanoPastilla1: TPlanoPastilla;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAgregarItem: TfrmAgregarItem;

implementation

{$R *.dfm}

procedure TfrmAgregarItem.Button1Click(Sender: TObject);
begin
close
end;

end.
