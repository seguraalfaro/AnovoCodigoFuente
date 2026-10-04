unit Anovo.Frames.Clientes;

// Seccion Clientes: listado y ficha del cliente.

interface

uses
  Anovo.UI.Tema,
  Anovo.UI.DBGridExtend,
  System.UITypes,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Types, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  VclPlano.BotonWin, Vcl.WinXCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.Pestanas,
  Anovo.Frames.Listado,
  Anovo.DTOs.Clientes,
  Anovo.Forms.ClienteNuevo,
  Anovo.Frames.ClienteDatos,
  Anovo.Vistas.Intf.Clientes,
  Anovo.Presentadores.Clientes;

type
  TfraClientes = class(TfraListado, IVistaClientes)
    btnExportar: TPlanoBotonWin;
    btnNuevo: TPlanoBotonWin;
    pstFiltros: TPlanoPestanas;
    procedure pstFiltrosChange(Sender: TObject);
    procedure btnNuevoClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
  private
    FPresentador: TPresentadorClientes;
    FDetalle: TfraClienteDatos;
    procedure CerrarDetalle(Sender: TObject);
    procedure Accion(Sender: TObject; const AClave: string);
    procedure MostrarAcciones(const AAcciones: TAccionesCliente;
      const APuedeCrear: Boolean);
    procedure MostrarClientes(const AClientes: TObjectList<TClienteDTO>);
    procedure MostrarDetalle(const AId: Integer);
    procedure MostrarListado;
  protected
    procedure Buscar(const ATexto: string); override;
    procedure Limpiar; override;
    procedure PaginaAnterior; override;
    procedure PaginaSiguiente; override;
    procedure MostrarCargando(const AActivo: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  rDBExport,
  Anovo.Api.Clientes,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

const
  CAMPO_ACCIONES = 'ACCIONES';
  CAMPO_CONSENTIMIENTO = 'CONSENTIMIENTO_ESTADO';

  ACCIONES: array [TAccionCliente] of TAccionRejilla = ((Clave: 'detalles';
    Rotulo: SAccionDetalles));

constructor TfraClientes.Create(AOwner: TComponent);
var
  lRejilla: TDBGridExtend;
begin
  inherited Create(AOwner);
  FTextoCargando := SCargandoClientes;
  FTextoSinRegistros := SSinClientes;
  FTextoPaginacion := SPaginacionClientes;

  lRejilla := TDBGridExtend.De(grDatos);
  lRejilla.ColumnaEstado(CAMPO_CONSENTIMIENTO);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := Accion;

  FPresentador := TPresentadorClientes.Create(Self, TApiClientes.Create);
  FPresentador.Iniciar;
end;

destructor TfraClientes.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraClientes.Buscar(const ATexto: string);
begin
  FPresentador.Buscar(ATexto);
end;

procedure TfraClientes.Limpiar;
begin
  FPresentador.Limpiar;
end;

procedure TfraClientes.PaginaAnterior;
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraClientes.PaginaSiguiente;
begin
  FPresentador.PaginaSiguiente;
end;

procedure TfraClientes.MostrarAcciones(const AAcciones: TAccionesCliente;
  const APuedeCrear: Boolean);
begin
  btnNuevo.Visible := APuedeCrear;
  TDBGridExtend.De(grDatos).PonerAcciones<TAccionesCliente>(ACCIONES,
    AAcciones);
end;

procedure TfraClientes.MostrarCargando(const AActivo: Boolean);
begin
  inherited;
  pstFiltros.Enabled := not AActivo;
end;

procedure TfraClientes.MostrarClientes(const AClientes
  : TObjectList<TClienteDTO>);
begin
  TMapeoDatos.AListaTabla<TClienteDTO>(AClientes, dmMemoria.mtClientes);
end;

procedure TfraClientes.Accion(Sender: TObject; const AClave: string);
begin
  if dmMemoria.mtClientes.IsEmpty then
    Exit;
  if SameText(AClave, ACCIONES[acDetalles].Clave) then
    FPresentador.VerDetalle(dmMemoria.mtClientesID.AsInteger);
end;

procedure TfraClientes.MostrarDetalle(const AId: Integer);
begin
  FreeAndNil(FDetalle);
  FDetalle := TfraClienteDatos.Crear(Self, AId);
  FDetalle.OnRegresar := CerrarDetalle;
  FDetalle.Parent := Self;
  FDetalle.SetBounds(0, 0, ClientWidth, ClientHeight);
  FDetalle.Anchors := [akLeft, akTop, akRight, akBottom];
  FDetalle.BringToFront;
  AplicarTemaFrame(FDetalle);
end;

procedure TfraClientes.CerrarDetalle(Sender: TObject);
begin
  FPresentador.VolverAlListado;
end;

procedure TfraClientes.MostrarListado;
begin
  if Assigned(FDetalle) then
    FDetalle.Visible := False;
end;

procedure TfraClientes.pstFiltrosChange(Sender: TObject);
begin
  if FPresentador = nil then
    Exit;
  FPresentador.Filtrar(TFiltroConsentimiento(pstFiltros.ItemIndex));
end;

procedure TfraClientes.btnExportarClick(Sender: TObject);
begin
  rDBExport.DBExport(grDatos, True, True);
end;

procedure TfraClientes.btnNuevoClick(Sender: TObject);
var
  lVentana: TfrmClienteNuevo;
begin
  lVentana := TfrmClienteNuevo.Create(Self);
  try
    if lVentana.ShowModal = mrOk then
      FPresentador.Buscar(sbBuscar.Text);
  finally
    lVentana.Free;
  end;
end;

end.
