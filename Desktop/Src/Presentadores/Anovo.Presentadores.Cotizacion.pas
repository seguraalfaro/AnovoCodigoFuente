unit Anovo.Presentadores.Cotizacion;

// Presentadores de la cotizacion: la pantalla de elaboracion y detalle,
// la ventana de una linea y la del ajuste.

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.Api.Intf.Catalogos,
  Anovo.Api.Intf.Cotizaciones,
  Anovo.Api.Intf.Solicitudes,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Cotizaciones,
  Anovo.DTOs.Documento,
  Anovo.Presentadores.Base,
  Anovo.Vistas.Intf.Cotizacion,
  Anovo.Textos;

type
  TPresentadorCotizacion = class(TPresentadorBase)
  private
    FVista: IVistaCotizacion;
    FApi: IApiCotizaciones;
    FSolicitudes: IApiSolicitudes;
    FCatalogos: IApiCatalogos;
    FId: Integer;
    FNumero: Integer;
    FSolicitudId: Integer;
    FObjVersion: Integer;
    FEstado: string;
    FCosto: Currency;
    FPorcentajeIva: Currency;
    FPorcentajeAjuste: Currency;
    FMotivoAjuste: string;
    FLineas: TObjectList<TLineaDTO>;
    FEvidenciaPedida: Boolean;
    procedure Cargar(const AConEncabezado: Boolean);
    procedure CargarEvidencia;
    procedure TomarCotizacion(const ACotizacion: TCotizacionDTO);
    procedure PublicarBotones;
    function Editable: Boolean;
    procedure MostrarError(AMensaje: string);
    procedure MostrarCargando(AActivo: Boolean);
  public
    constructor Create(const AVista: IVistaCotizacion;
      const AApi: IApiCotizaciones; const ASolicitudes: IApiSolicitudes;
      const ACatalogos: IApiCatalogos);
    destructor Destroy; override;
    procedure Iniciar(const AId: Integer);
    procedure Recargar;
    procedure RecargarTipos;
    procedure Guardar(const ADatos: TCotizacionEdicionDTO);
    procedure Presentar(const ADatos: TCotizacionEdicionDTO);
    procedure PrepararEnvio;
    procedure VerDocumento(const ARuta: string);
    procedure RegistrarRespuesta(const AAceptada: Boolean);
    procedure QuitarLinea(const ALineaId: Integer);
    function Linea(const ALineaId: Integer): TLineaDTO;
    property Id: Integer read FId;
    property Numero: Integer read FNumero;
    property Costo: Currency read FCosto;
    property PorcentajeIva: Currency read FPorcentajeIva;
    property PorcentajeAjuste: Currency read FPorcentajeAjuste;
    property MotivoAjuste: string read FMotivoAjuste;
  end;

  TPresentadorLineaCotizacion = class(TPresentadorBase)
  private
    FVista: IVistaLineaCotizacion;
    FApi: IApiCotizaciones;
    FCatalogos: IApiCatalogos;
    FCotizacionId: Integer;
    FModo: TModoLinea;
    FLineaId: Integer;
    FTipo: string;
    FMaterialId: Integer;
    FManoObraId: Integer;
    FMaquinaId: Integer;
    FDescripcion: string;
    FUnidad: string;
    procedure Enviar(const ADto: TLineaNuevaDTO);
    function TipoDelModo: string;
  public
    constructor Create(const AVista: IVistaLineaCotizacion;
      const AApi: IApiCotizaciones; const ACatalogos: IApiCatalogos);
    procedure Iniciar(const ACotizacionId: Integer; const AModo: TModoLinea;
      const ALinea: TLineaDTO);
    procedure Buscar(const ATexto: string; const ACategoriaId: Integer);
    procedure Agregar(const AItemId: Integer; const ANombre, AUnidad: string;
      const ACantidad: Currency);
    procedure AgregarNota(const ATexto: string);
    procedure Cambiar(const ACantidad: Currency; const ANota: string);
    function EsNota: Boolean;
  end;

  TPresentadorAjusteCotizacion = class(TPresentadorBase)
  private
    FVista: IVistaAjuste;
    FApi: IApiCotizaciones;
    FCotizacionId: Integer;
    FCosto: Currency;
    FPorcentajeIva: Currency;
  public
    constructor Create(const AVista: IVistaAjuste;
      const AApi: IApiCotizaciones);
    procedure Iniciar(const ACotizacionId: Integer;
      const ACosto, APorcentajeIva: Currency);
    procedure Previsualizar(const APorcentaje: Currency;
      const ADescuento: Boolean);
    procedure Aplicar(const APorcentaje: Currency; const ADescuento: Boolean;
      const AMotivo: string);
  end;

