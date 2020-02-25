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

import 'chatBoard.dart';


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
                                      CommonShareWidget.goToAnotherPage(
                              nextPage: ChatBoard(data.claimId,data.blockId),
                              context: context);

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
                               StreamBuilder<DocumentSnapshot>(
                                   stream: apiRepo.thisUserAlreadyBlockedOrNot(data.claimId) ,
                builder: (BuildContext context,  snapshot){
                    if(!snapshot.hasData)return Text("...");
                                     if(snapshot.data.exists){
                                       return Text("Blocked",style: TextStyle(color: AppColor.redColor),);

                                     }else{
                                       return FlatButton(onPressed:  (){
                                         buildUpdateDialog(context: context,uid: data.claimId );
                                    
                                  }, child: Text("block",style: TextStyle(color: AppColor.redColor),));
                                     }
                                   },
                                 )
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
                                 
                                 
                                 StreamBuilder<DocumentSnapshot>(
                                   stream: apiRepo.thisUserAlreadyBlockedOrNot(data.blockId) ,
                builder: (BuildContext context,  snapshot){
                  if(!snapshot.hasData)return Text("...");
                                     if(snapshot.data.exists){
                                       return Text("Blocked",style: TextStyle(color: AppColor.redColor),);

                                     }else{
                                       return FlatButton(onPressed:  (){
                                         buildUpdateDialog(context: context,uid: data.blockId );
                                    
                                  }, child: Text("block",style: TextStyle(color: AppColor.redColor),));
                                     }
                                   },
                                 ),
                                 
                                  
                              ],
                            ),
                           
                          ],
                        ),
                        onTap: () {
                  
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



      Future buildUpdateDialog({BuildContext context,uid}) {
    FocusScope.of(context).requestFocus(new FocusNode());
    bool loaderstatus = false;
    return showDialog(
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialougeState) {
          return AlertDialog(
            title: Text(loaderstatus ? "Please wait..." : "Sure about blocking this User?"),
           
            actions: <Widget>[
              FlatButton(
                  child: Text('Yes'),
                  onPressed: loaderstatus
                      ? null
                      : () async{
                        setState(() {
                          loaderstatus=true;
                        });
                       await apiRepo.addUserAsBlock(uid);
                       Navigator.of(context).pop();
                          
                        }),
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: loaderstatus
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        })
            ],
          );
        });
      },
      context: context,
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
