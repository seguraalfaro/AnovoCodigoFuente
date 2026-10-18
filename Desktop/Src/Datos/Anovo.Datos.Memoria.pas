unit Anovo.Datos.Memoria;

// Tablas en memoria de las pantallas.

interface

uses
  Anovo.DTOs.Clientes, Anovo.Validacion, Anovo.Formato,
  System.Generics.Collections,
  System.SysUtils, System.Classes, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.FBDef, FireDAC.Phys,
  FireDAC.Phys.IBBase, FireDAC.Phys.FB;

type
  TdmMemoria = class(TDataModule)
    mtClientes: TFDMemTable;
    mtClientesID: TIntegerField;
    mtClientesIDENTIFICACION: TStringField;
    mtClientesNOMBRE: TStringField;
    mtClientesTELEFONO: TStringField;
    mtClientesCORREO: TStringField;
    mtClientesCONSENTIMIENTO_ESTADO: TStringField;
    mtClientesACCIONES: TStringField;
    mtClienteDetalle: TFDMemTable;
    mtClienteDetalleID: TIntegerField;
    mtClienteDetalleUUID_LOCAL: TStringField;
    mtClienteDetalleNOMBRE: TStringField;
    mtClienteDetalleIDENTIFICACION: TStringField;
    mtClienteDetalleTIPO_IDENTIFICACION: TSmallintField;
    mtClienteDetalleTIPO_IDENTIFICACION_TEXTO: TStringField;
    mtClienteDetalleCONTACTO: TStringField;
    mtClienteDetalleTELEFONO: TStringField;
    mtClienteDetalleCORREO: TStringField;
    mtClienteDetalleDIRECCION: TStringField;
    mtClienteDetalleLATITUD: TFloatField;
    mtClienteDetalleLONGITUD: TFloatField;
    mtClienteDetalleACTIVO: TBooleanField;
    mtClienteDetalleEXONERADO: TBooleanField;
    mtClienteDetalleCODIGO_EXONERACION: TStringField;
    mtClienteDetalleCONSENTIMIENTO_ESTADO: TStringField;
    mtClienteDetalleCONSENTIMIENTO_FECHA: TDateTimeField;
    mtClienteDetalleCONSENTIMIENTO_VERSION: TStringField;
    mtClienteDetalleOBJVERSION: TIntegerField;
    mtContactos: TFDMemTable;
    mtContactosID: TIntegerField;
    mtContactosNOMBRE: TStringField;
    mtContactosAREA: TStringField;
    mtContactosTELEFONO: TStringField;
    mtContactosCORREO: TStringField;
    mtContactosPRINCIPAL: TStringField;
    mtContactosACCIONES: TStringField;
    mtConsentimientos: TFDMemTable;
    mtConsentimientosFECHA: TDateTimeField;
    mtConsentimientosACCION: TStringField;
    mtConsentimientosVERSION_TEXTO: TStringField;
    mtConsentimientosFIRMANTE_NOMBRE: TStringField;
    mtClienteCotizaciones: TFDMemTable;
    mtClienteCotizacionesID: TIntegerField;
    mtClienteCotizacionesNUMERO: TIntegerField;
    mtClienteCotizacionesTIPO_TRABAJO_NOMBRE: TStringField;
    mtClienteCotizacionesFECHA_ELABORACION: TDateTimeField;
    mtClienteCotizacionesELABORADA_POR_NOMBRE: TStringField;
    mtClienteCotizacionesMONTO_TOTAL: TCurrencyField;
    mtClienteCotizacionesESTADO: TStringField;
    mtClienteCotizacionesACCIONES: TStringField;
    dsClienteCotizaciones: TDataSource;
    mtSolicitudes: TFDMemTable;
    mtSolicitudesID: TIntegerField;
    mtSolicitudesCODIGO: TStringField;
    mtSolicitudesCLIENTE: TStringField;
    mtSolicitudesASESOR: TStringField;
    mtSolicitudesFECHA_RECEPCION: TDateTimeField;
    mtSolicitudesFOTOS: TIntegerField;
    mtSolicitudesCROQUIS: TStringField;
    mtSolicitudesESTADO: TStringField;
    mtSolicitudesACCIONES: TStringField;
    mtPorCotizar: TFDMemTable;
    mtPorCotizarID: TIntegerField;
    mtPorCotizarCODIGO: TStringField;
    mtPorCotizarCLIENTE: TStringField;
    mtPorCotizarFECHA_RECEPCION: TDateField;
    mtPorCotizarASESOR: TStringField;
    mtPorCotizarESTADO: TStringField;
    mtPorCotizarACCIONES: TStringField;
    mtPorAprobar: TFDMemTable;
    mtPorAprobarID: TIntegerField;
    mtPorAprobarNUMERO: TStringField;
    mtPorAprobarCLIENTE: TStringField;
    mtPorAprobarFECHA_ELABORACION: TDateField;
    mtPorAprobarASESOR: TStringField;
    mtPorAprobarMONTO_TOTAL: TCurrencyField;
    mtPorAprobarESTADO: TStringField;
    mtPorAprobarACCIONES: TStringField;
    mtCotizaciones: TFDMemTable;
    mtCotizacionesID: TIntegerField;
    mtCotizacionesNUMERO: TStringField;
    mtCotizacionesCLIENTE: TStringField;
    mtCotizacionesFECHA_ELABORACION: TDateField;
    mtCotizacionesASESOR: TStringField;
    mtCotizacionesMONTO_TOTAL: TCurrencyField;
    mtCotizacionesESTADO: TStringField;
    mtCotizacionesACCIONES: TStringField;
    mtCotizacionLineas: TFDMemTable;
    mtCotizacionLineasID: TIntegerField;
    mtCotizacionLineasCODIGO: TStringField;
    mtCotizacionLineasDESCRIPCION: TStringField;
    mtCotizacionLineasUNIDAD_MEDIDA: TStringField;
    mtCotizacionLineasCANTIDAD: TFloatField;
    mtCotizacionLineasPRECIO_UNITARIO: TCurrencyField;
    mtCotizacionLineasSUBTOTAL: TCurrencyField;
    mtCotizacionLineasACCIONES: TStringField;
    mtRecientes: TFDMemTable;
    mtRecientesID: TIntegerField;
    mtRecientesNUMERO: TStringField;
    mtRecientesCLIENTE: TStringField;
    mtRecientesFECHA_ELABORACION: TDateField;
    mtRecientesMONTO_TOTAL: TCurrencyField;
    mtRecientesESTADO: TStringField;
    mtGerenciaPendientes: TFDMemTable;
    mtGerenciaPendientesID: TIntegerField;
    mtGerenciaPendientesNUMERO: TStringField;
    mtGerenciaPendientesCLIENTE: TStringField;
    mtGerenciaPendientesFECHA_ELABORACION: TDateField;
    mtGerenciaPendientesASESOR: TStringField;
    mtGerenciaPendientesMONTO_TOTAL: TCurrencyField;
    mtGerenciaPendientesESTADO: TStringField;
    mtGerenciaPendientesACCIONES: TStringField;
    mtGerenciaRecientes: TFDMemTable;
    mtGerenciaRecientesID: TIntegerField;
    mtGerenciaRecientesNUMERO: TStringField;
    mtGerenciaRecientesCLIENTE: TStringField;
    mtGerenciaRecientesFECHA_ELABORACION: TDateField;
    mtGerenciaRecientesASESOR: TStringField;
    mtGerenciaRecientesMONTO_TOTAL: TCurrencyField;
    mtGerenciaRecientesESTADO: TStringField;
    mtGerenciaRecientesACCIONES: TStringField;
    mtMateriales: TFDMemTable;
    mtMaterialesID: TIntegerField;
    mtMaterialesCODIGO: TStringField;
    mtMaterialesNOMBRE: TStringField;
    mtMaterialesDESCRIPCION: TStringField;
    mtMaterialesUNIDAD_MEDIDA_ID: TIntegerField;
    mtMaterialesUNIDAD_MEDIDA: TStringField;
    mtMaterialesCOSTO_UNITARIO: TCurrencyField;
    mtMaterialesPRECIO_UNITARIO: TCurrencyField;
    mtMaterialesFECHA_VIGENCIA: TDateField;
    mtMaterialesPROGRAMADO_FECHA: TDateField;
    mtMaterialesACTIVO: TBooleanField;
    mtMaterialesESTADO: TStringField;
    mtMaterialesACCIONES: TStringField;
    mtManoObra: TFDMemTable;
    mtManoObraID: TIntegerField;
    mtManoObraCODIGO: TStringField;
    mtManoObraCATEGORIA_ID: TIntegerField;
    mtManoObraCATEGORIA_NOMBRE: TStringField;
    mtManoObraNOMBRE: TStringField;
    mtManoObraDESCRIPCION: TStringField;
    mtManoObraUNIDAD_MEDIDA_ID: TIntegerField;
    mtManoObraUNIDAD_MEDIDA: TStringField;
    mtManoObraCOSTO_UNITARIO: TCurrencyField;
    mtManoObraFECHA_VIGENCIA: TDateField;
    mtManoObraPROGRAMADO_FECHA: TDateField;
    mtManoObraACTIVO: TBooleanField;
    mtManoObraESTADO: TStringField;
    mtManoObraACCIONES: TStringField;
    mtMaquinas: TFDMemTable;
    mtMaquinasID: TIntegerField;
    mtMaquinasCODIGO: TStringField;
    mtMaquinasNOMBRE: TStringField;
    mtMaquinasDESCRIPCION: TStringField;
    mtMaquinasCOSTO_HORA: TCurrencyField;
    mtMaquinasFECHA_VIGENCIA: TDateField;
    mtMaquinasPROGRAMADO_FECHA: TDateField;
    mtMaquinasACTIVO: TBooleanField;
    mtMaquinasESTADO: TStringField;
    mtMaquinasACCIONES: TStringField;
    mtTodos: TFDMemTable;
    mtTodosTIPO: TStringField;
    mtTodosID: TIntegerField;
    mtTodosCODIGO: TStringField;
    mtTodosNOMBRE: TStringField;
    mtTodosDESCRIPCION: TStringField;
    mtTodosUNIDAD_MEDIDA_ID: TIntegerField;
    mtTodosUNIDAD_MEDIDA: TStringField;
    mtTodosCATEGORIA_ID: TIntegerField;
    mtTodosCOSTO_UNITARIO: TCurrencyField;
    mtTodosPRECIO_UNITARIO: TCurrencyField;
    mtTodosCOSTO_HORA: TCurrencyField;
    mtTodosCOSTO: TCurrencyField;
    mtTodosFECHA_VIGENCIA: TDateField;
    mtTodosPROGRAMADO_FECHA: TDateField;
    mtTodosACTIVO: TBooleanField;
    mtTodosESTADO: TStringField;
    mtTodosACCIONES: TStringField;
    mtDashboardAsesor: TFDMemTable;
    mtDashboardAsesorID: TIntegerField;
    mtDashboardAsesorCOTIZACION_ID: TIntegerField;
    mtDashboardAsesorFECHA_CAPTURA: TDateTimeField;
    mtDashboardAsesorCLIENTE_NOMBRE: TStringField;
    mtDashboardAsesorDESCRIPCION: TStringField;
    mtDashboardAsesorESTADO: TStringField;
    mtDashboardAsesorMONTO_APROBADO: TCurrencyField;
    dsDashboardAsesor: TDataSource;
    mtDashboardAsistente: TFDMemTable;
    mtDashboardAsistenteID: TIntegerField;
    mtDashboardAsistenteFECHA_RECEPCION: TDateTimeField;
    mtDashboardAsistenteCLIENTE_NOMBRE: TStringField;
    mtDashboardAsistenteASESOR_NOMBRE: TStringField;
    mtDashboardAsistenteDESCRIPCION: TStringField;
    mtDashboardAsistenteDIAS_ESPERA: TIntegerField;
    dsDashboardAsistente: TDataSource;
    mtDashboardSupervisor: TFDMemTable;
    mtDashboardSupervisorID: TIntegerField;
    mtDashboardSupervisorNUMERO: TIntegerField;
    mtDashboardSupervisorFECHA_MODIFICACION: TDateTimeField;
    mtDashboardSupervisorCLIENTE_NOMBRE: TStringField;
    mtDashboardSupervisorELABORADA_POR_NOMBRE: TStringField;
    mtDashboardSupervisorMONTO_TOTAL: TCurrencyField;
    mtDashboardSupervisorDIAS_EN_ESTADO: TIntegerField;
    dsDashboardSupervisor: TDataSource;
    mtDashboardGerencia: TFDMemTable;
    mtDashboardGerenciaASESOR_ID: TIntegerField;
    mtDashboardGerenciaASESOR_NOMBRE: TStringField;
    mtDashboardGerenciaSOLICITUDES_MES: TIntegerField;
    mtDashboardGerenciaAPROBADAS_MES: TIntegerField;
    mtDashboardGerenciaMONTO_APROBADO_MES: TCurrencyField;
    dsDashboardGerencia: TDataSource;
    mtDashboardEstados: TFDMemTable;
    mtDashboardEstadosESTADO: TStringField;
    mtDashboardEstadosCANTIDAD: TIntegerField;
    mtDashboardEstadosMONTO: TCurrencyField;
    dsDashboardEstados: TDataSource;
    mtDashboardCuentas: TFDMemTable;
    mtDashboardCuentasID: TIntegerField;
    mtDashboardCuentasFECHA: TDateTimeField;
    mtDashboardCuentasUSUARIO_NOMBRE: TStringField;
    mtDashboardCuentasACCION: TStringField;
    mtDashboardCuentasDETALLE: TStringField;
    dsDashboardCuentas: TDataSource;
    mtBandeja: TFDMemTable;
    mtBandejaID: TIntegerField;
    mtBandejaNUMERO: TIntegerField;
    mtBandejaCLIENTE_NOMBRE: TStringField;
    mtBandejaASESOR_NOMBRE: TStringField;
    mtBandejaELABORADA_POR_NOMBRE: TStringField;
    mtBandejaDESCRIPCION_TRABAJO: TStringField;
    mtBandejaFECHA_MODIFICACION: TDateTimeField;
    mtBandejaDIAS_EN_ESTADO: TIntegerField;
    mtBandejaMONTO_TOTAL: TCurrencyField;
    mtBandejaACCIONES: TStringField;
    dsBandeja: TDataSource;
    mtRevisionLineas: TFDMemTable;
    mtRevisionLineasID: TIntegerField;
    mtRevisionLineasTIPO: TStringField;
    mtRevisionLineasDESCRIPCION: TStringField;
    mtRevisionLineasUNIDAD_MEDIDA: TStringField;
    mtRevisionLineasCANTIDAD: TCurrencyField;
    mtRevisionLineasPRECIO_UNITARIO: TCurrencyField;
    mtRevisionLineasSUBTOTAL: TCurrencyField;
    dsRevisionLineas: TDataSource;
    mtSolicitudesCola: TFDMemTable;
    mtSolicitudesColaID: TIntegerField;
    mtSolicitudesColaFECHA_RECEPCION: TDateTimeField;
    mtSolicitudesColaCLIENTE_NOMBRE: TStringField;
    mtSolicitudesColaASESOR_NOMBRE: TStringField;
    mtSolicitudesColaDESCRIPCION: TStringField;
    mtSolicitudesColaDIAS_ESPERA: TIntegerField;
    mtSolicitudesColaACCIONES: TStringField;
    dsSolicitudesCola: TDataSource;
    mtSolicitudesEnTrabajo: TFDMemTable;
    mtSolicitudesEnTrabajoID: TIntegerField;
    mtSolicitudesEnTrabajoSOLICITUD_ID: TIntegerField;
    mtSolicitudesEnTrabajoNUMERO: TIntegerField;
    mtSolicitudesEnTrabajoFECHA_MODIFICACION: TDateTimeField;
    mtSolicitudesEnTrabajoCLIENTE_NOMBRE: TStringField;
    mtSolicitudesEnTrabajoDESCRIPCION_TRABAJO: TStringField;
    mtSolicitudesEnTrabajoESTADO: TStringField;
    mtSolicitudesEnTrabajoMOTIVO_RECHAZO: TStringField;
    mtSolicitudesEnTrabajoACCIONES: TStringField;
    dsSolicitudesEnTrabajo: TDataSource;
    mtSeguimiento: TFDMemTable;
    mtSeguimientoID: TIntegerField;
    mtSeguimientoCOTIZACION_ID: TIntegerField;
    mtSeguimientoFECHA_CAPTURA: TDateTimeField;
    mtSeguimientoCLIENTE_NOMBRE: TStringField;
    mtSeguimientoDESCRIPCION: TStringField;
    mtSeguimientoESTADO: TStringField;
    mtSeguimientoMONTO_APROBADO: TCurrencyField;
    mtSeguimientoVER_COTIZACION: TBooleanField;
    mtSeguimientoACCIONES: TStringField;
    dsSeguimiento: TDataSource;
    mtTiposTrabajo: TFDMemTable;
    mtTiposTrabajoID: TIntegerField;
    mtTiposTrabajoNOMBRE: TStringField;
    mtTiposTrabajoACTIVO: TBooleanField;
    mtTiposTrabajoESTADO: TStringField;
    mtTiposTrabajoACCIONES: TStringField;
    mtHistorialPrecios: TFDMemTable;
    mtHistorialPreciosFECHA_VIGENCIA: TDateField;
    mtHistorialPreciosPRECIO_UNITARIO: TCurrencyField;
    mtHistorialPreciosVARIACION: TStringField;
    mtHistorialPreciosMODIFICADO_POR: TStringField;
    mtHistorialPreciosREGISTRADO: TDateTimeField;
    mtFotos: TFDMemTable;
    mtFotosID: TIntegerField;
    mtFotosNOMBRE_ARCHIVO: TStringField;
    mtFotosFECHA_CREACION: TDateTimeField;
    mtFotosACCIONES: TStringField;
    mtRoles: TFDMemTable;
    mtRolesID: TIntegerField;
    mtRolesCODIGO: TStringField;
    mtRolesNOMBRE: TStringField;
    mtPermisos: TFDMemTable;
    mtPermisosID: TIntegerField;
    mtPermisosCODIGO: TStringField;
    mtPermisosNOMBRE: TStringField;
    mtPermisosMODULO: TStringField;
    mtPermisosOTORGADO: TBooleanField;
    mtAuditoria: TFDMemTable;
    mtAuditoriaID: TIntegerField;
    mtAuditoriaFECHA: TDateTimeField;
    mtAuditoriaUSUARIO: TStringField;
    mtAuditoriaACCION: TStringField;
    mtAuditoriaENTIDAD: TStringField;
    mtAuditoriaENTIDAD_ID: TIntegerField;
    mtAuditoriaDETALLE: TStringField;
    dsAuditoria: TDataSource;
    mtItemCatalogo: TFDMemTable;
    mtItemCatalogoCODIGO: TStringField;
    mtItemCatalogoNOMBRE: TStringField;
    mtItemCatalogoDESCRIPCION: TStringField;
    mtItemCatalogoUNIDAD_MEDIDA_ID: TIntegerField;
    mtItemCatalogoABREVIATURA: TStringField;
    mtItemCatalogoMAGNITUD: TStringField;
    mtItemCatalogoCATEGORIA_ID: TIntegerField;
    mtPrecioCatalogo: TFDMemTable;
    mtPrecioCatalogoCOSTO_UNITARIO: TCurrencyField;
    mtPrecioCatalogoPRECIO_UNITARIO: TCurrencyField;
    mtPrecioCatalogoCOSTO_HORA: TCurrencyField;
    mtPrecioCatalogoFECHA_VIGENCIA: TDateField;
    mtHistorialPrecio: TFDMemTable;
    mtHistorialPrecioFECHA_VIGENCIA: TDateField;
    mtHistorialPrecioCOSTO_UNITARIO: TCurrencyField;
    mtHistorialPrecioPRECIO_UNITARIO: TCurrencyField;
    mtHistorialPrecioCOSTO_HORA: TCurrencyField;
    mtHistorialPrecioACTIVO: TBooleanField;
    mtHistorialPrecioESTADO: TStringField;
    dsCatalogo: TDataSource;
    dsTodos: TDataSource;
    dsMateriales: TDataSource;
    dsManoObra: TDataSource;
    dsMaquinas: TDataSource;
    dsTiposTrabajo: TDataSource;
    dsUnidadesLista: TDataSource;
    dsCatalogoSimple: TDataSource;
    mtUnidadesMedida: TFDMemTable;
    mtUnidadesMedidaID: TIntegerField;
    mtUnidadesMedidaNOMBRE: TStringField;
    mtUnidadesLista: TFDMemTable;
    mtUnidadesListaID: TIntegerField;
    mtUnidadesListaNOMBRE: TStringField;
    mtUnidadesListaABREVIATURA: TStringField;
    mtUnidadesListaMAGNITUD: TStringField;
    mtUnidadesListaACTIVO: TBooleanField;
    mtUnidadesListaESTADO: TStringField;
    mtUnidadesListaACCIONES: TStringField;
    dsUnidadesMedida: TDataSource;
    dsItemCatalogo: TDataSource;
    dsPrecioCatalogo: TDataSource;
    dsHistorialPrecio: TDataSource;
    dsClientes: TDataSource;
    dsClienteDetalle: TDataSource;
    dsContactos: TDataSource;
    dsConsentimientos: TDataSource;
    mtClienteNuevo: TFDMemTable;
    mtClienteNuevoUUID_LOCAL: TStringField;
    mtClienteNuevoNOMBRE: TStringField;
    mtClienteNuevoIDENTIFICACION: TStringField;
    mtClienteNuevoTIPO_IDENTIFICACION: TSmallintField;
    mtClienteNuevoTIPO_IDENTIFICACION_TEXTO: TStringField;
    mtClienteNuevoCONTACTO: TStringField;
    mtClienteNuevoTELEFONO: TStringField;
    mtClienteNuevoCORREO: TStringField;
    mtClienteNuevoDIRECCION: TStringField;
    mtClienteNuevoLATITUD: TFloatField;
    mtClienteNuevoLONGITUD: TFloatField;
    mtClienteNuevoACTIVO: TBooleanField;
    mtClienteNuevoEXONERADO: TBooleanField;
    mtClienteNuevoCODIGO_EXONERACION: TStringField;
    mtClienteNuevoCONSENTIMIENTO_ESTADO: TStringField;
    mtClienteNuevoCONSENTIMIENTO_FECHA: TDateTimeField;
    mtClienteNuevoCONSENTIMIENTO_VERSION: TStringField;
    mtClienteNuevoANONIMIZADO: TBooleanField;
    mtContactoNuevo: TFDMemTable;
    mtContactoNuevoUUID_LOCAL: TStringField;
    mtContactoNuevoCLIENTE_ID: TIntegerField;
    mtContactoNuevoNOMBRE: TStringField;
    mtContactoNuevoAREA: TStringField;
    mtContactoNuevoTELEFONO: TStringField;
    mtContactoNuevoCELULAR: TStringField;
    mtContactoNuevoCORREO: TStringField;
    mtContactoNuevoPRINCIPAL: TBooleanField;
    mtContactoNuevoCONSENTIMIENTO_ESTADO: TStringField;
    mtContactoNuevoANONIMIZADO: TBooleanField;
    mtContactoNuevoACTIVO: TBooleanField;
    dsClienteNuevo: TDataSource;
    dsContactoNuevo: TDataSource;
    mtTiposIdentificacion: TFDMemTable;
    mtTiposIdentificacionID: TSmallintField;
    mtTiposIdentificacionNOMBRE: TStringField;
    dsTiposIdentificacion: TDataSource;
    mtUsuarios: TFDMemTable;
    mtUsuariosID: TIntegerField;
    mtUsuariosNOMBRE: TStringField;
    mtUsuariosCORREO: TStringField;
    mtUsuariosROL_ID: TIntegerField;
    mtUsuariosROL_NOMBRE: TStringField;
    mtUsuariosACTIVO: TBooleanField;
    mtUsuariosDEBE_CAMBIAR_CLAVE: TBooleanField;
    mtUsuariosEXCEPCIONES: TIntegerField;
    mtUsuariosESTADO: TStringField;
    mtUsuariosACCIONES: TStringField;
    dsUsuarios: TDataSource;
    mtPermisosUsuario: TFDMemTable;
    mtPermisosUsuarioPERMISO_ID: TIntegerField;
    mtPermisosUsuarioMODULO: TStringField;
    mtPermisosUsuarioNOMBRE: TStringField;
    mtPermisosUsuarioTIENE: TBooleanField;
    mtPermisosUsuarioDEL_ROL: TBooleanField;
    mtPermisosUsuarioTIENE_ORIGINAL: TBooleanField;
    mtPermisosUsuarioMOTIVO: TStringField;
    mtPermisosUsuarioORIGEN: TStringField;
    mtPermisosUsuarioADICIONALES: TAggregateField;
    mtPermisosUsuarioQUITADOS: TAggregateField;
    dsPermisosUsuario: TDataSource;
    mtMatrizRoles: TFDMemTable;
    mtMatrizRolesPERMISO_ID: TIntegerField;
    mtMatrizRolesMODULO: TStringField;
    mtMatrizRolesNOMBRE: TStringField;
    mtMatrizRolesASESOR: TBooleanField;
    mtMatrizRolesASISTENTE: TBooleanField;
    mtMatrizRolesSUPERVISOR: TBooleanField;
    mtMatrizRolesGERENCIA: TBooleanField;
    mtMatrizRolesADMIN: TBooleanField;
    dsMatrizRoles: TDataSource;
    mtUsuario: TFDMemTable;
    mtUsuarioNOMBRE: TStringField;
    mtUsuarioCORREO: TStringField;
    mtUsuarioROL_ID: TIntegerField;
    mtUsuarioCLAVE_TEMPORAL: TStringField;
    dsUsuario: TDataSource;
    dsRoles: TDataSource;
    mtCategorias: TFDMemTable;
    mtCategoriasID: TIntegerField;
    mtCategoriasNOMBRE: TStringField;
    dsCategorias: TDataSource;
    mtMagnitudes: TFDMemTable;
    mtMagnitudesCODIGO: TStringField;
    mtMagnitudesNOMBRE: TStringField;
    dsMagnitudes: TDataSource;
    mtCotizacionesLista: TFDMemTable;
    mtCotizacionesListaID: TIntegerField;
    mtCotizacionesListaNUMERO: TIntegerField;
    mtCotizacionesListaCLIENTE_NOMBRE: TStringField;
    mtCotizacionesListaDESCRIPCION_TRABAJO: TStringField;
    mtCotizacionesListaASESOR_NOMBRE: TStringField;
    mtCotizacionesListaFECHA_ELABORACION: TDateTimeField;
    mtCotizacionesListaMONTO_TOTAL: TCurrencyField;
    mtCotizacionesListaESTADO: TStringField;
    mtCotizacionesListaACCIONES: TStringField;
    dsCotizacionesLista: TDataSource;
    mtLineasCotizacion: TFDMemTable;
    mtLineasCotizacionID: TIntegerField;
    mtLineasCotizacionTIPO: TStringField;
    mtLineasCotizacionDESCRIPCION: TStringField;
    mtLineasCotizacionUNIDAD_MEDIDA: TStringField;
    mtLineasCotizacionCANTIDAD: TCurrencyField;
    mtLineasCotizacionPRECIO_UNITARIO: TCurrencyField;
    mtLineasCotizacionSUBTOTAL: TCurrencyField;
    mtLineasCotizacionACCIONES: TStringField;
    dsLineasCotizacion: TDataSource;
    mtCotizacionEdicion: TFDMemTable;
    mtCotizacionEdicionTIPO_TRABAJO_ID: TIntegerField;
    mtCotizacionEdicionDESCRIPCION_TRABAJO: TStringField;
    mtCotizacionEdicionFORMA_PAGO_ID: TIntegerField;
    mtCotizacionEdicionPLAZO_ENTREGA_CANTIDAD: TIntegerField;
    mtCotizacionEdicionPLAZO_ENTREGA_UNIDAD: TStringField;
    mtCotizacionEdicionGARANTIA_CANTIDAD: TIntegerField;
    mtCotizacionEdicionGARANTIA_UNIDAD: TStringField;
    dsCotizacionEdicion: TDataSource;
    mtTiposTrabajoLista: TFDMemTable;
    mtTiposTrabajoListaID: TIntegerField;
    mtTiposTrabajoListaNOMBRE: TStringField;
    dsTiposTrabajoLista: TDataSource;
    mtMedidas: TFDMemTable;
    mtMedidasPIEZA_NOMBRE: TStringField;
    mtMedidasETIQUETA: TStringField;
    mtMedidasTIPO_MEDIDA: TStringField;
    mtMedidasUNIDAD_MEDIDA: TStringField;
    mtMedidasVALOR: TCurrencyField;
    mtMedidasCANTIDAD: TIntegerField;
    dsMedidas: TDataSource;
    mtPiezas: TFDMemTable;
    mtPiezasID: TIntegerField;
    mtPiezasNOMBRE: TStringField;
    mtPiezasTIPO_TRABAJO_NOMBRE: TStringField;
    mtPiezasTIPO_MATERIAL_NOMBRE: TStringField;
    mtPiezasACABADO_NOMBRE: TStringField;
    dsPiezas: TDataSource;
    mtCatalogoSimple: TFDMemTable;
    mtCatalogoSimpleID: TIntegerField;
    mtCatalogoSimpleNOMBRE: TStringField;
    mtCatalogoSimpleACTIVO: TBooleanField;
    mtCatalogoSimpleESTADO: TStringField;
    mtCatalogoSimpleACCIONES: TStringField;
    mtFormasPagoLista: TFDMemTable;
    mtFormasPagoListaID: TIntegerField;
    mtFormasPagoListaNOMBRE: TStringField;
    dsFormasPagoLista: TDataSource;
    mtUnidadesPlazo: TFDMemTable;
    mtUnidadesPlazoCODIGO: TStringField;
    mtUnidadesPlazoNOMBRE: TStringField;
    dsUnidadesPlazo: TDataSource;
    mtTelefonos: TFDMemTable;
    mtTelefonosID: TIntegerField;
    mtTelefonosNOMBRE: TStringField;
    mtTelefonosFECHA_CREACION: TDateTimeField;
    mtTelefonosFECHA_ULTIMO_USO: TDateTimeField;
    mtTelefonosESTADO: TStringField;
    mtTelefonosMOTIVO: TStringField;
    mtTelefonosACTIVO: TBooleanField;
    mtTelefonosINACTIVAR: TBooleanField;
    dsTelefonos: TDataSource;
    mtTextosConsentimiento: TFDMemTable;
    mtTextosConsentimientoID: TIntegerField;
    mtTextosConsentimientoVERSION: TStringField;
    mtTextosConsentimientoTITULO: TStringField;
    mtTextosConsentimientoVIGENTE_DESDE: TDateTimeField;
    mtTextosConsentimientoESTADO: TStringField;
    mtTextosConsentimientoVIGENTE: TBooleanField;
    mtTextosConsentimientoCONTENIDO: TWideMemoField;
    dsTextosConsentimiento: TDataSource;
    mtConsentimientoNuevo: TFDMemTable;
    mtConsentimientoNuevoVERSION: TStringField;
    mtConsentimientoNuevoTITULO: TStringField;
    mtConsentimientoNuevoCONTENIDO: TWideMemoField;
    dsConsentimientoNuevo: TDataSource;
    mtItemsLinea: TFDMemTable;
    mtItemsLineaID: TIntegerField;
    mtItemsLineaCODIGO: TStringField;
    mtItemsLineaNOMBRE: TStringField;
    mtItemsLineaCATEGORIA: TStringField;
    mtItemsLineaUNIDAD_MEDIDA: TStringField;
    mtItemsLineaPRECIO: TCurrencyField;
    mtItemsLineaPROGRAMADO_FECHA: TDateTimeField;
    dsItemsLinea: TDataSource;
    mtLineaNueva: TFDMemTable;
    mtLineaNuevaCANTIDAD: TCurrencyField;
    mtLineaNuevaNOTA: TStringField;
    dsLineaNueva: TDataSource;
    mtAjuste: TFDMemTable;
    mtAjustePORCENTAJE: TCurrencyField;
    mtAjusteMOTIVO: TStringField;
    dsAjuste: TDataSource;
    mtReporteEstados: TFDMemTable;
    mtReporteEstadosESTADO: TStringField;
    mtReporteEstadosCANTIDAD: TIntegerField;
    mtReporteEstadosMONTO: TCurrencyField;
    dsReporteEstados: TDataSource;
    mtReporteAsesores: TFDMemTable;
    mtReporteAsesoresASESOR_ID: TIntegerField;
    mtReporteAsesoresASESOR_NOMBRE: TStringField;
    mtReporteAsesoresCANTIDAD: TIntegerField;
    mtReporteAsesoresAPROBADAS: TIntegerField;
    mtReporteAsesoresRECHAZADAS: TIntegerField;
    mtReporteAsesoresDESCARTADAS: TIntegerField;
    mtReporteAsesoresTASA_APROBACION: TIntegerField;
    mtReporteAsesoresMONTO_TOTAL: TCurrencyField;
    mtReporteAsesoresMONTO_APROBADO: TCurrencyField;
    dsReporteAsesores: TDataSource;
    mtReporteClientes: TFDMemTable;
    mtReporteClientesCLIENTE_ID: TIntegerField;
    mtReporteClientesCLIENTE_NOMBRE: TStringField;
    mtReporteClientesENVIADAS: TIntegerField;
    mtReporteClientesAPROBADAS: TIntegerField;
    mtReporteClientesRECHAZADAS: TIntegerField;
    mtReporteClientesEN_ESPERA: TIntegerField;
    mtReporteClientesSIN_RESPUESTA: TIntegerField;
    mtReporteClientesPORCENTAJE_SIN_RESPUESTA: TIntegerField;
    mtReporteClientesMONTO_SIN_RESPUESTA: TCurrencyField;
    mtReporteClientesULTIMO_ENVIO: TDateTimeField;
    dsReporteClientes: TDataSource;
    mtReporteTipos: TFDMemTable;
    mtReporteTiposTIPO_TRABAJO_ID: TIntegerField;
    mtReporteTiposTIPO_TRABAJO_NOMBRE: TStringField;
    mtReporteTiposCANTIDAD: TIntegerField;
    mtReporteTiposAPROBADAS: TIntegerField;
    mtReporteTiposRECHAZADAS: TIntegerField;
    mtReporteTiposDESCARTADAS: TIntegerField;
    mtReporteTiposTASA_APROBACION: TIntegerField;
    mtReporteTiposMONTO_TOTAL: TCurrencyField;
    mtReporteTiposMONTO_APROBADO: TCurrencyField;
    dsReporteTipos: TDataSource;
    mtReporteMeses: TFDMemTable;
    mtReporteMesesMES_NOMBRE: TStringField;
    mtReporteMesesANIO: TIntegerField;
    mtReporteMesesMES: TIntegerField;
    mtReporteMesesCANTIDAD: TIntegerField;
    mtReporteMesesAPROBADAS: TIntegerField;
    mtReporteMesesRECHAZADAS: TIntegerField;
    mtReporteMesesDESCARTADAS: TIntegerField;
    mtReporteMesesTASA_APROBACION: TIntegerField;
    mtReporteMesesMONTO_TOTAL: TCurrencyField;
    mtReporteMesesMONTO_APROBADO: TCurrencyField;
    dsReporteMeses: TDataSource;
    mtImportacion: TFDMemTable;
    mtImportacionFILA: TIntegerField;
    mtImportacionCODIGO: TStringField;
    mtImportacionCATEGORIA: TStringField;
    mtImportacionNOMBRE: TStringField;
    mtImportacionDESCRIPCION: TStringField;
    mtImportacionUNIDAD: TStringField;
    mtImportacionCOSTO: TStringField;
    mtImportacionPRECIO: TStringField;
    mtImportacionREVISION: TStringField;
    mtImportacionCON_ERROR: TBooleanField;
    dsImportacion: TDataSource;
    mtEmpresa: TFDMemTable;
    mtEmpresaRAZON_SOCIAL: TStringField;
    mtEmpresaCEDULA_JURIDICA: TStringField;
    mtEmpresaDIRECCION: TStringField;
    mtEmpresaTELEFONO_FIJO: TStringField;
    mtEmpresaCELULAR: TStringField;
    mtEmpresaCORREO: TStringField;
    mtEmpresaREPRESENTANTE_LEGAL: TStringField;
    mtEmpresaCUENTA_BANCARIA: TStringField;
    mtEmpresaPORCENTAJE_IVA: TCurrencyField;
    mtEmpresaFORMA_PAGO_ID: TIntegerField;
    mtEmpresaPLAZO_ENTREGA_CANTIDAD: TIntegerField;
    mtEmpresaPLAZO_ENTREGA_UNIDAD: TStringField;
    mtEmpresaGARANTIA_CANTIDAD: TIntegerField;
    mtEmpresaGARANTIA_UNIDAD: TStringField;
    mtEmpresaFIRMANTE: TStringField;
    mtEmpresaCARTA_PRESENTACION: TStringField;
    dsEmpresa: TDataSource;
    mtParametros: TFDMemTable;
    mtParametrosDIAS_SIN_RESPUESTA: TIntegerField;
    mtParametrosMINUTOS_AVISOS: TIntegerField;
    dsParametros: TDataSource;
    mtDocumentoLineas: TFDMemTable;
    mtDocumentoLineasDESCRIPCION: TStringField;
    mtDocumentoLineasCANTIDAD: TCurrencyField;
    mtDocumentoLineasPRECIO_UNITARIO: TCurrencyField;
    mtDocumentoLineasTOTAL: TCurrencyField;
    dsDocumentoLineas: TDataSource;
    mtEnvioCorreo: TFDMemTable;
    mtEnvioCorreoPARA: TStringField;
    mtEnvioCorreoCC: TStringField;
    mtEnvioCorreoASUNTO: TStringField;
    mtEnvioCorreoMENSAJE: TStringField;
    dsEnvioCorreo: TDataSource;
    mtSinRespuesta: TFDMemTable;
    mtSinRespuestaID: TIntegerField;
    mtSinRespuestaNUMERO: TIntegerField;
    mtSinRespuestaCLIENTE_NOMBRE: TStringField;
    mtSinRespuestaFECHA_ENVIO: TDateTimeField;
    mtSinRespuestaDIAS: TIntegerField;
    mtSinRespuestaMONTO_TOTAL: TCurrencyField;
    mtSinRespuestaACCIONES: TStringField;
    dsSinRespuesta: TDataSource;
    mtHistorialEstados: TFDMemTable;
    mtHistorialEstadosFECHA: TDateTimeField;
    mtHistorialEstadosESTADO: TStringField;
    mtHistorialEstadosUSUARIO_NOMBRE: TStringField;
    mtHistorialEstadosMOTIVO: TStringField;
    mtHistorialEstadosACTIVO: TBooleanField;
    dsHistorialEstados: TDataSource;
    mtDetalleReporte: TFDMemTable;
    mtDetalleReporteID: TIntegerField;
    mtDetalleReporteNUMERO: TIntegerField;
    mtDetalleReporteCLIENTE_NOMBRE: TStringField;
    mtDetalleReporteDESCRIPCION_TRABAJO: TStringField;
    mtDetalleReporteASESOR_NOMBRE: TStringField;
    mtDetalleReporteFECHA_ENVIO: TDateTimeField;
    mtDetalleReporteMONTO_TOTAL: TCurrencyField;
    mtDetalleReporteESTADO: TStringField;
    mtDetalleReporteACCIONES: TStringField;
    dsDetalleReporte: TDataSource;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
    procedure mtContactoNuevoBeforePost(DataSet: TDataSet);
    procedure CatalogoCalcFields(DataSet: TDataSet);
    procedure SeguimientoCalcFields(DataSet: TDataSet);
    procedure MotivoTelefonoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TextosConsentimientoCalcFields(DataSet: TDataSet);
    procedure SinRespuestaCalcFields(DataSet: TDataSet);
    procedure EstadoConsentimientoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure EstadoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure TipoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ClaveGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure MagnitudGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure MayusculaInicialGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure UsuariosCalcFields(DataSet: TDataSet);
    procedure UsuarioEstadoGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure AdicionalesGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure PermisosUsuarioCalcFields(DataSet: TDataSet);
    procedure OrigenGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure AccionAuditoriaGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure EntidadAuditoriaGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ModuloGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ReporteMesesCalcFields(DataSet: TDataSet);
    procedure PorcentajeGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure UsuarioNombreGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    procedure CargarTiposIdentificacion;
    procedure CargarMagnitudes;
    procedure CargarUnidadesPlazo;
  public
    procedure PrepararItemCatalogo;
    procedure PrepararPrecioCatalogo;
    procedure PrepararClienteNuevo;
    procedure PrepararContactoNuevo(const AClienteId: Integer);
    procedure PrepararUsuario;
    procedure PrepararConsentimientoNuevo;
    procedure PrepararParametros(const AMinutosAvisos: Integer);
    procedure FijarDiasSinRespuesta(const ADias: Integer);
    procedure Preparar(const ATabla: TFDMemTable);
    procedure SoloExcepciones(const ASolo: Boolean);
    procedure PrepararImportacion(const AConUnidad, AConCategoria,
      AConPrecio: Boolean; const ARotuloCosto: string);
    procedure SoloErroresImportacion(const ASolo: Boolean);
    procedure SinTodasLasCategorias(const ASin: Boolean);
    function PermisoSinGuardar: Boolean;
    procedure Confirmar(const ATabla: TDataSet);
    procedure LimpiarTodo;
    function FilaCatalogo: TDataSet;
    function IdFilaCatalogo: Integer;
    function NombreFilaCatalogo: string;
  end;

