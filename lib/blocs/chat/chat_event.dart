import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;

  const SendMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class CopyToClipboard extends ChatEvent {
  final String text;

  const CopyToClipboard(this.text);

  @override
  List<Object?> get props => [text];
}
