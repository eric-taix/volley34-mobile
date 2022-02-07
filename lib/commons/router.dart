import 'package:flutter/material.dart';

class RouterFacade {
  static Future<T?> push<T extends Object>({required BuildContext context, required WidgetBuilder builder}) {
    return Navigator.push(context, PageRoute(builder: builder));
  }
}

class PageRoute<T> extends MaterialPageRoute<T> {
  PageRoute({required WidgetBuilder builder, RouteSettings? settings}) : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => Duration(milliseconds: 600);
}
