import 'package:bytebank/http/interceptors/logging_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';

const String baseUrl = 'http://192.168.0.13:8081/transactions';

final Client client = HttpClientWithInterceptor.build(
  interceptors: [LoggingInterceptor()],
);
