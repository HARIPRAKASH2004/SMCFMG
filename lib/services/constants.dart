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
   // static const String uri = "http://192.168.53.132:5000";
  // static const String uri = "http://192.168.163.132:5000";
  static const String uri = "https://track-bcakend-production.up.railway.app";
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
  static RestAPI logout() => RestAPI(
    url: "/user/logout",
    method: delete,
  );
  static RestAPI login() => RestAPI(
    url: "/user/login",
    method: post,
  );
  static RestAPI googleLogin() => RestAPI(
    url: "/user/google-login",
    method: post,
  );
  static RestAPI updateOnlineStatus() => RestAPI(
    url: "/user/online-status",
    method: put,
  );
  static RestAPI updateAadhaarNumber() => RestAPI(
    url: "/user/update-aadhaar", // Update to the correct endpoint
    method: put,
  );
  static RestAPI registerVehicle() => RestAPI(
    url: "/vehicles/register", // Updated endpoint path
    method: post, // Use POST for creating resources like vehicles
  );
  static RestAPI updatePassword() => RestAPI(
    url: "/user/change-password", // Updated endpoint path
    method: put,
  );
  static RestAPI getAllUsers() => RestAPI(
    url: "/admin/get-allusers", // Updated endpoint path
    method: get,
  );
  static RestAPI getAllVendors() => RestAPI(
    url: "/admin/get-allvendors", // Updated endpoint path
    method: get,
  );
  static RestAPI submitVendorDetails() => RestAPI(
    url: "/admin/vendordetail", // Updated endpoint path
    method: post,
  );
  static RestAPI deleteVendor(String vendorId) => RestAPI(
    url: "/admin/delete-vendor/$vendorId", // Updated endpoint path
    method: delete,
  );
  static RestAPI fetchVendors() => RestAPI(
    url: "/admin/activeVendors", // Updated endpoint path
    method: get,
  );
  static RestAPI deleteUser(String UserId) => RestAPI(
    url: "/admin/delete-user/$UserId", // Updated endpoint path
    method: delete,
  );
  static RestAPI fetchDashboardSummary() => RestAPI(
    url: "/admin/dashboard-summary", // Updated endpoint path
    method: get,
  );
  static RestAPI assignOrder() => RestAPI(
    url: "/admin/assign-order", // Updated endpoint path
    method: post,
  );
  static RestAPI getOrdersByUser() => RestAPI(
    url: "/user/user-order", // Endpoint uses token to identify user
    method: get,
  );





}

