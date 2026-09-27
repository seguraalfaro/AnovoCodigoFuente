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
    fFechaPresentada: NullableTDateTime;
    fClienteNombre: string;
    fElaboradaPorNombre: string;
    fMontoTotal: NullableCurrency;
    fDiasEspera: NullableInt32;
  public
    property ID: Integer read fID write fID;
    property Numero: Integer read fNumero write fNumero;
    property FechaPresentada: NullableTDateTime read fFechaPresentada
      write fFechaPresentada;
    property ClienteNombre: string read fClienteNombre write fClienteNombre;
    property ElaboradaPorNombre: string read fElaboradaPorNombre
      write fElaboradaPorNombre;
    property MontoTotal: NullableCurrency read fMontoTotal write fMontoTotal;
    property DiasEspera: NullableInt32 read fDiasEspera write fDiasEspera;
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

end.
