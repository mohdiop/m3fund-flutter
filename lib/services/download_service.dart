import 'dart:typed_data';

import 'package:m3fund_flutter/constants.dart';
import 'package:dio/dio.dart';

class DownloadService {
  Future<Uint8List?> fetchImageBytes(String path) async {
    final dio = Dio();
    final url = "$baseUrl/public/download";
    final response = await dio.get(
      url,
      queryParameters: {"absolutePath": path},
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data);
  }
}
