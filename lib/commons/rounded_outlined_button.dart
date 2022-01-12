import 'package:flutter/material.dart';

class RoundedOutlinedButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const RoundedOutlinedButton({Key? key, required this.child, this.onPressed, this.leadingIcon, this.trailingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: _ForegroundColorStateProperty(Theme.of(context).textTheme.headline1!.color!),
        side: _BorderStateProperty(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: leadingIcon,
            ),
          child,
          if (trailingIcon != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: trailingIcon,
            ),
        ],
      ),
    );
  }
}

class _BorderStateProperty extends MaterialStateProperty<BorderSide> {
  _BorderStateProperty();

  @override
  BorderSide resolve(Set<MaterialState> states) => states.contains(MaterialState.disabled)
      ? BorderSide(color: Color(0xff3c403e), width: 2)
      : BorderSide(color: Color(0xFFC9334F), width: 2);
}

class _ForegroundColorStateProperty extends MaterialStateProperty<Color> {
  final Color color;
  _ForegroundColorStateProperty(this.color);

  @override
  Color resolve(Set<MaterialState> states) => states.contains(MaterialState.disabled) ? Color(0xFF686B75) : color;
}
