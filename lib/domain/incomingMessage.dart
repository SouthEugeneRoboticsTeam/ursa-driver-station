import 'dart:io';
import 'dart:typed_data';

class IncomingMessage {
  bool enabled = false;
  bool tipped = false;
  int robotId = 0;
  int modelNumber = 0;
  double pitch = 0;
  int voltage = 0;
  int leftMotorSpeed = 0;
  int rightMotorSpeed = 0;
  int auxLength = 0;
  bool containsPid = false;
  double pitchTarget = 0;
  double pitchOffset = 0;
  double speedP = 0;
  double speedI = 0;
  double speedD = 0;
  double angleP = 0;
  double angleI = 0;
  double angleD = 0;

  int messageTime = DateTime.now().millisecondsSinceEpoch;

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

    this.auxLength = bytes[25];
    this.containsPid = bytes[26] == 1;

    if (this.containsPid) {
      this.angleP = data.getFloat32(27, Endian.little);
      this.angleI = data.getFloat32(31, Endian.little);
      this.angleD = data.getFloat32(35, Endian.little);
      this.speedP = data.getFloat32(39, Endian.little);
      this.speedI = data.getFloat32(43, Endian.little);
      this.speedD = data.getFloat32(47, Endian.little);
    }
  }

  IncomingMessage.empty();
}
