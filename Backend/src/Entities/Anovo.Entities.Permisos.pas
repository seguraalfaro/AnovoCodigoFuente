// ***************************************************************************
//
// Delphi MVC Framework
//
// Copyright (c) 2010-2026 Daniele Teti and the DMVCFramework Team
//
// https://github.com/danieleteti/delphimvcframework
//
// ***************************************************************************
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// ***************************************************************************

unit Anovo.Entities.Permisos;

// PERMISOS Y ROLES_PERMISOS
//
// Generada por MVCEntGen y separada por recurso desde
// AnovoCodigoFuente\Db\generado\Anovo.Entities.Generadas.pas. Al regenerar,
// volver a partir de ahi: lo que se escriba a mano aqui se pierde.
//
// PERMISOS es catalogo fijo: el backend solo lo lee, lo carga la migracion 08.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  MVCFramework.ActiveRecord,
  MVCFramework.Validators;

type

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('PERMISOS')]
  TPermisos = class(TMVCActiveRecord)
  private
    [MVCTableField('ID', [foPrimaryKey])]
    [MVCRequired]
    fID: Int32;
    [MVCTableField('CODIGO')]
    [MVCRequired]
    [MVCMaxLength(50)]
    fCodigo: String;
    [MVCTableField('NOMBRE')]
    [MVCRequired]
    [MVCMaxLength(120)]
    fNombre: String;
    [MVCTableField('MODULO')]
    [MVCRequired]
    [MVCMaxLength(30)]
    fModulo: String;
    [MVCTableField('AMBITO')]
    [MVCRequired]
    [MVCMaxLength(15)]
    fAmbito: String;
  public
    property ID: Int32 read fID write fID;
    property Codigo: String read fCodigo write fCodigo;
    property Nombre: String read fNombre write fNombre;
    property Modulo: String read fModulo write fModulo;
    property Ambito: String read fAmbito write fAmbito;
  end;

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('ROLES_PERMISOS')]
  TRolesPermisos = class(TMVCActiveRecord)
  private
    [MVCTableField('ROL_ID', [foPrimaryKey])]
    [MVCRequired]
    fRolId: Int32;
    [MVCTableField('PERMISO_ID', [foPrimaryKey])]
    [MVCRequired]
    fPermisoId: Int32;
    // Tiene que ser el del permiso. Si no coincide con el del rol, la FK
    // compuesta rechaza el insert.
    [MVCTableField('AMBITO')]
    [MVCRequired]
    [MVCMaxLength(15)]
    fAmbito: String;
    // Escrito a mano: la pone el DEFAULT. Sin estos flags el insert manda NULL
    // explicito y choca con el NOT NULL. [foDoNotInsert, foDoNotUpdate, foRefresh])
    [MVCTableField('FECHA_CREACION', [foDoNotInsert, foDoNotUpdate, foRefresh])]
    fFechaCreacion: NullableTDateTime { dtDateTimeStamp };
  public
    property RolId: Int32 read fRolId write fRolId;
    property PermisoId: Int32 read fPermisoId write fPermisoId;
    property Ambito: String read fAmbito write fAmbito;
    property FechaCreacion: NullableTDateTime { dtDateTimeStamp }
      read fFechaCreacion write fFechaCreacion;
  end;

implementation

initialization

ActiveRecordMappingRegistry.AddEntity('permisos', TPermisos);
ActiveRecordMappingRegistry.AddEntity('roles_permisos', TRolesPermisos);

end.
