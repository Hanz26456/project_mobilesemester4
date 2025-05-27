// File: widgets/chat_bubble.dart
// Widget untuk menampilkan bubble chat dengan dukungan quick replies

import 'package:flutter/material.dart';
import '../data/models/chat_message.dart';
import '../data/models/quick_reply_option.dart';
import '../data/services/chatbot_service.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(String) onQuickReplySelected;
  
  const ChatBubble({
    Key? key,
    required this.message,
    required this.onQuickReplySelected,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: message.isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        // Bubble pesan chat
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: message.isUser 
                ? Theme.of(context).primaryColor 
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: message.isUser ? Colors.white : Colors.black87,
              fontSize: 15,
            ),
          ),
        ),
        
        // Timestamp kecil
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 5, left: 8, right: 8),
          child: Text(
            _formatTime(message.timestamp),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 11,
            ),
          ),
        ),
        
        // Quick reply options (hanya untuk pesan dari bot)
        if (!message.isUser && message.quickReplies != null && message.quickReplies!.isNotEmpty)
          _buildQuickReplies(context, message.quickReplies!),
      ],
    );
  }
  
  // Widget untuk menampilkan opsi quick reply
 Widget _buildQuickReplies(BuildContext context, List<QuickReplyOption> options) {
  return Container(
    margin: const EdgeInsets.only(top: 8, bottom: 16),
    height: 40,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: ElevatedButton(
            onPressed: () => onQuickReplySelected(option.value),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black87,
              backgroundColor: Colors.white, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.5)),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (option.iconName != null) ...[  // Cek apakah iconName ada
                  Icon(
                    _getIconData(option.iconName!),  // Dapatkan ikon berdasarkan iconName
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  option.text,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

  
  // Helper untuk mendapatkan icon berdasarkan nama
  IconData _getIconData(String iconName) {
    // Map nama icon ke IconData, sesuaikan dengan kebutuhan
    final Map<String, IconData> iconMap = {
      'ac': Icons.ac_unit,
      'price': Icons.attach_money,
      'schedule': Icons.calendar_today,
      'repair': Icons.build,
      'promo': Icons.local_offer,
      // Tambahkan icon lain sesuai kebutuhan
    };
    
    return iconMap[iconName] ?? Icons.chat_bubble_outline;
  }
  
  // Format timestamp untuk ditampilkan
  String _formatTime(DateTime time) {
    // Format jam:menit
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}