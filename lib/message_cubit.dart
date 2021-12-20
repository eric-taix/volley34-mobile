import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  void showMessage({String title = "Ooops", required String message}) {
    emit(NewMessage(title, message));
  }

  void showHelp({required String title, required List<String> paragraphs}) {
    emit(NewHelp(title, paragraphs));
  }

  void clearMessage() {
    emit(MessageCleared());
  }
}
