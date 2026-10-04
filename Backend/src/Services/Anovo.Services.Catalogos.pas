unit Anovo.Services.Catalogos;

// Servicio de catalogos: duplicados por nombre, cambio de
// precio con historial y precios programados.

interface

uses
  System.Generics.Collections,
  MVCFramework,
  Anovo.DTOs.Catalogos,
  Anovo.Entities.Catalogos,
  Anovo.Repositories.Intf.Catalogos,
  Anovo.Services.Intf.Catalogos;

type
  TCatalogoService = class(TInterfacedObject, ICatalogoService)
  private
    fMateriales: IMaterialRepository;
    fMaterialesPrecios: IMaterialPrecioRepository;
    fManoObra: IManoObraRepository;
    fManoObraPrecios: IManoObraPrecioRepository;
    fCategorias: IManoObraCategoriaRepository;
    fMaquinas: IMaquinaRepository;
    fMaquinasPrecios: IMaquinaPrecioRepository;
    fProgramados: IPrecioProgramadoRepository;
    fTodos: ICatalogoTodosRepository;
    fTiposTrabajo: ITipoTrabajoRepository;
    fUnidades: IUnidadMedidaRepository;

    function TraerMaterial(const AId: Integer): TMateriales;
    function TraerManoObra(const AId: Integer): TManoObra;
    function TraerMaquina(const AId: Integer): TMaquinas;
    function TraerTipoTrabajo(const AId: Integer): TTiposTrabajo;
    function TraerUnidadMedida(const AId: Integer): TUnidadesMedida;
    function NombreUnidadMedida(const AId: Integer): string;
    procedure ValidarUnidadActiva(const AId: Integer);
    procedure ValidarUnidadMedida(const ADto: TUnidadMedidaNuevaDTO;
      const AExcluirId: Integer);
  public
    [MVCInject]
    constructor Create(AMateriales: IMaterialRepository;
      AMaterialesPrecios: IMaterialPrecioRepository;
      AManoObra: IManoObraRepository;
      AManoObraPrecios: IManoObraPrecioRepository;
      ACategorias: IManoObraCategoriaRepository;
      AMaquinas: IMaquinaRepository;
      AMaquinasPrecios: IMaquinaPrecioRepository;
      ATiposTrabajo: ITipoTrabajoRepository;
      AProgramados: IPrecioProgramadoRepository;
      ATodos: ICatalogoTodosRepository;
      AUnidades: IUnidadMedidaRepository); reintroduce;

    function BuscarTodos(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TCatalogoItemDTO>;

    function BuscarMateriales(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TMaterialDTO>;
    function ObtenerMaterial(const AId: Integer): TMaterialDTO;
    function CrearMaterial(const ADto: TMaterialNuevoDTO): Integer;
    procedure ActualizarMaterial(const AId: Integer;
      const ADto: TMaterialEdicionDTO);
    procedure InactivarMaterial(const AId: Integer);
    procedure CambiarPrecioMaterial(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialPrecioMaterial(const AId: Integer)
      : TObjectList<TPrecioDTO>;

    function BuscarManoObra(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      const ACategoriaId: Integer; out ATotal: Int64)
      : TObjectList<TManoObraDTO>;
    function ObtenerManoObra(const AId: Integer): TManoObraDTO;
    function CrearManoObra(const ADto: TManoObraNuevaDTO): Integer;
    procedure ActualizarManoObra(const AId: Integer;
      const ADto: TManoObraEdicionDTO);
    procedure InactivarManoObra(const AId: Integer);
    procedure CambiarPrecioManoObra(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialPrecioManoObra(const AId: Integer)
      : TObjectList<TPrecioDTO>;
    function Categorias: TObjectList<TCategoriaDTO>;

    function BuscarMaquinas(const ATexto: string;
      const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
      out ATotal: Int64): TObjectList<TMaquinaDTO>;
    function ObtenerMaquina(const AId: Integer): TMaquinaDTO;
    function CrearMaquina(const ADto: TMaquinaNuevaDTO): Integer;
    procedure ActualizarMaquina(const AId: Integer;
      const ADto: TMaquinaEdicionDTO);
    procedure InactivarMaquina(const AId: Integer);
    procedure CambiarCostoMaquina(const AId: Integer;
      const ADto: TPrecioNuevoDTO);
    function HistorialCostoMaquina(const AId: Integer)
      : TObjectList<TPrecioDTO>;

    function TiposTrabajo(const AIncluirInactivos: Boolean;
      const ATexto: string = ''): TObjectList<TTipoTrabajoDTO>;
    function CrearTipoTrabajo(const ADto: TTipoTrabajoNuevoDTO): Integer;
    procedure ActualizarTipoTrabajo(const AId: Integer;
      const ADto: TTipoTrabajoNuevoDTO);
    procedure InactivarTipoTrabajo(const AId: Integer);

    function UnidadesMedida(const AIncluirInactivas: Boolean;
      const ATexto: string = ''): TObjectList<TUnidadMedidaDTO>;
    function CrearUnidadMedida(const ADto: TUnidadMedidaNuevaDTO): Integer;
    procedure ActualizarUnidadMedida(const AId: Integer;
      const ADto: TUnidadMedidaNuevaDTO);
    procedure InactivarUnidadMedida(const AId: Integer);
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.Textos,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Consultas,
  Anovo.Errors,
  Anovo.Mapeo;

constructor TCatalogoService.Create(AMateriales: IMaterialRepository;
  AMaterialesPrecios: IMaterialPrecioRepository;
  AManoObra: IManoObraRepository;
  AManoObraPrecios: IManoObraPrecioRepository;
  ACategorias: IManoObraCategoriaRepository; AMaquinas: IMaquinaRepository;
  AMaquinasPrecios: IMaquinaPrecioRepository;
  ATiposTrabajo: ITipoTrabajoRepository;
  AProgramados: IPrecioProgramadoRepository;
  ATodos: ICatalogoTodosRepository; AUnidades: IUnidadMedidaRepository);
begin
  inherited Create;
  fMateriales := AMateriales;
  fMaterialesPrecios := AMaterialesPrecios;
  fManoObra := AManoObra;
  fManoObraPrecios := AManoObraPrecios;
  fCategorias := ACategorias;
  fMaquinas := AMaquinas;
  fMaquinasPrecios := AMaquinasPrecios;
  fTiposTrabajo := ATiposTrabajo;
  fProgramados := AProgramados;
  fTodos := ATodos;
  fUnidades := AUnidades;
end;

const
  ESTADO_PENDIENTE = 'pendiente';

function Detalle(const AProgramado: Boolean;
  const ACambio, AProgramada, ANombre: string): string;
begin
  if AProgramado then
    Result := Format(AProgramada, [ANombre])
  else
    Result := Format(ACambio, [ANombre]);
end;

function Programado(const ADto: TPrecioNuevoDTO): Boolean;
begin
  Result := ADto.FechaVigencia.HasValue and (ADto.FechaVigencia.Value > Now);
end;

procedure ValidarVigencia(const ADto: TPrecioNuevoDTO);
begin
  if ADto.FechaVigencia.HasValue and (ADto.FechaVigencia.Value < Date) then
    raise EDatoInvalido.Create
      (SVigenciaAnterior);
end;

function TCatalogoService.TraerMaterial(const AId: Integer): TMateriales;
begin
  Result := fMateriales.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoMaterial, AId);
end;

function TCatalogoService.TraerManoObra(const AId: Integer): TManoObra;
begin
  Result := fManoObra.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoManoObra, AId);
end;

function TCatalogoService.TraerMaquina(const AId: Integer): TMaquinas;
begin
  Result := fMaquinas.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoMaquina, AId);
end;

function TCatalogoService.TraerTipoTrabajo(const AId: Integer): TTiposTrabajo;
begin
  Result := fTiposTrabajo.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoTipoTrabajo, AId);
