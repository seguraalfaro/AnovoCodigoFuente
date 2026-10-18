unit Anovo.Presentadores.Cotizacion;

// Presentadores de la cotizacion: la pantalla de elaboracion y detalle,
// la ventana de una linea y la del ajuste.

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Anovo.Api.Intf.Catalogos,
  Anovo.Api.Intf.Clientes,
  Anovo.Api.Intf.Cotizaciones,
  Anovo.Api.Intf.Solicitudes,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Cotizaciones,
  Anovo.DTOs.Documento,
  Anovo.DTOs.Solicitudes,
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
    FClientes: IApiClientes;
    FId: Integer;
    FNumero: Integer;
    FSolicitudId: Integer;
    FPiezaId: Integer;
    FMedidas: TObjectList<TMedidaDTO>;
    FAdjuntos: TObjectList<TAdjuntoDTO>;
    FNombresPieza: TDictionary<Integer, string>;
    FCroquis: TDictionary<Integer, string>;
    FFotos: TObjectDictionary<Integer, TList<TBytes>>;
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
    procedure DescargarPieza(const APiezaId: Integer; const ANombre: string);
    procedure TomarCotizacion(const ACotizacion: TCotizacionDTO);
    procedure PublicarBotones;
    function Editable: Boolean;
    procedure MostrarError(AMensaje: string);
    procedure MostrarCargando(AActivo: Boolean);
    function CondicionesValidas(const ADatos: TCotizacionEdicionDTO): Boolean;
  public
    constructor Create(const AVista: IVistaCotizacion;
      const AApi: IApiCotizaciones; const ASolicitudes: IApiSolicitudes;
      const ACatalogos: IApiCatalogos; const AClientes: IApiClientes);
    destructor Destroy; override;
    procedure Iniciar(const AId: Integer);
    procedure ElegirPieza(const APiezaId: Integer);
    procedure Recargar;
    procedure RecargarTipos;
    procedure Guardar(const ADatos: TCotizacionEdicionDTO);
    procedure Presentar(const ADatos: TCotizacionEdicionDTO);
    procedure PedirDocumento(const AMostrar: TProc<TCotizacionDocumentoDTO>);
    procedure PrepararEnvio;
    procedure VerDocumento(const ARuta: string);
    procedure VerHistorial;
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
    FCategoriaBuscada: Integer;
    procedure Enviar(const ADto: TLineaNuevaDTO);
    function TipoDelModo: string;
  public
    constructor Create(const AVista: IVistaLineaCotizacion;
      const AApi: IApiCotizaciones; const ACatalogos: IApiCatalogos);
    procedure Iniciar(const ACotizacionId: Integer; const AModo: TModoLinea;
      const ALinea: TLineaDTO);
    procedure Buscar(const ATexto: string; const ACategoriaId: Integer);
    procedure FiltrarCategoria(const ATexto: string;
      const ACategoriaId: Integer);
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
  Anovo.Condiciones,
  Anovo.DTOs.Clientes,
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
  ESTADO_DESCARTADA = 'descartada';
  ADJUNTO_CROQUIS = 'croquis';
  ADJUNTO_FOTO = 'foto';
  ITEMS_POR_BUSQUEDA = 50;
  UNIDAD_HORA = 'h';

type
  TEvidenciaPieza = class
  private
    FCroquis: string;
    FFotos: TList<TBytes>;
  public
    constructor Create;
    destructor Destroy; override;
    property Croquis: string read FCroquis write FCroquis;
    property Fotos: TList<TBytes> read FFotos;
  end;

constructor TEvidenciaPieza.Create;
begin
  inherited Create;
  FFotos := TList<TBytes>.Create;
end;

destructor TEvidenciaPieza.Destroy;
begin
  FFotos.Free;
  inherited;
end;

function TextoContacto(const AContactos: TObjectList<TContactoDTO>;
  const AId: Integer): string;
var
  lContacto: TContactoDTO;
  lTelefono, lCorreo: string;
begin
  for lContacto in AContactos do
    if lContacto.ID = AId then
    begin
      Result := lContacto.Nombre;
      lTelefono := lContacto.Celular.ValueOrDefault.Trim;
      if lTelefono.IsEmpty then
        lTelefono := lContacto.Telefono.ValueOrDefault.Trim;
      if not lTelefono.IsEmpty then
        Result := Result + SImpSeparador + lTelefono;
      lCorreo := lContacto.Correo.ValueOrDefault.Trim;
      if not lCorreo.IsEmpty then
        Result := Result + SImpSeparador + lCorreo;
      Exit;
    end;
  Result := SContactoInactivo;
