# dart_toast

Support for simple toast messages in Dart web apps.

## Usage

First, be sure to include the CSS in your index.html file:

    <link rel="stylesheet" href="packages/dart_toast/dart_toast.css">

A simple usage example:

    import 'dart:html';

    import 'package:dart_toast/dart_toast.dart';

    void main() {
      document.getElementById('toast-btn').onClick.listen((_) {
        new Toast("Toast!", "A toasty toast.");
      });

      document.getElementById('success-btn').onClick.listen((_) {
        new Toast.success(title: "Success!", message: "Misson accomplished.");
      });

      document.getElementById('error-btn').onClick.listen((_) {
        new Toast.error(title: "Error!", message: "Misson failed.");
      });

      document.getElementById('warning-btn').onClick.listen((_) {
        new Toast.warning(title: "Warning!", message: "Misson in jeopardy.");
      });

      document.getElementById('info-btn').onClick.listen((_) {
        new Toast.info(title: "Info!", message: "Misson briefing complete.");
      });

      document.getElementById('top-left-btn').onClick.listen((_) {
        new Toast("Top Left",  "Look at me!", position: ToastPos.topLeft);
      });

      document.getElementById('top-right-btn').onClick.listen((_) {
        new Toast("Top Right",  "Look at me!", position: ToastPos.topRight);
      });

      document.getElementById('bottom-left-btn').onClick.listen((_) {
        new Toast("Bottom Left",  "Look at me!", position: ToastPos.bottomLeft);
      });

      document.getElementById('bottom-right-btn').onClick.listen((_) {
        new Toast("Bottom Right",  "Look at me!", position: ToastPos.bottomRight);
      });

      document.getElementById('top-center-btn').onClick.listen((_) {
        new Toast("Top Center",  "Look at me!", position: ToastPos.topCenter);
      });

      document.getElementById('bottom-center-btn').onClick.listen((_) {
        new Toast("Bottom Center",  "Look at me!", position: ToastPos.bottomCenter);
      });
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/montyr75/dart_toast/issues
