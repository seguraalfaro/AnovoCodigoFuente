unit Anovo.DTOs.Dispositivos;

// DTOs de /api/auth: registro del dispositivo, renovacion de la sesion
// con la llave y cierre.

interface

uses
  MVCFramework.Serializer.Commons;

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
  public
    property Llave: string read fLlave write fLlave;
    property Vence: TDateTime read fVence write fVence;
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
