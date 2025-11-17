import 'package:flutter/material.dart';
import 'chat_detail_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 48, 129, 250),
        automaticallyImplyLeading: false,
        title: const Text(
          'Tin nhắn',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 8.0,
        shadowColor: Colors.black26,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        toolbarHeight: 100,
      ),
      body: Column(
        children: [
          //Danh sách chat
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 16.0),
              children: const [
                ChatListItem(
                  avatarAsset: 'assets/images/chat/com_que_duong_bau.png',
                  name: 'Cơm quê dượng bầu',
                  message: 'Bạn: Tôi muốn đặt bàn vip ngày 7 tháng 12',
                  time: '8.45 AM',
                ),
                ChatListItem(
                  avatarAsset: 'assets/images/chat/the_reverie_saigon.png',
                  name: 'The Reverie Saigon',
                  message: 'Bạn: Bên bạn còn phòng đôi ngày 6 tháng 12 không?',
                  time: '6.30 AM',
                ),
                ChatListItem(
                  avatarAsset:
                      'assets/images/chat/KunKin_garden_aparthotel.jpg',
                  name: 'KunKin Garden Aparthotel',
                  message: 'Xin lỗi bên mình hiện tại đã hết phòng đôi ạ.',
                  time: '3 weeks',
                ),
                ChatListItem(
                  avatarAsset: 'assets/images/chat/phuc_long.webp',
                  name: 'Phúc Long',
                  message: 'Cảm ơn quý khách đã sử dụng dịch vụ bên mình',
                  time: '2 months',
                ),
                // Thêm các mục chat khác ở đây
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final String avatarAsset;
  final String name;
  final String message;
  final String time;

  const ChatListItem({
    super.key,
    required this.avatarAsset,
    required this.name,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //ĐIỀU HƯỚNG
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailPage(
              name: name, // Truyền tên
              avatarAsset: avatarAsset, // Truyền ảnh
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 30, // Kích thước avatar
              backgroundImage: AssetImage(avatarAsset),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 16),
            // Thông tin
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Tên + Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                      ),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  //Message + Share Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.share_outlined,
                        color: Colors.grey[500],
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
