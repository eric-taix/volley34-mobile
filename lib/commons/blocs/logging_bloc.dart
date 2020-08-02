import 'package:flutter_bloc/flutter_bloc.dart';

class LoggingBlocDelegate extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('$error, $stackTrace');
  }
}
