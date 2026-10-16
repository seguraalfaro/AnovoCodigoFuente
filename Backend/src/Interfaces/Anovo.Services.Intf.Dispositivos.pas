unit Anovo.Services.Intf.Dispositivos;

// Contrato del servicio de dispositivos: llave por telefono para renovar
// la sesion sin pedir la clave.

interface

uses
  System.Generics.Collections,
  Anovo.DTOs.Dispositivos;

const
  MOTIVO_CIERRE = 'cierre';
  MOTIVO_REUSO = 'reuso';
  MOTIVO_CLAVE = 'clave';
  MOTIVO_USUARIO = 'usuario';
  MOTIVO_REEMPLAZO = 'reemplazo';
  MOTIVO_VENCIDO = 'vencido';
  MOTIVO_ADMIN = 'admin';

type
  IDispositivoService = interface
    ['{A7D41C38-6E2F-4B95-8C07-1F3E9B5D2A64}']
    function Registrar(const AUsuarioId: Integer;
      const ADto: TDispositivoNuevoDTO): TLlaveDispositivoDTO;
    function Renovar(const ADto: TRenovacionDTO): TSesionRenovadaDTO;
    procedure Cerrar(const ADto: TRenovacionDTO);
    function DeUsuario(const AUsuarioId: Integer): TObjectList<TDispositivoDTO>;
    procedure InactivarPorAdmin(const AUsuarioId, ADispositivoId: Integer);
  end;

implementation

end.
