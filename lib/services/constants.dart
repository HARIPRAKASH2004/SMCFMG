import '/utils/api_handler.dart';
import '/services/auth_services.dart';
class RestAPI {
  final String url;
  final String method;

  RestAPI({
    required this.url,
    required this.method,
  });
}

class Constants {
  static const String uri = "http://192.168.53.132:5000";
 // static const String uri = "https://192.168.53.132:5000";
  static const vapidKey =
      "BGm0V2dKGdvYkJdMUi3Uzmjc0FVFkGzpYN19llpiU_KuYQUjZfdkr1Iov6qPliZT7cSS1tTjd0McNSYraiVGgj8";
}

class RESTURIConstants {
  static const String post = 'POST';
  static const String get = 'GET';
  static const String put = 'PUT';
  static const String delete = 'DELETE';

  static RestAPI register() => RestAPI(
    url: "/user/register",
    method: post,
  );
  static RestAPI getData() => RestAPI(
    url: "/user/data",
    method: get,
  );
}

