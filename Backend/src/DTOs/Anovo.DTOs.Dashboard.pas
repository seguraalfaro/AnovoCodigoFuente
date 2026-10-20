unit Anovo.DTOs.Dashboard;

// DTOs de /api/dashboard.

interface

uses
  System.Generics.Collections,
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type

  [MVCNameCase(ncSnakeCase)]
  TSolicitudAsesorDTO = class
  private
    fID: Integer;
    fFechaCaptura: NullableTDateTime;
    fClienteNombre: string;
    fDescripcion: string;
    fEstado: string;
    fCotizacionId: NullableInt32;
    fMontoAprobado: NullableCurrency;
  public
    property ID: Integer read fID write fID;
    property FechaCaptura: NullableTDateTime read fFechaCaptura
      write fFechaCaptura;
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property Descripcion: string read fDescripcion write fDescripcion;
    property Estado: string read fEstado write fEstado;
    property CotizacionId: NullableInt32 read fCotizacionId
      write fCotizacionId;
    property MontoAprobado: NullableCurrency read fMontoAprobado
      write fMontoAprobado;
  end;

  [MVCNameCase(ncSnakeCase)]
  TDashboardBarraDTO = class
  private
    fClave: string;
    fEtiqueta: string;
    fCantidad: Integer;
  public
    property Clave: string read fClave write fClave;
    property Etiqueta: string read fEtiqueta write fEtiqueta;
    property Cantidad: Integer read fCantidad write fCantidad;
  end;

  [MVCNameCase(ncSnakeCase)]
  TDashboardAvisoDTO = class
  private
    fCotizacionId: Integer;
    fNumero: Integer;
    fClienteNombre: string;
    fEstado: string;
    fDetalle: string;
    fDias: Integer;
    fNivel: string;
    fEtiqueta: string;
  public
    property CotizacionId: Integer read fCotizacionId write fCotizacionId;
    property Numero: Integer read fNumero write fNumero;
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property Estado: string read fEstado write fEstado;
    property Detalle: string read fDetalle write fDetalle;
    property Dias: Integer read fDias write fDias;
    property Nivel: string read fNivel write fNivel;
    property Etiqueta: string read fEtiqueta write fEtiqueta;
  end;

  [MVCNameCase(ncSnakeCase)]
  TDashboardDatoDTO = class
  private
    fConcepto: string;
    fValor: string;
  public
    property Concepto: string read fConcepto write fConcepto;
    property Valor: string read fValor write fValor;
  end;

  [MVCNameCase(ncSnakeCase)]
  TDashboardAsesorDTO = class
  private
    fDesde: TDateTime;
    fHasta: TDateTime;
    fSolicitudesMes: Integer;
    fEsperandoCotizacion: Integer;
    fAprobadasMes: Integer;
    fMontoAprobadoMes: Currency;
    fSolicitudesMesAnterior: Integer;
    fDiasMasAntigua: Integer;
    fTasaAprobacion: Currency;
    fVariacionSolicitudes: Integer;
    fMontoAprobadoAnterior: Currency;
    fVariacionMonto: NullableCurrency;
    fMesAnterior: TDateTime;
    fRecientes: TObjectList<TSolicitudAsesorDTO>;
    fPorEstado: TObjectList<TDashboardBarraDTO>;
    fPorLlamar: TObjectList<TDashboardAvisoDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property Desde: TDateTime read fDesde write fDesde;
    property Hasta: TDateTime read fHasta write fHasta;
    property SolicitudesMes: Integer read fSolicitudesMes
      write fSolicitudesMes;
    property EsperandoCotizacion: Integer read fEsperandoCotizacion
      write fEsperandoCotizacion;
    property AprobadasMes: Integer read fAprobadasMes write fAprobadasMes;
    property MontoAprobadoMes: Currency read fMontoAprobadoMes
      write fMontoAprobadoMes;
    property SolicitudesMesAnterior: Integer read fSolicitudesMesAnterior
      write fSolicitudesMesAnterior;
    property DiasMasAntigua: Integer read fDiasMasAntigua write fDiasMasAntigua;
    property TasaAprobacion: Currency read fTasaAprobacion write fTasaAprobacion;
    property VariacionSolicitudes: Integer read fVariacionSolicitudes
      write fVariacionSolicitudes;
    property MontoAprobadoAnterior: Currency read fMontoAprobadoAnterior
      write fMontoAprobadoAnterior;
    property VariacionMonto: NullableCurrency read fVariacionMonto
      write fVariacionMonto;
    property MesAnterior: TDateTime read fMesAnterior write fMesAnterior;
    property Recientes: TObjectList<TSolicitudAsesorDTO> read fRecientes
      write fRecientes;
    property PorEstado: TObjectList<TDashboardBarraDTO> read fPorEstado
      write fPorEstado;
    property PorLlamar: TObjectList<TDashboardAvisoDTO> read fPorLlamar
      write fPorLlamar;
  end;

  [MVCNameCase(ncSnakeCase)]
  TSolicitudPorCotizarDTO = class
  private
    fID: Integer;
    fFechaRecepcion: NullableTDateTime;
    fClienteNombre: string;
    fAsesorNombre: string;
    fDescripcion: string;
    fDiasEspera: NullableInt32;
  public
    property ID: Integer read fID write fID;
    property FechaRecepcion: NullableTDateTime read fFechaRecepcion
      write fFechaRecepcion;
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property AsesorNombre: string read fAsesorNombre write fAsesorNombre;
    property Descripcion: string read fDescripcion write fDescripcion;
    property DiasEspera: NullableInt32 read fDiasEspera write fDiasEspera;
  end;

  [MVCNameCase(ncSnakeCase)]
  TDashboardAsistenteDTO = class
  private
    fPorCotizar: Integer;
    fMisBorradores: Integer;
    fEnAprobacion: Integer;
    fPorEnviar: Integer;
    fDevueltas: Integer;
    fSinRespuesta: Integer;
    fDiasMasAntigua: Integer;
    fDiasPlazo: Integer;
    fCola: TObjectList<TSolicitudPorCotizarDTO>;
    fPorEtapa: TObjectList<TDashboardBarraDTO>;
    fParaHoy: TObjectList<TDashboardAvisoDTO>;
    fMiMes: TObjectList<TDashboardDatoDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property PorCotizar: Integer read fPorCotizar write fPorCotizar;
    property MisBorradores: Integer read fMisBorradores write fMisBorradores;
    property EnAprobacion: Integer read fEnAprobacion write fEnAprobacion;
    property PorEnviar: Integer read fPorEnviar write fPorEnviar;
    property Devueltas: Integer read fDevueltas write fDevueltas;
    property SinRespuesta: Integer read fSinRespuesta write fSinRespuesta;
    property DiasMasAntigua: Integer read fDiasMasAntigua write fDiasMasAntigua;
    property DiasPlazo: Integer read fDiasPlazo write fDiasPlazo;
    property Cola: TObjectList<TSolicitudPorCotizarDTO> read fCola
      write fCola;
    property PorEtapa: TObjectList<TDashboardBarraDTO> read fPorEtapa
      write fPorEtapa;
    property ParaHoy: TObjectList<TDashboardAvisoDTO> read fParaHoy
      write fParaHoy;
    property MiMes: TObjectList<TDashboardDatoDTO> read fMiMes write fMiMes;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCotizacionPorAprobarDTO = class
  private
    fID: Integer;
    fNumero: Integer;
    fFechaModificacion: NullableTDateTime;
    fClienteNombre: string;
    fElaboradaPorNombre: string;
    fMontoTotal: NullableCurrency;
    fDiasEnEstado: NullableInt32;
  public
    property ID: Integer read fID write fID;
    property Numero: Integer read fNumero write fNumero;
    property FechaModificacion: NullableTDateTime read fFechaModificacion
      write fFechaModificacion;
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property ElaboradaPorNombre: string read fElaboradaPorNombre
      write fElaboradaPorNombre;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property DiasEnEstado: NullableInt32 read fDiasEnEstado write fDiasEnEstado;
  end;

  [MVCNameCase(ncSnakeCase)]
  TDashboardSupervisorDTO = class
  private
    fDesde: TDateTime;
    fHasta: TDateTime;
    fPorAprobar: Integer;
    fDiasMasAntigua: Integer;
    fAprobadasMes: Integer;
    fMontoAprobadoMes: Currency;
    fRechazadasMes: Integer;
    fVistoBuenoMes: Integer;
    fDevueltasMes: Integer;
    fTasaAprobacion: Currency;
    fMontoAprobadoAnterior: Currency;
    fTasaAnterior: Currency;
    fVariacionTasa: Currency;
    fVariacionMonto: NullableCurrency;
    fMesAnterior: TDateTime;
    fCola: TObjectList<TCotizacionPorAprobarDTO>;
    fCarga: TObjectList<TDashboardBarraDTO>;
    fEstancadas: TObjectList<TDashboardAvisoDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property Desde: TDateTime read fDesde write fDesde;
    property Hasta: TDateTime read fHasta write fHasta;
    property PorAprobar: Integer read fPorAprobar write fPorAprobar;
    property DiasMasAntigua: Integer read fDiasMasAntigua
      write fDiasMasAntigua;
    property AprobadasMes: Integer read fAprobadasMes write fAprobadasMes;
    property MontoAprobadoMes: Currency read fMontoAprobadoMes
      write fMontoAprobadoMes;
    property RechazadasMes: Integer read fRechazadasMes write fRechazadasMes;
    property VistoBuenoMes: Integer read fVistoBuenoMes write fVistoBuenoMes;
    property DevueltasMes: Integer read fDevueltasMes write fDevueltasMes;
    property TasaAprobacion: Currency read fTasaAprobacion write fTasaAprobacion;
    property MontoAprobadoAnterior: Currency read fMontoAprobadoAnterior
      write fMontoAprobadoAnterior;
    property TasaAnterior: Currency read fTasaAnterior write fTasaAnterior;
    property VariacionTasa: Currency read fVariacionTasa write fVariacionTasa;
    property VariacionMonto: NullableCurrency read fVariacionMonto
      write fVariacionMonto;
    property MesAnterior: TDateTime read fMesAnterior write fMesAnterior;
    property Cola: TObjectList<TCotizacionPorAprobarDTO> read fCola
      write fCola;
    property Carga: TObjectList<TDashboardBarraDTO> read fCarga write fCarga;
    property Estancadas: TObjectList<TDashboardAvisoDTO> read fEstancadas
      write fEstancadas;
  end;

  [MVCNameCase(ncSnakeCase)]
  TProductividadAsesorDTO = class
  private
    fAsesorId: Integer;
    fAsesorNombre: string;
    fSolicitudesMes: Integer;
    fAprobadasMes: Integer;
    fMontoAprobadoMes: NullableCurrency;
  public
    property AsesorId: Integer read fAsesorId write fAsesorId;
    property AsesorNombre: string read fAsesorNombre write fAsesorNombre;
    property SolicitudesMes: Integer read fSolicitudesMes write fSolicitudesMes;
    property AprobadasMes: Integer read fAprobadasMes write fAprobadasMes;
    property MontoAprobadoMes: NullableCurrency read fMontoAprobadoMes
      write fMontoAprobadoMes;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCotizacionesPorEstadoDTO = class
  private
    fEstado: string;
    fCantidad: Integer;
    fMonto: NullableCurrency;
  public
    property Estado: string read fEstado write fEstado;
    property Cantidad: Integer read fCantidad write fCantidad;
    property Monto: NullableCurrency read fMonto write fMonto;
  end;

  [MVCNameCase(ncSnakeCase)]
  TDashboardGerenciaDTO = class
  private
    fDesde: TDateTime;
    fHasta: TDateTime;
    fCotizadoMes: Currency;
    fAprobadasMes: Integer;
    fRechazadasMes: Integer;
    fTasaAprobacion: Currency;
    fRespuestaMedia: Integer;
    fAsesoresActivos: Integer;
    fProductividad: TObjectList<TProductividadAsesorDTO>;
    fEstados: TObjectList<TCotizacionesPorEstadoDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property Desde: TDateTime read fDesde write fDesde;
    property Hasta: TDateTime read fHasta write fHasta;
    property CotizadoMes: Currency read fCotizadoMes write fCotizadoMes;
    property AprobadasMes: Integer read fAprobadasMes write fAprobadasMes;
    property RechazadasMes: Integer read fRechazadasMes write fRechazadasMes;
    property TasaAprobacion: Currency read fTasaAprobacion write fTasaAprobacion;
    property RespuestaMedia: Integer read fRespuestaMedia write fRespuestaMedia;
    property AsesoresActivos: Integer read fAsesoresActivos write fAsesoresActivos;
    property Productividad: TObjectList<TProductividadAsesorDTO> read fProductividad
      write fProductividad;
    property Estados: TObjectList<TCotizacionesPorEstadoDTO> read fEstados
      write fEstados;
  end;

  [MVCNameCase(ncSnakeCase)]
  TCambioCuentaDTO = class
  private
    fID: Integer;
    fFecha: NullableTDateTime;
    fUsuarioNombre: string;
    fAccion: string;
    fDetalle: string;
  public
    property ID: Integer read fID write fID;
    property Fecha: NullableTDateTime read fFecha write fFecha;
    property UsuarioNombre: string read fUsuarioNombre write fUsuarioNombre;
    property Accion: string read fAccion write fAccion;
    property Detalle: string read fDetalle write fDetalle;
  end;

  [MVCNameCase(ncSnakeCase)]
  TDashboardCuentasDTO = class
  private
    fDesde: TDateTime;
    fHasta: TDateTime;
    fUsuariosActivos: Integer;
    fUsuariosInactivos: Integer;
    fClavePendiente: Integer;
    fCambiosMes: Integer;
    fCambios: TObjectList<TCambioCuentaDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property Desde: TDateTime read fDesde write fDesde;
    property Hasta: TDateTime read fHasta write fHasta;
    property UsuariosActivos: Integer read fUsuariosActivos write fUsuariosActivos;
    property UsuariosInactivos: Integer read fUsuariosInactivos write fUsuariosInactivos;
    property ClavePendiente: Integer read fClavePendiente write fClavePendiente;
    property CambiosMes: Integer read fCambiosMes write fCambiosMes;
    property Cambios: TObjectList<TCambioCuentaDTO> read fCambios
      write fCambios;
  end;

  [MVCNameCase(ncSnakeCase)]
  TAvisosDTO = class
  private
    fPorAprobar: Integer;
    fPorCotizar: Integer;
    fMisBorradores: Integer;
  public
    property PorAprobar: Integer read fPorAprobar write fPorAprobar;
    property PorCotizar: Integer read fPorCotizar write fPorCotizar;
    property MisBorradores: Integer read fMisBorradores write fMisBorradores;
  end;

