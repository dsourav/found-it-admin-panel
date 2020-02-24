import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:found_it_admin_panel/constant/colors.dart';
import 'package:found_it_admin_panel/repository/apiRepo.dart';

class BlockDetailPage extends StatefulWidget {
  final String docId;
  BlockDetailPage(this.docId);
  @override
  _BlockDetailPageState createState() => _BlockDetailPageState();
}

class _BlockDetailPageState extends State<BlockDetailPage> {
  ApiRepo _apiRepo;
  @override
  void initState() {
    _apiRepo=ApiRepo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.redColor,
        title: Text('Details'),
      
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _apiRepo.getBlockDetailDocument(widget.docId) ,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(!snapshot.hasData)return Container();

          return Container(
            margin: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
              //  Text(data)

              ],),
            ),
          );
        },
      ),

      
    );
  }
}