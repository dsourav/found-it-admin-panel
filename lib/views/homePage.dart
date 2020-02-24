import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:found_it_admin_panel/bloc/blockedUserListBloc.dart';
import 'package:found_it_admin_panel/constant/colors.dart';
import 'package:found_it_admin_panel/model/pendingBlockRequestmodel.dart';
import 'package:found_it_admin_panel/model/userProfile.dart';
import 'package:found_it_admin_panel/provider/loginProvider.dart';
import 'package:found_it_admin_panel/repository/apiRepo.dart';
import 'package:found_it_admin_panel/views/shareAbleWidget.dart/commonShareWidget.dart';
import 'package:provider/provider.dart';

import 'blockDetailPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();
  ApiRepo apiRepo;
  BlockedUserListBloc blockedUserListBloc;
  List<PendingBlockRequestedModel> _list;
  @override
  void initState() {
    blockedUserListBloc = BlockedUserListBloc();
    blockedUserListBloc.fetchFirstList();
    controller.addListener(_scrollListener);
    blockedUserListBloc.listentChangeofData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.redColor,
        title: Text('Dashboard'),
        actions: <Widget>[logout()],
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: blockedUserListBloc.itemStream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            _list = snapshot.data
                .map((e) => PendingBlockRequestedModel.fromDocumentSnapshot(e))
                .toList();
            return ListView.builder(
                itemCount: _list.length,
                controller: controller,
                itemBuilder: (context, index) {
                  var data = _list[index];
                  return Card(
                    elevation: 8.0,
                    child: Container(
                     // height: 140.0,
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        //                       child: Table(

                        //   children: [
                        //     // TableRow(children: [
                        //     // textWidget("Request",1),
                        //     // textWidget(data.text,3),
                        //     //   ]),
                        //     TableRow(children: [
                        //       textWidget("Reported By:",1),
                        //        getUserName(data.claimId)
                        //     ]),
                        //     // TableRow(children: [
                        //     //   textWidget("Report Of:",1),
                        //     //    getUserName(data.blockId)
                        //     // ])
                        //   ],
                        // ),
                        child: Wrap(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                textWidget("Report:\t\t", 1),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: textWidget(data.text, 3),
                                ),
                                               FlatButton(
                                  onPressed: (){

                                  },
                                   child: Text("view chat",style: TextStyle(color: AppColor.redColor)))
                              ],
                            ),
                          
                            Row(
                              children: <Widget>[
                                textWidget("Reported By:", 1),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: getUserName(data.claimId),
                                ),
                                FlatButton(
                                  onPressed: (){

                                  },
                                   child: Text("block",style: TextStyle(color: AppColor.redColor)))
                              ],
                            ),
                             SizedBox(height: 8.0),
                            Row(
                              children: <Widget>[
                                 textWidget("Report Of:",1 ),
                                 SizedBox(width: 24.0),
                                Expanded(
                                  child: getUserName(data.blockId),
                                ),
                                  FlatButton(
                                  onPressed: (){
                                    
                                  },
                                   child: Text("block",style: TextStyle(color: AppColor.redColor),))
                              ],
                            ),
                           
                          ],
                        ),
                        onTap: () {
                          CommonShareWidget.goToAnotherPage(
                              nextPage: BlockDetailPage(data.docId),
                              context: context);
                        },
                      ),
                    ),
                  );
                });
          }
          return CommonShareWidget.showLoader();
        },
      ),
    );
  }

  textWidget(text, maxline) {
    return Text(
      text,
      softWrap: true,
      style: TextStyle(fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
    );
  }

  logout() {
    return IconButton(
        icon: Icon(Icons.exit_to_app),
        onPressed: () {
          Provider.of<AuthService>(context, listen: false).logout();
          //     .logout()
        });
  }

  getUserName(uid) {
    apiRepo = ApiRepo();

    return FutureBuilder<UserProfileModel>(
        future: apiRepo.getUserProfile(uid),
        builder: (context, info) {
          return info.data == null
              ? Text("Loading...")
              : Row(
                  children: <Widget>[
                    CommonShareWidget.imageNetwork(
                        shape: CircleBorder(),
                        height: 60.0,
                        width: 60.0,
                        imageurl: info.data.profilephotoImageUrl),
                   SizedBox(width: 8.0),
                    Text(
                      info.data.name,
                      maxLines: 1,
                      
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
        });
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      blockedUserListBloc.fetchNextList();
    }
  }
}
