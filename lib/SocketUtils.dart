// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

class SocketUtils {
  Socket? _socket;
  static const String SERVET_IP = "192.168.103.96";
  static const int SERVET_PORT = 6000;

  Future<bool> sendMessage(String message, Function connectionListner,
      Function messageListner) async {
    try {
      _socket = await Socket.connect(SERVET_IP, SERVET_PORT);
      connectionListner(true);
      _socket!.listen((List<int> event) {
        // print message here
        String message = utf8.decode(event);
        print("Message : $message\n");
        messageListner(message);
      });
      _socket!.add(utf8.encode(message));
      _socket!.close();
    } catch (e) {
      connectionListner(false);
      return false;
    }
    return true;
  }

  void cleanUp() {
    if (_socket != null) {
      _socket!.destroy();
    }
  }
}