var
  dmMemoria: TdmMemoria;

implementation

{$R *.dfm}

uses
  System.DateUtils,
  Anovo.Condiciones,
  Anovo.DTOs.Catalogos,
  Anovo.Sesion,
  Anovo.Textos;

const
  CONSENTIMIENTO_PENDIENTE = 'pendiente';
  CAMPO_ID_CATALOGO = 'ID';
  CAMPO_NOMBRE_CATALOGO = 'NOMBRE';

  ESTADO_ACTIVO = 'activo';
  ESTADO_INACTIVO = 'inactivo';
  ESTADO_PROGRAMADO = 'programado';
  ESTADO_CLAVE_PENDIENTE = 'pendiente';

  ORIGEN_BASICO = 'basico';
  ORIGEN_ADICIONAL = 'adicional';
  ORIGEN_QUITADO = 'quitado';
  ORIGEN_SIN_GUARDAR = 'sin_guardar';
  FILTRO_EXCEPCIONES = 'TIENE <> DEL_ROL';
  FILTRO_ERRORES_IMPORTACION = 'CON_ERROR = True';
  FILTRO_CATEGORIAS = 'ID > 0';

function NuevoUuid: string;
begin
  Result := LowerCase(TGUID.NewGuid.ToString.Trim(['{', '}']));
