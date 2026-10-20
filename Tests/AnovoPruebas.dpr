program AnovoPruebas;

// Pruebas unitarias automatizadas (DUnitX) del backend y del escritorio.
// Deja el resultado en consola y en AnovoPruebas.xml (formato NUnit).

{$APPTYPE CONSOLE}
{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  Anovo.Pruebas.Permisos.Cache in 'Anovo.Pruebas.Permisos.Cache.pas',
  Anovo.Pruebas.Permisos.Controllers in 'Anovo.Pruebas.Permisos.Controllers.pas',
  Anovo.Pruebas.Menu in 'Anovo.Pruebas.Menu.pas',
  Anovo.Pruebas.Plazos in 'Anovo.Pruebas.Plazos.pas',
  Anovo.Pruebas.PeriodoBusqueda in 'Anovo.Pruebas.PeriodoBusqueda.pas',
  Anovo.Pruebas.TotalesCotizacion in 'Anovo.Pruebas.TotalesCotizacion.pas',
  Anovo.Pruebas.Catalogos in 'Anovo.Pruebas.Catalogos.pas';

const
  ARCHIVO_RESULTADOS = 'AnovoPruebas.xml';

var
  lCorredor: ITestRunner;
  lResultados: IRunResults;
begin
  try
    TDUnitX.CheckCommandLine;
    lCorredor := TDUnitX.CreateRunner;
    lCorredor.UseRTTI := True;
    lCorredor.FailsOnNoAsserts := True;
    lCorredor.AddLogger(TDUnitXConsoleLogger.Create(False));
    lCorredor.AddLogger(TDUnitXXMLNUnitFileLogger.Create
      (ExtractFilePath(ParamStr(0)) + ARCHIVO_RESULTADOS));
    lResultados := lCorredor.Execute;
    if not lResultados.AllPassed then
      System.ExitCode := EXIT_ERRORS;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      System.ExitCode := EXIT_ERRORS;
    end;
  end;
end.