implementation

uses
  System.NetEncoding,
  Anovo.DTOs.Solicitudes,
  Anovo.Mensajes,
  Anovo.Permisos,
  Anovo.Sesion;

const
  ESTADO_BORRADOR = 'borrador';
  ESTADO_DEVUELTA = 'devuelta';
  ESTADO_VISTO_BUENO = 'visto_bueno';
  ESTADO_ENVIADA = 'enviada';
  ESTADO_APROBADA = 'aprobada';
  ESTADO_RECHAZADA = 'rechazada';
  ADJUNTO_CROQUIS = 'croquis';
  ADJUNTO_FOTO = 'foto';
  MAXIMO_FOTOS = 4;
  ITEMS_POR_BUSQUEDA = 50;
  UNIDAD_HORA = 'h';

constructor TPresentadorCotizacion.Create(const AVista: IVistaCotizacion;
  const AApi: IApiCotizaciones; const ASolicitudes: IApiSolicitudes;
  const ACatalogos: IApiCatalogos);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FSolicitudes := ASolicitudes;
  FCatalogos := ACatalogos;
  FLineas := TObjectList<TLineaDTO>.Create(True);
end;

destructor TPresentadorCotizacion.Destroy;
begin
  FLineas.Free;
  inherited;
end;

procedure TPresentadorCotizacion.MostrarError(AMensaje: string);
begin
  FVista.MostrarError(AMensaje);
end;

procedure TPresentadorCotizacion.MostrarCargando(AActivo: Boolean);
begin
  FVista.MostrarCargando(AActivo);
end;

function TPresentadorCotizacion.Editable: Boolean;
begin
  Result := ((FEstado = ESTADO_BORRADOR) or (FEstado = ESTADO_DEVUELTA)) and
    TSesion.Tiene(PERMISO_COTIZACIONES_ELABORAR);
end;

procedure TPresentadorCotizacion.PublicarBotones;
var
  lBotones: TBotonesCotizacion;
  lAcciones: TAccionesLinea;
begin
  lBotones := [];
  lAcciones := [];
  if Editable then
  begin
    lBotones := [bcGuardar, bcPresentar, bcAgregarLinea, bcAjuste];
    if TSesion.Tiene(PERMISO_CATALOGOS_EDITAR) then
      Include(lBotones, bcNuevoTipo);
    lAcciones := [alEditar, alQuitar];
  end
  else if (FEstado = ESTADO_VISTO_BUENO) and
    TSesion.Tiene(PERMISO_COTIZACIONES_ELABORAR) then
    lBotones := [bcEnviar]
  else if (FEstado = ESTADO_ENVIADA) and
    TSesion.Tiene(PERMISO_COTIZACIONES_ELABORAR) then
    lBotones := [bcRespuesta];
  if (FEstado = ESTADO_VISTO_BUENO) or (FEstado = ESTADO_ENVIADA) or
    (FEstado = ESTADO_APROBADA) or (FEstado = ESTADO_RECHAZADA) then
    Include(lBotones, bcDocumento);
  FVista.MostrarBotones(lBotones, lAcciones);
end;

procedure TPresentadorCotizacion.TomarCotizacion(const ACotizacion
  : TCotizacionDTO);
begin
  FNumero := ACotizacion.Numero;
  FSolicitudId := ACotizacion.SolicitudId;
  FObjVersion := ACotizacion.ObjVersion;
  FEstado := ACotizacion.Estado;
  FCosto := ACotizacion.CostoTotal.ValueOrDefault;
  FPorcentajeIva := ACotizacion.PorcentajeIva;
  FPorcentajeAjuste := ACotizacion.PorcentajeAjuste;
  FMotivoAjuste := ACotizacion.MotivoAjuste.ValueOrDefault;
