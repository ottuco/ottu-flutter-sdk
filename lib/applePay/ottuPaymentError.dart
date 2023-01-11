class OttuPaymentError extends Error {
  final String? description;
  final String? code;

  OttuPaymentError({this.code, this.description});

  @override
  String toString() {
    return '''\n
    Error: $code.
    Description: $description''';
  }
}