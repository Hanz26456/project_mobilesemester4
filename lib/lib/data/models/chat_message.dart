// File: models/chat_message.dart
// Updated model untuk pesan chat dengan dukungan untuk quick replies
import 'quick_reply_option.dart';
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<QuickReplyOption>? quickReplies; // Opsi quick reply untuk respons bot
  
  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.quickReplies,
  });
  
  // Konversi dari Map ke objek ChatMessage
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    List<QuickReplyOption>? qr;
    if (json['quickReplies'] != null) {
      qr = (json['quickReplies'] as List)
          .map((i) => QuickReplyOption.fromJson(i as Map<String, dynamic>))
          .toList();
    }
    
    return ChatMessage(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      quickReplies: qr,
    );
  }
  
  // Konversi dari objek ChatMessage ke Map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
    
    if (quickReplies != null) {
      data['quickReplies'] = quickReplies!.map((x) => x.toJson()).toList();
    }
    
    return data;
  }
}

// Import the QuickReplyOption model
