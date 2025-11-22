import 'package:flutter/material.dart';
import 'package:music_app/presentation/screens/search/pages/body_search.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const BodySearchPage()
    );
  }
}
