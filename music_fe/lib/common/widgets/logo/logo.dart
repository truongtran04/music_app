import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/configs/assets/app_vectors.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          AppVectors.whiteLogo,
          height: 120,
          width: 120,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