end;

procedure TdmMemoria.DataModuleCreate(Sender: TObject);
begin
  CargarTiposIdentificacion;
  CargarMagnitudes;
  CargarUnidadesPlazo;
end;

procedure TdmMemoria.CargarTiposIdentificacion;
var
  lTipo: TTipoIdentificacion;
begin
  mtTiposIdentificacion.Close;
  mtTiposIdentificacion.CreateDataSet;
  for lTipo := tiFisica to High(TTipoIdentificacion) do
    mtTiposIdentificacion.AppendRecord([Ord(lTipo),
      TIPOS_IDENTIFICACION[lTipo]]);
  mtTiposIdentificacion.First;
end;

procedure TdmMemoria.CargarMagnitudes;
var
  lMagnitud: string;
begin
  mtMagnitudes.Close;
  mtMagnitudes.CreateDataSet;
  for lMagnitud in MAGNITUDES do
    mtMagnitudes.AppendRecord([lMagnitud, TFormato.Magnitud(lMagnitud)]);
  mtMagnitudes.First;
end;

procedure TdmMemoria.CargarUnidadesPlazo;
var
  lUnidad: string;
begin
  mtUnidadesPlazo.Close;
  mtUnidadesPlazo.CreateDataSet;
  for lUnidad in UNIDADES_PLAZO do
    mtUnidadesPlazo.AppendRecord([lUnidad, NombreUnidadPlazo(lUnidad)]);
  mtUnidadesPlazo.First;
