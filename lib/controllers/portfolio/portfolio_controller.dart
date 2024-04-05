import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';

class PortfolioController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<DocumentSnapshot>> getUserPlans(String status) async {
    final User? user = _auth.currentUser;
    final uid = user!.uid;

    if (uid != null) {
      final QuerySnapshot userPlansQuery = await userPlansCollection
          .where('uid', isEqualTo: uid)
          .where('status', isEqualTo: status)
          .get();

      return userPlansQuery.docs;
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> getActiveUserPlans(String status) async {
    final userPlans = await getUserPlans(status);
    final activeUserPlans = <Map<String, dynamic>>[];

    for (final userPlan in userPlans) {
      final pid = userPlan['pid'];
      final planDetails = await getPlanDetails(pid);

      if (planDetails != null) {
        // Add additional attributes to the planDetails map
        planDetails['createdat'] = userPlan['createdat'];
        planDetails['amount'] = userPlan['amount'];
        planDetails['upid'] = userPlan['upid'];
        planDetails['status'] = userPlan['status'];
        activeUserPlans.add(planDetails);
      }
    }

    return activeUserPlans;
  }

  Future<Map<String, dynamic>?> getPlanDetails(String pid) async {
    final DocumentSnapshot planSnapshot = await plansCollection.doc(pid).get();

    return planSnapshot.data() as Map<String, dynamic>?;
  }

  Stream<List<Map<String, dynamic>>> getActiveUserPlansStream(String status) {
    return getUserPlansStream(status)
        .asyncMap((List<DocumentSnapshot<Object?>> userPlans) async {
      final activeUserPlans = <Map<String, dynamic>>[];

      for (final userPlan in userPlans) {
        final pid = userPlan['pid'];
        final planDetails = await getPlanDetails(pid);

        if (planDetails != null) {
          // Add additional attributes to the planDetails map
          planDetails['createdat'] = userPlan['createdat'];
          planDetails['amount'] = userPlan['amount'];
          planDetails['upid'] = userPlan['upid'];
          planDetails['status'] = userPlan['status'];
          activeUserPlans.add(planDetails);
        }
      }

      return activeUserPlans;
    });
  }

  Stream<List<DocumentSnapshot>> getUserPlansStream(String status) {
    final User? user = _auth.currentUser;
    final uid = user!.uid;

    if (uid != null) {
      return userPlansCollection
          .where('uid', isEqualTo: uid)
          .where('status', isEqualTo: status)
          .snapshots()
          .map((snapshot) => snapshot.docs);
    }

    return Stream.value([]);
  }

  Future<void> updatePlanStatus(String userPlanId, String newStatus) async {
    try {
      await userPlansCollection.doc(userPlanId).update({'status': newStatus});
      // You can add additional logic or error handling if needed
    } catch (e) {
      log('Error updating status: $e');
      // Handle the error accordingly
    }
  }
}
