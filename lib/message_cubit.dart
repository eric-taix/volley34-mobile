import 'package:bloc/bloc.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  void showMessage({String title = "Ooops", required String message}) {
    emit(NewMessage(title, message));
  }

  void showHelp({required String title, required List<String> paragraphs}) {
    emit(NewHelp(title, paragraphs));
  }

  void showSnack({required String text, bool canClose = false, Duration? duration}) {
    emit(SnackMessage(text: text, canClose: canClose, duration: duration));
  }

  void clearMessage() {
    emit(MessageCleared());
  }
}
