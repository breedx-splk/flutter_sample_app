import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SessionIdModel extends ChangeNotifier {

  var _sessionId = "";

  getSessionId(){
    return _sessionId;
  }

  setSessionId(value){
    _sessionId = value;
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
      builder: (context, model, child){
        return Row(
            children: [
              Text("session id: ${model.getSessionId()}"),
            ]
        );
      }
    );
  }

}