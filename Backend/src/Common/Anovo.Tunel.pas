unit Anovo.Tunel;

// Corre cloudflared como proceso hijo sin consola, lee su salida linea por
// linea y cuenta las conexiones registradas con Cloudflare.

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Anovo.Tunel.Config;

type
  TLineaTunel = reference to procedure(const ALinea: string);

  TLectorTunel = class(TThread)
  private
    FLectura: THandle;
    FOnLinea: TLineaTunel;
    FOnTermino: TProc;
    procedure Entregar(const ALinea: string);
  protected
    procedure Execute; override;
  public
    constructor Create(ALectura: THandle; const AOnLinea: TLineaTunel;
      const AOnTermino: TProc);
  end;

  TTunel = class
  private
    FProceso: THandle;
    FTrabajo: THandle;
    FLectura: THandle;
    FLector: TLectorTunel;
    FConexiones: Cardinal;
    FOnLinea: TLineaTunel;
    FOnCambio: TProc;
    procedure Procesar(const ALinea: string);
    procedure Terminado;
    procedure Liberar;
    function IndiceDe(const ALinea: string): Integer;
  public
    constructor Create(const AOnLinea: TLineaTunel; const AOnCambio: TProc);
    destructor Destroy; override;
    procedure Iniciar(const AConfig: TConfigTunel);
    procedure Detener;
    function Corriendo: Boolean;
    function Conexiones: Integer;
  end;

implementation

uses
  System.StrUtils;

const
  TAMANO_BLOQUE = 4096;
  ESPERA_CIERRE_MS = 5000;
  TEXTO_REGISTRADA = 'Registered tunnel connection';
  TEXTO_DESREGISTRADA = 'Unregistered tunnel connection';
  TEXTO_TERMINADA = 'Connection terminated';
  TEXTO_INDICE = 'connIndex=';

constructor TLectorTunel.Create(ALectura: THandle; const AOnLinea: TLineaTunel;
  const AOnTermino: TProc);
begin
  FLectura := ALectura;
  FOnLinea := AOnLinea;
  FOnTermino := AOnTermino;
  FreeOnTerminate := False;
  inherited Create(False);
end;

procedure TLectorTunel.Entregar(const ALinea: string);
var
  lLinea: string;
begin
  lLinea := ALinea.TrimRight;
  if lLinea.IsEmpty then
    Exit;
  Queue(
    procedure
    begin
      FOnLinea(lLinea);
    end);
end;

procedure TLectorTunel.Execute;
var
  lBloque: array [0 .. TAMANO_BLOQUE - 1] of Byte;
  lLeidos: DWORD;
  lPendiente: TBytes;
  lFin, lInicio, I: Integer;
begin
  lPendiente := nil;
  while not Terminated do
  begin
    if not ReadFile(FLectura, lBloque, TAMANO_BLOQUE, lLeidos, nil) or
      (lLeidos = 0) then
      Break;
    lInicio := Length(lPendiente);
    SetLength(lPendiente, lInicio + Integer(lLeidos));
    Move(lBloque, lPendiente[lInicio], lLeidos);
    lInicio := 0;
    for I := 0 to High(lPendiente) do
      if lPendiente[I] = 10 then
      begin
        Entregar(TEncoding.UTF8.GetString(lPendiente, lInicio, I - lInicio));
        lInicio := I + 1;
      end;
    lFin := Length(lPendiente) - lInicio;
    lPendiente := Copy(lPendiente, lInicio, lFin);
  end;
  if Length(lPendiente) > 0 then
    Entregar(TEncoding.UTF8.GetString(lPendiente));
  Queue(
    procedure
    begin
      FOnTermino();
    end);
end;

constructor TTunel.Create(const AOnLinea: TLineaTunel; const AOnCambio: TProc);
begin
  inherited Create;
  FOnLinea := AOnLinea;
  FOnCambio := AOnCambio;
end;

destructor TTunel.Destroy;
begin
  Detener;
  inherited;
end;

function TTunel.Corriendo: Boolean;
begin
  Result := (FProceso <> 0) and
    (WaitForSingleObject(FProceso, 0) = WAIT_TIMEOUT);
end;

function TTunel.Conexiones: Integer;
var
  lBits: Cardinal;
begin
  Result := 0;
  lBits := FConexiones;
  while lBits <> 0 do
  begin
    Inc(Result, lBits and 1);
    lBits := lBits shr 1;
  end;
end;

