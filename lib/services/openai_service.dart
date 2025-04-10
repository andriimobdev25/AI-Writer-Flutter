import 'package:dart_openai/dart_openai.dart';
import 'package:linkedin_writer/config/api_key.dart';

class OpenAIService {
  late final OpenAI _openAI;

  OpenAIService() {
    OpenAI.apiKey = ApiKey.openAiKey;
    _openAI = OpenAI.instance;
  }

  Future<String> generateLinkedInPost(String topic) async {
    try {
      final chatCompletion = await _openAI.chat.create(
        model: 'gpt-4',
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text('''
You are a professional LinkedIn post writer. Your goal is to help users create engaging, professional, and effective LinkedIn posts.
When a user provides a topic or idea, craft a post that:
1. Is clear and concise
2. Uses professional language
3. Engages the target audience
4. Follows LinkedIn best practices
5. Maintains authenticity
'''),
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(topic)],
          ),
        ],
        temperature: 1.1,
      );

      if (chatCompletion.choices.isEmpty) {
        throw Exception('No response from OpenAI');
      }

      final content = chatCompletion.choices.first.message.content;
      if (content == null || content.isEmpty) {
        throw Exception('Empty response from OpenAI');
      }

      return content.first.text ?? '';
    } catch (e) {
      throw Exception('Failed to generate post: ${e.toString()}');
    }
  }
}
