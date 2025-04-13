import 'package:equatable/equatable.dart';
import 'package:linkedin_writer/app/features/chat/domain/entities/message.dart';

enum ChatStatus { initial, loading, success, error }

class ChatState extends Equatable {
  final List<ChatMessage> messages;
  final ChatStatus status;
  final String? errorMessage;
  final int? remainingTokens;

  const ChatState({
    this.messages = const [],
    this.status = ChatStatus.initial,
    this.errorMessage,
    this.remainingTokens,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    ChatStatus? status,
    String? errorMessage,
    int? remainingTokens,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      remainingTokens: remainingTokens ?? this.remainingTokens,
    );
  }

  @override
  List<Object?> get props => [messages, status, errorMessage, remainingTokens];
}
