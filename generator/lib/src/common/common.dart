import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';

// Custom TypeChecker that works with analyzer 10.0.1+
class CustomTypeChecker {
  final String elementName;
  final String? packageName;
  
  const CustomTypeChecker(this.elementName, [this.packageName]);
  
  bool isExactlyType(DartType? type) {
    if (type == null) return false;
    final element = type.element;
    if (element == null) return false;
    // For simplicity, just match by element name
    // The package check is too fragile with different analyzer versions
    return element.name == elementName;
  }
  
  bool isExactly(Element? element) {
    if (element == null) return false;
    return element.name == elementName;
  }
  
  bool isSuperTypeOf(DartType? type) {
    if (type == null) return false;
    if (isExactlyType(type)) return true;
    
    final element = type.element;
    if (element is! InterfaceElement) return false;
    
    for (final supertype in element.allSupertypes) {
      if (isExactlyType(supertype)) return true;
    }
    return false;
  }
  
  // Alias for isSuperTypeOf to match TypeChecker API
  bool isAssignableFromType(DartType? type) {
    return isSuperTypeOf(type);
  }
  
  bool hasAnnotation(Element element, {bool throwOnUnresolved = true}) {
    return firstAnnotationOf(element, throwOnUnresolved: throwOnUnresolved) != null;
  }
  
  DartObject? firstAnnotationOf(Element element, {bool throwOnUnresolved = true}) {
    if (element is! ClassElement && element is! PropertyAccessorElement && element is! FieldElement) {
      return null;
    }
    
    final metadata = element.metadata;
    for (final annotation in metadata.annotations) {
      final value = annotation.computeConstantValue();
      if (value == null) continue;
      final type = value.type;
      // Use isSuperTypeOf to match subtypes (e.g., HasMany implements Relation)
      if (type != null && isSuperTypeOf(type)) {
        return value;
      }
    }
    return null;
  }
  
  DartObject? firstAnnotationOfExact(Element element, {bool throwOnUnresolved = true}) {
    return firstAnnotationOf(element, throwOnUnresolved: throwOnUnresolved);
  }
}

const isGenBean = CustomTypeChecker('GenBean', 'jaguar_orm');

const isBean = CustomTypeChecker('Bean', 'jaguar_orm');

const isIgnore = CustomTypeChecker('IgnoreColumn', 'jaguar_orm');

const isColumnBase = CustomTypeChecker('ColumnBase', 'jaguar_orm');

const isColumn = CustomTypeChecker('Column', 'jaguar_orm');

const isPrimaryKey = CustomTypeChecker('PrimaryKey', 'jaguar_orm');

const isForeignKey = CustomTypeChecker('ForeignKey', 'jaguar_orm');

const isBelongsTo = CustomTypeChecker('BelongsTo', 'jaguar_orm');

const isRelation = CustomTypeChecker('Relation', 'jaguar_orm');

const isHasOne = CustomTypeChecker('HasOne', 'jaguar_orm');

const isHasMany = CustomTypeChecker('HasMany', 'jaguar_orm');

const isManyToMany = CustomTypeChecker('ManyToMany', 'jaguar_orm');

// Dart core types
const isList = CustomTypeChecker('List', 'dart.core');

const isMap = CustomTypeChecker('Map', 'dart.core');

const isString = CustomTypeChecker('String', 'dart.core');

const isInt = CustomTypeChecker('int', 'dart.core');

const isDouble = CustomTypeChecker('double', 'dart.core');

const isNum = CustomTypeChecker('num', 'dart.core');

const isDateTime = CustomTypeChecker('DateTime', 'dart.core');

const isBool = CustomTypeChecker('bool', 'dart.core');

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
