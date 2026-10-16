unit Anovo.Mensajes;

// Mensajes entre pantallas con System.Messaging: una pantalla avisa y
// la ventana principal responde, sin que se conozcan.

interface

uses
  System.Messaging,
  Anovo.Vistas.Intf.Principal;

type
  TMensajeAvisos = class(TMessage);
  TMensajeNavegar = class(TMessage<TSeccion>);
  TMensajeAbrirCotizacion = class(TMessage<Integer>);

procedure AvisarCambioEnAvisos;
procedure PedirSeccion(const ASeccion: TSeccion);
procedure PedirCotizacion(const AId: Integer);

implementation

procedure AvisarCambioEnAvisos;
begin
  TMessageManager.DefaultManager.SendMessage(nil, TMensajeAvisos.Create, True);
end;

procedure PedirSeccion(const ASeccion: TSeccion);
begin
  TMessageManager.DefaultManager.SendMessage(nil,
    TMensajeNavegar.Create(ASeccion), True);
end;

procedure PedirCotizacion(const AId: Integer);
begin
  TMessageManager.DefaultManager.SendMessage(nil,
    TMensajeAbrirCotizacion.Create(AId), True);
end;

end.
