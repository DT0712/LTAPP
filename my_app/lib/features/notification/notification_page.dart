import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      // --- APPBAR ---
      appBar: AppBar(
        // Style
        backgroundColor: const Color(0xFFC0DFFF),
        elevation: 8,
        shadowColor: Colors.black12,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,

        // Bo góc
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),

        // Tiêu đề "Thông báo"
        title: Text(
          'Thông báo',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D3A5F),
              ),
        ),
        centerTitle: true,

        // TabBar được đặt ở 'bottom' của AppBar
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          indicatorWeight: 3.0,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          tabs: [
            //Chung
            const Tab(
              text: 'Chung',
            ),

            //Gợi ý
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Gợi ý'),
                  const SizedBox(width: 4),
                  // Badge "10"
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '10',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ---  BODY  ---
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab "Chung"
          _buildNotificationList(),

          // Tab "Gợi ý"
          _buildSuggestionList(),
        ],
      ),
    );
  }

  // Danh sách thông báo Chung
  Widget _buildNotificationList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      children: const [
        // Item 1
        _NotificationListItem(
          imageAsset: 'assets/images/notification/highlands.webp',
          title: 'ĐẶT BÀN THÀNH CÔNG',
          subtitle: 'Bạn đã đặt bàn ở HighLands thành công. Mã vé: #HL8823...',
          time: '1 phút trước',
          hasBadge: true,
          badgeCount: '1',
        ),

        // Item 2
        _NotificationListItem(
          imageAsset: 'assets/images/notification/spicybox.png',
          title: 'SIÊU SALE GIỜ VÀNG',
          subtitle: 'SpicyBox giảm giá 50% combo lẩu chỉ trong 2 giờ tới...',
          time: '15 phút trước',
          hasBadge: true,
          badgeCount: '1',
        ),

        // Item 3
        _NotificationListItem(
          imageAsset: 'assets/images/chat/the_reverie_saigon.png',
          title: 'SẮP ĐẾN GIỜ CHECK-IN',
          subtitle:
              'Bạn có lịch đặt phòng tại The Reverie vào 14:00 chiều nay...',
          time: '30 phút trước',
          hasBadge: true,
          badgeCount: '!',
        ),

        // Item 4
        _NotificationListItem(
          imageAsset: 'assets/images/notification/highlands.webp',
          title: 'GIAO HÀNG THÀNH CÔNG',
          subtitle: 'Tài xế đã giao đơn hàng trà sen vàng đến sảnh tòa nhà...',
          time: '2 giờ trước',
        ),

        // Item 5
        _NotificationListItem(
          imageAsset: 'assets/images/DiaDiem/landmark_81.jpg',
          title: 'BẠN CẢM THẤY THẾ NÀO?',
          subtitle:
              'Hãy chia sẻ cảm nhận về chuyến đi Landmark 81 vừa qua nhé...',
          time: '5 giờ trước',
        ),

        // Item 6
        _NotificationListItem(
          imageAsset: 'assets/images/headers/destination_header.jpg',
          title: 'GỢI Ý ĐỊA ĐIỂM',
          subtitle:
              'Phát hiện 3 quán cafe view đẹp mới mở gần vị trí của bạn...',
          time: '10 giờ trước',
        ),

        // Item 7
        _NotificationListItem(
          imageAsset: 'assets/images/headers/destination_header.jpg',
          title: 'CẬP NHẬT ỨNG DỤNG',
          subtitle: 'Phiên bản mới 2.0 đã sẵn sàng với giao diện tối ưu hơn...',
          time: '1 ngày trước',
        ),

        // Item 8
        _NotificationListItem(
          imageAsset: 'assets/images/notification/spicybox.png',
          title: 'VOUCHER SẮP HẾT HẠN',
          subtitle:
              'Voucher giảm 15% của bạn sẽ hết hạn vào ngày mai. Dùng ngay!',
          time: '1 ngày trước',
        ),

        // Item 9
        _NotificationListItem(
          imageAsset: 'assets/images/chat/the_reverie_saigon.png',
          title: 'CHÀO MỪNG BẠN MỚI',
          subtitle: 'Cảm ơn bạn đã tham gia iTour. Tặng bạn 500 điểm thưởng...',
          time: '3 ngày trước',
        ),

        // Item 10
        _NotificationListItem(
          imageAsset: 'assets/images/DiaDiem/ben_thanh.jpg',
          title: 'SỰ KIỆN CUỐI TUẦN',
          subtitle: 'Chợ Bến Thành tổ chức lễ hội ẩm thực đường phố đêm nay...',
          time: '4 ngày trước',
        ),
      ],
    );
  }

  // Danh sách Gợi ý
  Widget _buildSuggestionList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      children: const [
        // Item 1
        _NotificationListItem(
          imageAsset: 'assets/images/headers/destination_header.jpg',
          title: 'KHÁM PHÁ ĐÀ LẠT',
          subtitle: 'Mùa này Đà Lạt đang rất đẹp, săn mây ngay...',
          time: 'Vừa xong',
          hasBadge: true,
          badgeCount: '1',
        ),

        // Item 2
        _NotificationListItem(
          imageAsset: 'assets/images/DiaDiem/landmark_81.jpg',
          title: 'CHECK-IN LANDMARK 81',
          subtitle: 'Ngắm toàn cảnh thành phố từ trên cao...',
          time: '15 phút trước',
        ),

        // Item 3
        _NotificationListItem(
          imageAsset: 'assets/images/notification/spicybox.png',
          title: 'VOUCHER GIẢM 50%',
          subtitle: 'Dành riêng cho bạn khi ăn tại SpicyBox...',
          time: '2 giờ trước',
          hasBadge: true,
          badgeCount: '1',
        ),

        // Item 4
        _NotificationListItem(
          imageAsset: 'assets/images/DiaDiem/ben_thanh.jpg',
          title: 'ẨM THỰC CHỢ BẾN THÀNH',
          subtitle: 'Top 5 món ăn nhất định phải thử khi đến đây...',
          time: '3 giờ trước',
        ),

        // Item 5
        _NotificationListItem(
          imageAsset: 'assets/images/chat/the_reverie_saigon.png',
          title: 'KHÁCH SẠN 5 SAO',
          subtitle: 'Trải nghiệm nghỉ dưỡng đẳng cấp tại Reverie...',
          time: '5 giờ trước',
        ),

        // Item 6
        _NotificationListItem(
          imageAsset: 'assets/images/notification/highlands.webp',
          title: 'CÀ PHÊ CUỐI TUẦN',
          subtitle: 'Highlands tặng bạn mã Freeship cho đơn từ 100k...',
          time: '1 ngày trước',
        ),

        // Item 7
        _NotificationListItem(
          imageAsset: 'assets/images/DiaDiem/suoi_tien.jpg',
          title: 'LỄ HỘI TRÁI CÂY',
          subtitle: 'Sắp diễn ra tại Suối Tiên với nhiều hoạt động...',
          time: '1 ngày trước',
        ),

        // Item 8
        _NotificationListItem(
          imageAsset: 'assets/images/DiaDiem/nha_tho_duc_ba.jpg',
          title: 'GÓC CHỤP ẢNH ĐẸP',
          subtitle: 'Hướng dẫn chụp ảnh check-in cực chất tại Quận 1...',
          time: '2 ngày trước',
        ),

        // Item 9
        _NotificationListItem(
          imageAsset: 'assets/images/headers/destination_header.jpg',
          title: 'BẠN MUỐN ĐI ĐÂU?',
          subtitle: 'Cập nhật danh sách địa điểm hot tháng này...',
          time: '2 ngày trước',
        ),

        // Item 10
        _NotificationListItem(
          imageAsset: 'assets/images/headers/destination_header.jpg',
          title: 'CẨM NANG DU LỊCH',
          subtitle: 'Những vật dụng không thể thiếu khi đi phượt...',
          time: '3 ngày trước',
        ),
      ],
    );
  }
}

/// Widget con cho mỗi item thông báo
class _NotificationListItem extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;
  final String time;
  final bool hasBadge;
  final String badgeCount;

  const _NotificationListItem({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.time,
    this.hasBadge = false,
    this.badgeCount = '0',
  });

  @override
  Widget build(BuildContext context) {
    // Màu tiêu đề
    const Color titleColor = Colors.black87;

    // Phụ đề thay đổi màu dựa trên 'hasBadge'.
    final Color subtitleColor = hasBadge ? Colors.black! : Colors.grey[500]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar và Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    width: 80.0,
                    height: 80.0,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported,
                          color: Colors.grey);
                    },
                  ),
                ),
              ),
              if (hasBadge)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      badgeCount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Tiêu đề, Phụ đề
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Thời gian
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
