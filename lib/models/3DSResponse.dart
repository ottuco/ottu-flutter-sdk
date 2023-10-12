
// ignore_for_file: file_names

class ThreeDsResponse {
  ThreeDsResponse({
    this.status,
    this.html,
    this.referenceNumber,
    this.wsUrl,
  });

  String? status;
  String? html;
  String? referenceNumber;
  String? wsUrl;

  factory ThreeDsResponse.fromJson(Map<String, dynamic> json) =>
      ThreeDsResponse(
        status: json["status"],
        html: json["html"],
        referenceNumber: json["reference_number"],
        wsUrl: json["ws_url"],
      );
}
