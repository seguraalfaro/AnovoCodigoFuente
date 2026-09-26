unit Anovo.Presentadores.ClienteDatos;

// La logica de la ficha del cliente, fuera del frame.
//
// Cada pestana pide sus datos la primera vez que se abre, no al entrar: quien
// solo quiere ver el telefono no espera por los contactos ni por el historial.
//
// Mismas dos trampas que el listado, y se resuelven igual: el frame se puede
// destruir mientras una respuesta viene en camino -el destructor cancela-, y
// dos peticiones pueden volver en otro orden -solo se muestra la ultima-.

interface

uses
  Anovo.Api.Intf.Clientes,
  Anovo.Cancelacion,
  Anovo.DTOs.Clientes,
  Anovo.Vistas.Intf.ClienteDatos;

type
  TPresentadorClienteDatos = class
  private
    FVista: IVistaClienteDatos;
    FApi: IApiClientes;
    FCancelacion: ICancelacion;
    FClienteId: Integer;
    FSolicitud: Integer;

    FCargadas: set of TPestanaCliente;
    procedure CargarDatosCliente;
    procedure CargarContactos;
    procedure CargarConsentimientos;
  public
    constructor Create(const AVista: IVistaClienteDatos;
      const AApi: IApiClientes; const AClienteId: Integer);
    destructor Destroy; override;
    procedure Iniciar;
    procedure AbrirPestana(const APestana: TPestanaCliente);
    // Vuelve a pedir lo de una pestana: despues de editar o de revocar.
    procedure Refrescar(const APestana: TPestanaCliente);
    // El DTO lo arma la vista desde la tabla y lo libera el presentador.
    procedure Guardar(const ADto: TClienteEdicionDTO);
    // No tocan la vista: se prueban asignando permisos a TSesion.
    class function PuedeEditar: Boolean;
    class function PuedeRevocar: Boolean;
    class function PuedeVerCotizaciones: Boolean;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.Sesion,
  Anovo.Textos;

// La frase completa vive en Anovo.Textos. Aqui solo se dice de que accion
// se habla, que es lo unico que cambia de una pantalla a otra.
function MensajeInesperado: string;
begin
  Result := Format(SErrorInesperado, [SAccionCargarFichaCliente]);
end;

constructor TPresentadorClienteDatos.Create(const AVista: IVistaClienteDatos;
  const AApi: IApiClientes; const AClienteId: Integer);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FClienteId := AClienteId;
  FCancelacion := TCancelacion.Create;
end;

destructor TPresentadorClienteDatos.Destroy;
begin

  FCancelacion.Cancelar;
  inherited;
end;

class function TPresentadorClienteDatos.PuedeEditar: Boolean;
begin
  Result := TSesion.Tiene('clientes.editar');
end;

class function TPresentadorClienteDatos.PuedeRevocar: Boolean;
begin
  Result := TSesion.Tiene('clientes.consentimiento');
end;

class function TPresentadorClienteDatos.PuedeVerCotizaciones: Boolean;
begin

  Result := TSesion.TieneAlguno(['cotizaciones.ver_todas',
    'cotizaciones.ver_aprobadas_propias']);
end;

procedure TPresentadorClienteDatos.Iniciar;
begin
  FVista.MostrarAcciones(PuedeEditar, PuedeRevocar, PuedeVerCotizaciones);
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

procedure TPresentadorClienteDatos.Guardar(const ADto: TClienteEdicionDTO);
var
  lCancelacion: ICancelacion;
  lApi: IApiClientes;
  lId: Integer;
begin
  lCancelacion := FCancelacion;
  lApi := FApi;
  lId := FClienteId;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lError: string;
    begin
      lError := '';
      try
        try
          lApi.Actualizar(lId, ADto);
        except

          on E: EAnovoCliente do
            lError := E.Message;
          on E: Exception do
            lError := MensajeInesperado;
        end;
      finally
        ADto.Free;
      end;

      TThread.Queue(nil,
        procedure
        begin
          if lCancelacion.Cancelada then
            Exit;

          FVista.MostrarCargando(False);
          if not lError.IsEmpty then
          begin

            FVista.MostrarError(lError);
            Exit;
          end;

          FVista.MostrarModoEdicion(False);

          Refrescar(pcDatos);
        end);
    end);
end;

procedure TPresentadorClienteDatos.CargarDatosCliente;
var
  lCancelacion: ICancelacion;
  lApi: IApiClientes;
  lId, lNumero: Integer;
begin

  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lId := FClienteId;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lCliente: TClienteDTO;
      lError: string;
    begin
      lCliente := nil;
      lError := '';
      try
        lCliente := lApi.Obtener(lId);
      except
        on E: EAnovoCliente do
          lError := E.Message;

        on E: Exception do
          lError := MensajeInesperado;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try

            if lCancelacion.Cancelada or (lNumero <> FSolicitud) then
              Exit;

            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
              FVista.MostrarError(lError)
            else
              FVista.MostrarCliente(lCliente);
          finally
            lCliente.Free;
          end;
        end);
    end);
end;

procedure TPresentadorClienteDatos.CargarContactos;
var
  lCancelacion: ICancelacion;
  lApi: IApiClientes;
  lId, lNumero: Integer;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lId := FClienteId;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TContactoDTO>;
      lError: string;
    begin
      lLista := nil;
      lError := '';
      try
        lLista := lApi.Contactos(lId);
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MensajeInesperado;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada or (lNumero <> FSolicitud) then
              Exit;

            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
              FVista.MostrarError(lError)
            else
              FVista.MostrarContactos(lLista);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

procedure TPresentadorClienteDatos.CargarConsentimientos;
var
  lCancelacion: ICancelacion;
  lApi: IApiClientes;
  lId, lNumero: Integer;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lId := FClienteId;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TConsentimientoDTO>;
      lError: string;
    begin
      lLista := nil;
      lError := '';
      try
        lLista := lApi.Consentimientos(lId);
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MensajeInesperado;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada or (lNumero <> FSolicitud) then
              Exit;

            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
              FVista.MostrarError(lError)
            else
              FVista.MostrarConsentimientos(lLista);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

end.
