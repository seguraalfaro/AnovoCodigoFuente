unit Anovo.Presentadores.Catalogos;

// La logica de los cuatro catalogos, fuera del frame.
//
// Guarda el estado de la consulta: pestana, texto, categoria y pagina. Cada
// cambio vuelve a pedir al servidor, fuera del hilo de la interfaz, con las
// dos precauciones del listado de clientes: el frame se destruye al cambiar de
// seccion y la respuesta puede llegar despues, y quien busca seguido dispara
// varias peticiones que pueden volver en otro orden.
//
// Los cuatro catalogos se cargan en cuatro metodos casi iguales. Es a
// proposito: lo unico que comparten es el andamiaje de la tarea, y unificarlo
// obligaria a mover las listas como TObject y devolverles el tipo con un cast
// del lado de la vista.
//
// Tipos de trabajo no pagina: es una lista corta que llena un desplegable.

interface

uses
  Anovo.Api.Intf.Catalogos,
  Anovo.Cancelacion,
  Anovo.Vistas.Intf.Catalogos;

type
  TPresentadorCatalogos = class
  private
    FVista: IVistaCatalogos;
    FApi: IApiCatalogos;
    FCancelacion: ICancelacion;
    FCatalogo: TCatalogo;
    FTexto: string;
    FCategoriaId: Integer;
    FPagina: Integer;
    FTotalPaginas: Integer;
    FSolicitud: Integer;
    FCategoriasPedidas: Boolean;
    procedure Cargar;
    procedure CargarMateriales;
    procedure CargarManoObra;
    procedure CargarMaquinas;
    procedure CargarTiposTrabajo;
    procedure CargarCategorias;
    procedure PublicarAcciones;
  public
    constructor Create(const AVista: IVistaCatalogos;
      const AApi: IApiCatalogos);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Buscar(const ATexto: string);
    // Quita el texto y vuelve al catalogo completo. La pestana y la categoria
    // se conservan.
    procedure Limpiar;
    procedure Filtrar(const ACatalogo: TCatalogo);
    // Solo tiene efecto en mano de obra. 0 son todas.
    procedure FiltrarCategoria(const ACategoriaId: Integer);
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;

    // Las cuatro acciones de la fila. Abren formulario o traen el historial;
    // ninguna escribe: eso lo hacen los formularios contra la API.
    procedure Nuevo;
    procedure Editar(const AId: Integer);
    procedure CambiarPrecio(const AId: Integer);
    procedure VerHistorial(const AId: Integer);
    procedure Inactivar(const AId: Integer);
    // La llaman los formularios al guardar, para que la rejilla se entere.
    procedure Recargar;

    // No tocan la vista: se prueban asignando permisos a TSesion.
    class function AccionesPermitidas: TAccionesCatalogo;
    class function PuedeEditar: Boolean;
  end;

const
  CATALOGO_POR_PAGINA = 50;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.Threading,
  System.Generics.Collections,
  Anovo.Api.Base,
  Anovo.DTOs.Catalogos,
  Anovo.Sesion;

const
  MENSAJE_INESPERADO = 'Ocurrio un error inesperado al cargar el catalogo. ' +
    'Intente de nuevo; si persiste, avise al administrador.';

  PERMISO_VER = 'catalogos.ver';
  PERMISO_EDITAR = 'catalogos.editar';

// TPresentadorCatalogos

constructor TPresentadorCatalogos.Create(const AVista: IVistaCatalogos;
  const AApi: IApiCatalogos);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
  FCatalogo := ctMateriales;
  FPagina := 1;
end;

destructor TPresentadorCatalogos.Destroy;
begin
  // Lo que venga en camino se tira: el frame ya no esta.
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorCatalogos.Iniciar;
begin
  FVista.MostrarCatalogo(FCatalogo);
  PublicarAcciones;
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorCatalogos.PublicarAcciones;
var
  lAcciones: TAccionesCatalogo;
begin
  lAcciones := AccionesPermitidas;
  // Tipos de trabajo no lleva precio: sus dos acciones no tendrian que
  // abrir nada.
  if FCatalogo = ctTiposTrabajo then
    lAcciones := lAcciones - [acPrecio, acHistorial];
  FVista.MostrarAcciones(lAcciones, PuedeEditar);
end;

// Consulta

procedure TPresentadorCatalogos.Cargar;
begin
  case FCatalogo of
    ctMateriales:
      CargarMateriales;
    ctManoObra:
      begin
        // El desplegable se llena una sola vez: es catalogo fijo.
        if not FCategoriasPedidas then
          CargarCategorias;
        CargarManoObra;
      end;
    ctMaquinas:
      CargarMaquinas;
    ctTiposTrabajo:
      CargarTiposTrabajo;
  end;
end;

