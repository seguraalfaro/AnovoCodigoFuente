unit Anovo.Presentadores.ClienteDatos;

// Presentador de la ficha del cliente: cada pestana
// carga sus datos la primera vez que se abre.

interface

uses
  Anovo.Api.Intf.Clientes,
  Anovo.Presentadores.Base,
  Anovo.DTOs.Clientes,
  Anovo.Vistas.Intf.ClienteDatos,
  Anovo.Permisos;

type
  TPresentadorClienteDatos = class(TPresentadorBase)
  private
    FVista: IVistaClienteDatos;
    FApi: IApiClientes;
    FClienteId: Integer;
    FCargadas: set of TPestanaCliente;
    FPersonaFisica: Boolean;
    FAnonimizado: Boolean;
    procedure CargarDatosCliente;
    procedure CargarContactos;
    procedure CargarConsentimientos;
    procedure MostrarError(AMensaje: string);
    procedure MostrarCargando(AActivo: Boolean);
  public
    constructor Create(const AVista: IVistaClienteDatos;
      const AApi: IApiClientes; const AClienteId: Integer);
    procedure Iniciar;
    procedure AbrirPestana(const APestana: TPestanaCliente);
    procedure Refrescar(const APestana: TPestanaCliente);
    procedure Guardar(const ADto: TClienteEdicionDTO);
    procedure Anonimizar;
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
  Anovo.Sesion,
  Anovo.Textos;

const
  TIPO_IDENT_FISICA = 1;
  TIPO_IDENT_DIMEX = 3;

constructor TPresentadorClienteDatos.Create(const AVista: IVistaClienteDatos;
  const AApi: IApiClientes; const AClienteId: Integer);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FClienteId := AClienteId;
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
      ;
  end;
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
      FVista.MostrarConsentimientos(ALista);
    end, MostrarError, MostrarCargando);
end;

end.
