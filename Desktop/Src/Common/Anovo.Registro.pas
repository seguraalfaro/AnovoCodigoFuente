unit Anovo.Registro;

// Registro de llamadas a la API en un archivo de texto junto al
// ejecutable: verbo, ruta, estado y milisegundos, desde cualquier hilo.

interface

procedure RegistrarLlamada(const AVerbo, ARuta: string;
  const AEstado: Integer; const AMilisegundos: Int64;
  const ADetalle: string = '');

implementation

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils;

const
  TAMANO_MAXIMO = 2 * 1024 * 1024;
  SUFIJO_LOG = '.llamadas.log';
  SUFIJO_ANTERIOR = '.llamadas.1.log';

var
  Candado: TObject;

function RutaLog: string;
begin
  Result := ChangeFileExt(ParamStr(0), SUFIJO_LOG);
end;

function Tamano(const ARuta: string): Int64;
var
  lDatos: TSearchRec;
begin
  Result := 0;
  if FindFirst(ARuta, faAnyFile, lDatos) = 0 then
  begin
    Result := lDatos.Size;
    FindClose(lDatos);
  end;
end;

procedure RotarSiHaceFalta(const ARuta: string);
var
  lAnterior: string;
begin
  if Tamano(ARuta) < TAMANO_MAXIMO then
    Exit;
  lAnterior := ChangeFileExt(ParamStr(0), SUFIJO_ANTERIOR);
  if TFile.Exists(lAnterior) then
    TFile.Delete(lAnterior);
  TFile.Move(ARuta, lAnterior);
end;

procedure RegistrarLlamada(const AVerbo, ARuta: string;
  const AEstado: Integer; const AMilisegundos: Int64; const ADetalle: string);
var
  lLinea, lRuta: string;
begin
  lLinea := Format('%s  %-6s %s  %d  %dms', [FormatDateTime('yyyy-mm-dd hh:nn:ss',
    Now, TFormatSettings.Invariant), AVerbo, ARuta, AEstado, AMilisegundos]);
  if ADetalle <> '' then
    lLinea := lLinea + '  ' + ADetalle;

  TMonitor.Enter(Candado);
  try
    try
      lRuta := RutaLog;
      RotarSiHaceFalta(lRuta);
      TFile.AppendAllText(lRuta, lLinea + sLineBreak, TEncoding.UTF8);
    except
      on Exception do
        ;
    end;
  finally
    TMonitor.Exit(Candado);
  end;
end;

initialization

Candado := TObject.Create;

finalization

Candado.Free;

end.
