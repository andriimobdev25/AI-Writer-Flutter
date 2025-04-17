import 'package:ai_linkedin_writer/app/core/config/sentry_config.dart';
import 'package:ai_linkedin_writer/app/core/config/theme.dart';
import 'package:ai_linkedin_writer/app/core/services/openai_service.dart';
import 'package:ai_linkedin_writer/app/features/presentation/blocs/chat/chat_bloc.dart';
import 'package:ai_linkedin_writer/app/features/presentation/screens/chat_screen.dart';
import 'package:ai_linkedin_writer/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kReleaseMode) {
    await SentryFlutter.init((options) {
      options.dsn = sentryDsn;
      options.sendDefaultPii = true;
    }, appRunner: () => runApp(const MyApp()));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Linkedin Writer',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => ChatBloc(openAIService: OpenAIService()),
        child: const ChatScreen(),
      ),
    );
  }
}