end;

procedure TPresentadorCotizacion.Iniciar(const AId: Integer);
begin
  FId := AId;
  Cargar(True);
end;

procedure TPresentadorCotizacion.Recargar;
begin
  Cargar(False);
end;

procedure TPresentadorCotizacion.RecargarTipos;
var
  lCatalogos: IApiCatalogos;
begin
  lCatalogos := FCatalogos;
  Ejecutar<TObjectList<TTipoTrabajoDTO>>(SAccionCargarCotizacion,
    function: TObjectList<TTipoTrabajoDTO>
    begin
      Result := lCatalogos.TiposTrabajo(False);
    end,
    procedure(ATipos: TObjectList<TTipoTrabajoDTO>)
    begin
      FVista.MostrarTiposTrabajo(ATipos);
    end, MostrarError, MostrarCargando);
end;

procedure TPresentadorCotizacion.Cargar(const AConEncabezado: Boolean);
var
  lApi: IApiCotizaciones;
  lCatalogos: IApiCatalogos;
  lId: Integer;
  lCotizacion: TCotizacionDTO;
  lLineas: TObjectList<TLineaDTO>;
  lTipos: TObjectList<TTipoTrabajoDTO>;
begin
  lApi := FApi;
  lCatalogos := FCatalogos;
  lId := FId;
  lCotizacion := nil;
  lLineas := nil;
  lTipos := nil;

  Ejecutar(SAccionCargarCotizacion,
    procedure
    begin
      lCotizacion := lApi.Obtener(lId);
      lLineas := lApi.Detalle(lId);
      if AConEncabezado then
        lTipos := lCatalogos.TiposTrabajo(False);
    end,
    procedure
    begin
      TomarCotizacion(lCotizacion);
      if lTipos <> nil then
        FVista.MostrarTiposTrabajo(lTipos);
      FVista.MostrarCotizacion(lCotizacion, AConEncabezado);
      if (FEstado = ESTADO_DEVUELTA) and lCotizacion.MotivoRechazo.HasValue then
        FVista.MostrarDevolucion(lCotizacion.MotivoRechazo.Value)
      else
        FVista.MostrarDevolucion('');
      FVista.MostrarLineas(lLineas);
      FLineas.Free;
      FLineas := lLineas;
      lLineas := nil;
      PublicarBotones;
      CargarEvidencia;
    end, MostrarError, MostrarCargando,
    procedure
    begin
      lTipos.Free;
      lLineas.Free;
      lCotizacion.Free;
    end);
end;

procedure TPresentadorCotizacion.CargarEvidencia;
var
  lSolicitudes: IApiSolicitudes;
  lSolicitudId: Integer;
  lMedidas: TObjectList<TMedidaDTO>;
  lCroquis: string;
  lFotos: TList<TBytes>;
