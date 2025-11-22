import 'package:flutter/material.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';
import 'package:music_app/core/configs/theme/app_colors.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final List<Widget>? actions;

  const AppBarHome({
    required this.scaffoldKey,
    required this.title,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: context.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
          icon: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Center( // Căn giữa nội dung bên trong
              child: Text(
                "T",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
