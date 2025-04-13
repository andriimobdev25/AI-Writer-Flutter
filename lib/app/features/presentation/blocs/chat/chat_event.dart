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

class UpdateTokenCount extends ChatEvent {
  final int remainingTokens;

  const UpdateTokenCount(this.remainingTokens);

  @override
  List<Object?> get props => [remainingTokens];
}

// Development only: Reset tokens event
class ResetTokens extends ChatEvent {
  const ResetTokens();

  @override
  List<Object?> get props => [];
}

// Reset chat and start new conversation
class ResetChat extends ChatEvent {
  const ResetChat();

  @override
  List<Object?> get props => [];
}
