unit Anovo.Pruebas.Permisos.Cache;

// Autorizacion del backend (RF-010, RNF-004): permisos efectivos segun el
// rol base y las excepciones por usuario de la minuta 09.

interface

uses
  DUnitX.TestFramework,
  Anovo.Repositories.Intf.Permisos,
  Anovo.Services.Intf.Permisos;

type
  [TestFixture('Permisos efectivos: rol base y excepciones por usuario')]
  TPruebasPermisosCache = class
  private
    FCache: IPermisoCache;
    function Par(const ARol, APermiso: string): TRolPermiso;
    function Excepcion(const AUsuarioId: Integer; const APermiso: string;
      const AOtorgado: Boolean): TExcepcionPermiso;
  public
    [Setup]
    procedure Preparar;

    [Test]
    procedure ElRolConElPermisoLoTiene;
    [Test]
    procedure ElRolSinElPermisoNoLoTiene;
    [Test]
    procedure UnPermisoQuitadoGanaAlRol;
    [Test]
    procedure UnPermisoOtorgadoNoNecesitaElRol;
    [Test]
    procedure LaExcepcionSoloAfectaASuUsuario;
    [Test]
    procedure NoDistingueMayusculas;
    [Test]
    procedure LaListaDePermisosAplicaLasExcepciones;
    [Test]
    procedure InvalidarObligaARecargar;
  end;

implementation

uses
  System.SysUtils,
  Anovo.Permisos,
  Anovo.Services.Permisos;

const
  ROL_ASESOR = 'asesor';
  ROL_ASISTENTE = 'asistente';
  ROL_SUPERVISOR = 'supervisor';
  USUARIO_SIN_EXCEPCIONES = 1;
  USUARIO_CON_QUITADO = 20;
  USUARIO_CON_OTORGADO = 30;
  OTRO_ASESOR = 31;

function TPruebasPermisosCache.Par(const ARol, APermiso: string): TRolPermiso;
begin
  Result.Rol := ARol;
  Result.Permiso := APermiso;
end;

function TPruebasPermisosCache.Excepcion(const AUsuarioId: Integer;
  const APermiso: string; const AOtorgado: Boolean): TExcepcionPermiso;
begin
  Result.UsuarioId := AUsuarioId;
  Result.Permiso := APermiso;
  Result.Otorgado := AOtorgado;
end;

procedure TPruebasPermisosCache.Preparar;
begin
  FCache := TPermisoCache.Create;
  FCache.Cargar([Par(ROL_SUPERVISOR, PERMISO_COTIZACIONES_APROBAR),
    Par(ROL_SUPERVISOR, PERMISO_REPORTES_VER),
    Par(ROL_ASISTENTE, PERMISO_COTIZACIONES_ELABORAR),
    Par(ROL_ASESOR, PERMISO_CLIENTES_VER)],
    [Excepcion(USUARIO_CON_QUITADO, PERMISO_COTIZACIONES_APROBAR, False),
    Excepcion(USUARIO_CON_OTORGADO, PERMISO_REPORTES_VER, True)]);
end;

procedure TPruebasPermisosCache.ElRolConElPermisoLoTiene;
begin
  Assert.IsTrue(FCache.Tiene(USUARIO_SIN_EXCEPCIONES, ROL_SUPERVISOR,
    PERMISO_COTIZACIONES_APROBAR));
end;

procedure TPruebasPermisosCache.ElRolSinElPermisoNoLoTiene;
begin
  Assert.IsFalse(FCache.Tiene(USUARIO_SIN_EXCEPCIONES, ROL_ASESOR,
    PERMISO_COTIZACIONES_APROBAR));
end;

procedure TPruebasPermisosCache.UnPermisoQuitadoGanaAlRol;
begin
  Assert.IsFalse(FCache.Tiene(USUARIO_CON_QUITADO, ROL_SUPERVISOR,
    PERMISO_COTIZACIONES_APROBAR));
  Assert.IsTrue(FCache.Tiene(USUARIO_CON_QUITADO, ROL_SUPERVISOR,
    PERMISO_REPORTES_VER));
end;

procedure TPruebasPermisosCache.UnPermisoOtorgadoNoNecesitaElRol;
begin
  Assert.IsTrue(FCache.Tiene(USUARIO_CON_OTORGADO, ROL_ASESOR,
    PERMISO_REPORTES_VER));
end;

procedure TPruebasPermisosCache.LaExcepcionSoloAfectaASuUsuario;
begin
  Assert.IsFalse(FCache.Tiene(OTRO_ASESOR, ROL_ASESOR, PERMISO_REPORTES_VER));
end;

procedure TPruebasPermisosCache.NoDistingueMayusculas;
begin
  Assert.IsTrue(FCache.Tiene(USUARIO_SIN_EXCEPCIONES,
    UpperCase(ROL_SUPERVISOR), UpperCase(PERMISO_COTIZACIONES_APROBAR)));
end;

procedure TPruebasPermisosCache.LaListaDePermisosAplicaLasExcepciones;
var
  lPermisos: TArray<string>;
begin
  lPermisos := FCache.PermisosDe(USUARIO_CON_QUITADO, ROL_SUPERVISOR);
  Assert.IsFalse(string.Join(';', lPermisos).Contains
    (PERMISO_COTIZACIONES_APROBAR));
  Assert.IsTrue(string.Join(';', lPermisos).Contains(PERMISO_REPORTES_VER));

  lPermisos := FCache.PermisosDe(USUARIO_CON_OTORGADO, ROL_ASESOR);
  Assert.IsTrue(string.Join(';', lPermisos).Contains(PERMISO_CLIENTES_VER));
  Assert.IsTrue(string.Join(';', lPermisos).Contains(PERMISO_REPORTES_VER));
end;

procedure TPruebasPermisosCache.InvalidarObligaARecargar;
begin
  Assert.IsTrue(FCache.Cargada);
  FCache.Invalidar;
  Assert.IsFalse(FCache.Cargada);
end;

initialization
  TDUnitX.RegisterTestFixture(TPruebasPermisosCache);

end.
