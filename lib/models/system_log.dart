class SystemLog {
  final String timestamp;
  final String message;

  SystemLog(this.timestamp, this.message);

  // Assuming the JSON structure has the key as the timestamp and value as the log message
  factory SystemLog.fromJson(String key, dynamic value) {
    return SystemLog(key, value.toString());
  }
}
