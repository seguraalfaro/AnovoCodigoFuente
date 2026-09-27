unit Anovo.Presentadores.Catalogos;

// Presentador de la seccion Catalogos.

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
    procedure CargarTodos;
    procedure CargarTiposTrabajo;
    procedure CargarUnidadesMedida;
    procedure CargarUnidadesActivas;
    procedure CargarCategorias;
    procedure PublicarAcciones;
    function CatalogoDeFila: TCatalogo;
  public
    constructor Create(const AVista: IVistaCatalogos;
      const AApi: IApiCatalogos);
    destructor Destroy; override;
    procedure Iniciar;
    procedure Buscar(const ATexto: string);
    procedure Limpiar;
    procedure Filtrar(const ACatalogo: TCatalogo);
    procedure FiltrarCategoria(const ACategoriaId: Integer);
    procedure IrAPagina(const APagina: Integer);
    procedure PaginaSiguiente;
    procedure PaginaAnterior;

    procedure Nuevo;
    procedure Editar(const AId: Integer);
    procedure CambiarPrecio(const AId: Integer);
    procedure VerHistorial(const AId: Integer);
    procedure Inactivar(const AId: Integer);
    procedure Recargar;

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
  Anovo.Sesion,
  Anovo.Textos;

const

  PERMISO_VER = 'catalogos.ver';
  PERMISO_EDITAR = 'catalogos.editar';

function MensajeInesperado: string;
begin
  Result := Format(SErrorInesperado, [SAccionCargarCatalogo]);
end;

constructor TPresentadorCatalogos.Create(const AVista: IVistaCatalogos;
  const AApi: IApiCatalogos);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCancelacion := TCancelacion.Create;
  FCatalogo := ctTodos;
  FPagina := 1;
end;

destructor TPresentadorCatalogos.Destroy;
begin
  FCancelacion.Cancelar;
  inherited;
end;

procedure TPresentadorCatalogos.Iniciar;
begin
  FVista.MostrarCatalogo(FCatalogo);
  PublicarAcciones;
  FVista.MostrarBusqueda('', False);
  CargarUnidadesActivas;
  Cargar;
end;

procedure TPresentadorCatalogos.PublicarAcciones;
var
  lAcciones: TAccionesCatalogo;
begin
  lAcciones := AccionesPermitidas;
  if FCatalogo in [ctTiposTrabajo, ctUnidadesMedida] then
    lAcciones := lAcciones - [acPrecio, acHistorial];
  FVista.MostrarAcciones(lAcciones, PuedeEditar and (FCatalogo <> ctTodos));
end;

procedure TPresentadorCatalogos.Cargar;
begin
  case FCatalogo of
    ctTodos:
      begin

        if not FCategoriasPedidas then
          CargarCategorias;
        CargarTodos;
      end;
    ctMateriales:
      CargarMateriales;
    ctManoObra:
      begin

        if not FCategoriasPedidas then
          CargarCategorias;
        CargarManoObra;
      end;
    ctMaquinas:
      CargarMaquinas;
    ctTiposTrabajo:
      CargarTiposTrabajo;
    ctUnidadesMedida:
      CargarUnidadesMedida;
  end;
end;

procedure TPresentadorCatalogos.CargarMateriales;
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
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FTotalPaginas := (lTotal + CATALOGO_POR_PAGINA - 1)
              div CATALOGO_POR_PAGINA;
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
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FTotalPaginas := (lTotal + CATALOGO_POR_PAGINA - 1)
              div CATALOGO_POR_PAGINA;
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
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FTotalPaginas := (lTotal + CATALOGO_POR_PAGINA - 1)
              div CATALOGO_POR_PAGINA;
            FVista.MostrarMaquinas(lLista);
            FVista.MostrarPaginacion(lPagina, FTotalPaginas, lTotal);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

