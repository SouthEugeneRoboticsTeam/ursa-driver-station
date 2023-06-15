import 'dart:typed_data';

class CommandMessage {
  final BytesBuilder _builder = BytesBuilder();

  bool enabled = false;
  bool advanced = false;
  int auxiliary = 0;
  double angleP = 0;
  double angleI = 0;
  double angleD = 0;
  double speedP = 0;
  double speedI = 0;
  double speedD = 0;
  int saveRecallState = 1;

  int _speed = 100;

  set speed(int value) {
    _speed = value + 100;
  }

  int get speed {
    return _speed - 100;
  }

  int _turn = 100;

  set turn(int value) {
    _turn = value + 100;
  }

  int get turn {
    return _turn - 100;
  }

  List<int> getBytes() {
    _builder.addByte(enabled ? 1 : 0);
    _builder.addByte(_speed);
    _builder.addByte(_turn);
    _builder.addByte(auxiliary);
    _builder.addByte(advanced ? 1 : 0);

    if (advanced) {
      // Convert float data to a 4-byte array
      var data = ByteData(4);

      data.setFloat32(0, angleP, Endian.little);
      _builder.add(data.buffer.asUint8List(0));

      data.setFloat32(0, angleI, Endian.little);
      _builder.add(data.buffer.asUint8List(0));

      data.setFloat32(0, angleD, Endian.little);
      _builder.add(data.buffer.asUint8List(0));

      data.setFloat32(0, speedP, Endian.little);
      _builder.add(data.buffer.asUint8List(0));

      data.setFloat32(0, speedI, Endian.little);
      _builder.add(data.buffer.asUint8List(0));

      data.setFloat32(0, speedD, Endian.little);
      _builder.add(data.buffer.asUint8List(0));
    }

    _builder.addByte(saveRecallState);

    return _builder.takeBytes();
  }
}