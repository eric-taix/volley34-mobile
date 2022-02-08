part of 'message_cubit.dart';

abstract class MessageState {
  const MessageState();
}

class MessageInitial extends MessageState {}

class SnackMessage extends MessageState {
  final bool canClose;
  final String text;
  final Duration? duration;

  SnackMessage({required this.text, this.canClose = false, this.duration});
}

class NewMessage extends MessageState {
  final String title;
  final String message;

  NewMessage(this.title, this.message);
}

class NewHelp extends MessageState {
  final String title;
  final List<String> paragraphs;

  NewHelp(this.title, this.paragraphs);
}

class MessageCleared extends MessageState {}
