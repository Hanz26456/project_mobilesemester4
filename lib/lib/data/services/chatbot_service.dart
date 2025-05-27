import '../models/chat_message.dart';
import '../models/quick_reply_option.dart';
import 'dart:math';

class ChatbotService {
  static List<ChatMessage> messages = [];

  // Kategori layanan
  static const List<String> serviceCategories = [
    'AC & Pendingin',
    'Elektronik Rumah Tangga',
    'Perbaikan Komputer & Laptop',
    'Instalasi Listrik',
    'Perbaikan Perabot',
    'Renovasi',
  ];

  static Future<Map<String, dynamic>> getResponse(String message) async {
    await Future.delayed(Duration(milliseconds: 800 + Random().nextInt(700)));

    String responseText;
    List<QuickReplyOption> quickReplies = [];

    if (_containsAnyKeyword(message, ['ac', 'pendingin', 'cooling'])) {
      responseText = '''
Layanan AC & Pendingin kami meliputi:
• Pemasangan AC baru (split/window/central)
• Pembersihan rutin & deep cleaning
• Perbaikan kerusakan umum
• Konsultasi efisiensi energi

Apakah Anda ingin tahu harga atau langsung buat jadwal?
''';

      quickReplies = [
        QuickReplyOption(text: 'Harga service AC', value: 'harga_ac'),
        QuickReplyOption(text: 'Buat jadwal', value: 'jadwal_ac'),
        QuickReplyOption(text: 'Pembersihan AC', value: 'service_bersih_ac'),
      ];
    } else if (_containsAnyKeyword(message, [
      'listrik',
      'instalasi',
      'lampu',
      'mcb',
    ])) {
      responseText = '''
Kami menyediakan teknisi listrik bersertifikat untuk:
• Instalasi listrik baru
• Perbaikan MCB, stop kontak, saklar
• Pemasangan lampu & emergency system

Perlu teknisi sekarang atau konsultasi dulu?
''';

      quickReplies = [
        QuickReplyOption(text: 'Pasang Lampu', value: 'pasang_lampu'),
        QuickReplyOption(text: 'Perbaikan MCB', value: 'repair_mcb'),
        QuickReplyOption(text: 'Jadwalkan teknisi', value: 'jadwal_listrik'),
      ];
    } else if (_containsAnyKeyword(message, [
      'komputer',
      'laptop',
      'pc',
      'cpu',
    ])) {
      responseText = '''
Kami bisa bantu:
• Perbaikan software & hardware laptop/PC
• Instalasi ulang OS, upgrade RAM/SSD
• Service panggilan langsung ke rumah

Butuh bantuan teknis atau estimasi biaya?
''';

      quickReplies = [
        QuickReplyOption(text: 'Install Ulang', value: 'install_ulang'),
        QuickReplyOption(text: 'Service di rumah', value: 'service_rumah'),
        QuickReplyOption(
          text: 'Harga service komputer',
          value: 'harga_komputer',
        ),
      ];
    } else if (_containsAnyKeyword(message, [
      'elektronik',
      'tv',
      'kulkas',
      'mesin cuci',
      'microwave',
    ])) {
      responseText = '''
Kami menangani perbaikan elektronik rumah tangga seperti:
• TV LED/LCD, kulkas, mesin cuci, microwave
• Diagnosa & perbaikan on-site
• Penggantian komponen asli

Mau service langsung atau konsultasi dulu?
''';

      quickReplies = [
        QuickReplyOption(text: 'Perbaiki TV', value: 'repair_tv'),
        QuickReplyOption(text: 'Service Mesin Cuci', value: 'repair_washer'),
        QuickReplyOption(text: 'Biaya perbaikan', value: 'biaya_elektronik'),
      ];
    } else if (_containsAnyKeyword(message, [
      'renovasi',
      'bangun',
      'tembok',
      'cat',
      'plafon',
    ])) {
      responseText = '''
Tim renovasi kami siap bantu:
• Renovasi dapur, kamar mandi, & ruang tamu
• Perbaikan dinding, plafon, dan pengecatan
• Estimasi transparan dan sesuai budget

Ingin survey lokasi atau konsultasi desain?
''';

      quickReplies = [
        QuickReplyOption(
          text: 'Konsultasi desain',
          value: 'konsultasi_renovasi',
        ),
        QuickReplyOption(text: 'Estimasi biaya', value: 'biaya_renovasi'),
        QuickReplyOption(text: 'Jadwalkan survey', value: 'survey_renovasi'),
      ];
    } else {
      responseText = '''
Halo! 👋 Terima kasih sudah menghubungi Si Tukang.

Kami siap membantu berbagai kebutuhan perbaikan dan instalasi rumah tangga Anda 💪

Silakan pilih kategori layanan yang Anda butuhkan di bawah ini:
''';

      quickReplies = [
        QuickReplyOption(text: 'Layanan AC', value: 'layanan_ac'),
        QuickReplyOption(text: 'Listrik', value: 'layanan_listrik'),
        QuickReplyOption(text: 'Elektronik', value: 'layanan_elektronik'),
        QuickReplyOption(text: 'Komputer / Laptop', value: 'layanan_komputer'),
        QuickReplyOption(text: 'Renovasi Rumah', value: 'layanan_renovasi'),
      ];
    }

    return {
      'text': responseText,
      'quickReplies': quickReplies, // Tidak perlu menggunakan .toJson() lagi
    };
  }

  // Cek apakah pesan mengandung keyword tertentu
  static bool _containsAnyKeyword(String message, List<String> keywords) {
    message = message.toLowerCase();
    for (String keyword in keywords) {
      if (message.contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  // Tambahkan pesan ke histori chat
  static void addMessage(
    String text,
    bool isUser, {
    List<QuickReplyOption>? quickReplies,
  }) {
    messages.add(
      ChatMessage(
        text: text,
        isUser: isUser,
        timestamp: DateTime.now(),
        quickReplies: quickReplies,
      ),
    );
  }

  // Saran respons otomatis berdasarkan histori
  static List<String> getSuggestedResponses() {
    if (messages.isEmpty) {
      return [
        "Saya butuh service AC",
        "Info harga layanan",
        "Ada promo apa saja?",
        "Jadwalkan teknisi",
      ];
    }

    String lastBotMessage = '';
    for (int i = messages.length - 1; i >= 0; i--) {
      if (!messages[i].isUser) {
        lastBotMessage = messages[i].text;
        break;
      }
    }

    if (lastBotMessage.contains('AC') || lastBotMessage.contains('pendingin')) {
      return [
        "Berapa biaya service AC?",
        "AC saya tidak dingin",
        "Saya ingin pasang AC baru",
        "Ada rekomendasi merk AC?",
      ];
    } else if (lastBotMessage.contains('harga') ||
        lastBotMessage.contains('biaya')) {
      return [
        "Ada diskon?",
        "Bisa nego?",
        "Termasuk sparepart?",
        "Cara pembayarannya?",
      ];
    }

    return [
      "Layanan elektronik",
      "Perbaikan komputer",
      "Info promo",
      "Konsultasi masalah rumah",
    ];
  }
}
