class Config {
  static const String baseUrl ="http://192.168.100.205:8000/api";
  static const String fileBaseUrl = "http://192.168.100.205:8000"; // Pastikan URL benar

 static String getProfilePhotoUrl(String filename) {
    return '$fileBaseUrl$filename';
}
} 