import 'dart:async';
import 'dart:html';

import 'package:css_animation/css_animation.dart';

class Toast {
  Element _toastElement;

  List<StreamSubscription> subs;

  bool _delayRemoval = false;  // delay removal if mouse cursor is hovering over toast
  bool _isExpired = false;     // has the removal timer expired?

  StreamController _onRemoved = new StreamController.broadcast();
  Stream get onRemoved => _onRemoved.stream;

  Toast(String title, String message, {MessageType type, ToastPos position, Duration duration}) {
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
    _toastElement = new DivElement()..className = "toast ${_getTypeClass(type ?? MessageType.plain)}";

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

    subs = [
      _toastElement.onClick.listen((_) => remove()),
      _toastElement.onMouseEnter.listen((_) => _delayRemoval = true),
      _toastElement.onMouseLeave.listen((_) {
        _delayRemoval = false;
        remove();
      })
    ];

    // remove the toast after [duration]
    new Future.delayed(duration ?? const Duration(seconds: 2), () {
      _isExpired = true;
      remove();
    });
  }

  factory Toast.success({String title, String message, ToastPos position, Duration duration}) =>
    new Toast(title, message, type: MessageType.success, position: position, duration: duration);

  factory Toast.info({String title, String message, ToastPos position, Duration duration}) =>
    new Toast(title, message, type: MessageType.info, position: position, duration: duration);

  factory Toast.warning({String title, String message, ToastPos position, Duration duration}) =>
    new Toast(title, message, type: MessageType.warning, position: position, duration: duration);

  factory Toast.error({String title, String message, ToastPos position, Duration duration}) =>
    new Toast(title, message, type: MessageType.error, position: position, duration: duration);

  void remove() {
    if (!removed && !_delayRemoval && _isExpired) {
      _cancelSubs();

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

  String _getTypeClass(MessageType type) {
    switch (type) {
      case MessageType.plain: return 'toast-plain';
      case MessageType.success: return 'toast-success';
      case MessageType.error: return 'toast-error';
      case MessageType.warning: return 'toast-warning';
      case MessageType.info: return 'toast-info';
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

  void _cancelSubs() {
    for (StreamSubscription sub in subs) {
      sub.cancel();
    }

    subs = null;
  }

  bool get removed => _toastElement == null;
}

enum MessageType {
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