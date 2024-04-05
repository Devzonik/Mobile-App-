import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/core/constants/instances_constants.dart';
import 'package:grow_x/models/user_models/user_model.dart';
import 'package:grow_x/services/firebase/firebase_crud.dart';

void getUserDataStream({required String userId}) {
  //getting user's data stream
  StreamSubscription<DocumentSnapshot<Object?>> userDataStream =
      FirebaseCRUDService.instance
          .getSingleDocStream(
              collectionReference: users2Collection, docId: userId)
          .listen((DocumentSnapshot<Object?> event) {
    userModelGlobal.value = UserModel.fromJson(event);

    log("Full name from model is: ${userModelGlobal.value.name}");
  });

  //you can cancel the stream if you wanna do
  // userDataStream.cancel();
}
