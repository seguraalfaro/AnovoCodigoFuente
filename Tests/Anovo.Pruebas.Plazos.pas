unit Anovo.Pruebas.Plazos;

// Plazo de entrega y garantia de la cotizacion (HU-04): cantidad y unidad
// van juntas, entre 1 y 999, con una unidad del catalogo.

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture('Plazos de entrega y garantia')]
  TPruebasPlazos = class
  public
    [Test]
    procedure SinCantidadNiUnidadEsValido;
    [Test]
    [TestCase('Un dia', '1,dias')]
    [TestCase('Maximo en meses', '999,meses')]
    [TestCase('Dias habiles', '15,dias_habiles')]
    procedure PlazoCompletoEsValido(const ACantidad: Integer;
      const AUnidad: string);
    [Test]
    [TestCase('Cero', '0,dias')]
    [TestCase('Pasa el maximo', '1000,dias')]
    [TestCase('Negativo', '-3,semanas')]
    [TestCase('Unidad desconocida', '5,quincenas')]
    [TestCase('Unidad en mayusculas', '5,DIAS')]
    procedure PlazoFueraDeReglaNoEsValido(const ACantidad: Integer;
      const AUnidad: string);
    [Test]
    procedure CantidadSinUnidadNoEsValida;
    [Test]
    procedure UnidadSinCantidadNoEsValida;
    [Test]
    procedure ElErrorNombraElPlazoQueFalla;
    [Test]
    procedure ElTextoUsaSingularYPlural;
  end;

implementation

uses
  System.SysUtils,
  MVCFramework.Nullables,
  Anovo.Condiciones,
  Anovo.Textos;

function Cantidad(const AValor: Integer): NullableInt32;
begin
  Result := AValor;
end;

function Unidad(const AValor: string): NullableString;
begin
  Result := AValor;
end;

procedure TPruebasPlazos.SinCantidadNiUnidadEsValido;
var
  lCantidad: NullableInt32;
  lUnidad: NullableString;
begin
  lCantidad.Clear;
  lUnidad.Clear;
  Assert.IsTrue(PlazoValido(lCantidad, lUnidad));
end;

procedure TPruebasPlazos.PlazoCompletoEsValido(const ACantidad: Integer;
  const AUnidad: string);
begin
  Assert.IsTrue(PlazoValido(Cantidad(ACantidad), Unidad(AUnidad)));
end;

procedure TPruebasPlazos.PlazoFueraDeReglaNoEsValido(const ACantidad: Integer;
  const AUnidad: string);
begin
  Assert.IsFalse(PlazoValido(Cantidad(ACantidad), Unidad(AUnidad)));
end;

procedure TPruebasPlazos.CantidadSinUnidadNoEsValida;
var
  lUnidad: NullableString;
begin
  lUnidad.Clear;
  Assert.IsFalse(PlazoValido(Cantidad(5), lUnidad));
end;

procedure TPruebasPlazos.UnidadSinCantidadNoEsValida;
var
  lCantidad: NullableInt32;
begin
  lCantidad.Clear;
  Assert.IsFalse(PlazoValido(lCantidad, Unidad(UNIDAD_DIAS)));
end;

procedure TPruebasPlazos.ElErrorNombraElPlazoQueFalla;
begin
  Assert.AreEqual(Format(SPlazoEntregaInvalido, [PLAZO_MAXIMO]),
    ErrorDePlazos(Cantidad(0), Unidad(UNIDAD_DIAS), Cantidad(1),
    Unidad(UNIDAD_ANIOS)));
  Assert.AreEqual(Format(SGarantiaInvalida, [PLAZO_MAXIMO]),
    ErrorDePlazos(Cantidad(10), Unidad(UNIDAD_DIAS), Cantidad(1),
    Unidad('siglos')));
  Assert.AreEqual('', ErrorDePlazos(Cantidad(10), Unidad(UNIDAD_DIAS),
    Cantidad(1), Unidad(UNIDAD_ANIOS)));
end;

procedure TPruebasPlazos.ElTextoUsaSingularYPlural;
begin
  Assert.AreEqual('1 ' + SUnidadDia, TextoPlazo(Cantidad(1),
    Unidad(UNIDAD_DIAS)));
  Assert.AreEqual('3 ' + SUnidadMeses, TextoPlazo(Cantidad(3),
    Unidad(UNIDAD_MESES)));
end;

initialization
  TDUnitX.RegisterTestFixture(TPruebasPlazos);

end.
