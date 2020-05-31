class SendMessage {
  String message;
  int discussionId;
  String mediaUrl;

  SendMessage(String message, int discussionId, String mediaUrl){
    this.message = message;
    this.discussionId = discussionId;
    this.mediaUrl = mediaUrl;
  }

  Map<String, dynamic> toJson() => 
  {
    'message': this.message,
    'discussionId': this.discussionId,
    'mediaUrl': this.mediaUrl,
  };
}