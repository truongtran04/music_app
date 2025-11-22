import 'package:flutter/material.dart';

void showAddBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _AddBox(),
  );
}

class _AddBox extends StatelessWidget {
  const _AddBox();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF232323),
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AddItem(
              icon: Icons.music_note,
              title: 'Danh sách phát',
              subtitle: 'Tạo danh sách phát gồm bài hát hoặc tập podcast',
              onTap: () {}, // Xử lý khi chọn
            ),
            const SizedBox(height: 18),
            _AddItem(
              icon: Icons.group,
              title: 'Danh sách phát cộng tác',
              subtitle: 'Mời bạn bè cùng sáng tạo',
              onTap: () {},
            ),
            const SizedBox(height: 18),
            _AddItem(
              icon: Icons.all_inclusive,
              title: 'Giai điệu chung',
              subtitle: 'Kết hợp các gu nghe nhạc trong một danh sách phát chia sẻ cùng bạn bè',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _AddItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AddItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white54, size: 32),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}