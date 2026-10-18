unit Anovo.Presentadores.ClienteDatos;

// Presentador de la ficha del cliente: cada pestana
// carga sus datos la primera vez que se abre.

interface

uses
  Anovo.Api.Intf.Clientes,
  Anovo.Api.Intf.Cotizaciones,
  Anovo.Presentadores.Base,
  Anovo.DTOs.Clientes,
  Anovo.Vistas.Intf.ClienteDatos,
  Anovo.PeriodoBusqueda,
  Anovo.Permisos;

type
  TPresentadorClienteDatos = class(TPresentadorBase)
  private
    FVista: IVistaClienteDatos;
    FApi: IApiClientes;
    FApiCotizaciones: IApiCotizaciones;
    FTextoCotizaciones: string;
    FEstadoCotizaciones: string;
    FPeriodoCotizaciones: TPeriodoBusqueda;
    FClienteId: Integer;
    FCargadas: set of TPestanaCliente;
    FPersonaFisica: Boolean;
    FAnonimizado: Boolean;
    procedure CargarDatosCliente;
    procedure CargarContactos;
    procedure CargarConsentimientos;
    procedure CargarCotizaciones;
    procedure MostrarUbicacion(const ACliente: TClienteDTO);
    procedure MostrarError(AMensaje: string);
    procedure MostrarCargando(AActivo: Boolean);
  public
    constructor Create(const AVista: IVistaClienteDatos;
      const AApi: IApiClientes; const AApiCotizaciones: IApiCotizaciones;
      const AClienteId: Integer);
    procedure BuscarCotizaciones(const ATexto: string);
    procedure FiltrarCotizaciones(const AFiltro: Integer);
    procedure FiltrarPeriodoCotizaciones(const APeriodo: TPeriodoBusqueda);
    procedure VerCotizacion(const AId: Integer);
    procedure Iniciar;
    procedure AbrirPestana(const APestana: TPestanaCliente);
    procedure Refrescar(const APestana: TPestanaCliente);
    procedure Guardar(const ADto: TClienteEdicionDTO);
    procedure Anonimizar;
    procedure AnonimizarContacto(const AContactoId: Integer;
      const ANombre: string);
    class function PuedeEditar: Boolean;
    class function PuedeAnonimizar: Boolean;
    class function PuedeRevocar: Boolean;
    class function PuedeVerCotizaciones: Boolean;
    class function AccionesContacto: TAccionesContacto;
    class function AccionesCotizacion: TAccionesCotizacionCliente;
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.Formato,
  Anovo.Sesion,
  Anovo.Textos,
  Anovo.DTOs.Cotizaciones,
  Anovo.Mensajes;

const
  COTIZACIONES_DEL_CLIENTE = 200;
  ESTADOS_COTIZACION: array [0 .. 3] of string = ('', 'aprobada', 'enviada',
    'rechazada');

const
  TIPO_IDENT_FISICA = 1;
  TIPO_IDENT_DIMEX = 3;
  URL_MAPA = 'https://www.google.com/maps/search/?api=1&query=%s';

procedure TPresentadorClienteDatos.MostrarUbicacion(const ACliente
  : TClienteDTO);
var
  lCoordenadas: string;
begin
  if not ACliente.Latitud.HasValue or not ACliente.Longitud.HasValue then
  begin
    FVista.MostrarUbicacion(SSinUbicacion, '');
    Exit;
  end;
  lCoordenadas := TFormato.Coordenadas(ACliente.Latitud.Value,
    ACliente.Longitud.Value);
  FVista.MostrarUbicacion(lCoordenadas, Format(URL_MAPA,
    [StringReplace(lCoordenadas, ' ', '', [rfReplaceAll])]));
end;

function TextoRecogido(const ALista: TObjectList<TConsentimientoDTO>): string;
var
  lPrimera: TConsentimientoDTO;
begin
  if ALista.Count = 0 then
    Exit(SSinDato);
  lPrimera := ALista.First;
  Result := lPrimera.FirmanteNombre.ValueOrElse(SSinDato);
  if lPrimera.Origen.HasValue and (lPrimera.Origen.Value <> '') then
    Result := Format(SNombreConDetalle, [Result, lPrimera.Origen.Value]);
end;

constructor TPresentadorClienteDatos.Create(const AVista: IVistaClienteDatos;
  const AApi: IApiClientes; const AApiCotizaciones: IApiCotizaciones;
  const AClienteId: Integer);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FApiCotizaciones := AApiCotizaciones;
  FClienteId := AClienteId;
  FPeriodoCotizaciones := TPeriodoBusqueda.De(apTodas);
