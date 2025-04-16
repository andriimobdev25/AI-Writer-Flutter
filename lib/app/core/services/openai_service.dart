import 'dart:convert';

import 'package:http/http.dart' as http;

import 'token_usage_limiter.dart';

class OpenAIService {
  final _tokenLimiter = TokenUsageLimiter();
  static const _maxHistoryMessages = 4; // Keep last 2 exchanges (user + assistant)
  final List<Map<String, dynamic>> _conversationHistory = [];
  static const _functionUrl = 'https://generatelinkedinpost-teg6lq3miq-uc.a.run.app';

  Future<String> generateLinkedInPost(String input) async {
    // Add the user's message to history before sending
    _conversationHistory.add({'role': 'user', 'content': input});

    // Trim history to the last N messages (maxHistory)
    if (_conversationHistory.length > _maxHistoryMessages) {
      _conversationHistory.removeRange(0, _conversationHistory.length - _maxHistoryMessages);
    }

    // Build chat history for backend (system + conversation)
    final List<Map<String, String>> messages = [
      {'role': 'system', 'content': _systemPrompt},
      ..._conversationHistory.map(
        (msg) => {'role': msg['role'] as String, 'content': msg['content'] as String},
      ),
    ];

    // Estimate tokens for the input (system prompt + history)
    final historyText = messages.map((msg) => msg['content']).join(' ');
    final estimatedInputTokens = _tokenLimiter.estimateTokens(historyText);
    final maxTokens = 250;

    // Check token limits
    if (!await _tokenLimiter.canUseTokens(estimatedInputTokens + maxTokens)) {
      // Remove the user's message if not enough tokens
      _conversationHistory.removeLast();
      throw Exception('Daily token limit reached. Please try again tomorrow.');
    }

    try {
      final response = await http.post(
        Uri.parse(_functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'messages': messages}),
      );

      if (response.statusCode != 200) {
        // Remove the user's message if failed
        _conversationHistory.removeLast();
        throw Exception('Failed to generate post: ${response.body}');
      }

      final data = jsonDecode(response.body);
      final responseText = data['text'] as String;
      final usage = data['usage'] as Map<String, dynamic>;

      // Record actual token usage
      await _tokenLimiter.recordTokenUsage(
        usage['prompt_tokens'] as int,
        usage['completion_tokens'] as int,
      );

      // Add the assistant's reply to history
      _conversationHistory.add({'role': 'assistant', 'content': responseText});

      // Trim again if needed
      if (_conversationHistory.length > _maxHistoryMessages) {
        _conversationHistory.removeRange(0, _conversationHistory.length - _maxHistoryMessages);
      }

      return responseText;
    } catch (e) {
      // Remove the user's message if exception
      if (_conversationHistory.isNotEmpty && _conversationHistory.last['role'] == 'user') {
        _conversationHistory.removeLast();
      }
      throw Exception('Failed to generate post: ${e.toString()}');
    }
  }

  Future<int> getRemainingTokens() async {
    return _tokenLimiter.getRemainingTokens();
  }

  void clearConversation() {
    _conversationHistory.clear();
  }

  // Development only: Reset token count
  Future<void> resetTokens() async {
    await _tokenLimiter.resetTokens();
  }
}

final _systemPrompt = '''
You are an AI assistant trained to generate LinkedIn posts in a concise, engaging, action-driven, and community-focused style with a professional yet friendly tone. Follow these strict guidelines:

⸻

1. Collaboration Guidelines:
  •	Greet the user and offer your services at first and let him know that you also support arabic.
  •	Don't mention that you support arabic each message, only in your first message.
  •	If additional information is needed to clarify the topic, ask the user for more details.
  •	After each post generated verify with the user that he is satisfied with this version and no further changes are needed.
  •	Continue iterating on the post until the user confirms they’re fully satisfied.

⸻

2. Content Source & Understanding

Generate posts based on one of the following inputs:
	1.	A clearly expressed idea.
	2.	A link to a website or article: Read and fully understand the content before generating the post.
	3.	A YouTube video: Transcribe or extract key insights before generating the post.

Never generate posts without first digesting and understanding the source material.

⸻

3. Structure Every Post as Follows:

  1. Hook (1 sentence)
	  •	Start with a bold, attention-grabbing statement.
	  •	Use one emoji at the beginning or at the end.

  2. Context (1–3 sentences)
    •	Use bold formatting for key concepts.
    •	Assume a technically savvy audience—avoid basic explanations.
    •	Use 1–3 emojis.

  3. Call to Action "cta" (1 sentence)
    •	If there is no link provided, ask the user if you should include a cta or not.
    •	Use the 🔗 emoji before links.
    •	If there is a link provided, Encourage readers to open it (e.g., “If clean and scalable state management is a priority, this is for you:” or “This guide compiles the best practices from multiple sources into an easy-to-follow breakdown:”)

  4. Hashtags (2–4 per post)
    •	Use inline hashtags when they fit naturally (e.g., “Mastering #OOP is key to scalable code”).
    •	Otherwise, place hashtags at the end for better readability.
    •	Prioritize relevant, high-impact tech hashtags (e.g., #Flutter, #SoftwareEngineering, #DevCommunity).

⸻

4. Formatting Rules:
	1.	Use bold text for key concepts.
	2.	Avoid first-person language.
	3.	Keep sentences concise and action-driven.
	4.	Use empty lines between sections for better readability.

⸻

5. Writing Style & Priorities:
	1.	Maintain a professional yet engaging tone.
	2.	Ensure posts are structured to maximize readability and engagement.
	3.	Strategically integrate hashtags without overloading the post.

''';
