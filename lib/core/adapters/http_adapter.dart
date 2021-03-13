import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

abstract class HttpAdapter {
  Future<File> downloadFile(String url);
}

class HttpAdapterImpl implements HttpAdapter {
  @override
  Future<File> downloadFile(String url) async {
    final resp = await http.get(Uri.parse(url));
    final tempDir = (await getTemporaryDirectory()).path;
    final file = File('$tempDir/file.geojson');
    await file.create();
    await file.writeAsBytes(resp.bodyBytes);
    return file;
  }
}
