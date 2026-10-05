unit Anovo.Services.Intf.Importacion;

// Contrato del servicio de importacion masiva a los catalogos.

interface

uses
  Anovo.DTOs.Importacion;

type
  IImportacionService = interface
    ['{8D2B6E41-3C7A-4F95-B10E-6A9C2E5D7F38}']
    function Importar(const ACatalogo: TCatalogoImportacion;
      const ADatos: TImportacionDTO; const ASoloRevisar: Boolean)
      : TImportacionResultadoDTO;
  end;

implementation

end.
