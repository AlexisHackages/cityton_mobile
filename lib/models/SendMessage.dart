class SendMessage {
  String message;
  int discussionId;
  String imageUrl;

  SendMessage(String message, int discussionId, String imageUrl){
    this.message = message;
    this.discussionId = discussionId;
    this.imageUrl = imageUrl;
  }

  Map<String, dynamic> toJson() => 
  {
    'message': this.message,
    'discussionId': this.discussionId,
    'imageUrl': this.imageUrl,
  };
}