import 'package:cloud_firestore/cloud_firestore.dart';

class PendingBlockRequestedModel{
   String claimId;
  String blockId;
  var timestamp;
  String text;
  String docId;
  PendingBlockRequestedModel({this.claimId,this.blockId,this.timestamp,this.text});
  PendingBlockRequestedModel.fromDocumentSnapshot(DocumentSnapshot snapshot):
  claimId=snapshot.data['claim_id']??"",
  blockId=snapshot.data['block_id']??"",
  text=snapshot.data['text']??"",
  timestamp=snapshot.data['timestamp'],
  docId=snapshot.documentID;
 toJson(){
    return {
      'claim_id':claimId,
      'block_id':blockId,
      'text':text,
      'timestamp':timestamp

    };
  }
}