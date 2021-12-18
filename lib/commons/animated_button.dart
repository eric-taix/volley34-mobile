import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final bool elevated;
  final Future<dynamic>? Function()? onPressed;
  final double width;
  const AnimatedButton({Key? key, required this.text, this.elevated = true, this.onPressed, this.width = 180})
      : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  Future<dynamic>? _computation;
  late double? _buttonWidth;

  static const double PROGRESS_SIZE = 20;

  @override
  void initState() {
    super.initState();
    _buttonWidth = widget.width;
  }

  @override
  Widget build(BuildContext context) {
    return widget.elevated
        ? ElevatedButton(
            onPressed: widget.onPressed != null && _computation == null ? _onPressed : null,
            child: AnimatedContainer(
              width: _buttonWidth,
              duration: Duration(milliseconds: 250),
              child: _computation == null
                  ? Center(
                      child: Text(
                        widget.text,
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        width: PROGRESS_SIZE,
                        height: PROGRESS_SIZE,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                        ),
                      ),
                    ),
            ),
          )
        : TextButton(
            onPressed: widget.onPressed != null ? _onPressed : null,
            child: _computation == null
                ? Text(widget.text)
                : SizedBox(
                    width: PROGRESS_SIZE,
                    height: PROGRESS_SIZE,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                  ),
          );
  }

  _onPressed() {
    if (widget.onPressed != null) {
      setState(
        () {
          _buttonWidth = PROGRESS_SIZE;
          _computation = widget.onPressed!();
          _computation?.then(
            (_) {
              if (mounted)
                setState(
                  () {
                    _buttonWidth = widget.width;
                    Future.delayed(Duration(milliseconds: 280), () => setState(() => _computation = null));
                  },
                );
            },
          );
        },
      );
    }
  }
}
