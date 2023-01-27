class ErrorModel {
  String? message;
  int? code;
  String errors = "";

  ErrorModel({this.message, this.code, errors}) {
    if (message == null) message = "";

    if (errors is List)
      this.errors = "";
    else {
      int i = 0;
      this.errors = "";
      Map<String, dynamic>? _errors = errors;
      _errors?.forEach((key, value) {
        value.forEach((element) {
          this.errors += "${i += 1}. " + element + "\n";
        });
      });
    }
    if (errors == null) errors = "";
  }
}
