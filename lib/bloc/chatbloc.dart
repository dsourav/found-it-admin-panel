import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:found_it_admin_panel/repository/chatRepo.dart';
import 'package:rxdart/rxdart.dart';

class ChatBLoc {
    bool showIndicator = false;
  BehaviorSubject<List<DocumentSnapshot>> chatMessageController;
   ChatRepo _chatRepo;
  List<DocumentSnapshot> documentList;
   BehaviorSubject<bool> showIndicatorController;

  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<DocumentSnapshot>> get itemStream => chatMessageController.stream;

   ChatBLoc() {
    _chatRepo=ChatRepo();
    showIndicatorController = BehaviorSubject<bool>();
    chatMessageController = BehaviorSubject<List<DocumentSnapshot>>();
  }
 

Future fetchFirstList(docId)async {
      try {
      documentList = await _chatRepo.fetchFirstList(docId);
    //  print(documentList);
      chatMessageController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          chatMessageController.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      chatMessageController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      chatMessageController.sink.addError(e);
    }
  }

  fetchNextList(docId) async{
       try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList =
          await _chatRepo.fetchNextList(documentList,docId);
      documentList.addAll(newDocumentList);
      chatMessageController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          chatMessageController.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      chatMessageController.sink.addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      chatMessageController.sink.addError(e);
    }
    
  }


  updateIndicator(bool value) {
     showIndicator = value;
    showIndicatorController.sink.add(value);
  }


  void dispose() {
   chatMessageController.close();
    showIndicatorController.close();
  }
}