part of 'message_cubit.dart';

abstract class MessageState extends Equatable {
  const MessageState();
}

class MessageInitial extends MessageState {
  @override
  List<Object> get props => [];
}

class NewMessage extends MessageState {
  final String title;
  final String message;

  NewMessage(this.title, this.message);

  @override
  List<Object?> get props => [];
}

class NewHelp extends MessageState {
  final String title;
  final List<String> paragraphs;

  NewHelp(this.title, this.paragraphs);

  @override
  List<Object?> get props => [];
}

class MessageCleared extends MessageState {
  @override
  List<Object?> get props => [];
}
