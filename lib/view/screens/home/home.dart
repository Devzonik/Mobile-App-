import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:grow_x/config/routes/custom_route_widget.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/controllers/home/deposit_controller.dart';
import 'package:grow_x/controllers/home/home_controller.dart';
import 'package:grow_x/core/constants/firebase_collection_references.dart';
import 'package:grow_x/core/constants/instances_constants.dart';
import 'package:grow_x/core/utils/formatters/date_fromatter.dart';
import 'package:grow_x/core/utils/snackbars.dart';
import 'package:grow_x/generated/assets.dart';
import 'package:grow_x/models/user_models/user_model.dart';
import 'package:grow_x/view/screens/auth/login.dart';
import 'package:grow_x/view/screens/home/contactus.dart';
import 'package:grow_x/view/screens/home/deposit.dart';
import 'package:grow_x/view/screens/home/deposit_detials.dart';
import 'package:grow_x/view/screens/home/invest_now.dart';
import 'package:grow_x/view/screens/home/withdraw.dart';
import 'package:grow_x/view/screens/menu/menu.dart';
import 'package:grow_x/view/screens/menu/recharge_history.dart';
import 'package:grow_x/view/screens/menu/withdrawal_history.dart';
import 'package:grow_x/view/screens/portfolio/portfolio.dart';
import 'package:grow_x/view/widgets/common_image_view_widget.dart';
import 'package:grow_x/view/widgets/custom_expansion_tile.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:grow_x/view/widgets/plan_tile.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