procedure TPresentadorCatalogos.CargarMateriales;
var
  lCancelacion: ICancelacion;
  lApi: IApiCatalogos;
  lNumero, lPagina: Integer;
  lTexto: string;
begin
  // Copias locales: la tarea no puede leer campos del presentador, que puede
  // haberse liberado cuando ella termine.
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TMaterialDTO>;
      lTotal: Int64;
      lError: string;
    begin
      lLista := nil;
      lTotal := 0;
      lError := '';
      try
        lLista := lApi.BuscarMateriales(lTexto, lPagina, CATALOGO_POR_PAGINA,
          False, lTotal);
      except
        // Sin conexion, sesion vencida y errores del servidor ya traen su
        // mensaje para la persona.
        on E: EAnovoCliente do
          lError := E.Message;
        // Una excepcion que se escapa de TTask no la ve nadie.
        on E: Exception do
          lError := MENSAJE_INESPERADO;
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

            FTotalPaginas := (lTotal + CATALOGO_POR_PAGINA - 1) div
              CATALOGO_POR_PAGINA;
            FVista.MostrarMateriales(lLista);
            FVista.MostrarPaginacion(lPagina, FTotalPaginas, lTotal);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

procedure TPresentadorCatalogos.CargarManoObra;
var
  lCancelacion: ICancelacion;
  lApi: IApiCatalogos;
  lNumero, lPagina, lCategoria: Integer;
  lTexto: string;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;
  lCategoria := FCategoriaId;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TManoObraDTO>;
      lTotal: Int64;
      lError: string;
    begin
      lLista := nil;
      lTotal := 0;
      lError := '';
      try
        lLista := lApi.BuscarManoObra(lTexto, lPagina, CATALOGO_POR_PAGINA,
          False, lCategoria, lTotal);
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MENSAJE_INESPERADO;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada or (lNumero <> FSolicitud) then
              Exit;

            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FTotalPaginas := (lTotal + CATALOGO_POR_PAGINA - 1) div
              CATALOGO_POR_PAGINA;
            FVista.MostrarManoObra(lLista);
            FVista.MostrarPaginacion(lPagina, FTotalPaginas, lTotal);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

procedure TPresentadorCatalogos.CargarMaquinas;
var
  lCancelacion: ICancelacion;
  lApi: IApiCatalogos;
  lNumero, lPagina: Integer;
  lTexto: string;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lTexto := FTexto;
  lPagina := FPagina;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TMaquinaDTO>;
      lTotal: Int64;
      lError: string;
    begin
      lLista := nil;
      lTotal := 0;
      lError := '';
      try
        lLista := lApi.BuscarMaquinas(lTexto, lPagina, CATALOGO_POR_PAGINA,
          False, lTotal);
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MENSAJE_INESPERADO;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada or (lNumero <> FSolicitud) then
              Exit;

            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FTotalPaginas := (lTotal + CATALOGO_POR_PAGINA - 1) div
              CATALOGO_POR_PAGINA;
            FVista.MostrarMaquinas(lLista);
            FVista.MostrarPaginacion(lPagina, FTotalPaginas, lTotal);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

procedure TPresentadorCatalogos.CargarTiposTrabajo;
var
  lCancelacion: ICancelacion;
  lApi: IApiCatalogos;
  lNumero: Integer;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TTipoTrabajoDTO>;
      lError: string;
    begin
      lLista := nil;
      lError := '';
      try
        // Sin texto ni pagina: la ruta devuelve la lista entera.
        lLista := lApi.TiposTrabajo(False);
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MENSAJE_INESPERADO;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada or (lNumero <> FSolicitud) then
              Exit;

            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FTotalPaginas := 0;
            FVista.MostrarTiposTrabajo(lLista);
            // Cero paginas: la vista esconde los controles de paginacion.
            FVista.MostrarPaginacion(1, 0, lLista.Count);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

procedure TPresentadorCatalogos.CargarCategorias;
var
  lCancelacion: ICancelacion;
  lApi: IApiCatalogos;
begin
  // No lleva numero de solicitud: no compite con el listado y llega cuando
  // llegue. Se marca antes de pedir para no dispararla dos veces seguidas.
  FCategoriasPedidas := True;
  lCancelacion := FCancelacion;
  lApi := FApi;

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TCategoriaDTO>;
    begin
      lLista := nil;
      try
        lLista := lApi.Categorias;
      except
        // Sin categorias el filtro queda vacio y el listado funciona igual:
        // no vale la pena molestar a la persona con un mensaje.
        on E: Exception do
          Exit;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada then
              Exit;
            FVista.MostrarCategorias(lLista);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

// Busqueda y navegacion

procedure TPresentadorCatalogos.Buscar(const ATexto: string);
begin
  FTexto := ATexto.Trim;
  FPagina := 1;
  FVista.MostrarBusqueda(FTexto, not FTexto.IsEmpty);
  Cargar;