end;

class function TPresentadorClienteDatos.PuedeEditar: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_CLIENTES_EDITAR);
end;

class function TPresentadorClienteDatos.PuedeAnonimizar: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_CLIENTES_INACTIVAR);
end;

class function TPresentadorClienteDatos.PuedeRevocar: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_CLIENTES_CONSENTIMIENTO);
end;

class function TPresentadorClienteDatos.PuedeVerCotizaciones: Boolean;
begin
  Result := TSesion.TieneAlguno([PERMISO_COTIZACIONES_VER_TODAS,
    PERMISO_COTIZACIONES_VER_APROBADAS_PROPIAS]);
end;

class function TPresentadorClienteDatos.AccionesContacto: TAccionesContacto;
begin
  Result := [];
  if PuedeEditar then
    Result := [acoEditar, acoQuitar];
  if PuedeAnonimizar then
    Include(Result, acoAnonimizar);
end;

class function TPresentadorClienteDatos.AccionesCotizacion
  : TAccionesCotizacionCliente;
begin
  Result := [];
  if PuedeVerCotizaciones then
    Result := [accVer];
end;

procedure TPresentadorClienteDatos.Iniciar;
begin
  FVista.MostrarAcciones(PuedeEditar, PuedeRevocar, PuedeVerCotizaciones,
    AccionesContacto, AccionesCotizacion);
  FVista.MostrarPeriodoCotizaciones(FPeriodoCotizaciones);
  AbrirPestana(pcDatos);
end;

procedure TPresentadorClienteDatos.AbrirPestana(const APestana
  : TPestanaCliente);
begin
  if APestana in FCargadas then
    Exit;
  Refrescar(APestana);
end;

procedure TPresentadorClienteDatos.Refrescar(const APestana: TPestanaCliente);
begin
  Include(FCargadas, APestana);
  case APestana of
    pcDatos:
      CargarDatosCliente;
    pcContactos:
      CargarContactos;
    pcConsentimiento:
      CargarConsentimientos;
    pcCotizaciones:
      CargarCotizaciones;
  end;
end;

procedure TPresentadorClienteDatos.CargarCotizaciones;
var
  lApi: IApiCotizaciones;
  lTexto, lEstado: string;
  lClienteId: Integer;
  lDesde, lHasta: TDateTime;
  lTotal: Int64;
begin
  lApi := FApiCotizaciones;
  lDesde := FPeriodoCotizaciones.Desde;
  lHasta := FPeriodoCotizaciones.Hasta;
  lTexto := FTextoCotizaciones;
  lEstado := FEstadoCotizaciones;
  lClienteId := FClienteId;
  lTotal := 0;

  EjecutarUltima<TObjectList<TCotizacionDTO>>(SAccionCargarCotizaciones,
    function: TObjectList<TCotizacionDTO>
    begin
      Result := lApi.Listar(lTexto, lEstado, lClienteId, lDesde, lHasta, 1,
        COTIZACIONES_DEL_CLIENTE, lTotal);
    end,
    procedure(ALista: TObjectList<TCotizacionDTO>)
    begin
      FVista.MostrarCotizaciones(ALista);
    end, MostrarError, MostrarCargando);
end;

procedure TPresentadorClienteDatos.BuscarCotizaciones(const ATexto: string);
begin
  FTextoCotizaciones := Trim(ATexto);
  CargarCotizaciones;
end;

procedure TPresentadorClienteDatos.FiltrarCotizaciones(const AFiltro: Integer);
begin
  if (AFiltro < Low(ESTADOS_COTIZACION)) or
    (AFiltro > High(ESTADOS_COTIZACION)) then
    Exit;
  FEstadoCotizaciones := ESTADOS_COTIZACION[AFiltro];
  CargarCotizaciones;
end;

procedure TPresentadorClienteDatos.FiltrarPeriodoCotizaciones
  (const APeriodo: TPeriodoBusqueda);
var
  lMensaje: string;
begin
  if not APeriodo.Validar(lMensaje) then
  begin
    FVista.MostrarError(lMensaje);
    FVista.MostrarPeriodoCotizaciones(FPeriodoCotizaciones);
    Exit;
  end;
  FPeriodoCotizaciones := APeriodo;
  CargarCotizaciones;
end;

procedure TPresentadorClienteDatos.VerCotizacion(const AId: Integer);
begin
  if AId > 0 then
    PedirCotizacion(AId);
