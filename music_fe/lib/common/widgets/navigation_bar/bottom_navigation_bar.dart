import 'package:flutter/material.dart';
import 'package:music_app/common/widgets/navigation_bar/tab_item.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../presentation/screens/add/widgets/add_bottom_sheet.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int activeTab;
  final Function(int) onTabSelected;

  CustomBottomNavigationBar(
      {required this.activeTab, required this.onTabSelected, super.key});

  final List<TabItem> items = [
    TabItem(icon: Icons.home_filled, title: "Trang chủ"),
    TabItem(icon: Icons.search_rounded, title: "Tìm kiếm"),
    TabItem(icon: Icons.library_music_outlined, title: "Thư viện"),
    TabItem(icon: Icons.sports_baseball_outlined, title: "Premium"),
    TabItem(icon: Icons.add, title: "Tạo"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.black,
      ),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(items.length, (index) {
            return IconButton(
              onPressed: () {
                if (index == 4) {
                  // Nếu là nút "Tạo" (Add)
                  showAddBottomSheet(context);
                } else {
                  onTabSelected(index);
                }
              },
              icon: SizedBox(
                height: 60,
                width: 60,
                child: Column(
                  children: [
                    Icon(
                      items[index].icon,
                      size: 30,
                      color: activeTab == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                    ),
                    Text(
                      items[index].title,
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }
}
