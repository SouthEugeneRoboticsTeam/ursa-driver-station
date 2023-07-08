import 'package:flutter/material.dart';

import '../models/robot_state_model.dart';

class TelemetryTable extends StatelessWidget {
  final RobotStateModel robotState;

  const TelemetryTable({super.key, required this.robotState});

  TableRow createTableRow(String label, String value) {
    return TableRow(
      children: <Widget>[
        Text(
          label,
          textAlign: TextAlign.right,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
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
        createTableRow('Enabled', robotState.enabled?.toString() ?? 'no data'),
        createTableRow('Tipped', robotState.tipped?.toString() ?? 'no data'),
        createTableRow('Voltage', robotState.voltage?.toString() ?? 'no data'),
        createTableRow(
            'Pitch', robotState.pitch?.toStringAsFixed(2) ?? 'no data'),
        createTableRow('Pitch Target',
            robotState.pitchTarget?.toStringAsFixed(2) ?? 'no data'),
        createTableRow('Pitch Offset',
            robotState.pitchOffset?.toStringAsFixed(2) ?? 'no data'),
        createTableRow('Left Speed',
            robotState.leftMotorSpeed?.toStringAsFixed(2) ?? 'no data'),
        createTableRow('Right Speed',
            robotState.rightMotorSpeed?.toStringAsFixed(2) ?? 'no data'),
      ],
    );
  }
}
