/*
Example/spike of some splunk RUM behaviors in Dart
*/
library rum;
export 'rum.dart';

import 'dart:ui';

import 'package:flutter/services.dart';

var rum = SplunkRum();

// MethodChannel shim into the SplunkRum instance.
class SplunkRum {
  final channel = const MethodChannel("com.splunk/rum");

  addRumEvent(name, attributes) async {
    channel.invokeMethod("addRumEvent", [name, attributes]);
  }

  getSessionId() async {
    return channel.invokeMethod("getSessionId");
  }

  startSpan(String name) async {
    //TODO: Obvs. we want attributes as well, when coming from @WithSpan
    // just the common/standard attrs (which don't exist yet, lol)
    return channel.invokeMethod("startSpan", [name]);
  }

  endSpan(String scopeId) async {
    await channel.invokeMethod("endSpan", [scopeId]);
  }

  void runInSpan(String name, VoidCallback fn) async {
    startSpan(name).then((scopeId) {
      try {
        fn();
      }
      finally {
        endSpan(scopeId);
      }
    });
  }

}

