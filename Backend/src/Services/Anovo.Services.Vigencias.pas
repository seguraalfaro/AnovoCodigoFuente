unit Anovo.Services.Vigencias;

// Aplica los cambios de precio programados cuando les llega la fecha.
//
// Un cambio con fecha futura no se guarda como precio: espera en
// PRECIOS_PROGRAMADOS, que es una cola de intenciones, no de precios. Cuando
// vence, esta rutina hace lo que haria una persona -jubilar el vigente e
// insertar el nuevo- y marca el pendiente como aplicado.
//
// Quien lo hace es el servidor: al arrancar y cada hora, en el hilo de la
// ventana. Por eso no hay nada que bloquear. La alternativa -que el primero
// que consulte aplique el cambio- obligaba a serializar lectores contra la
// tabla de precios y dejaba en AUDITORIA que ese usuario cambio el precio
// cuando lo unico que hizo fue abrir el listado.
//
// Como nadie mas releva, ACTIVO sigue significando "es el que rige" y ninguna
// consulta de precios cambia.
//
// Que corra tambien al arrancar es lo que cubre el equipo apagado: si paso una
// noche o una semana sin servidor, al levantarse vacia la cola atrasada antes
// de atender a nadie.

interface

type
  TResumenVigencias = record
    Aplicados: Integer;
    Fallidos: Integer;
  end;

// Abre y cierra su propia conexion, porque no corre dentro de una peticion.
// Requiere que las definiciones de FireDAC ya esten cargadas, cosa que hace el
// middleware de ActiveRecord al construirse: de ahi que esto vaya despues de
// armar el servidor y antes de ponerlo a escuchar.
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

{ --- privado -------------------------------------------------------------- }

function UsuarioSistema: Integer;
var
  lValor: Variant;
begin
  lValor := TMVCActiveRecord.CurrentConnection.ExecSQLScalar(USUARIO_SISTEMA);
  if VarIsNull(lValor) or not TryStrToInt(VarToStr(lValor), Result) then
    Result := 0;
end;

// Las tres tablas de precios tienen la misma forma pero distinta columna de
// item y distintos montos, y las entidades salen de MVCEntGen sin antepasado
// comun: no hay donde colgar un generico sin tocar lo generado. Salen tres
// funciones iguales, que es mas barato de leer que resolverlo por RTTI.
//
// Todas devuelven el ID de la fila que crearon, que es lo que une el pendiente
// con el precio que salio de el.

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
    // La fecha del pendiente y no Now: es desde cuando rige, y puede ser
    // anterior a este momento si el servidor estuvo apagado.
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

// El CHECK de la base garantiza que viene exactamente una llave, asi que el
// else no deberia darse nunca. Se contempla igual: si algun dia alguien escribe
// en la tabla por fuera, mejor una fila fallida en el log que una excepcion que
// tumbe la vuelta entera.
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

{ --- publico -------------------------------------------------------------- }

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
      // Sin el, los disparadores tumban cada escritura con
      // E_AUDITORIA_SIN_USUARIO. Mejor no intentarlo y decir por que.
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
          // Una transaccion por pendiente y no una para todos: jubilar el
          // vigente, insertar el nuevo y marcar el pendiente son un solo
          // cambio, pero dos items distintos no tienen por que caerse juntos.
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
              // Se queda pendiente y se reintenta en la vuelta siguiente. No
              // se marca de ninguna forma: la fila sigue como estaba.
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
