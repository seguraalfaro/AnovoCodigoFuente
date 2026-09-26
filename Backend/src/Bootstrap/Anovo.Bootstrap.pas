// ***************************************************************************
//
// Delphi MVC Framework
//
// Copyright (c) 2010-2026 Daniele Teti and the DMVCFramework Team
//
// https://github.com/danieleteti/delphimvcframework
//
// ***************************************************************************

unit Anovo.Bootstrap;

// Startup configuration: dotEnv, LoggerPro, DMVC profiler, TemplatePro context.
// Call Boot once, before any LogI/LogW/LogE call.

interface

uses
  LoggerPro;

// AAppender es por donde la ventana del servidor mete su propio destino de
// log. Bootstrap no sabe que existe VCL: solo ve la interfaz.
//
// AConConsola en falso para la version con ventana: una aplicacion grafica no
// tiene consola donde escribir.
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

{ --- private ---------------------------------------------------------------- }

procedure ConfigDotEnv;
begin
  // .UseLogger intentionally omitted: the dotEnv fallback calls LogI, which would
  // create a default logger before ConfigLogger installs the configured one.
  dotEnvConfigure(
    function: IMVCDotEnv
    begin
      Result := NewDotEnv
                 .UseStrategy(TMVCDotEnvPriority.FileThenEnv)
                                     //if available, by default, loads default environment (.env)
                 .UseProfile('test') //if available loads the test environment (.env.test)
                 .UseProfile('prod') //if available loads the prod environment (.env.prod)
                 .Build(AppPath);    //uses the executable folder to look for .env* files
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
      .WithFileBaseName(dotEnv.Env('logger.file.basename', 'DMVCFrameworkProject1'))
      .WithMaxFileSizeInKB(dotEnv.Env('logger.file.max_kb', 10000))
      .WithMaxBackupFiles(dotEnv.Env('logger.file.max_backups', 5))
      .Done
    ;


  SetDefaultLogger(lBuilder.Build);
end;

procedure ConfigProfiler;
begin
{$IF CompilerVersion >= 34} //SYDNEY+
  if dotEnv.Env('dmvc.profiler.enabled', False) then
  begin
    Profiler.ProfileLogger := Log;
    Profiler.WarningThreshold := dotEnv.Env('dmvc.profiler.warning_threshold', 1000);
    Profiler.LogsOnlyIfOverThreshold := dotEnv.Env('dmvc.profiler.logs_only_over_threshold', True);
  end;
{$ENDIF}
end;

{ --- public ----------------------------------------------------------------- }

procedure Boot(const AAppender: ILogAppender; const AConConsola: Boolean);
begin
  ConfigDotEnv;
  ConfigLogger(AAppender, AConConsola);
  ConfigProfiler;
end;

end.
