unit Anovo.Services.Intf.Correo;

// Contrato del correo saliente: el resto del sistema no sabe de SMTP ni de
// OAuth2, solo arma el mensaje.

interface

uses
  System.SysUtils,
  Anovo.DTOs.Correo;

type
  TMensajeCorreo = class
  private
    fPara: TArray<string>;
    fCopia: TArray<string>;
    fAsunto: string;
    fTexto: string;
    fNombreAdjunto: string;
    fAdjunto: TBytes;
  public
    property Para: TArray<string> read fPara write fPara;
    property Copia: TArray<string> read fCopia write fCopia;
    property Asunto: string read fAsunto write fAsunto;
    property Texto: string read fTexto write fTexto;
    property NombreAdjunto: string read fNombreAdjunto write fNombreAdjunto;
    property Adjunto: TBytes read fAdjunto write fAdjunto;
  end;

  ICorreoService = interface
    ['{4F8B2C61-9A37-4E05-B1D8-2C6E7A90F315}']
    function Estado: TEstadoCorreoDTO;
    function Remitente: string;
    function Modo: string;
    procedure Enviar(const AMensaje: TMensajeCorreo);
  end;

implementation

end.
