abstract class ConfigReader {
  //static late Map<String, dynamic> _config;

  static Future<void> initialize() async {
    //  final configString = await rootBundle.loadString('config/app_config.json');
    //  _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String? getXApiLogin() {
    return null;
    //return _config["x-api-login"] as String;
  }

  static String? getXApiKey() {
    return null;
    //return _config["x-api-key"] as String;
  }
}
