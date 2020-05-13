


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Router {

  static Future<T> push<T extends Object>({BuildContext context, WidgetBuilder builder}) {
    return Navigator.push(
        context,
        PageRoute(builder: builder)
    );
  }

}

class PageRoute<T> extends MaterialPageRoute<T> {
  PageRoute({WidgetBuilder builder, RouteSettings settings}): super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => Duration(milliseconds: 600);

}