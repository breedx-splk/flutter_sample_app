// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_sample_app/biz_logic.dart';
import 'package:flutter_sample_app/rum.dart';
import 'package:flutter_sample_app/session_id.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const FlutterSampleApp());
}

class FlutterSampleApp extends StatelessWidget {
  const FlutterSampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Sample App',
        home: Scaffold(
          appBar: AppBar(
              title: const Text("Flutter Sample App")
          ),
          body: FirstPageLayout(),
        )
    );
  }
}

class FirstPageLayout extends StatelessWidget {
   final bizLogic = OtelInstrumentedBizLogic();

  FirstPageLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sessionIdModel = SessionIdModel();
    var sessionIdText = const SessionIdText();
    rum.getSessionId().then((value) {
      debugPrint("Splunk RUM session id => $value");
      sessionIdModel.setSessionId(value);
    });
    return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Row(
                children: const [
                  Text('dart + splunk rum'),
                ]
            ),
            ChangeNotifierProvider(
              create: (context) => sessionIdModel,
              child: sessionIdText
            ),
            buildEventRow(),
            buildCodeGenRow(),
            buildManualRow()
          ]
      )
    );
  }

  Row buildEventRow() {
    var droidButton = IconButton(
      padding: const EdgeInsets.all(0),
      iconSize: 100,
      alignment: Alignment.centerRight,
      icon: (const Icon(Icons.adb_outlined)),
      color: Colors.blueGrey[500],
      onPressed: _droidClicked,
    );
    return Row(children: [
      const Text(
        'Click for event:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
      ),
      droidButton
    ]);
  }

  Row buildCodeGenRow() {
    var traceButton = IconButton(
      padding: const EdgeInsets.all(0),
      iconSize: 75,
      alignment: Alignment.centerRight,
      icon: (const Icon(Icons.account_tree_outlined)),
      color: Colors.pinkAccent[500],
      onPressed: () => bizLogic.doGreatThing(),
    );
    return Row(children: [
      const Text(
        'Trace (generated):',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
      ),
      traceButton
    ]);
  }

  Row buildManualRow() {
    var traceButton = IconButton(
      padding: const EdgeInsets.all(0),
      iconSize: 75,
      alignment: Alignment.centerRight,
      icon: (const Icon(Icons.account_tree_outlined)),
      color: Colors.cyan[500],
      onPressed: () => _traceManual(),
    );
    return Row(children: [
      const Text(
        'Trace (manual): ',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 28),
      ),
      traceButton
    ]);
  }

  dynamic _traceManual() async {
    debugPrint("trace manual started");
    var result = await rum.runInSpan("outer skin", () async {
      debugPrint("outer skin");
      return await rum.runInSpan("musculature", () async {
        debugPrint("musculature");
        return await rum.runInSpan("inner skeleton", () async {
          debugPrint("Inner skeleton");
          return await Future.delayed(const Duration(seconds: 1), () => "trace complete");
        });
      });
    });
    debugPrint(result);
  }

  void _droidClicked(){
    debugPrint("robot was clicked");
    var words = WordPair.random().asPascalCase;
    var attributes = {
      "click.target": "a robot",
      "click.reason": "futility"
    };
    rum.addRumEvent(words, attributes);
  }

}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  ListView buildBody() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return const Divider();
        /*2*/

        final index = i ~/ 2; /*3*/
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10)); /*4*/
        }
        return ListTile(
          title: Text(
            _suggestions[index].asPascalCase,
            style: _biggerFont,
          ),
        );
      },
    );
  }
}
