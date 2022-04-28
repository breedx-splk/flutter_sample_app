
import 'package:flutter_sample_app/otel_instrumented.dart';
import 'package:flutter_sample_app/with_span.dart';
import 'package:flutter/foundation.dart';

part 'biz_logic.g.dart';

@OtelInstrumented()
class BizLogic {

  const BizLogic();

  @WithSpan(name: "buttercup")
  doGreatThing(){
    debugPrint("trace was clicked");
    debugPrint("  result: " + _anotherMethod().toString());
  }

  @WithSpan()
  _anotherMethod(){
    debugPrint("  anotherMethod was called");
    return _finalMethod() * 3;
  }

  @WithSpan()
  _finalMethod(){
    debugPrint("  in the final method");
    return 5;
  }

}