begin
  if FEvidenciaPedida or (FSolicitudId = 0) then
    Exit;
  FEvidenciaPedida := True;
  lSolicitudes := FSolicitudes;
  lSolicitudId := FSolicitudId;
  lMedidas := nil;
  lCroquis := '';
  lFotos := TList<TBytes>.Create;

  Ejecutar(SAccionCargarCotizacion,
    procedure
    var
      lAdjuntos: TObjectList<TAdjuntoDTO>;
      lAdjunto: TAdjuntoDTO;
      lContenido: TAdjuntoContenidoDTO;
    begin
      lMedidas := lSolicitudes.Medidas(lSolicitudId);
      lAdjuntos := lSolicitudes.Adjuntos(lSolicitudId);
      try
        for lAdjunto in lAdjuntos do
        begin
          if not lAdjunto.Activo then
            Continue;
          if (lAdjunto.Tipo = ADJUNTO_CROQUIS) and lCroquis.IsEmpty then
          begin
            lContenido := lSolicitudes.Adjunto(lSolicitudId, lAdjunto.ID);
            try
              lCroquis := lContenido.ContenidoJson.ValueOrDefault;
            finally
              lContenido.Free;
            end;
          end
          else if (lAdjunto.Tipo = ADJUNTO_FOTO) and
            (lFotos.Count < MAXIMO_FOTOS) then
          begin
            lContenido := lSolicitudes.Adjunto(lSolicitudId, lAdjunto.ID);
            try
              if lContenido.Contenido.HasValue then
                lFotos.Add(TNetEncoding.Base64.DecodeStringToBytes
                  (lContenido.Contenido.Value));
            finally
              lContenido.Free;
            end;
          end;
        end;
      finally
        lAdjuntos.Free;
      end;
    end,
    procedure
    var
      I: Integer;
    begin
      FVista.MostrarMedidas(lMedidas);
      FVista.MostrarCroquis(lCroquis);
      for I := 0 to lFotos.Count - 1 do
        FVista.MostrarFoto(I, lFotos.Count, lFotos[I]);
      if lFotos.Count = 0 then
        FVista.MostrarFoto(-1, 0, nil);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarCroquis('');
      FVista.MostrarFoto(-1, 0, nil);
      FVista.MostrarError(AMensaje);
    end, nil,
    procedure
    begin
      lMedidas.Free;
      lFotos.Free;
    end);
end;

procedure TPresentadorCotizacion.Guardar(const ADatos: TCotizacionEdicionDTO);
var
  lApi: IApiCotizaciones;
  lId: Integer;
begin
  ADatos.ObjVersion := FObjVersion;
  lApi := FApi;
  lId := FId;

  Ejecutar(SAccionGuardar,
    procedure
    begin
      lApi.Actualizar(lId, ADatos);
    end,
    procedure
    begin
      Cargar(True);
    end, MostrarError, MostrarCargando,
    procedure
    begin
      ADatos.Free;
    end);
end;

procedure TPresentadorCotizacion.Presentar(const ADatos: TCotizacionEdicionDTO);
var
  lApi: IApiCotizaciones;
  lId: Integer;
begin
  if not FVista.Confirmar(Format(SConfirmarPresentar, [FNumero])) then
  begin
    ADatos.Free;
    Exit;
  end;
  ADatos.ObjVersion := FObjVersion;
  lApi := FApi;
  lId := FId;

  Ejecutar(SAccionPresentarCotizacion,
    procedure
    begin
      lApi.Actualizar(lId, ADatos);
      lApi.Presentar(lId);
    end,
    procedure
    begin
      AvisarCambioEnAvisos;
      FVista.Regresar;
    end, MostrarError, MostrarCargando,
    procedure
    begin
      ADatos.Free;
    end);
end;

procedure TPresentadorCotizacion.PrepararEnvio;
var
  lApi: IApiCotizaciones;
  lId: Integer;
begin
  lApi := FApi;
  lId := FId;

  Ejecutar<TCotizacionDocumentoDTO>(SAccionCargarDocumento,
    function: TCotizacionDocumentoDTO
    begin
      Result := lApi.Documento(lId);
    end,
    procedure(ADocumento: TCotizacionDocumentoDTO)
    begin
      FVista.MostrarEnvio(ADocumento);
    end, MostrarError, MostrarCargando);
end;

procedure TPresentadorCotizacion.VerDocumento(const ARuta: string);
var
  lApi: IApiCotizaciones;
  lId: Integer;
begin
  lApi := FApi;
  lId := FId;

  Ejecutar<TCotizacionDocumentoDTO>(SAccionCargarDocumento,
    function: TCotizacionDocumentoDTO
    begin
      Result := lApi.Documento(lId);
    end,
    procedure(ADocumento: TCotizacionDocumentoDTO)
    begin
      FVista.MostrarDocumento(ADocumento, ARuta);
    end, MostrarError, MostrarCargando);
end;

procedure TPresentadorCotizacion.RegistrarRespuesta(const AAceptada: Boolean);
var
  lApi: IApiCotizaciones;
  lId: Integer;
  lPregunta: string;
