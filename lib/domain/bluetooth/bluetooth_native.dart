import 'package:collection/collection.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothProvider {
  static final BluetoothProvider _instance = BluetoothProvider._internal();

  factory BluetoothProvider() {
    return _instance;
  }

  BluetoothProvider._internal() {
    flutterBlue = FlutterBluePlus.instance;
  }

  late FlutterBluePlus flutterBlue;

  Future<BluetoothDevice> getDevice(String address) async {
    // check if device is already connected
    List<BluetoothDevice> devices = await flutterBlue.connectedDevices;
    for (BluetoothDevice device in devices) {
      if (device.id.toString() == address) {
        return device;
      }
    }

    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    print('getDevice 1');

    // create generator from scan results
    Stream<BluetoothDevice?> scanResults = flutterBlue.scanResults.map((scanResults) {
      for (ScanResult result in scanResults) {
        if (result.device.name == '') continue;
        print('${result.device.name} found! rssi: ${result.rssi}');
      }

      return scanResults.firstWhereOrNull((result) => result.device.id.toString() == address)?.device;
    });

    print('getDevice 2');

    BluetoothDevice? result = await scanResults.firstWhere((element) => element != null);

    return result!;
  }

  void getConnectedDevices() async {
    print('getConnectedDevices');
    List<BluetoothDevice> devices = await flutterBlue.connectedDevices;
    print('# devices: ${devices.length}');
    for (BluetoothDevice device in devices) {
      print('${device.name} is connected!');
    }
  }

  void getBondedDevices() async {
    print('getBondedDevices');
    List<BluetoothDevice> devices = await flutterBlue.bondedDevices;
    print('# devices: ${devices.length}');
    for (BluetoothDevice device in devices) {
      var state = await device.state.first;
      print('Bonded: ${device.name}, ${device.id}, ${device.type}, ${state}');
    }
  }

  Future<BluetoothDevice> connectToDevice(String address) async {
    print('finding device with address $address');
    BluetoothDevice device = await getDevice(address);
    print('device found, connecting...');

    BluetoothDeviceState connectionState = await device.state.first;
    if (connectionState == BluetoothDeviceState.connected) {
      print('device already connected');
      return device;
    }

    await device.connect(timeout: const Duration(seconds: 10), autoConnect: true);
    print('Connected to ${device.name}');

    return device;
  }

  void doSomething() async {
    // BluetoothDevice device = await connectToDevice('40:22:D8:3C:23:4E');

    BluetoothDevice device = BluetoothDevice.fromId('40:22:D8:3C:23:4E');
    BluetoothDeviceState connectionState = await device.state.first;
    if (connectionState != BluetoothDeviceState.connected) {
      await device.connect(timeout: const Duration(seconds: 10), autoConnect: true);
    }

    List<BluetoothService> services = await device.discoverServices();
    print('services: $services');

    BluetoothService? robotService = services.firstWhereOrNull((service) => service.uuid.toString() == '4fafc201-1fb5-459e-8fcc-c5c9c331914b');
    BluetoothCharacteristic? telemCharacteristic = robotService?.characteristics.firstWhereOrNull((characteristic) => characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8');

    print(robotService);
    print(telemCharacteristic);

    telemCharacteristic?.setNotifyValue(true);

    telemCharacteristic?.read().then((value) {
      String stringValue = String.fromCharCodes(value);
      print('First BLE value: $value ($stringValue)');
    });

    telemCharacteristic?.value.listen((value) {
      String stringValue = String.fromCharCodes(value);
      print('BLE value: $value ($stringValue)');
    });

    // for (BluetoothService service in services) {
    //   print('service: ${service.uuid}');
    //   for (BluetoothCharacteristic characteristic in service.characteristics) {
    //     print('characteristic: ${characteristic.uuid}');

    //     if (characteristic.properties.read) {
    //       List<int> value = await characteristic.read();
    //       print('value: $value');

    //       // value to string
    //       String stringValue = String.fromCharCodes(value);
    //       print('stringValue: $stringValue');
    //     } else {
    //       print('characteristic does not support read');
    //     }
    //   }
    // }
  }
}
