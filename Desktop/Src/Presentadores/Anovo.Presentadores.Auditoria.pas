unit Anovo.Presentadores.Auditoria;

// La logica de la bitacora de auditoria, fuera del frame.
//
// Guarda el estado de la consulta: ventana de tiempo, entidad, texto y pagina.
// Cada cambio vuelve a pedir al servidor, fuera del hilo de la interfaz, con
// las dos precauciones del listado de clientes: el frame se destruye al
// cambiar de seccion y la respuesta puede llegar despues, y quien busca
// seguido dispara varias peticiones que pueden volver en otro orden.
//
// El alcance no es un filtro mas. Quien tiene auditoria.ver_cuentas y no
// auditoria.ver_toda solo puede pedir la bitacora de cuentas: la otra ruta le
// responde 403. Se decide una vez, al arrancar, con los permisos de la sesion.

interface

uses
  Anovo.Api.Intf.Auditoria,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.Auditoria;

type
  TPresentadorAuditoria = class
  private
    FVista: IVistaAuditoria;
    FApi: IApiAuditoria;
    FCancelacion: ICancelacion;
    FSoloCuentas: Boolean;
    FDesde: TDateTime;
    FHasta: TDateTime;
    FFiltro: TFiltroEntidad;
    FTexto: string;
    FPagina: Integer;
    FTotalPaginas: Integer;
    FSolicitud: Integer;
    function EntidadPedida: string;
    procedure Cargar;
  public
    constructor Create(const AVista: IVistaAuditoria;
      const AApi: IApiAuditoria);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Buscar(const ATexto: string);
    // Quita el texto y vuelve a la bitacora completa. El periodo y la entidad
    // se conservan.
    procedure Limpiar;
    procedure Filtrar(const AFiltro: TFiltroEntidad);
    procedure CambiarPeriodo(const ADesde, AHasta: TDateTime);
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;
    // No tocan la vista: se prueban asignando permisos a TSesion.
    class function PuedeVerTodo: Boolean;
    class function PuedeVerCuentas: Boolean;
  end;

const
  AUDITORIA_POR_PAGINA = 50;
  // Lo que se muestra al abrir la pantalla. El servidor usa la misma reserva
  // cuando no le mandan fechas.
  DIAS_POR_DEFECTO = 30;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  System.Threading,
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.DTOs.Auditoria,
  Anovo.Sesion,
  Anovo.Textos;

const


  // Mismo orden que TFiltroEntidad, mismos valores que la columna ENTIDAD.
  // Cuentas es USUARIOS: el cambio de clave, que es USUARIOS_CLAVES, se ve
  // desde la pantalla del administrador.
  ENTIDAD_API: array [TFiltroEntidad] of string = ('', 'CLIENTES',
    'COTIZACIONES', 'USUARIOS');

// La frase completa vive en Anovo.Textos. Aqui solo se dice de que accion
// se habla, que es lo unico que cambia de una pantalla a otra.
function MensajeInesperado: string;
begin
  Result := Format(SErrorInesperado, [SAccionCargarBitacora]);
end;

// TPresentadorAuditoria

constructor TPresentadorAuditoria.Create(const AVista: IVistaAuditoria;
  const AApi: IApiAuditoria);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
  FPagina := 1;
  FHasta := Date;
  FDesde := IncDay(FHasta, -DIAS_POR_DEFECTO);
end;

destructor TPresentadorAuditoria.Destroy;
begin
  // Lo que vuelva despues de esto ya no tiene frame donde mostrarse.
  FCancelacion.Cancelar;
  inherited;
end;

class function TPresentadorAuditoria.PuedeVerTodo: Boolean;
begin
  Result := TSesion.Tiene('auditoria.ver_toda');
end;

class function TPresentadorAuditoria.PuedeVerCuentas: Boolean;
begin
  Result := TSesion.Tiene('auditoria.ver_cuentas');
end;

function TPresentadorAuditoria.EntidadPedida: string;
begin
  // Con el alcance de cuentas la entidad la pone el servidor: pedirle otra
  // cosa por esa ruta es un 403, no una lista vacia.
  if FSoloCuentas then
    Result := ''
  else
    Result := ENTIDAD_API[FFiltro];
end;

procedure TPresentadorAuditoria.Iniciar;
begin
  // Quien tiene los dos permisos ve la bitacora completa, que ya incluye las
  // cuentas.
  FSoloCuentas := not PuedeVerTodo;
  FVista.MostrarAlcance(not FSoloCuentas);
  FVista.MostrarPeriodo(FDesde, FHasta);
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorAuditoria.Buscar(const ATexto: string);
begin
  // Borrar el texto a mano y buscar es lo mismo que Limpiar.
  FTexto := ATexto.Trim;
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, not FTexto.IsEmpty);
  Cargar;
end;

procedure TPresentadorAuditoria.Limpiar;
begin
  Buscar('');
end;

procedure TPresentadorAuditoria.Filtrar(const AFiltro: TFiltroEntidad);
begin
  FFiltro := AFiltro;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorAuditoria.CambiarPeriodo(const ADesde, AHasta: TDateTime);
begin
  // Se avisa aqui y no se manda al servidor: el rango al reves es un error de
  // quien escoge las fechas, no del servidor.
  if ADesde > AHasta then
  begin
    FVista.MostrarError(SPeriodoInvertido);
    FVista.MostrarPeriodo(FDesde, FHasta);
    Exit;
  end;

  FDesde := ADesde;
  FHasta := AHasta;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorAuditoria.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorAuditoria.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorAuditoria.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
end;

procedure TPresentadorAuditoria.Cargar;
var
  lCancelacion: ICancelacion;
  lApi: IApiAuditoria;
  lNumero: Integer;
  lSoloCuentas: Boolean;
  lDesde, lHasta: TDateTime;
  lEntidad, lTexto: string;
  lPagina: Integer;
begin
  // Copias locales: la tarea no puede leer campos del presentador, que puede
  // haberse liberado cuando ella termine.
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lSoloCuentas := FSoloCuentas;
  lDesde := FDesde;
  lHasta := FHasta;
  lEntidad := EntidadPedida;
  lTexto := FTexto;
  lPagina := FPagina;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TAuditoriaDTO>;
      lTotal: Int64;
      lError: string;
    begin
      lLista := nil;
      lTotal := 0;
      lError := '';
      try
        // La accion no se filtra desde aqui todavia: la pantalla no tiene
        // donde escogerla.
        lLista := lApi.Buscar(lSoloCuentas, lDesde, lHasta, lEntidad, '',
          lTexto, lPagina, AUDITORIA_POR_PAGINA, lTotal);
      except
        // Sin conexion, sesion vencida y errores del servidor ya traen su
        // mensaje para la persona.
        on E: EAnovoCliente do
          lError := E.Message;
        // Una excepcion que se escapa de TTask no la ve nadie.
        on E: Exception do
          lError := MensajeInesperado;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            // Primero la bandera, antes de tocar el presentador: si se
            // cancelo, el presentador ya no existe.
            if lCancelacion.Cancelada or (lNumero <> FSolicitud) then
              Exit;

            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FTotalPaginas := (lTotal + AUDITORIA_POR_PAGINA - 1) div
              AUDITORIA_POR_PAGINA;
            FVista.MostrarAuditoria(lLista);
            FVista.MostrarPaginacion(lPagina, FTotalPaginas, lTotal);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

end.
