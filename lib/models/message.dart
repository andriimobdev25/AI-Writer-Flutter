import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime createdAt;

  ChatMessage({
    required this.text,
    required this.isUser,
    String? id,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = DateTime.now();

  // Convert to flutter_chat_types Message
  types.TextMessage toChatUiMessage() {
    return types.TextMessage(
      author: types.User(
        id: isUser ? 'user' : 'ai',
        firstName: isUser ? 'You' : 'AI Assistant',
      ),
      id: id,
      text: text,
      createdAt: createdAt.millisecondsSinceEpoch,
    );
  }

  // Create a user message
  static ChatMessage user(String text) {
    return ChatMessage(
      text: text,
      isUser: true,
    );
  }

  // Create an AI message
  static ChatMessage ai(String text) {
    return ChatMessage(
      text: text,
      isUser: false,
    );
  }
}
