import 'dart:async';
import 'dart:io';
import 'outgoingMessage.dart';

//final InternetAddress address = InternetAddress('10.25.21.1');
final InternetAddress address = InternetAddress.loopbackIPv4;
final int port = 2521;

OutgoingMessage message = OutgoingMessage();

RawDatagramSocket socket;

Future initSocket() async {
  socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
}

void initSendLoop() {
//  const interval = Duration(milliseconds: 50); // 20Hz refresh
  const interval = Duration(seconds: 1); // 20Hz refresh
  Timer.periodic(interval, (Timer t) => sendData(message.getBytes()));
}

void receiveData(Function(String) onDataReceived) {
  if (socket == null) return;

  socket.listen((RawSocketEvent e) {
    Datagram d = socket.receive();
    if (d == null) return;

//    String message = String.fromCharCodes(d.data);

    onDataReceived(d.data.toString());
  });
}

void sendData(List<int> message) {
  if (socket == null) return;

  socket.send(message, address, port);
}
