import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModelMessage {
  String message;
  String senderId;
  String receiverId;
  int docId;
  DocumentReference documentReference;
  var timeStamp;
  ChatModelMessage({this.message, this.senderId,this.receiverId,this.docId,this.documentReference,this.timeStamp});

  ChatModelMessage.fromDocumentSnap(DocumentSnapshot data)
      : message = data['message']??"",
        senderId = data['sender_id']??"",
        docId=data['doc_id'],
        timeStamp=data['timestamp']??"",
        receiverId=data['receiver_id']??"";


  toJson(){
    return {
     'message':message,
     'sender_id':senderId,
     'receiver_id':receiverId,
     'timestamp':timeStamp,
     'doc_id':docId
    };
  }
}