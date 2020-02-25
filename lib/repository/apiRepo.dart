import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:found_it_admin_panel/model/userProfile.dart';
import 'package:found_it_admin_panel/repository/baseRepo.dart';

class ApiRepo extends BaseRepo {
  final Firestore _db = Firestore.instance;

  @override
  Future<List<DocumentSnapshot>> fetchFirstList() async {
    return (await _db
            .collection("pendingBlockList")
            .orderBy("timestamp", descending: true)
            .limit(20)
            .getDocuments())
        .documents;
  }

  @override
  Future<List<DocumentSnapshot>> fetchNextList(
      List<DocumentSnapshot> documentList) async {
    return (await _db
            .collection("pendingBlockList")
            .orderBy("timestamp", descending: true)
            .startAfterDocument(documentList[documentList.length - 1])
            .limit(20)
            .getDocuments())
        .documents;
  }

  @override
  Stream<QuerySnapshot> itemListStream() {
    return _db
        .collection("pendingBlockList")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

 Future<UserProfileModel> getUserProfile(uid)async{
   DocumentSnapshot snapshot= await _db.collection('users').document(uid).get();
   return UserProfileModel.fromDocumentSnap(snapshot);
  }
  Stream<DocumentSnapshot>getBlockDetailDocument(docid){
  return _db.collection('pendingBlockList').document(docid).snapshots();
  }

  Stream<DocumentSnapshot>thisUserAlreadyBlockedOrNot(uid){
    return _db.collection('blockList').document(uid).snapshots();
  }
 Future addUserAsBlock(uid){
    return _db.collection('blockList').document(uid).setData({
      'block_id':uid
    });
  }
}
