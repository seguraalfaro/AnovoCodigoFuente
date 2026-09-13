unit Anovo.Frames.ClienteDatos;

interface

uses
  Anovo.UI.Iconos,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  VclPlano.BotonWin, Vcl.ExtCtrls, Vcl.WinXCtrls, System.Actions, Vcl.ActnList,
  VclPlano.Pestanas, Vcl.WinXPanels, VclPlano.Tarjeta, Data.DB, Vcl.Grids,
  Vcl.DBGrids, rDBGrid, VclPlano.Pastilla;

type
  TFrame1 = class(TFrame)
    rpTitulo: TRelativePanel;
    PlanoBotonWin1: TPlanoBotonWin;
    ActionList1: TActionList;
    AcRegregsar: TAction;
    pstCliente: TPlanoPestanas;
    pnbottom: TRelativePanel;
    CardPanel1: TCardPanel;
    RelativePanel1: TRelativePanel;
    tjIdentificacion: TPlanoTarjeta;
    lblNombre: TLabel;
    valNombre: TLabel;
    lblIdentificacion: TLabel;
    valIdentificacion: TLabel;
    lblTelefono: TLabel;
    valTelefono: TLabel;
    lblCorreo: TLabel;
    valCorreo: TLabel;
    lblDireccion: TLabel;
    valDireccion: TLabel;
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