begin
  if AAceptada then
    lPregunta := SConfirmarClienteAprobo
  else
    lPregunta := SConfirmarClienteRechazo;
  if not FVista.Confirmar(Format(lPregunta, [FNumero])) then
    Exit;
  lApi := FApi;
  lId := FId;

  Ejecutar(SAccionRegistrarRespuesta,
    procedure
    begin
      lApi.RegistrarRespuesta(lId, AAceptada);
    end,
    procedure
    begin
      FVista.Regresar;
    end, MostrarError, MostrarCargando);
end;

function TPresentadorCotizacion.Linea(const ALineaId: Integer): TLineaDTO;
var
  lLinea: TLineaDTO;
begin
  for lLinea in FLineas do
    if lLinea.ID = ALineaId then
      Exit(lLinea);
  Result := nil;
end;

procedure TPresentadorCotizacion.QuitarLinea(const ALineaId: Integer);
var
  lApi: IApiCotizaciones;
  lId: Integer;
  lLinea: TLineaDTO;
begin
  lLinea := Linea(ALineaId);
  if (lLinea = nil) or not Editable or
    not FVista.Confirmar(Format(SConfirmarQuitarLinea, [lLinea.Descripcion]))
  then
    Exit;
  lApi := FApi;
  lId := FId;

  Ejecutar(SAccionGuardar,
    procedure
    begin
      lApi.QuitarLinea(lId, ALineaId);
    end,
    procedure
    begin
      Recargar;
    end, MostrarError, MostrarCargando);
end;

constructor TPresentadorLineaCotizacion.Create(const AVista
  : IVistaLineaCotizacion; const AApi: IApiCotizaciones;
  const ACatalogos: IApiCatalogos);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FCatalogos := ACatalogos;
end;

function TPresentadorLineaCotizacion.TipoDelModo: string;
begin
  case FModo of
    mlManoObra:
      Result := TIPO_MANO_OBRA;
    mlMaquina:
      Result := TIPO_MAQUINA;
    mlNota:
      Result := TIPO_NOTA;
  else
    Result := TIPO_MATERIAL;
  end;
end;

function TPresentadorLineaCotizacion.EsNota: Boolean;
begin
  Result := (FModo = mlNota) or ((FModo = mlEditar) and (FTipo = TIPO_NOTA));
end;

procedure TPresentadorLineaCotizacion.Iniciar(const ACotizacionId: Integer;
  const AModo: TModoLinea; const ALinea: TLineaDTO);
var
  lCatalogos: IApiCatalogos;
begin
  FCotizacionId := ACotizacionId;
  FModo := AModo;
  if ALinea <> nil then
  begin
    FLineaId := ALinea.ID;
    FTipo := ALinea.Tipo;
    FMaterialId := ALinea.MaterialId.ValueOrDefault;
    FManoObraId := ALinea.ManoObraId.ValueOrDefault;
    FMaquinaId := ALinea.MaquinaId.ValueOrDefault;
    FDescripcion := ALinea.Descripcion;
    FUnidad := ALinea.UnidadMedida.ValueOrDefault;
  end;

  if FModo in [mlMaterial, mlManoObra, mlMaquina] then
    Buscar('', 0);

  if FModo = mlManoObra then
  begin
    lCatalogos := FCatalogos;
    Ejecutar<TObjectList<TCategoriaDTO>>(SAccionBuscarCatalogo,
      function: TObjectList<TCategoriaDTO>
      begin
        Result := lCatalogos.Categorias;
      end,
      procedure(ACategorias: TObjectList<TCategoriaDTO>)
      begin
        FVista.MostrarCategorias(ACategorias);
      end, nil);
  end;
end;

procedure TPresentadorLineaCotizacion.Buscar(const ATexto: string;
  const ACategoriaId: Integer);
var
  lCatalogos: IApiCatalogos;
  lModo: TModoLinea;
  lTexto: string;
