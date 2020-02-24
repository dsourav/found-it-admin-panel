import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseRepo{
  Future<List<DocumentSnapshot>> fetchFirstList();
  Future<List<DocumentSnapshot>> fetchNextList(
      List<DocumentSnapshot> documentList) ;
 Stream<QuerySnapshot> itemListStream();

}