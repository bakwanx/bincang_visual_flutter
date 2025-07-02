import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum ScreenType {
  watch,
  phone,
  tablet,
  desktop,
}

extension ContextExtension on BuildContext {
  bool isTablet() {
    return _screenType == ScreenType.tablet;
  }

  bool isPhone() {
    return _screenType == ScreenType.phone;
  }

  bool isDesktop() {
    return _screenType == ScreenType.desktop;
  }

  bool isWatch() {
    return _screenType == ScreenType.watch;
  }

  bool isPortrait() {
    return MediaQuery.of(this).orientation == Orientation.portrait;
  }

  ScreenType get _screenType {
    final deviceWidth = MediaQuery.of(this).size.shortestSide;
    if (deviceWidth >= 1200) return ScreenType.desktop;
    if (deviceWidth >= 550) return ScreenType.tablet;
    if (deviceWidth < 300) return ScreenType.watch;
    return ScreenType.phone;
  }

  double width() {
    final deviceWidth = MediaQuery.of(this).size.width;
    return deviceWidth;
  }

  double height() {
    final deviceWidth = MediaQuery.of(this).size.height;
    return deviceWidth;
  }

  Future<dynamic> push(Widget page) =>
      Navigator.of(this).push(CustomPageRoute(page));

  Future<dynamic> pushReplacement(Widget page) =>
      Navigator.of(this).pushReplacement(CustomPageRoute(page));

  Future<dynamic> pushAndRemoveUntil(Widget page) =>
      Navigator.of(this).pushAndRemoveUntil(
        CustomPageRoute(page),
            (route) => false,
      );
}

class CustomPageRoute<T> extends PageRoute<T> {
  final Widget child;
  CustomPageRoute(this.child);

  @override
  @SemanticsHintOverrides()
  Color? get barrierColor => Colors.transparent;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: child);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}
