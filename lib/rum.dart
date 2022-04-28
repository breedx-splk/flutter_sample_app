/*
Example/spike of some splunk RUM behaviors in Dart
*/
library rum;
export 'rum.dart';

import 'package:flutter/services.dart';

class SplunkRum {
  final channel = const MethodChannel("com.splunk/rum");

  addRumEvent(name, attributes) async {
    await channel.invokeMethod("addRumEvent", [name, attributes]);
  }

  getSessionId() {
    return channel.invokeMethod("getSessionId");
  }

}

