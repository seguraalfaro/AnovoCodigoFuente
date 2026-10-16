unit Anovo.DTOs.Dispositivos;

// DTOs de /api/auth: registro del dispositivo, renovacion de la sesion
// con la llave y cierre.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables;

type
  [MVCNameCase(ncSnakeCase)]
  TDispositivoNuevoDTO = class
  private
    fUuidDispositivo: string;
    fNombre: string;
  public
    property UuidDispositivo: string read fUuidDispositivo
      write fUuidDispositivo;
    property Nombre: string read fNombre write fNombre;
  end;

  [MVCNameCase(ncSnakeCase)]
  TLlaveDispositivoDTO = class
  private
    fLlave: string;
    fVence: TDateTime;
    fToken: string;
  public
    property Llave: string read fLlave write fLlave;
    property Vence: TDateTime read fVence write fVence;
    property Token: string read fToken write fToken;
  end;

  [MVCNameCase(ncSnakeCase)]
  TDispositivoDTO = class
  private
    fID: Integer;
    fNombre: NullableString;
    fActivo: Boolean;
    fMotivo: NullableString;
    fFechaCreacion: NullableTDateTime;
    fFechaUltimoUso: NullableTDateTime;
    fFechaVence: TDateTime;
  public
    property ID: Integer read fID write fID;
    property Nombre: NullableString read fNombre write fNombre;
    property Activo: Boolean read fActivo write fActivo;
    property Motivo: NullableString read fMotivo write fMotivo;
    property FechaCreacion: NullableTDateTime read fFechaCreacion
      write fFechaCreacion;
    property FechaUltimoUso: NullableTDateTime read fFechaUltimoUso
      write fFechaUltimoUso;
    property FechaVence: TDateTime read fFechaVence write fFechaVence;
  end;

  [MVCNameCase(ncSnakeCase)]
  TRenovacionDTO = class
  private
    fUuidDispositivo: string;
    fLlave: string;
  public
    property UuidDispositivo: string read fUuidDispositivo
      write fUuidDispositivo;
    property Llave: string read fLlave write fLlave;
  end;

  [MVCNameCase(ncSnakeCase)]
  TSesionRenovadaDTO = class
  private
    fToken: string;
    fLlave: string;
    fVence: TDateTime;
  public
    property Token: string read fToken write fToken;
    property Llave: string read fLlave write fLlave;
    property Vence: TDateTime read fVence write fVence;
  end;

implementation

end.
