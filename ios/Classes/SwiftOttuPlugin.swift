import Flutter
import UIKit
import PassKit

public class SwiftOttuPlugin: NSObject, FlutterPlugin {
    let paymentAuthorizationController = PKPaymentAuthorizationController()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ottu", binaryMessenger: registrar.messenger())
        let instance = SwiftOttuPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private var flutterResult: FlutterResult?
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "canMakePayments") {
            canMakePayment(result: result)
        } else if(call.method == "canMakePaymentsWithActiveCard") {
            canMakePaymentsWithActiveCard(arguments: call.arguments, result: result)
        } else if(call.method == "requestPayment") {
            requestPayment(arguments: call.arguments, result: result)
        } else if(call.method == "switchEnvironment") {}
        
    }
    
    func canMakePayment(arguments: Any? = nil, result: @escaping FlutterResult) {
        let canMakePayment = PKPaymentAuthorizationController.canMakePayments()
        result(canMakePayment)
    }
    
    func canMakePaymentsWithActiveCard(arguments: Any? = nil, result: @escaping FlutterResult) {
        guard let params = arguments as? [String: Any],
              let paymentNetworks = params["paymentNetworks"] as? [String] else {
            result(FlutterError(code: "invalidParameters", message: "Invalid parameters", details: nil))
            return;
        }
        let pkPaymentNetworks: [PKPaymentNetwork] = paymentNetworks.compactMap({ PaymentNetworkHelper.decodePaymentNetwork($0) })
        let canMakePayments = PKPaymentAuthorizationController.canMakePayments(usingNetworks: pkPaymentNetworks)
        result(canMakePayments)
    }
    
    func requestPayment(arguments: Any? = nil, result: @escaping FlutterResult) {
        NSLog("requestPayment started result \(result)");
        guard let params = arguments as? [String: Any],
              let merchantID = params["merchantIdentifier"] as? String,
              let currency = params["currencyCode"] as? String,
              let countryCode = params["countryCode"] as? String,
              let allowedPaymentNetworks = params["allowedPaymentNetworks"] as? [String],
              let items = params["items"] as? [[String: String]] else {
            result(FlutterError(code: "invalidParameters", message: "Invalid parameters", details: nil))
            return
        }
        var paymentItems = [PKPaymentSummaryItem]()
        for item in items {
            guard let itemTitle = item["name"], let itemPrice = item["price"] else {
                result(FlutterError(code: "invalidItem", message: "Invalid item", details: nil))
                return
            }
            let itemDecimalPrice = NSDecimalNumber(string: itemPrice)
            let paymentItem = PKPaymentSummaryItem(label: itemTitle, amount: itemDecimalPrice)
            paymentItems.append(paymentItem)
        }
        
        let paymentNetworks = allowedPaymentNetworks.count > 0 ? allowedPaymentNetworks.compactMap { PaymentNetworkHelper.decodePaymentNetwork($0) } : PKPaymentRequest.availableNetworks()
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentItems        
        paymentRequest.merchantIdentifier = merchantID
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = countryCode
        paymentRequest.currencyCode = currency
        paymentRequest.supportedNetworks = paymentNetworks
        
        let paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        NSLog("paymentController \(paymentController)");
        
        paymentController.delegate = self
        self.flutterResult = result
        paymentController.present(completion: nil)
    }
    
    private func paymentResult(pkPayment: PKPayment?) {
        if let result = flutterResult {
            if let payment = pkPayment {
                let token = String(data: payment.token.paymentData, encoding: .utf8)
                result(["token": token])
            } else {
                result(FlutterError(code: "userCancelledError", message: "User cancelled the payment", details: nil))
            }
            flutterResult = nil
        }
    }
}

@available(iOS 10.0, *)
extension SwiftOttuPlugin: PKPaymentAuthorizationControllerDelegate {
    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        paymentResult(pkPayment: nil)
        controller.dismiss(completion: nil)
    }
    
    @available(iOS 11.0, *)
    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) ->  Void) {
        paymentResult(pkPayment: payment)
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
}
