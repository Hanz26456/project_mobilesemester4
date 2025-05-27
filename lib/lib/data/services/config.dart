class Config {
  static const String baseUrl ="https://webfw23.myhost.id/gol_bws1/api";
  static const String fileBaseUrl ="https://webfw23.myhost.id/gol_bws1/public/"; // Pastikan URL benar

 static String getProfilePhotoUrl(String filename) {
    return '$fileBaseUrl$filename';
}
}  