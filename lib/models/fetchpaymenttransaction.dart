class Payment {
  Payment({
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
    this.responseConfig,
  });

  String? amount;
  ApplePayConfig? applePayConfig;
  ResponseConfig? responseConfig;
  dynamic attachment;
  List<Card>? cards;
  dynamic checkoutShortUrl;
  String? checkoutUrl;
  String? currencyCode;
  String? customerEmail;
  String? customerFirstName;
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
  String? webhookUrl;
  bool? applePayAvailable;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        amount: json["amount"],
        applePayConfig: json["apple_pay_config"] == null ? ApplePayConfig() : ApplePayConfig.fromJson(json["apple_pay_config"]),
        attachment: json["attachment"],
        cards: json['cards'] == null ? [] : List<Card>.from(json["cards"].map((x) => Card.fromJson(x))),
        checkoutShortUrl: json["checkout_short_url"],
        checkoutUrl: json["checkout_url"],
        responseConfig: json['response'] == null
            ? ResponseConfig()
            : ResponseConfig.fromJson(
                json['response'],
              ),
        currencyCode: json["currency_code"],
        customerEmail: json["customer_email"],
        customerFirstName: json["customer_first_name"],
        customerId: json["customer_id"],
        customerLastName: json["customer_last_name"],
        customerPhone: json["customer_phone"],
        initiatorId: json["initiator_id"],
        language: json["language"],
        mode: json["mode"],
        operation: json["operation"],
        orderNo: json["order_no"],
        paymentMethods: json["payment_methods"] == null ? [] : List<PaymentMethod>.from(json["payment_methods"].map((x) => PaymentMethod.fromJson(x))),
        pgCodes: json["pg_codes"] == null ? [] : List<String>.from(json["pg_codes"].map((x) => x)),
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
    this.fee_description,
    this.merchant_id,
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
  String? fee_description;
  String? merchant_id;

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
        fee_description: json["fee_description"] ?? '',
        merchant_id: json["merchant_id"] ?? '',
      );
}

class ResponseConfig {
  ResponseConfig({
    this.status,
    this.session_id,
    this.message,
    this.order_no,
    this.operation,
    this.reference_number,
    this.redirect_url,
  });

  String? status;
  String? session_id;
  String? message;
  String? order_no;
  String? operation;
  String? reference_number;
  String? redirect_url;

  factory ResponseConfig.fromJson(Map<String, dynamic> json) => ResponseConfig(
        status: json["status"] ?? '',
        session_id: json["session_id"] ?? '',
        message: json["message"] ?? '',
        order_no: json["order_no"] ?? '',
        operation: json["operation"] ?? '',
        reference_number: json["reference_number"] ?? '',
        redirect_url: json["redirect_url"] ?? '',
      );
  Map<String, dynamic> toJson() => {
        "status": status,
        "session_id": session_id,
        "message": message,
        "order_no": order_no,
        "operation": operation,
        "reference_number": reference_number,
        "redirect_url": redirect_url,
      };
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
    this.fee_description,
    this.cansavecard,
    this.publicKeyUrl,
    this.cancelUrl,
    this.paymentUrl,
  });

  String? code;
  String? name;
  String? pg;
  String? type;
  String? amount;
  String? paymentUrl;

  String? currencyCode;
  String? fee;
  String? icon;
  bool isSelected;
  bool isRedirectSelected;
  bool ischecked;
  String? flow;
  String? submitUrl;
  String? redirectUrl;
  String? fee_description;
  bool? cansavecard;
  String? publicKeyUrl;
  String? cancelUrl;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        code: json["code"],
        name: json["name"],
        pg: json["pg"],
        type: json["type"],
        amount: json["amount"],
        currencyCode: json["currency_code"],
        fee_description: json["fee_description"] ?? '',
        fee: json["fee"],
        icon: json["icon"],
        flow: json["flow"],
        submitUrl: json["submit_url"] ?? '',
        paymentUrl: json["payment_url"] ?? '',
        redirectUrl: json["redirect_url"] ?? '',
        cansavecard: json['can_save_card'],
        publicKeyUrl: json['flow'] == 'card' ? json['public_key_url'] : '',
        cancelUrl: json['flow'] == 'card' ? json['cancel_url'] : '',
      );
}