end;

constructor TPresentadorCotizacion.Create(const AVista: IVistaCotizacion;
  const AApi: IApiCotizaciones; const ASolicitudes: IApiSolicitudes;
  const ACatalogos: IApiCatalogos; const AClientes: IApiClientes);
begin
  inherited Create;
  FVista := AVista;
  FApi := AApi;
  FSolicitudes := ASolicitudes;
  FCatalogos := ACatalogos;
  FClientes := AClientes;
  FLineas := TObjectList<TLineaDTO>.Create(True);
  FNombresPieza := TDictionary<Integer, string>.Create;
  FCroquis := TDictionary<Integer, string>.Create;
  FFotos := TObjectDictionary<Integer, TList<TBytes>>.Create([doOwnsValues]);
end;

destructor TPresentadorCotizacion.Destroy;
begin
  FLineas.Free;
  FMedidas.Free;
  FAdjuntos.Free;
  FNombresPieza.Free;
  FCroquis.Free;
  FFotos.Free;
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
  else if ((FEstado = ESTADO_ENVIADA) or (FEstado = ESTADO_DESCARTADA)) and
    TSesion.Tiene(PERMISO_COTIZACIONES_ELABORAR) then
    lBotones := [bcRespuesta];
  if ((FEstado = ESTADO_VISTO_BUENO) or (FEstado = ESTADO_ENVIADA) or
    (FEstado = ESTADO_APROBADA) or (FEstado = ESTADO_RECHAZADA) or
    (FEstado = ESTADO_DESCARTADA)) and
    (TSesion.Tiene(PERMISO_COTIZACIONES_ELABORAR) or
    TSesion.Tiene(PERMISO_COTIZACIONES_APROBAR)) then
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
  lFormas: TObjectList<TCatalogoSimpleDTO>;
begin
  lApi := FApi;
  lCatalogos := FCatalogos;
  lId := FId;
  lCotizacion := nil;
  lLineas := nil;
  lTipos := nil;
  lFormas := nil;

  Ejecutar(SAccionCargarCotizacion,
    procedure
    begin
      lCotizacion := lApi.Obtener(lId);
      lLineas := lApi.Detalle(lId);
      if AConEncabezado then
      begin
        lTipos := lCatalogos.TiposTrabajo(False);
        lFormas := lCatalogos.Simples(csFormaPago, False);
      end;
    end,
    procedure
    begin
      TomarCotizacion(lCotizacion);
      if lTipos <> nil then
        FVista.MostrarTiposTrabajo(lTipos);
      if lFormas <> nil then
        FVista.MostrarFormasPago(lFormas);
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
      lFormas.Free;
      lLineas.Free;
      lCotizacion.Free;
    end);
end;

procedure TPresentadorCotizacion.CargarEvidencia;
var
  lSolicitudes: IApiSolicitudes;
  lClientes: IApiClientes;
  lSolicitudId: Integer;
  lSolicitud: TSolicitudDTO;
  lPiezas: TObjectList<TPiezaDTO>;
  lMedidas: TObjectList<TMedidaDTO>;
  lAdjuntos: TObjectList<TAdjuntoDTO>;
  lContacto: string;
