unit Anovo.Pruebas.TotalesCotizacion;

// Textos del desglose de una cotizacion que comparten el detalle y la
// revision: ajuste, IVA exonerado y motivo.

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture('Textos del desglose de una cotizacion')]
  TPruebasTotalesCotizacion = class
  public
    [Test]
    procedure SinAjusteDiceSinAjuste;
    [Test]
    procedure AjusteMuestraElPorcentaje;
    [Test]
    procedure IvaCeroEsExonerado;
    [Test]
    procedure IvaMuestraElPorcentaje;
    [Test]
    procedure MotivoVacioQuedaVacio;
  end;

implementation

uses
  System.SysUtils,
  Anovo.DTOs.Cotizaciones,
  Anovo.Formato,
  Anovo.Textos,
  Anovo.TotalesCotizacion;

function Cotizacion(const AAjuste, AIva: Currency): TCotizacionDTO;
begin
  Result := TCotizacionDTO.Create;
  Result.PorcentajeAjuste := AAjuste;
  Result.PorcentajeIva := AIva;
  Result.CostoTotal := 1000;
end;

procedure TPruebasTotalesCotizacion.SinAjusteDiceSinAjuste;
var
  lCotizacion: TCotizacionDTO;
begin
  lCotizacion := Cotizacion(0, 13);
  try
    Assert.AreEqual(SSinAjuste, TTotalesCotizacion.De(lCotizacion).AjusteRotulo);
  finally
    lCotizacion.Free;
  end;
end;

procedure TPruebasTotalesCotizacion.AjusteMuestraElPorcentaje;
var
  lCotizacion: TCotizacionDTO;
begin
  lCotizacion := Cotizacion(10, 13);
  try
    Assert.AreEqual(Format(SAjustePorcentaje, [TFormato.Porcentaje(10)]),
      TTotalesCotizacion.De(lCotizacion).AjusteRotulo);
  finally
    lCotizacion.Free;
  end;
end;

procedure TPruebasTotalesCotizacion.IvaCeroEsExonerado;
var
  lCotizacion: TCotizacionDTO;
begin
  lCotizacion := Cotizacion(0, 0);
  try
    Assert.AreEqual(SIvaExonerado, TTotalesCotizacion.De(lCotizacion).IvaRotulo);
  finally
    lCotizacion.Free;
  end;
end;

procedure TPruebasTotalesCotizacion.IvaMuestraElPorcentaje;
var
  lCotizacion: TCotizacionDTO;
begin
  lCotizacion := Cotizacion(0, 13);
  try
    Assert.AreEqual(Format(SIvaPorcentaje, [TFormato.Porcentaje(13)]),
      TTotalesCotizacion.De(lCotizacion).IvaRotulo);
  finally
    lCotizacion.Free;
  end;
end;

procedure TPruebasTotalesCotizacion.MotivoVacioQuedaVacio;
var
  lCotizacion: TCotizacionDTO;
begin
  lCotizacion := Cotizacion(5, 13);
  try
    Assert.AreEqual('', TTotalesCotizacion.De(lCotizacion).MotivoAjuste);
  finally
    lCotizacion.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TPruebasTotalesCotizacion);

end.
