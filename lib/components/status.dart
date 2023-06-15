import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ursa_ds_mobile/models/connection_model.dart';

Map<ConnectionStatus, Color> colorMap = {
  ConnectionStatus.connected: Colors.green.shade300,
  ConnectionStatus.networkConnected: Colors.orange.shade300,
  ConnectionStatus.disconnected: Colors.red.shade300,
};

class StatusIndicator extends StatelessWidget {
  final ConnectionStatus _connectionStatus;
  final bool _enabled;

  const StatusIndicator({super.key, required connectionStatus, required enabled})
  : _connectionStatus = connectionStatus,
    _enabled = connectionStatus == ConnectionStatus.connected && enabled;

  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width * 0.4, 180);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
            color: colorMap[_connectionStatus],
          ),
          child: Center(
            child: Text(
              getStatusText(context, _connectionStatus),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ),
        ),

        Container(
          width: 1,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.black87,
          ),
        ),

        Container(
          width: width,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
            color: _enabled ? Colors.green[300] : Colors.red[300]
          ),
          child: Center(
            child: Text(
              _enabled ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ),
        ),
      ],
    );
  }

  String getStatusText(BuildContext context, ConnectionStatus connectionState) {
    switch (connectionState) {
      case ConnectionStatus.connected:
        return AppLocalizations.of(context)!.connected;
      case ConnectionStatus.networkConnected:
        return AppLocalizations.of(context)!.networkConnected;
      case ConnectionStatus.disconnected:
        return AppLocalizations.of(context)!.disconnected;
    }
  }
}
