import 'dart:async';
import 'dart:html';

import 'package:css_animation/css_animation.dart';

class Toast {
  Element _toastElement;

  StreamSubscription _clickSub;

  StreamController _onRemoved = new StreamController.broadcast();
  Stream get onRemoved => _onRemoved.stream;

  Toast(String title, String message, {ToastType type, ToastPos position, Duration duration}) {
    // get container element
    Element toastContainerElement = document.body.querySelector('#toast-container');

    // if the container element doesn't exist, create it
    if (toastContainerElement == null) {
      toastContainerElement = new DivElement()..id = 'toast-container';
      document.body.children.add(toastContainerElement);
    }

    // set position
    toastContainerElement.className = _getPosClass(position ?? ToastPos.topRight);

    // create toast element
    _toastElement = new DivElement()..className = "toast ${_getTypeClass(type ?? ToastType.plain)}";

    // create title element
    if (title?.isNotEmpty ?? false) {
      final titleElement = new DivElement()
        ..className = 'toast-title'
        ..text = title;

      _toastElement.children.add(titleElement);
    }

    // create message element
    if (message?.isNotEmpty ?? false) {
      final messageElement = new DivElement()
        ..className = 'toast-message'
        ..text = message;

      _toastElement.children.add(messageElement);
    }

    // add toast element to container element
    toastContainerElement.children.add(_toastElement);

    _clickSub = _toastElement.onClick.listen((_) => remove());

    // remove the toast after [duration]
    new Future.delayed(duration ?? const Duration(seconds: 2), remove);
  }

  factory Toast.success({String title, String message, ToastPos position, Duration duration}) =>
    new Toast(title, message, type: ToastType.success, position: position, duration: duration);

  factory Toast.info({String title, String message, ToastPos position, Duration duration}) =>
    new Toast(title, message, type: ToastType.info, position: position, duration: duration);

  factory Toast.warning({String title, String message, ToastPos position, Duration duration}) =>
    new Toast(title, message, type: ToastType.warning, position: position, duration: duration);

  factory Toast.error({String title, String message, ToastPos position, Duration duration}) =>
    new Toast(title, message, type: ToastType.error, position: position, duration: duration);

  void remove() {
    if (!removed) {
      _clickSub?.cancel();
      _clickSub = null;

      // TODO: Provide a way to customize animations.
      CssAnimation animation = new CssAnimation.properties(
        {'opacity': 0.8},
        {'opacity': 0}
      );

      animation.apply(_toastElement, duration: 500, onComplete: () {
        _toastElement.remove();
        _toastElement = null;
        _onRemoved.add(null);
      });
    }
  }

  String _getTypeClass(ToastType type) {
    switch (type) {
      case ToastType.plain: return 'toast-plain';
      case ToastType.success: return 'toast-success';
      case ToastType.error: return 'toast-error';
      case ToastType.warning: return 'toast-warning';
      case ToastType.info: return 'toast-info';
    }

    throw new UnsupportedError('Invalid toast type.');
  }
  
  String _getPosClass(ToastPos pos) {
    switch (pos) {
      case ToastPos.topLeft: return ' toast-top-left';
      case ToastPos.topRight: return ' toast-top-right';
      case ToastPos.bottomLeft: return ' toast-bottom-left';
      case ToastPos.bottomRight: return ' toast-bottom-right';
      case ToastPos.topCenter: return ' toast-top-center';
      case ToastPos.bottomCenter: return ' toast-bottom-center';
    }

    throw new UnsupportedError('Invalid toast position.');
  }

  bool get removed => _toastElement == null;
}

enum ToastType {
  plain,
  success,
  error,
  warning,
  info
}

enum ToastPos {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  topCenter,
  bottomCenter
}