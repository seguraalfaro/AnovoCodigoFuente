object dmMemoria: TdmMemoria
  OldCreateOrder = True
  Height = 484
  Width = 1033
  object mtClientes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 48
    Top = 24
    object mtClientesID: TIntegerField
      FieldName = 'ID'
    end
    object mtClientesIDENTIFICACION: TStringField
      FieldName = 'IDENTIFICACION'
      Size = 30
    end
    object mtClientesNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtClientesTELEFONO: TStringField
      FieldName = 'TELEFONO'
      Size = 30
    end
    object mtClientesCORREO: TStringField
      FieldName = 'CORREO'
      Size = 150
    end
    object mtClientesCONSENTIMIENTO: TStringField
      FieldName = 'CONSENTIMIENTO'
    end
    object mtClientesACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtClienteDetalle: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 184
    Top = 24
    object mtClienteDetalleID: TIntegerField
      FieldName = 'ID'
    end
    object mtClienteDetalleUUID_LOCAL: TStringField
      FieldName = 'UUID_LOCAL'
      Size = 36
    end
    object mtClienteDetalleNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtClienteDetalleIDENTIFICACION: TStringField
      FieldName = 'IDENTIFICACION'
      Size = 30
    end
    object mtClienteDetalleTIPO_IDENTIFICACION: TSmallintField
      FieldName = 'TIPO_IDENTIFICACION'
    end
    object mtClienteDetalleCONTACTO: TStringField
      FieldName = 'CONTACTO'
      Size = 120
    end
    object mtClienteDetalleTELEFONO: TStringField
      FieldName = 'TELEFONO'
      Size = 30
    end
    object mtClienteDetalleCORREO: TStringField
      FieldName = 'CORREO'
      Size = 150
    end
    object mtClienteDetalleDIRECCION: TStringField
      FieldName = 'DIRECCION'
      Size = 500
    end
    object mtClienteDetalleLATITUD: TFloatField
      FieldName = 'LATITUD'
      DisplayFormat = '#,##0.00'
    end
    object mtClienteDetalleLONGITUD: TFloatField
      FieldName = 'LONGITUD'
      DisplayFormat = '#,##0.00'
    end
    object mtClienteDetalleACTIVO: TBooleanField
      FieldName = 'ACTIVO'
    end
    object mtClienteDetalleEXONERADO: TBooleanField
      FieldName = 'EXONERADO'
    end
    object mtClienteDetalleCODIGO_EXONERACION: TStringField
      FieldName = 'CODIGO_EXONERACION'
      Size = 50
    end
    object mtClienteDetalleCONSENTIMIENTO_ESTADO: TStringField
      FieldName = 'CONSENTIMIENTO_ESTADO'
    end
    object mtClienteDetalleCONSENTIMIENTO_FECHA: TDateTimeField
      FieldName = 'CONSENTIMIENTO_FECHA'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
    object mtClienteDetalleCONSENTIMIENTO_VERSION: TStringField
      FieldName = 'CONSENTIMIENTO_VERSION'
    end
    object mtClienteDetalleOBJVERSION: TIntegerField
      FieldName = 'OBJVERSION'
    end
  end
  object mtContactos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 288
    Top = 24
    object mtContactosID: TIntegerField
      FieldName = 'ID'
    end
    object mtContactosNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtContactosCARGO: TStringField
      FieldName = 'CARGO'
      Size = 60
    end
    object mtContactosTELEFONO: TStringField
      FieldName = 'TELEFONO'
      Size = 30
    end
    object mtContactosCORREO: TStringField
      FieldName = 'CORREO'
      Size = 150
    end
    object mtContactosPRINCIPAL: TStringField
      FieldName = 'PRINCIPAL'
      Size = 15
    end
    object mtContactosACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtConsentimientos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 408
    Top = 24
    object mtConsentimientosMOMENTO: TDateTimeField
      FieldName = 'MOMENTO'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
    object mtConsentimientosACCION: TStringField
      FieldName = 'ACCION'
      Size = 40
    end
    object mtConsentimientosVERSION: TStringField
      FieldName = 'VERSION'
    end
    object mtConsentimientosUSUARIO: TStringField
      FieldName = 'USUARIO'
      Size = 60
    end
  end
  object mtClienteCotizaciones: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 528
    Top = 24
    object mtClienteCotizacionesID: TIntegerField
      FieldName = 'ID'
    end
    object mtClienteCotizacionesCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtClienteCotizacionesTIPO: TStringField
      FieldName = 'TIPO'
      Size = 60
    end
    object mtClienteCotizacionesFECHA: TDateField
      FieldName = 'FECHA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtClienteCotizacionesASESOR: TStringField
      FieldName = 'ASESOR'
      Size = 80
    end
    object mtClienteCotizacionesMONTO: TCurrencyField
      FieldName = 'MONTO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtClienteCotizacionesESTADO: TStringField
      FieldName = 'ESTADO'
    end
  end
  object mtSolicitudes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 648
    Top = 24
    object mtSolicitudesID: TIntegerField
      FieldName = 'ID'
    end
    object mtSolicitudesCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtSolicitudesCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 120
    end
    object mtSolicitudesASESOR: TStringField
      FieldName = 'ASESOR'
      Size = 80
    end
    object mtSolicitudesRECIBIDA: TDateTimeField
      FieldName = 'RECIBIDA'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
    object mtSolicitudesFOTOS: TIntegerField
      FieldName = 'FOTOS'
    end
    object mtSolicitudesCROQUIS: TStringField
      FieldName = 'CROQUIS'
      Size = 10
    end
    object mtSolicitudesESTADO: TStringField
      FieldName = 'ESTADO'
    end
    object mtSolicitudesACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtPorCotizar: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 48
    Top = 88
    object mtPorCotizarID: TIntegerField
      FieldName = 'ID'
    end
    object mtPorCotizarCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtPorCotizarCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 120
    end
    object mtPorCotizarFECHA: TDateField
      FieldName = 'FECHA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtPorCotizarASESOR: TStringField
      FieldName = 'ASESOR'
      Size = 80
    end
    object mtPorCotizarESTADO: TStringField
      FieldName = 'ESTADO'
    end
    object mtPorCotizarACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtPorAprobar: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 168
    Top = 88
    object mtPorAprobarID: TIntegerField
      FieldName = 'ID'
    end
    object mtPorAprobarCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtPorAprobarCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 120
    end
    object mtPorAprobarFECHA: TDateField
      FieldName = 'FECHA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtPorAprobarASESOR: TStringField
      FieldName = 'ASESOR'
      Size = 80
    end
    object mtPorAprobarMONTO: TCurrencyField
      FieldName = 'MONTO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtPorAprobarESTADO: TStringField
      FieldName = 'ESTADO'
    end
    object mtPorAprobarACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtCotizaciones: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 288
    Top = 88
    object mtCotizacionesID: TIntegerField
      FieldName = 'ID'
    end
    object mtCotizacionesCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtCotizacionesCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 120
    end
    object mtCotizacionesFECHA: TDateField
      FieldName = 'FECHA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtCotizacionesASESOR: TStringField
      FieldName = 'ASESOR'
      Size = 80
    end
    object mtCotizacionesMONTO: TCurrencyField
      FieldName = 'MONTO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtCotizacionesESTADO: TStringField
      FieldName = 'ESTADO'
    end
    object mtCotizacionesACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtCotizacionLineas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 408
    Top = 88
    object mtCotizacionLineasID: TIntegerField
      FieldName = 'ID'
    end
    object mtCotizacionLineasCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtCotizacionLineasDESCRIPCION: TStringField
      FieldName = 'DESCRIPCION'
      Size = 120
    end
    object mtCotizacionLineasUNIDAD: TStringField
      FieldName = 'UNIDAD'
      Size = 15
    end
    object mtCotizacionLineasCANTIDAD: TFloatField
      FieldName = 'CANTIDAD'
      DisplayFormat = '#,##0.00'
    end
    object mtCotizacionLineasPRECIO: TCurrencyField
      FieldName = 'PRECIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtCotizacionLineasSUBTOTAL: TCurrencyField
      FieldName = 'SUBTOTAL'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtCotizacionLineasACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtRecientes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 528
    Top = 88
    object mtRecientesID: TIntegerField
      FieldName = 'ID'
    end
    object mtRecientesCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtRecientesCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 120
    end
    object mtRecientesFECHA: TDateField
      FieldName = 'FECHA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtRecientesMONTO: TCurrencyField
      FieldName = 'MONTO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtRecientesESTADO: TStringField
      FieldName = 'ESTADO'
    end
  end
  object mtGerenciaPendientes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 648
    Top = 88
    object mtGerenciaPendientesID: TIntegerField
      FieldName = 'ID'
    end
    object mtGerenciaPendientesCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtGerenciaPendientesCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 120
    end
    object mtGerenciaPendientesFECHA: TDateField
      FieldName = 'FECHA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtGerenciaPendientesASESOR: TStringField
      FieldName = 'ASESOR'
      Size = 80
    end
    object mtGerenciaPendientesMONTO: TCurrencyField
      FieldName = 'MONTO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtGerenciaPendientesESTADO: TStringField
      FieldName = 'ESTADO'
    end
    object mtGerenciaPendientesACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtGerenciaRecientes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 48
    Top = 152
    object mtGerenciaRecientesID: TIntegerField
      FieldName = 'ID'
    end
    object mtGerenciaRecientesCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtGerenciaRecientesCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 120
    end
    object mtGerenciaRecientesFECHA: TDateField
      FieldName = 'FECHA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtGerenciaRecientesASESOR: TStringField
      FieldName = 'ASESOR'
      Size = 80
    end
    object mtGerenciaRecientesMONTO: TCurrencyField
      FieldName = 'MONTO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtGerenciaRecientesESTADO: TStringField
      FieldName = 'ESTADO'
    end
    object mtGerenciaRecientesACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtMateriales: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 168
    Top = 152
    object mtMaterialesID: TIntegerField
      FieldName = 'ID'
    end
    object mtMaterialesCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtMaterialesDESCRIPCION: TStringField
      FieldName = 'DESCRIPCION'
      Size = 120
    end
    object mtMaterialesUNIDAD: TStringField
      FieldName = 'UNIDAD'
      Size = 15
    end
    object mtMaterialesPRECIO: TCurrencyField
      FieldName = 'PRECIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtMaterialesVIGENTE: TDateField
      FieldName = 'VIGENTE'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtMaterialesESTADO: TStringField
      FieldName = 'ESTADO'
      Size = 15
    end
    object mtMaterialesACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtManoObra: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 288
    Top = 152
    object mtManoObraID: TIntegerField
      FieldName = 'ID'
    end
    object mtManoObraCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtManoObraDESCRIPCION: TStringField
      FieldName = 'DESCRIPCION'
      Size = 120
    end
    object mtManoObraUNIDAD: TStringField
      FieldName = 'UNIDAD'
      Size = 15
    end
    object mtManoObraTARIFA: TCurrencyField
      FieldName = 'TARIFA'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtManoObraVIGENTE: TDateField
      FieldName = 'VIGENTE'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtManoObraESTADO: TStringField
      FieldName = 'ESTADO'
      Size = 15
    end
    object mtManoObraACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtMaquinas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 408
    Top = 152
    object mtMaquinasID: TIntegerField
      FieldName = 'ID'
    end
    object mtMaquinasCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtMaquinasDESCRIPCION: TStringField
      FieldName = 'DESCRIPCION'
      Size = 120
    end
    object mtMaquinasUNIDAD: TStringField
      FieldName = 'UNIDAD'
      Size = 15
    end
    object mtMaquinasTARIFA: TCurrencyField
      FieldName = 'TARIFA'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtMaquinasVIGENTE: TDateField
      FieldName = 'VIGENTE'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtMaquinasESTADO: TStringField
      FieldName = 'ESTADO'
      Size = 15
    end
    object mtMaquinasACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtTiposTrabajo: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 528
    Top = 152
    object mtTiposTrabajoID: TIntegerField
      FieldName = 'ID'
    end
    object mtTiposTrabajoCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtTiposTrabajoDESCRIPCION: TStringField
      FieldName = 'DESCRIPCION'
      Size = 120
    end
    object mtTiposTrabajoMARGEN: TFloatField
      FieldName = 'MARGEN'
      DisplayFormat = '#,##0.00'
    end
    object mtTiposTrabajoESTADO: TStringField
      FieldName = 'ESTADO'
      Size = 15
    end
    object mtTiposTrabajoACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtHistorialPrecios: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 648
    Top = 152
    object mtHistorialPreciosVIGENTE: TDateField
      FieldName = 'VIGENTE'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtHistorialPreciosPRECIO: TCurrencyField
      FieldName = 'PRECIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtHistorialPreciosVARIACION: TStringField
      FieldName = 'VARIACION'
      Size = 15
    end
    object mtHistorialPreciosUSUARIO: TStringField
      FieldName = 'USUARIO'
      Size = 60
    end
    object mtHistorialPreciosREGISTRADO: TDateTimeField
      FieldName = 'REGISTRADO'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
  end
  object mtFotos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 48
    Top = 216
    object mtFotosID: TIntegerField
      FieldName = 'ID'
    end
    object mtFotosARCHIVO: TStringField
      FieldName = 'ARCHIVO'
      Size = 180
    end
    object mtFotosTOMADA: TDateTimeField
      FieldName = 'TOMADA'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
    object mtFotosACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtUsuarios: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 168
    Top = 216
    object mtUsuariosID: TIntegerField
      FieldName = 'ID'
    end
    object mtUsuariosUSUARIO: TStringField
      FieldName = 'USUARIO'
      Size = 30
    end
    object mtUsuariosNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtUsuariosCORREO: TStringField
      FieldName = 'CORREO'
      Size = 150
    end
    object mtUsuariosROL: TStringField
      FieldName = 'ROL'
    end
    object mtUsuariosULTIMO_ACCESO: TDateTimeField
      FieldName = 'ULTIMO_ACCESO'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
    object mtUsuariosESTADO: TStringField
      FieldName = 'ESTADO'
      Size = 15
    end
    object mtUsuariosACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtRoles: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 288
    Top = 216
    object mtRolesID: TIntegerField
      FieldName = 'ID'
    end
    object mtRolesROL: TStringField
      FieldName = 'ROL'
    end
    object mtRolesDESCRIPCION: TStringField
      FieldName = 'DESCRIPCION'
      Size = 140
    end
    object mtRolesUSUARIOS: TIntegerField
      FieldName = 'USUARIOS'
    end
    object mtRolesPERMISOS: TIntegerField
      FieldName = 'PERMISOS'
    end
    object mtRolesESTADO: TStringField
      FieldName = 'ESTADO'
      Size = 15
    end
    object mtRolesACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtPermisos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 408
    Top = 216
    object mtPermisosID: TIntegerField
      FieldName = 'ID'
    end
    object mtPermisosCODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 50
    end
    object mtPermisosNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtPermisosMODULO: TStringField
      FieldName = 'MODULO'
      Size = 30
    end
    object mtPermisosOTORGADO: TBooleanField
      FieldName = 'OTORGADO'
    end
  end
  object mtAuditoria: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 528
    Top = 216
    object mtAuditoriaMOMENTO: TDateTimeField
      FieldName = 'MOMENTO'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
    object mtAuditoriaUSUARIO: TStringField
      FieldName = 'USUARIO'
      Size = 60
    end
    object mtAuditoriaACCION: TStringField
      FieldName = 'ACCION'
      Size = 40
    end
    object mtAuditoriaENTIDAD: TStringField
      FieldName = 'ENTIDAD'
      Size = 40
    end
    object mtAuditoriaREFERENCIA: TStringField
      FieldName = 'REFERENCIA'
      Size = 30
    end
    object mtAuditoriaORIGEN: TStringField
      FieldName = 'ORIGEN'
      Size = 30
    end
    object mtAuditoriaACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object dsClientes: TDataSource
    AutoEdit = False
    DataSet = mtClientes
    Left = 104
    Top = 24
  end
end
