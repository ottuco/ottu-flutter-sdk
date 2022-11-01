class FetchPaymentTransaction {
  FetchPaymentTransaction({
    this.amount,
    this.applePayConfig,
    this.attachment,
    this.cards,
    this.checkoutShortUrl,
    this.checkoutUrl,
    this.currencyCode,
    this.customerEmail,
    this.customerFirstName,
    this.customerId,
    this.customerLastName,
    this.customerPhone,
    this.emailRecipients,
    this.extra,
    this.initiatorId,
    this.language,
    this.mode,
    this.cansavecard,
    this.notifications,
    this.operation,
    this.orderNo,
    this.paymentMethods,
    this.pgCodes,
    this.redirectUrl,
    this.sessionId,
    this.state,
    this.submitUrl,
    this.type,
    this.vendorName,
    this.webhookUrl,
    this.applePayAvailable,
    this.publicKeyUrl,
  });

  String? amount;
  ApplePayConfig? applePayConfig;
  dynamic attachment;
  List<Card>? cards;
  dynamic checkoutShortUrl;
  String? checkoutUrl;
  String? currencyCode;
  String? customerEmail;
  String? customerFirstName;
  bool? cansavecard;
  String? customerId;
  String? customerLastName;
  String? customerPhone;
  List<dynamic>? emailRecipients;
  Extra? extra;
  dynamic initiatorId;
  String? language;
  String? mode;
  Extra? notifications;
  String? operation;
  dynamic orderNo;
  List<PaymentMethod>? paymentMethods;
  List<String>? pgCodes;
  String? redirectUrl;
  String? sessionId;
  String? state;
  String? submitUrl;
  String? type;
  String? vendorName;
  String? publicKeyUrl;
  String? webhookUrl;
  bool? applePayAvailable;

  factory FetchPaymentTransaction.fromJson(Map<String, dynamic> json) =>
      FetchPaymentTransaction(
        amount: json["amount"],
        applePayConfig: json["apple_pay_config"] == null
            ? ApplePayConfig()
            : ApplePayConfig.fromJson(json["apple_pay_config"]),
        attachment: json["attachment"],
        cards: json['cards'] == null
            ? []
            : List<Card>.from(json["cards"].map((x) => Card.fromJson(x))),
        checkoutShortUrl: json["checkout_short_url"],
        checkoutUrl: json["checkout_url"],
        currencyCode: json["currency_code"],
        cansavecard: json['can_save_card'],
        customerEmail: json["customer_email"],
        publicKeyUrl: json['public_key_url'],
        customerFirstName: json["customer_first_name"],
        customerId: json["customer_id"],
        customerLastName: json["customer_last_name"],
        customerPhone: json["customer_phone"],
        initiatorId: json["initiator_id"],
        language: json["language"],
        mode: json["mode"],
        operation: json["operation"],
        orderNo: json["order_no"],
        paymentMethods: json["payment_methods"] == null
            ? []
            : List<PaymentMethod>.from(
                json["payment_methods"].map((x) => PaymentMethod.fromJson(x))),
        pgCodes: List<String>.from(json["pg_codes"].map((x) => x)),
        redirectUrl: json["redirect_url"],
        sessionId: json["session_id"],
        state: json["state"],
        submitUrl: json["submit_url"],
        type: json["type"],
        vendorName: json["vendor_name"],
        webhookUrl: json["webhook_url"],
        applePayAvailable: json["apple_pay_available"],
      );
}

class ApplePayConfig {
  ApplePayConfig({
    this.domain,
    this.code,
    this.shopName,
    this.amount,
    this.fee,
    this.currencyCode,
    this.countryCode,
    this.validationUrl,
    this.paymentUrl,
  });

  String? domain;
  String? code;
  String? shopName;
  String? amount;
  String? fee;
  String? currencyCode;
  String? countryCode;
  String? validationUrl;
  String? paymentUrl;

  factory ApplePayConfig.fromJson(Map<String, dynamic> json) => ApplePayConfig(
        domain: json["domain"] ?? '',
        code: json["code"] ?? '',
        shopName: json["shop_name"] ?? '',
        amount: json["amount"] ?? '',
        fee: json["fee"] ?? '',
        currencyCode: json["currency_code"] ?? '',
        countryCode: json["country_code"] ?? '',
        validationUrl: json["validation_url"] ?? '',
        paymentUrl: json["payment_url"] ?? '',
      );
}

class Card {
  Card({
    this.customerId,
    this.brand,
    this.nameOnCard,
    this.number,
    this.expiryMonth,
    this.expiryYear,
    this.token,
    this.preferred,
    this.isExpired,
    this.requiredCvv,
    this.pgCode,
    this.deleteUrl,
    this.cvv,
    this.submitUrl,
    this.saveCard,
    this.isSelected = false,
  });

  String? customerId;
  String? cvv;
  String? brand;
  bool? requiredCvv;
  String? nameOnCard;
  bool? saveCard;
  String? number;
  String? expiryMonth;
  String? expiryYear;
  String? token;
  bool? preferred;
  bool? isExpired;
  String? pgCode;
  String? deleteUrl;
  String? submitUrl;
  bool isSelected;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        customerId: json["customer_id"],
        brand: json["brand"],
        nameOnCard: json["name_on_card"],
        number: json["number"],
        expiryMonth: json["expiry_month"],
        expiryYear: json["expiry_year"],
        token: json["token"],
        requiredCvv: json['cvv_required'],
        preferred: json["preferred"],
        isExpired: json["is_expired"],
        pgCode: json["pg_code"],
        deleteUrl: json["delete_url"],
        submitUrl: json["submit_url"],
      );
}

class Extra {
  Extra();

  factory Extra.fromJson(Map<String, dynamic> json) => Extra();

  Map<String, dynamic> toJson() => {};
}

class PaymentMethod {
  PaymentMethod({
    this.code,
    this.name,
    this.pg,
    this.type,
    this.amount,
    this.currencyCode,
    this.fee,
    this.icon,
    this.isSelected = false,
    this.ischecked = false,
    this.isRedirectSelected = false,
    this.flow,
    this.submitUrl,
    this.redirectUrl,
  });

  String? code;
  String? name;
  String? pg;
  String? type;
  String? amount;

  String? currencyCode;
  String? fee;
  String? icon;
  bool isSelected;
  bool isRedirectSelected;
  bool ischecked;
  String? flow;
  String? submitUrl;
  String? redirectUrl;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        code: json["code"],
        name: json["name"],
        pg: json["pg"],
        type: json["type"],
        amount: json["amount"],
        currencyCode: json["currency_code"],
        fee: json["fee"],
        icon: json["icon"],
        flow: json["flow"],
        submitUrl: json["submit_url"] ?? '',
        redirectUrl: json["redirect_url"] ?? '',
      );
}
