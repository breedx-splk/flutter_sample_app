import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:flutter_sample_app/with_span.dart';
import 'package:flutter_sample_app/otel_instrumented.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/visitor.dart';

Builder createOtelInstrumentedBuilder(BuilderOptions options) =>
    SharedPartBuilder([OtelInstrumentedGenerator()], 'otel_instrumented');

class OtelInstrumentedGenerator extends GeneratorForAnnotation<OtelInstrumented> {

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = WithSpanVisitor();
    element.visitChildren(visitor);

    final methods = visitor.buildMethods();

    final className = element.declaration?.name;
    return '''
      class OtelInstrumented$className extends $className {
      //   I am a pony!";
        $methods
      }
    ''';
  }
}

class WithSpanVisitor extends SimpleElementVisitor<void> {

  final withSpanChecker = const TypeChecker.fromRuntime(WithSpan);
  var methods = <MethodElement>[];

  @override
  void visitMethodElement(MethodElement element) {
    // print("  displayName => " + element.displayName);
    // print("  declaration name => " + element.declaration.name);
    // print("  return type => " + element.declaration.returnType.getDisplayString(withNullability: false));
    // for (var param in element.declaration.parameters) {
    //   print("       ${param.declaration.type} ${param.declaration.name}");
    // }
    if(withSpanChecker.hasAnnotationOfExact(element)){
      print(element.metadata);
      print(element.metadata[0]);
      print(element.metadata[0].context);
      print(element.metadata[0].element);
      print(element.metadata[0].computeConstantValue()?.getField("name"));
      methods.add(element);
    }
  }

  buildMethods() {
    var results = <String>[];
    for (MethodElement method in methods) {
      var returnType = method.declaration.returnType.getDisplayString(withNullability: false);
      returnType = (returnType == "dynamic") ? "" : "$returnType ";
      final methodName = method.declaration.name;
      final declArgs = buildMethodArgs(method);
      final argList = buildMethodArgs(method, withType: false);
      var spanName = getSpanName(method);
      spanName = "'$spanName'";

      //TODO: This probably needs to look very different for async methods <YIKES>

      final thisMethod = '''
      @override
      $returnType$methodName($declArgs) {
        final scopeId = rum.startSpan($spanName);
        try {
          return super.$methodName($argList);
        }
        finally {
          rum.endSpan(scopeId);
        }
      }
      ''';
      results.add(thisMethod);
    }
    return results.join("\n\n");
  }

  buildMethodArgs(MethodElement method, {withType = true}) {
    var args = <String>[];
    for (ParameterElement param in method.declaration.parameters) {
      var typePart = withType ? "${param.declaration.type} " : "";
      var arg = "$typePart${param.declaration.name}";
      args.add(arg);
    }
    return args.join(", ");
  }

  String getSpanName(MethodElement method) {
    for (ElementAnnotation meta in method.metadata) {
      // TODO: Gotta be a better way of finding the annotation on the method, bah.
      if(meta.toString().startsWith("@WithSpan")){
        return meta.computeConstantValue()?.getField('name')?.toStringValue() ?? method.declaration.name;
      }
    }
    return method.declaration.name;
  }

}