begin
  if FEvidenciaPedida or (FSolicitudId = 0) then
    Exit;
  FEvidenciaPedida := True;
  lSolicitudes := FSolicitudes;
  lClientes := FClientes;
  lSolicitudId := FSolicitudId;
  lSolicitud := nil;
  lPiezas := nil;
  lMedidas := nil;
  lAdjuntos := nil;
  lContacto := SSinContacto;

  Ejecutar(SAccionCargarCotizacion,
    procedure
    var
      lContactos: TObjectList<TContactoDTO>;
    begin
      lSolicitud := lSolicitudes.Obtener(lSolicitudId);
      lPiezas := lSolicitudes.Piezas(lSolicitudId);
      lMedidas := lSolicitudes.Medidas(lSolicitudId);
      lAdjuntos := lSolicitudes.Adjuntos(lSolicitudId);
      if lSolicitud.ClienteContactoId.HasValue then
      begin
        lContactos := lClientes.Contactos(lSolicitud.ClienteId);
        try
          lContacto := TextoContacto(lContactos,
            lSolicitud.ClienteContactoId.Value);
        finally
          lContactos.Free;
        end;
      end;
    end,
    procedure
    var
      lProyecto: string;
      lPieza: TPiezaDTO;
      lSinMedidas: TObjectList<TMedidaDTO>;
    begin
      lProyecto := lSolicitud.NombreProyecto.ValueOrDefault.Trim;
      if lProyecto.IsEmpty then
        lProyecto := SSinProyecto;
      FVista.MostrarSolicitud(lProyecto, lContacto);
      FVista.MostrarPiezas(lPiezas);
      for lPieza in lPiezas do
        FNombresPieza.AddOrSetValue(lPieza.ID, lPieza.Nombre);
      FMedidas := lMedidas;
      lMedidas := nil;
      FAdjuntos := lAdjuntos;
      lAdjuntos := nil;
      if lPiezas.Count > 0 then
        ElegirPieza(lPiezas[0].ID)
      else
      begin
        lSinMedidas := TObjectList<TMedidaDTO>.Create(False);
        try
          FVista.MostrarMedidas('', lSinMedidas);
        finally
          lSinMedidas.Free;
        end;
        FVista.MostrarEvidencia('', '', nil, False);
      end;
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarEvidencia('', '', nil, False);
      FVista.MostrarError(AMensaje);
    end, nil,
    procedure
    begin
      lSolicitud.Free;
      lPiezas.Free;
      lMedidas.Free;
      lAdjuntos.Free;
    end);
end;

procedure TPresentadorCotizacion.ElegirPieza(const APiezaId: Integer);
var
  lNombre: string;
  lMedidas: TObjectList<TMedidaDTO>;
  lMedida: TMedidaDTO;
begin
  if (APiezaId = FPiezaId) or not FNombresPieza.TryGetValue(APiezaId, lNombre)
  then
    Exit;
  FPiezaId := APiezaId;

  lMedidas := TObjectList<TMedidaDTO>.Create(False);
  try
    for lMedida in FMedidas do
      if lMedida.PiezaId = APiezaId then
        lMedidas.Add(lMedida);
    FVista.MostrarMedidas(lNombre, lMedidas);
  finally
    lMedidas.Free;
  end;

  if FCroquis.ContainsKey(APiezaId) then
    FVista.MostrarEvidencia(lNombre, FCroquis[APiezaId], FFotos[APiezaId],
      False)
  else
    DescargarPieza(APiezaId, lNombre);
end;

procedure TPresentadorCotizacion.DescargarPieza(const APiezaId: Integer;
  const ANombre: string);
var
  lSolicitudes: IApiSolicitudes;
  lSolicitudId: Integer;
  lIds: TArray<Integer>;
  lTipos: TArray<string>;
  lAdjunto: TAdjuntoDTO;
begin
  FVista.MostrarEvidencia(ANombre, '', nil, True);
  for lAdjunto in FAdjuntos do
    if lAdjunto.Activo and (lAdjunto.PiezaId = APiezaId) and
      ((lAdjunto.Tipo = ADJUNTO_CROQUIS) or (lAdjunto.Tipo = ADJUNTO_FOTO)) then
    begin
      lIds := lIds + [lAdjunto.ID];
      lTipos := lTipos + [lAdjunto.Tipo];
    end;
  lSolicitudes := FSolicitudes;
  lSolicitudId := FSolicitudId;

  Ejecutar<TEvidenciaPieza>(SAccionCargarCotizacion,
    function: TEvidenciaPieza
    var
      I: Integer;
      lContenido: TAdjuntoContenidoDTO;
    begin
      Result := TEvidenciaPieza.Create;
      try
        for I := 0 to High(lIds) do
        begin
          if (lTipos[I] = ADJUNTO_CROQUIS) and not Result.Croquis.IsEmpty then
            Continue;
          lContenido := lSolicitudes.Adjunto(lSolicitudId, lIds[I]);
          try
            if lTipos[I] = ADJUNTO_CROQUIS then
              Result.Croquis := lContenido.ContenidoJson.ValueOrDefault
            else if lContenido.Contenido.HasValue then
              Result.Fotos.Add(TNetEncoding.Base64.DecodeStringToBytes
                (lContenido.Contenido.Value));
          finally
            lContenido.Free;
          end;
        end;
      except
        Result.Free;
        raise;
      end;
    end,
    procedure(AEvidencia: TEvidenciaPieza)
    var
      lFotos: TList<TBytes>;
    begin
      lFotos := TList<TBytes>.Create(AEvidencia.Fotos);
      FCroquis.AddOrSetValue(APiezaId, AEvidencia.Croquis);
      FFotos.AddOrSetValue(APiezaId, lFotos);
      if FPiezaId = APiezaId then
        FVista.MostrarEvidencia(ANombre, AEvidencia.Croquis, lFotos, False);
    end,
    procedure(AMensaje: string)
    begin
      if FPiezaId = APiezaId then
        FVista.MostrarEvidencia(ANombre, '', nil, False);
      FVista.MostrarError(AMensaje);
    end, nil);
