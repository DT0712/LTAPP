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
                  // Badge "12"
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '12',
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

          // Tab "Gợi ý" (Hiện đang trống, bạn có thể thêm ListView khác)
          const Center(child: Text('Không có gợi ý nào')),
        ],
      ),
    );
  }

  // --- HÀM _buildHeader ---

  Widget _buildNotificationList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      children: const [
        // Item 1
        _NotificationListItem(
          imageAsset: 'assets/images/notification/highlands.webp',
          title: 'ĐẶT BÀN THÀNH CÔNG',
          subtitle: 'Bạn đã đặt bàn ở HighLands thành công...',
          time: '1 phút trước.',
          hasBadge: true,
          badgeCount: '2',
        ),
        // Item 2
        _NotificationListItem(
          imageAsset: 'assets/images/headers/destination_header.jpg',
          title: 'GỢI Ý ĐỊA ĐIỂM',
          subtitle: 'Gần bạn...',
          time: '1 phút trước.',
          hasBadge: true,
          badgeCount: '2',
        ),
        // Item 3
        _NotificationListItem(
          imageAsset: 'assets/images/notification/spicybox.png',
          title: 'ƯU ĐÃI HÔM NAY',
          subtitle: 'SpicyBox ưu đãi 15% chỉ hôm nay...',
          time: '1 phút trước.',
        ),
        // Item 4
        _NotificationListItem(
          imageAsset: 'assets/images/chat/the_reverie_saigon.png',
          title: 'ĐẶT PHÒNG THÀNH CÔNG',
          subtitle: 'Bạn đã đặt thành công phòng ở...',
          time: '10 giờ trước.',
        ),
        // Item 5
        _NotificationListItem(
          imageAsset: 'assets/images/notification/highlands.webp',
          title: 'ƯU ĐÃI 20%',
          subtitle: 'Ưu đãi 20% cho quán cà phê HighLands...',
          time: '15 giờ trước.',
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
    // Tiêu đề (title) LUÔN LUÔN có màu đen đậm.
    const Color titleColor = Colors.black87;

    // Phụ đề (subtitle) thay đổi màu dựa trên 'hasBadge'.
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
