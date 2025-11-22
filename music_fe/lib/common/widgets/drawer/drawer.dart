import 'package:flutter/material.dart';
import 'package:music_app/common/helpers/is_dark_mode.dart';

import '../../../core/configs/theme/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: kToolbarHeight,
                left: 16,
                right: 16,
                bottom: 10
              ),
              child: Row(
                children: [
                  Container(
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
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Truong",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Xem hồ sơ",
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10,
                  left: 16,
                  right: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Trùng với background
                      shadowColor: Colors.transparent, // Xóa bóng
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Bo góc
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa icon & text
                        children: [
                          Icon(
                            Icons.settings,
                            size: 35,
                            color: context.isDarkMode ? Colors.white : Colors.black,
                          ),
                          const SizedBox(width: 20), // Tạo khoảng cách giữa Icon và Text
                          Expanded(
                            child: Text(
                              "Cài đặt",
                              textAlign: TextAlign.left, // Căn trái nội dung text
                              style: TextStyle(
                                color: AppColors.white.withOpacity(0.8),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
