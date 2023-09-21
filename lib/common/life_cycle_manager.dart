import 'dart:developer';

import 'package:flutter/material.dart';

class LifecycleManager extends StatefulWidget {
  /// 需要監聽的Widget
  final Widget child;

  /// 生命週期Callback
  final LifecycleCallback callback;

  /// 生命週期管理
  ///
  /// 用於管理生命週期，可用於監聽 App 進入前景、背景、暫停、銷毀等狀態
  const LifecycleManager({
    super.key,
    required this.child,
    required this.callback,
  });

  @override
  State<StatefulWidget> createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifecycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    widget.callback.onCreated.call();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('state = $state', name: 'LifecycleManager');
    switch (state) {
      case AppLifecycleState.resumed:
        widget.callback.onResumed.call();
        break;
      case AppLifecycleState.inactive:
        widget.callback.onInactive.call();
        break;
      case AppLifecycleState.paused:
        widget.callback.onPaused.call();
        break;
      case AppLifecycleState.detached:
        widget.callback.onDetached.call();
        break;
      case AppLifecycleState.hidden:
        widget.callback.onDetached.call();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: widget.child);
  }
}

abstract class LifecycleCallback {
  void onCreated() {}

  /// On all platforms, this state indicates that the application is in the
  /// default running mode for a running application that has input focus and is
  /// visible.
  ///
  /// On Android, this state corresponds to the Flutter host view having focus
  /// ([`Activity.onWindowFocusChanged`](https://developer.android.com/reference/android/app/Activity#onWindowFocusChanged(boolean))
  /// was called with true) while in Android's "resumed" state. It is possible
  /// for the Flutter app to be in the [AppLifecycleState.inactive] state while still being in
  /// Android's
  /// ["onResume"](https://developer.android.com/guide/components/activities/activity-lifecycle)
  /// state if the app has lost focus
  /// ([`Activity.onWindowFocusChanged`](https://developer.android.com/reference/android/app/Activity#onWindowFocusChanged(boolean))
  /// was called with false), but hasn't had
  /// [`Activity.onPause`](https://developer.android.com/reference/android/app/Activity#onPause())
  /// called on it.
  ///
  /// On iOS and macOS, this corresponds to the app running in the foreground
  /// active state.
  void onResumed() {}

  /// At least one view of the application is visible, but none have input
  /// focus. The application is otherwise running normally.
  ///
  /// On non-web desktop platforms, this corresponds to an application that is
  /// not in the foreground, but still has visible windows.
  ///
  /// On the web, this corresponds to an application that is running in a
  /// window or tab that does not have input focus.
  ///
  /// On iOS and macOS, this state corresponds to the Flutter host view running in the
  /// foreground inactive state. Apps transition to this state when in a phone
  /// call, when responding to a TouchID request, when entering the app switcher
  /// or the control center, or when the UIViewController hosting the Flutter
  /// app is transitioning.
  ///
  /// On Android, this corresponds to the Flutter host view running in Android's
  /// paused state (i.e.
  /// [`Activity.onPause`](https://developer.android.com/reference/android/app/Activity#onPause())
  /// has been called), or in Android's "resumed" state (i.e.
  /// [`Activity.onResume`](https://developer.android.com/reference/android/app/Activity#onResume())
  /// has been called) but does not have window focus. Examples of when apps
  /// transition to this state include when the app is partially obscured or
  /// another activity is focused, a app running in a split screen that isn't
  /// the current app, an app interrupted by a phone call, a picture-in-picture
  /// app, a system dialog, another view. It will also be inactive when the
  /// notification window shade is down, or the application switcher is visible.
  ///
  /// On Android and iOS, apps in this state should assume that they may be
  /// [AppLifecycleState.hidden] and [AppLifecycleState.paused] at any time.
  void onInactive() {}

  /// The application is not currently visible to the user, and not responding
  /// to user input.
  ///
  /// When the application is in this state, the engine will not call the
  /// [PlatformDispatcher.onBeginFrame] and [PlatformDispatcher.onDrawFrame]
  /// callbacks.
  ///
  /// This state is only entered on iOS and Android.
  void onPaused() {}

  /// The application is still hosted by a Flutter engine but is detached from
  /// any host views.
  ///
  /// The application defaults to this state before it initializes, and can be
  /// in this state (on Android and iOS only) after all views have been
  /// detached.
  ///
  /// When the application is in this state, the engine is running without a
  /// view.
  ///
  /// This state is only entered on iOS and Android, although on all platforms
  /// it is the default state before the application begins running.
  void onDetached() {}

  /// All views of an application are hidden, either because the application is
  /// about to be paused (on iOS and Android), or because it has been minimized
  /// or placed on a desktop that is no longer visible (on non-web desktop), or
  /// is running in a window or tab that is no longer visible (on the web).
  ///
  /// On iOS and Android, in order to keep the state machine the same on all
  /// platforms, a transition to this state is synthesized before the [AppLifecycleState.paused]
  /// state is entered when coming from [AppLifecycleState.inactive], and before the [AppLifecycleState.inactive]
  /// state is entered when coming from [AppLifecycleState.paused]. This allows cross-platform
  /// implementations that want to know when an app is conceptually "hidden" to
  /// only write one handler.
  void onHidden() {}
}
