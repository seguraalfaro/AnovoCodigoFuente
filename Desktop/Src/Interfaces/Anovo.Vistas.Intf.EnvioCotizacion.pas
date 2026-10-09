unit Anovo.Vistas.Intf.EnvioCotizacion;

// Contrato de la ventana Enviar al cliente: desde el servidor o manualmente.

interface

uses
  Anovo.DTOs.Correo;

type
  IVistaEnvioCotizacion = interface
    ['{B27E4D19-6A53-4C08-9E1F-3D8A5C26E741}']
    procedure MostrarCargando(const AActivo: Boolean);
    procedure MostrarError(const AMensaje: string);
    function Confirmar(const AMensaje: string): Boolean;
    procedure MostrarDatos(const ADatos: TEnvioCorreoDTO);
    procedure MostrarServidor(const ADisponible: Boolean;
      const AAviso: string);
    procedure Enviado(const AMensaje: string);
  end;

implementation

end.
