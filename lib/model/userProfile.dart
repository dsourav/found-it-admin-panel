import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel{
  String name;
  String email;
  String phone;
  String address;
  String profilephotoImageUrl;
  String nidImageUrl;
  UserProfileModel({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.nidImageUrl,
    this.profilephotoImageUrl

  });
  UserProfileModel.fromDocumentSnap(DocumentSnapshot snapshot):
  name=snapshot.data['name']??"",
  email=snapshot.data['email']??"",
  phone=snapshot.data['phone']??"",
  address=snapshot.data['address']??"",
  profilephotoImageUrl=snapshot.data['profile_image_url']??"",
  nidImageUrl=snapshot.data['nid_image_url']??"";
 
 toJson(){
   return {
     "name":name,
     'email':email,
     'phone':phone,
     'address':address,
     'profile_image_url':profilephotoImageUrl,
     'nid_image_url':nidImageUrl

   };

 }

}