implementation

constructor TDashboardAsesorDTO.Create;
begin
  inherited Create;
  fRecientes := TObjectList<TSolicitudAsesorDTO>.Create(True);
  fPorEstado := TObjectList<TDashboardBarraDTO>.Create(True);
  fPorLlamar := TObjectList<TDashboardAvisoDTO>.Create(True);
end;

destructor TDashboardAsesorDTO.Destroy;
begin
  fPorLlamar.Free;
  fPorEstado.Free;
  fRecientes.Free;
  inherited;
end;

constructor TDashboardAsistenteDTO.Create;
begin
  inherited Create;
  fCola := TObjectList<TSolicitudPorCotizarDTO>.Create(True);
  fPorEtapa := TObjectList<TDashboardBarraDTO>.Create(True);
  fParaHoy := TObjectList<TDashboardAvisoDTO>.Create(True);
  fMiMes := TObjectList<TDashboardDatoDTO>.Create(True);
end;

destructor TDashboardAsistenteDTO.Destroy;
begin
  fMiMes.Free;
  fParaHoy.Free;
  fPorEtapa.Free;
  fCola.Free;
  inherited;
end;

constructor TDashboardSupervisorDTO.Create;
begin
  inherited Create;
  fCola := TObjectList<TCotizacionPorAprobarDTO>.Create(True);
  fCarga := TObjectList<TDashboardBarraDTO>.Create(True);
  fEstancadas := TObjectList<TDashboardAvisoDTO>.Create(True);
end;

destructor TDashboardSupervisorDTO.Destroy;
begin
  fEstancadas.Free;
  fCarga.Free;
  fCola.Free;
  inherited;
end;

constructor TDashboardGerenciaDTO.Create;
begin
  inherited Create;
  fProductividad := TObjectList<TProductividadAsesorDTO>.Create(True);
  fEstados := TObjectList<TCotizacionesPorEstadoDTO>.Create(True);
end;

destructor TDashboardGerenciaDTO.Destroy;
begin
  fEstados.Free;
  fProductividad.Free;
  inherited;
end;

constructor TDashboardCuentasDTO.Create;
begin
  inherited Create;
  fCambios := TObjectList<TCambioCuentaDTO>.Create(True);
end;

destructor TDashboardCuentasDTO.Destroy;
begin
  fCambios.Free;
  inherited;
end;

end.
