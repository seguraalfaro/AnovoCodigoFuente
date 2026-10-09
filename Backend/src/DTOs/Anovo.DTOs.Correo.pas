unit Anovo.DTOs.Correo;

// DTOs del envio de la cotizacion por correo. Compartidos con el escritorio.

interface

uses
  MVCFramework.Serializer.Commons;

type

  [MVCNameCase(ncSnakeCase)]
  TEnvioCorreoDTO = class
  private
    fPara: string;
    fCc: string;
    fAsunto: string;
    fMensaje: string;
    fPdf: string;
  public
    property Para: string read fPara write fPara;
    property Cc: string read fCc write fCc;
    property Asunto: string read fAsunto write fAsunto;
    property Mensaje: string read fMensaje write fMensaje;
    property Pdf: string read fPdf write fPdf;
  end;

  [MVCNameCase(ncSnakeCase)]
  TEstadoCorreoDTO = class
  private
    fConfigurado: Boolean;
    fModo: string;
    fRemitente: string;
  public
    property Configurado: Boolean read fConfigurado write fConfigurado;
    property Modo: string read fModo write fModo;
    property Remitente: string read fRemitente write fRemitente;
  end;

implementation

end.
