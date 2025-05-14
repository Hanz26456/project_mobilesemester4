class QuickReplyOption {
  final String text;
  final String value;
  final String? iconName; // Tambahkan properti iconName

  QuickReplyOption({required this.text, required this.value, this.iconName});

  // Membuat objek QuickReplyOption dari JSON
  factory QuickReplyOption.fromJson(Map<String, dynamic> json) {
    return QuickReplyOption(
      text: json['text'] as String,
      value: json['value'] as String,
      iconName: json['iconName'] as String?,  // Pastikan properti ini ada di JSON
    );
  }

  // Mengubah QuickReplyOption menjadi format JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'value': value,
      'iconName': iconName,  // Sertakan iconName dalam JSON
    };
  }
}
