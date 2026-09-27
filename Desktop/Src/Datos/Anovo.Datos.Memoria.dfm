object dmMemoria: TdmMemoria
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 518
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
    object mtClientesCONSENTIMIENTO_ESTADO: TStringField
      FieldName = 'CONSENTIMIENTO_ESTADO'
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
    Left = 128
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
    object mtClienteDetalleTIPO_IDENTIFICACION_TEXTO: TStringField
      DisplayLabel = 'Tipo de identificaci'#243'n'
      FieldKind = fkLookup
      FieldName = 'TIPO_IDENTIFICACION_TEXTO'
      LookupDataSet = mtTiposIdentificacion
      LookupKeyFields = 'ID'
      LookupResultField = 'NOMBRE'
      KeyFields = 'TIPO_IDENTIFICACION'
      Lookup = True
    end
    object mtClienteDetalleCONTACTO: TStringField
      FieldName = 'CONTACTO'
      Size = 120
    end
    object mtClienteDetalleTELEFONO: TStringField
      FieldName = 'TELEFONO'
      EditMask = '0000-0000;1;_'
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
    Left = 200
    Top = 24
    object mtContactosID: TIntegerField
      FieldName = 'ID'
    end
    object mtContactosNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtContactosAREA: TStringField
      FieldName = 'AREA'
      Size = 60
    end
    object mtContactosTELEFONO: TStringField
      FieldName = 'TELEFONO'
      EditMask = '0000-0000;1;_'
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
    Left = 280
    Top = 24
    object mtConsentimientosFECHA: TDateTimeField
      FieldName = 'FECHA'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
    object mtConsentimientosACCION: TStringField
      FieldName = 'ACCION'
      Size = 40
    end
    object mtConsentimientosVERSION_TEXTO: TStringField
      FieldName = 'VERSION_TEXTO'
    end
    object mtConsentimientosFIRMANTE_NOMBRE: TStringField
      FieldName = 'FIRMANTE_NOMBRE'
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
    Left = 704
    Top = 24
    object mtClienteCotizacionesID: TIntegerField
      FieldName = 'ID'
    end
    object mtClienteCotizacionesNUMERO: TStringField
      FieldName = 'NUMERO'
    end
    object mtClienteCotizacionesTIPO: TStringField
      FieldName = 'TIPO'
      Size = 60
    end
    object mtClienteCotizacionesFECHA_ELABORACION: TDateField
      FieldName = 'FECHA_ELABORACION'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtClienteCotizacionesASESOR: TStringField
      FieldName = 'ASESOR'
      Size = 80
    end
    object mtClienteCotizacionesMONTO_TOTAL: TCurrencyField
      FieldName = 'MONTO_TOTAL'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtClienteCotizacionesESTADO: TStringField
      FieldName = 'ESTADO'
    end
    object mtClienteCotizacionesACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
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
    Left = 800
    Top = 40
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
    object mtSolicitudesFECHA_RECEPCION: TDateTimeField
      FieldName = 'FECHA_RECEPCION'
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
    Left = 32
    Top = 312
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
    object mtPorCotizarFECHA_RECEPCION: TDateField
      FieldName = 'FECHA_RECEPCION'
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
    Left = 152
    Top = 312
    object mtPorAprobarID: TIntegerField
      FieldName = 'ID'
    end
    object mtPorAprobarNUMERO: TStringField
      FieldName = 'NUMERO'
    end
    object mtPorAprobarCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 120
    end
    object mtPorAprobarFECHA_ELABORACION: TDateField
      FieldName = 'FECHA_ELABORACION'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtPorAprobarASESOR: TStringField
      FieldName = 'ASESOR'
      Size = 80
    end
    object mtPorAprobarMONTO_TOTAL: TCurrencyField
      FieldName = 'MONTO_TOTAL'
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
    Left = 272
    Top = 312
    object mtCotizacionesID: TIntegerField
      FieldName = 'ID'
    end
    object mtCotizacionesNUMERO: TStringField
      FieldName = 'NUMERO'
    end
    object mtCotizacionesCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 120
    end
    object mtCotizacionesFECHA_ELABORACION: TDateField
      FieldName = 'FECHA_ELABORACION'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtCotizacionesASESOR: TStringField
      FieldName = 'ASESOR'
      Size = 80
    end
    object mtCotizacionesMONTO_TOTAL: TCurrencyField
      FieldName = 'MONTO_TOTAL'
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
    Left = 392
    Top = 312
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
    object mtCotizacionLineasUNIDAD_MEDIDA: TStringField
      FieldName = 'UNIDAD_MEDIDA'
      Size = 15
    end
    object mtCotizacionLineasCANTIDAD: TFloatField
      FieldName = 'CANTIDAD'
      DisplayFormat = '#,##0.00'
    end
    object mtCotizacionLineasPRECIO_UNITARIO: TCurrencyField
      FieldName = 'PRECIO_UNITARIO'
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
    Left = 512
    Top = 312
    object mtRecientesID: TIntegerField
      FieldName = 'ID'
    end
    object mtRecientesNUMERO: TStringField
      FieldName = 'NUMERO'
    end
    object mtRecientesCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 120
    end
    object mtRecientesFECHA_ELABORACION: TDateField
      FieldName = 'FECHA_ELABORACION'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtRecientesMONTO_TOTAL: TCurrencyField
      FieldName = 'MONTO_TOTAL'
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
    Left = 632
    Top = 312
    object mtGerenciaPendientesID: TIntegerField
      FieldName = 'ID'
    end
    object mtGerenciaPendientesNUMERO: TStringField
      FieldName = 'NUMERO'
    end
    object mtGerenciaPendientesCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 120
    end
    object mtGerenciaPendientesFECHA_ELABORACION: TDateField
      FieldName = 'FECHA_ELABORACION'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtGerenciaPendientesASESOR: TStringField
      FieldName = 'ASESOR'
      Size = 80
    end
    object mtGerenciaPendientesMONTO_TOTAL: TCurrencyField
      FieldName = 'MONTO_TOTAL'
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
    Left = 32
    Top = 376
    object mtGerenciaRecientesID: TIntegerField
      FieldName = 'ID'
    end
    object mtGerenciaRecientesNUMERO: TStringField
      FieldName = 'NUMERO'
    end
    object mtGerenciaRecientesCLIENTE: TStringField
      FieldName = 'CLIENTE'
      Size = 120
    end
    object mtGerenciaRecientesFECHA_ELABORACION: TDateField
      FieldName = 'FECHA_ELABORACION'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtGerenciaRecientesASESOR: TStringField
      FieldName = 'ASESOR'
      Size = 80
    end
    object mtGerenciaRecientesMONTO_TOTAL: TCurrencyField
      FieldName = 'MONTO_TOTAL'
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
    Left = 152
    Top = 376
    object mtMaterialesID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtMaterialesCODIGO: TStringField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'CODIGO'
      Size = 30
    end
    object mtMaterialesNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtMaterialesDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION'
      Visible = False
      Size = 500
    end
    object mtMaterialesUNIDAD_MEDIDA: TStringField
      DisplayLabel = 'Unidad'
      FieldName = 'UNIDAD_MEDIDA'
      Size = 20
    end
    object mtMaterialesCOSTO_UNITARIO: TCurrencyField
      DisplayLabel = 'Costo'
      FieldName = 'COSTO_UNITARIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtMaterialesPRECIO_UNITARIO: TCurrencyField
      DisplayLabel = 'Precio'
      FieldName = 'PRECIO_UNITARIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtMaterialesFECHA_VIGENCIA: TDateField
      DisplayLabel = 'Vigente desde'
      FieldName = 'FECHA_VIGENCIA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtMaterialesPROGRAMADO_FECHA: TDateField
      DisplayLabel = 'Programado'
      FieldName = 'PROGRAMADO_FECHA'
      Visible = False
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtMaterialesACTIVO: TBooleanField
      FieldName = 'ACTIVO'
      Visible = False
    end
    object mtMaterialesESTADO: TStringField
      DisplayLabel = 'Estado'
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
    Left = 256
    Top = 376
    object mtManoObraID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtManoObraCODIGO: TStringField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'CODIGO'
      Size = 30
    end
    object mtManoObraCATEGORIA_ID: TIntegerField
      FieldName = 'CATEGORIA_ID'
      Visible = False
    end
    object mtManoObraNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtManoObraCATEGORIA_NOMBRE: TStringField
      DisplayLabel = 'Categor'#237'a'
      FieldName = 'CATEGORIA_NOMBRE'
      Size = 120
    end
    object mtManoObraDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION'
      Visible = False
      Size = 500
    end
    object mtManoObraUNIDAD_MEDIDA: TStringField
      DisplayLabel = 'Unidad'
      FieldName = 'UNIDAD_MEDIDA'
      Size = 20
    end
    object mtManoObraCOSTO_UNITARIO: TCurrencyField
      DisplayLabel = 'Costo'
      FieldName = 'COSTO_UNITARIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtManoObraFECHA_VIGENCIA: TDateField
      DisplayLabel = 'Vigente desde'
      FieldName = 'FECHA_VIGENCIA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtManoObraPROGRAMADO_FECHA: TDateField
      DisplayLabel = 'Programado'
      FieldName = 'PROGRAMADO_FECHA'
      Visible = False
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtManoObraACTIVO: TBooleanField
      FieldName = 'ACTIVO'
      Visible = False
    end
    object mtManoObraESTADO: TStringField
      DisplayLabel = 'Estado'
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
    Left = 360
    Top = 376
    object mtMaquinasID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtMaquinasCODIGO: TStringField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'CODIGO'
      Size = 30
    end
    object mtMaquinasNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtMaquinasDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION'
      Size = 500
    end
    object mtMaquinasCOSTO_HORA: TCurrencyField
      DisplayLabel = 'Costo por hora'
      FieldName = 'COSTO_HORA'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtMaquinasFECHA_VIGENCIA: TDateField
      DisplayLabel = 'Vigente desde'
      FieldName = 'FECHA_VIGENCIA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtMaquinasPROGRAMADO_FECHA: TDateField
      DisplayLabel = 'Programado'
      FieldName = 'PROGRAMADO_FECHA'
      Visible = False
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtMaquinasACTIVO: TBooleanField
      FieldName = 'ACTIVO'
      Visible = False
    end
    object mtMaquinasESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldName = 'ESTADO'
      Size = 15
    end
    object mtMaquinasACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtTodos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 360
    Top = 440
    object mtTodosTIPO: TStringField
      DisplayLabel = 'Tipo'
      FieldName = 'TIPO'
      Size = 10
    end
    object mtTodosID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtTodosCODIGO: TStringField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'CODIGO'
      Size = 30
    end
    object mtTodosNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtTodosDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION'
      Visible = False
      Size = 500
    end
    object mtTodosUNIDAD_MEDIDA: TStringField
      DisplayLabel = 'Unidad'
      FieldName = 'UNIDAD_MEDIDA'
    end
    object mtTodosCATEGORIA_ID: TIntegerField
      FieldName = 'CATEGORIA_ID'
      Visible = False
    end
    object mtTodosCOSTO_UNITARIO: TCurrencyField
      FieldName = 'COSTO_UNITARIO'
      Visible = False
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtTodosCOSTO: TCurrencyField
      DisplayLabel = 'Costo'
      FieldName = 'COSTO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtTodosPRECIO_UNITARIO: TCurrencyField
      DisplayLabel = 'P. venta'
      FieldName = 'PRECIO_UNITARIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtTodosCOSTO_HORA: TCurrencyField
      FieldName = 'COSTO_HORA'
      Visible = False
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtTodosFECHA_VIGENCIA: TDateField
      DisplayLabel = 'Vigente desde'
      FieldName = 'FECHA_VIGENCIA'
      Visible = False
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtTodosPROGRAMADO_FECHA: TDateField
      DisplayLabel = 'Programado'
      FieldName = 'PROGRAMADO_FECHA'
      Visible = False
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtTodosACTIVO: TBooleanField
      FieldName = 'ACTIVO'
      Visible = False
    end
    object mtTodosESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldName = 'ESTADO'
      Size = 15
    end
    object mtTodosACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtDashboardAsesor: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 360
    Top = 504
    object mtDashboardAsesorID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtDashboardAsesorCOTIZACION_ID: TIntegerField
      FieldName = 'COTIZACION_ID'
      Visible = False
    end
    object mtDashboardAsesorFECHA_CAPTURA: TDateTimeField
      DisplayLabel = 'Fecha'
      FieldName = 'FECHA_CAPTURA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtDashboardAsesorCLIENTE_NOMBRE: TStringField
      DisplayLabel = 'Cliente'
      FieldName = 'CLIENTE_NOMBRE'
      Size = 120
    end
    object mtDashboardAsesorDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION'
      Size = 500
    end
    object mtDashboardAsesorESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldName = 'ESTADO'
    end
    object mtDashboardAsesorMONTO_APROBADO: TCurrencyField
      DisplayLabel = 'Monto aprobado'
      FieldName = 'MONTO_APROBADO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
  end
  object dsDashboardAsesor: TDataSource
    DataSet = mtDashboardAsesor
    Left = 464
    Top = 504
  end
  object mtSeguimiento: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 360
    Top = 568
    object mtSeguimientoID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtSeguimientoCOTIZACION_ID: TIntegerField
      FieldName = 'COTIZACION_ID'
      Visible = False
    end
    object mtSeguimientoFECHA_CAPTURA: TDateTimeField
      DisplayLabel = 'Fecha'
      FieldName = 'FECHA_CAPTURA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtSeguimientoCLIENTE_NOMBRE: TStringField
      DisplayLabel = 'Cliente'
      FieldName = 'CLIENTE_NOMBRE'
      Size = 120
    end
    object mtSeguimientoDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION'
      Size = 500
    end
    object mtSeguimientoESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldName = 'ESTADO'
    end
    object mtSeguimientoMONTO_APROBADO: TCurrencyField
      DisplayLabel = 'Monto aprobado'
      FieldName = 'MONTO_APROBADO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
  end
  object dsSeguimiento: TDataSource
    DataSet = mtSeguimiento
    Left = 464
    Top = 568
  end
  object mtTiposTrabajo: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 464
    Top = 376
    object mtTiposTrabajoID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtTiposTrabajoNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtTiposTrabajoACTIVO: TBooleanField
      FieldName = 'ACTIVO'
      Visible = False
    end
    object mtTiposTrabajoESTADO: TStringField
      DisplayLabel = 'Estado'
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
    Left = 632
    Top = 376
    object mtHistorialPreciosFECHA_VIGENCIA: TDateField
      FieldName = 'FECHA_VIGENCIA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtHistorialPreciosPRECIO_UNITARIO: TCurrencyField
      FieldName = 'PRECIO_UNITARIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtHistorialPreciosVARIACION: TStringField
      FieldName = 'VARIACION'
      Size = 15
    end
    object mtHistorialPreciosMODIFICADO_POR: TStringField
      FieldName = 'MODIFICADO_POR'
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
    Left = 32
    Top = 440
    object mtFotosID: TIntegerField
      FieldName = 'ID'
    end
    object mtFotosNOMBRE_ARCHIVO: TStringField
      FieldName = 'NOMBRE_ARCHIVO'
      Size = 180
    end
    object mtFotosFECHA_CREACION: TDateTimeField
      FieldName = 'FECHA_CREACION'
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
    Left = 152
    Top = 440
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
    object mtUsuariosACTIVO: TStringField
      FieldName = 'ACTIVO'
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
    Left = 272
    Top = 440
    object mtRolesID: TIntegerField
      FieldName = 'ID'
    end
    object mtRolesCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object mtRolesNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 140
    end
    object mtRolesUSUARIOS: TIntegerField
      FieldName = 'USUARIOS'
    end
    object mtRolesPERMISOS: TIntegerField
      FieldName = 'PERMISOS'
    end
    object mtRolesACTIVO: TStringField
      FieldName = 'ACTIVO'
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
    Left = 392
    Top = 440
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
    Left = 512
    Top = 440
    object mtAuditoriaID: TIntegerField
      FieldName = 'ID'
    end
    object mtAuditoriaFECHA: TDateTimeField
      DisplayLabel = 'Fecha'
      FieldName = 'FECHA'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
    object mtAuditoriaUSUARIO: TStringField
      DisplayLabel = 'Usuario'
      FieldName = 'USUARIO'
      Size = 120
    end
    object mtAuditoriaACCION: TStringField
      DisplayLabel = 'Acción'
      FieldName = 'ACCION'
      Size = 50
    end
    object mtAuditoriaENTIDAD: TStringField
      DisplayLabel = 'Entidad'
      FieldName = 'ENTIDAD'
      Size = 50
    end
    object mtAuditoriaENTIDAD_ID: TIntegerField
      DisplayLabel = 'Nº'
      FieldName = 'ENTIDAD_ID'
    end
    object mtAuditoriaDETALLE: TStringField
      DisplayLabel = 'Detalle'
      FieldName = 'DETALLE'
      Size = 500
    end
  end
  object mtTiposIdentificacion: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 600
    Top = 24
    object mtTiposIdentificacionID: TSmallintField
      FieldName = 'ID'
    end
    object mtTiposIdentificacionNOMBRE: TStringField
      FieldName = 'NOMBRE'
    end
  end
  object dsTiposIdentificacion: TDataSource
    AutoEdit = False
    DataSet = mtTiposIdentificacion
    Left = 600
    Top = 80
  end
  object mtItemCatalogo: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 568
    Top = 376
    object mtItemCatalogoCODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 30
    end
    object mtItemCatalogoNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtItemCatalogoDESCRIPCION: TStringField
      FieldName = 'DESCRIPCION'
      Size = 500
    end
    object mtItemCatalogoUNIDAD_MEDIDA: TStringField
      FieldName = 'UNIDAD_MEDIDA'
      Size = 20
    end
  end
  object mtPrecioCatalogo: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 568
    Top = 440
    object mtPrecioCatalogoCOSTO_UNITARIO: TCurrencyField
      FieldName = 'COSTO_UNITARIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtPrecioCatalogoPRECIO_UNITARIO: TCurrencyField
      FieldName = 'PRECIO_UNITARIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtPrecioCatalogoCOSTO_HORA: TCurrencyField
      FieldName = 'COSTO_HORA'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtPrecioCatalogoFECHA_VIGENCIA: TDateField
      FieldName = 'FECHA_VIGENCIA'
      DisplayFormat = 'dd/mm/yyyy'
    end
  end
  object mtHistorialPrecio: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 672
    Top = 376
    object mtHistorialPrecioFECHA_VIGENCIA: TDateField
      FieldName = 'FECHA_VIGENCIA'
      DisplayLabel = 'Vigente desde'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtHistorialPrecioCOSTO_UNITARIO: TCurrencyField
      FieldName = 'COSTO_UNITARIO'
      DisplayLabel = 'Costo'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtHistorialPrecioPRECIO_UNITARIO: TCurrencyField
      FieldName = 'PRECIO_UNITARIO'
      DisplayLabel = 'Precio'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtHistorialPrecioCOSTO_HORA: TCurrencyField
      FieldName = 'COSTO_HORA'
      DisplayLabel = 'Costo por hora'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtHistorialPrecioACTIVO: TBooleanField
      FieldName = 'ACTIVO'
      Visible = False
    end
    object mtHistorialPrecioESTADO: TStringField
      FieldName = 'ESTADO'
      DisplayLabel = 'Estado'
      Size = 15
    end
  end
  object mtUnidadesMedida: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 776
    Top = 376
    object mtUnidadesMedidaNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 20
    end
  end
  object dsUnidadesMedida: TDataSource
    AutoEdit = False
    DataSet = mtUnidadesMedida
    Left = 776
    Top = 440
  end
  object dsItemCatalogo: TDataSource
    DataSet = mtItemCatalogo
    Left = 568
    Top = 504
  end
  object dsPrecioCatalogo: TDataSource
    DataSet = mtPrecioCatalogo
    Left = 672
    Top = 440
  end
  object dsHistorialPrecio: TDataSource
    AutoEdit = False
    DataSet = mtHistorialPrecio
    Left = 672
    Top = 504
  end
  object dsCatalogo: TDataSource
    AutoEdit = False
    Left = 152
    Top = 440
  end
  object dsClientes: TDataSource
    AutoEdit = False
    DataSet = mtClientes
    Left = 48
    Top = 80
  end
  object dsClienteDetalle: TDataSource
    AutoEdit = False
    DataSet = mtClienteDetalle
    Left = 120
    Top = 80
  end
  object dsContactos: TDataSource
    AutoEdit = False
    DataSet = mtContactos
    Left = 200
    Top = 80
  end
  object dsConsentimientos: TDataSource
    AutoEdit = False
    DataSet = mtConsentimientos
    Left = 280
    Top = 80
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 936
    Top = 336
  end
  object mtClienteNuevo: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 384
    Top = 24
    object mtClienteNuevoUUID_LOCAL: TStringField
      FieldName = 'UUID_LOCAL'
      Size = 36
    end
    object mtClienteNuevoNOMBRE: TStringField
      DisplayLabel = 'Nombre o raz'#243'n social'
      FieldName = 'NOMBRE'
      Required = True
      Size = 120
    end
    object mtClienteNuevoIDENTIFICACION: TStringField
      DisplayLabel = 'Identificaci'#243'n'
      FieldName = 'IDENTIFICACION'
      Required = True
      Size = 30
    end
    object mtClienteNuevoTIPO_IDENTIFICACION: TSmallintField
      DisplayLabel = 'Tipo de identificaci'#243'n'
      FieldName = 'TIPO_IDENTIFICACION'
      Required = True
    end
    object mtClienteNuevoTIPO_IDENTIFICACION_TEXTO: TStringField
      DisplayLabel = 'Tipo de identificaci'#243'n'
      FieldKind = fkLookup
      FieldName = 'TIPO_IDENTIFICACION_TEXTO'
      LookupDataSet = mtTiposIdentificacion
      LookupKeyFields = 'ID'
      LookupResultField = 'NOMBRE'
      KeyFields = 'TIPO_IDENTIFICACION'
      Lookup = True
    end
    object mtClienteNuevoCONTACTO: TStringField
      FieldName = 'CONTACTO'
      Size = 120
    end
    object mtClienteNuevoTELEFONO: TStringField
      DisplayLabel = 'Tel'#233'fono'
      FieldName = 'TELEFONO'
      Required = True
      EditMask = '0000-0000;1;_'
      Size = 30
    end
    object mtClienteNuevoCORREO: TStringField
      DisplayLabel = 'Correo'
      FieldName = 'CORREO'
      Required = True
      Size = 150
    end
    object mtClienteNuevoDIRECCION: TStringField
      DisplayLabel = 'Direcci'#243'n'
      FieldName = 'DIRECCION'
      Required = True
      Size = 500
    end
    object mtClienteNuevoLATITUD: TFloatField
      FieldName = 'LATITUD'
      DisplayFormat = '0.000000'
    end
    object mtClienteNuevoLONGITUD: TFloatField
      FieldName = 'LONGITUD'
      DisplayFormat = '0.000000'
    end
    object mtClienteNuevoACTIVO: TBooleanField
      FieldName = 'ACTIVO'
    end
    object mtClienteNuevoEXONERADO: TBooleanField
      FieldName = 'EXONERADO'
    end
    object mtClienteNuevoCODIGO_EXONERACION: TStringField
      DisplayLabel = 'C'#243'digo de exoneraci'#243'n'
      FieldName = 'CODIGO_EXONERACION'
      Required = True
      Size = 30
    end
    object mtClienteNuevoCONSENTIMIENTO_ESTADO: TStringField
      FieldName = 'CONSENTIMIENTO_ESTADO'
    end
    object mtClienteNuevoCONSENTIMIENTO_FECHA: TDateTimeField
      FieldName = 'CONSENTIMIENTO_FECHA'
    end
    object mtClienteNuevoCONSENTIMIENTO_VERSION: TStringField
      FieldName = 'CONSENTIMIENTO_VERSION'
      Size = 10
    end
    object mtClienteNuevoANONIMIZADO: TBooleanField
      FieldName = 'ANONIMIZADO'
    end
  end
  object mtContactoNuevo: TFDMemTable
    BeforePost = mtContactoNuevoBeforePost
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 496
    Top = 24
    object mtContactoNuevoUUID_LOCAL: TStringField
      FieldName = 'UUID_LOCAL'
      Size = 36
    end
    object mtContactoNuevoCLIENTE_ID: TIntegerField
      FieldName = 'CLIENTE_ID'
    end
    object mtContactoNuevoNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
      Required = True
      Size = 120
    end
    object mtContactoNuevoAREA: TStringField
      DisplayLabel = #193'rea'
      FieldName = 'AREA'
      Size = 80
    end
    object mtContactoNuevoTELEFONO: TStringField
      DisplayLabel = 'Tel'#233'fono'
      FieldName = 'TELEFONO'
      Size = 30
    end
    object mtContactoNuevoCELULAR: TStringField
      DisplayLabel = 'Celular'
      FieldName = 'CELULAR'
      EditMask = '0000-0000;1;_'
      Size = 30
    end
    object mtContactoNuevoCORREO: TStringField
      DisplayLabel = 'Correo'
      FieldName = 'CORREO'
      Required = True
      Size = 150
    end
    object mtContactoNuevoPRINCIPAL: TBooleanField
      FieldName = 'PRINCIPAL'
    end
    object mtContactoNuevoCONSENTIMIENTO_ESTADO: TStringField
      FieldName = 'CONSENTIMIENTO_ESTADO'
    end
    object mtContactoNuevoANONIMIZADO: TBooleanField
      FieldName = 'ANONIMIZADO'
    end
    object mtContactoNuevoACTIVO: TBooleanField
      FieldName = 'ACTIVO'
    end
  end
  object dsClienteNuevo: TDataSource
    DataSet = mtClienteNuevo
    Left = 384
    Top = 80
  end
  object dsAuditoria: TDataSource
    AutoEdit = False
    DataSet = mtAuditoria
    Left = 512
    Top = 384
  end
  object dsContactoNuevo: TDataSource
    DataSet = mtContactoNuevo
    Left = 488
    Top = 80
  end
end