end;

procedure TdmMemoria.mtContactoNuevoBeforePost(DataSet: TDataSet);
begin
  mtContactoNuevoTELEFONO.AsString :=
    TFormato.TelefonoExt(mtContactoNuevoTELEFONO.AsString);
end;

procedure TdmMemoria.SinRespuestaCalcFields(DataSet: TDataSet);
begin
  if mtSinRespuestaFECHA_ENVIO.IsNull then
    mtSinRespuestaDIAS.Clear
  else
    mtSinRespuestaDIAS.AsInteger := DaysBetween(Date,
      DateOf(mtSinRespuestaFECHA_ENVIO.AsDateTime));
end;

procedure TdmMemoria.TextosConsentimientoCalcFields(DataSet: TDataSet);
begin
  if mtTextosConsentimientoVIGENTE.AsBoolean then
    mtTextosConsentimientoESTADO.AsString := ESTADO_ACTIVO
  else
    mtTextosConsentimientoESTADO.AsString := ESTADO_INACTIVO;
end;

procedure TdmMemoria.EstadoConsentimientoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if Sender.AsString = ESTADO_ACTIVO then
    Text := SEstadoVigente
  else
    Text := SEstadoAnterior;
end;

procedure TdmMemoria.MotivoTelefonoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := TFormato.MotivoTelefono(Sender.AsString);
end;

