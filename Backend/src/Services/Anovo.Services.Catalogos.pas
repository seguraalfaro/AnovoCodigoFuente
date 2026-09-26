unit Anovo.Services.Catalogos;

// Servicio de catalogos: donde vive el negocio de los cuatro.
//
// Dos reglas se repiten en los tres catalogos con precio y son la razon de que
// esto no sea un CRUD generico:
//
// La primera, el duplicado por nombre que pide la HU-05. La base solo tiene
// UNIQUE en CODIGO, asi que el nombre se comprueba aqui.
//
// La segunda, el cambio de precio: se desactiva la fila vigente y se inserta
// otra, las dos en la misma transaccion. Nunca se modifica la anterior, porque
// el historial es lo que sostiene el precio de las cotizaciones ya aprobadas.
//
// Nada se borra: se inactiva. Una cotizacion de hace seis meses sigue
// nombrando ese material.

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
    fTiposTrabajo: ITipoTrabajoRepository;

    function TraerMaterial(const AId: Integer): TMateriales;
    function TraerManoObra(const AId: Integer): TManoObra;
    function TraerMaquina(const AId: Integer): TMaquinas;
    function TraerTipoTrabajo(const AId: Integer): TTiposTrabajo;
  public
    // Un repositorio por tabla. El servicio los junta: las reglas que cruzan
    // tablas -el item y su precio- y la transaccion viven aqui.
    [MVCInject]
    constructor Create(AMateriales: IMaterialRepository;
      AMaterialesPrecios: IMaterialPrecioRepository;
      AManoObra: IManoObraRepository;
      AManoObraPrecios: IManoObraPrecioRepository;
      ACategorias: IManoObraCategoriaRepository;
      AMaquinas: IMaquinaRepository;
      AMaquinasPrecios: IMaquinaPrecioRepository;
      ATiposTrabajo: ITipoTrabajoRepository); reintroduce;

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

    function TiposTrabajo(const AIncluirInactivos: Boolean)
      : TObjectList<TTipoTrabajoDTO>;
    function CrearTipoTrabajo(const ADto: TTipoTrabajoNuevoDTO): Integer;
    procedure ActualizarTipoTrabajo(const AId: Integer;
      const ADto: TTipoTrabajoNuevoDTO);
    procedure InactivarTipoTrabajo(const AId: Integer);
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.Repository,
  Anovo.Auditoria.Contexto,
  Anovo.Entities.Vistas.Catalogos,
  Anovo.Errors,
  Anovo.Mapeo;

constructor TCatalogoService.Create(AMateriales: IMaterialRepository;
  AMaterialesPrecios: IMaterialPrecioRepository;
  AManoObra: IManoObraRepository;
  AManoObraPrecios: IManoObraPrecioRepository;
  ACategorias: IManoObraCategoriaRepository; AMaquinas: IMaquinaRepository;
  AMaquinasPrecios: IMaquinaPrecioRepository;
  ATiposTrabajo: ITipoTrabajoRepository);
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
end;

// Apoyo

function TCatalogoService.TraerMaterial(const AId: Integer): TMateriales;
begin
  // El False es RaiseExceptionIfNotFound: se prefiere la excepcion propia, que
  // sale con el codigo y el mensaje del contrato.
  Result := fMateriales.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create('el material', AId);
end;

function TCatalogoService.TraerManoObra(const AId: Integer): TManoObra;
begin
  Result := fManoObra.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create('la mano de obra', AId);
end;

function TCatalogoService.TraerMaquina(const AId: Integer): TMaquinas;
begin
  Result := fMaquinas.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create('la maquina', AId);
end;

function TCatalogoService.TraerTipoTrabajo(const AId: Integer): TTiposTrabajo;
begin
  Result := fTiposTrabajo.GetByPK(AId, False);
  if Result = nil then
    raise ERecursoNoEncontrado.Create('el tipo de trabajo', AId);
end;

// Materiales

function TCatalogoService.BuscarMateriales(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  out ATotal: Int64): TObjectList<TMaterialDTO>;
var
  lFilas: TObjectList<TMaterialConPrecio>;
