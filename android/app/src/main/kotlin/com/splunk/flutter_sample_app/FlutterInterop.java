package com.splunk.flutter_sample_app;

import android.util.Log;

import com.splunk.rum.SplunkRum;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.opentelemetry.api.common.Attributes;
import io.opentelemetry.api.common.AttributesBuilder;
import io.opentelemetry.api.trace.Span;
import io.opentelemetry.context.Scope;

public class FlutterInterop {

    public static SplunkRum rum;
    private final Map<String,Scope> activeScopes = new HashMap<>();
    private final Map<String,Span> activeSpans = new HashMap<>();

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
        if (methodCall.method.equals("startSpan")){
            List<Object> args = methodCall.arguments();
            String spanName = (String) args.get(0);
            String scopeId = startSpan(spanName);
            Log.d("FlutterInterop", "start span with scopeId = " + scopeId);
            result.success(scopeId);
        }
        if(methodCall.method.equals("endSpan")){
            List<Object> args = methodCall.arguments();
            String scopeId = (String) args.get(0);
            Log.d("FlutterInterop", "end span with scopeId = " + scopeId);
            endSpan(scopeId);
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

    public String startSpan(String name) {
        Span span = rum.getOpenTelemetry().getTracer("SplunkRum")
                .spanBuilder(name)
                // TODO: Add common attributes etc.
                .startSpan();
        Scope scope = span.makeCurrent();
        String scopeId = String.valueOf(scope.hashCode());
        activeScopes.put(scopeId, scope); // YIKES, this feels so bad.
        activeSpans.put(scopeId, span); // YIKES, this feels so bad.
        return scopeId;
    }

    public void endSpan(String scopeId){
        activeScopes.get(scopeId).close();
        activeScopes.remove(scopeId);
        activeSpans.get(scopeId).end();
        activeSpans.remove(scopeId);
    }
}