procedure TdmMemoria.SeguimientoCalcFields(DataSet: TDataSet);
begin
  mtSeguimientoVER_COTIZACION.AsBoolean :=
    mtSeguimientoCOTIZACION_ID.AsInteger > 0;
end;

procedure TdmMemoria.CatalogoCalcFields(DataSet: TDataSet);
var
  lProgramado, lEstado: TField;
begin
  lProgramado := DataSet.FindField('PROGRAMADO_FECHA');
  lEstado := DataSet.FieldByName('ESTADO');

  if not DataSet.FieldByName('ACTIVO').AsBoolean then
    lEstado.AsString := ESTADO_INACTIVO
  else if (lProgramado <> nil) and not lProgramado.IsNull then
    lEstado.AsString := ESTADO_PROGRAMADO
  else
    lEstado.AsString := ESTADO_ACTIVO;
end;

procedure TdmMemoria.UsuariosCalcFields(DataSet: TDataSet);
begin
  if not mtUsuariosACTIVO.AsBoolean then
    mtUsuariosESTADO.AsString := ESTADO_INACTIVO
  else if mtUsuariosDEBE_CAMBIAR_CLAVE.AsBoolean then
    mtUsuariosESTADO.AsString := ESTADO_CLAVE_PENDIENTE
  else
    mtUsuariosESTADO.AsString := ESTADO_ACTIVO;
