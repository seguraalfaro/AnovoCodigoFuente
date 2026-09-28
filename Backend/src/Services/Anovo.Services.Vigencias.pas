unit Anovo.Services.Vigencias;

// Aplica los precios programados cuando llega su fecha, con el
// usuario del sistema para la auditoria.

interface

type
  TResumenVigencias = record
    Aplicados: Integer;
    Fallidos: Integer;
  end;

function AplicarVigencias: TResumenVigencias;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  MVCFramework.ActiveRecord,
  MVCFramework.Repository,
  MVCFramework.Commons,
  MVCFramework.Logger,
  Anovo.Auditoria.Contexto,
  Anovo.Textos,
  Anovo.Entities.Catalogos,
  Anovo.Repositories.Intf.Catalogos,
  Anovo.Repositories.Catalogos,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Repositories.Usuarios;

type
  TAplicadorVigencias = class
  private
    fProgramados: IPrecioProgramadoRepository;
    fMateriales: IMaterialPrecioRepository;
    fManoObra: IManoObraPrecioRepository;
    fMaquinas: IMaquinaPrecioRepository;
    fUsuario: Integer;
    function AplicarAMaterial(const AProg: TPreciosProgramados): Integer;
    function AplicarAManoObra(const AProg: TPreciosProgramados): Integer;
    function AplicarAMaquina(const AProg: TPreciosProgramados): Integer;
    function Aplicar(const AProg: TPreciosProgramados): Integer;
    procedure AplicarUno(const AProg: TPreciosProgramados);
  public
    constructor Create(const AUsuario: Integer);
    function AplicarPendientes: TResumenVigencias;
  end;

constructor TAplicadorVigencias.Create(const AUsuario: Integer);
begin
  inherited Create;
  fUsuario := AUsuario;
  fProgramados := TPrecioProgramadoRepository.Create;
  fMateriales := TMaterialPrecioRepository.Create;
  fManoObra := TManoObraPrecioRepository.Create;
  fMaquinas := TMaquinaPrecioRepository.Create;
end;

function TAplicadorVigencias.AplicarAMaterial(const AProg
  : TPreciosProgramados): Integer;
var
  lVigente: TMaterialesPrecios;
  lNuevo: TMaterialesPrecios;
begin
  lVigente := fMateriales.PrecioVigenteDe(AProg.MaterialId.Value);
  if lVigente <> nil then
    try
      lVigente.Activo := False;
      lVigente.ModificadoPor := fUsuario;
      fMateriales.Update(lVigente);
    finally
      lVigente.Free;
    end;

  lNuevo := TMaterialesPrecios.Create;
  try
    lNuevo.MaterialId := AProg.MaterialId.Value;
    lNuevo.CostoUnitario := AProg.CostoUnitario;
    lNuevo.PrecioUnitario := AProg.PrecioUnitario;
    lNuevo.Activo := True;
    lNuevo.FechaVigencia := AProg.FechaVigencia;
    lNuevo.ModificadoPor := fUsuario;
    fMateriales.Insert(lNuevo);
    Result := lNuevo.ID.ValueOrDefault;
  finally
    lNuevo.Free;
  end;
end;

function TAplicadorVigencias.AplicarAManoObra(const AProg
  : TPreciosProgramados): Integer;
var
  lVigente: TManoObraPrecios;
  lNuevo: TManoObraPrecios;
begin
  lVigente := fManoObra.PrecioVigenteDe(AProg.ManoObraId.Value);
  if lVigente <> nil then
    try
      lVigente.Activo := False;
      lVigente.ModificadoPor := fUsuario;
      fManoObra.Update(lVigente);
    finally
      lVigente.Free;
    end;

  lNuevo := TManoObraPrecios.Create;
  try
    lNuevo.ManoObraId := AProg.ManoObraId.Value;
    lNuevo.CostoUnitario := AProg.CostoUnitario;
    lNuevo.Activo := True;
    lNuevo.FechaVigencia := AProg.FechaVigencia;
    lNuevo.ModificadoPor := fUsuario;
    fManoObra.Insert(lNuevo);
    Result := lNuevo.ID.ValueOrDefault;
  finally
    lNuevo.Free;
  end;
