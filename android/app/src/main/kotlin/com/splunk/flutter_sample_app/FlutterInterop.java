package com.splunk.flutter_sample_app;

import android.util.Log;

import com.splunk.rum.SplunkRum;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.opentelemetry.api.common.Attributes;
import io.opentelemetry.api.common.AttributesBuilder;

public class FlutterInterop {

    public static SplunkRum rum;

    public void dispatch(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("addRumEvent")) {
            Log.i("FlutterInterop", "dispatching addRumEvent");
            List<Object> args = methodCall.arguments();
            String name = (String) args.get(0);
            Map<String, String> attrMap = (Map<String, String>) args.get(1);
            AttributesBuilder attributesBuilder = Attributes.builder();
            for (Map.Entry<String, String> entry : attrMap.entrySet()) {
                attributesBuilder.put(entry.getKey(), entry.getValue());
            }
            rum.addRumEvent(name, attributesBuilder.build());
        }
        if (methodCall.method.equals("getSessionId")){
            result.success(getSessionId());
        }
    }

    public String getSessionId() {
        return rum.getRumSessionId();
    }

    public void addRumEvent(String name, Map<String, String> attributes) {
        Log.i("FlutterInterop", "addRumEvent was called with name=" + name);
        AttributesBuilder attributesBuilder = Attributes.builder();
        for (Map.Entry<String, String> entry : attributes.entrySet()) {
            attributesBuilder.put(entry.getKey(), entry.getValue());
        }
        rum.addRumEvent(name, attributesBuilder.build());
    }
}
