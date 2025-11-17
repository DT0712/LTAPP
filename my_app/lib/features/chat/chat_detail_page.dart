import 'package:flutter/material.dart';

class ChatDetailPage extends StatelessWidget {
  final String name;
  final String avatarAsset;

  const ChatDetailPage({
    super.key,
    required this.name,
    required this.avatarAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 48, 129, 250),
        elevation: 4.0,
        //Nút back
        leadingWidth: 55,
        titleSpacing: 2,
        //Avatar và Tên trên AppBar
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(avatarAsset),
              radius: 18,
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          //Danh sách tin nhắn
          Expanded(
            child: ListView(
              reverse: true, // Bắt đầu từ cuối danh sách
              padding: const EdgeInsets.all(16.0),
              children: const [
                ChatMessageBubble(
                  text: 'Cho 3 người vào 11 giờ trưa.',
                  isMe: true,
                  time: '8:45 AM',
                ),
                ChatMessageBubble(
                  text: 'Dạ vâng, quý khách muốn đặt cho mấy người ạ?',
                  isMe: false,
                  time: '8:44 AM',
                ),
                ChatMessageBubble(
                  text: 'Chào bạn, Cơm quê dượng bầu xin nghe.',
                  isMe: false,
                  time: '8:44 AM',
                ),
                ChatMessageBubble(
                  text: 'Tôi muốn đặt bàn vip ngày 7 tháng 12',
                  isMe: true,
                  time: '8:43 AM',
                ),
              ],
            ),
          ),
          _buildTextInputArea(),
        ],
      ),
    );
  }

  // Widget khu vực nhập văn bản
  Widget _buildTextInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0)
          .copyWith(bottom: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.grey[600]),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Nhắn tin...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send,
                color: Color.fromARGB(255, 48, 129, 250)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// Widget riêng cho từng bong bóng chat
class ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color:
                  isMe ? const Color.fromARGB(255, 48, 129, 250) : Colors.white,
              borderRadius: BorderRadius.circular(18.0).copyWith(
                bottomRight: isMe
                    ? const Radius.circular(4.0)
                    : const Radius.circular(18.0),
                bottomLeft: isMe
                    ? const Radius.circular(18.0)
                    : const Radius.circular(4.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              time,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
            ),
          )
        ],
      ),
    );
  }
}
