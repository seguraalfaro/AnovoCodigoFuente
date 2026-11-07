unit Anovo.Presentadores.SolicitudNueva;

// Solicitud registrada en la oficina: datos basicos, una pieza con sus medidas
// a mano y los planos del cliente como imagen, sin croquis (minuta 19/2026).

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Anovo.Presentadores.Base,
  Anovo.Api.Intf.Clientes,
  Anovo.Api.Intf.Catalogos,
  Anovo.Api.Intf.Solicitudes,
  Anovo.DTOs.Clientes,
  Anovo.DTOs.Catalogos,
  Anovo.DTOs.Solicitudes,
  Anovo.Vistas.Intf.SolicitudNueva;

type
  TPresentadorSolicitudNueva = class(TPresentadorBase)
  private
    FVista: IVistaSolicitudNueva;
    FSolicitudes: IApiSolicitudes;
    FClientes: IApiClientes;
    FCatalogos: IApiCatalogos;
    FClienteId: Integer;
    FMedidas: TObjectList<TMedidaOficina>;
    FPlanos: TObjectList<TPlanoOficina>;
    procedure CargarContactos;
    procedure CargarCatalogos;
    function Reparos(const ASolicitud: TSolicitudNuevaDTO;
      const APieza: TPiezaNuevaDTO): TStringList;
    function Armar(const ASolicitud: TSolicitudNuevaDTO;
      const APieza: TPiezaNuevaDTO): TSolicitudCompletaDTO;
    class procedure AdjuntarPlanos(const ADto: TSolicitudCompletaDTO;
      const ARutas: TArray<string>); static;
  public
    constructor Create(const AVista: IVistaSolicitudNueva;
      const ASolicitudes: IApiSolicitudes; const AClientes: IApiClientes;
      const ACatalogos: IApiCatalogos; const AClienteId: Integer);
    destructor Destroy; override;
    procedure Iniciar;
    function AgregarMedida(const ATipo, ATipoNombre: string;
      const AValor: Double; const AUnidad: string; const ACantidad: Integer;
      const AObservacion: string): Boolean;
    procedure QuitarMedida(const AIndice: Integer);
    procedure AgregarPlanos(const AArchivos: TStrings);
    procedure QuitarPlano(const AIndice: Integer);
    procedure Guardar(const ASolicitud: TSolicitudNuevaDTO;
      const APieza: TPiezaNuevaDTO);
  end;

implementation

uses
  System.IOUtils,
  System.NetEncoding,
  Anovo.Api.Base,
  Anovo.Textos;

const
  PLANO_MAXIMO_BYTES = 3145728;
  PLANOS_MAXIMO = 20;
  CANTIDAD_MAXIMA = 9999;
  ADJUNTO_FOTO = 'foto';

function TamanoDe(const ARuta: string): Int64;
var
  lArchivo: TFileStream;
begin
  lArchivo := TFileStream.Create(ARuta, fmOpenRead or fmShareDenyNone);
  try
    Result := lArchivo.Size;
  finally
    lArchivo.Free;
  end;
end;

function NuevoId: string;
begin
  Result := LowerCase(TGUID.NewGuid.ToString.Replace('{', '').Replace('}', ''));
end;

constructor TPresentadorSolicitudNueva.Create(const AVista: IVistaSolicitudNueva;
  const ASolicitudes: IApiSolicitudes; const AClientes: IApiClientes;
  const ACatalogos: IApiCatalogos; const AClienteId: Integer);
begin
  inherited Create;
  FVista := AVista;
  FSolicitudes := ASolicitudes;
  FClientes := AClientes;
  FCatalogos := ACatalogos;
  FClienteId := AClienteId;
  FMedidas := TObjectList<TMedidaOficina>.Create(True);
  FPlanos := TObjectList<TPlanoOficina>.Create(True);
end;

destructor TPresentadorSolicitudNueva.Destroy;
begin
  FMedidas.Free;
  FPlanos.Free;
  inherited;
