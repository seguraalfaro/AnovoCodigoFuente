unit Anovo.Services.Permisos;

// Cache de la matriz rol-permiso.
//
// Una sola instancia para todo el servidor y varias peticiones a la vez: todo
// pasa por el candado. Son 57 pares; el candado solo se nota en la primera
// carga, que es la unica vez que se espera a la base.
//
// TPermisoService es lo que usan el handler y los controllers. La cache no la
// toca nadie mas: asi la carga perezosa vive en un solo sitio.

interface

uses
  MVCFramework,
  System.SyncObjs,
  System.Generics.Collections,
  Anovo.Repositories.Intf.Permisos,
  Anovo.Services.Intf.Permisos;

type
  TPermisoCache = class(TInterfacedObject, IPermisoCache)
  private
    fCandado: TCriticalSection;
    fPares: TArray<TRolPermiso>;
    fIndice: TDictionary<string, Boolean>;
    fCargada: Boolean;
    class function Llave(const ARol, APermiso: string): string; static;
  public
    constructor Create;
    destructor Destroy; override;
    function Cargada: Boolean;
    procedure Cargar(const AMatriz: TArray<TRolPermiso>);
    procedure Invalidar;
    function Tiene(const ARol, APermiso: string): Boolean;
    function PermisosDe(const ARol: string): TArray<string>;
  end;

  TPermisoService = class(TInterfacedObject, IPermisoService)
  private
    fRepo: IPermisoRepository;
    fCache: IPermisoCache;
    procedure AsegurarCargada;
  public
    [MVCInject]
    constructor Create(ARepo: IPermisoRepository; ACache: IPermisoCache);
      reintroduce;
    function Tiene(const ARol, APermiso: string): Boolean;
    function PermisosDe(const ARol: string): TArray<string>;
  end;

implementation

uses
  System.SysUtils;

{ TPermisoCache }

constructor TPermisoCache.Create;
begin
  inherited Create;
  fCandado := TCriticalSection.Create;
  fIndice := TDictionary<string, Boolean>.Create;
end;

destructor TPermisoCache.Destroy;
begin
  fIndice.Free;
  fCandado.Free;
  inherited;
end;

class function TPermisoCache.Llave(const ARol, APermiso: string): string;
begin
  Result := LowerCase(ARol) + #9 + LowerCase(APermiso);
end;

function TPermisoCache.Cargada: Boolean;
begin
  fCandado.Enter;
  try
    Result := fCargada;
  finally
    fCandado.Leave;
  end;
end;

procedure TPermisoCache.Cargar(const AMatriz: TArray<TRolPermiso>);
var
  lPar: TRolPermiso;
begin
  fCandado.Enter;
  try
    fIndice.Clear;
    for lPar in AMatriz do
      fIndice.AddOrSetValue(Llave(lPar.Rol, lPar.Permiso), True);
    fPares := AMatriz;
    fCargada := True;
  finally
    fCandado.Leave;
  end;
end;

procedure TPermisoCache.Invalidar;
begin
  fCandado.Enter;
  try
    fCargada := False;
  finally
    fCandado.Leave;
  end;
end;

function TPermisoCache.Tiene(const ARol, APermiso: string): Boolean;
begin
  fCandado.Enter;
  try
    Result := fIndice.ContainsKey(Llave(ARol, APermiso));
  finally
    fCandado.Leave;
  end;
end;

function TPermisoCache.PermisosDe(const ARol: string): TArray<string>;
var
  lPar: TRolPermiso;
  lLista: TList<string>;
begin
  fCandado.Enter;
  try
    lLista := TList<string>.Create;
    try
      for lPar in fPares do
        if SameText(lPar.Rol, ARol) then
          lLista.Add(lPar.Permiso);
      Result := lLista.ToArray;
    finally
      lLista.Free;
    end;
  finally
    fCandado.Leave;
  end;
end;

{ TPermisoService }

constructor TPermisoService.Create(ARepo: IPermisoRepository;
  ACache: IPermisoCache);
begin
  inherited Create;
  fRepo := ARepo;
  fCache := ACache;
end;

procedure TPermisoService.AsegurarCargada;
begin
  // Si dos peticiones llegan a la vez con la cache vacia las dos cargan; da
  // igual, cargan lo mismo.
  if not fCache.Cargada then
    fCache.Cargar(fRepo.Matriz);
end;

function TPermisoService.Tiene(const ARol, APermiso: string): Boolean;
begin
  AsegurarCargada;
  Result := fCache.Tiene(ARol, APermiso);
end;

function TPermisoService.PermisosDe(const ARol: string): TArray<string>;
begin
  AsegurarCargada;
  Result := fCache.PermisosDe(ARol);
end;

end.
