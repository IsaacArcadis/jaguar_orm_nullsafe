import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/element.dart';

final isGenBean = const TypeChecker.fromUrl('package:jaguar_orm/jaguar_orm.dart#GenBean');

final isBean = const TypeChecker.fromUrl('package:jaguar_orm/jaguar_orm.dart#Bean');

final isIgnore = const TypeChecker.fromUrl('package:jaguar_orm/jaguar_orm.dart#IgnoreColumn');

final isColumnBase = const TypeChecker.fromUrl('package:jaguar_orm/jaguar_orm.dart#ColumnBase');

final isColumn = const TypeChecker.fromUrl('package:jaguar_orm/jaguar_orm.dart#Column');

final isPrimaryKey = const TypeChecker.fromUrl('package:jaguar_orm/jaguar_orm.dart#PrimaryKey');

final isForeignKey = const TypeChecker.fromUrl('package:jaguar_orm/jaguar_orm.dart#ForeignKey');

final isBelongsTo = const TypeChecker.fromUrl('package:jaguar_orm/jaguar_orm.dart#BelongsTo');

final isRelation = const TypeChecker.fromUrl('package:jaguar_orm/jaguar_orm.dart#Relation');

final isHasOne = const TypeChecker.fromUrl('package:jaguar_orm/jaguar_orm.dart#HasOne');

final isHasMany = const TypeChecker.fromUrl('package:jaguar_orm/jaguar_orm.dart#HasMany');

final isManyToMany = const TypeChecker.fromUrl('package:jaguar_orm/jaguar_orm.dart#ManyToMany');

final isList = const TypeChecker.fromUrl('dart:core#List');

final isMap = const TypeChecker.fromUrl('dart:core#Map');

final isString = const TypeChecker.fromUrl('dart:core#String');

final isInt = const TypeChecker.fromUrl('dart:core#int');

final isDouble = const TypeChecker.fromUrl('dart:core#double');

final isNum = const TypeChecker.fromUrl('dart:core#num');

final isDateTime = const TypeChecker.fromUrl('dart:core#DateTime');

final isBool = const TypeChecker.fromUrl('dart:core#bool');

bool isBuiltin(DartType type) {
  if (isString.isExactlyType(type)) return true;
  if (isInt.isExactlyType(type)) return true;
  if (isDouble.isExactlyType(type)) return true;
  if (isNum.isExactlyType(type)) return true;
  if (isBool.isExactlyType(type)) return true;

  return false;
}

DartType getModelForBean(DartType bean) {
  ClassElement c = bean.element as ClassElement;
  InterfaceType i =
      c.allSupertypes.firstWhere((InterfaceType i) => isBean.isExactlyType(i));
  return i.typeArguments[0];
}

class FieldSpecException {
  String name;

  String message;

  FieldSpecException(this.name, this.message);

  String toString() => 'Field $name has exception: $message';
}

String uncap(String str) =>
    str.substring(0, 1).toLowerCase() + str.substring(1);