end;

procedure TPresentadorSolicitudNueva.Iniciar;
begin
  CargarContactos;
  CargarCatalogos;
  FVista.MostrarMedidas(FMedidas);
  FVista.MostrarPlanos(FPlanos);
end;

procedure TPresentadorSolicitudNueva.CargarContactos;
var
  lApi: IApiClientes;
  lCliente: Integer;
begin
  lApi := FClientes;
  lCliente := FClienteId;

  Ejecutar<TObjectList<TContactoDTO>>(SAccionCargarContactos,
    function: TObjectList<TContactoDTO>
    begin
      Result := lApi.Contactos(lCliente);
    end,
    procedure(AContactos: TObjectList<TContactoDTO>)
    var
      lActivos: TObjectList<TContactoDTO>;
      lContacto: TContactoDTO;
      lPrincipal: Integer;
    begin
      lPrincipal := 0;
      lActivos := TObjectList<TContactoDTO>.Create(False);
      try
        for lContacto in AContactos do
          if lContacto.Activo and not lContacto.Anonimizado then
          begin
            lActivos.Add(lContacto);
            if lContacto.Principal or (lPrincipal = 0) then
              lPrincipal := lContacto.ID;
          end;
        FVista.MostrarContactos(lActivos, lPrincipal);
        if lActivos.Count = 0 then
          FVista.MostrarError(SClienteSinContactosActivos);
      finally
        lActivos.Free;
      end;
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end,
    procedure(AActivo: Boolean)
    begin
      FVista.MostrarGuardando(AActivo);
    end);
end;

procedure TPresentadorSolicitudNueva.CargarCatalogos;
var
  lApi: IApiCatalogos;
begin
  lApi := FCatalogos;

  Ejecutar<TObjectList<TTipoTrabajoDTO>>(SAccionCargarCatalogosPieza,
    function: TObjectList<TTipoTrabajoDTO>
    begin
      Result := lApi.TiposTrabajo(False);
    end,
    procedure(ATipos: TObjectList<TTipoTrabajoDTO>)
    begin
      FVista.MostrarTiposTrabajo(ATipos);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end);

  Ejecutar<TObjectList<TCatalogoSimpleDTO>>(SAccionCargarCatalogosPieza,
    function: TObjectList<TCatalogoSimpleDTO>
    begin
      Result := lApi.Simples(csTipoMaterial, False);
    end,
    procedure(AMateriales: TObjectList<TCatalogoSimpleDTO>)
    begin
      FVista.MostrarMateriales(AMateriales);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end);

  Ejecutar<TObjectList<TCatalogoSimpleDTO>>(SAccionCargarCatalogosPieza,
    function: TObjectList<TCatalogoSimpleDTO>
    begin
      Result := lApi.Simples(csAcabado, False);
    end,
    procedure(AAcabados: TObjectList<TCatalogoSimpleDTO>)
    begin
      FVista.MostrarAcabados(AAcabados);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end);

  Ejecutar<TObjectList<TUnidadMedidaDTO>>(SAccionCargarCatalogosPieza,
    function: TObjectList<TUnidadMedidaDTO>
    begin
      Result := lApi.UnidadesMedida(False);
    end,
    procedure(AUnidades: TObjectList<TUnidadMedidaDTO>)
    begin
      FVista.MostrarUnidades(AUnidades);
    end,
    procedure(AMensaje: string)
    begin
      FVista.MostrarError(AMensaje);
    end);
end;

function TPresentadorSolicitudNueva.AgregarMedida(const ATipo,
  ATipoNombre: string; const AValor: Double; const AUnidad: string;
  const ACantidad: Integer; const AObservacion: string): Boolean;
var
  lReparos: TStringList;
  lMedida: TMedidaOficina;