begin
  lCatalogos := FCatalogos;
  lModo := FModo;
  lTexto := ATexto.Trim;

  EjecutarUltima<TObjectList<TItemLinea>>(SAccionBuscarCatalogo,
    function: TObjectList<TItemLinea>
    var
      lTotal: Int64;
      lItem: TItemLinea;
      lMateriales: TObjectList<TMaterialDTO>;
      lMaterial: TMaterialDTO;
      lManoObra: TObjectList<TManoObraDTO>;
      lObra: TManoObraDTO;
      lMaquinas: TObjectList<TMaquinaDTO>;
      lMaquina: TMaquinaDTO;
    begin
      Result := TObjectList<TItemLinea>.Create(True);
      try
        case lModo of
          mlManoObra:
            begin
              lManoObra := lCatalogos.BuscarManoObra(lTexto, 1,
                ITEMS_POR_BUSQUEDA, False, ACategoriaId, lTotal);
              try
                for lObra in lManoObra do
                begin
                  lItem := TItemLinea.Create;
                  Result.Add(lItem);
                  lItem.ID := lObra.ID;
                  lItem.Codigo := lObra.Codigo;
                  lItem.Nombre := lObra.Nombre;
                  lItem.Categoria := lObra.CategoriaNombre;
                  lItem.UnidadMedida := lObra.UnidadMedida;
                  lItem.Precio := lObra.CostoUnitario.ValueOrDefault;
                  lItem.ProgramadoFecha := lObra.ProgramadoFecha;
                end;
              finally
                lManoObra.Free;
              end;
            end;
          mlMaquina:
            begin
              lMaquinas := lCatalogos.BuscarMaquinas(lTexto, 1,
                ITEMS_POR_BUSQUEDA, False, lTotal);
              try
                for lMaquina in lMaquinas do
                begin
                  lItem := TItemLinea.Create;
                  Result.Add(lItem);
                  lItem.ID := lMaquina.ID;
                  lItem.Codigo := lMaquina.Codigo;
                  lItem.Nombre := lMaquina.Nombre;
                  lItem.UnidadMedida := UNIDAD_HORA;
                  lItem.Precio := lMaquina.CostoHora.ValueOrDefault;
                  lItem.ProgramadoFecha := lMaquina.ProgramadoFecha;
                end;
              finally
                lMaquinas.Free;
              end;
            end;
        else
          begin
            lMateriales := lCatalogos.BuscarMateriales(lTexto, 1,
              ITEMS_POR_BUSQUEDA, False, lTotal);
            try
              for lMaterial in lMateriales do
              begin
                lItem := TItemLinea.Create;
                Result.Add(lItem);
                lItem.ID := lMaterial.ID;
                lItem.Codigo := lMaterial.Codigo;
                lItem.Nombre := lMaterial.Nombre;
                lItem.UnidadMedida := lMaterial.UnidadMedida;
                lItem.Precio := lMaterial.PrecioUnitario.ValueOrDefault;
                lItem.ProgramadoFecha := lMaterial.ProgramadoFecha;
              end;
            finally
              lMateriales.Free;
            end;
          end;
        end;
      except
        Result.Free;
        raise;
      end;
    end,
    procedure(AItems: TObjectList<TItemLinea>)
    begin
      FVista.MostrarItems(AItems);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarCargando(AActivo);
    end);
end;

procedure TPresentadorLineaCotizacion.Enviar(const ADto: TLineaNuevaDTO);
var
  lApi: IApiCotizaciones;
  lCotizacionId, lLineaId: Integer;
begin
  lApi := FApi;
  lCotizacionId := FCotizacionId;
  lLineaId := FLineaId;

  Ejecutar(SAccionGuardar,
    procedure
    begin
      if lLineaId = 0 then
        lApi.AgregarLinea(lCotizacionId, ADto)
      else
        lApi.ActualizarLinea(lCotizacionId, lLineaId, ADto);
    end,
    procedure
    begin
      FVista.Guardado(lLineaId);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarGuardando(AActivo);
    end,
    procedure
    begin
      ADto.Free;
    end);
end;

procedure TPresentadorLineaCotizacion.Agregar(const AItemId: Integer;
  const ANombre, AUnidad: string; const ACantidad: Currency);
var
  lDto: TLineaNuevaDTO;
