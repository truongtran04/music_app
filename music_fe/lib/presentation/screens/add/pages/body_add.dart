import 'package:flutter/material.dart';

class BodyAddPage extends StatelessWidget {
  const BodyAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Center(
                child: Text("Add Page"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
