import 'package:flutter/material.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';

import '../../../core/navigations/app_router.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget ? title;
  final bool hideBack;
  final VoidCallback ? onPressed;
  final IconData ? iconData;
  final List<Widget> ? actions;
  const BasicAppbar({
    this.title,
    this.hideBack = false,
    this.onPressed,
    this.iconData,
    this.actions,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title ?? const Text(''),
      leading: hideBack ? null : IconButton(
        onPressed: onPressed ?? () {
          AppRouter.router.navigateTo(context, '/signInOrSignUp');
        },
        icon: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
              color: context.isDarkMode ? Colors.black.withOpacity(0.04) : Colors.white.withOpacity(0.03),
              shape: BoxShape.circle
          ),
          child: Icon(
            iconData ?? Icons.arrow_back_outlined,
            size: 30,
            color: context.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}