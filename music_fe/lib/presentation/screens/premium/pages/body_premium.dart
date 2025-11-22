import 'package:flutter/material.dart';

class BodyPremiumPage extends StatelessWidget {
  const BodyPremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner giới thiệu Premium
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://wwwmarketing.scdn.co/static/images/premium/desktop-album-evergreen-1x.png',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black54,
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Nghe không giới hạn. Dùng thử Premium Individual trong 2 tháng với giá 59.000 ₫ trên Spotify.',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 18),
                    Center(
                      child: PremiumButton(
                        text: 'Dùng thử 2 tháng với giá 59.000 ₫',
                        color: Color(0xFFFFE0EB),
                        textColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Lý do nên dùng Premium
              const Text(
                'Lý do nên dùng gói Premium',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              _ReasonList(),
              const SizedBox(height: 24),
              // Các gói Premium
              const Text(
                'Các gói có sẵn',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              _PremiumCard(
                label: '59.000 ₫ cho 2 tháng',
                title: 'Individual',
                price: '59.000 ₫ cho 2 tháng',
                after: 'Sau đó là 59.000 ₫/tháng.',
                features: const [
                  '1 tài khoản Premium',
                  'Hủy bất cứ lúc nào',
                  'Đăng ký hoặc thanh toán một lần',
                ],
                buttonText: 'Dùng thử 2 tháng với giá 59.000 ₫',
                buttonColor: Color(0xFFFFE0EB),
                borderColor: Color(0xFFFFE0EB),
                description:
                    '59.000 ₫ cho 2 tháng, sau đó là 59.000 ₫/tháng. Chỉ áp dụng ưu đãi nếu bạn đăng ký qua Spotify và chưa từng dùng gói Premium. Các ưu đãi qua Google Play có thể khác. Có áp dụng Điều khoản.',
              ),
              const SizedBox(height: 20),
              _PremiumCard(
                label: '29.500 ₫ cho 2 tháng',
                title: 'Student',
                price: '29.500 ₫ cho 2 tháng',
                after: 'Sau đó là 29.500 ₫/tháng.',
                features: const [
                  '1 tài khoản Premium đã xác minh',
                  'Giảm giá cho sinh viên đủ điều kiện',
                  'Hủy bất cứ lúc nào',
                  'Đăng ký hoặc thanh toán một lần',
                ],
                buttonText: 'Dùng thử 2 tháng với giá 29.500 ₫',
                buttonColor: Color(0xFFE5D6F7),
                borderColor: Color(0xFFE5D6F7),
                description:
                    '29.500 ₫ cho 2 tháng, sau đó là 29.500 ₫/tháng. Chỉ áp dụng ưu đãi nếu bạn đăng ký qua Spotify và chưa từng dùng gói Premium. Các ưu đãi qua Google Play có thể khác. Ưu đãi chỉ dành cho sinh viên tại các cơ sở giáo dục bậc cao được công nhận. Có áp dụng Điều khoản.',
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  const PremiumButton({
    required this.text,
    required this.color,
    required this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ReasonList extends StatelessWidget {
  const _ReasonList();

  @override
  Widget build(BuildContext context) {
    const reasons = [
      {'icon': Icons.volume_off, 'text': 'Nghe nhạc không quảng cáo'},
      {'icon': Icons.download, 'text': 'Tải xuống để nghe không cần mạng'},
      {'icon': Icons.shuffle, 'text': 'Phát nhạc theo thứ tự bất kỳ'},
      {'icon': Icons.headphones, 'text': 'Chất lượng âm thanh cao'},
      {'icon': Icons.people, 'text': 'Nghe cùng bạn bè theo thời gian thực'},
      {'icon': Icons.format_list_bulleted, 'text': 'Sắp xếp danh sách chờ nghe'},
    ];
    return Column(
      children: reasons
          .map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(item['icon'] as IconData, color: Colors.white, size: 26),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item['text'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PremiumCard extends StatelessWidget {
  final String label;
  final String title;
  final String price;
  final String after;
  final List<String> features;
  final String buttonText;
  final Color buttonColor;
  final Color borderColor;
  final String description;

  const _PremiumCard({
    required this.label,
    required this.title,
    required this.price,
    required this.after,
    required this.features,
    required this.buttonText,
    required this.buttonColor,
    required this.borderColor,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.workspace_premium, color: Colors.white, size: 28),
              const SizedBox(width: 8),
              Text(
                'Premium',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: borderColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            after,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          ...features.map(
            (f) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: Colors.white, fontSize: 16)),
                Expanded(
                  child: Text(
                    f,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: PremiumButton(
              text: buttonText,
              color: buttonColor,
              textColor: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Thanh toán một lần',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
