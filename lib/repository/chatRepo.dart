import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepo {
 
  Future<List<DocumentSnapshot>> fetchFirstList(docId)async {
   return (await Firestore.instance
            .collection("chat").
            document(docId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
            .limit(100)
            .getDocuments())
        .documents;
  }


  Future<List<DocumentSnapshot>> fetchNextList(List<DocumentSnapshot> documentList,docid)async {
    return (await Firestore.instance
         .collection("chat").
            document(docid)
        .collection('messages')
        .orderBy('timestamp', descending: true)
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(100)
            .getDocuments())
        .documents;
  }



}