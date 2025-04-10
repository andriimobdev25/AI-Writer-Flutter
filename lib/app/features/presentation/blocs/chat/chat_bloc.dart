import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin_writer/app/features/presentation/blocs/chat/chat_event.dart';
import 'package:linkedin_writer/app/features/presentation/blocs/chat/chat_state.dart';
import 'package:linkedin_writer/app/features/chat/domain/entities/message.dart';
import 'package:linkedin_writer/app/core/services/openai_service.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final OpenAIService _openAIService;

  ChatBloc({required OpenAIService openAIService})
    : _openAIService = openAIService,
      super(const ChatState()) {
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    // Add user message
    final userMessage = ChatMessage.user(event.message);
    emit(state.copyWith(messages: [...state.messages, userMessage], status: ChatStatus.loading));

    try {
      // Generate AI response
      final response = await _openAIService.generateLinkedInPost(event.message);

      // Add AI message
      final aiMessage = ChatMessage.ai(response);
      emit(state.copyWith(messages: [...state.messages, aiMessage], status: ChatStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: e.toString()));
    }
  }
}
