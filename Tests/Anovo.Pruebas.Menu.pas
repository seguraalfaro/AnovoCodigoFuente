unit Anovo.Pruebas.Menu;

// Menu del escritorio por permisos (CP-12, RF-010): cada seccion aparece con
// su propio permiso, de modo que una fila corrida en PERMISOS_SECCION falla.

interface

uses
  DUnitX.TestFramework,
  Anovo.Vistas.Intf.Principal;

type
  [TestFixture('Menu del escritorio segun los permisos de la sesion')]
  TPruebasMenu = class
  private
    procedure AbrirSesion(const ARol: string; const APermisos: array of string);
    function Secciones: TSecciones;
  public
    [TearDown]
    procedure Cerrar;

    [Test]
    procedure SinPermisosSoloConfiguracion;
    [Test]
    [TestCase('DashboardSupervisor', 'secDashboardSupervisor,cotizaciones.aprobar,supervisor')]
    [TestCase('DashboardCuentas', 'secDashboardCuentas,usuarios.administrar,admin')]
    [TestCase('DashboardAsesor', 'secDashboardAsesor,cotizaciones.ver_aprobadas_propias,asesor')]
    [TestCase('DashboardAsistente', 'secDashboardAsistente,cotizaciones.elaborar,asistente')]
    [TestCase('Solicitudes', 'secSolicitudes,solicitudes.ver_propias,asesor')]
    [TestCase('Bandeja', 'secBandeja,cotizaciones.aprobar,supervisor')]
    [TestCase('Cotizaciones', 'secCotizaciones,cotizaciones.ver_todas,asistente')]
    [TestCase('Generacion', 'secGeneracion,cotizaciones.elaborar,asistente')]
    [TestCase('Detalle', 'secDetalle,cotizaciones.ver_todas,asistente')]
    [TestCase('Clientes', 'secClientes,clientes.ver,asesor')]
    [TestCase('Materiales', 'secMateriales,catalogos.editar,supervisor')]
    [TestCase('Reportes', 'secReportes,reportes.ver,supervisor')]
    [TestCase('Gerencia', 'secGerencia,reportes.ver,gerencia')]
    [TestCase('Usuarios', 'secUsuarios,usuarios.administrar,admin')]
    [TestCase('Roles', 'secRoles,permisos.ver,admin')]
    [TestCase('Auditoria', 'secAuditoria,auditoria.ver_cuentas,admin')]
    procedure CadaSeccionAparecePorSuPermiso(const ASeccion, APermiso,
      ARol: string);
    [Test]
    procedure UnPermisoNoAbreSeccionesAjenas;
    [Test]
    procedure LaVistaDeGerenciaExigeElRolGerencia;
    [Test]
    procedure GerenciaVeUnSoloDashboard;
    [Test]
    procedure SupervisorVeSuDashboardYNoElDelAsistente;
    [Test]
    procedure AsesorNoVeCotizacionesNiMateriales;
  end;

implementation

uses
  System.SysUtils,
  System.TypInfo,
  MVCFramework.Commons,
  Anovo.Permisos,
  Anovo.Sesion,
  Anovo.Presentadores.Principal;

const
  ENCABEZADO_TOKEN = '{"alg":"none","typ":"JWT"}';
  CUERPO_TOKEN = '{"roles":"%s","USUARIO_ID":"1","exp":4102444800}';
  FIRMA_TOKEN = 'prueba';

procedure TPruebasMenu.AbrirSesion(const ARol: string;
  const APermisos: array of string);
var
  lPermisos: TArray<string>;
  I: Integer;
begin
  TSesion.Abrir(URLSafeB64encode(ENCABEZADO_TOKEN, False) + '.' +
    URLSafeB64encode(Format(CUERPO_TOKEN, [ARol]), False) + '.' + FIRMA_TOKEN);
  SetLength(lPermisos, Length(APermisos));
  for I := 0 to High(APermisos) do
    lPermisos[I] := APermisos[I];
  TSesion.AsignarPermisos(lPermisos);
end;

function TPruebasMenu.Secciones: TSecciones;
begin
  Result := TPresentadorPrincipal.SeccionesPermitidas;
end;

procedure TPruebasMenu.Cerrar;
begin
  TSesion.Cerrar;
end;

procedure TPruebasMenu.SinPermisosSoloConfiguracion;
begin
  AbrirSesion('asistente', []);
  Assert.IsTrue(Secciones = [secConfiguracion]);
end;

procedure TPruebasMenu.CadaSeccionAparecePorSuPermiso(const ASeccion, APermiso,
  ARol: string);
var
  lSeccion: TSeccion;
begin
  lSeccion := TSeccion(GetEnumValue(TypeInfo(TSeccion), ASeccion));
  AbrirSesion(ARol, [APermiso]);
  Assert.IsTrue(lSeccion in Secciones,
    Format('%s no aparece con %s', [ASeccion, APermiso]));
end;

procedure TPruebasMenu.UnPermisoNoAbreSeccionesAjenas;
begin
  AbrirSesion('asesor', [PERMISO_CLIENTES_VER]);
  Assert.IsTrue(Secciones = [secClientes, secConfiguracion]);
end;

procedure TPruebasMenu.LaVistaDeGerenciaExigeElRolGerencia;
begin
  AbrirSesion('supervisor', [PERMISO_REPORTES_VER]);
  Assert.IsFalse(secGerencia in Secciones);
end;

procedure TPruebasMenu.GerenciaVeUnSoloDashboard;
var
  lSecciones: TSecciones;
begin
  AbrirSesion('gerencia', [PERMISO_REPORTES_VER, PERMISO_COTIZACIONES_APROBAR,
    PERMISO_COTIZACIONES_ELABORAR]);
  lSecciones := Secciones;
  Assert.IsTrue(secGerencia in lSecciones);
  Assert.IsFalse(secDashboardSupervisor in lSecciones);
  Assert.IsFalse(secDashboardAsistente in lSecciones);
  Assert.IsTrue(secBandeja in lSecciones);
end;

procedure TPruebasMenu.SupervisorVeSuDashboardYNoElDelAsistente;
var
  lSecciones: TSecciones;
begin
  AbrirSesion('supervisor', [PERMISO_COTIZACIONES_APROBAR,
    PERMISO_COTIZACIONES_ELABORAR]);
  lSecciones := Secciones;
  Assert.IsTrue(secDashboardSupervisor in lSecciones);
  Assert.IsFalse(secDashboardAsistente in lSecciones);
end;

procedure TPruebasMenu.AsesorNoVeCotizacionesNiMateriales;
var
  lSecciones: TSecciones;
begin
  AbrirSesion('asesor', [PERMISO_COTIZACIONES_VER_APROBADAS_PROPIAS,
    PERMISO_SOLICITUDES_VER_PROPIAS, PERMISO_CLIENTES_VER,
    PERMISO_CATALOGOS_VER]);
  lSecciones := Secciones;
  Assert.IsTrue(secSolicitudes in lSecciones);
  Assert.IsFalse(secCotizaciones in lSecciones);
  Assert.IsFalse(secMateriales in lSecciones);
  Assert.IsFalse(secBandeja in lSecciones);
  Assert.IsFalse(secGeneracion in lSecciones);
end;

initialization
  TDUnitX.RegisterTestFixture(TPruebasMenu);

end.
