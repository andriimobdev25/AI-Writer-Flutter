import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/chat/chat_bloc.dart';
import '../blocs/chat/chat_event.dart';
import '../widgets/token_counter.dart';

const String kGithubRepoUrl = 'https://github.com/ISL270/ai-linkedin-writer';
const String kLinkedinProfileUrl = 'https://www.linkedin.com/in/eslam-se';

class AiLinkedinAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AiLinkedinAppBar({super.key});

  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'AI Linkedin Writer ✏️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 0.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.github, color: Colors.white),
                      tooltip: 'View on GitHub',
                      onPressed: () => _launchExternalUrl(kGithubRepoUrl),
                    ),
                    const SizedBox(width: 2),

                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.linkedin, color: Colors.white),
                      tooltip: 'View LinkedIn Profile',
                      onPressed: () => _launchExternalUrl(kLinkedinProfileUrl),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 15, top: 4) + EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TokenCounter(),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('New Post', style: TextStyle(color: Colors.white)),
                  onPressed: () => context.read<ChatBloc>().add(const ResetChat()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(92);
}
