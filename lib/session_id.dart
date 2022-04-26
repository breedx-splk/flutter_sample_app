import 'package:flutter/material.dart';
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
        TextEditingController myController = TextEditingController()..text = model.getSessionId();
        return Row(
            children: [
              Flexible(
                child: TextField(
                    controller: myController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'session id:',
                    )
                )
              )
            ]
        );
      }
    );
  }
}