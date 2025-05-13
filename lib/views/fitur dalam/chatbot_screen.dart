import 'package:flutter/material.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/quick_reply_option.dart';
import '../../data/services/chatbot_service.dart';
import '../../widgets/chatbubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    if (ChatbotService.messages.isEmpty) {
      _getWelcomeMessage();
    }
  }

  void _getWelcomeMessage() async {
    setState(() {
      _isTyping = true;
    });

    final response = await ChatbotService.getResponse('welcome');

    setState(() {
      _isTyping = false;
      ChatbotService.addMessage(
        response['text'],
        false,
        quickReplies: response['quickReplies'],
      );
    });

    _scrollToBottom();
  }

  void _handleSubmit(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();

    setState(() {
      ChatbotService.addMessage(text, true);
      _isTyping = true;
    });

    _scrollToBottom();

    final response = await ChatbotService.getResponse(text);

    setState(() {
      _isTyping = false;
      ChatbotService.addMessage(
        response['text'],
        false,
        quickReplies: response['quickReplies'],
      );
    });

    _scrollToBottom();
  }

  void _handleQuickReplySelected(String value) {
    final selectedOption = ChatbotService.messages.last.quickReplies!
        .firstWhere((option) => option.value == value);

    if (selectedOption != null) {
      _handleSubmit(selectedOption.text);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green.withOpacity(0.2),
              child: Icon(
                Icons.support_agent,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Si Tukang',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildOptionsSheet(context),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: ChatbotService.messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ChatBubble(
                    message: ChatbotService.messages[index],
                    onQuickReplySelected: _handleQuickReplySelected,
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTypingIndicator(),
                    const SizedBox(width: 8),
                    Text(
                      'Asisten sedang mengetik...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          _buildSuggestedResponses(),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      width: 40,
      height: 25,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return _buildDot(index);
        }),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: (value - (0.3 * index)).clamp(0.0, 1.0),
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey[600]),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fitur attachment akan datang segera')),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Ketik pesan Anda...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: _handleSubmit,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _handleSubmit(_textController.text),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedResponses() {
    final suggestions = ChatbotService.getSuggestedResponses();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: suggestions.map((suggestion) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => _handleSubmit(suggestion),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    suggestion,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOptionsSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Riwayat Percakapan'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.rate_review),
            title: Text('Beri Rating'),
            onTap: () {
              Navigator.pop(context);
              _showRatingDialog(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.support_agent),
            title: Text('Hubungi Agen Manusia'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                ChatbotService.addMessage(
                  'Permintaan Anda untuk berbicara dengan agen manusia sedang diproses. Mohon tunggu sebentar, agen kami akan segera menghubungi Anda.',
                  false,
                );
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Hapus Percakapan'),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Beri Rating untuk Asisten Digital'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Seberapa puas Anda dengan layanan asisten kami?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < 3 ? Colors.amber : Colors.grey[300],
                    size: 32,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Terima kasih atas penilaian Anda')),
                    );
                  },
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('BATAL'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Percakapan'),
        content: Text('Anda yakin ingin menghapus seluruh percakapan ini?'),
        actions: [
          TextButton(
            child: Text('BATAL'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('HAPUS'),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                ChatbotService.messages.clear();
                _getWelcomeMessage();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Percakapan telah dihapus')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
