import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:found_it_admin_panel/bloc/chatbloc.dart';
import 'package:found_it_admin_panel/constant/colors.dart';
import 'package:found_it_admin_panel/model/chatModelMessage.dart';
import 'package:found_it_admin_panel/repository/chatRepo.dart';
import 'package:found_it_admin_panel/views/shareAbleWidget.dart/commonShareWidget.dart';


class ChatBoard extends StatefulWidget {
  final userId;
  final clientId;

  ChatBoard(this.userId, this.clientId);
  @override
  _ChatBoardState createState() => _ChatBoardState();
}

class _ChatBoardState extends State<ChatBoard> {
  String chatDocId;
  List<ChatModelMessage> chatDataModel;
  File imageFile;
  String imageUrl = '';
  bool _loaderState = false;
  ChatRepo _chatRepo;
  ScrollController controller = ScrollController();
  ChatBLoc _chatBloc;
  @override
  void initState() {
    _chatRepo = ChatRepo();
    
      setState(() {
        chatDocId = _chatRepo.chatMessageEndPoint(
            widget.userId, widget.clientId);
      });
    

   if(chatDocId!=null){
          _chatBloc = ChatBLoc();
    _chatBloc.fetchFirstList(chatDocId);
    controller.addListener(_scrollListener);

   }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return chatDocId != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.redColor,
              title: Text('chat'),
            ),
            body: StreamBuilder<List<DocumentSnapshot>>(
                                stream: _chatBloc.itemStream,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                    //  child: CommonShareWidget.showLoader(),
                                    );

                                  if (snapshot.data.isEmpty) {
                                    return Center(
                                        child: Text(
                                            'Start new conversation',
                                            style: TextStyle(
                                                
                                                fontSize: 20.0)));
                                  }

                                  chatDataModel = snapshot.data
                                      .map((doc) =>
                                          ChatModelMessage.fromDocumentSnap(
                                              doc))
                                      .toList();

                                  List<Widget> messages = chatDataModel
                                      .map((doc) => Message(
                                            text: doc.message,
                                            me: doc.senderId ==
                                                    widget.userId
                                                ? true
                                                : false,
                                            docType: doc.docId,
                                            documentReference:
                                                doc.documentReference,
                                          ))
                                      .toList();
                                  return ListView(
                                    reverse: true,
                                    controller: controller,
                                    children: messages,
                                  );
                                },
                              ),
          )
        : Scaffold(
            body: Center(
              child: CommonShareWidget.showLoader(),
            ),
          );
  }

 
 
 

   void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      _chatBloc.fetchNextList(chatDocId);
    }
  }
}

class Message extends StatelessWidget {
  final String text;
  final bool me;
  final int docType;
  final DocumentReference documentReference;
  Message(
      {@required this.text,
      @required this.me,
      @required this.docType,
      @required this.documentReference});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          docType == 1
              ? Container(
                  padding: EdgeInsets.all(5.0),
                  child: Material(
                      color: me ? Colors.blueAccent : Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(10.0),
                      elevation: 6.0,
                      child: Column(
                        children: <Widget>[
                          //  Text(from,style: TextStyle(color: Colors.white),),
                          // SizedBox(height: 5.0,),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Text(
                              text,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )))
              : Container(
                  padding: EdgeInsets.all(5.0),
                  child: FlatButton(
                    child: Material(
                      child: Hero(
                        tag: '$text',
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent),
                            ),
                            width: 200.0,
                            height: 200.0,
                            padding: EdgeInsets.all(70.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Material(
                            child: Icon(Icons.broken_image),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          imageUrl: text,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (text != null && text.length > 0) {
                      
                      }
                    },
                  )),
        ],
      ),
    );
  }
}