end;

procedure TdmMemoria.UsuarioEstadoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsString = ESTADO_CLAVE_PENDIENTE then
    Text := SEstClavePendiente
  else
    Text := TFormato.Estado(Sender.AsString);
end;

procedure TdmMemoria.AdicionalesGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsInteger > 0 then
    Text := Sender.AsString
  else
    Text := '';
end;

procedure TdmMemoria.PermisosUsuarioCalcFields(DataSet: TDataSet);
begin
  if mtPermisosUsuarioTIENE.AsBoolean <>
    mtPermisosUsuarioTIENE_ORIGINAL.AsBoolean then
    mtPermisosUsuarioORIGEN.AsString := ORIGEN_SIN_GUARDAR
  else if mtPermisosUsuarioTIENE.AsBoolean = mtPermisosUsuarioDEL_ROL.AsBoolean then
  begin
    if mtPermisosUsuarioDEL_ROL.AsBoolean then
      mtPermisosUsuarioORIGEN.AsString := ORIGEN_BASICO
    else
      mtPermisosUsuarioORIGEN.AsString := '';
  end
  else if mtPermisosUsuarioTIENE.AsBoolean then
    mtPermisosUsuarioORIGEN.AsString := ORIGEN_ADICIONAL
  else
    mtPermisosUsuarioORIGEN.AsString := ORIGEN_QUITADO;
