import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart' as model_viewer;

String js = '''
  window.modelViewer = document.querySelector('#robot-viewer');
  window.updateOrientation = (roll, pitch, yaw) => {
    window.modelViewer.orientation = `\${roll}deg \${pitch}deg \${yaw}deg`;
  };

  // on page load
  (() => {
    updateOrientation(0, 0, -180);

    clearInterval(window.updateInterval);
    window.updateInterval = setInterval(() => {
      modelViewer.model.materials[0].pbrMetallicRoughness.setBaseColorFactor([Math.random(), Math.random(), Math.random()]);
      // modelViewer.model.materials[1].pbrMetallicRoughness.setBaseColorFactor([Math.random(), Math.random(), Math.random()]);
      modelViewer.model.materials[2].pbrMetallicRoughness.setBaseColorFactor([Math.random(), Math.random(), Math.random()]);
    }, 500);
  })();
''';

@JS('updateOrientation')
external void updateOrientation(int roll, int pitch, int yaw);

class ModelViewer extends StatelessWidget {
  ModelViewer({super.key, double yaw = 0, double pitch = 0}) {
    updateOrientation(0, pitch.round(), yaw.round() - 180);
  }

  @override
  Widget build(BuildContext context) {
    return model_viewer.ModelViewer(
      id: "robot-viewer",
      src: 'assets/Robot.glb',
      alt: "A model of a robot",
      autoRotate: true,
      autoRotateDelay: 0,
      rotationPerSecond: '5deg',
      cameraControls: false,
      cameraOrbit: '0deg 90deg auto',
      fieldOfView: '10deg',

      animationName: 'Dance',
      autoPlay: true,

      relatedJs: js,
    );
  }
}
