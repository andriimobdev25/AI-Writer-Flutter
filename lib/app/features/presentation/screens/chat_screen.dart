import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide ChatState;
import 'package:linkedin_writer/app/core/config/theme.dart';
import 'package:linkedin_writer/app/features/presentation/blocs/chat/chat_bloc.dart';
import 'package:linkedin_writer/app/features/presentation/blocs/chat/chat_event.dart';
import 'package:linkedin_writer/app/features/presentation/blocs/chat/chat_state.dart';

import '../widgets/token_counter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Padding(padding: const EdgeInsets.only(left: 10), child: TokenCounter()),
        title: const Text('LinkedIn Post Writer'),
        leadingWidth: 200,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextButton(
                child: Text('New post', style: TextStyle(color: Colors.white)),
                onPressed: () => context.read<ChatBloc>().add(const ResetChat()),
              ),
            ),
          ),
        ],
      ),
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
              state.messages.map((msg) => msg.toChatUiMessage()).toList().reversed.toList();

          return Column(
            children: [
              if (state.status == ChatStatus.loading) const LinearProgressIndicator(),
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
                  customBottomWidget: const ChatInputField(),
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
  const ChatInputField({super.key});

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
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'What would you like to post about?',
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
              onSubmitted: (_) {},
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