end;

function TCatalogoService.TraerUnidadMedida(const AId: Integer)
  : TUnidadesMedida;
begin
  Result := fUnidades.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create(SRecursoUnidadMedida, AId);
end;

function TCatalogoService.NombreUnidadMedida(const AId: Integer): string;
var
  lUnidad: TUnidadesMedida;
begin
  lUnidad := TraerUnidadMedida(AId);
  try
    Result := lUnidad.Nombre;
  finally
    lUnidad.Free;
  end;
end;


procedure TCatalogoService.ValidarUnidadActiva(const AId: Integer);
var
  lUnidad: TUnidadesMedida;
begin
  lUnidad := TraerUnidadMedida(AId);
  try
    if not lUnidad.Activo.ValueOrDefault then
      raise EDatoInvalido.Create(SUnidadMedidaInactiva);
  finally
    lUnidad.Free;
  end;
end;


procedure TCatalogoService.ValidarUnidadMedida(const ADto: TUnidadMedidaNuevaDTO;
  const AExcluirId: Integer);
begin
  if not MatchStr(ADto.Magnitud, MAGNITUDES) then
    raise EDatoInvalido.Create(SMagnitudInvalida);
  if fUnidades.ExisteNombre(ADto.Nombre, AExcluirId) then
    if AExcluirId = 0 then
      raise EDatoInvalido.Create(SNombreDuplicadoUnidadMedida)
    else
      raise EDatoInvalido.Create(SNombreDuplicadoOtraUnidadMedida);
