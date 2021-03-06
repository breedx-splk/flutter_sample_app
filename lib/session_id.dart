import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SessionIdModel extends ChangeNotifier {
  var _sessionId = "unknown";

  getSessionId(){
    return _sessionId;
  }

  setSessionId(value){
    _sessionId = value;
    notifyListeners();
  }
}

class SessionIdText extends StatefulWidget {

  const SessionIdText({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SessionId();

}

class _SessionId extends State<SessionIdText> {

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionIdModel>(
      builder: (context, model, child) {
        TextEditingController textController = TextEditingController()..text = model.getSessionId();
        return Row(
            children: [
              Flexible(
                child: TextField(
                    controller: textController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'session id:',
                    )
                )
              ),
              IconButton(
                padding: const EdgeInsets.all(0),
                iconSize: 28,
                alignment: Alignment.center,
                icon: (const Icon(Icons.copy)),
                color: Colors.black38,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: model.getSessionId()));
                },
              ),
              const SizedBox(height: 75)
            ]
        );
      }
    );
  }
}