end;

procedure TPresentadorCatalogos.Limpiar;
begin
  Buscar('');
end;

procedure TPresentadorCatalogos.Filtrar(const ACatalogo: TCatalogo);
begin
  if ACatalogo = FCatalogo then
    Exit;

  FCatalogo := ACatalogo;
  // El texto no se conserva entre pestanas: lo que se busca en materiales no
  // significa nada en maquinas.
  FTexto := '';
  FCategoriaId := 0;
  FPagina := 1;

  FVista.MostrarCatalogo(FCatalogo);
  PublicarAcciones;
  FVista.MostrarBusqueda('', False);
  Cargar;
end;

procedure TPresentadorCatalogos.FiltrarCategoria(const ACategoriaId: Integer);
begin
  if FCatalogo <> ctManoObra then
    Exit;
  FCategoriaId := ACategoriaId;
  FPagina := 1;
  Cargar;
end;

procedure TPresentadorCatalogos.IrAPagina(const APagina: Integer);
begin
  if (APagina < 1) or ((FTotalPaginas > 0) and (APagina > FTotalPaginas)) then
    Exit;
  FPagina := APagina;
  Cargar;
end;

procedure TPresentadorCatalogos.PaginaSiguiente;
begin
  IrAPagina(FPagina + 1);
end;

procedure TPresentadorCatalogos.PaginaAnterior;
begin
  IrAPagina(FPagina - 1);
end;

procedure TPresentadorCatalogos.Recargar;
begin
  Cargar;
end;

// Acciones de la fila

procedure TPresentadorCatalogos.Nuevo;
begin
  if not PuedeEditar then
    Exit;
  FVista.MostrarFormularioItem(FCatalogo, 0);
end;

procedure TPresentadorCatalogos.Editar(const AId: Integer);
begin
  if not PuedeEditar then
    Exit;
  FVista.MostrarFormularioItem(FCatalogo, AId);
end;

procedure TPresentadorCatalogos.CambiarPrecio(const AId: Integer);
begin
  if not PuedeEditar then
    Exit;
  if FCatalogo = ctTiposTrabajo then
    Exit;
  FVista.MostrarFormularioPrecio(FCatalogo, AId);
end;

procedure TPresentadorCatalogos.VerHistorial(const AId: Integer);
var
  lCancelacion: ICancelacion;
  lApi: IApiCatalogos;
  lCatalogo: TCatalogo;
begin
  if FCatalogo = ctTiposTrabajo then
    Exit;

  lCancelacion := FCancelacion;
  lApi := FApi;
  lCatalogo := FCatalogo;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TPrecioDTO>;
      lError: string;
    begin
      lLista := nil;
      lError := '';
      try
        case lCatalogo of
          ctManoObra:
            lLista := lApi.HistorialPrecioManoObra(AId);
          ctMaquinas:
            lLista := lApi.HistorialCostoMaquina(AId);
        else
          lLista := lApi.HistorialPrecioMaterial(AId);
        end;
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MENSAJE_INESPERADO;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada then
              Exit;

            FVista.MostrarCargando(False);
            if not lError.IsEmpty then
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FVista.MostrarHistorial(lLista);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

procedure TPresentadorCatalogos.Inactivar(const AId: Integer);
var
  lCancelacion: ICancelacion;
  lApi: IApiCatalogos;
  lCatalogo: TCatalogo;
begin
  if not PuedeEditar then
    Exit;

  lCancelacion := FCancelacion;
  lApi := FApi;
  lCatalogo := FCatalogo;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lError: string;
    begin
      lError := '';
      try
        case lCatalogo of
          ctManoObra:
            lApi.InactivarManoObra(AId);
          ctMaquinas:
            lApi.InactivarMaquina(AId);
          ctTiposTrabajo:
            lApi.InactivarTipoTrabajo(AId);
        else
          lApi.InactivarMaterial(AId);
        end;
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MENSAJE_INESPERADO;
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

          // La fila cambio de estado en el servidor: se vuelve a pedir en vez
          // de tocar la rejilla, que es lo unico que garantiza que lo que se
          // ve es lo que hay.
          Cargar;
        end);
    end);
end;

// Permisos

class function TPresentadorCatalogos.AccionesPermitidas: TAccionesCatalogo;
begin
  // El historial es de solo lectura: alcanza con poder ver el catalogo.
  Result := [];
  if TSesion.Tiene(PERMISO_VER) then
    Include(Result, acHistorial);
  if TSesion.Tiene(PERMISO_EDITAR) then
    Result := Result + [acEditar, acPrecio, acInactivar];
end;

class function TPresentadorCatalogos.PuedeEditar: Boolean;
begin
  Result := TSesion.Tiene(PERMISO_EDITAR);
end;

end.
