import 'dart:io';
import 'dart:typed_data';

class IncomingMessage {
  bool enabled;
  bool tipped;
  int robotId;
  int modelNumber;
  double pitch;
  int voltage;
  int leftMotorSpeed;
  int rightMotorSpeed;
  double pitchTarget;
  double pitchOffset;

  IncomingMessage(List<int> bytes) {
    var buffer = Uint8List.fromList(bytes).buffer;
    var data = ByteData.view(buffer);

    this.enabled = bytes[0] == 1;
    this.tipped = bytes[1] == 1;
    this.robotId = bytes[2];
    this.modelNumber = bytes[3];

    this.pitch = data.getFloat32(4, Endian.little);
    this.voltage = bytes[8];
    this.leftMotorSpeed = data.getInt32(9, Endian.little);
    this.rightMotorSpeed = data.getInt32(13, Endian.little);
    this.pitchTarget = data.getFloat32(17, Endian.little);
    this.pitchOffset = data.getFloat32(21, Endian.little);
  }
}