begin
  lReparos := TStringList.Create;
  try
    if ATipo.Trim.IsEmpty then
      lReparos.Add(SFaltaTipoMedida);
    if AValor <= 0 then
      lReparos.Add(SMedidaValorInvalido);
    if AUnidad.Trim.IsEmpty then
      lReparos.Add(SFaltaUnidadMedida);
    if (ACantidad < 1) or (ACantidad > CANTIDAD_MAXIMA) then
      lReparos.Add(SMedidaCantidadInvalida);
    Result := lReparos.Count = 0;
    if not Result then
    begin
      FVista.AvisarReparos(lReparos);
      Exit;
    end;
  finally
    lReparos.Free;
  end;

  lMedida := TMedidaOficina.Create;
  lMedida.TipoMedida := ATipo;
  lMedida.TipoNombre := ATipoNombre;
  lMedida.Valor := AValor;
  lMedida.UnidadMedida := AUnidad;
  lMedida.Cantidad := ACantidad;
  lMedida.Observacion := AObservacion.Trim;
  FMedidas.Add(lMedida);
  FVista.MostrarMedidas(FMedidas);
end;

procedure TPresentadorSolicitudNueva.QuitarMedida(const AIndice: Integer);
begin
  if (AIndice < 0) or (AIndice >= FMedidas.Count) then
    Exit;
  FMedidas.Delete(AIndice);
  FVista.MostrarMedidas(FMedidas);
end;

procedure TPresentadorSolicitudNueva.AgregarPlanos(const AArchivos: TStrings);
var
  lRuta: string;
  lTamano: Int64;
  lPlano: TPlanoOficina;
begin
  for lRuta in AArchivos do
  begin
    if FPlanos.Count >= PLANOS_MAXIMO then
    begin
      FVista.MostrarError(Format(SPlanosMaximo, [PLANOS_MAXIMO]));
      Break;
    end;
    try
      lTamano := TamanoDe(lRuta);
    except
      FVista.MostrarError(Format(SPlanoNoSeLee, [ExtractFileName(lRuta)]));
      Continue;
    end;
    if lTamano > PLANO_MAXIMO_BYTES then
    begin
      FVista.MostrarError(Format(SPlanoMuyGrande, [ExtractFileName(lRuta)]));
      Continue;
    end;
    lPlano := TPlanoOficina.Create;
    lPlano.Nombre := ExtractFileName(lRuta);
    lPlano.Ruta := lRuta;
    lPlano.TamanoKb := (lTamano + 1023) div 1024;
    FPlanos.Add(lPlano);
  end;
  FVista.MostrarPlanos(FPlanos);
end;

procedure TPresentadorSolicitudNueva.QuitarPlano(const AIndice: Integer);
begin
  if (AIndice < 0) or (AIndice >= FPlanos.Count) then
    Exit;
  FPlanos.Delete(AIndice);
  FVista.MostrarPlanos(FPlanos);
end;

function TPresentadorSolicitudNueva.Reparos(const ASolicitud
  : TSolicitudNuevaDTO; const APieza: TPiezaNuevaDTO): TStringList;
begin
  Result := TStringList.Create;
  if not ASolicitud.ClienteContactoId.HasValue or
    (ASolicitud.ClienteContactoId.Value <= 0) then
    Result.Add(SFaltaContactoSolicitud);
  if not ASolicitud.NombreProyecto.HasValue or
    ASolicitud.NombreProyecto.Value.Trim.IsEmpty then
    Result.Add(SFaltaNombreProyecto);
  if ASolicitud.Descripcion.Trim.IsEmpty then
    Result.Add(SFaltaDescripcionSolicitud);
  if APieza.Nombre.Trim.IsEmpty then
    Result.Add(SFaltaNombrePiezaOficina);
  if not APieza.TipoTrabajoId.HasValue or (APieza.TipoTrabajoId.Value <= 0) then
    Result.Add(SFaltaTipoTrabajoPieza);
  if not APieza.TipoMaterialId.HasValue or (APieza.TipoMaterialId.Value <= 0)
  then
    Result.Add(SFaltaMaterialPieza);
  if not APieza.AcabadoId.HasValue or (APieza.AcabadoId.Value <= 0) then
    Result.Add(SFaltaAcabadoPieza);
  if FMedidas.Count = 0 then
    Result.Add(SFaltaMedidasPieza);
