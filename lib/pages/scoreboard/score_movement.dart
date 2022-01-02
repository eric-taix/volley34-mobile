enum FlingDirection { none, down, up }
enum FlingType { none, manual, auto }

class Fling {
  final FlingType type;
  final FlingDirection direction;
  late final double _initialDy;
  final double delta;

  static final Fling none = Fling(FlingType.none, FlingDirection.none);

  Fling(this.type, this.direction, {this.delta = 0, double initialDy = 0}) {
    this._initialDy = initialDy;
  }

  Fling start(FlingDirection direction, double initialDy) => Fling(FlingType.manual, direction, initialDy: initialDy);

  Fling update(double dy, double height) {
    if (dy < _initialDy && direction == FlingDirection.up) {
      return Fling(type, direction, delta: ((_initialDy - dy) / height) * 0.66, initialDy: _initialDy);
    } else if (dy > _initialDy && direction == FlingDirection.down) {
      return Fling(type, direction, delta: 1 - (((dy - _initialDy) / height)) * 0.66, initialDy: _initialDy);
    }
    return Fling(type, direction, delta: direction == FlingDirection.up ? 0 : 1, initialDy: _initialDy);
  }

  Fling auto({FlingDirection? direction}) =>
      Fling(FlingType.auto, direction ?? this.direction, delta: delta, initialDy: _initialDy);

  Fling end() => none;

  @override
  String toString() {
    return 'Fling{type: $type, dir: $direction, delta: $delta}';
  }
}
