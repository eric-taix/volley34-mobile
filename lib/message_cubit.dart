import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  void showMessage({String title = "Ooops", required String message}) {
    emit(NewMessage(title, message));
  }

  void clearMessage() {
    emit(MessageCleared());
  }
}
