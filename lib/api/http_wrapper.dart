import 'package:http/http.dart';

class HttpWrapper {
  late Client client;

  HttpWrapper() {
    client = Client();
  }

  Future<Response> get(String url) {
    return this.client.get(Uri.parse(url));
  }

  Future<Response> post(String url, { Map<String, String>? headers, body }) {
    return this.client.post(Uri.parse(url), headers: headers, body: body);
  }

  Future<Response> put(String url, { Map<String, String>? headers, body }) {
    return this.client.put(Uri.parse(url), headers: headers, body: body);
  }

  Future<Response> delete(String url) {
    return this.client.delete(Uri.parse(url));
  }
}
