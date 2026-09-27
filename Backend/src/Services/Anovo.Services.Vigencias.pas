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
  System.Variants,
  System.Generics.Collections,
  MVCFramework.ActiveRecord,
  MVCFramework.Commons,
  MVCFramework.Logger,
  Anovo.Auditoria.Contexto,
  Anovo.Textos,
  Anovo.Entities.Catalogos,
  Anovo.SQL.Catalogos,
  Anovo.SQL.Usuarios;

function UsuarioSistema: Integer;
var
  lValor: Variant;
begin
  lValor := TMVCActiveRecord.CurrentConnection.ExecSQLScalar(USUARIO_SISTEMA);
  if VarIsNull(lValor) or not TryStrToInt(VarToStr(lValor), Result) then
    Result := 0;
end;

function AplicarAMaterial(const AProg: TPreciosProgramados;
  const AUsuario: Integer): Integer;
var
  lVigente: TMaterialesPrecios;
  lNuevo: TMaterialesPrecios;
begin
  lVigente := TMVCActiveRecord.GetOneByWhere<TMaterialesPrecios>
    (MATERIAL_PRECIO_VIGENTE, [AProg.MaterialId.Value], False);
  if lVigente <> nil then
    try
      lVigente.Activo := False;
      lVigente.ModificadoPor := AUsuario;
      lVigente.Update;
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
    lNuevo.ModificadoPor := AUsuario;
    lNuevo.Insert;
    Result := lNuevo.ID.ValueOrDefault;
  finally
    lNuevo.Free;
  end;
end;

function AplicarAManoObra(const AProg: TPreciosProgramados;
  const AUsuario: Integer): Integer;
var
  lVigente: TManoObraPrecios;
  lNuevo: TManoObraPrecios;
begin
  lVigente := TMVCActiveRecord.GetOneByWhere<TManoObraPrecios>
    (MANO_OBRA_PRECIO_VIGENTE, [AProg.ManoObraId.Value], False);
  if lVigente <> nil then
    try
      lVigente.Activo := False;
      lVigente.ModificadoPor := AUsuario;
      lVigente.Update;
    finally
      lVigente.Free;
    end;

  lNuevo := TManoObraPrecios.Create;
  try
    lNuevo.ManoObraId := AProg.ManoObraId.Value;
    lNuevo.CostoUnitario := AProg.CostoUnitario;
    lNuevo.Activo := True;
    lNuevo.FechaVigencia := AProg.FechaVigencia;
    lNuevo.ModificadoPor := AUsuario;
    lNuevo.Insert;
    Result := lNuevo.ID.ValueOrDefault;
  finally
    lNuevo.Free;
  end;
end;

function AplicarAMaquina(const AProg: TPreciosProgramados;
  const AUsuario: Integer): Integer;
var
  lVigente: TMaquinasPrecios;
  lNuevo: TMaquinasPrecios;
begin
  lVigente := TMVCActiveRecord.GetOneByWhere<TMaquinasPrecios>
    (MAQUINA_PRECIO_VIGENTE, [AProg.MaquinaId.Value], False);
  if lVigente <> nil then
    try
      lVigente.Activo := False;
      lVigente.ModificadoPor := AUsuario;
      lVigente.Update;
    finally
      lVigente.Free;
    end;

  lNuevo := TMaquinasPrecios.Create;
  try
    lNuevo.MaquinaId := AProg.MaquinaId.Value;
    lNuevo.CostoHora := AProg.CostoHora;
    lNuevo.Activo := True;
    lNuevo.FechaVigencia := AProg.FechaVigencia;
    lNuevo.ModificadoPor := AUsuario;
    lNuevo.Insert;
    Result := lNuevo.ID.ValueOrDefault;
  finally
    lNuevo.Free;
  end;
end;

function Aplicar(const AProg: TPreciosProgramados;
  const AUsuario: Integer): Integer;
begin
  if AProg.MaterialId.HasValue then
    Result := AplicarAMaterial(AProg, AUsuario)
  else if AProg.ManoObraId.HasValue then
    Result := AplicarAManoObra(AProg, AUsuario)
  else if AProg.MaquinaId.HasValue then
    Result := AplicarAMaquina(AProg, AUsuario)
  else
    Result := 0;
end;

function AplicarVigencias: TResumenVigencias;
var
  lUsuario: Integer;
  lPendientes: TObjectList<TPreciosProgramados>;
  lProg: TPreciosProgramados;
  lPrecioId: Integer;
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
      lPendientes := TMVCActiveRecord.Where<TPreciosProgramados>
        (PROGRAMADOS_POR_APLICAR, []);
      try
        for lProg in lPendientes do
        begin
          TMVCActiveRecord.CurrentConnection.StartTransaction;
          try
            FijarDetalle(SDetalleRelevoAplicado);

            lPrecioId := Aplicar(lProg, lUsuario);
            if lPrecioId = 0 then
              raise Exception.Create
                ('El pendiente no apunta a ningun item del catalogo.');

            lProg.Estado := 'aplicado';
            lProg.PrecioId := lPrecioId;
            lProg.FechaAplicacion := Now;
            lProg.Update;

            TMVCActiveRecord.CurrentConnection.Commit;
            Inc(Result.Aplicados);
          except
            on E: Exception do
            begin
              TMVCActiveRecord.CurrentConnection.Rollback;
              Inc(Result.Fallidos);
              LogE(Format('No se pudo aplicar el precio programado %d: %s: %s',
                [lProg.ID.ValueOrDefault, E.ClassName, E.Message]));
            end;
          end;
        end;
      finally
        lPendientes.Free;
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
