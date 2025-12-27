import 'package:flutter/foundation.dart';
import 'package:my_sivi_chat/src/models/chat_session.dart';

class AppState extends ChangeNotifier {
  final List<String> _users = [];
  final List<ChatSession> _chatHistory = [];

  List<String> get users => List.unmodifiable(_users);
  List<ChatSession> get chatHistory => List.unmodifiable(_chatHistory);

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  ValueNotifier<bool> get isLoading => _isLoading;

  void addUser(String name) {
    if (!_users.contains(name)) {
      _users.add(name);
      notifyListeners();
    }
  }

  void addChatSession(ChatSession session) {
    _chatHistory.removeWhere((s) => s.userName == session.userName);
    _chatHistory.insert(0, session);
    notifyListeners();
  }

  Future<void> loadInitialData() async {
    _isLoading.value = true;
    try {
      // Add any initial data loading logic here
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate loading
    } finally {
      _isLoading.value = false;
    }
  }
}