end;

procedure TdmMemoria.AccionAuditoriaGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := TFormato.AccionAuditoria(Sender.AsString);
end;

procedure TdmMemoria.EntidadAuditoriaGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := TFormato.EntidadAuditoria(Sender.AsString);
end;

procedure TdmMemoria.ModuloGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := TFormato.Modulo(Sender.AsString);
end;

procedure TdmMemoria.UsuarioNombreGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if mtUsuariosID.AsInteger = TSesion.UsuarioId then
    Text := Format(SUsted, [Sender.AsString])
  else
    Text := Sender.AsString;
end;

procedure TdmMemoria.OrigenGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.AsString = ORIGEN_BASICO then
    Text := SOrigenBasico
  else if Sender.AsString = ORIGEN_ADICIONAL then
    Text := SOrigenAdicional
  else if Sender.AsString = ORIGEN_QUITADO then
    Text := SOrigenQuitado
  else if Sender.AsString = ORIGEN_SIN_GUARDAR then
    Text := SSinGuardar
  else
    Text := '';
end;

procedure TdmMemoria.ReporteMesesCalcFields(DataSet: TDataSet);
var
  lFecha: TDateTime;
begin
  if TryEncodeDate(mtReporteMesesANIO.AsInteger, mtReporteMesesMES.AsInteger,
    1, lFecha) then
    mtReporteMesesMES_NOMBRE.AsString := TFormato.MesAnio(lFecha)
  else
    mtReporteMesesMES_NOMBRE.Clear;
