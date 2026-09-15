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

unit Anovo.Entities.Empresa;

// EMPRESA: los datos del emisor de la cotizacion
//
// Generada por MVCEntGen y separada por recurso desde
// db-firebird\generado\Anovo.Entities.Generadas.pas. Al regenerar, volver a
// partir de ahi: lo que se escriba a mano aqui se pierde.

interface

uses
  MVCFramework.Serializer.Commons,
  MVCFramework.Nullables,
  MVCFramework.ActiveRecord,
  MVCFramework.Validators;

type

  [MVCNameCase(ncSnakeCase)]
  [MVCTable('EMPRESA')]
  TEmpresa = class(TMVCActiveRecord)
  private
    [MVCTableField('ID', [foPrimaryKey])]
    [MVCRequired]
    fID: Int32;
    [MVCTableField('RAZON_SOCIAL')]
    [MVCRequired]
    [MVCMaxLength(120)]
    fRazonSocial: String;
    [MVCTableField('CEDULA_JURIDICA')]
    [MVCRequired]
    [MVCMaxLength(20)]
    fCedulaJuridica: String;
    [MVCTableField('DIRECCION')]
    [MVCMaxLength(500)]
    fDireccion: NullableString;
    [MVCTableField('TELEFONO_FIJO')]
    [MVCMaxLength(30)]
    fTelefonoFijo: NullableString;
    [MVCTableField('CELULAR')]
    [MVCMaxLength(30)]
    fCelular: NullableString;
    [MVCTableField('CORREO')]
    [MVCMaxLength(150)]
    fCorreo: NullableString;
    [MVCTableField('REPRESENTANTE_LEGAL')]
    [MVCMaxLength(120)]
    fRepresentanteLegal: NullableString;
    [MVCTableField('CUENTA_BANCARIA')]
    [MVCMaxLength(60)]
    fCuentaBancaria: NullableString;
    [MVCTableField('MODIFICADO_POR')]
    fModificadoPor: NullableInt32;
    [MVCTableField('FECHA_MODIFICACION', [foRefresh])]
    fFechaModificacion: NullableTDateTime {dtDateTimeStamp};
  public
    property ID: Int32 read fID write fID;
    property RazonSocial: String read fRazonSocial write fRazonSocial;
    property CedulaJuridica: String read fCedulaJuridica write fCedulaJuridica;
    property Direccion: NullableString read fDireccion write fDireccion;
    property TelefonoFijo: NullableString read fTelefonoFijo write fTelefonoFijo;
    property Celular: NullableString read fCelular write fCelular;
    property Correo: NullableString read fCorreo write fCorreo;
    property RepresentanteLegal: NullableString read fRepresentanteLegal write fRepresentanteLegal;
    property CuentaBancaria: NullableString read fCuentaBancaria write fCuentaBancaria;
    property ModificadoPor: NullableInt32 read fModificadoPor write fModificadoPor;
    property FechaModificacion: NullableTDateTime {dtDateTimeStamp} read fFechaModificacion write fFechaModificacion;
  end;

implementation

initialization

ActiveRecordMappingRegistry.AddEntity('empresa', TEmpresa);

end.
