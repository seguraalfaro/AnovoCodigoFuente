unit Anovo.Entities.Consultas;

// Consultas sobre las vistas: una subclase por uso con sus consultas RQL con
// nombre. Sin filtro fijo en [MVCTable]: ver verificado.md, MergeDefaultRQLFilter.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.ActiveRecord,
  Anovo.Entities.Permisos,
  Anovo.Entities.Vistas.Lectura,
  Anovo.Entities.Vistas.Tablas;

const
  CONSULTA_BUSCAR = 'Buscar';
  CONSULTA_BUSCAR_ACTIVOS = 'BuscarActivos';
  CONSULTA_BUSCAR_DE_CATEGORIA = 'BuscarDeCategoria';
  CONSULTA_BUSCAR_ACTIVOS_DE_CATEGORIA = 'BuscarActivosDeCategoria';
  CONSULTA_DE_OTROS = 'DeOtros';
  CONSULTA_DE_USUARIO = 'DeUsuario';
  CONSULTA_DE_ASESOR = 'DeAsesor';
  CONSULTA_DE_ASESOR_ENTRE = 'DeAsesorEntre';
  CONSULTA_PRODUCTIVIDAD = 'Productividad';
  CONSULTA_ORDENADAS = 'Ordenadas';
  CONSULTA_RECIENTES = 'Recientes';
  CONSULTA_ENTRE = 'Entre';
  CONSULTA_POR_ID = 'PorId';
  CONSULTA_DE_SOLICITUD = 'DeSolicitud';
  CONSULTA_DE_CLIENTE = 'DeCliente';
  CONSULTA_BUSCAR_INACTIVOS = 'BuscarInactivos';
  CONSULTA_BUSCAR_CLAVE_PENDIENTE = 'BuscarClavePendiente';
  CONSULTA_BUSCAR_CON_ADICIONALES = 'BuscarConAdicionales';
  CONSULTA_BAJADA = 'Bajada';
  CONSULTA_BAJADA_DESDE = 'BajadaDesde';
  CONSULTA_HISTORIAL_DE = 'HistorialDe';
  CONSULTA_PARA_HOY = 'ParaHoy';
  CONSULTA_ESTANCADAS = 'Estancadas';

  RQL_PAGINA = ';limit(%d,%d)';
  RQL_TEXTO_USUARIO = 'or(contains(Nombre,"%s"),contains(Correo,"%s"))';
  RQL_SIN_SISTEMA = 'ne(Correo,"sistema@anovo.local")';
  RQL_ORDEN_USUARIOS = ';sort(+Nombre,+ID)';
  RQL_TEXTO_COTIZACION =
    'or(contains(ClienteNombre,"%s"),contains(DescripcionTrabajo,"%s"))';
  RQL_TEXTO_SOLICITUD =
    'or(contains(ClienteNombre,"%s"),contains(Descripcion,"%s"))';
  RQL_TEXTO_CATALOGO =
    'or(contains(Codigo,"%s"),contains(Nombre,"%s"),contains(Descripcion,"%s"))';
  RQL_ORDEN_CATALOGO = ';sort(+Nombre)';
  RQL_EN_CURSO = 'in(Estado,["borrador","en_revision","devuelta","visto_bueno"])';

