import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin_writer/blocs/chat/chat_bloc.dart';
import 'package:linkedin_writer/config/theme.dart';
import 'package:linkedin_writer/screens/chat_screen.dart';
import 'package:linkedin_writer/services/openai_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkedIn Post Writer',
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (context) => ChatBloc(
          openAIService: OpenAIService(),
        ),
        child: const ChatScreen(),
      ),
    );
  }
}
