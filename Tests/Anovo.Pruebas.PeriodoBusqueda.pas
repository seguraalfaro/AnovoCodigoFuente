unit Anovo.Pruebas.PeriodoBusqueda;

// Periodo de busqueda del escritorio: fechas de cada atajo, extremos abiertos,
// periodo invertido y el texto del boton.

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture('Periodo de busqueda de los listados del escritorio')]
  TPruebasPeriodoBusqueda = class
  private
    FSeparador: Char;
  public
    [SetupFixture]
    procedure Preparar;
    [TearDownFixture]
    procedure Restaurar;

    [Test]
    procedure TodasNoTieneLimites;
    [Test]
    procedure HoyEsUnSoloDia;
    [Test]
    procedure EstaSemanaEmpiezaElLunes;
    [Test]
    procedure EsteMesVaDelPrimeroAHoy;
    [Test]
    procedure MesAnteriorEsElMesCompleto;
    [Test]
    procedure MesAnteriorEnEneroEsDiciembre;
    [Test]
    procedure TresMesesIncluyeElMesActual;
    [Test]
    procedure TresMesesCruzaElAnio;
    [Test]
    procedure EsteAnioEmpiezaEnEnero;
    [Test]
    procedure PersonalizadoSoloDesde;
    [Test]
    procedure PersonalizadoSoloHasta;
    [Test]
    procedure PersonalizadoSinFechasEsTodas;
    [Test]
    procedure PersonalizadoQuitaLaHora;
    [Test]
    procedure ValidarRechazaElPeriodoInvertido;
    [Test]
    procedure ValidarAceptaUnExtremoAbierto;
    [Test]
    procedure IgualComparaAtajoYFechas;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils,
  Anovo.PeriodoBusqueda,
  Anovo.Textos;

function Hoy: TDateTime;
begin
  Result := EncodeDate(2026, 10, 17);
end;

procedure TPruebasPeriodoBusqueda.Preparar;
begin
  FSeparador := FormatSettings.DateSeparator;
  FormatSettings.DateSeparator := '/';
end;

procedure TPruebasPeriodoBusqueda.Restaurar;
begin
  FormatSettings.DateSeparator := FSeparador;
end;

procedure TPruebasPeriodoBusqueda.TodasNoTieneLimites;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.De(apTodas, Hoy);
  Assert.AreEqual<TDateTime>(0, lPeriodo.Desde);
  Assert.AreEqual<TDateTime>(0, lPeriodo.Hasta);
  Assert.IsFalse(lPeriodo.Activo);
  Assert.AreEqual(SPeriodoTodas, lPeriodo.Texto);
end;

procedure TPruebasPeriodoBusqueda.HoyEsUnSoloDia;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.De(apHoy, Hoy);
  Assert.AreEqual<TDateTime>(Hoy, lPeriodo.Desde);
  Assert.AreEqual<TDateTime>(Hoy, lPeriodo.Hasta);
  Assert.AreEqual('Hoy: 17/10/2026', lPeriodo.Texto);
end;

procedure TPruebasPeriodoBusqueda.EstaSemanaEmpiezaElLunes;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.De(apEstaSemana, Hoy);
  Assert.AreEqual<TDateTime>(EncodeDate(2026, 10, 12), lPeriodo.Desde);
  Assert.AreEqual<TDateTime>(Hoy, lPeriodo.Hasta);
end;

procedure TPruebasPeriodoBusqueda.EsteMesVaDelPrimeroAHoy;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.De(apEsteMes, Hoy);
  Assert.AreEqual<TDateTime>(EncodeDate(2026, 10, 1), lPeriodo.Desde);
  Assert.AreEqual<TDateTime>(Hoy, lPeriodo.Hasta);
  Assert.IsTrue(lPeriodo.Activo);
  Assert.AreEqual('Este mes: 01/10 al 17/10/2026', lPeriodo.Texto);
end;

procedure TPruebasPeriodoBusqueda.MesAnteriorEsElMesCompleto;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.De(apMesAnterior, Hoy);
  Assert.AreEqual<TDateTime>(EncodeDate(2026, 9, 1), lPeriodo.Desde);
  Assert.AreEqual<TDateTime>(EncodeDate(2026, 9, 30), lPeriodo.Hasta);
end;

procedure TPruebasPeriodoBusqueda.MesAnteriorEnEneroEsDiciembre;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.De(apMesAnterior, EncodeDate(2026, 1, 15));
  Assert.AreEqual<TDateTime>(EncodeDate(2025, 12, 1), lPeriodo.Desde);
  Assert.AreEqual<TDateTime>(EncodeDate(2025, 12, 31), lPeriodo.Hasta);
  Assert.AreEqual('Mes anterior: 01/12 al 31/12/2025', lPeriodo.Texto);
