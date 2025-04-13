import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin_writer/app/core/config/theme.dart';
import 'package:linkedin_writer/app/core/services/openai_service.dart';
import 'package:linkedin_writer/app/features/presentation/blocs/chat/chat_bloc.dart';
import 'package:linkedin_writer/app/features/presentation/screens/chat_screen.dart';

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
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => ChatBloc(openAIService: OpenAIService()),
        child: const ChatScreen(),
      ),
    );
  }
}
