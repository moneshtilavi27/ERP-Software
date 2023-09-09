class URL {
  String api = false
      ? "https://moneshtilavi.000webhostapp.com/billing/api/login/"
      : "http://localhost/billing/api/login/";
}

class API {
  static String localLogin = "${URL().api}/validate.php";
  static String itemMaster = "${URL().api}/itemMaster.php";
  static String invoice = "${URL().api}/invoice.php";
  static String customer = "${URL().api}/customer.php";

  static String login = "${URL().api}/login";
  static String animal = "${URL().api}/animal";
}
