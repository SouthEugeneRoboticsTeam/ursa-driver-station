import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/connection_model.dart';

Map<ConnectionStatus, Color> colorMap = {
  ConnectionStatus.connected: Colors.green.shade300,
  ConnectionStatus.networkConnected: Colors.orange.shade300,
  ConnectionStatus.disconnected: Colors.red.shade300,
};

class StatusIndicator extends StatelessWidget {
  final ConnectionStatus connectionStatus;
  final bool enabled;

  final double? width;
  final double? height;

  const StatusIndicator(
      {super.key,
      required this.connectionStatus,
      required enabled,
      this.width,
      this.height = 50})
      : enabled = connectionStatus == ConnectionStatus.connected && enabled;

  @override
  Widget build(BuildContext context) {
    String connectionText = getStatusText(context, connectionStatus);
    String enabledText = enabled
        ? AppLocalizations.of(context)!.enabled
        : AppLocalizations.of(context)!.disabled;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (connectionStatus == ConnectionStatus.disconnected) {
              AppSettings.openWIFISettings();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            width: width ?? min(MediaQuery.of(context).size.width * 0.4, 180),
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(8)),
              color: colorMap[connectionStatus],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  connectionText,
                  key: ValueKey(connectionText),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 1,
          height: height,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.black87,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          width: width ?? min(MediaQuery.of(context).size.width * 0.4, 180),
          height: height,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(8)),
              color: enabled ? Colors.green[300] : Colors.red[300]),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                enabledText,
                key: ValueKey(enabledText),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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
