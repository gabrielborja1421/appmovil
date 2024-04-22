class ResponseAPI<T> {
  int status;
  String message;
  T? body;

  ResponseAPI({
    required this.status,
    required this.message,
    this.body,
  });

  factory ResponseAPI.fromMap(Map<String, dynamic> map) {
    return ResponseAPI(
      status: map['status'],
      message: map['message'],
      body: map['body'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'body': body,
    };
  }
}
