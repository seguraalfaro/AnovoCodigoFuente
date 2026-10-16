object dmMemoria: TdmMemoria
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 809
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
    OnCalcFields = CatalogoCalcFields
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
    object mtMaterialesUNIDAD_MEDIDA_ID: TIntegerField
      FieldName = 'UNIDAD_MEDIDA_ID'
      Visible = False
    end
    object mtMaterialesUNIDAD_MEDIDA: TStringField
      DisplayLabel = 'Unidad'
      FieldName = 'UNIDAD_MEDIDA'
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
      FieldKind = fkCalculated
      FieldName = 'ESTADO'
      Size = 15
      Calculated = True
    end
    object mtMaterialesACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtManoObra: TFDMemTable
    OnCalcFields = CatalogoCalcFields
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
    object mtManoObraUNIDAD_MEDIDA_ID: TIntegerField
      FieldName = 'UNIDAD_MEDIDA_ID'
      Visible = False
    end
    object mtManoObraUNIDAD_MEDIDA: TStringField
      DisplayLabel = 'Unidad'
      FieldName = 'UNIDAD_MEDIDA'
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
      FieldKind = fkCalculated
      FieldName = 'ESTADO'
      Size = 15
      Calculated = True
    end
    object mtManoObraACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtMaquinas: TFDMemTable
    OnCalcFields = CatalogoCalcFields
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
      FieldKind = fkCalculated
      FieldName = 'ESTADO'
      Size = 15
      Calculated = True
    end
    object mtMaquinasACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtTodos: TFDMemTable
    OnCalcFields = CatalogoCalcFields
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
      OnGetText = TipoGetText
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
    object mtTodosUNIDAD_MEDIDA_ID: TIntegerField
      FieldName = 'UNIDAD_MEDIDA_ID'
      Visible = False
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
      FieldKind = fkCalculated
      FieldName = 'ESTADO'
      Size = 15
      Calculated = True
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
      OnGetText = EstadoGetText
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
  object mtDashboardAsistente: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 360
    Top = 632
    object mtDashboardAsistenteID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtDashboardAsistenteFECHA_RECEPCION: TDateTimeField
      DisplayLabel = 'Recibida'
      FieldName = 'FECHA_RECEPCION'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtDashboardAsistenteCLIENTE_NOMBRE: TStringField
      DisplayLabel = 'Cliente'
      FieldName = 'CLIENTE_NOMBRE'
      Size = 120
    end
    object mtDashboardAsistenteASESOR_NOMBRE: TStringField
      DisplayLabel = 'Asesor'
      FieldName = 'ASESOR_NOMBRE'
      Size = 120
    end
    object mtDashboardAsistenteDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION'
      Size = 500
    end
    object mtDashboardAsistenteDIAS_ESPERA: TIntegerField
      DisplayLabel = 'D'#237'as de espera'
      FieldName = 'DIAS_ESPERA'
    end
  end
  object dsDashboardAsistente: TDataSource
    DataSet = mtDashboardAsistente
    Left = 464
    Top = 632
  end
  object mtDashboardSupervisor: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 360
    Top = 696
    object mtDashboardSupervisorID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtDashboardSupervisorNUMERO: TIntegerField
      DisplayLabel = 'N'#250'mero'
      FieldName = 'NUMERO'
    end
    object mtDashboardSupervisorFECHA_MODIFICACION: TDateTimeField
      DisplayLabel = 'Presentada'
      FieldName = 'FECHA_MODIFICACION'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtDashboardSupervisorCLIENTE_NOMBRE: TStringField
      DisplayLabel = 'Cliente'
      FieldName = 'CLIENTE_NOMBRE'
      Size = 120
    end
    object mtDashboardSupervisorELABORADA_POR_NOMBRE: TStringField
      DisplayLabel = 'Elaborada por'
      FieldName = 'ELABORADA_POR_NOMBRE'
      Size = 120
    end
    object mtDashboardSupervisorMONTO_TOTAL: TCurrencyField
      DisplayLabel = 'Monto'
      FieldName = 'MONTO_TOTAL'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtDashboardSupervisorDIAS_EN_ESTADO: TIntegerField
      DisplayLabel = 'D'#237'as de espera'
      FieldName = 'DIAS_EN_ESTADO'
    end
  end
  object dsDashboardSupervisor: TDataSource
    DataSet = mtDashboardSupervisor
    Left = 464
    Top = 696
  end
  object mtDashboardGerencia: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 360
    Top = 760
    object mtDashboardGerenciaASESOR_ID: TIntegerField
      FieldName = 'ASESOR_ID'
      Visible = False
    end
    object mtDashboardGerenciaASESOR_NOMBRE: TStringField
      DisplayLabel = 'Asesor'
      FieldName = 'ASESOR_NOMBRE'
      Size = 120
    end
    object mtDashboardGerenciaSOLICITUDES_MES: TIntegerField
      DisplayLabel = 'Solicitudes'
      FieldName = 'SOLICITUDES_MES'
    end
    object mtDashboardGerenciaAPROBADAS_MES: TIntegerField
      DisplayLabel = 'Aprobadas'
      FieldName = 'APROBADAS_MES'
    end
    object mtDashboardGerenciaMONTO_APROBADO_MES: TCurrencyField
      DisplayLabel = 'Monto aprobado'
      FieldName = 'MONTO_APROBADO_MES'
      DisplayFormat = '#,##0.00'
      currency = False
    end
  end
  object dsDashboardGerencia: TDataSource
    DataSet = mtDashboardGerencia
    Left = 464
    Top = 760
  end
  object mtDashboardEstados: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 360
    Top = 824
    object mtDashboardEstadosESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldName = 'ESTADO'
      OnGetText = EstadoGetText
    end
    object mtDashboardEstadosCANTIDAD: TIntegerField
      DisplayLabel = 'Cantidad'
      FieldName = 'CANTIDAD'
    end
    object mtDashboardEstadosMONTO: TCurrencyField
      DisplayLabel = 'Monto'
      FieldName = 'MONTO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
  end
  object dsDashboardEstados: TDataSource
    DataSet = mtDashboardEstados
    Left = 464
    Top = 824
  end
  object mtDashboardCuentas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 360
    Top = 888
    object mtDashboardCuentasID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtDashboardCuentasFECHA: TDateTimeField
      DisplayLabel = 'Fecha'
      FieldName = 'FECHA'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
    object mtDashboardCuentasUSUARIO_NOMBRE: TStringField
      DisplayLabel = 'Hecho por'
      FieldName = 'USUARIO_NOMBRE'
      Size = 120
    end
    object mtDashboardCuentasACCION: TStringField
      DisplayLabel = 'Acci'#243'n'
      FieldName = 'ACCION'
      OnGetText = AccionAuditoriaGetText
      Size = 50
    end
    object mtDashboardCuentasDETALLE: TStringField
      DisplayLabel = 'Detalle'
      FieldName = 'DETALLE'
      Size = 500
    end
  end
  object dsDashboardCuentas: TDataSource
    DataSet = mtDashboardCuentas
    Left = 464
    Top = 888
  end
  object mtBandeja: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 360
    Top = 952
    object mtBandejaID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtBandejaNUMERO: TIntegerField
      DisplayLabel = 'N'#250'mero'
      FieldName = 'NUMERO'
    end
    object mtBandejaCLIENTE_NOMBRE: TStringField
      DisplayLabel = 'Cliente'
      FieldName = 'CLIENTE_NOMBRE'
      Size = 120
    end
    object mtBandejaASESOR_NOMBRE: TStringField
      DisplayLabel = 'Asesor'
      FieldName = 'ASESOR_NOMBRE'
      Size = 120
    end
    object mtBandejaELABORADA_POR_NOMBRE: TStringField
      DisplayLabel = 'Elabor'#243
      FieldName = 'ELABORADA_POR_NOMBRE'
      Size = 120
    end
    object mtBandejaDESCRIPCION_TRABAJO: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION_TRABAJO'
      Size = 500
    end
    object mtBandejaFECHA_MODIFICACION: TDateTimeField
      DisplayLabel = 'Enviada'
      FieldName = 'FECHA_MODIFICACION'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtBandejaDIAS_EN_ESTADO: TIntegerField
      DisplayLabel = 'D'#237'as'
      FieldName = 'DIAS_EN_ESTADO'
    end
    object mtBandejaMONTO_TOTAL: TCurrencyField
      DisplayLabel = 'Monto'
      FieldName = 'MONTO_TOTAL'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtBandejaACCIONES: TStringField
      DisplayLabel = 'Acciones'
      FieldName = 'ACCIONES'
    end
  end
  object dsBandeja: TDataSource
    DataSet = mtBandeja
    Left = 464
    Top = 952
  end
  object mtRevisionLineas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 360
    Top = 1016
    object mtRevisionLineasID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtRevisionLineasTIPO: TStringField
      DisplayLabel = 'Tipo'
      FieldName = 'TIPO'
      OnGetText = TipoGetText
    end
    object mtRevisionLineasDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION'
      Size = 500
    end
    object mtRevisionLineasUNIDAD_MEDIDA: TStringField
      DisplayLabel = 'Unidad'
      FieldName = 'UNIDAD_MEDIDA'
    end
    object mtRevisionLineasCANTIDAD: TCurrencyField
      DisplayLabel = 'Cantidad'
      FieldName = 'CANTIDAD'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtRevisionLineasPRECIO_UNITARIO: TCurrencyField
      DisplayLabel = 'Precio'
      FieldName = 'PRECIO_UNITARIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtRevisionLineasSUBTOTAL: TCurrencyField
      DisplayLabel = 'Subtotal'
      FieldName = 'SUBTOTAL'
      DisplayFormat = '#,##0.00'
      currency = False
    end
  end
  object dsRevisionLineas: TDataSource
    DataSet = mtRevisionLineas
    Left = 464
    Top = 1016
  end
  object mtSolicitudesCola: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 360
    Top = 1080
    object mtSolicitudesColaID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtSolicitudesColaFECHA_RECEPCION: TDateTimeField
      DisplayLabel = 'Recibida'
      FieldName = 'FECHA_RECEPCION'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtSolicitudesColaCLIENTE_NOMBRE: TStringField
      DisplayLabel = 'Cliente'
      FieldName = 'CLIENTE_NOMBRE'
      Size = 120
    end
    object mtSolicitudesColaASESOR_NOMBRE: TStringField
      DisplayLabel = 'Asesor'
      FieldName = 'ASESOR_NOMBRE'
      Size = 120
    end
    object mtSolicitudesColaDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION'
      Size = 500
    end
    object mtSolicitudesColaDIAS_ESPERA: TIntegerField
      DisplayLabel = 'D'#237'as'
      FieldName = 'DIAS_ESPERA'
    end
    object mtSolicitudesColaACCIONES: TStringField
      DisplayLabel = 'Acciones'
      FieldName = 'ACCIONES'
    end
  end
  object dsSolicitudesCola: TDataSource
    AutoEdit = False
    DataSet = mtSolicitudesCola
    Left = 360
    Top = 1136
  end
  object mtSolicitudesEnTrabajo: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 464
    Top = 1080
    object mtSolicitudesEnTrabajoID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtSolicitudesEnTrabajoSOLICITUD_ID: TIntegerField
      FieldName = 'SOLICITUD_ID'
      Visible = False
    end
    object mtSolicitudesEnTrabajoNUMERO: TIntegerField
      DisplayLabel = 'N'#250'mero'
      FieldName = 'NUMERO'
    end
    object mtSolicitudesEnTrabajoFECHA_MODIFICACION: TDateTimeField
      DisplayLabel = 'Actualizada'
      FieldName = 'FECHA_MODIFICACION'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtSolicitudesEnTrabajoCLIENTE_NOMBRE: TStringField
      DisplayLabel = 'Cliente'
      FieldName = 'CLIENTE_NOMBRE'
      Size = 120
    end
    object mtSolicitudesEnTrabajoDESCRIPCION_TRABAJO: TStringField
      DisplayLabel = 'Trabajo'
      FieldName = 'DESCRIPCION_TRABAJO'
      Size = 500
    end
    object mtSolicitudesEnTrabajoESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldName = 'ESTADO'
      OnGetText = EstadoGetText
    end
    object mtSolicitudesEnTrabajoMOTIVO_RECHAZO: TStringField
      DisplayLabel = 'Observaci'#243'n'
      FieldName = 'MOTIVO_RECHAZO'
      Size = 500
    end
    object mtSolicitudesEnTrabajoACCIONES: TStringField
      DisplayLabel = 'Acciones'
      FieldName = 'ACCIONES'
    end
  end
  object dsSolicitudesEnTrabajo: TDataSource
    AutoEdit = False
    DataSet = mtSolicitudesEnTrabajo
    Left = 464
    Top = 1136
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
      OnGetText = EstadoGetText
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
    OnCalcFields = CatalogoCalcFields
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
      FieldKind = fkCalculated
      FieldName = 'ESTADO'
      Size = 15
      Calculated = True
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
      DisplayLabel = 'Acci'#243'n'
      FieldName = 'ACCION'
      OnGetText = AccionAuditoriaGetText
      Size = 50
    end
    object mtAuditoriaENTIDAD: TStringField
      DisplayLabel = 'Entidad'
      FieldName = 'ENTIDAD'
      OnGetText = EntidadAuditoriaGetText
      Size = 50
    end
    object mtAuditoriaENTIDAD_ID: TIntegerField
      DisplayLabel = 'N'#186
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
    Left = 768
    Top = 200
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
    object mtItemCatalogoUNIDAD_MEDIDA_ID: TIntegerField
      FieldName = 'UNIDAD_MEDIDA_ID'
    end
    object mtItemCatalogoABREVIATURA: TStringField
      FieldName = 'ABREVIATURA'
      Size = 10
    end
    object mtItemCatalogoMAGNITUD: TStringField
      FieldName = 'MAGNITUD'
      Size = 10
    end
    object mtItemCatalogoCATEGORIA_ID: TIntegerField
      FieldName = 'CATEGORIA_ID'
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
    OnCalcFields = CatalogoCalcFields
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
      DisplayLabel = 'Vigente desde'
      FieldName = 'FECHA_VIGENCIA'
      DisplayFormat = 'dd/mm/yyyy'
    end
    object mtHistorialPrecioCOSTO_UNITARIO: TCurrencyField
      DisplayLabel = 'Costo'
      FieldName = 'COSTO_UNITARIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtHistorialPrecioPRECIO_UNITARIO: TCurrencyField
      DisplayLabel = 'Precio'
      FieldName = 'PRECIO_UNITARIO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtHistorialPrecioCOSTO_HORA: TCurrencyField
      DisplayLabel = 'Costo por hora'
      FieldName = 'COSTO_HORA'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtHistorialPrecioACTIVO: TBooleanField
      FieldName = 'ACTIVO'
      Visible = False
    end
    object mtHistorialPrecioESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldKind = fkCalculated
      FieldName = 'ESTADO'
      Size = 15
      Calculated = True
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
    object mtUnidadesMedidaID: TIntegerField
      FieldName = 'ID'
    end
    object mtUnidadesMedidaNOMBRE: TStringField
      FieldName = 'NOMBRE'
    end
  end
  object mtUnidadesLista: TFDMemTable
    OnCalcFields = CatalogoCalcFields
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 880
    Top = 376
    object mtUnidadesListaID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtUnidadesListaNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
    end
    object mtUnidadesListaABREVIATURA: TStringField
      DisplayLabel = 'Abreviatura'
      FieldName = 'ABREVIATURA'
      Size = 10
    end
    object mtUnidadesListaMAGNITUD: TStringField
      DisplayLabel = 'Magnitud'
      FieldName = 'MAGNITUD'
      OnGetText = MagnitudGetText
      Size = 10
    end
    object mtUnidadesListaACTIVO: TBooleanField
      FieldName = 'ACTIVO'
      Visible = False
    end
    object mtUnidadesListaESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldKind = fkCalculated
      FieldName = 'ESTADO'
      Size = 15
      Calculated = True
    end
    object mtUnidadesListaACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
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
    Left = 536
    Top = 376
  end
  object dsContactoNuevo: TDataSource
    DataSet = mtContactoNuevo
    Left = 488
    Top = 80
  end
  object mtUsuarios: TFDMemTable
    OnCalcFields = UsuariosCalcFields
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 48
    Top = 1160
    object mtUsuariosID: TIntegerField
      FieldName = 'ID'
    end
    object mtUsuariosNOMBRE: TStringField
      FieldName = 'NOMBRE'
      OnGetText = UsuarioNombreGetText
      Size = 120
    end
    object mtUsuariosCORREO: TStringField
      FieldName = 'CORREO'
      Size = 150
    end
    object mtUsuariosROL_ID: TIntegerField
      FieldName = 'ROL_ID'
      Visible = False
    end
    object mtUsuariosROL_NOMBRE: TStringField
      FieldName = 'ROL_NOMBRE'
      Size = 120
    end
    object mtUsuariosACTIVO: TBooleanField
      FieldName = 'ACTIVO'
      Visible = False
    end
    object mtUsuariosDEBE_CAMBIAR_CLAVE: TBooleanField
      FieldName = 'DEBE_CAMBIAR_CLAVE'
      Visible = False
    end
    object mtUsuariosEXCEPCIONES: TIntegerField
      Alignment = taCenter
      FieldName = 'EXCEPCIONES'
      OnGetText = AdicionalesGetText
    end
    object mtUsuariosESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldKind = fkCalculated
      FieldName = 'ESTADO'
      OnGetText = UsuarioEstadoGetText
      Size = 15
      Calculated = True
    end
    object mtUsuariosACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object dsUsuarios: TDataSource
    AutoEdit = False
    DataSet = mtUsuarios
    Left = 48
    Top = 1216
  end
  object mtPermisosUsuario: TFDMemTable
    OnCalcFields = PermisosUsuarioCalcFields
    AggregatesActive = True
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 160
    Top = 1160
    object mtPermisosUsuarioPERMISO_ID: TIntegerField
      FieldName = 'PERMISO_ID'
      Visible = False
    end
    object mtPermisosUsuarioMODULO: TStringField
      FieldName = 'MODULO'
      OnGetText = ModuloGetText
      Size = 30
    end
    object mtPermisosUsuarioNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtPermisosUsuarioTIENE: TBooleanField
      FieldName = 'TIENE'
    end
    object mtPermisosUsuarioDEL_ROL: TBooleanField
      FieldName = 'DEL_ROL'
      Visible = False
    end
    object mtPermisosUsuarioTIENE_ORIGINAL: TBooleanField
      FieldName = 'TIENE_ORIGINAL'
      Visible = False
    end
    object mtPermisosUsuarioMOTIVO: TStringField
      FieldName = 'MOTIVO'
      Size = 500
    end
    object mtPermisosUsuarioORIGEN: TStringField
      FieldKind = fkCalculated
      FieldName = 'ORIGEN'
      OnGetText = OrigenGetText
      Size = 15
      Calculated = True
    end
    object mtPermisosUsuarioADICIONALES: TAggregateField
      FieldName = 'ADICIONALES'
      Active = True
      DisplayName = ''
      Expression = 'SUM(IIF(TIENE AND NOT DEL_ROL, 1, 0))'
    end
    object mtPermisosUsuarioQUITADOS: TAggregateField
      FieldName = 'QUITADOS'
      Active = True
      DisplayName = ''
      Expression = 'SUM(IIF(DEL_ROL AND NOT TIENE, 1, 0))'
    end
  end
  object dsPermisosUsuario: TDataSource
    DataSet = mtPermisosUsuario
    Left = 160
    Top = 1216
  end
  object mtMatrizRoles: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 280
    Top = 1160
    object mtMatrizRolesPERMISO_ID: TIntegerField
      FieldName = 'PERMISO_ID'
      Visible = False
    end
    object mtMatrizRolesMODULO: TStringField
      FieldName = 'MODULO'
      OnGetText = ModuloGetText
      Size = 30
    end
    object mtMatrizRolesNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtMatrizRolesASESOR: TBooleanField
      FieldName = 'ASESOR'
    end
    object mtMatrizRolesASISTENTE: TBooleanField
      FieldName = 'ASISTENTE'
    end
    object mtMatrizRolesSUPERVISOR: TBooleanField
      FieldName = 'SUPERVISOR'
    end
    object mtMatrizRolesGERENCIA: TBooleanField
      FieldName = 'GERENCIA'
    end
    object mtMatrizRolesADMIN: TBooleanField
      FieldName = 'ADMIN'
    end
  end
  object dsMatrizRoles: TDataSource
    DataSet = mtMatrizRoles
    Left = 280
    Top = 1216
  end
  object mtUsuario: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 400
    Top = 1160
    object mtUsuarioNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtUsuarioCORREO: TStringField
      FieldName = 'CORREO'
      Size = 150
    end
    object mtUsuarioROL_ID: TIntegerField
      FieldName = 'ROL_ID'
    end
    object mtUsuarioCLAVE_TEMPORAL: TStringField
      FieldName = 'CLAVE_TEMPORAL'
      OnGetText = ClaveGetText
      Size = 30
    end
  end
  object dsUsuario: TDataSource
    DataSet = mtUsuario
    Left = 400
    Top = 1216
  end
  object dsRoles: TDataSource
    AutoEdit = False
    DataSet = mtRoles
    Left = 272
    Top = 496
  end
  object mtCategorias: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 936
    Top = 400
    object mtCategoriasID: TIntegerField
      FieldName = 'ID'
    end
    object mtCategoriasNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 100
    end
  end
  object dsCategorias: TDataSource
    AutoEdit = False
    DataSet = mtCategorias
    Left = 936
    Top = 456
  end
  object mtMagnitudes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 936
    Top = 512
    object mtMagnitudesCODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 10
    end
    object mtMagnitudesNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 40
    end
  end
  object dsMagnitudes: TDataSource
    AutoEdit = False
    DataSet = mtMagnitudes
    Left = 936
    Top = 568
  end
  object mtCotizacionesLista: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1056
    Top = 24
    object mtCotizacionesListaID: TIntegerField
      Visible = False
      FieldName = 'ID'
    end
    object mtCotizacionesListaNUMERO: TIntegerField
      DisplayLabel = 'N'#250'mero'
      FieldName = 'NUMERO'
    end
    object mtCotizacionesListaCLIENTE_NOMBRE: TStringField
      DisplayLabel = 'Cliente'
      Size = 120
      FieldName = 'CLIENTE_NOMBRE'
    end
    object mtCotizacionesListaDESCRIPCION_TRABAJO: TStringField
      DisplayLabel = 'Trabajo'
      Size = 500
      FieldName = 'DESCRIPCION_TRABAJO'
    end
    object mtCotizacionesListaASESOR_NOMBRE: TStringField
      DisplayLabel = 'Asesor'
      Size = 120
      FieldName = 'ASESOR_NOMBRE'
    end
    object mtCotizacionesListaFECHA_ELABORACION: TDateTimeField
      DisplayLabel = 'Elaborada'
      DisplayFormat = 'dd/mm/yyyy'
      FieldName = 'FECHA_ELABORACION'
    end
    object mtCotizacionesListaMONTO_TOTAL: TCurrencyField
      DisplayLabel = 'Total'
      DisplayFormat = '#,##0.00'
      currency = False
      FieldName = 'MONTO_TOTAL'
    end
    object mtCotizacionesListaESTADO: TStringField
      DisplayLabel = 'Estado'
      OnGetText = EstadoGetText
      FieldName = 'ESTADO'
    end
    object mtCotizacionesListaACCIONES: TStringField
      DisplayLabel = 'Acciones'
      FieldName = 'ACCIONES'
    end
  end
  object dsCotizacionesLista: TDataSource
    AutoEdit = False
    DataSet = mtCotizacionesLista
    Left = 1160
    Top = 24
  end
  object mtLineasCotizacion: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1056
    Top = 80
    object mtLineasCotizacionID: TIntegerField
      Visible = False
      FieldName = 'ID'
    end
    object mtLineasCotizacionTIPO: TStringField
      DisplayLabel = 'Tipo'
      OnGetText = TipoGetText
      FieldName = 'TIPO'
    end
    object mtLineasCotizacionDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      Size = 500
      FieldName = 'DESCRIPCION'
    end
    object mtLineasCotizacionUNIDAD_MEDIDA: TStringField
      DisplayLabel = 'Unidad'
      Size = 30
      FieldName = 'UNIDAD_MEDIDA'
    end
    object mtLineasCotizacionCANTIDAD: TCurrencyField
      DisplayLabel = 'Cantidad'
      DisplayFormat = '#,##0.00'
      currency = False
      FieldName = 'CANTIDAD'
    end
    object mtLineasCotizacionPRECIO_UNITARIO: TCurrencyField
      DisplayLabel = 'Precio'
      DisplayFormat = '#,##0.00'
      currency = False
      FieldName = 'PRECIO_UNITARIO'
    end
    object mtLineasCotizacionSUBTOTAL: TCurrencyField
      DisplayLabel = 'Subtotal'
      DisplayFormat = '#,##0.00'
      currency = False
      FieldName = 'SUBTOTAL'
    end
    object mtLineasCotizacionACCIONES: TStringField
      DisplayLabel = 'Acciones'
      FieldName = 'ACCIONES'
    end
  end
  object dsLineasCotizacion: TDataSource
    AutoEdit = False
    DataSet = mtLineasCotizacion
    Left = 1160
    Top = 80
  end
  object mtCotizacionEdicion: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1056
    Top = 136
    object mtCotizacionEdicionTIPO_TRABAJO_ID: TIntegerField
      FieldName = 'TIPO_TRABAJO_ID'
    end
    object mtCotizacionEdicionDESCRIPCION_TRABAJO: TStringField
      Size = 500
      FieldName = 'DESCRIPCION_TRABAJO'
    end
    object mtCotizacionEdicionFORMA_PAGO_ID: TIntegerField
      DisplayLabel = 'Forma de pago'
      FieldName = 'FORMA_PAGO_ID'
    end
    object mtCotizacionEdicionPLAZO_ENTREGA_CANTIDAD: TIntegerField
      DisplayLabel = 'Entrega'
      FieldName = 'PLAZO_ENTREGA_CANTIDAD'
    end
    object mtCotizacionEdicionPLAZO_ENTREGA_UNIDAD: TStringField
      DisplayLabel = 'Unidad'
      FieldName = 'PLAZO_ENTREGA_UNIDAD'
      Size = 15
    end
    object mtCotizacionEdicionGARANTIA_CANTIDAD: TIntegerField
      DisplayLabel = 'Garant'#237'a'
      FieldName = 'GARANTIA_CANTIDAD'
    end
    object mtCotizacionEdicionGARANTIA_UNIDAD: TStringField
      DisplayLabel = 'Unidad'
      FieldName = 'GARANTIA_UNIDAD'
      Size = 15
    end
  end
  object dsCotizacionEdicion: TDataSource
    DataSet = mtCotizacionEdicion
    Left = 1160
    Top = 136
  end
  object mtTiposTrabajoLista: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1056
    Top = 192
    object mtTiposTrabajoListaID: TIntegerField
      FieldName = 'ID'
    end
    object mtTiposTrabajoListaNOMBRE: TStringField
      Size = 100
      FieldName = 'NOMBRE'
    end
  end
  object dsTiposTrabajoLista: TDataSource
    AutoEdit = False
    DataSet = mtTiposTrabajoLista
    Left = 1160
    Top = 192
  end
  object mtMedidas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1056
    Top = 248
    object mtMedidasPIEZA_NOMBRE: TStringField
      DisplayLabel = 'Pieza'
      DisplayWidth = 18
      FieldName = 'PIEZA_NOMBRE'
      Visible = False
      Size = 120
    end
    object mtMedidasETIQUETA: TStringField
      DisplayLabel = 'Etiqueta'
      FieldName = 'ETIQUETA'
      Size = 120
    end
    object mtMedidasTIPO_MEDIDA: TStringField
      DisplayLabel = 'Tipo de medida'
      FieldName = 'TIPO_MEDIDA'
      OnGetText = MayusculaInicialGetText
      Size = 30
    end
    object mtMedidasUNIDAD_MEDIDA: TStringField
      DisplayLabel = 'Unidad'
      FieldName = 'UNIDAD_MEDIDA'
      Size = 30
    end
    object mtMedidasVALOR: TCurrencyField
      DisplayLabel = 'Valor'
      FieldName = 'VALOR'
      DisplayFormat = '#,##0.##'
      currency = False
    end
    object mtMedidasCANTIDAD: TIntegerField
      DisplayLabel = 'Cantidad'
      FieldName = 'CANTIDAD'
    end
  end
  object dsMedidas: TDataSource
    AutoEdit = False
    DataSet = mtMedidas
    Left = 1160
    Top = 248
  end
  object mtPiezas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 568
    object mtPiezasID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtPiezasNOMBRE: TStringField
      DisplayLabel = 'Pieza'
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtPiezasTIPO_TRABAJO_NOMBRE: TStringField
      DisplayLabel = 'Trabajo'
      FieldName = 'TIPO_TRABAJO_NOMBRE'
      Size = 100
    end
    object mtPiezasTIPO_MATERIAL_NOMBRE: TStringField
      DisplayLabel = 'Material'
      FieldName = 'TIPO_MATERIAL_NOMBRE'
      Size = 100
    end
    object mtPiezasACABADO_NOMBRE: TStringField
      DisplayLabel = 'Acabado'
      FieldName = 'ACABADO_NOMBRE'
      Size = 100
    end
  end
  object dsPiezas: TDataSource
    AutoEdit = False
    DataSet = mtPiezas
    Left = 1384
    Top = 568
  end
  object mtCatalogoSimple: TFDMemTable
    OnCalcFields = CatalogoCalcFields
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 624
    object mtCatalogoSimpleID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtCatalogoSimpleNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtCatalogoSimpleACTIVO: TBooleanField
      FieldName = 'ACTIVO'
      Visible = False
    end
    object mtCatalogoSimpleESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldKind = fkCalculated
      FieldName = 'ESTADO'
      Size = 15
      Calculated = True
    end
    object mtCatalogoSimpleACCIONES: TStringField
      FieldName = 'ACCIONES'
      Size = 1
    end
  end
  object mtFormasPagoLista: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 680
    object mtFormasPagoListaID: TIntegerField
      FieldName = 'ID'
    end
    object mtFormasPagoListaNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 120
    end
  end
  object dsFormasPagoLista: TDataSource
    AutoEdit = False
    DataSet = mtFormasPagoLista
    Left = 1384
    Top = 680
  end
  object mtUnidadesPlazo: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 736
    object mtUnidadesPlazoCODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 15
    end
    object mtUnidadesPlazoNOMBRE: TStringField
      FieldName = 'NOMBRE'
      Size = 40
    end
  end
  object dsUnidadesPlazo: TDataSource
    AutoEdit = False
    DataSet = mtUnidadesPlazo
    Left = 1384
    Top = 736
  end
  object mtTelefonos: TFDMemTable
    OnCalcFields = CatalogoCalcFields
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 792
    object mtTelefonosID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtTelefonosNOMBRE: TStringField
      DisplayLabel = 'Tel'#233'fono'
      FieldName = 'NOMBRE'
      Size = 120
    end
    object mtTelefonosFECHA_CREACION: TDateTimeField
      DisplayLabel = 'Registrado'
      FieldName = 'FECHA_CREACION'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
    object mtTelefonosFECHA_ULTIMO_USO: TDateTimeField
      DisplayLabel = #218'ltimo uso'
      FieldName = 'FECHA_ULTIMO_USO'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
    object mtTelefonosESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldKind = fkCalculated
      FieldName = 'ESTADO'
      Size = 15
      Calculated = True
    end
    object mtTelefonosMOTIVO: TStringField
      DisplayLabel = 'Motivo'
      FieldName = 'MOTIVO'
      OnGetText = MotivoTelefonoGetText
      Size = 20
    end
    object mtTelefonosACTIVO: TBooleanField
      FieldName = 'ACTIVO'
      Visible = False
    end
    object mtTelefonosINACTIVAR: TBooleanField
      DisplayLabel = 'Inactivar al guardar'
      FieldName = 'INACTIVAR'
    end
  end
  object dsTelefonos: TDataSource
    DataSet = mtTelefonos
    Left = 1384
    Top = 792
  end
  object mtTextosConsentimiento: TFDMemTable
    OnCalcFields = TextosConsentimientoCalcFields
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 848
    object mtTextosConsentimientoID: TIntegerField
      FieldName = 'ID'
      Visible = False
    end
    object mtTextosConsentimientoVERSION: TStringField
      DisplayLabel = 'Versi'#243'n'
      FieldName = 'VERSION'
      Size = 10
    end
    object mtTextosConsentimientoTITULO: TStringField
      DisplayLabel = 'T'#237'tulo'
      FieldName = 'TITULO'
      Size = 120
    end
    object mtTextosConsentimientoVIGENTE_DESDE: TDateTimeField
      DisplayLabel = 'Rige desde'
      FieldName = 'VIGENTE_DESDE'
      DisplayFormat = 'dd/mm/yyyy hh:nn'
    end
    object mtTextosConsentimientoESTADO: TStringField
      DisplayLabel = 'Estado'
      FieldKind = fkCalculated
      FieldName = 'ESTADO'
      OnGetText = EstadoConsentimientoGetText
      Size = 15
      Calculated = True
    end
    object mtTextosConsentimientoVIGENTE: TBooleanField
      FieldName = 'VIGENTE'
      Visible = False
    end
    object mtTextosConsentimientoCONTENIDO: TWideMemoField
      FieldName = 'CONTENIDO'
      Visible = False
      BlobType = ftWideMemo
    end
  end
  object dsTextosConsentimiento: TDataSource
    AutoEdit = False
    DataSet = mtTextosConsentimiento
    Left = 1384
    Top = 848
  end
  object mtConsentimientoNuevo: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 904
    object mtConsentimientoNuevoVERSION: TStringField
      DisplayLabel = 'Versi'#243'n'
      FieldName = 'VERSION'
      Size = 10
    end
    object mtConsentimientoNuevoTITULO: TStringField
      DisplayLabel = 'T'#237'tulo'
      FieldName = 'TITULO'
      Size = 120
    end
    object mtConsentimientoNuevoCONTENIDO: TWideMemoField
      FieldName = 'CONTENIDO'
      BlobType = ftWideMemo
    end
  end
  object dsConsentimientoNuevo: TDataSource
    DataSet = mtConsentimientoNuevo
    Left = 1384
    Top = 904
  end
  object mtItemsLinea: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1056
    Top = 304
    object mtItemsLineaID: TIntegerField
      Visible = False
      FieldName = 'ID'
    end
    object mtItemsLineaCODIGO: TStringField
      DisplayLabel = 'C'#243'digo'
      Size = 30
      FieldName = 'CODIGO'
    end
    object mtItemsLineaNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      Size = 120
      FieldName = 'NOMBRE'
    end
    object mtItemsLineaCATEGORIA: TStringField
      DisplayLabel = 'Categor'#237'a'
      Size = 100
      FieldName = 'CATEGORIA'
    end
    object mtItemsLineaUNIDAD_MEDIDA: TStringField
      DisplayLabel = 'Unidad'
      Size = 30
      FieldName = 'UNIDAD_MEDIDA'
    end
    object mtItemsLineaPRECIO: TCurrencyField
      DisplayLabel = 'Precio vigente'
      DisplayFormat = '#,##0.00'
      currency = False
      FieldName = 'PRECIO'
    end
    object mtItemsLineaPROGRAMADO_FECHA: TDateTimeField
      DisplayLabel = 'Nuevo precio desde'
      DisplayFormat = 'dd/mm/yyyy'
      FieldName = 'PROGRAMADO_FECHA'
    end
  end
  object dsItemsLinea: TDataSource
    AutoEdit = False
    DataSet = mtItemsLinea
    Left = 1160
    Top = 304
  end
  object mtLineaNueva: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1056
    Top = 360
    object mtLineaNuevaCANTIDAD: TCurrencyField
      DisplayLabel = 'Cantidad'
      DisplayFormat = '#,##0.##'
      currency = False
      FieldName = 'CANTIDAD'
    end
    object mtLineaNuevaNOTA: TStringField
      Size = 500
      FieldName = 'NOTA'
    end
  end
  object dsLineaNueva: TDataSource
    DataSet = mtLineaNueva
    Left = 1160
    Top = 360
  end
  object mtAjuste: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1056
    Top = 416
    object mtAjustePORCENTAJE: TCurrencyField
      DisplayFormat = '#,##0.##'
      currency = False
      FieldName = 'PORCENTAJE'
    end
    object mtAjusteMOTIVO: TStringField
      Size = 300
      FieldName = 'MOTIVO'
    end
  end
  object dsAjuste: TDataSource
    DataSet = mtAjuste
    Left = 1160
    Top = 416
  end
  object mtReporteEstados: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 32
    object mtReporteEstadosESTADO: TStringField
      DisplayLabel = 'Paso'
      DisplayWidth = 28
      FieldName = 'ESTADO'
      OnGetText = EstadoGetText
    end
    object mtReporteEstadosCANTIDAD: TIntegerField
      DisplayLabel = 'Cantidad'
      FieldName = 'CANTIDAD'
    end
    object mtReporteEstadosMONTO: TCurrencyField
      DisplayLabel = 'Monto'
      FieldName = 'MONTO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
  end
  object dsReporteEstados: TDataSource
    DataSet = mtReporteEstados
    Left = 1384
    Top = 32
  end
  object mtReporteAsesores: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 96
    object mtReporteAsesoresASESOR_ID: TIntegerField
      FieldName = 'ASESOR_ID'
      Visible = False
    end
    object mtReporteAsesoresASESOR_NOMBRE: TStringField
      DisplayLabel = 'Asesor'
      FieldName = 'ASESOR_NOMBRE'
      Size = 120
    end
    object mtReporteAsesoresCANTIDAD: TIntegerField
      DisplayLabel = 'Enviadas'
      FieldName = 'CANTIDAD'
    end
    object mtReporteAsesoresAPROBADAS: TIntegerField
      DisplayLabel = 'Aprobadas'
      FieldName = 'APROBADAS'
    end
    object mtReporteAsesoresRECHAZADAS: TIntegerField
      DisplayLabel = 'Rechazadas'
      FieldName = 'RECHAZADAS'
    end
    object mtReporteAsesoresTASA_APROBACION: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Tasa'
      FieldName = 'TASA_APROBACION'
      OnGetText = PorcentajeGetText
    end
    object mtReporteAsesoresMONTO_APROBADO: TCurrencyField
      DisplayLabel = 'Monto aprobado'
      FieldName = 'MONTO_APROBADO'
      DisplayFormat = '#,##0.00'
      currency = False
    end
    object mtReporteAsesoresMONTO_TOTAL: TCurrencyField
      DisplayLabel = 'Monto enviado'
      FieldName = 'MONTO_TOTAL'
      DisplayFormat = '#,##0.00'
      currency = False
    end
  end
  object dsReporteAsesores: TDataSource
    DataSet = mtReporteAsesores
    Left = 1384
    Top = 96
  end
  object mtReporteTipos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 160
    object mtReporteTiposTIPO_TRABAJO_ID: TIntegerField
      FieldName = 'TIPO_TRABAJO_ID'
      Visible = False
    end
    object mtReporteTiposTIPO_TRABAJO_NOMBRE: TStringField
      DisplayLabel = 'Tipo de trabajo'
      FieldName = 'TIPO_TRABAJO_NOMBRE'
      Size = 120
    end
    object mtReporteTiposCANTIDAD: TIntegerField
      DisplayLabel = 'Enviadas'
      FieldName = 'CANTIDAD'
    end
    object mtReporteTiposAPROBADAS: TIntegerField
      DisplayLabel = 'Aprobadas'
      FieldName = 'APROBADAS'
    end
    object mtReporteTiposMONTO_TOTAL: TCurrencyField
      DisplayLabel = 'Monto enviado'
      FieldName = 'MONTO_TOTAL'
      DisplayFormat = '#,##0.00'
      currency = False
    end
  end
  object dsReporteTipos: TDataSource
    DataSet = mtReporteTipos
    Left = 1384
    Top = 160
  end
  object mtReporteMeses: TFDMemTable
    OnCalcFields = ReporteMesesCalcFields
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 224
    object mtReporteMesesMES_NOMBRE: TStringField
      DisplayLabel = 'Mes'
      FieldKind = fkCalculated
      FieldName = 'MES_NOMBRE'
      Size = 40
      Calculated = True
    end
    object mtReporteMesesANIO: TIntegerField
      FieldName = 'ANIO'
      Visible = False
    end
    object mtReporteMesesMES: TIntegerField
      FieldName = 'MES'
      Visible = False
    end
    object mtReporteMesesCANTIDAD: TIntegerField
      DisplayLabel = 'Enviadas'
      FieldName = 'CANTIDAD'
    end
    object mtReporteMesesAPROBADAS: TIntegerField
      DisplayLabel = 'Aprobadas'
      FieldName = 'APROBADAS'
    end
    object mtReporteMesesRECHAZADAS: TIntegerField
      DisplayLabel = 'Rechazadas'
      FieldName = 'RECHAZADAS'
    end
    object mtReporteMesesTASA_APROBACION: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Tasa'
      FieldName = 'TASA_APROBACION'
      OnGetText = PorcentajeGetText
    end
    object mtReporteMesesMONTO_TOTAL: TCurrencyField
      DisplayLabel = 'Monto enviado'
      FieldName = 'MONTO_TOTAL'
      DisplayFormat = '#,##0.00'
      currency = False
    end
  end
  object dsReporteMeses: TDataSource
    DataSet = mtReporteMeses
    Left = 1384
    Top = 224
  end
  object mtImportacion: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 288
    object mtImportacionFILA: TIntegerField
      DisplayLabel = 'Fila'
      FieldName = 'FILA'
    end
    object mtImportacionCODIGO: TStringField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'CODIGO'
      Size = 30
    end
    object mtImportacionCATEGORIA: TStringField
      DisplayLabel = 'Categor'#237'a'
      FieldName = 'CATEGORIA'
      Size = 60
    end
    object mtImportacionNOMBRE: TStringField
      DisplayLabel = 'Nombre'
      FieldName = 'NOMBRE'
      DisplayWidth = 30
      Size = 120
    end
    object mtImportacionDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION'
      DisplayWidth = 30
      Size = 500
    end
    object mtImportacionUNIDAD: TStringField
      DisplayLabel = 'Unidad'
      FieldName = 'UNIDAD'
      DisplayWidth = 10
      Size = 30
    end
    object mtImportacionCOSTO: TStringField
      Alignment = taRightJustify
      DisplayLabel = 'Costo'
      FieldName = 'COSTO'
      DisplayWidth = 14
      Size = 30
    end
    object mtImportacionPRECIO: TStringField
      Alignment = taRightJustify
      DisplayLabel = 'Precio'
      FieldName = 'PRECIO'
      DisplayWidth = 14
      Size = 30
    end
    object mtImportacionREVISION: TStringField
      DisplayLabel = 'Revisi'#243'n'
      FieldName = 'REVISION'
      DisplayWidth = 40
      Size = 300
    end
    object mtImportacionCON_ERROR: TBooleanField
      FieldName = 'CON_ERROR'
      Visible = False
    end
  end
  object dsImportacion: TDataSource
    DataSet = mtImportacion
    Left = 1384
    Top = 288
  end
  object mtEmpresa: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 344
    object mtEmpresaRAZON_SOCIAL: TStringField
      DisplayLabel = 'Raz'#243'n social'
      FieldName = 'RAZON_SOCIAL'
      Required = True
      Size = 120
    end
    object mtEmpresaCEDULA_JURIDICA: TStringField
      DisplayLabel = 'C'#233'dula jur'#237'dica'
      FieldName = 'CEDULA_JURIDICA'
      Required = True
      Size = 20
    end
    object mtEmpresaDIRECCION: TStringField
      DisplayLabel = 'Direcci'#243'n'
      FieldName = 'DIRECCION'
      Size = 500
    end
    object mtEmpresaTELEFONO_FIJO: TStringField
      DisplayLabel = 'Tel'#233'fono fijo'
      FieldName = 'TELEFONO_FIJO'
      Size = 30
    end
    object mtEmpresaCELULAR: TStringField
      DisplayLabel = 'Celular'
      FieldName = 'CELULAR'
      Size = 30
    end
    object mtEmpresaCORREO: TStringField
      DisplayLabel = 'Correo'
      FieldName = 'CORREO'
      Size = 150
    end
    object mtEmpresaREPRESENTANTE_LEGAL: TStringField
      DisplayLabel = 'Representante legal'
      FieldName = 'REPRESENTANTE_LEGAL'
      Size = 120
    end
    object mtEmpresaCUENTA_BANCARIA: TStringField
      DisplayLabel = 'Cuenta bancaria'
      FieldName = 'CUENTA_BANCARIA'
      Size = 60
    end
    object mtEmpresaFORMA_PAGO_ID: TIntegerField
      DisplayLabel = 'Forma de pago'
      FieldName = 'FORMA_PAGO_ID'
    end
    object mtEmpresaPLAZO_ENTREGA_CANTIDAD: TIntegerField
      DisplayLabel = 'Entrega'
      FieldName = 'PLAZO_ENTREGA_CANTIDAD'
    end
    object mtEmpresaPLAZO_ENTREGA_UNIDAD: TStringField
      DisplayLabel = 'Unidad'
      FieldName = 'PLAZO_ENTREGA_UNIDAD'
      Size = 15
    end
    object mtEmpresaGARANTIA_CANTIDAD: TIntegerField
      DisplayLabel = 'Garant'#237'a'
      FieldName = 'GARANTIA_CANTIDAD'
    end
    object mtEmpresaGARANTIA_UNIDAD: TStringField
      DisplayLabel = 'Unidad'
      FieldName = 'GARANTIA_UNIDAD'
      Size = 15
    end
    object mtEmpresaFIRMANTE: TStringField
      DisplayLabel = 'Firma la cotizaci'#243'n'
      FieldName = 'FIRMANTE'
      Size = 120
    end
    object mtEmpresaCARTA_PRESENTACION: TStringField
      DisplayLabel = 'Carta de presentaci'#243'n (segunda p'#225'gina)'
      FieldName = 'CARTA_PRESENTACION'
      Size = 4000
    end
    object mtEmpresaPORCENTAJE_IVA: TCurrencyField
      DisplayLabel = 'IVA (%)'
      DisplayFormat = '#,##0.##'
      currency = False
      FieldName = 'PORCENTAJE_IVA'
      Required = True
    end
  end
  object dsEmpresa: TDataSource
    DataSet = mtEmpresa
    Left = 1384
    Top = 344
  end
  object mtParametros: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 400
    object mtParametrosDIAS_SIN_RESPUESTA: TIntegerField
      DisplayLabel = 'D'#237'as para '#171'sin respuesta'#187' del cliente'
      FieldName = 'DIAS_SIN_RESPUESTA'
    end
    object mtParametrosMINUTOS_AVISOS: TIntegerField
      DisplayLabel = 'Revisar avisos cada (minutos)'
      FieldName = 'MINUTOS_AVISOS'
    end
  end
  object dsParametros: TDataSource
    DataSet = mtParametros
    Left = 1384
    Top = 400
  end
  object mtDocumentoLineas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 456
    object mtDocumentoLineasDESCRIPCION: TStringField
      DisplayLabel = 'Descripci'#243'n'
      FieldName = 'DESCRIPCION'
      Size = 500
    end
    object mtDocumentoLineasCANTIDAD: TCurrencyField
      DisplayLabel = 'Cantidad'
      DisplayFormat = '#,##0.##'
      currency = False
      FieldName = 'CANTIDAD'
    end
    object mtDocumentoLineasPRECIO_UNITARIO: TCurrencyField
      DisplayLabel = 'Precio unitario'
      DisplayFormat = #162'#,##0.00'
      currency = False
      FieldName = 'PRECIO_UNITARIO'
    end
    object mtDocumentoLineasTOTAL: TCurrencyField
      DisplayLabel = 'Total'
      DisplayFormat = #162'#,##0.00'
      currency = False
      FieldName = 'TOTAL'
    end
  end
  object dsDocumentoLineas: TDataSource
    DataSet = mtDocumentoLineas
    Left = 1384
    Top = 456
  end
  object mtEnvioCorreo: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 1280
    Top = 512
    object mtEnvioCorreoPARA: TStringField
      DisplayLabel = 'Para (separe varios correos con coma)'
      FieldName = 'PARA'
      Size = 300
    end
    object mtEnvioCorreoCC: TStringField
      DisplayLabel = 'Con copia (opcional)'
      FieldName = 'CC'
      Size = 300
    end
    object mtEnvioCorreoASUNTO: TStringField
      DisplayLabel = 'Asunto'
      FieldName = 'ASUNTO'
      Size = 200
    end
    object mtEnvioCorreoMENSAJE: TStringField
      DisplayLabel = 'Mensaje'
      FieldName = 'MENSAJE'
      Size = 4000
    end
  end
  object dsEnvioCorreo: TDataSource
    DataSet = mtEnvioCorreo
    Left = 1384
    Top = 512
  end
end
