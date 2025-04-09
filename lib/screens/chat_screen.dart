import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide ChatState;
import 'package:linkedin_writer/blocs/chat/chat_bloc.dart';
import 'package:linkedin_writer/blocs/chat/chat_event.dart';
import 'package:linkedin_writer/blocs/chat/chat_state.dart';
import 'package:linkedin_writer/config/constants.dart';
import 'package:linkedin_writer/config/theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        centerTitle: true,
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
          final messages = state.messages
              .map((msg) => msg.toChatUiMessage())
              .toList()
              .reversed
              .toList();

          return Column(
            children: [
              if (state.status == ChatStatus.loading)
                const LinearProgressIndicator(),
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
                    sentMessageBodyTextStyle:
                        const TextStyle(color: Colors.white),
                    receivedMessageBodyTextStyle:
                        const TextStyle(color: Colors.black87),
                    inputTextStyle: const TextStyle(color: Colors.black87),
                  ),
                  customBottomWidget: _buildInputField(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) {
                if (event is KeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.enter ||
                      event.logicalKey == LogicalKeyboardKey.numpadEnter) {
                    if (HardwareKeyboard.instance.isShiftPressed) {
                      // Allow new line with Shift+Enter
                      return;
                    } else {
                      // Send message with Enter
                      final text = _textController.text;
                      if (text.trim().isNotEmpty) {
                        context.read<ChatBloc>().add(SendMessage(text));
                        _textController.clear();
                      }
                    }
                  }
                }
              },
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              onSubmitted: (text) {
                if (text.trim().isNotEmpty) {
                  context.read<ChatBloc>().add(SendMessage(text));
                  _textController.clear();
                }
              },
              onEditingComplete: () {
                final text = _textController.text;
                if (text.trim().isNotEmpty) {
                  context.read<ChatBloc>().add(SendMessage(text));
                  _textController.clear();
                }
              },
            ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            color: AppTheme.linkedinBlue,
            onPressed: () {
              final text = _textController.text;
              if (text.trim().isNotEmpty) {
                context.read<ChatBloc>().add(SendMessage(text));
                _textController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
