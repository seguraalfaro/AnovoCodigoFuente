unit Anovo.Frames.ClienteDatos;

// Ficha del cliente: datos, contactos, consentimiento y cotizaciones, una
// pestana cada uno. La abre el listado de clientes encima de si mismo.
//
// Regresar no se cierra solo: avisa con OnRegresar y el listado decide. Un
// frame no puede liberarse dentro de su propio evento.

interface

uses
  Anovo.UI.Iconos,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  VclPlano.BotonWin, Vcl.ExtCtrls, Vcl.WinXCtrls, System.Actions, Vcl.ActnList,
  VclPlano.Pestanas, Vcl.WinXPanels, VclPlano.Tarjeta, Data.DB, Vcl.Grids,
  Vcl.DBGrids, rDBGrid, VclPlano.Pastilla, Vcl.Mask, Vcl.DBCtrls, rDBComponents;

type
  TfraClienteDatos = class(TFrame)
    rpTitulo: TRelativePanel;
    PlanoBotonWin1: TPlanoBotonWin;
    ActionList1: TActionList;
    AcRegregsar: TAction;
    pstCliente: TPlanoPestanas;
    pnbottom: TRelativePanel;
    CardPanel1: TCardPanel;
    RelativePanel1: TRelativePanel;
    tjIdentificacion: TPlanoTarjeta;
    tjUbicacion: TPlanoTarjeta;
    lblRegimen: TLabel;
    valRegimen: TLabel;
    lblExoneracion: TLabel;
    valExoneracion: TLabel;
    lblLatitud: TLabel;
    valLatitud: TLabel;
    lblLongitud: TLabel;
    valLongitud: TLabel;
    lblAvisoUbicacion: TLabel;
    pnlBarra: TPanel;
    sbBuscar: TSearchBox;
    btnNuevo: TPlanoBotonWin;
    pnclient: TRelativePanel;
    grDatos: TrDBGrid;
    rpClient: TRelativePanel;
    tjVigente: TPlanoTarjeta;
    lblVersion: TLabel;
    valVersion: TLabel;
    lblOtorgado: TLabel;
    valOtorgado: TLabel;
    lblRecogido: TLabel;
    valRecogido: TLabel;
    pstEstado: TPlanoPastilla;
    btnRevocar: TPlanoBotonWin;
    tjHistorial: TPlanoTarjeta;
    pnlHistorial: TPanel;
    grHistorial: TrDBGrid;
    RelativePanel2: TRelativePanel;
    Panel1: TPanel;
    SearchBox1: TSearchBox;
    btnExportar: TPlanoBotonWin;
    pstFiltros: TPlanoPestanas;
    rpdatos: TRelativePanel;
    rDBGrid1: TrDBGrid;
    rDBEdit1: TrDBEdit;
    rDBEdit2: TrDBEdit;
    rDBEdit3: TrDBEdit;
    rDBEdit4: TrDBEdit;
    rDBEdit5: TrDBEdit;
    procedure AcRegregsarExecute(Sender: TObject);
  private
    FOnRegresar: TNotifyEvent;
  public
    property OnRegresar: TNotifyEvent read FOnRegresar write FOnRegresar;
  end;

implementation

{$R *.dfm}

uses
  Anovo.Datos.Memoria;

procedure TfraClienteDatos.AcRegregsarExecute(Sender: TObject);
begin
  if Assigned(FOnRegresar) then
    FOnRegresar(Self);
end;

end.
