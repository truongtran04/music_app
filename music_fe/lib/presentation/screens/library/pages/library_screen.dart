import 'package:flutter/material.dart';
import 'package:music_app/presentation/screens/library/pages/body_library.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BodyLibraryPage()
    );
  }
}
