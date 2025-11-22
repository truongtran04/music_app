import 'package:flutter/material.dart';
import 'package:music_app/presentation/screens/add/pages/body_add.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BodyAddPage()
    );
  }
}
