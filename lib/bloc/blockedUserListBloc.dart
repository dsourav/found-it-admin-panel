import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:found_it_admin_panel/bloc/baseBloc.dart';
import 'package:found_it_admin_panel/repository/apiRepo.dart';
import 'package:rxdart/rxdart.dart';

class BlockedUserListBloc implements BaseBloc{
  BlockedUserListBloc(){
    apiRepo=ApiRepo();
       showIndicatorController = BehaviorSubject<bool>();
    itemController = BehaviorSubject<List<DocumentSnapshot>>();
  }
    ApiRepo apiRepo;
  bool showIndicator = false;
  List<DocumentSnapshot> documentList;

  BehaviorSubject<List<DocumentSnapshot>> itemController;

  BehaviorSubject<bool> showIndicatorController;

  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<DocumentSnapshot>> get itemStream => itemController.stream;

  @override
  Future fetchFirstList()async {
     try {
      documentList = await apiRepo.fetchFirstList();
    //  print(documentList);
      itemController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          itemController.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      itemController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      itemController.sink.addError(e);
    }
  }

  @override
  fetchNextList() async{
       try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList =
          await apiRepo.fetchNextList(documentList);
      documentList.addAll(newDocumentList);
      itemController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          itemController.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      itemController.sink.addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      itemController.sink.addError(e);
    }
  }

  @override
  listentChangeofData() {
  
   apiRepo.itemListStream()
        .listen((event) => onChangeData(event.documentChanges));
  }

  @override
  void onChangeData(List<DocumentChange> documentChanges) {
   var isChange = false;
    documentChanges.forEach((productChange) {
      if (productChange.type == DocumentChangeType.removed) {
        documentList.removeWhere((product) {
          return productChange.document.documentID == product.documentID;
        });
        isChange = true;
      } else if (productChange.type == DocumentChangeType.added) {
    
        if (documentList != null) {
          documentList..insert(productChange.newIndex, productChange.document);
          // _products[productChange.newIndex]=productChange.document;

        }
        isChange = true;
      } else {
        if (productChange.type == DocumentChangeType.modified) {
          int indexWhere = documentList.indexWhere((product) {
            return productChange.document.documentID == product.documentID;
          });

          if (indexWhere >= 0) {
            documentList[indexWhere] = productChange.document;
          }
          isChange = true;
        }
      }
    });

    if (isChange) {
      itemController.sink.add(documentList);
    }
  }

  @override
  updateIndicator(bool value) {
 showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  @override
  void dispose() {
      itemController.close();
    showIndicatorController.close();
  }
}