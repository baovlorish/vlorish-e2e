import 'dart:async';
import 'dart:html' as html;

enum CustomConnectionState { connected, none }

class ConnectionListener {
  ConnectionListener? instance;
  StreamController<CustomConnectionState>? _connectivityResult;

  ConnectionListener._internal();

  static final ConnectionListener _singleton = ConnectionListener._internal();

  factory ConnectionListener() => _singleton;

  Stream<CustomConnectionState> get onConnectivityChanged {
    _connectivityResult ??= StreamController<CustomConnectionState>();

    html.window.onOnline.listen((event) {
      _connectivityResult!.add(CustomConnectionState.connected);
    });
    html.window.onOffline.listen((event) {
      _connectivityResult!.add(CustomConnectionState.none);
    });

    return _connectivityResult!.stream;
  }
}
