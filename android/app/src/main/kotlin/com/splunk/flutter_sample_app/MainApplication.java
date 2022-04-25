package com.splunk.flutter_sample_app;
import android.app.Application;
import com.splunk.rum.Config;
import com.splunk.rum.SplunkRum;
import com.splunk.rum.StandardAttributes;

import io.flutter.app.FlutterApplication;
import io.opentelemetry.api.common.Attributes;

import android.util.Log;

import java.time.Duration;

public class MainApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        Config config =
                SplunkRum.newConfigBuilder()
                        // note: for these values to be resolved, put them in your local.properties
                        // file as
                        // rum.beacon.url and rum.access.token
                        .realm(getResources().getString(R.string.rum_realm))
                        .slowRenderingDetectionPollInterval(Duration.ofMillis(1000))
                        .rumAccessToken(getResources().getString(R.string.rum_access_token))
                        .applicationName("Splunk flutter sample app")
                        .debugEnabled(true)
                        .diskBufferingEnabled(true)
                        .deploymentEnvironment("demo")
//                        .limitDiskUsageMegabytes(1)
                        .globalAttributes(
                                Attributes.builder()
                                        .put("vendor", "Splunk")
                                        .put(
                                                StandardAttributes.APP_VERSION,
                                                BuildConfig.VERSION_NAME)
                                        .build())
                        .build();
        SplunkRum.initialize(config, this);
        Log.i("flutter_sample", "Splunk flutter sample app started");
    }
}
