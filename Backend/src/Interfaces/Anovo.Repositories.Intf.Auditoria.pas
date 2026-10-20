unit Anovo.Repositories.Intf.Auditoria;

// Contrato del repositorio de auditoria. Solo lectura.

interface

uses
  System.Generics.Collections,
  MVCFramework.Repository,
  Anovo.Entities.Auditoria,
  Anovo.Entities.Vistas.Lectura;

const
  ENTIDAD_GRUPO_CUENTAS = 'CUENTAS';

type

  IAuditoriaRepository = interface(IMVCRepository<TAuditoria>)
    ['{B25B2BBC-2DD4-4E00-828C-A2B2F784BE65}']

    function Buscar(const ADesde, AHasta: TDateTime;
      const APagina, APorPagina: Integer; const AUsuarioId: Integer = 0;
      const AEntidad: string = ''; const AAccion: string = '';
      const ATexto: string = ''): TObjectList<TVAuditoria>;

    function ContarBusqueda(const ADesde, AHasta: TDateTime;
      const AUsuarioId: Integer = 0; const AEntidad: string = '';
      const AAccion: string = ''; const ATexto: string = ''): Int64;

    function DeLaEntidad(const AEntidad: string; const AEntidadId: Integer)
      : TObjectList<TVAuditoria>;
  end;

implementation

end.
