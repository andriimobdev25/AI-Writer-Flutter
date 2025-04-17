import 'package:ai_linkedin_writer/app/core/config/theme.dart';
import 'package:ai_linkedin_writer/app/features/presentation/blocs/chat/chat_bloc.dart';
import 'package:ai_linkedin_writer/app/features/presentation/blocs/chat/chat_event.dart';
import 'package:ai_linkedin_writer/app/features/presentation/blocs/chat/chat_state.dart';
import 'package:ai_linkedin_writer/app/widgets/typing_indicator.dart' as app_widgets;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide ChatState;

import '../widgets/ai_linkedin_app_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Focus on the text field when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AiLinkedinAppBar(onNewPost: _focusNode.requestFocus),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state.status == ChatStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final messages =
              state.messages.map((msg) => (msg).toChatUiMessage()).toList().reversed.toList();

          return Column(
            children: [
              Expanded(
                child: Chat(
                  messages: messages,
                  onSendPressed: (text) {
                    context.read<ChatBloc>().add(SendMessage(text.text));
                  },
                  user: const types.User(id: 'user'),
                  theme: DefaultChatTheme(
                    backgroundColor: AppTheme.linkedinLightGray,
                    primaryColor: AppTheme.linkedinBlue,
                    secondaryColor: Colors.white,
                    inputBackgroundColor: Colors.white,
                    sentMessageBodyTextStyle: const TextStyle(color: Colors.white),
                    receivedMessageBodyTextStyle: const TextStyle(color: Colors.black87),
                    inputTextStyle: const TextStyle(color: Colors.black87),
                  ),
                  customBottomWidget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      app_widgets.TypingIndicator(
                        showIndicator: state.status == ChatStatus.loading,
                      ),
                      ChatInputField(
                        focusNode: _focusNode,
                        isChatEmpty: state.messages.isEmpty,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ChatInputField extends StatefulWidget {
  final FocusNode focusNode;
  final bool isChatEmpty;
  const ChatInputField({super.key, required this.focusNode, required this.isChatEmpty});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text;
    if (text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(SendMessage(text));
      _textController.clear();
      // Keep cursor at the start for next message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: widget.focusNode,
              controller: _textController,
              decoration: InputDecoration(
                hintText: widget.isChatEmpty ? 'What would you like to post about?' : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.linkedinLightGray,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.none,
              onEditingComplete: _sendMessage,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            color: AppTheme.linkedinBlue,
          ),
        ],
      ),
    );
  }
}