end;

function TAplicadorVigencias.AplicarAMaquina(const AProg
  : TPreciosProgramados): Integer;
var
  lVigente: TMaquinasPrecios;
  lNuevo: TMaquinasPrecios;
begin
  lVigente := fMaquinas.PrecioVigenteDe(AProg.MaquinaId.Value);
  if lVigente <> nil then
    try
      lVigente.Activo := False;
      lVigente.ModificadoPor := fUsuario;
      fMaquinas.Update(lVigente);
    finally
      lVigente.Free;
    end;

  lNuevo := TMaquinasPrecios.Create;
  try
    lNuevo.MaquinaId := AProg.MaquinaId.Value;
    lNuevo.CostoHora := AProg.CostoHora;
    lNuevo.Activo := True;
    lNuevo.FechaVigencia := AProg.FechaVigencia;
    lNuevo.ModificadoPor := fUsuario;
    fMaquinas.Insert(lNuevo);
    Result := lNuevo.ID.ValueOrDefault;
  finally
    lNuevo.Free;
  end;
end;

function TAplicadorVigencias.Aplicar(const AProg: TPreciosProgramados)
  : Integer;
begin
  if AProg.MaterialId.HasValue then
    Result := AplicarAMaterial(AProg)
  else if AProg.ManoObraId.HasValue then
    Result := AplicarAManoObra(AProg)
  else if AProg.MaquinaId.HasValue then
    Result := AplicarAMaquina(AProg)
  else
    Result := 0;
end;

procedure TAplicadorVigencias.AplicarUno(const AProg: TPreciosProgramados);
var
  lPrecioId: Integer;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  FijarDetalle(SDetalleRelevoAplicado);

  lPrecioId := Aplicar(AProg);
  if lPrecioId = 0 then
    raise Exception.Create
      ('El pendiente no apunta a ningun item del catalogo.');

  AProg.Estado := 'aplicado';
  AProg.PrecioId := lPrecioId;
  AProg.FechaAplicacion := Now;
  fProgramados.Update(AProg);
end;

function TAplicadorVigencias.AplicarPendientes: TResumenVigencias;
var
  lPendientes: TObjectList<TPreciosProgramados>;
  lProg: TPreciosProgramados;
begin
  Result := Default (TResumenVigencias);
  lPendientes := fProgramados.PorAplicar;
  try
    for lProg in lPendientes do
      try
        AplicarUno(lProg);
        Inc(Result.Aplicados);
      except
        on E: Exception do
        begin
          Inc(Result.Fallidos);
          LogE(Format('No se pudo aplicar el precio programado %d: %s: %s',
            [lProg.ID.ValueOrDefault, E.ClassName, E.Message]));
        end;
      end;
  finally
    lPendientes.Free;
  end;
end;

function UsuarioSistema: Integer;
var
  lUsuarios: IUsuarioRepository;
begin
  lUsuarios := TUsuarioRepository.Create;
  Result := lUsuarios.IdSistema;
end;

function AplicarVigencias: TResumenVigencias;
var
  lUsuario: Integer;
  lAplicador: TAplicadorVigencias;
begin
  Result := Default (TResumenVigencias);

  ActiveRecordConnectionsRegistry.AddDefaultConnection
    (dotEnv.Env('firedac.connection_definition_name', 'AnovoDef'));
  try
    lUsuario := UsuarioSistema;
    if lUsuario = 0 then
    begin
      LogE('Falta el usuario sistema@anovo.local: no se aplica ningun cambio '
        + 'de precio programado. Correr la migracion 13.');
      Exit;
    end;

    FijarUsuario(lUsuario);
    try
      lAplicador := TAplicadorVigencias.Create(lUsuario);
      try
        Result := lAplicador.AplicarPendientes;
      finally
        lAplicador.Free;
      end;
    finally
      LimpiarDetalle;
      LimpiarUsuario;
    end;

    if (Result.Aplicados > 0) or (Result.Fallidos > 0) then
      LogI(Format('Precios programados: %d aplicados, %d con error',
        [Result.Aplicados, Result.Fallidos]));
  finally
    ActiveRecordConnectionsRegistry.RemoveDefaultConnection;
  end;
end;

end.