end;

function TPresentadorCotizacion.CondicionesValidas(const ADatos
  : TCotizacionEdicionDTO): Boolean;
var
  lError: string;
begin
  lError := ErrorDePlazos(ADatos.PlazoEntregaCantidad,
    ADatos.PlazoEntregaUnidad, ADatos.GarantiaCantidad, ADatos.GarantiaUnidad);
  Result := lError.IsEmpty;
  if not Result then
  begin
    ADatos.Free;
    FVista.MostrarError(lError);
  end;
end;

procedure TPresentadorCotizacion.Guardar(const ADatos: TCotizacionEdicionDTO);
var
  lApi: IApiCotizaciones;
  lId: Integer;
begin
  if not CondicionesValidas(ADatos) then
    Exit;
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
      Cargar(False);
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
  if not CondicionesValidas(ADatos) then
    Exit;
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

procedure TPresentadorCotizacion.PedirDocumento(const AMostrar
  : TProc<TCotizacionDocumentoDTO>);
var
  lApi: IApiCotizaciones;
  lId: Integer;
  lDocumento: TCotizacionDocumentoDTO;
begin
  lApi := FApi;
  lId := FId;
  lDocumento := nil;

  Ejecutar(SAccionCargarDocumento,
    procedure
    begin
      lDocumento := lApi.Documento(lId);
    end,
    procedure
    var
      lTomado: TCotizacionDocumentoDTO;
    begin
      lTomado := lDocumento;
      lDocumento := nil;
      Diferir(
        procedure
        begin
          AMostrar(lTomado);
        end,
        procedure
        begin
          lTomado.Free;
        end);
    end, MostrarError, MostrarCargando,
    procedure
    begin
      lDocumento.Free;
    end);
end;

procedure TPresentadorCotizacion.PrepararEnvio;
begin
  PedirDocumento(
    procedure(ADocumento: TCotizacionDocumentoDTO)
    begin
      FVista.MostrarEnvio(ADocumento);
    end);
end;

procedure TPresentadorCotizacion.VerDocumento(const ARuta: string);
begin
  PedirDocumento(
    procedure(ADocumento: TCotizacionDocumentoDTO)
    begin
      FVista.MostrarDocumento(ADocumento, ARuta);
    end);
end;

procedure TPresentadorCotizacion.VerHistorial;
var
  lApi: IApiCotizaciones;
  lId: Integer;
  lEstados: TObjectList<TEstadoCotizacionDTO>;
begin
  lApi := FApi;
  lId := FId;
  lEstados := nil;

  Ejecutar(SAccionCargarHistorial,
    procedure
    begin
      lEstados := lApi.Estados(lId);
    end,
    procedure
    var
      lTomados: TObjectList<TEstadoCotizacionDTO>;
    begin
      lTomados := lEstados;
      lEstados := nil;
      Diferir(
        procedure
        begin
          FVista.MostrarHistorial(lTomados);
        end,
        procedure
        begin
          lTomados.Free;
        end);
    end, MostrarError, MostrarCargando,
    procedure
    begin
      lEstados.Free;
    end);
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
      AvisarCambioEnAvisos;
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

procedure TPresentadorLineaCotizacion.FiltrarCategoria(const ATexto: string;
  const ACategoriaId: Integer);
begin
  if ACategoriaId = FCategoriaBuscada then
    Exit;
  Buscar(ATexto, ACategoriaId);
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
  FCategoriaBuscada := ACategoriaId;

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
