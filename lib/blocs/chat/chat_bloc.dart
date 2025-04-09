import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin_writer/blocs/chat/chat_event.dart';
import 'package:linkedin_writer/blocs/chat/chat_state.dart';
import 'package:linkedin_writer/models/message.dart';
import 'package:linkedin_writer/services/openai_service.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final OpenAIService _openAIService;

  ChatBloc({required OpenAIService openAIService})
      : _openAIService = openAIService,
        super(const ChatState()) {
    on<SendMessage>(_onSendMessage);
    on<CopyToClipboard>(_onCopyToClipboard);
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    // Add user message
    final userMessage = ChatMessage.user(event.message);
    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      status: ChatStatus.loading,
    ));

    try {
      // Generate AI response
      final response = await _openAIService.generateLinkedInPost(event.message);
      
      // Add AI message
      final aiMessage = ChatMessage.ai(response);
      emit(state.copyWith(
        messages: [...state.messages, aiMessage],
        status: ChatStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCopyToClipboard(
    CopyToClipboard event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await Clipboard.setData(ClipboardData(text: event.text));
    } catch (e) {
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: 'Failed to copy text: ${e.toString()}',
      ));
    }
  }
}
