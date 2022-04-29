# flutter_sample_app

Sample flutter app.

Exploring some instrumentation ideas for flutter+dart+otel, that's all.

# sample app

To start, run `flutter get` to grab dependencies.

The sample app is in `main.dart`. Just run it with the android emulator.

<img width="415" alt="image" src="https://user-images.githubusercontent.com/75337021/166078476-cfca73c5-dc20-4cc6-b57c-b0e3d026b778.png">

* Press the copy button to grab the session id to the clipboard
* Click the android to generate a custom event
* Click the black tree to generate a trace from generated code (does not yet work)
* Click the cyan tree to generate a trace with manual instrumentation

# build / codegen

There is some instrumentation created with build-time code generation.

```
$ flutter pub run build_runner build
```
