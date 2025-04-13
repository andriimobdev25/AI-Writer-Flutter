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
    on<UpdateTokenCount>(_onUpdateTokenCount);
    on<ResetTokens>(_onResetTokens);
    on<ResetChat>(_onResetChat);
    
    // Initialize token count
    _openAIService.getRemainingTokens().then((tokens) {
      add(UpdateTokenCount(tokens));
    }).catchError((error) {
    });

  }

  void _updateTokenCount() {
    _openAIService.getRemainingTokens().then((tokens) {
      add(UpdateTokenCount(tokens));
    });
  }

  void _onUpdateTokenCount(UpdateTokenCount event, Emitter<ChatState> emit) {
    emit(state.copyWith(remainingTokens: event.remainingTokens));
  }

  // Development only: Reset tokens
  Future<void> _onResetTokens(ResetTokens event, Emitter<ChatState> emit) async {
    await _openAIService.resetTokens();
    final tokens = await _openAIService.getRemainingTokens();
    add(UpdateTokenCount(tokens));
  }

  // Reset chat and start new conversation
  void _onResetChat(ResetChat event, Emitter<ChatState> emit) {
    // Clear conversation history in OpenAI service
    _openAIService.clearConversation();
    // Reset chat state but preserve token count
    emit(ChatState(remainingTokens: state.remainingTokens));
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
      emit(state.copyWith(
        messages: [...state.messages, aiMessage],
        status: ChatStatus.success
      ));
      // Update token count after successful message
      _updateTokenCount();
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: e.toString()));
    }
  }
}