end;

procedure TPruebasPeriodoBusqueda.TresMesesIncluyeElMesActual;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.De(apTresMeses, Hoy);
  Assert.AreEqual<TDateTime>(EncodeDate(2026, 8, 1), lPeriodo.Desde);
  Assert.AreEqual<TDateTime>(Hoy, lPeriodo.Hasta);
end;

procedure TPruebasPeriodoBusqueda.TresMesesCruzaElAnio;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.De(apTresMeses, EncodeDate(2026, 2, 10));
  Assert.AreEqual<TDateTime>(EncodeDate(2025, 12, 1), lPeriodo.Desde);
  Assert.AreEqual(TPeriodoBusqueda.Nombre(apTresMeses) +
    ': 01/12/2025 al 10/02/2026', lPeriodo.Texto);
end;

procedure TPruebasPeriodoBusqueda.EsteAnioEmpiezaEnEnero;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.De(apEsteAnio, Hoy);
  Assert.AreEqual<TDateTime>(EncodeDate(2026, 1, 1), lPeriodo.Desde);
  Assert.AreEqual<TDateTime>(Hoy, lPeriodo.Hasta);
end;

procedure TPruebasPeriodoBusqueda.PersonalizadoSoloDesde;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.Personalizado(EncodeDate(2026, 10, 1), 0);
  Assert.IsTrue(lPeriodo.Atajo = apPersonalizado);
  Assert.IsTrue(lPeriodo.Activo);
  Assert.AreEqual<TDateTime>(0, lPeriodo.Hasta);
  Assert.AreEqual('Desde 01/10/2026', lPeriodo.Texto);
end;

procedure TPruebasPeriodoBusqueda.PersonalizadoSoloHasta;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.Personalizado(0, EncodeDate(2026, 10, 15));
  Assert.AreEqual<TDateTime>(0, lPeriodo.Desde);
  Assert.AreEqual('Hasta 15/10/2026', lPeriodo.Texto);
end;

procedure TPruebasPeriodoBusqueda.PersonalizadoSinFechasEsTodas;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.Personalizado(0, 0);
  Assert.IsTrue(lPeriodo.Atajo = apTodas);
  Assert.IsFalse(lPeriodo.Activo);
end;

procedure TPruebasPeriodoBusqueda.PersonalizadoQuitaLaHora;
var
  lPeriodo: TPeriodoBusqueda;
begin
  lPeriodo := TPeriodoBusqueda.Personalizado(EncodeDateTime(2026, 10, 1, 15,
    30, 0, 0), EncodeDateTime(2026, 10, 15, 8, 0, 0, 0));
  Assert.AreEqual<TDateTime>(EncodeDate(2026, 10, 1), lPeriodo.Desde);
  Assert.AreEqual<TDateTime>(EncodeDate(2026, 10, 15), lPeriodo.Hasta);
  Assert.AreEqual('01/10 al 15/10/2026', lPeriodo.Texto);
end;

procedure TPruebasPeriodoBusqueda.ValidarRechazaElPeriodoInvertido;
var
  lMensaje: string;
begin
  Assert.IsFalse(TPeriodoBusqueda.Personalizado(EncodeDate(2026, 10, 15),
    EncodeDate(2026, 10, 1)).Validar(lMensaje));
  Assert.AreEqual(SPeriodoInvertido, lMensaje);
end;

procedure TPruebasPeriodoBusqueda.ValidarAceptaUnExtremoAbierto;
var
  lMensaje: string;
begin
  Assert.IsTrue(TPeriodoBusqueda.Personalizado(EncodeDate(2026, 10, 15),
    0).Validar(lMensaje));
  Assert.IsTrue(TPeriodoBusqueda.Personalizado(0, EncodeDate(2026, 10, 1))
    .Validar(lMensaje));
  Assert.IsTrue(TPeriodoBusqueda.De(apHoy, Hoy).Validar(lMensaje));
  Assert.AreEqual('', lMensaje);
end;

procedure TPruebasPeriodoBusqueda.IgualComparaAtajoYFechas;
var
  lEsteMes: TPeriodoBusqueda;
begin
  lEsteMes := TPeriodoBusqueda.De(apEsteMes, Hoy);
  Assert.IsTrue(lEsteMes.Igual(TPeriodoBusqueda.De(apEsteMes, Hoy)));
  Assert.IsFalse(lEsteMes.Igual(TPeriodoBusqueda.Personalizado(lEsteMes.Desde,
    lEsteMes.Hasta)));
  Assert.IsFalse(lEsteMes.Igual(TPeriodoBusqueda.De(apEsteMes,
    EncodeDate(2026, 10, 18))));
end;

initialization
  TDUnitX.RegisterTestFixture(TPruebasPeriodoBusqueda);

end.