end;

procedure TPresentadorClienteDatos.MostrarError(AMensaje: string);
begin
  FVista.MostrarError(AMensaje);
end;

procedure TPresentadorClienteDatos.MostrarCargando(AActivo: Boolean);
begin
  FVista.MostrarCargando(AActivo);
end;

procedure TPresentadorClienteDatos.Guardar(const ADto: TClienteEdicionDTO);
var
  lApi: IApiClientes;
  lId: Integer;
begin
  lApi := FApi;
  lId := FClienteId;

  Ejecutar(SAccionGuardar,
    procedure
    begin
      lApi.Actualizar(lId, ADto);
    end,
    procedure
    begin
      FVista.MostrarModoEdicion(False);
      Refrescar(pcDatos);
    end, MostrarError, MostrarCargando,
    procedure
    begin
      ADto.Free;
    end);
end;

procedure TPresentadorClienteDatos.Anonimizar;
var
  lApi: IApiClientes;
  lId: Integer;
  lMotivo: string;
begin
  if not PuedeAnonimizar or FAnonimizado or not FPersonaFisica then
    Exit;
  if not FVista.PedirMotivoAnonimizacion(lMotivo) then
    Exit;

  lApi := FApi;
  lId := FClienteId;

  Ejecutar(SAccionAnonimizar,
    procedure
    begin
      lApi.Anonimizar(lId, lMotivo);
    end,
    procedure
    begin
      Refrescar(pcDatos);
      if pcContactos in FCargadas then
        Refrescar(pcContactos);
    end, MostrarError, MostrarCargando);
end;

procedure TPresentadorClienteDatos.AnonimizarContacto(const AContactoId: Integer;
  const ANombre: string);
var
  lApi: IApiClientes;
  lId: Integer;
  lMotivo: string;
begin
  if not PuedeAnonimizar or (AContactoId = 0) then
    Exit;
  if not FVista.PedirMotivoContacto(ANombre, lMotivo) then
    Exit;

  lApi := FApi;
  lId := FClienteId;

  Ejecutar(SAccionAnonimizarContacto,
    procedure
    begin
      lApi.AnonimizarContacto(lId, AContactoId, lMotivo);
    end,
    procedure
    begin
      Refrescar(pcContactos);
    end, MostrarError, MostrarCargando);
end;

procedure TPresentadorClienteDatos.CargarDatosCliente;
var
  lApi: IApiClientes;
  lId: Integer;
begin
  lApi := FApi;
  lId := FClienteId;

  Ejecutar<TClienteDTO>(SAccionCargarFichaCliente,
    function: TClienteDTO
    begin
      Result := lApi.Obtener(lId);
    end,
    procedure(ACliente: TClienteDTO)
    begin
      FPersonaFisica := ACliente.TipoIdentificacion.HasValue and
        ((ACliente.TipoIdentificacion.Value = TIPO_IDENT_FISICA) or
        (ACliente.TipoIdentificacion.Value = TIPO_IDENT_DIMEX));
      FAnonimizado := ACliente.Anonimizado;
      FVista.MostrarCliente(ACliente);
      MostrarUbicacion(ACliente);
      FVista.MostrarAnonimizacion(PuedeAnonimizar,
        FPersonaFisica and not FAnonimizado);
    end, MostrarError, MostrarCargando);
end;

procedure TPresentadorClienteDatos.CargarContactos;
var
  lApi: IApiClientes;
  lId: Integer;
begin
  lApi := FApi;
  lId := FClienteId;

  Ejecutar<TObjectList<TContactoDTO>>(SAccionCargarFichaCliente,
    function: TObjectList<TContactoDTO>
    begin
      Result := lApi.Contactos(lId);
    end,
    procedure(ALista: TObjectList<TContactoDTO>)
    begin
      FVista.MostrarContactos(ALista);
    end, MostrarError, MostrarCargando);
end;

procedure TPresentadorClienteDatos.CargarConsentimientos;
var
  lApi: IApiClientes;
  lId: Integer;
begin
  lApi := FApi;
  lId := FClienteId;

  Ejecutar<TObjectList<TConsentimientoDTO>>(SAccionCargarFichaCliente,
    function: TObjectList<TConsentimientoDTO>
    begin
      Result := lApi.Consentimientos(lId);
    end,
    procedure(ALista: TObjectList<TConsentimientoDTO>)
    begin
      FVista.MostrarConsentimientos(ALista, TextoRecogido(ALista));
    end, MostrarError, MostrarCargando);
end;

end.
