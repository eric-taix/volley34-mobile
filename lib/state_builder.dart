import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef Builder<T> = Widget Function(BuildContext context, T state);

class StateConditionBuilder<T> extends StatelessWidget {
  final T state;
  final List<ConditionBuilder<T>> conditionalBuilders;
  final Widget Function(BuildContext, T) defaultBuilder;

  StateConditionBuilder({required this.state, required this.conditionalBuilders, required this.defaultBuilder});

  @override
  Widget build(BuildContext context) {
    ConditionBuilder<T>? mayBeConditionalBuilder =
        conditionalBuilders.firstWhereOrNull((conditionalBuilder) => conditionalBuilder.accept(state));
    return mayBeConditionalBuilder != null
        ? mayBeConditionalBuilder.build(context, state)
        : defaultBuilder(context, state);
  }
}

ConditionBuilder<T> when<T>(Condition condition, Widget Function(BuildContext context, T state) builder) =>
    ConditionBuilder<T>(condition: condition, builder: builder);

class ConditionBuilder<T> {
  final Condition condition;
  final Widget Function(BuildContext context, T state) builder;

  ConditionBuilder({required this.condition, required this.builder});

  bool accept(dynamic state) => condition.accept(state);

  Widget build(BuildContext context, dynamic state) {
    return builder(context, state as T);
  }
}

abstract class Condition {
  bool accept(dynamic state);
}

Condition stateIs<T>() => _StateIs<T>();

class _StateIs<T> extends Condition {
  _StateIs();

  @override
  bool accept(dynamic state) => state.runtimeType == T;
}

Condition or(List<Condition> conditions) => _Or(conditions: conditions);

class _Or extends Condition {
  final List<Condition> conditions;

  _Or({required this.conditions});

  @override
  bool accept(state) => conditions.firstWhereOrNull((condition) => condition.accept(state)) != null;
}
