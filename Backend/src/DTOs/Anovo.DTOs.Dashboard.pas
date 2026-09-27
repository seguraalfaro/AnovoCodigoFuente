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

end.
