import 'package:flutter/material.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';

import 'search_focus.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SearchFocusPage()),
          );
        },
        child: AbsorbPointer( // Để không focus vào TextField ở trang này
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: context.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Bạn muốn nghe gì?',
                hintMaxLines: 1,
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                prefixIcon: const Icon(Icons.search, size: 30, color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}