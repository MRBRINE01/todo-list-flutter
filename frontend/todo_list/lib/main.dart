import 'package:flutter/material.dart';
import 'package:todo_list/views/left_panel.dart';
import 'package:todo_list/views/main_layout.dart';
import 'package:todo_list/views/right_panel.dart';
import 'dart:js' as js;

void main() {
  // Disable browser's default context menu
  js.context.callMethod('eval', [
    '''
    document.addEventListener('contextmenu', function(e) {
      e.preventDefault();
      return false;
    });
  '''
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 31, 31, 31),
            surface: Color.fromARGB(255, 27, 27, 27),
            primary: const Color.fromARGB(255, 43, 43, 43)),
        useMaterial3: true,
      ),
      home: MainLayout(),
    );
  }
}
