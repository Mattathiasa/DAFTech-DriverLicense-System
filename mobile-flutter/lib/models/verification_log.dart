class VerificationLog {
  final String id;
  final String licenseId;
  final String
  result; // 'real', 'fake', 'expired' (mapped from verificationStatus)
  final DateTime timestamp;
  final bool isReal;
  final bool? isActive;
  final int? checkedBy;

  VerificationLog({
    required this.id,
    required this.licenseId,
    required this.result,
    required this.timestamp,
    required this.isReal,
    this.isActive,
    this.checkedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'licenseId': licenseId,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
      'isReal': isReal,
      'isActive': isActive,
      'checkedBy': checkedBy,
    };
  }

  factory VerificationLog.fromJson(Map<String, dynamic> json) {
    return VerificationLog(
      id: json['logId']?.toString() ?? json['id'] ?? '',
      licenseId: json['licenseId'],
      result: json['verificationStatus'] ?? json['result'] ?? '',
      timestamp: DateTime.parse(json['checkedDate'] ?? json['timestamp']),
      isReal: json['isReal'] ?? (json['result'] == 'real'),
      isActive: json['isActive'],
      checkedBy: json['checkedBy'],
    );
  }
}
