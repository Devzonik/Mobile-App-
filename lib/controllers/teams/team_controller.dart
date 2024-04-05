import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:grow_x/controllers/auth/signup_controller.dart';
import 'package:grow_x/controllers/home/home_controller.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';

class TeamsController extends GetxController {
  RxInt userCount = 0.obs;
  RxDouble totalAmont = 0.0.obs;
  RxDouble totalCommissionForLevel2Users = 0.0.obs;
  RxDouble totalCommissionForLevel3Users = 0.0.obs;
  final HomeController controller = Get.find<HomeController>();
  // Function to get the number of users with the same referrer code
  Future<void> getUserCountWithReferrerCode() async {
    try {
      String? currentUserReferralLink = controller.referralLink.value;

      // Perform a query on the UserCollection to count users with the given referrer code
      QuerySnapshot querySnapshot = await users2Collection
          .where('referrerCode', isEqualTo: currentUserReferralLink)
          .get();

      // Update the userCount variable with the count of documents in the query result
      userCount.value = querySnapshot.size;
    } catch (e) {
      log("Error getting user count: $e");
    }
  }

  // Function to accumulate deposit amounts for users matching the current user's referral link
  Future<void> accumulateDepositAmounts() async {
    try {
      String currentUserReferralLink = controller.referralLink.value;

      // Query documents in the deposit collection where the user ID matches the referrer code
      QuerySnapshot usersSnapshot = await users2Collection
          .where('referrerCode', isEqualTo: currentUserReferralLink)
          .get();

      // Accumulator variable for summing deposit amounts

      // Iterate through documents in the deposit collection and sum deposit amounts
      // Iterate through matched users
      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        // Get the user ID
        String userId = userDoc.id;

        // Query documents in the deposit collection where the user ID matches
        QuerySnapshot depositSnapshot =
            await userPlansCollection.where('uid', isEqualTo: userId).get();

        // Iterate through documents in the deposit collection and sum deposit amounts
        depositSnapshot.docs.forEach((doc) {
          // Assuming the deposit amount is stored in a field called 'amount'
          double depositAmountString = doc['amount'] ?? 0.0;

          // Parse the deposit amount string to a double
          //   double depositAmount = double.tryParse(depositAmountString) ?? 0.0;

          totalAmont.value += depositAmountString;
          //  log($totalAmont);
        });
        for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
          // Get the user ID
          String userId = FirebaseAuth.instance.currentUser!.uid;

          // Query documents in the deposit collection where the user ID matches
          QuerySnapshot depositSnapshot =
              await userPlansCollection.where('uid', isEqualTo: userId).get();
          log(userId);
          // Iterate through documents in the deposit collection and sum deposit amounts
          depositSnapshot.docs.forEach((doc) {
            // Assuming the deposit amount is stored in a field called 'amount'
            double depositAmountString = doc['amount'] ?? 0.0;
            //  log(depositAmountString);
            //   // Parse the deposit amount string to a double
            //    double depositAmount = double.tryParse(depositAmountString) ?? 0.0;

            totalAmont.value += depositAmountString;
          });
        }
      }

      log('Total deposit amount for users with current user\'s referral link: ${totalAmont}');
    } catch (e) {
      log("Error accumulating deposit amounts: $e");
    }
  }

  Future<void> accumulateCommissionForLevel2Users() async {
    try {
      String currentUserReferralLink = controller.referralLink.value;

      // Query documents in the users2Collection where the referrerCode matches the current user's referral link and the user level is 2
      QuerySnapshot usersSnapshot = await users2Collection
          .where('referrerCode', isEqualTo: currentUserReferralLink)
          .where('level', isEqualTo: 2)
          .get();

      // Accumulator variable for summing commission amounts

      // Iterate through matched users with level 2

      // Check if the user document has a commissionList field (doc.data() as Map<String, dynamic>).containsKey('commissionList'))
      // Iterate through matched users with level 2
      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        // Explicitly cast userDoc.data() to Map<String, dynamic>
        final userData = userDoc.data() as Map<String, dynamic>;

        // Check if the user document has a commissionList field
        if (userData.containsKey('commissionList')) {
          List<dynamic> commissions = userData['commissionList'];

          // Calculate the total commission for the user
          double totalCommission = commissions.fold(0.0,
              (previousValue, element) => previousValue + (element as double));

          // Add the total commission to the accumulator variable
          totalCommissionForLevel2Users.value += totalCommission;
        }
      }

      log('Total commission for level 2 users: $totalCommissionForLevel2Users');
    } catch (e) {
      log("Error accumulating commission for level 2 users: $e");
    }
  }

  Future<void> accumulateCommissionForLevel3Users() async {
    try {
      String currentUserReferralLink = controller.referralLink.value;

      // Query documents in the users2Collection where the referrerCode matches the current user's referral link and the user level is 2
      QuerySnapshot usersSnapshot = await users2Collection
          .where('referrerCode', isEqualTo: currentUserReferralLink)
          .where('level', isEqualTo: 3)
          .get();

      // Accumulator variable for summing commission amounts

      // Iterate through matched users with level 2

      // Check if the user document has a commissionList field (doc.data() as Map<String, dynamic>).containsKey('commissionList'))
      // Iterate through matched users with level 2
      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        // Explicitly cast userDoc.data() to Map<String, dynamic>
        final userData = userDoc.data() as Map<String, dynamic>;

        // Check if the user document has a commissionList field
        if (userData.containsKey('commissionList')) {
          List<dynamic> commissions = userData['commissionList'];

          // Calculate the total commission for the user
          double totalCommission = commissions.fold(0.0,
              (previousValue, element) => previousValue + (element as double));

          // Add the total commission to the accumulator variable
          totalCommissionForLevel3Users.value += totalCommission;
        }
      }

      log('Total commission for level 2 users: $totalCommissionForLevel3Users');
    } catch (e) {
      log("Error accumulating commission for level 3 users: $e");
    }
  }
}
