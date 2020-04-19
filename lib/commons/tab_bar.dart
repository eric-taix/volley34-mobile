import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextTabBar extends StatelessWidget {
  final List<TextTab> tabs;

  TextTabBar({this.tabs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: new PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: new Container(
          color: Theme.of(context).primaryColor,
          child: new SafeArea(
            child: Column(children: <Widget>[
             // Expanded(child: new Container(color: Colors.redAccent,)),
              TabBar(
                isScrollable: true,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 30.0),
                tabs: tabs
                    .map((tab) => Container(
                  height: 70,
                          child: Align(alignment: Alignment.bottomCenter, child: Text(tab.title)),
                        ))
                    .toList(),
              ),
            ]),
          ),
        ),
      ),
      body: TabBarView(children: tabs.map((tab) => tab.child).toList()),
    );
  }
}

class TextTab {
  final String title;
  final Widget child;

  TextTab(this.title, this.child);
}

class DashedUnderlineIndicator extends Decoration {
  final BorderSide borderSide;
  final double width;
  final EdgeInsetsGeometry insets;
  final double dashWidth;
  final double dashSpace;

  const DashedUnderlineIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.width,
    this.insets = EdgeInsets.zero,
    this.dashWidth = 3,
    this.dashSpace = 7,
  })  : assert(borderSide != null),
        assert(insets != null);

  @override
  BoxPainter createBoxPainter([onChanged]) {
    return _DashedUnderlinePainter(this, onChanged);
    ;
  }
}

class _DashedUnderlinePainter extends BoxPainter {
  _DashedUnderlinePainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final DashedUnderlineIndicator decoration;

  BorderSide get borderSide => decoration.borderSide;

  EdgeInsetsGeometry get insets => decoration.insets;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
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
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;
    final Rect indicator = _indicatorRectFor(rect, textDirection).deflate(borderSide.width / 2.0);
    final Paint paint = borderSide.toPaint()..strokeCap = StrokeCap.round;

    // bl.dx     (bl.dx + br.dx)/2        br.dx
    //         <----------w--------->
    // startX = (bl.dx + br.dx - w)/2
    // endX = (bl.dx + br.dx + w)/2

    double startX = decoration.width != null ? (indicator.bottomLeft.dx + indicator.bottomRight.dx - decoration.width) / 2 : indicator.bottomLeft.dx;
    double endX = decoration.width != null ? (indicator.bottomLeft.dx + indicator.bottomRight.dx + decoration.width) / 2 : indicator.bottomRight.dx;
    while (startX < endX) {
      canvas.drawLine(Offset(startX, indicator.bottomLeft.dy), Offset(startX + decoration.dashWidth, indicator.bottomRight.dy), paint);
      startX += decoration.dashWidth + decoration.dashSpace;
    }
  }
}
