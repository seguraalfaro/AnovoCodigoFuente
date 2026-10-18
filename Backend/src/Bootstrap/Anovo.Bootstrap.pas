unit Anovo.Bootstrap;

// Arranque: .env, LoggerPro y profiler de DMVC.
// Se llama una vez, antes de cualquier log.

interface

uses
  LoggerPro;

procedure Boot(const AAppender: ILogAppender = nil;
  const AConConsola: Boolean = True);

implementation

uses
  System.SysUtils,
  LoggerPro.Builder,
  LoggerPro.ConsoleAppender,
  LoggerPro.FileAppender,
  MVCFramework.Logger.ColorConsoleRenderer,
  MVCFramework.DotEnv,
  MVCFramework.Commons,
  MVCFramework.Logger;

procedure ConfigDotEnv;
begin
  dotEnvConfigure(
    function: IMVCDotEnv
    begin
      Result := NewDotEnv
                 .UseStrategy(TMVCDotEnvPriority.FileThenEnv)
                 .UseProfile('test')
                 .UseProfile('prod')
                 .Build(AppPath);
    end);
end;

procedure ConfigLogger(const AAppender: ILogAppender;
  const AConConsola: Boolean);
var
  lBuilder: ILoggerProBuilder;

begin
  lBuilder := LoggerProBuilder.WithDefaultMinimumLevel(TLogType.Debug);

  if AConConsola then
    lBuilder := lBuilder
      .WriteToConsole
        .WithUTF8Output
        .WithRenderer(TMVCColorConsoleRenderer.Create)
        .Done;

  if AAppender <> nil then
    lBuilder := lBuilder.WriteToAppender(AAppender);

  lBuilder := lBuilder
    .WriteToFile
      .WithLogsFolder(dotEnv.Env('logger.file.folder', 'logs'))
      .WithFileBaseName(dotEnv.Env('logger.file.basename', 'AnovoAPI'))
      .WithMaxFileSizeInKB(dotEnv.Env('logger.file.max_kb', 10000))
      .WithMaxBackupFiles(dotEnv.Env('logger.file.max_backups', 5))
      .Done
    ;

  SetDefaultLogger(lBuilder.Build);
end;

procedure ConfigProfiler;
begin
{$IF CompilerVersion >= 34}
  if dotEnv.Env('dmvc.profiler.enabled', False) then
  begin
    Profiler.ProfileLogger := Log;
    Profiler.WarningThreshold := dotEnv.Env('dmvc.profiler.warning_threshold', 1000);
    Profiler.LogsOnlyIfOverThreshold := dotEnv.Env('dmvc.profiler.logs_only_over_threshold', True);
  end;
{$ENDIF}
end;

procedure Boot(const AAppender: ILogAppender; const AConConsola: Boolean);
begin
  ConfigDotEnv;
  ConfigLogger(AAppender, AConConsola);
  ConfigProfiler;
end;

end.
