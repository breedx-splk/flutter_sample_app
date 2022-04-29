# flutter_sample_app

Sample flutter app.

Exploring some instrumentation ideas for flutter+dart+otel, that's all.

# sample app

To start, run `flutter get` to grab dependencies.

The sample app is in `main.dart`. Just run it with the android emulator.

<img width="250" alt="image" src="https://user-images.githubusercontent.com/75337021/166078594-5a107b5a-d6b4-4172-ae6d-b8570407f77a.png">

* Press the copy button to grab the session id to the clipboard
* Click the android to generate a custom event
* Click the black tree to generate a trace from generated code (does not yet work)
* Click the cyan tree to generate a trace with manual instrumentation

# build / codegen

There is some instrumentation created with build-time code generation.

```
$ flutter pub run build_runner build
```
