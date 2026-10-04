unit Anovo.Services.Roles;

// Servicio de roles: la matriz de permisos y sus cambios,
// con motivo y sin tocar el rol de quien cambia.

interface

uses
  MVCFramework,
  Anovo.DTOs.Roles,
  Anovo.Entities.Usuarios,
  Anovo.Entities.Permisos,
  Anovo.Repositories.Intf.Usuarios,
  Anovo.Repositories.Intf.Permisos,
  Anovo.Services.Intf.Permisos,
  Anovo.Services.Intf.Roles;

type
  TRolService = class(TInterfacedObject, IRolService)
  private
    fRoles: IRolRepository;
    fPermisos: IPermisoRepository;
    fCatalogo: IPermisoCatalogoRepository;
    fUsuarios: IUsuarioRepository;
    fExcepciones: IUsuarioPermisoRepository;
    fCache: IPermisoCache;
    function RolDeQuienCambia: Integer;
    procedure BorrarExcepcionesSobrantes(const ARol: TRoles;
      const APermiso: TPermisos; const AAsignado: Boolean);
    procedure AplicarCambios(const ADto: TCambiosMatrizDTO);
    procedure AplicarCambio(const ACambio: TCambioPermisoDTO;
      const ARolPropio: Integer; const AMotivo: string);
  public
    [MVCInject]
    constructor Create(ARoles: IRolRepository; APermisos: IPermisoRepository;
      ACatalogo: IPermisoCatalogoRepository; AUsuarios: IUsuarioRepository;
      AExcepciones: IUsuarioPermisoRepository; ACache: IPermisoCache);
      reintroduce;
    function Matriz: TMatrizPermisosDTO;
    procedure CambiarMatriz(const ADto: TCambiosMatrizDTO);
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Errors,
  Anovo.Mapeo,
  Anovo.Textos,
  Anovo.Auditoria.Contexto,
  Anovo.Entities.Consultas;

constructor TRolService.Create(ARoles: IRolRepository;
  APermisos: IPermisoRepository; ACatalogo: IPermisoCatalogoRepository;
  AUsuarios: IUsuarioRepository; AExcepciones: IUsuarioPermisoRepository;
  ACache: IPermisoCache);
begin
  inherited Create;
  fRoles := ARoles;
  fPermisos := APermisos;
  fCatalogo := ACatalogo;
  fUsuarios := AUsuarios;
  fExcepciones := AExcepciones;
  fCache := ACache;
end;

function TRolService.Matriz: TMatrizPermisosDTO;
var
  lRoles: TObjectList<TRolesOrdenados>;
  lPermisos: TObjectList<TCatalogoPermisos>;
  lAsignaciones: TObjectList<TRolesPermisos>;
begin
  Result := TMatrizPermisosDTO.Create;
  try
    lRoles := fRoles.Resumen;
    try
      Result.Roles.Free;
      Result.Roles := TMapeo.AListaDto<TRolesOrdenados, TRolDTO>(lRoles);
    finally
      lRoles.Free;
    end;

    lPermisos := fCatalogo.Catalogo;
    try
      Result.Permisos.Free;
      Result.Permisos := TMapeo.AListaDto<TCatalogoPermisos, TPermisoDTO>(lPermisos);
    finally
      lPermisos.Free;
    end;

    lAsignaciones := fPermisos.GetAll;
    try
      Result.Asignaciones.Free;
      Result.Asignaciones :=
        TMapeo.AListaDto<TRolesPermisos, TAsignacionDTO>(lAsignaciones);
    finally
      lAsignaciones.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TRolService.RolDeQuienCambia: Integer;
var
  lUsuario: TUsuarios;
begin
  lUsuario := fUsuarios.GetByPK(UsuarioActual, False);
  if lUsuario = nil then
    raise ESinPermiso.Create(SAccionCambiarPermisos);
  try
    Result := lUsuario.RolId;
  finally
    lUsuario.Free;
  end;
end;