begin
  if AItemId = 0 then
  begin
    FVista.MostrarError(SEscojaItem);
    Exit;
  end;
  if ACantidad <= 0 then
  begin
    FVista.MostrarError(SCantidadInvalida);
    Exit;
  end;

  lDto := TLineaNuevaDTO.Create;
  lDto.Tipo := TipoDelModo;
  case FModo of
    mlManoObra:
      lDto.ManoObraId := AItemId;
    mlMaquina:
      lDto.MaquinaId := AItemId;
  else
    lDto.MaterialId := AItemId;
  end;
  lDto.Descripcion := ANombre;
  lDto.UnidadMedida := AUnidad;
  lDto.Cantidad := ACantidad;
  Enviar(lDto);
end;

procedure TPresentadorLineaCotizacion.AgregarNota(const ATexto: string);
var
  lDto: TLineaNuevaDTO;
begin
  if ATexto.Trim.IsEmpty then
  begin
    FVista.MostrarError(SNotaVacia);
    Exit;
  end;
  lDto := TLineaNuevaDTO.Create;
  lDto.Tipo := TIPO_NOTA;
  lDto.Descripcion := ATexto.Trim;
  Enviar(lDto);
end;

procedure TPresentadorLineaCotizacion.Cambiar(const ACantidad: Currency;
  const ANota: string);
var
  lDto: TLineaNuevaDTO;
begin
  if EsNota then
  begin
    AgregarNota(ANota);
    Exit;
  end;
  if ACantidad <= 0 then
  begin
    FVista.MostrarError(SCantidadInvalida);
    Exit;
  end;

  lDto := TLineaNuevaDTO.Create;
  lDto.Tipo := FTipo;
  if FMaterialId > 0 then
    lDto.MaterialId := FMaterialId;
  if FManoObraId > 0 then
    lDto.ManoObraId := FManoObraId;
  if FMaquinaId > 0 then
    lDto.MaquinaId := FMaquinaId;
  lDto.Descripcion := FDescripcion;
  lDto.UnidadMedida := FUnidad;
  lDto.Cantidad := ACantidad;
  Enviar(lDto);
end;

constructor TPresentadorAjusteCotizacion.Create(const AVista: IVistaAjuste;
  const AApi: IApiCotizaciones);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
end;

procedure TPresentadorAjusteCotizacion.Iniciar(const ACotizacionId: Integer;
  const ACosto, APorcentajeIva: Currency);
begin
  FCotizacionId := ACotizacionId;
  FCosto := ACosto;
  FPorcentajeIva := APorcentajeIva;
end;

procedure TPresentadorAjusteCotizacion.Previsualizar(const APorcentaje
  : Currency; const ADescuento: Boolean);
var
  lAjuste, lIva: Currency;
begin
  lAjuste := FCosto * APorcentaje / 100;
  if ADescuento then
    lAjuste := -lAjuste;
  lIva := (FCosto + lAjuste) * FPorcentajeIva / 100;
  FVista.MostrarVistaPrevia(lAjuste, lIva, FCosto + lAjuste + lIva);
end;

procedure TPresentadorAjusteCotizacion.Aplicar(const APorcentaje: Currency;
  const ADescuento: Boolean; const AMotivo: string);
var
  lApi: IApiCotizaciones;
  lId: Integer;
  lDto: TAjusteDTO;
begin
  if (APorcentaje <> 0) and AMotivo.Trim.IsEmpty then
  begin
    FVista.MostrarError(SAjusteSinMotivo);
    Exit;
  end;

  lDto := TAjusteDTO.Create;
  if ADescuento then
    lDto.PorcentajeAjuste := -APorcentaje
  else
    lDto.PorcentajeAjuste := APorcentaje;
  if APorcentaje <> 0 then
    lDto.MotivoAjuste := AMotivo.Trim;
  lApi := FApi;
  lId := FCotizacionId;

  Ejecutar(SAccionGuardar,
    procedure
    begin
      lApi.AplicarAjuste(lId, lDto);
    end,
    procedure
    begin
      FVista.Guardado(lId);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarGuardando(AActivo);
    end,
    procedure
    begin
      lDto.Free;
    end);
end;

end.