procedure TPresentadorCatalogos.CargarTodos;
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
      lLista: TObjectList<TCatalogoItemDTO>;
      lTotal: Int64;
      lError: string;
    begin
      lLista := nil;
      lTotal := 0;
      lError := '';
      try
        lLista := lApi.BuscarTodos(lTexto, lPagina, CATALOGO_POR_PAGINA,
          False, lTotal);
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
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FTotalPaginas := (lTotal + CATALOGO_POR_PAGINA - 1)
              div CATALOGO_POR_PAGINA;
            FVista.MostrarTodos(lLista);
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
  lTexto: string;
begin
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lTexto := FTexto;

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
        lLista := lApi.TiposTrabajo(False, lTexto);
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
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FTotalPaginas := 0;
            FVista.MostrarTiposTrabajo(lLista);
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

procedure TPresentadorCatalogos.CargarUnidadesMedida;
var
  lCancelacion: ICancelacion;
  lApi: IApiCatalogos;
  lNumero: Integer;
  lTexto: string;
begin
  CargarUnidadesActivas;
  Inc(FSolicitud);
  lNumero := FSolicitud;
  lCancelacion := FCancelacion;
  lApi := FApi;
  lTexto := FTexto;

  FVista.MostrarCargando(True);

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TUnidadMedidaDTO>;
      lError: string;
    begin
      lLista := nil;
      lError := '';
      try
        lLista := lApi.UnidadesMedida(False, lTexto);
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
            begin
              FVista.MostrarError(lError);
              Exit;
            end;

            FTotalPaginas := 0;
            FVista.MostrarUnidadesMedida(lLista);
            FVista.MostrarPaginacion(1, 0, lLista.Count);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

procedure TPresentadorCatalogos.CargarUnidadesActivas;
var
  lCancelacion: ICancelacion;
  lApi: IApiCatalogos;
begin
  lCancelacion := FCancelacion;
  lApi := FApi;

  TTask.Run(
    procedure
    var
      lLista: TObjectList<TUnidadMedidaDTO>;
    begin
      lLista := nil;
      try
        lLista := lApi.UnidadesMedida(False);
      except
        on E: Exception do
          Exit;
      end;

      TThread.Queue(nil,
        procedure
        begin
          try
            if lCancelacion.Cancelada then
              Exit;
            FVista.MostrarUnidadesActivas(lLista);
          finally
            lLista.Free;
          end;
        end);
    end);
end;

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

function TPresentadorCatalogos.CatalogoDeFila: TCatalogo;
begin
  if FCatalogo = ctTodos then
    Result := FVista.CatalogoDeLaFila
  else
    Result := FCatalogo;
end;

procedure TPresentadorCatalogos.Nuevo;
begin
  if not PuedeEditar or (FCatalogo = ctTodos) then
    Exit;
  FVista.MostrarFormularioItem(FCatalogo, 0);
end;

procedure TPresentadorCatalogos.Editar(const AId: Integer);
begin
  if not PuedeEditar then
    Exit;
  FVista.MostrarFormularioItem(CatalogoDeFila, AId);
end;

procedure TPresentadorCatalogos.CambiarPrecio(const AId: Integer);
begin
  if not PuedeEditar then
    Exit;
  if CatalogoDeFila in [ctTiposTrabajo, ctUnidadesMedida] then
    Exit;
  FVista.MostrarFormularioPrecio(CatalogoDeFila, AId);
end;

procedure TPresentadorCatalogos.VerHistorial(const AId: Integer);
var
  lCancelacion: ICancelacion;
  lApi: IApiCatalogos;
  lCatalogo: TCatalogo;
begin
  lCatalogo := CatalogoDeFila;
  if lCatalogo in [ctTiposTrabajo, ctUnidadesMedida] then
    Exit;

  lCancelacion := FCancelacion;
  lApi := FApi;

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
          lError := MensajeInesperado;
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
  lCatalogo := CatalogoDeFila;

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
          ctUnidadesMedida:
            lApi.InactivarUnidadMedida(AId);
        else
          lApi.InactivarMaterial(AId);
        end;
      except
        on E: EAnovoCliente do
          lError := E.Message;
        on E: Exception do
          lError := MensajeInesperado;
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

          Cargar;
        end);
    end);
end;

class function TPresentadorCatalogos.AccionesPermitidas: TAccionesCatalogo;
begin
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