end;

function TCatalogoService.BuscarTodos(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  out ATotal: Int64): TObjectList<TCatalogoItemDTO>;
var
  lFilas: TObjectList<TCatalogoTodos>;
begin
  ATotal := fTodos.ContarBusqueda(ATexto, AIncluirInactivos);
  lFilas := fTodos.Buscar(ATexto, APagina, APorPagina, AIncluirInactivos);
  try
    Result := TMapeo.AListaDto<TCatalogoTodos, TCatalogoItemDTO>
      (lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCatalogoService.BuscarMateriales(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  out ATotal: Int64): TObjectList<TMaterialDTO>;
var
  lFilas: TObjectList<TMaterialesConPrecio>;
begin
  ATotal := fMateriales.ContarBusqueda(ATexto, AIncluirInactivos);
  lFilas := fMateriales.BuscarConPrecio(ATexto, APagina, APorPagina,
    AIncluirInactivos);
  try
    Result := TMapeo.AListaDto<TMaterialesConPrecio, TMaterialDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCatalogoService.ObtenerMaterial(const AId: Integer): TMaterialDTO;
var
  lMaterial: TMateriales;
  lPrecio: TMaterialesPrecios;
begin
  lMaterial := TraerMaterial(AId);
  try
    Result := TMapeo.ADto<TMaterialDTO>(lMaterial);
    Result.UnidadMedida := NombreUnidadMedida(lMaterial.UnidadMedidaId);
  finally
    lMaterial.Free;
  end;

  lPrecio := fMaterialesPrecios.PrecioVigenteDe(AId);
  if lPrecio <> nil then
    try
      Result.CostoUnitario := lPrecio.CostoUnitario;
      Result.PrecioUnitario := lPrecio.PrecioUnitario;
      Result.FechaVigencia := lPrecio.FechaVigencia;
    finally
      lPrecio.Free;
    end;
end;

function TCatalogoService.CrearMaterial(const ADto: TMaterialNuevoDTO): Integer;
var
  lMaterial: TMateriales;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  ValidarUnidadActiva(ADto.UnidadMedidaId);
  if fMateriales.ExisteNombre(ADto.Nombre) then
    raise EDatoInvalido.Create
      (SNombreDuplicadoMaterial);

  lMaterial := TMateriales.Create;
  try
    TMapeo.Copiar(ADto, lMaterial);
    lMaterial.Activo := True;
    FijarDetalle(Format(SDetalleRegistroMaterial, [ADto.Nombre]));
    fMateriales.Insert(lMaterial);
    Result := lMaterial.ID.ValueOrDefault;
  finally
    lMaterial.Free;
  end;
end;

procedure TCatalogoService.ActualizarMaterial(const AId: Integer;
  const ADto: TMaterialEdicionDTO);
var
  lMaterial: TMateriales;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lMaterial := TraerMaterial(AId);
  try
    if fMateriales.ExisteNombre(ADto.Nombre, AId) then
      raise EDatoInvalido.Create
        (SNombreDuplicadoOtroMaterial);
    if ADto.UnidadMedidaId <> lMaterial.UnidadMedidaId then
      ValidarUnidadActiva(ADto.UnidadMedidaId);

    TMapeo.Copiar(ADto, lMaterial);
    FijarDetalle(Format(SDetalleCambioMaterial, [ADto.Nombre]));
    fMateriales.Update(lMaterial);
  finally
    lMaterial.Free;
  end;
end;

procedure TCatalogoService.InactivarMaterial(const AId: Integer);
var
  lMaterial: TMateriales;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lMaterial := TraerMaterial(AId);
  try
    lMaterial.Activo := False;
    FijarDetalle(Format(SDetalleInactivacionMaterial, [lMaterial.Nombre]));
    fMateriales.Update(lMaterial);
  finally
    lMaterial.Free;
  end;
end;

procedure TCatalogoService.CambiarPrecioMaterial(const AId: Integer;
  const ADto: TPrecioNuevoDTO);
var
  lMaterial: TMateriales;
  lVigente: TMaterialesPrecios;
  lNuevo: TMaterialesPrecios;
  lProgramado: Boolean;
  lPendiente: TPreciosProgramados;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lMaterial := TraerMaterial(AId);
  try
    if not ADto.PrecioUnitario.HasValue then
      raise EDatoInvalido.Create(SFaltaPrecioUnitario);

    ValidarVigencia(ADto);

    lProgramado := Programado(ADto);

    FijarDetalle(Detalle(lProgramado, SDetalleCambioPrecioMaterial,
      SDetallePrecioProgramadoMaterial, lMaterial.Nombre));

    if lProgramado then
    begin
      lPendiente := TPreciosProgramados.Create;
      try
        lPendiente.MaterialId := AId;
        lPendiente.CostoUnitario := ADto.CostoUnitario;
        lPendiente.PrecioUnitario := ADto.PrecioUnitario;
        lPendiente.FechaVigencia := ADto.FechaVigencia.Value;
        lPendiente.Estado := ESTADO_PENDIENTE;
        lPendiente.CreadoPor := UsuarioActual;
        fProgramados.Insert(lPendiente);
      finally
        lPendiente.Free;
      end;
      Exit;
    end;

    lVigente := fMaterialesPrecios.PrecioVigenteDe(AId);
    if lVigente <> nil then
      try
        lVigente.Activo := False;
        fMaterialesPrecios.Update(lVigente);
      finally
        lVigente.Free;
      end;

    lNuevo := TMaterialesPrecios.Create;
    try
      lNuevo.MaterialId := AId;
      lNuevo.CostoUnitario := ADto.CostoUnitario;
      lNuevo.PrecioUnitario := ADto.PrecioUnitario;
      lNuevo.Activo := True;
      if ADto.FechaVigencia.HasValue then
        lNuevo.FechaVigencia := ADto.FechaVigencia.Value
      else
        lNuevo.FechaVigencia := Now;
      lNuevo.ModificadoPor := UsuarioActual;
      fMaterialesPrecios.Insert(lNuevo);
    finally
      lNuevo.Free;
    end;
  finally
    lMaterial.Free;
  end;
end;

function TCatalogoService.HistorialPrecioMaterial(const AId: Integer)
  : TObjectList<TPrecioDTO>;
var
  lFilas: TObjectList<TMaterialesPrecios>;
begin
  lFilas := fMaterialesPrecios.HistorialDe(AId);
  try
    Result := TMapeo.AListaDto<TMaterialesPrecios, TPrecioDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCatalogoService.BuscarManoObra(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  const ACategoriaId: Integer; out ATotal: Int64): TObjectList<TManoObraDTO>;
var
  lFilas: TObjectList<TManoObraConPrecio>;
begin
  ATotal := fManoObra.ContarBusqueda(ATexto, AIncluirInactivos, ACategoriaId);
  lFilas := fManoObra.BuscarConPrecio(ATexto, APagina, APorPagina,
    AIncluirInactivos, ACategoriaId);
  try
    Result := TMapeo.AListaDto<TManoObraConPrecio, TManoObraDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCatalogoService.ObtenerManoObra(const AId: Integer): TManoObraDTO;
var
  lItem: TManoObra;
  lPrecio: TManoObraPrecios;
begin
  lItem := TraerManoObra(AId);
  try
    Result := TMapeo.ADto<TManoObraDTO>(lItem);
    Result.UnidadMedida := NombreUnidadMedida(lItem.UnidadMedidaId);
  finally
    lItem.Free;
  end;

  lPrecio := fManoObraPrecios.PrecioVigenteDe(AId);
  if lPrecio <> nil then
    try
      Result.CostoUnitario := lPrecio.CostoUnitario;
      Result.FechaVigencia := lPrecio.FechaVigencia;
    finally
      lPrecio.Free;
    end;
end;

function TCatalogoService.CrearManoObra(const ADto: TManoObraNuevaDTO): Integer;
var
  lItem: TManoObra;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  ValidarUnidadActiva(ADto.UnidadMedidaId);
  if fManoObra.ExisteNombre(ADto.Nombre) then
    raise EDatoInvalido.Create(SNombreDuplicadoManoObra);

  lItem := TManoObra.Create;
  try
    TMapeo.Copiar(ADto, lItem);
    lItem.Activo := True;
    FijarDetalle(Format(SDetalleRegistroManoObra, [ADto.Nombre]));
    fManoObra.Insert(lItem);
    Result := lItem.ID.ValueOrDefault;
  finally
    lItem.Free;
  end;
end;

procedure TCatalogoService.ActualizarManoObra(const AId: Integer;
  const ADto: TManoObraEdicionDTO);
var
  lItem: TManoObra;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lItem := TraerManoObra(AId);
  try
    if fManoObra.ExisteNombre(ADto.Nombre, AId) then
      raise EDatoInvalido.Create
        (SNombreDuplicadoOtraManoObra);
    if ADto.UnidadMedidaId <> lItem.UnidadMedidaId then
      ValidarUnidadActiva(ADto.UnidadMedidaId);

    TMapeo.Copiar(ADto, lItem);
    FijarDetalle(Format(SDetalleCambioManoObra, [ADto.Nombre]));
    fManoObra.Update(lItem);
  finally
    lItem.Free;
  end;
end;

procedure TCatalogoService.InactivarManoObra(const AId: Integer);
var
  lItem: TManoObra;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lItem := TraerManoObra(AId);
  try
    lItem.Activo := False;
    FijarDetalle(Format(SDetalleInactivacionManoObra, [lItem.Nombre]));
    fManoObra.Update(lItem);
  finally
    lItem.Free;
  end;
end;

procedure TCatalogoService.CambiarPrecioManoObra(const AId: Integer;
  const ADto: TPrecioNuevoDTO);
var
  lItem: TManoObra;
  lVigente: TManoObraPrecios;
  lNuevo: TManoObraPrecios;
  lProgramado: Boolean;
  lPendiente: TPreciosProgramados;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lItem := TraerManoObra(AId);
  try
    if not ADto.CostoUnitario.HasValue then
      raise EDatoInvalido.Create(SFaltaCostoUnitario);

    ValidarVigencia(ADto);

    lProgramado := Programado(ADto);

    FijarDetalle(Detalle(lProgramado, SDetalleCambioCostoManoObra,
      SDetallePrecioProgramadoManoObra, lItem.Nombre));

    if lProgramado then
    begin
      lPendiente := TPreciosProgramados.Create;
      try
        lPendiente.ManoObraId := AId;
        lPendiente.CostoUnitario := ADto.CostoUnitario;
        lPendiente.FechaVigencia := ADto.FechaVigencia.Value;
        lPendiente.Estado := ESTADO_PENDIENTE;
        lPendiente.CreadoPor := UsuarioActual;
        fProgramados.Insert(lPendiente);
      finally
        lPendiente.Free;
      end;
      Exit;
    end;

    lVigente := fManoObraPrecios.PrecioVigenteDe(AId);
    if lVigente <> nil then
      try
        lVigente.Activo := False;
        fManoObraPrecios.Update(lVigente);
      finally
        lVigente.Free;
      end;

    lNuevo := TManoObraPrecios.Create;
    try
      lNuevo.ManoObraId := AId;
      lNuevo.CostoUnitario := ADto.CostoUnitario;
      lNuevo.Activo := True;
      if ADto.FechaVigencia.HasValue then
        lNuevo.FechaVigencia := ADto.FechaVigencia.Value
      else
        lNuevo.FechaVigencia := Now;
      lNuevo.ModificadoPor := UsuarioActual;
      fManoObraPrecios.Insert(lNuevo);
    finally
      lNuevo.Free;
    end;
  finally
    lItem.Free;
  end;
end;

function TCatalogoService.HistorialPrecioManoObra(const AId: Integer)
  : TObjectList<TPrecioDTO>;
var
  lFilas: TObjectList<TManoObraPrecios>;
begin
  lFilas := fManoObraPrecios.HistorialDe(AId);
  try
    Result := TMapeo.AListaDto<TManoObraPrecios, TPrecioDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCatalogoService.Categorias: TObjectList<TCategoriaDTO>;
var
  lFilas: TObjectList<TManoObraCategoria>;
begin
  lFilas := fCategorias.Todas;
  try
    Result := TMapeo.AListaDto<TManoObraCategoria, TCategoriaDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCatalogoService.BuscarMaquinas(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  out ATotal: Int64): TObjectList<TMaquinaDTO>;
var
  lFilas: TObjectList<TMaquinasConPrecio>;
begin
  ATotal := fMaquinas.ContarBusqueda(ATexto, AIncluirInactivos);
  lFilas := fMaquinas.BuscarConPrecio(ATexto, APagina, APorPagina,
    AIncluirInactivos);
  try
    Result := TMapeo.AListaDto<TMaquinasConPrecio, TMaquinaDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCatalogoService.ObtenerMaquina(const AId: Integer): TMaquinaDTO;
var
  lMaquina: TMaquinas;
  lPrecio: TMaquinasPrecios;
begin
  lMaquina := TraerMaquina(AId);
  try
    Result := TMapeo.ADto<TMaquinaDTO>(lMaquina);
  finally
    lMaquina.Free;
  end;

  lPrecio := fMaquinasPrecios.PrecioVigenteDe(AId);
  if lPrecio <> nil then
    try
      Result.CostoHora := lPrecio.CostoHora;
      Result.FechaVigencia := lPrecio.FechaVigencia;
    finally
      lPrecio.Free;
    end;
end;

function TCatalogoService.CrearMaquina(const ADto: TMaquinaNuevaDTO): Integer;
var
  lMaquina: TMaquinas;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if fMaquinas.ExisteNombre(ADto.Nombre) then
    raise EDatoInvalido.Create(SNombreDuplicadoMaquina);

  lMaquina := TMaquinas.Create;
  try
    TMapeo.Copiar(ADto, lMaquina);
    lMaquina.Activo := True;
    FijarDetalle(Format(SDetalleRegistroMaquina, [ADto.Nombre]));
    fMaquinas.Insert(lMaquina);
    Result := lMaquina.ID.ValueOrDefault;
  finally
    lMaquina.Free;
  end;
end;

procedure TCatalogoService.ActualizarMaquina(const AId: Integer;
  const ADto: TMaquinaEdicionDTO);
var
  lMaquina: TMaquinas;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lMaquina := TraerMaquina(AId);
  try
    if fMaquinas.ExisteNombre(ADto.Nombre, AId) then
      raise EDatoInvalido.Create(SNombreDuplicadoOtraMaquina);

    TMapeo.Copiar(ADto, lMaquina);
    FijarDetalle(Format(SDetalleCambioMaquina, [ADto.Nombre]));
    fMaquinas.Update(lMaquina);
  finally
    lMaquina.Free;
  end;
end;

procedure TCatalogoService.InactivarMaquina(const AId: Integer);
var
  lMaquina: TMaquinas;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lMaquina := TraerMaquina(AId);
  try
    lMaquina.Activo := False;
    FijarDetalle(Format(SDetalleInactivacionMaquina, [lMaquina.Nombre]));
    fMaquinas.Update(lMaquina);
  finally
    lMaquina.Free;
  end;
end;

procedure TCatalogoService.CambiarCostoMaquina(const AId: Integer;
  const ADto: TPrecioNuevoDTO);
var
  lMaquina: TMaquinas;
  lVigente: TMaquinasPrecios;
  lNuevo: TMaquinasPrecios;
  lProgramado: Boolean;
  lPendiente: TPreciosProgramados;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lMaquina := TraerMaquina(AId);
  try
    if not ADto.CostoHora.HasValue then
      raise EDatoInvalido.Create(SFaltaCostoPorHora);

    ValidarVigencia(ADto);

    lProgramado := Programado(ADto);

    FijarDetalle(Detalle(lProgramado, SDetalleCambioCostoMaquina,
      SDetallePrecioProgramadoMaquina, lMaquina.Nombre));

    if lProgramado then
    begin
      lPendiente := TPreciosProgramados.Create;
      try
        lPendiente.MaquinaId := AId;
        lPendiente.CostoHora := ADto.CostoHora;
        lPendiente.FechaVigencia := ADto.FechaVigencia.Value;
        lPendiente.Estado := ESTADO_PENDIENTE;
        lPendiente.CreadoPor := UsuarioActual;
        fProgramados.Insert(lPendiente);
      finally
        lPendiente.Free;
      end;
      Exit;
    end;

    lVigente := fMaquinasPrecios.PrecioVigenteDe(AId);
    if lVigente <> nil then
      try
        lVigente.Activo := False;
        fMaquinasPrecios.Update(lVigente);
      finally
        lVigente.Free;
      end;

    lNuevo := TMaquinasPrecios.Create;
    try
      lNuevo.MaquinaId := AId;
      lNuevo.CostoHora := ADto.CostoHora;
      lNuevo.Activo := True;
      if ADto.FechaVigencia.HasValue then
        lNuevo.FechaVigencia := ADto.FechaVigencia.Value
      else
        lNuevo.FechaVigencia := Now;
      lNuevo.ModificadoPor := UsuarioActual;
      fMaquinasPrecios.Insert(lNuevo);
    finally
      lNuevo.Free;
    end;
  finally
    lMaquina.Free;
  end;
end;

function TCatalogoService.HistorialCostoMaquina(const AId: Integer)
  : TObjectList<TPrecioDTO>;
var
  lFilas: TObjectList<TMaquinasPrecios>;
begin
  lFilas := fMaquinasPrecios.HistorialDe(AId);
  try
    Result := TMapeo.AListaDto<TMaquinasPrecios, TPrecioDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCatalogoService.TiposTrabajo(const AIncluirInactivos: Boolean;
  const ATexto: string): TObjectList<TTipoTrabajoDTO>;
var
  lFilas: TObjectList<TTiposTrabajo>;
begin
  lFilas := fTiposTrabajo.Todos(AIncluirInactivos, ATexto.Trim);
  try
    Result := TMapeo.AListaDto<TTiposTrabajo, TTipoTrabajoDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCatalogoService.CrearTipoTrabajo(const ADto: TTipoTrabajoNuevoDTO)
  : Integer;
var
  lTipo: TTiposTrabajo;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if fTiposTrabajo.ExisteNombre(ADto.Nombre) then
    raise EDatoInvalido.Create(SNombreDuplicadoTipoTrabajo);

  lTipo := TTiposTrabajo.Create;
  try
    TMapeo.Copiar(ADto, lTipo);
    lTipo.Activo := True;
    FijarDetalle(Format(SDetalleRegistroTipoTrabajo, [ADto.Nombre]));
    fTiposTrabajo.Insert(lTipo);
    Result := lTipo.ID.ValueOrDefault;
  finally
    lTipo.Free;
  end;
end;

procedure TCatalogoService.ActualizarTipoTrabajo(const AId: Integer;
  const ADto: TTipoTrabajoNuevoDTO);
var
  lTipo: TTiposTrabajo;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lTipo := TraerTipoTrabajo(AId);
  try
    if fTiposTrabajo.ExisteNombre(ADto.Nombre, AId) then
      raise EDatoInvalido.Create
        (SNombreDuplicadoOtroTipoTrabajo);

    TMapeo.Copiar(ADto, lTipo);
    FijarDetalle(Format(SDetalleCambioTipoTrabajo, [ADto.Nombre]));
    fTiposTrabajo.Update(lTipo);
  finally
    lTipo.Free;
  end;
end;

procedure TCatalogoService.InactivarTipoTrabajo(const AId: Integer);
var
  lTipo: TTiposTrabajo;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lTipo := TraerTipoTrabajo(AId);
  try
    lTipo.Activo := False;
    FijarDetalle(Format(SDetalleInactivacionTipoTrabajo, [lTipo.Nombre]));
    fTiposTrabajo.Update(lTipo);
  finally
    lTipo.Free;
  end;
end;

function TCatalogoService.UnidadesMedida(const AIncluirInactivas: Boolean;
  const ATexto: string): TObjectList<TUnidadMedidaDTO>;
var
  lFilas: TObjectList<TUnidadesMedida>;
begin
  lFilas := fUnidades.Todas(AIncluirInactivas, ATexto.Trim);
  try
    Result := TMapeo.AListaDto<TUnidadesMedida, TUnidadMedidaDTO>(lFilas);
  finally
    lFilas.Free;
  end;
end;

function TCatalogoService.CrearUnidadMedida(const ADto: TUnidadMedidaNuevaDTO)
  : Integer;
var
  lUnidad: TUnidadesMedida;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  ValidarUnidadMedida(ADto, 0);

  lUnidad := TUnidadesMedida.Create;
  try
    TMapeo.Copiar(ADto, lUnidad);
    lUnidad.Activo := True;
    FijarDetalle(Format(SDetalleRegistroUnidadMedida, [ADto.Nombre]));
    fUnidades.Insert(lUnidad);
    Result := lUnidad.ID.ValueOrDefault;
  finally
    lUnidad.Free;
  end;
end;

procedure TCatalogoService.ActualizarUnidadMedida(const AId: Integer;
  const ADto: TUnidadMedidaNuevaDTO);
var
  lUnidad: TUnidadesMedida;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lUnidad := TraerUnidadMedida(AId);
  try
    ValidarUnidadMedida(ADto, AId);
    TMapeo.Copiar(ADto, lUnidad);
    FijarDetalle(Format(SDetalleCambioUnidadMedida, [ADto.Nombre]));
    fUnidades.Update(lUnidad);
  finally
    lUnidad.Free;
  end;
end;


procedure TCatalogoService.InactivarUnidadMedida(const AId: Integer);
var
  lUnidad: TUnidadesMedida;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lUnidad := TraerUnidadMedida(AId);
  try
    lUnidad.Activo := False;
    FijarDetalle(Format(SDetalleInactivacionUnidadMedida, [lUnidad.Nombre]));
    fUnidades.Update(lUnidad);
  finally
    lUnidad.Free;
  end;
end;

end.
