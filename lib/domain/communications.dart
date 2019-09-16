import 'dart:async';
import 'dart:io';

import 'package:flutter/scheduler.dart';
import 'package:ursa_ds_mobile/domain/incomingMessage.dart';
import 'package:ursa_ds_mobile/domain/outgoingMessage.dart';

final InternetAddress address = InternetAddress('10.25.21.1');
final int port = 2521;

OutgoingMessage message = OutgoingMessage();

RawDatagramSocket socket;
Timer sendLoop;
StreamSubscription subscription;

const interval = Duration(milliseconds: 50); // 20Hz refresh

Future initSocket() async {
  if (socket != null) socket.close();

  socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
}

void initSendLoop() {
  if (sendLoop != null) sendLoop.cancel();

  sendLoop = Timer.periodic(interval, (Timer t) => SchedulerBinding.instance.scheduleTask(() => sendData(message.getBytes()), Priority.touch));
}

void receiveData(Function(IncomingMessage) onDataReceived) async {
  assert(socket != null);

  if (subscription != null) await subscription.cancel();

  subscription = socket.listen((RawSocketEvent e) {
    Datagram d = socket.receive();
    if (d == null) return;

    onDataReceived(IncomingMessage(d.data));
  });
}

void sendData(List<int> message) {
  assert(socket != null);

  socket.send(message, address, port);
}
