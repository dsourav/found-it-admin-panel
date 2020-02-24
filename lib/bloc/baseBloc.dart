import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseBloc{
   Future fetchFirstList();
   fetchNextList() ;
   listentChangeofData();
    void onChangeData(
    List<DocumentChange> documentChanges,
  );
  updateIndicator(bool value) ;
  void dispose() ;
}