RxDouble _totalDeposit = 0.0.obs;
RxDouble _totalInvested = 0.0.obs;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController controller = Get.find<HomeController>();

  final DepositController controller2 = Get.find<DepositController>();

  bool ispurchase = false;

  UserModel? currentuser;
  User? user = FirebaseAuth.instance.currentUser;
  AccumulatedAmountNotifier _amountNotifier = AccumulatedAmountNotifier();
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchAndDisplayTotalDeposit();
    controller.loadUsername();

    // Call the function in initState or where appropriate
  }

  Future<void> fetchAndDisplayTotalDeposit() async {
    try {
      double totalDeposit = await controller2.fetchTotalDeposit();
      double totalCurrentBalance = await controller2.fetchTotalCurrentBalance();
      // log(_totalDeposit);
      setState(() {
        _totalDeposit.value = totalDeposit - totalCurrentBalance;
        _totalInvested.value = totalCurrentBalance;
        _isLoading = false; // Set loading state to false after data is fetched
      });
      // log(_totalDeposit);
    } catch (e) {
      log('Error fetching and displaying total deposit: $e');
      setState(() {
        _isLoading = false; // Set loading state to false if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void refreshScreen() {
      fetchAndDisplayTotalDeposit();
      // Set state to trigger rebuild
      // Add logic here to refresh the screen (e.g., fetching new data)
      setState(() {});
    }

    double totalAmount = 0;
    double totalWithdrawal = 0;
    double totalclaimedinvested = 0;
    double totalbalance = 0;
    log("FirstScreen build");
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Scaffold(
                body: Stack(children: [
              CommonImageView(
                imagePath: Assets.imagesWaves,
                width: Get.width,
                height: Get.height,
                fit: BoxFit.cover,
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: AppSizes.DEFAULT_HORIZONTAL,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const ImageIcon(
                            AssetImage(Assets.imagesBlack),
                            color: kSecondaryColor,
                            size: 50,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacement(CustomPageRoute(
                                    page: const Menu(),
                                  ));
                                },
                                child: const ImageIcon(
                                  AssetImage(Assets.imagesSettings),
                                  color: kSecondaryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  FirebaseAuth.instance.signOut();
                                  Get.offAll(() => Login());
                                },
                                child: const ImageIcon(
                                  AssetImage(Assets.imagesLogout2),
                                  color: kSecondaryColor,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: AppSizes.DEFAULT_PADDING,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            decoration: rounded(kPrimaryColor),
                            child: Row(children: [
                              const Icon(
                                Icons.person,
                                size: 100,
                                color: kSecondaryColor,
                              ),
                              Expanded(
                                  child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: kSecondaryColor.withOpacity(0.3),
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                        topLeft: Radius.circular(30),
                                        bottomLeft: Radius.circular(30))),
                                child: ListTile(
                                  title: Obx(
                                    () => MyText(
                                      text: '${controller.username}',
                                      paddingLeft: 10,
                                      paddingTop: 10,
                                      fontFamily: AppFonts.PLAY,
                                      color: kBlack2Color,
                                      weight: FontWeight.bold,
                                      size: 12,
                                    ),
                                  ),
                                  subtitle: MyText(
                                      paddingLeft: 10,
                                      text: '${controller.joindate}'),
                                ),
                              ))
                            ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                stream: depositCollection
                                    .where('uid',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final documents = snapshot.data!.docs;
                                    for (final doc in documents) {
                                      final amountString =
                                          doc['amount'] as String;
                                      final amount =
                                          double.tryParse(amountString) ?? 0;
                                      if (doc['approved'] == 'approved') {
                                        totalAmount += amount;
                                      }
                                    }
                                    return StreamBuilder<QuerySnapshot>(
                                      stream: userPlansCollection
                                          .where('uid',
                                              isEqualTo: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .where('status', isEqualTo: 'claimed')
                                          .snapshots(),
                                      builder: (context, userplanSnapshot) {
                                        if (userplanSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (userplanSnapshot.hasError) {
                                          return Text(
                                              'Error: ${userplanSnapshot.error}');
                                        } else {
                                          final userplanDocuments =
                                              userplanSnapshot.data!.docs;
                                          double profitAmount = 0;
                                          for (final doc in userplanDocuments) {
                                            final profit = doc['profitamount']
                                                    as double? ??
                                                0;
                                            final amount =
                                                doc['amount'] as double? ?? 0;
                                            profitAmount += profit;
                                            totalclaimedinvested += amount;
                                            // log(totalclaimedinvested);
                                            // log(profitAmount);
                                            totalbalance = totalAmount +
                                                totalclaimedinvested +
                                                profitAmount -
                                                _totalInvested.value;
                                          }
                                          return balanceTile(
                                              'Balance',
                                              totalAmount +
                                                  totalclaimedinvested +
                                                  profitAmount -
                                                  _totalInvested.value, () {
                                            Navigator.of(context).push(
                                                CustomPageRoute(
                                                    page:
                                                        const RechargeHistory()));
                                          });
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Obx(
                                () => balanceTile(
                                    'Deposit', _totalInvested.value, () {
                                  Navigator.of(context).push(CustomPageRoute(
                                      page: Portfolio(
                                    hasback: true,
                                  )));
                                }),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: withdrawalRequestCollection
                                      .where('uid',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      final documents = snapshot.data!.docs;
                                      for (final doc in documents) {
                                        final amountString =
                                            doc['deductedamount'] as String;
                                        final amount =
                                            double.tryParse(amountString) ?? 0;
                                        if (doc['status'] == 'received') {
                                          totalWithdrawal += amount;
                                        }
                                      }
                                    }
                                    return balanceTile(
                                        'Withdrawal', totalWithdrawal, () {
                                      Navigator.of(context).push(
                                          CustomPageRoute(
                                              page: const ManageWithdrawals()));
                                    });
                                  })
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(CustomPageRoute(
                                              page: const DepositDetails()))
                                          .then((_) {
                                        // Callback to refresh screen after popping the investment screen
                                        refreshScreen();
                                      });
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: circle(
                                          kSecondaryColor, kPrimaryColor),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.add,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  MyText(
                                    text: 'Recharge',
                                    weight: FontWeight.bold,
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: userPlansCollection
                                      .where('uid',
                                          isEqualTo: FirebaseAuth
                                              .instance.currentUser!.uid)
                                      .where('status', isEqualTo: 'claimed')
                                      .snapshots(),
                                  builder: (context, userplanSnapshot) {
                                    if (userplanSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (userplanSnapshot.hasError) {
                                      return Text(
                                          'Error: ${userplanSnapshot.error}');
                                    } else {
                                      final userplanDocuments =
                                          userplanSnapshot.data!.docs;
                                      double profitAmount = 0;
                                      for (final doc in userplanDocuments) {
                                        final profit =
                                            doc['profitamount'] as double? ?? 0;
                                        final amount =
                                            doc['amount'] as double? ?? 0;
                                        profitAmount += profit;
                                        totalclaimedinvested += amount;
                                        // log(totalclaimedinvested);
                                        // log(profitAmount);
                                      }
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              //log(totalbalance);
                                              if (totalbalance == 0) {
                                                Navigator.of(context)
                                                    .push(CustomPageRoute(
                                                        page: Withdraw(
                                                      deposit: totalAmount -
                                                          _totalInvested.value,
                                                    )))
                                                    .then((value) =>
                                                        refreshScreen());
                                              } else {
                                                CustomSnackBars.instance
                                                    .showFailureSnackbar(
                                                        title: 'Withdraw error',
                                                        message:
                                                            'You need to invest all your balance to withdraw');
                                              }
                                            },
                                            child: Container(
                                              height: 50,
                                              decoration: circle(
                                                  kSecondaryColor,
                                                  kPrimaryColor),
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.download_rounded,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          MyText(
                                            text: 'Withdrawal',
                                            weight: FontWeight.bold,
                                          )
                                        ],
                                      );
                                    }
                                  }),
                              const SizedBox(
                                width: 16,
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          CustomPageRoute(page: ContactUs()));
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: circle(
                                          kSecondaryColor, kPrimaryColor),
                                      child: const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Center(
                                            child: ImageIcon(
                                              AssetImage(Assets.imagesContact),
                                              size: 20,
                                              color: kPrimaryColor,
                                            ),
                                          )),
                                    ),
                                  ),
                                  MyText(
                                    text: 'Contact Us',
                                    weight: FontWeight.bold,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: 'Packages',
                                size: 14,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<List<Map<String, dynamic>>>(
                      stream: Get.find<HomeController>().dataStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const Text('No data available.');
                        } else {
                          List<Map<String, dynamic>>? dataList = snapshot.data;

                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: dataList?.length ?? 0,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data = dataList![index];

                                  // Create a widget to display each item in the list
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: AppSizes.DEFAULT_PADDING,
                                        child: PlanTile(
                                          ontap: () async {
                                            // Fetch user's invested plans data
                                            List<Map<String, dynamic>>?
                                                dataListuserplans =
                                                await controller
                                                    .fetchInvestedPlansData();
                                            await _amountNotifier
                                                .calculateTotalAmount(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    data['pid']);

                                            // Access the updated _totalAmount after the calculation is completed
                                            double totalAmount2 =
                                                _amountNotifier.totalAmount;

                                            //  log(totalAmount);
                                            log("upper:$totalAmount2");
                                            List<String> limitParts =
                                                data['depositLimit'].split('-');
                                            double maxDepositLimit =
                                                double.parse(limitParts[1]);
                                            double minlimit =
                                                double.parse(limitParts[0]);
                                            log('lower limit:$minlimit');
                                            // Find the matching invested plan data
                                            for (Map<String,
                                                    dynamic> datauserplans
                                                in dataListuserplans!) {
                                              if (data['pid'] ==
                                                      datauserplans['pid'] &&
                                                  datauserplans['uid'] ==
                                                      FirebaseAuth.instance
                                                          .currentUser?.uid &&
                                                  datauserplans[
                                                          'purchasedStatus'] ==
                                                      true) {
                                                if (datauserplans[
                                                            'purchasedStatus'] ==
                                                        true &&
                                                    totalAmount2 >=
                                                        maxDepositLimit) {
                                                  // Show failure Snackbar if purchasedStatus is true
                                                  CustomSnackBars.instance
                                                      .showFailureSnackbar(
                                                    title: 'Disable',
                                                    message:
                                                        'Your deposit limit is over',
                                                  );
                                                  // Exit the loop since we found a match
                                                  return;
                                                } else {
                                                  dynamic profitValue =
                                                      data['profit'];
                                                  double profit = 0.0;

                                                  if (profitValue is int) {
                                                    profit = profitValue
                                                        .toDouble(); // Integer ko double mein convert kiya
                                                  } else if (profitValue
                                                      is double) {
                                                    profit =
                                                        profitValue; // Already double hai, seedha use kiya
                                                  } else {
                                                    // Koi aur type hai, handle accordingly
                                                  }

                                                  log(' maccccxx  : ${maxDepositLimit - totalAmount2}');
                                                  Navigator.of(context)
                                                      .push(CustomPageRoute(
                                                    page: InvestNow(
                                                      deposit: totalAmount -
                                                          _totalInvested.value,
                                                      days: data['days']
                                                          .toDouble(),
                                                      planName: data['name'],
                                                      profit: profit,
                                                      range:
                                                          data['depositLimit'],
                                                      pid: data['pid'],
                                                      upperlinmit:
                                                          maxDepositLimit -
                                                              totalAmount2,
                                                      lowerrange: minlimit,
                                                    ),
                                                  ))
                                                      .then((_) {
                                                    // Callback to refresh screen after popping the investment screen
                                                    refreshScreen();
                                                  }); // If purchasedStatus is false, navigate to InvestNow page

                                                  // No need to continue the loop after navigation
                                                  return;
                                                }
                                              }
                                            }
                                            dynamic profitValue =
                                                data['profit'];
                                            double profit = 0.0;

                                            if (profitValue is int) {
                                              profit = profitValue
                                                  .toDouble(); // Integer ko double mein convert kiya
                                            } else if (profitValue is double) {
                                              profit =
                                                  profitValue; // Already double hai, seedha use kiya
                                            } else {
                                              // Koi aur type hai, handle accordingly
                                            }
                                            //  log(totalAmount2);
                                            log(' maccccxx  : ${maxDepositLimit - totalAmount2}');

                                            Navigator.of(context)
                                                .push(CustomPageRoute(
                                              page: InvestNow(
                                                deposit: totalAmount -
                                                    _totalInvested.value,
                                                days: data['days'].toDouble(),
                                                planName: data['name'],
                                                profit: profit,
                                                range: data['depositLimit'],
                                                pid: data['pid'],
                                                upperlinmit: maxDepositLimit -
                                                    totalAmount2,
                                                lowerrange: minlimit,
                                              ),
                                            ))
                                                .then((_) {
                                              // Callback to refresh screen after popping the investment screen
                                              refreshScreen();
                                            }); // If
                                            // If the loop completes without finding a match, you can add a default action here
                                            // For example, show a failure Snackbar or log a message.
                                          },
                                          day: data['days'].toString(),
                                          depositlimit: data['depositLimit'],
                                          name: data['name'],
                                          profit: data['profit'].toString(),
                                        ),
                                      ),
                                      Padding(
                                        padding: AppSizes.DEFAULT_HORIZONTAL,
                                        child: StreamBuilder<
                                            List<Map<String, dynamic>>>(
                                          stream: controller
                                              .fetchInvestedPlansStream(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return const Text(
                                                  'No data available.');
                                            } else {
                                              int totalDocuments = 0;
                                              List<Map<String, dynamic>>
                                                  dataListuserplans =
                                                  snapshot.data!;

                                              return CustomExpansionTile(
                                                  title: 'Details',
                                                  body: [
                                                    SizedBox(
                                                      height: 100,
                                                      child: ListView.builder(
                                                        itemCount:
                                                            dataListuserplans
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          Map<String, dynamic>
                                                              datauserplans =
                                                              dataListuserplans[
                                                                  index];

                                                          // DateTime createdAt =
                                                          //     plan['createdat'].toDate();
                                                          // DateTime currentDate =
                                                          //     DateTime.now();
                                                          DateTime
                                                              subscriptionDate;

                                                          if (datauserplans[
                                                                  'createdat'] !=
                                                              null) {
                                                            subscriptionDate =
                                                                (datauserplans[
                                                                            'createdat']
                                                                        as Timestamp)
                                                                    .toDate();
                                                          } else {
                                                            subscriptionDate =
                                                                DateTime.now();
                                                          }

                                                          int daysDifference =
                                                              DateTime.now()
                                                                  .difference(
                                                                      subscriptionDate)
                                                                  .inDays;

                                                          double
                                                              progressPercentage =
                                                              daysDifference /
                                                                  data['days'];
                                                          progressPercentage =
                                                              progressPercentage
                                                                  .clamp(
                                                                      0.0, 1.0);

                                                          if (daysDifference <
                                                                  data[
                                                                      'days'] &&
                                                              data[
                                                                      'pid'] ==
                                                                  datauserplans[
                                                                      'pid'] &&
                                                              datauserplans[
                                                                      'uid'] ==
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser
                                                                      ?.uid &&
                                                              datauserplans['purchasedStatus'] ==
                                                                  true) {
                                                            // Conditions met, purchasedStatus remains true
                                                            return Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                  child:
                                                                      Container(
                                                                    height: 40,
                                                                    decoration:
                                                                        rounded(
                                                                            kGrey2Color),
                                                                    child:
                                                                        LinearPercentIndicator(
                                                                      percent:
                                                                          progressPercentage,
                                                                      lineHeight:
                                                                          10,
                                                                      barRadius:
                                                                          const Radius
                                                                              .circular(
                                                                              10),
                                                                      progressColor:
                                                                          kSecondaryColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          } else if (daysDifference >=
                                                                  data[
                                                                      'days'] &&
                                                              data[
                                                                      'pid'] ==
                                                                  datauserplans[
                                                                      'pid'] &&
                                                              datauserplans[
                                                                      'uid'] ==
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser
                                                                      ?.uid &&
                                                              datauserplans[
                                                                      'status'] ==
                                                                  'running') {
                                                            double calculateTotalProfit(
                                                                Map<String,
                                                                        dynamic>
                                                                    datauserplans) {
                                                              try {
                                                                double amount =
                                                                    datauserplans[
                                                                            'amount'] ??
                                                                        0; // Use amount from datauserplans
                                                                double profit =
                                                                    (amount *
                                                                        data[
                                                                            'profit'] /
                                                                        100);
                                                                return profit *
                                                                    data[
                                                                        'days'];
                                                              } catch (e) {
                                                                log('Error calculating total profit: $e');
                                                                return 0; // Return a default value if there's an error
                                                              }
                                                            }

                                                            double
                                                                newProfitAmount =
                                                                calculateTotalProfit(
                                                                    datauserplans);
                                                            userPlansCollection
                                                                .doc(
                                                                    datauserplans[
                                                                        'upid'])
                                                                .update({
                                                              'profitamount':
                                                                  newProfitAmount,
                                                            }).then((_) {
                                                              log('ProfitAmount updated successfully!');
                                                            }).catchError(
                                                                    (error) {
                                                              log('Error updating profitAmount: $error');
                                                            });
                                                            // Conditions met for setting purchasedStatus to false
                                                            userPlansCollection
                                                                .doc(
                                                                    datauserplans[
                                                                        'upid'])
                                                                .update({
                                                              'purchasedStatus':
                                                                  false,
                                                            });

                                                            userPlansCollection
                                                                .doc(
                                                                    datauserplans[
                                                                        'upid'])
                                                                .update({
                                                              'status':
                                                                  'completed',
                                                            });
                                                            return const SizedBox
                                                                .shrink();
                                                          } else {
                                                            // Default case, return an empty container
                                                            return const SizedBox
                                                                .shrink();
                                                          }
                                                        },
                                                      ),
                                                    )
                                                  ]);
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ])),
          );
  }

  Widget balanceTile(String title, double balance, VoidCallback ontap) {
    return Expanded(
        child: Container(
      height: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: kSecondaryColor.withOpacity(0.5)),
      child: Center(
        child: ListTile(
          onTap: ontap,
          contentPadding: const EdgeInsets.all(0),
          title: MyText(
            text: balance.toString(),
            textOverflow: TextOverflow.ellipsis,
            maxLines: 1,
            paddingBottom: 10,
            textAlign: TextAlign.center,
            size: 16,
            color: kPrimaryColor,
            weight: FontWeight.bold,
            fontFamily: AppFonts.PLAY,
          ),
          subtitle: MyText(
            text: title,
            color: kPrimaryColor,
            weight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}

class WaveContainer extends StatelessWidget {
  final double heightFactor;
  final Color color;

  const WaveContainer({required this.heightFactor, required this.color});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height * heightFactor,
        width: MediaQuery.of(context).size.width,
        color: color,
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height * 0.75)
      ..quadraticBezierTo(
        size.width / 4,
        size.height,
        size.width / 2,
        size.height * 0.85,
      )
      ..quadraticBezierTo(
        3 * size.width / 4,
        size.height / 2.4,
        size.width,
        size.height * 0.9,
      )
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class AccumulatedAmountNotifier {
  double _totalAmount = 0;
  int _totalDocs = 0;

  double get totalAmount => _totalAmount; // Getter method for total amount
  int get totalDocs =>
      _totalDocs; // Getter method for total number of documents

  // Add a method to listen for changes to _totalAmount
  StreamController<double> _amountStreamController = StreamController<double>();
  Stream<double> get amountStream => _amountStreamController.stream;

  Future<void> calculateTotalAmount(String currentUid, String pid) async {
    // Perform your logic to calculate the total amount
    // For example, fetch documents from Firestore and accumulate the amount
    QuerySnapshot querySnapshot = await userPlansCollection
        .where('uid', isEqualTo: currentUid)
        .where('pid', isEqualTo: pid)
        .where('status', isEqualTo: 'running')
        .get();

    _totalAmount = 0; // Reset total amount before accumulating
    _totalDocs = querySnapshot.size; // Get the total number of documents

    querySnapshot.docs.forEach((doc) {
      // Accumulate the amount from each document
      double amount = (doc['amount'] ?? 0).toDouble();
      _totalAmount += amount.abs();
    });
    // log totalAmount
    log('totalAmount: $_totalAmount');
    // Add the totalAmount to the stream
    _amountStreamController.add(_totalAmount);
  }

  void dispose() {
    _amountStreamController.close();
  }
}