procedure TRolService.BorrarExcepcionesSobrantes(const ARol: TRoles;
  const APermiso: TPermisos; const AAsignado: Boolean);
var
  lUsuarios: TObjectList<TUsuarios>;
  lUsuario: TUsuarios;
  lExcepcion: TUsuariosPermisos;
  lSobrante: string;
begin
  if AAsignado then
    lSobrante := TIPO_OTORGADO
  else
    lSobrante := TIPO_QUITADO;

  lUsuarios := fUsuarios.DeRol(ARol.ID);
  try
    for lUsuario in lUsuarios do
    begin
      lExcepcion := fExcepciones.Una(lUsuario.ID.Value, APermiso.ID);
      try
        if (lExcepcion <> nil) and (lExcepcion.Tipo = lSobrante) then
        begin
          FijarDetalle(Format(SDetalleBorraExcepcionPorRol,
            [APermiso.Nombre, ARol.Nombre]));
          fExcepciones.Delete(lExcepcion);
        end;
      finally
        lExcepcion.Free;
      end;
    end;
  finally
    lUsuarios.Free;
  end;
end;

procedure TRolService.CambiarMatriz(const ADto: TCambiosMatrizDTO);
begin
  AplicarCambios(ADto);
  fCache.Invalidar;
end;

procedure TRolService.AplicarCambios(const ADto: TCambiosMatrizDTO);
var
  lCambio: TCambioPermisoDTO;
  lRolPropio: Integer;
begin
  var
  lTx := TMVCRepository.UseTransactionContext;

  if ADto.Motivo.Trim.IsEmpty then
    raise EDatoInvalido.Create(SMotivoFalta);
  if ADto.Cambios.Count = 0 then
    raise EDatoInvalido.Create(SSinCambiosPermisos);

  lRolPropio := RolDeQuienCambia;
  for lCambio in ADto.Cambios do
    AplicarCambio(lCambio, lRolPropio, ADto.Motivo.Trim);
end;

procedure TRolService.AplicarCambio(const ACambio: TCambioPermisoDTO;
  const ARolPropio: Integer; const AMotivo: string);
var
  lRol: TRoles;
  lPermiso: TPermisos;
  lFila: TRolesPermisos;
begin
  if ACambio.RolId = ARolPropio then
    raise ESinPermiso.Create(SAccionPermisosPropioRol);

  lRol := fRoles.GetByPK(ACambio.RolId, False);
  if lRol = nil then
    raise ERecursoNoEncontrado.Create(SRecursoRol, ACambio.RolId);
  try
    lPermiso := fCatalogo.GetByPK(ACambio.PermisoId, False);
    if lPermiso = nil then
      raise ERecursoNoEncontrado.Create(SRecursoPermiso, ACambio.PermisoId);
    try
      if lPermiso.Ambito <> lRol.Ambito then
        raise EDatoInvalido.Create(Format(SPermisoFueraDeAmbito,
          [lPermiso.Nombre, lRol.Nombre]));

      if fPermisos.Exists([ACambio.RolId, ACambio.PermisoId]) = ACambio.Asignado
      then
        Exit;

      lFila := TRolesPermisos.Create;
      try
        lFila.RolId := ACambio.RolId;
        lFila.PermisoId := ACambio.PermisoId;
        lFila.Ambito := lRol.Ambito;
        if ACambio.Asignado then
        begin
          FijarDetalle(Format(SDetalleOtorgaPermisoRol,
            [lPermiso.Nombre, lRol.Nombre, AMotivo]));
          fPermisos.Insert(lFila);
        end
        else
        begin
          FijarDetalle(Format(SDetalleQuitaPermisoRol,
            [lPermiso.Nombre, lRol.Nombre, AMotivo]));
          fPermisos.Delete(lFila);
        end;
      finally
        lFila.Free;
      end;
      BorrarExcepcionesSobrantes(lRol, lPermiso, ACambio.Asignado);
    finally
      lPermiso.Free;
    end;
  finally
    lRol.Free;
  end;
end;

end.