begin
  ATotal := fMateriales.ContarBusqueda(ATexto, AIncluirInactivos);
  lFilas := fMateriales.BuscarConPrecio(ATexto, APagina, APorPagina,
    AIncluirInactivos);
  try
    Result := TMapeo.AListaDto<TMaterialConPrecio, TMaterialDTO>(lFilas);
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
  finally
    lMaterial.Free;
  end;

  // El precio viene de otra tabla: la ficha lo pide aparte, a diferencia del
  // listado, que lo trae en la misma consulta.
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

  if fMateriales.ExisteNombre(ADto.Nombre) then
    raise EDatoInvalido.Create
      ('Ya existe un material con ese nombre en el catalogo.');

  lMaterial := TMateriales.Create;
  try
    TMapeo.Copiar(ADto, lMaterial);
    lMaterial.Activo := True;
    FijarDetalle('Registro del material ' + ADto.Nombre);
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
    // Excluyendo el propio, o editar sin cambiar el nombre chocaria consigo
    // mismo.
    if fMateriales.ExisteNombre(ADto.Nombre, AId) then
      raise EDatoInvalido.Create
        ('Ya existe otro material con ese nombre en el catalogo.');

    TMapeo.Copiar(ADto, lMaterial);
    FijarDetalle('Cambio en el material ' + ADto.Nombre);
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
    FijarDetalle('Inactivacion del material ' + lMaterial.Nombre);
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
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lMaterial := TraerMaterial(AId);
  try
    // El precio de venta es el que va a la cotizacion: sin el, la linea
    // quedaria en cero y nadie lo notaria hasta ver el total.
    if not ADto.PrecioUnitario.HasValue then
      raise EDatoInvalido.Create('Falta el precio unitario.');

    // Antes de la primera escritura, no antes del Insert: la desactivacion
    // tambien pasa por el disparador y sin esto queda con el texto fijo.
    FijarDetalle('Cambio de precio del material ' + lMaterial.Nombre);

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
      // MODIFICADO_POR no lo pone ningun disparador: es columna de negocio.
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

// Mano de obra

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

  if fManoObra.ExisteNombre(ADto.Nombre) then
    raise EDatoInvalido.Create('Ya existe una mano de obra con ese nombre.');

  lItem := TManoObra.Create;
  try
    TMapeo.Copiar(ADto, lItem);
    lItem.Activo := True;
    FijarDetalle('Registro de mano de obra ' + ADto.Nombre);
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
        ('Ya existe otra mano de obra con ese nombre.');

    TMapeo.Copiar(ADto, lItem);
    FijarDetalle('Cambio en la mano de obra ' + ADto.Nombre);
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
    FijarDetalle('Inactivacion de la mano de obra ' + lItem.Nombre);
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
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lItem := TraerManoObra(AId);
  try
    if not ADto.CostoUnitario.HasValue then
      raise EDatoInvalido.Create('Falta el costo unitario.');

    FijarDetalle('Cambio de costo de la mano de obra ' + lItem.Nombre);

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

// Maquinas

function TCatalogoService.BuscarMaquinas(const ATexto: string;
  const APagina, APorPagina: Integer; const AIncluirInactivos: Boolean;
  out ATotal: Int64): TObjectList<TMaquinaDTO>;
var
  lFilas: TObjectList<TMaquinaConPrecio>;
begin
  ATotal := fMaquinas.ContarBusqueda(ATexto, AIncluirInactivos);
  lFilas := fMaquinas.BuscarConPrecio(ATexto, APagina, APorPagina,
    AIncluirInactivos);
  try
    Result := TMapeo.AListaDto<TMaquinaConPrecio, TMaquinaDTO>(lFilas);
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
    raise EDatoInvalido.Create('Ya existe una maquina con ese nombre.');

  lMaquina := TMaquinas.Create;
  try
    TMapeo.Copiar(ADto, lMaquina);
    lMaquina.Activo := True;
    FijarDetalle('Registro de la maquina ' + ADto.Nombre);
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
      raise EDatoInvalido.Create('Ya existe otra maquina con ese nombre.');

    TMapeo.Copiar(ADto, lMaquina);
    FijarDetalle('Cambio en la maquina ' + ADto.Nombre);
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
    FijarDetalle('Inactivacion de la maquina ' + lMaquina.Nombre);
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
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  lMaquina := TraerMaquina(AId);
  try
    if not ADto.CostoHora.HasValue then
      raise EDatoInvalido.Create('Falta el costo por hora.');

    FijarDetalle('Cambio de costo por hora de la maquina ' +
      lMaquina.Nombre);

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

// Tipos de trabajo

function TCatalogoService.TiposTrabajo(const AIncluirInactivos: Boolean)
  : TObjectList<TTipoTrabajoDTO>;
var
  lFilas: TObjectList<TTiposTrabajo>;
begin
  lFilas := fTiposTrabajo.Todos(AIncluirInactivos);
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

  // NOMBRE si es UNIQUE en esta tabla; se comprueba igual para que salga el
  // error del contrato y no el del motor.
  if fTiposTrabajo.ExisteNombre(ADto.Nombre) then
    raise EDatoInvalido.Create('Ya existe un tipo de trabajo con ese nombre.');

  lTipo := TTiposTrabajo.Create;
  try
    TMapeo.Copiar(ADto, lTipo);
    lTipo.Activo := True;
    FijarDetalle('Registro del tipo de trabajo ' + ADto.Nombre);
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
        ('Ya existe otro tipo de trabajo con ese nombre.');

    TMapeo.Copiar(ADto, lTipo);
    FijarDetalle('Cambio en el tipo de trabajo ' + ADto.Nombre);
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
    FijarDetalle('Inactivacion del tipo de trabajo ' + lTipo.Nombre);
    fTiposTrabajo.Update(lTipo);
  finally
    lTipo.Free;
  end;
end;

end.
