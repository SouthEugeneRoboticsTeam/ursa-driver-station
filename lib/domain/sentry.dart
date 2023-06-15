import 'package:sentry_flutter/sentry_flutter.dart';

Future initSentry(AppRunner? appRunner) async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://11c99f1c3a524901a6fa6e6749bba354@o255745.ingest.sentry.io/4505365201420288';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: appRunner,
  );
}