procedure TTunel.Iniciar(const AConfig: TConfigTunel);
var
  lSeguridad: TSecurityAttributes;
  lEscritura: THandle;
  lInicio: TStartupInfo;
  lInfo: TProcessInformation;
  lLimite: TJobObjectExtendedLimitInformation;
  lLinea: string;
begin
  if Corriendo then
    Exit;
  Liberar;

  lSeguridad := Default(TSecurityAttributes);
  lSeguridad.nLength := SizeOf(lSeguridad);
  lSeguridad.bInheritHandle := True;
  if not CreatePipe(FLectura, lEscritura, @lSeguridad, 0) then
    RaiseLastOSError;
  SetHandleInformation(FLectura, HANDLE_FLAG_INHERIT, 0);

  lInicio := Default(TStartupInfo);
  lInicio.cb := SizeOf(lInicio);
  lInicio.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
  lInicio.wShowWindow := SW_HIDE;
  lInicio.hStdOutput := lEscritura;
  lInicio.hStdError := lEscritura;
  lInicio.hStdInput := GetStdHandle(STD_INPUT_HANDLE);

  lLinea := '"' + AConfig.Exe + '" ' + AConfig.Parametros;
  UniqueString(lLinea);
  try
    if not CreateProcess(nil, PChar(lLinea), nil, nil, True,
      CREATE_NO_WINDOW or CREATE_SUSPENDED, nil,
      PChar(ExtractFilePath(AConfig.Exe)), lInicio, lInfo) then
      RaiseLastOSError;
  finally
    CloseHandle(lEscritura);
  end;

  FProceso := lInfo.hProcess;
  FTrabajo := CreateJobObject(nil, nil);
  if FTrabajo <> 0 then
  begin
    lLimite := Default(TJobObjectExtendedLimitInformation);
    lLimite.BasicLimitInformation.LimitFlags :=
      JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;
    SetInformationJobObject(FTrabajo, JobObjectExtendedLimitInformation, @lLimite,
      SizeOf(lLimite));
    AssignProcessToJobObject(FTrabajo, FProceso);
  end;
  ResumeThread(lInfo.hThread);
  CloseHandle(lInfo.hThread);

  FConexiones := 0;
  FLector := TLectorTunel.Create(FLectura, Procesar, Terminado);
  FOnCambio();
end;

procedure TTunel.Detener;
begin
  if FProceso = 0 then
    Exit;
  if Corriendo then
  begin
    TerminateProcess(FProceso, 0);
    WaitForSingleObject(FProceso, ESPERA_CIERRE_MS);
  end;
  Liberar;
  FOnCambio();
end;

procedure TTunel.Liberar;
begin
  if FLector <> nil then
  begin
    FLector.Terminate;
    FLector.WaitFor;
    TThread.RemoveQueuedEvents(FLector);
    FreeAndNil(FLector);
  end;
  if FLectura <> 0 then
    CloseHandle(FLectura);
  if FProceso <> 0 then
    CloseHandle(FProceso);
  if FTrabajo <> 0 then
    CloseHandle(FTrabajo);
  FLectura := 0;
  FProceso := 0;
  FTrabajo := 0;
  FConexiones := 0;
end;

function TTunel.IndiceDe(const ALinea: string): Integer;
var
  lPos, lFin: Integer;
begin
  Result := -1;
  lPos := Pos(TEXTO_INDICE, ALinea);
  if lPos = 0 then
    Exit;
  lPos := lPos + Length(TEXTO_INDICE);
  lFin := lPos;
  while (lFin <= Length(ALinea)) and CharInSet(ALinea[lFin], ['0' .. '9']) do
    Inc(lFin);
  Result := StrToIntDef(Copy(ALinea, lPos, lFin - lPos), -1);
  if Result > 31 then
    Result := -1;
end;

procedure TTunel.Procesar(const ALinea: string);
var
  lIndice: Integer;
  lAntes: Cardinal;
begin
  FOnLinea(ALinea);
  lIndice := IndiceDe(ALinea);
  if lIndice < 0 then
    Exit;
  lAntes := FConexiones;
  if ContainsText(ALinea, TEXTO_DESREGISTRADA) or
    ContainsText(ALinea, TEXTO_TERMINADA) then
    FConexiones := FConexiones and not(Cardinal(1) shl lIndice)
  else if ContainsText(ALinea, TEXTO_REGISTRADA) then
    FConexiones := FConexiones or (Cardinal(1) shl lIndice);
  if FConexiones <> lAntes then
    FOnCambio();
end;

procedure TTunel.Terminado;
begin
  FConexiones := 0;
  FOnCambio();
end;

end.
