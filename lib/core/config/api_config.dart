class ApiConfig {
  static const String _defaultBaseUrl = 'https://ngonipay.ismael-dev.com/api';

  static String get baseUrl {
    return const String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: _defaultBaseUrl,
    );
  }

  static bool get isDefaultBaseUrl => baseUrl == _defaultBaseUrl;
}
