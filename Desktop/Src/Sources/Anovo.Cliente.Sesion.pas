unit Anovo.Cliente.Sesion;

interface

type
  TSesion = class
  private
    class

      var FUsuario: string;
    class var FNombre: string;
    class var FRol: string;
    class var FToken: string;
  public
    class procedure Iniciar(const AUsuario, ANombre, ARol, AToken: string);
    class procedure Cerrar;
    class function Activa: Boolean;

    class property Usuario: string read FUsuario;
    class property Nombre: string read FNombre;
    class property Rol: string read FRol;
    class property Token: string read FToken;
  end;

implementation

class procedure TSesion.Iniciar(const AUsuario, ANombre, ARol, AToken: string);
begin
  FUsuario := AUsuario;
  FNombre := ANombre;
  FRol := ARol;
  FToken := AToken; // solo memoria
end;

class procedure TSesion.Cerrar;
begin
  FUsuario := '';
  FNombre := '';
  FRol := '';
  FToken := '';
end;

class function TSesion.Activa: Boolean;
begin
  Result := FUsuario <> '';
end;

end.
