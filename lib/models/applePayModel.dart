class AppleParameters {
  final String merchantIdentifier;

  AppleParameters({
    required this.merchantIdentifier,
  });

  Map<String, dynamic> toMap() {
    return {
      'merchantIdentifier': merchantIdentifier,
    };
  }
}