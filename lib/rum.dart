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

  Future<dynamic> runInSpan(String name, Function fn) async {
    return startSpan(name).then((scopeId) async {
      try {
        Future<dynamic> result = fn();
        return await result;
      }
      finally {
        endSpan(scopeId);
      }
    });
  }

}

