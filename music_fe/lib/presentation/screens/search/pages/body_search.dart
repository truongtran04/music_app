import 'package:flutter/material.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';
import 'package:music_app/presentation/screens/search/widgets/search_box.dart';

import '../../../../common/widgets/text/text_title.dart';
import '../widgets/genres.dart';

class BodySearchPage extends StatelessWidget {
  const BodySearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBox(),
              TextTitle(title: "Thể loại", fontSize: 16),
              Genres()
            ],
          ),
        ),
      ),
    );
  }
}
