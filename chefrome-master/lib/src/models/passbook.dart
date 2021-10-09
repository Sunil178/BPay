class PassBookDetails {
  PassBookDetails({
    this.status,
    this.msg,
    this.data,
  });

  bool status;
  String msg;
  Map<String, dynamic> data;

  PassBookDetails.fromJson(Map<String,dynamic> jsonMap){
    status = jsonMap['status'] !=null ? jsonMap['status']:'';
    msg = jsonMap['msg'] != null ? jsonMap['msg']:'';
    data = jsonMap['data'] !=null ? jsonMap['data']:'';

  }
}