end;

procedure TdmMemoria.PorcentajeGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := ''
  else
    Text := TFormato.Tasa(Sender.AsInteger);
end;

procedure TdmMemoria.EstadoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := TFormato.Estado(Sender.AsString);
end;

procedure TdmMemoria.ClaveGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := TFormato.ClaveEnGrupos(Sender.AsString);
end;

procedure TdmMemoria.MagnitudGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := TFormato.Magnitud(Sender.AsString);
end;

procedure TdmMemoria.MayusculaInicialGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := Sender.AsString;
  if not Text.IsEmpty then
    Text := UpperCase(Text[1]) + Copy(Text, 2, MaxInt);
end;

procedure TdmMemoria.TipoGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if SameText(Sender.AsString, TIPO_MANO_OBRA) then
    Text := STipoManoObra
  else if SameText(Sender.AsString, TIPO_MAQUINA) then
    Text := STipoMaquina
  else if SameText(Sender.AsString, TIPO_NOTA) then
    Text := STipoNota
  else
    Text := STipoMaterial;
end;

procedure TdmMemoria.PrepararItemCatalogo;
begin
  mtItemCatalogo.Close;
  mtItemCatalogo.CreateDataSet;
  mtItemCatalogo.Append;
end;

procedure TdmMemoria.PrepararPrecioCatalogo;
begin
  mtPrecioCatalogo.Close;
  mtPrecioCatalogo.CreateDataSet;
  mtPrecioCatalogo.Append;
  mtPrecioCatalogoFECHA_VIGENCIA.AsDateTime := Date;
end;

procedure TdmMemoria.PrepararClienteNuevo;
begin
  mtClienteNuevo.Close;
  mtClienteNuevo.CreateDataSet;
  mtClienteNuevo.Append;
  mtClienteNuevoUUID_LOCAL.AsString := NuevoUuid;
  mtClienteNuevoACTIVO.AsBoolean := True;
  mtClienteNuevoANONIMIZADO.AsBoolean := False;
  mtClienteNuevoEXONERADO.AsBoolean := False;
  mtClienteNuevoCONSENTIMIENTO_ESTADO.AsString := CONSENTIMIENTO_PENDIENTE;
end;

procedure TdmMemoria.LimpiarTodo;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TFDMemTable then
      TFDMemTable(Components[I]).Close;
  CargarTiposIdentificacion;
  CargarMagnitudes;
  CargarUnidadesPlazo;
end;

procedure TdmMemoria.Confirmar(const ATabla: TDataSet);
begin
  if ATabla.State in dsEditModes then
    ATabla.Post;
end;

function TdmMemoria.FilaCatalogo: TDataSet;
begin
  Result := dsCatalogo.DataSet;
  if (Result <> nil) and Result.IsEmpty then
    Result := nil;
end;

function TdmMemoria.IdFilaCatalogo: Integer;
begin
  Result := 0;
  if FilaCatalogo <> nil then
    Result := FilaCatalogo.FieldByName(CAMPO_ID_CATALOGO).AsInteger;
end;

function TdmMemoria.NombreFilaCatalogo: string;
begin
  Result := '';
  if FilaCatalogo <> nil then
    Result := FilaCatalogo.FieldByName(CAMPO_NOMBRE_CATALOGO).AsString;
end;

procedure TdmMemoria.SinTodasLasCategorias(const ASin: Boolean);
begin
  mtCategorias.Filter := FILTRO_CATEGORIAS;
  mtCategorias.Filtered := ASin;
end;

procedure TdmMemoria.SoloExcepciones(const ASolo: Boolean);
begin
  mtPermisosUsuario.Filter := FILTRO_EXCEPCIONES;
  mtPermisosUsuario.Filtered := ASolo;
end;

procedure TdmMemoria.PrepararImportacion(const AConUnidad, AConCategoria,
  AConPrecio: Boolean; const ARotuloCosto: string);
begin
  mtImportacionUNIDAD.Visible := AConUnidad;
  mtImportacionCATEGORIA.Visible := AConCategoria;
  mtImportacionPRECIO.Visible := AConPrecio;
  mtImportacionCOSTO.DisplayLabel := ARotuloCosto;
end;

procedure TdmMemoria.SoloErroresImportacion(const ASolo: Boolean);
begin
  mtImportacion.Filter := FILTRO_ERRORES_IMPORTACION;
  mtImportacion.Filtered := ASolo;
end;

function TdmMemoria.PermisoSinGuardar: Boolean;
begin
  Result := mtPermisosUsuarioORIGEN.AsString = ORIGEN_SIN_GUARDAR;
end;

procedure TdmMemoria.Preparar(const ATabla: TFDMemTable);
begin
  ATabla.Close;
  ATabla.CreateDataSet;
  ATabla.Append;
end;

procedure TdmMemoria.PrepararConsentimientoNuevo;
begin
  mtConsentimientoNuevo.Close;
  mtConsentimientoNuevo.CreateDataSet;
  mtConsentimientoNuevo.Append;
end;

procedure TdmMemoria.PrepararUsuario;
begin
  mtUsuario.Close;
  mtUsuario.CreateDataSet;
  mtUsuario.Append;
end;

procedure TdmMemoria.PrepararParametros(const AMinutosAvisos: Integer);
begin
  mtParametros.Close;
  mtParametros.CreateDataSet;
  mtParametros.Append;
  mtParametrosMINUTOS_AVISOS.AsInteger := AMinutosAvisos;
  mtParametros.Post;
end;

procedure TdmMemoria.FijarDiasSinRespuesta(const ADias: Integer);
begin
  if not mtParametros.Active then
    PrepararParametros(0);
  mtParametros.Edit;
  mtParametrosDIAS_SIN_RESPUESTA.AsInteger := ADias;
  mtParametros.Post;
end;

procedure TdmMemoria.PrepararContactoNuevo(const AClienteId: Integer);
begin
  mtContactoNuevo.Close;
  mtContactoNuevo.CreateDataSet;
  mtContactoNuevo.Append;
  mtContactoNuevoUUID_LOCAL.AsString := NuevoUuid;
  mtContactoNuevoCLIENTE_ID.AsInteger := AClienteId;
  mtContactoNuevoACTIVO.AsBoolean := True;
  mtContactoNuevoANONIMIZADO.AsBoolean := False;
  mtContactoNuevoPRINCIPAL.AsBoolean := False;
  mtContactoNuevoCONSENTIMIENTO_ESTADO.AsString := CONSENTIMIENTO_PENDIENTE;
end;

end.
