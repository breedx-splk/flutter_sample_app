
import 'package:flutter_sample_app/otel_instrumented.dart';
import 'package:flutter_sample_app/rum.dart';
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
  int _anotherMethod(){
    debugPrint("  _anotherMethod was called");
    return _someIntermediate(2) * 3;
  }

  _someIntermediate(value){
    debugPrint("  in _someIntermediate");
    return _finalMethod(value);
  }

  @WithSpan()
  _finalMethod(value){
    debugPrint("  in the _finalMethod");
    return 5 + value;
  }

}