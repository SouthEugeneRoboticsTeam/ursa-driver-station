import 'dart:typed_data';

class TelemetryMessage {
  List<int> bytes = [];

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

  DateTime messageTime = DateTime.now();

  TelemetryMessage(List<int> bytes) {
    this.bytes = bytes;

    var buffer = Uint8List.fromList(bytes).buffer;
    var data = ByteData.view(buffer);

    enabled = bytes[0] == 1;
    tipped = bytes[1] == 1;
    robotId = bytes[2];
    modelNumber = bytes[3];

    pitch = data.getFloat32(4, Endian.little);
    voltage = bytes[8];
    leftMotorSpeed = data.getInt32(9, Endian.little);
    rightMotorSpeed = data.getInt32(13, Endian.little);
    pitchTarget = data.getFloat32(17, Endian.little);
    pitchOffset = data.getFloat32(21, Endian.little);

    auxLength = bytes[25];
    containsPid = bytes[26] == 1;

    if (containsPid) {
      angleP = data.getFloat32(27, Endian.little);
      angleI = data.getFloat32(31, Endian.little);
      angleD = data.getFloat32(35, Endian.little);
      speedP = data.getFloat32(39, Endian.little);
      speedI = data.getFloat32(43, Endian.little);
      speedD = data.getFloat32(47, Endian.little);
    }
  }

  // to string
  @override
  String toString() {
    return bytes.toString();
  }

  TelemetryMessage.empty();
}
