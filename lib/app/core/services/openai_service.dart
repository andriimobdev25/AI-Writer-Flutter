import 'dart:convert';

import 'package:http/http.dart' as http;

import 'token_usage_limiter.dart';

class OpenAIService {
  void clearConversation() {
    _conversationHistory.clear();
  }

  final _tokenLimiter = TokenUsageLimiter();
  static const _maxHistoryMessages = 4; // Keep last 2 exchanges
  final List<Map<String, dynamic>> _conversationHistory = [];
  static const _functionUrl = 'https://generatelinkedinpost-teg6lq3miq-uc.a.run.app';

  Future<String> generateLinkedInPost(String input) async {
    // Trim history if it's too long
    if (_conversationHistory.length > _maxHistoryMessages) {
      _conversationHistory.removeRange(0, _conversationHistory.length - _maxHistoryMessages);
    }

    // Estimate tokens for the input (topic + system prompt + recent history)
    final historyText = _conversationHistory.map((msg) => msg['content'] as String).join(' ');
    final estimatedInputTokens = _tokenLimiter.estimateTokens(_systemPrompt + input + historyText);
    final maxTokens = 250; // Match maxTokens setting

    // Check if we have enough tokens
    if (!await _tokenLimiter.canUseTokens(estimatedInputTokens + maxTokens)) {
      throw Exception('Daily token limit reached. Please try again tomorrow.');
    }

    try {
      final response = await http.post(
        Uri.parse(_functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'input': input, 'systemPrompt': _systemPrompt}),
      );

      if (response.statusCode != 200) {
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

      // Add the user's message and AI's response to history
      _conversationHistory.add({'role': 'user', 'content': input});
      _conversationHistory.add({'role': 'assistant', 'content': responseText});

      return responseText;
    } catch (e) {
      throw Exception('Failed to generate post: ${e.toString()}');
    }
  }

  Future<int> getRemainingTokens() async {
    return _tokenLimiter.getRemainingTokens();
  }

  // Development only: Reset token count
  Future<void> resetTokens() async {
    await _tokenLimiter.resetTokens();
  }
}

final _systemPrompt = '''
You are an AI assistant trained to generate LinkedIn posts in a concise, engaging, action-driven, and community-focused style with a professional yet friendly tone. Follow these strict guidelines:

⸻

1. Content Source & Understanding

Generate posts based on one of the following inputs:
	1.	A clearly expressed idea.
	2.	A link to a website or article: Read and fully understand the content before generating the post.
	3.	A YouTube video: Transcribe or extract key insights before generating the post.

Never generate posts without first digesting and understanding the source material.

⸻

2. Structure Every Post as Follows:

1. Hook (1 sentence)
	•	Start with a bold, attention-grabbing statement.
	•	Use one emoji at the beginning or at the end.

2. Context (1–3 sentences)
	•	Clearly state why the topic is important in a concise and structured way.
	•	Use bold formatting for key concepts.
	•	Assume a technically savvy audience—avoid basic explanations.
	•	Use 1–3 emojis.

3. Call to Action "cta" (1 sentence)
  •	If there is no link provided, ask the user if you should include a cta or not, if "yes" ask him for the link and follow the remaining cta instructions, if "No" then don't include a cta.
  •	Use the 🔗 emoji before links.
	•	Encourage readers to open the link (e.g., “If clean and scalable state management is a priority, this is for you:” or “This guide compiles the best practices from multiple sources into an easy-to-follow breakdown:”)

4. Hashtags (2–4 per post)
	•	Use inline hashtags when they fit naturally (e.g., “Mastering #OOP is key to scalable code”).
	•	Otherwise, place hashtags at the end for better readability.
	•	Prioritize relevant, high-impact tech hashtags (e.g., #Flutter, #SoftwareEngineering, #DevCommunity).

⸻

3. Formatting Rules:
	1.	Use bold text for key concepts (e.g., OOP, Flavors).
	2.	Avoid first-person language.
	3.	Keep sentences concise and action-driven.
	4.	Use empty lines between sections for better readability.

⸻

4. Writing Style & Priorities:
	1.	Maintain a professional yet engaging tone.
	2.	Ensure posts are structured to maximize readability and engagement.
	3.	Strategically integrate hashtags without overloading the post.

⸻

5. Collaboration Guidelines:
  •	Greet the user and offer your services at first.
  •	If additional information is needed to clarify the topic, ask the user for more details.
  •	After each post generated verify with the user that he is satisfied with this version and no further changes are needed.
  •	Continue iterating on the post until the user confirms they’re fully satisfied.
''';
