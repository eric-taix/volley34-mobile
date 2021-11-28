import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextTabBar extends StatelessWidget with PreferredSizeWidget {
  final List<TextTab>? tabs;
  final double height;

  TextTabBar({this.tabs, this.height = 60});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TabBar(
              isScrollable: true,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 20.0),
              tabs: tabs!.map((tab) {
                return Container(
                  height: 20,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(tab.title),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class TextTab {
  final String title;
  final Widget child;

  TextTab(this.title, this.child);
}

class DashedUnderlineIndicator extends Decoration {
  final BorderSide borderSide;
  final double? width;
  final EdgeInsetsGeometry insets;
  final double dashWidth;
  final double dashSpace;

  const DashedUnderlineIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.width,
    this.insets = EdgeInsets.zero,
    this.dashWidth = 3,
    this.dashSpace = 7,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DashedUnderlinePainter(this, onChanged);
  }
}

class _DashedUnderlinePainter extends BoxPainter {
  _DashedUnderlinePainter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  final DashedUnderlineIndicator decoration;

  BorderSide get borderSide => decoration.borderSide;

  EdgeInsetsGeometry get insets => decoration.insets;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    return Rect.fromLTWH(
      indicator.left,
      indicator.bottom - borderSide.width,
      indicator.width,
      borderSide.width,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.0);
    final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.round;

    // bl.dx     (bl.dx + br.dx)/2        br.dx
    //         <----------w--------->
    // startX = (bl.dx + br.dx - w)/2
    // endX = (bl.dx + br.dx + w)/2

    double startX = decoration.width != null
        ? (indicator.bottomLeft.dx + indicator.bottomRight.dx - decoration.width!) / 2
        : indicator.bottomLeft.dx;
    double endX = decoration.width != null
        ? (indicator.bottomLeft.dx + indicator.bottomRight.dx + decoration.width!) / 2
        : indicator.bottomRight.dx;

    while (startX < endX) {
      canvas.drawLine(Offset(startX, indicator.bottomLeft.dy),
          Offset(startX + decoration.dashWidth, indicator.bottomRight.dy), paint);
      startX += decoration.dashWidth + decoration.dashSpace;
    }
  }
}
