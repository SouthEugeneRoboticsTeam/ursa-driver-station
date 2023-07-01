import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart' as model_viewer;
import 'package:webview_flutter/webview_flutter.dart' as webview;

String js = '''
  const modelViewer = document.querySelector('#robot-viewer');

  const updateOrientation = (roll, pitch, yaw) => {
    modelViewer.orientation = `\${roll}deg \${pitch}deg \${yaw}deg`;
  };

  // on page load
  window.addEventListener('load', () => {
    // set initial orientation
    updateOrientation(0, 0, -180);
  });
''';

class ModelViewer extends StatefulWidget {
  const ModelViewer({super.key, this.yaw = 0, this.pitch = 0});

  final double yaw;
  final double pitch;

  @override
  ModelViewerState createState() => ModelViewerState();
}

class ModelViewerState extends State<ModelViewer> with AutomaticKeepAliveClientMixin {
  webview.WebViewController? _controller;

  DateTime _lastUpdate = DateTime.now();

  @override
  void didUpdateWidget(covariant ModelViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // update at most 20Hz
    if (DateTime.now().difference(_lastUpdate).inMilliseconds < 50) {
      return;
    }

    _lastUpdate = DateTime.now();
    _controller?.runJavaScript('updateOrientation(0, ${widget.pitch * -1}, ${-widget.yaw - 180})');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return model_viewer.ModelViewer(
      id: "robot-viewer",
      src: 'assets/headbot_transparent.glb',
      alt: "A model of a robot",
      autoRotate: true,
      autoRotateDelay: 0,
      rotationPerSecond: '5deg',
      cameraControls: false,
      cameraOrbit: '0deg 90deg auto',
      fieldOfView: '10deg',

      onWebViewCreated: (webview.WebViewController controller) {
        setState(() {
          _controller = controller;
        });
      },

      relatedJs: js,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
