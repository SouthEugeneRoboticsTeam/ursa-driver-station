import 'dart:io';

final InternetAddress robotAddress = InternetAddress('10.25.21.1');
// final InternetAddress robotAddress = InternetAddress('10.0.0.244');
const int robotPort = 2521;

void logNetworkInterfaces() async {
  for (var interface in await NetworkInterface.list()) {
    print('== Interface: ${interface.name} ==');
    for (var addr in interface.addresses) {
      print(
          '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
    }
  }
}

Future<List<InternetAddress>> getNetworkIps() async {
  List<InternetAddress> wifiIPs = [];
  for (var interface in await NetworkInterface.list()) {
    for (var addr in interface.addresses) {
      if (addr.type.name == 'IPv4') {
        wifiIPs.add(addr);
      }
    }
  }
  return wifiIPs;
}

Future<bool> isRobotConnected() async {
  // true if any of network ips start with 10.25.21
  for (var address in await getNetworkIps()) {
    if (address.rawAddress[0] == robotAddress.rawAddress[0] &&
        address.rawAddress[1] == robotAddress.rawAddress[1] &&
        address.rawAddress[2] == robotAddress.rawAddress[2]) {
      return true;
    }
  }

  return false;
}

Future<InternetAddress?> getRobotAddress() async {
  // true if any of network ips start with 10.25.21
  for (var address in await getNetworkIps()) {
    if (address.rawAddress[0] == robotAddress.rawAddress[0] &&
        address.rawAddress[1] == robotAddress.rawAddress[1] &&
        address.rawAddress[2] == robotAddress.rawAddress[2]) {
      return address;
    }
  }

  return null;
}
