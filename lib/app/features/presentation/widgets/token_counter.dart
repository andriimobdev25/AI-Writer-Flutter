import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/chat/chat_bloc.dart';
import '../blocs/chat/chat_state.dart';

class TokenCounter extends StatelessWidget {
  const TokenCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return Text(
                '${(state.remainingTokens ?? 0).toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')} tokens remained',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),
        // const SizedBox(width: 4),
        // SizedBox(
        //   width: 24,
        //   height: 24,
        //   child: IconButton(
        //     padding: EdgeInsets.zero,
        //     icon: const Icon(Icons.restart_alt, size: 18, color: Colors.white),
        //     tooltip: 'Reset Tokens (Dev Only)',
        //     onPressed: () => context.read<ChatBloc>().add(const ResetTokens()),
        //   ),
        // ),
      ],
    );
  }
}
