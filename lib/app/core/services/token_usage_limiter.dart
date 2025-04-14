import 'package:flutter/foundation.dart';
import 'storage/storage_provider.dart';

class TokenUsageLimiter {
  static const int _maxTokensPerDay = 20000; // Daily token limit
  static const String _keyDailyTokens = 'daily_token_usage';
  static const String _keyLastReset = 'last_token_reset';

  final _storage = StorageProvider.instance;

  Future<bool> canUseTokens(int estimatedTokens) async {
    await _initializeIfNeeded();
    final now = DateTime.now();
    
    // Get last reset time
    final lastResetStr = await _storage.getValue(_keyLastReset) ?? '0';
    final lastResetTime = DateTime.fromMillisecondsSinceEpoch(int.parse(lastResetStr));
    
    // If it's a new day, reset the counter
    if (now.difference(lastResetTime).inDays > 0) {
      await _resetCounter(now);
      return true;
    }
    
    // Check if under limit
    final usedTokensStr = await _storage.getValue(_keyDailyTokens) ?? '0';
    final usedTokens = int.parse(usedTokensStr);
    return (usedTokens + estimatedTokens) <= _maxTokensPerDay;
  }

  Future<void> recordTokenUsage(int inputTokens, int outputTokens) async {
    final currentUsageStr = await _storage.getValue(_keyDailyTokens) ?? '0';
    final currentUsage = int.parse(currentUsageStr);
    final totalTokens = inputTokens + outputTokens;
    await _storage.setValue(_keyDailyTokens, (currentUsage + totalTokens).toString());
  }

  // Development only: Reset tokens manually
  Future<void> resetTokens() async {
    await _resetCounter(DateTime.now());
  }

  Future<void> _resetCounter(DateTime now) async {
    debugPrint('Resetting token counter');
    await _storage.setValue(_keyDailyTokens, '0');
    await _storage.setValue(_keyLastReset, now.millisecondsSinceEpoch.toString());
    debugPrint('Token counter reset');
  }

  // Initialize the counter if it hasn't been set yet
  Future<void> _initializeIfNeeded() async {
    final lastReset = await _storage.getValue(_keyLastReset);
    if (lastReset == null) {
      debugPrint('Initializing token counter for the first time');
      await _resetCounter(DateTime.now());
    }
    // Debug: Print current values
    final usedTokens = await _storage.getValue(_keyDailyTokens) ?? '0';
    final lastResetTime = await _storage.getValue(_keyLastReset) ?? '0';
    debugPrint('Current token state - Used: $usedTokens, Last Reset: ${DateTime.fromMillisecondsSinceEpoch(int.parse(lastResetTime))}');
  }

  Future<int> getRemainingTokens() async {
    await _initializeIfNeeded();
    final usedTokensStr = await _storage.getValue(_keyDailyTokens) ?? '0';
    final usedTokens = int.parse(usedTokensStr);
    final remaining = _maxTokensPerDay - usedTokens;
    debugPrint('Getting remaining tokens: used=$usedTokens, remaining=$remaining');
    return remaining;
  }

  // Helper method to estimate tokens in a text
  int estimateTokens(String text) {
    // Rough estimation: 1 token ≈ 4 characters for English text
    return (text.length / 4).ceil();
  }
}
