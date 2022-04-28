import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:flutter_sample_app/with_span.dart';
import 'package:flutter_sample_app/otel_instrumented.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

// Builder createWithSpanBuilder(BuilderOptions options) =>
//     SharedPartBuilder([WithSpanGenerator()], 'with_span');

Builder createOtelInstrumentedBuilder(BuilderOptions options) =>
    SharedPartBuilder([OtelInstrumentedGenerator()], 'otel_instrumented');

class OtelInstrumentedGenerator extends GeneratorForAnnotation<OtelInstrumented> {

  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    print('HO HO HO HARDY HAR HAR');
    print('HO HO HO HARDY HAR HAR');
    print('HO HO HO HARDY HAR HAR');
    // print(element.type);
    print(element.metadata);
    var visitor = WithSpanVisitor();
    element.visitChildren(visitor);
    // for (var m in element.metadata) {
    //   print(m);
    // }

    var methods = visitor.buildMethods();

    var className = element.declaration?.name;
    return '''
      // class OtelInstrumented$className extends $className {
      //   I am a pony!";
      // $methods
      // }
    ''';
  }
}
//
// class WithSpanGenerator extends GeneratorForAnnotation<WithSpan> {
//
//   @override
//   generateForAnnotatedElement(
//       Element element, ConstantReader annotation, BuildStep buildStep) {
//     print('HO HO HO HARDY HAR HAR');
//     print('HO HO HO HARDY HAR HAR');
//     print('HO HO HO HARDY HAR HAR');
//     // print(element.type);
//     print(element.metadata);
//     element.visitChildren(new WithSpanVisitor());
//     // for (var m in element.metadata) {
//     //   print(m);
//     // }
//     return "// I am a pony!";
//   }
// }

class WithSpanVisitor extends SimpleElementVisitor<void> {

  var methods = [];

  @override
  void visitMethodElement(MethodElement element) {
    var withSpanChecker = const TypeChecker.fromRuntime(WithSpan);
    print("  displayName => " + element.displayName);
    // print("  declaration name => " + element.declaration.name);
    if(withSpanChecker.hasAnnotationOfExact(element)){
      print("    yes sweet it has it!");
      methods.add(element);
    }
    else {
      print("    Gonna ignore this one");
    }
    // for (var annotation in element.metadata) {
    //   print("runtime type: " + annotation.runtimeType.toString());
    //   annotation.runtimeType.
    // }
    // print("  " + element.metadata.toString());
  }

  buildMethods() {
    for (var method in methods) {

    }
  }
}
