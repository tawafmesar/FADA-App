class ScanHistoryModel {
  int? scanhistoryId;
  String? filePath;
  String? recognizedText;
  String? result;
  int? userId;
  int? ScanType;
  String? dateTime;

  ScanHistoryModel(
      {this.scanhistoryId,
        this.filePath,
        this.recognizedText,
        this.result,
        this.userId,
        this.ScanType,
        this.dateTime});

  ScanHistoryModel.fromJson(Map<String, dynamic> json) {
    scanhistoryId = json['scanhistory_id'];
    filePath = json['file_path'];
    recognizedText = json['recognized_text'];
    result = json['result'];
    userId = json['user_id'];
    ScanType = json['scan_type'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['scanhistory_id'] = this.scanhistoryId;
    data['file_path'] = this.filePath;
    data['recognized_text'] = this.recognizedText;
    data['result'] = this.result;
    data['user_id'] = this.userId;
    data['scan_type'] = this.ScanType;
    data['date_time'] = this.dateTime;
    return data;
  }
}