
/*
Example/spike of some splunk RUM behaviors in Dart
*/

import 'dart:collection';

import 'package:flutter/services.dart';

class SplunkRum {
  final channel = const MethodChannel("com.splunk/rum");

  addRumEvent(name, attributes) async {
    await channel.invokeMethod("addRumEvent", [name, attributes]);
  }

  getSessionId(){
    return channel.invokeMethod("getSessionId");
  }

}