end;

function TPresentadorSolicitudNueva.Armar(const ASolicitud: TSolicitudNuevaDTO;
  const APieza: TPiezaNuevaDTO): TSolicitudCompletaDTO;
var
  lMedida: TMedidaOficina;
  lNueva: TMedidaNuevaDTO;
  I: Integer;
begin
  Result := TSolicitudCompletaDTO.Create;
  try
    Result.Solicitud.Free;
    Result.Solicitud := ASolicitud;
    APieza.UuidLocal := NuevoId;
    APieza.Nombre := APieza.Nombre.Trim;
    APieza.Orden := 1;
    for I := 0 to FMedidas.Count - 1 do
    begin
      lMedida := FMedidas[I];
      lNueva := TMedidaNuevaDTO.Create;
      lNueva.UuidLocal := NuevoId;
      lNueva.TipoMedida := lMedida.TipoMedida;
      lNueva.Valor := lMedida.Valor;
      lNueva.UnidadMedida := lMedida.UnidadMedida;
      lNueva.Cantidad := lMedida.Cantidad;
      if not lMedida.Observacion.IsEmpty then
        lNueva.Observacion := lMedida.Observacion;
      lNueva.Orden := I + 1;
      APieza.Medidas.Add(lNueva);
    end;
    Result.Piezas.Add(APieza);
  except
    Result.Free;
    raise;
  end;
end;

class procedure TPresentadorSolicitudNueva.AdjuntarPlanos(const ADto
  : TSolicitudCompletaDTO; const ARutas: TArray<string>);
var
  lPieza: TPiezaNuevaDTO;
  lAdjunto: TAdjuntoNuevoDTO;
  lCodigo: TBase64Encoding;
  lRuta: string;
begin
  lPieza := ADto.Piezas[0];
  lCodigo := TBase64Encoding.Create(0, '');
  try
    for lRuta in ARutas do
    begin
      lAdjunto := TAdjuntoNuevoDTO.Create;
      lPieza.Adjuntos.Add(lAdjunto);
      lAdjunto.UuidLocal := NuevoId;
      lAdjunto.Tipo := ADJUNTO_FOTO;
      lAdjunto.NombreArchivo := ExtractFileName(lRuta);
      try
        lAdjunto.Contenido :=
          lCodigo.EncodeBytesToString(TFile.ReadAllBytes(lRuta));
      except
        raise EAnovoCliente.Create(Format(SPlanoNoSeLee,
          [ExtractFileName(lRuta)]));
      end;
    end;
  finally
    lCodigo.Free;
  end;
end;

procedure TPresentadorSolicitudNueva.Guardar(const ASolicitud
  : TSolicitudNuevaDTO; const APieza: TPiezaNuevaDTO);
var
  lApi: IApiSolicitudes;
  lReparos: TStringList;
  lDto: TSolicitudCompletaDTO;
  lRutas: TArray<string>;
  lId: Integer;
  I: Integer;
begin
  lReparos := Reparos(ASolicitud, APieza);
  try
    if lReparos.Count > 0 then
    begin
      ASolicitud.Free;
      APieza.Free;
      FVista.AvisarReparos(lReparos);
      Exit;
    end;
  finally
    lReparos.Free;
  end;

  lDto := Armar(ASolicitud, APieza);
  SetLength(lRutas, FPlanos.Count);
  for I := 0 to FPlanos.Count - 1 do
    lRutas[I] := FPlanos[I].Ruta;

  lApi := FSolicitudes;
  lId := 0;
  Ejecutar(SAccionGuardar,
    procedure
    begin
      AdjuntarPlanos(lDto, lRutas);
      lId := lApi.RegistrarEnOficina(lDto);
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
