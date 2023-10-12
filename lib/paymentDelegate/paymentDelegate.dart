// ignore_for_file: file_names

///Delegate to handle callbacks
abstract class PaymentDelegate {
  void successCallback(String paymentStatus);

  void cancelCallback(String paymentStatus);
  void beforeRedirect(String paymentStatus);
  void errorCallback(String paymentStatus);
}
