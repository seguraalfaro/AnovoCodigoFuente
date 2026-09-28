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
  TDashboardAsesorDTO = class
  private
    fDesde: TDateTime;
    fHasta: TDateTime;
    fSolicitudesMes: Integer;
    fEsperandoCotizacion: Integer;
    fAprobadasMes: Integer;
    fMontoAprobadoMes: Currency;
    fRecientes: TObjectList<TSolicitudAsesorDTO>;
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
    property Recientes: TObjectList<TSolicitudAsesorDTO> read fRecientes
      write fRecientes;
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
    fCola: TObjectList<TSolicitudPorCotizarDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    property PorCotizar: Integer read fPorCotizar write fPorCotizar;
    property MisBorradores: Integer read fMisBorradores write fMisBorradores;
    property EnAprobacion: Integer read fEnAprobacion write fEnAprobacion;
    property PorEnviar: Integer read fPorEnviar write fPorEnviar;
    property Cola: TObjectList<TSolicitudPorCotizarDTO> read fCola
      write fCola;
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
    fCola: TObjectList<TCotizacionPorAprobarDTO>;
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
    property Cola: TObjectList<TCotizacionPorAprobarDTO> read fCola
      write fCola;
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
    fTasaAprobacion: Integer;
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
    property TasaAprobacion: Integer read fTasaAprobacion write fTasaAprobacion;
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
end;

destructor TDashboardAsesorDTO.Destroy;
begin
  fRecientes.Free;
  inherited;
end;

constructor TDashboardAsistenteDTO.Create;
begin
  inherited Create;
  fCola := TObjectList<TSolicitudPorCotizarDTO>.Create(True);
end;

destructor TDashboardAsistenteDTO.Destroy;
begin
  fCola.Free;
  inherited;
end;

constructor TDashboardSupervisorDTO.Create;
begin
  inherited Create;
  fCola := TObjectList<TCotizacionPorAprobarDTO>.Create(True);
end;

destructor TDashboardSupervisorDTO.Destroy;
begin
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
