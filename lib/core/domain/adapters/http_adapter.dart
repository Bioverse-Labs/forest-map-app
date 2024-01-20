import 'dart:io';

abstract class HttpAdapter {
  Future<File> downloadFile(String url);
}
