import 'package:dart_openai/dart_openai.dart';
import 'package:linkedin_writer/config/api_key.dart';
import 'package:linkedin_writer/config/constants.dart';

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
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(
              AppConstants.initialSystemMessage,
            )],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(
              topic,
            )],
          ),
        ],
        temperature: 0.7,
        maxTokens: 500,
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
