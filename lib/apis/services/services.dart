import 'package:moekey/apis/dio.dart';

abstract class MisskeyApiServices {
  MisskeyApiServices({required this.client});

  MisskeyApisHttpClient client;
}
