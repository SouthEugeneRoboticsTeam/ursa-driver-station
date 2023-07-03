import 'package:flutter/material.dart';

import '../domain/dtos/telemetry_message.dart';

class TelemetryTable extends StatelessWidget {
  final TelemetryMessage? telemetryMessage;

  const TelemetryTable({super.key, required this.telemetryMessage});

  TableRow createTableRow(String label, String value) {
    return TableRow(
      children: <Widget>[
        Text(label,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(),
        Text(value, style: const TextStyle(fontSize: 18)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FixedColumnWidth(5),
        2: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        createTableRow('Enabled', telemetryMessage?.enabled.toString() ?? 'no data'),
        createTableRow('Tipped', telemetryMessage?.tipped.toString() ?? 'no data'),
        createTableRow('Voltage', telemetryMessage?.voltage.toString() ?? 'no data'),
        createTableRow('Pitch', telemetryMessage?.pitch.toStringAsFixed(2) ?? 'no data'),
        createTableRow('Pitch Target', telemetryMessage?.pitchTarget.toStringAsFixed(2) ?? 'no data'),
        createTableRow('Pitch Offset', telemetryMessage?.pitchOffset.toStringAsFixed(2) ?? 'no data'),
        createTableRow('Left Speed', telemetryMessage?.leftMotorSpeed.toStringAsFixed(2) ?? 'no data'),
        createTableRow('Right Speed', telemetryMessage?.rightMotorSpeed.toStringAsFixed(2) ?? 'no data'),
      ],
    );
  }
}
