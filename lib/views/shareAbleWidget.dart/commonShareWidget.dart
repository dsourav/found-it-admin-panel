import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:found_it_admin_panel/constant/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
class CommonShareWidget{
 

 static Widget signInUpbutton(title,VoidCallback callback,context ){
    return RaisedButton(onPressed: callback,
    child: SizedBox(
      width: MediaQuery.of(context).size.width/3,
      child: Center(child: Text(title)),
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
    textColor: AppColor.whiteColor,
    color: AppColor.redColor,
    );

  }

  static Widget flatTextButtonLogInUp(title,buttonText,VoidCallback callback ){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title,style: TextStyle(color: AppColor.blackColor),),
       SizedBox(width: 5.0,),
        InkWell(
          
          onTap: callback, child:  Text(buttonText,style: TextStyle(color: AppColor.blackColor,fontWeight: FontWeight.bold),))
      ],
    );
  }




   static  showFlushBar({String title,String message,@required context,@required duration}){
    Flushbar(
                  title: title,
                  message:  message,
                  duration:  Duration(seconds: duration),   
                  backgroundColor: AppColor.redColor,
                             
                )..show(context);

  }

 static Widget showLoader(){
   return SpinKitPulse(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                );
              },
            );

  }
static  Future buildErrorDialog(BuildContext context, _message) {
   FocusScope.of(context).requestFocus(new FocusNode());
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Error Message'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }

  static Widget imageNetwork({imageurl, height, width, borderadius,elevationCard,shape}) {

    return Container(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(borderadius ?? 0.0),
        child: Card(
           shape:shape,
     clipBehavior: Clip.antiAlias,
          elevation: elevationCard??0.0,
                  child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: imageurl,
            placeholder: (_, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled: true,
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white),
            ),
            errorWidget: (context, url, error) => Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }

 static  String timeAgo(serverTimeStamp) {
    final currentTime = DateTime.now();
    Timestamp timestamp = serverTimeStamp;
    final difference = timestamp != null
        ? currentTime.difference(timestamp.toDate())
        : Duration(minutes: 1);

    return timeago.format(currentTime.subtract(difference)) ?? "";
  }


 static goToAnotherPage({@required Widget nextPage,@required  context}){
  Navigator.of(context).push(MaterialPageRoute(
    builder: (BuildContext context) =>nextPage

  ));
}
}