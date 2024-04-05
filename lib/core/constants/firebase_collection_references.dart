import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference usersCollection =
    FirebaseFirestore.instance.collection("User2");
CollectionReference users2Collection =
    FirebaseFirestore.instance.collection("User2");
CollectionReference plansCollection =
    FirebaseFirestore.instance.collection("Plans");
CollectionReference bankCollection =
    FirebaseFirestore.instance.collection("bank_details");
CollectionReference depositCollection =
    FirebaseFirestore.instance.collection("Deposits");
CollectionReference userPlansCollection =
    FirebaseFirestore.instance.collection("user_plans");

CollectionReference withdrawalRequestCollection =
    FirebaseFirestore.instance.collection("withdrawal_requests");