type

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_SOLICITUDES')]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR,
    'and(eq(Estado,"recibida"),eq(TieneCotizacion,false),' +
    RQL_TEXTO_SOLICITUD + ');sort(+FechaRecepcion,+ID)' + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_ENTRE,
    'and(eq(Estado,"recibida"),eq(TieneCotizacion,false),' +
    'ge(FechaRecepcion,"%s"),lt(FechaRecepcion,"%s"),' +
    RQL_TEXTO_SOLICITUD + ');sort(+FechaRecepcion,+ID)' + RQL_PAGINA)]
  TColaSolicitudes = class(TVSolicitudes)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_COTIZACIONES')]
  [MVCNamedRQLQuery(CONSULTA_DE_OTROS,
    'and(eq(Estado,"en_revision"),ne(ElaboradaPor,%d),' +
    RQL_TEXTO_COTIZACION + ');sort(+FechaModificacion,+ID)' + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_ENTRE,
    'and(eq(Estado,"en_revision"),ne(ElaboradaPor,%d),' +
    'ge(FechaModificacion,"%s"),lt(FechaModificacion,"%s"),' +
    RQL_TEXTO_COTIZACION + ');sort(+FechaModificacion,+ID)' + RQL_PAGINA)]
  TBandejaCotizaciones = class(TVCotizaciones)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_COTIZACIONES')]
  [MVCNamedRQLQuery(CONSULTA_DE_USUARIO,
    'and(eq(ElaboradaPor,%d),' + RQL_EN_CURSO + ',' +
    RQL_TEXTO_COTIZACION + ');sort(-FechaModificacion,-ID)' + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_ENTRE,
    'and(eq(ElaboradaPor,%d),' + RQL_EN_CURSO + ',' +
    'ge(FechaModificacion,"%s"),lt(FechaModificacion,"%s"),' +
    RQL_TEXTO_COTIZACION + ');sort(-FechaModificacion,-ID)' + RQL_PAGINA)]
  TCotizacionesEnTrabajo = class(TVCotizaciones)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_CATALOGO_ITEMS')]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR,
    'and(eq(Tipo,"material"),' + RQL_TEXTO_CATALOGO + ')' +
    RQL_ORDEN_CATALOGO + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR_ACTIVOS,
    'and(eq(Tipo,"material"),eq(Activo,true),' +
    RQL_TEXTO_CATALOGO + ')' + RQL_ORDEN_CATALOGO + RQL_PAGINA)]
  TMaterialesConPrecio = class(TVCatalogoItems)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_CATALOGO_ITEMS')]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR,
    'and(eq(Tipo,"mano_obra"),' + RQL_TEXTO_CATALOGO + ')' +
    RQL_ORDEN_CATALOGO + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR_ACTIVOS,
    'and(eq(Tipo,"mano_obra"),eq(Activo,true),' +
    RQL_TEXTO_CATALOGO + ')' + RQL_ORDEN_CATALOGO + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR_DE_CATEGORIA,
    'and(eq(Tipo,"mano_obra"),eq(CategoriaId,%d),' +
    RQL_TEXTO_CATALOGO + ')' + RQL_ORDEN_CATALOGO + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR_ACTIVOS_DE_CATEGORIA,
    'and(eq(Tipo,"mano_obra"),eq(Activo,true),' +
    'eq(CategoriaId,%d),' + RQL_TEXTO_CATALOGO + ')' + RQL_ORDEN_CATALOGO +
    RQL_PAGINA)]
  TManoObraConPrecio = class(TVCatalogoItems)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_CATALOGO_ITEMS')]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR,
    'and(eq(Tipo,"maquina"),' + RQL_TEXTO_CATALOGO + ')' +
    RQL_ORDEN_CATALOGO + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR_ACTIVOS,
    'and(eq(Tipo,"maquina"),eq(Activo,true),' +
    RQL_TEXTO_CATALOGO + ')' + RQL_ORDEN_CATALOGO + RQL_PAGINA)]
  TMaquinasConPrecio = class(TVCatalogoItems)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_CATALOGO_ITEMS')]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR,
    RQL_TEXTO_CATALOGO + ';sort(+Nombre,+Tipo,+ID)' + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR_ACTIVOS,
    'and(eq(Activo,true),' + RQL_TEXTO_CATALOGO +
    ');sort(+Nombre,+Tipo,+ID)' + RQL_PAGINA)]
  TCatalogoTodos = class(TVCatalogoItems)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_TRABAJO_USUARIO')]
  [MVCNamedRQLQuery(CONSULTA_DE_USUARIO,
    'eq(UsuarioId,%d)')]
  TTrabajoUsuario = class(TVTrabajoUsuario)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_ASESORES_MES')]
  [MVCNamedRQLQuery(CONSULTA_DE_ASESOR,
    'eq(AsesorId,%d)')]
  [MVCNamedRQLQuery(CONSULTA_PRODUCTIVIDAD,
    'eq(Activo,true);sort(-MontoAprobadoMes,+AsesorNombre)')]
  TAsesoresMes = class(TVAsesoresMes)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_COTIZACIONES_POR_ESTADO')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS,
    'sort(+Orden)')]
  TCotizacionesPorEstado = class(TVCotizacionesPorEstado)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_AUDITORIA')]
  [MVCNamedRQLQuery(CONSULTA_RECIENTES,
    'in(Entidad,["USUARIOS","USUARIOS_CLAVES","ROLES_PERMISOS",' +
    '"USUARIOS_PERMISOS"]);sort(-Fecha,-ID);limit(0,20)')]
  TCambiosDeCuentas = class(TVAuditoria)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_SEGUIMIENTO_ASESOR')]
  [MVCNamedRQLQuery(CONSULTA_DE_ASESOR,
    'and(eq(AsesorId,%d),' + RQL_TEXTO_SOLICITUD +
    ');sort(-FechaCaptura,-ID)' + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_DE_ASESOR_ENTRE,
    'and(eq(AsesorId,%d),ge(FechaCaptura,"%s"),' +
    'lt(FechaCaptura,"%s"),' + RQL_TEXTO_SOLICITUD +
    ');sort(-FechaCaptura,-ID)' + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR,
    RQL_TEXTO_SOLICITUD + ';sort(-FechaCaptura,-ID)' + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_ENTRE,
    'and(ge(FechaCaptura,"%s"),lt(FechaCaptura,"%s"),' + RQL_TEXTO_SOLICITUD +
    ');sort(-FechaCaptura,-ID)' + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_BAJADA, 'eq(AsesorId,%d);sort(+ID)')]
  [MVCNamedRQLQuery(CONSULTA_BAJADA_DESDE,
    'and(eq(AsesorId,%d),gt(FechaCambio,"%s"));sort(+ID)')]
  TSeguimientoAsesor = class(TVSeguimientoAsesor)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_COTIZACIONES_LISTADO')]
  [MVCNamedRQLQuery(CONSULTA_POR_ID, 'eq(ID,%d)')]
  TCotizacionListada = class(TVCotizacionesListado)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_COTIZACIONES_SIN_RESPUESTA')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS, 'sort(+FechaEnvio,+ID)')]
  TCotizacionSinRespuesta = class(TVCotizacionesSinRespuesta)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_COTIZACION_TOTALES')]
  [MVCNamedRQLQuery(CONSULTA_POR_ID, 'eq(CotizacionId,%d)')]
  TTotalesDeCotizacion = class(TVCotizacionTotales)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_REPORTE_RESUMEN')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS, 'sort(+Periodo)')]
  TResumenDelReporte = class(TVReporteResumen)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_REPORTE_ESTADO')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS, 'sort(+Orden)')]
  TReportePorEstado = class(TVReporteEstado)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_REPORTE_ASESOR')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS, 'sort(-MontoAprobado,+AsesorNombre)')]
  TReportePorAsesor = class(TVReporteAsesor)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_REPORTE_TIPO')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS, 'sort(-Cantidad,+TipoTrabajoNombre)')]
  TReportePorTipo = class(TVReporteTipo)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_REPORTE_MES')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS, 'sort(+Anio,+Mes)')]
  TReportePorMes = class(TVReporteMes)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_REPORTE_CLIENTE')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS,
    'sort(-SinRespuesta,-PorcentajeSinRespuesta,+ClienteNombre)')]
  TReportePorCliente = class(TVReporteCliente)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_SOLICITUD_ADJUNTOS')]
  [MVCNamedRQLQuery(CONSULTA_DE_SOLICITUD,
    'and(eq(SolicitudId,%d),eq(Activo,true));sort(+Tipo,+FechaCreacion,+ID)')]
  TAdjuntosDeSolicitud = class(TVSolicitudAdjuntos)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_SOLICITUD_MEDIDAS')]
  [MVCNamedRQLQuery(CONSULTA_DE_SOLICITUD,
    'eq(SolicitudId,%d);sort(+PiezaId,+Orden,+ID)')]
  TMedidasDeSolicitud = class(TVSolicitudMedidas)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_SOLICITUD_PIEZAS')]
  [MVCNamedRQLQuery(CONSULTA_DE_SOLICITUD,
    'and(eq(SolicitudId,%d),eq(Activo,true));sort(+Orden,+ID)')]
  TPiezasDeSolicitud = class(TVSolicitudPiezas)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_CONSENTIMIENTOS')]
  [MVCNamedRQLQuery(CONSULTA_DE_CLIENTE,
    'eq(ClienteId,%d);sort(-Fecha,-ID)')]
  TConsentimientosDeCliente = class(TVConsentimientos)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_PERMISOS_ROLES')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS,
    'sort(+Rol,+Permiso)')]
  TPermisosDeRoles = class(TVPermisosRoles)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_ROLES')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS,
    'sort(+ID)')]
  TRolesOrdenados = class(TVRoles)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('VT_PERMISOS')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS,
    'sort(+ID)')]
  TCatalogoPermisos = class(TVtPermisos)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_USUARIOS')]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR,
    'and(' + RQL_SIN_SISTEMA + ',' + RQL_TEXTO_USUARIO + ')' +
    RQL_ORDEN_USUARIOS + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR_ACTIVOS,
    'and(' + RQL_SIN_SISTEMA + ',eq(Activo,true),' + RQL_TEXTO_USUARIO + ')' +
    RQL_ORDEN_USUARIOS + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR_INACTIVOS,
    'and(' + RQL_SIN_SISTEMA + ',eq(Activo,false),' + RQL_TEXTO_USUARIO + ')' +
    RQL_ORDEN_USUARIOS + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR_CLAVE_PENDIENTE,
    'and(' + RQL_SIN_SISTEMA + ',eq(Activo,true),eq(DebeCambiarClave,true),' +
    RQL_TEXTO_USUARIO + ')' + RQL_ORDEN_USUARIOS + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_BUSCAR_CON_ADICIONALES,
    'and(' + RQL_SIN_SISTEMA + ',gt(Excepciones,0),' + RQL_TEXTO_USUARIO + ')' +
    RQL_ORDEN_USUARIOS + RQL_PAGINA)]
  [MVCNamedRQLQuery(CONSULTA_POR_ID,
    'and(' + RQL_SIN_SISTEMA + ',eq(ID,%d))')]
  TUsuariosBuscados = class(TVUsuarios)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_USUARIOS_PERMISOS')]
  [MVCNamedRQLQuery(CONSULTA_DE_USUARIO,
    'eq(UsuarioId,%d);sort(+Modulo,+Nombre)')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS,
    'sort(+UsuarioId,+PermisoId)')]
  TExcepcionesDePermisos = class(TVUsuariosPermisos)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_COTIZACION_HISTORIAL')]
  [MVCNamedRQLQuery(CONSULTA_HISTORIAL_DE,
    'eq(CotizacionId,%d);sort(-Fecha,-ID)')]
  THistorialCotizacion = class(TVCotizacionHistorial)
  end;


  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_DASH_ASESOR_GRUPOS')]
  [MVCNamedRQLQuery(CONSULTA_DE_ASESOR, 'eq(AsesorId,%d);sort(+Orden)')]
  TGruposDelAsesor = class(TVDashAsesorGrupos)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_DASH_ASESOR_RESUMEN')]
  [MVCNamedRQLQuery(CONSULTA_DE_ASESOR, 'eq(AsesorId,%d)')]
  TResumenDelAsesor = class(TVDashAsesorResumen)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_DASH_ASISTENTE_RESUMEN')]
  [MVCNamedRQLQuery(CONSULTA_DE_USUARIO, 'eq(UsuarioId,%d)')]
  TResumenDelAsistente = class(TVDashAsistenteResumen)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_DASH_ENVIADAS')]
  [MVCNamedRQLQuery(CONSULTA_DE_ASESOR,
    'eq(AsesorId,%d);sort(-Dias,+CotizacionId)')]
  TEnviadaSinRespuesta = class(TVDashEnviadas)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_DASH_EN_CURSO')]
  [MVCNamedRQLQuery(CONSULTA_PARA_HOY,
    'and(eq(ElaboradaPor,%d),in(Estado,["devuelta","visto_bueno"]));' +
    'sort(-Dias,+CotizacionId)')]
  [MVCNamedRQLQuery(CONSULTA_ESTANCADAS,
    'eq(Estancada,true);sort(-Dias,+CotizacionId)')]
  TCotizacionEnCurso = class(TVDashEnCurso)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_DASH_ETAPAS_USUARIO')]
  [MVCNamedRQLQuery(CONSULTA_DE_USUARIO, 'eq(UsuarioId,%d);sort(+Orden)')]
  TEtapasDelUsuario = class(TVDashEtapasUsuario)
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCEntityActions([eaRetrieve])]
  [MVCTable('V_DASH_CARGA')]
  [MVCNamedRQLQuery(CONSULTA_ORDENADAS, 'sort(-Cantidad,+ElaboradaPorNombre)')]
  TCargaDePersona = class(TVDashCarga)
  end;

implementation

end.
