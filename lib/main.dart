import 'package:flutter/material.dart';
import 'package:my_sivi_chat/app/app.dart';
import 'package:my_sivi_chat/src/services/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => AppState(), child: const MyApp()),
  );
}
