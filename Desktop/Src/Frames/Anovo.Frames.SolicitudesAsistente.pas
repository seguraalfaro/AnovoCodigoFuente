unit Anovo.Frames.SolicitudesAsistente;

// Seccion Solicitudes del asistente y el supervisor: la cola comun
// de las sin procesar y las que cada uno tomo.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.WinXCtrls, Anovo.UI.PanelRelativo, Data.DB, Vcl.Grids, Vcl.DBGrids, rDBGrid,
  VclPlano.BotonWin, VclPlano.Pestanas,
  Anovo.Frames.Listado,
  Anovo.Frames.Cotizacion,
  Anovo.DTOs.Dashboard,
  Anovo.DTOs.Solicitudes,
  Anovo.Vistas.Intf.SolicitudesAsistente,
  Anovo.Presentadores.SolicitudesAsistente;

type
  TfraSolicitudesAsistente = class(TfraListado, IVistaSolicitudesAsistente)
    pstModo: TPlanoPestanas;
    procedure pstModoChange(Sender: TObject);
  private
    FPresentador: TPresentadorSolicitudesAsistente;
    procedure Accion(Sender: TObject; const AClave: string);
    procedure AbrirCotizacion(const AId: Integer);
    procedure CerrarCotizacion(Sender: TObject);
    procedure MostrarAcciones(const AAcciones: TAccionesCola);
    function Confirmar(const AMensaje: string): Boolean;
    procedure MostrarModo(const AModo: TModoSolicitudes);
    procedure MostrarCola(const AFilas: TObjectList<TSolicitudPorCotizarDTO>);
    procedure MostrarEnTrabajo(const AFilas
      : TObjectList<TSolicitudEnTrabajoDTO>);
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
  Anovo.UI.CeldasRejilla,
  Anovo.UI.Vista,
  Anovo.UI.Tema,
  Anovo.Api.Solicitudes,
  Anovo.Api.Cotizaciones,
  Anovo.Mapeo.Datos,
  Anovo.Datos.Memoria,
  Anovo.Textos;

const
  CAMPO_ACCIONES = 'ACCIONES';
  CAMPO_ESTADO = 'ESTADO';
  ACCIONES: array [TAccionCola] of TAccionRejilla = ((Clave: 'tomar';
    Rotulo: SAccionTomar), (Clave: 'abrir'; Rotulo: SAccionAbrir));


constructor TfraSolicitudesAsistente.Create(AOwner: TComponent);
var
  lRejilla: TCeldasRejilla;
begin
  inherited Create(AOwner);
  FTextoCargando := SCargandoSolicitudes;
  FTextoPaginacion := SPaginacionSolicitudes;

  lRejilla := TCeldasRejilla.De(grDatos);
  lRejilla.ColumnaEstado(CAMPO_ESTADO);
  lRejilla.ColumnaAcciones(CAMPO_ACCIONES);
  lRejilla.OnAccion := Accion;

  FPresentador := TPresentadorSolicitudesAsistente.Create(Self,
    TApiSolicitudes.Create, TApiCotizaciones.Create);
  FPresentador.Iniciar;
end;

destructor TfraSolicitudesAsistente.Destroy;
begin
  FreeAndNil(FPresentador);
  inherited;
end;

procedure TfraSolicitudesAsistente.Buscar(const ATexto: string);
begin
  FPresentador.Buscar(ATexto);
end;

procedure TfraSolicitudesAsistente.Limpiar;
begin
  FPresentador.Limpiar;
end;

procedure TfraSolicitudesAsistente.PaginaAnterior;
begin
  FPresentador.PaginaAnterior;
end;

procedure TfraSolicitudesAsistente.PaginaSiguiente;
begin
  FPresentador.PaginaSiguiente;
end;

procedure TfraSolicitudesAsistente.MostrarCargando(const AActivo: Boolean);
begin
  inherited;
  pstModo.Enabled := not AActivo;
end;

procedure TfraSolicitudesAsistente.MostrarModo(const AModo: TModoSolicitudes);
begin
  pstModo.ItemIndex := Ord(AModo);
  if AModo = msCola then
  begin
    FTextoSinRegistros := SSinCola;
    grDatos.DataSource := dmMemoria.dsSolicitudesCola;
  end
  else
  begin
    FTextoSinRegistros := SSinEnTrabajo;
    grDatos.DataSource := dmMemoria.dsSolicitudesEnTrabajo;
  end;
  TCeldasRejilla.De(grDatos).AjustarColumnas;
end;

procedure TfraSolicitudesAsistente.MostrarCola(const AFilas
  : TObjectList<TSolicitudPorCotizarDTO>);
begin
  TMapeoDatos.AListaTabla<TSolicitudPorCotizarDTO>(AFilas,
    dmMemoria.mtSolicitudesCola);
  TCeldasRejilla.De(grDatos).AjustarColumnas;
end;

procedure TfraSolicitudesAsistente.MostrarEnTrabajo(const AFilas
  : TObjectList<TSolicitudEnTrabajoDTO>);
begin
  TMapeoDatos.AListaTabla<TSolicitudEnTrabajoDTO>(AFilas,
    dmMemoria.mtSolicitudesEnTrabajo);
  TCeldasRejilla.De(grDatos).AjustarColumnas;
end;

procedure TfraSolicitudesAsistente.MostrarAcciones(const AAcciones
  : TAccionesCola);
begin
  TCeldasRejilla.De(grDatos).PonerAcciones<TAccionesCola>(ACCIONES, AAcciones);
end;

procedure TfraSolicitudesAsistente.Accion(Sender: TObject;
  const AClave: string);
begin
  if SameText(AClave, ACCIONES[acAbrir].Clave) then
  begin
    if not dmMemoria.mtSolicitudesEnTrabajo.IsEmpty then
      FPresentador.Abrir(dmMemoria.mtSolicitudesEnTrabajoID.AsInteger);
    Exit;
  end;
  if SameText(AClave, ACCIONES[acTomar].Clave) and
    not dmMemoria.mtSolicitudesCola.IsEmpty then
    FPresentador.Tomar(dmMemoria.mtSolicitudesColaID.AsInteger,
      dmMemoria.mtSolicitudesColaCLIENTE_NOMBRE.AsString);
end;

function TfraSolicitudesAsistente.Confirmar(const AMensaje: string): Boolean;
begin
  Result := Anovo.UI.Vista.Confirmar(AMensaje);
end;

procedure TfraSolicitudesAsistente.AbrirCotizacion(const AId: Integer);
var
  lCotizacion: TfraCotizacion;
begin
  lCotizacion := TfraCotizacion.Crear(Self, AId);
  lCotizacion.OnRegresar := CerrarCotizacion;
  MostrarEncima(lCotizacion);
end;

procedure TfraSolicitudesAsistente.CerrarCotizacion(Sender: TObject);
begin
  CerrarEncima(
    procedure
    begin
      FPresentador.Recargar;
    end);
end;

procedure TfraSolicitudesAsistente.pstModoChange(Sender: TObject);
begin
  if FPresentador = nil then
    Exit;
  FPresentador.CambiarModo(TModoSolicitudes(pstModo.ItemIndex));
end;

end.
