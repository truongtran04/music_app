import 'package:flutter/material.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SearchAppBar({
    this.controller, 
    this.focusNode, 
    this.onChanged,
    this.onClear,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return AppBar(
      backgroundColor: isDark ? Colors.black : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back, 
          color: isDark ? Colors.white : Colors.black, 
          size: 28
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(right: 16, bottom: 5),
        child: SizedBox(
          height: 40,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black, 
              fontSize: 16
            ),
            cursorColor: isDark ? Colors.white : Colors.black,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Bạn muốn nghe gì?',
              hintStyle: TextStyle(
                color: isDark 
                    ? Colors.white.withOpacity(0.7)
                    : Colors.black.withOpacity(0.7)
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              filled: false,
              suffixIcon: controller?.text.isNotEmpty == true
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: isDark ? Colors.white : Colors.black,
                        size: 20,
                      ),
                      onPressed: onClear,
                    )
                  : null,
            ),
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}