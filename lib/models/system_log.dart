class SystemLog {
  final String timestamp;
  final String message;

  SystemLog(this.timestamp, this.message);

  factory SystemLog.fromJson(String key, String value) {
    final timestamp = key;
    final message = value;
    return SystemLog(timestamp, message);
  }
  @override
  String toString() {
    return 'SystemLog { timestamp: $timestamp, message: $message }';
  }
}
