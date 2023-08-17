class URL {
  String api = true
      // ignore: dead_code
      ? "https://www.cowsoncloud.com:5002/api/"
      : "http://localhost:5001/api/";
}

class API {
  static String localLogin = "http://localhost/billing/api/login/validate.php";
  static String itemMaster =
      "http://localhost/billing/api/login/itemMaster.php";
  static String login = "${URL().api}/login";
  static String animal = "${URL().api}/animal";
}
