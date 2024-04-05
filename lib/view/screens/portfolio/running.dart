import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grow_x/constants/app_colors.dart';
import 'package:grow_x/constants/app_fonts.dart';
import 'package:grow_x/constants/app_sizes.dart';
import 'package:grow_x/constants/app_styling.dart';
import 'package:grow_x/controllers/portfolio/portfolio_controller.dart';
import 'package:grow_x/view/widgets/my_text_widget.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Running extends StatefulWidget {
  const Running({super.key});

  @override
  State<Running> createState() => _RunningState();
}

class _RunningState extends State<Running> {
  final PortfolioController controller = Get.find<PortfolioController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: controller.getActiveUserPlansStream('running'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userPlans = snapshot.data;

          if (userPlans == null || userPlans.isEmpty) {
            return Padding(
              padding: AppSizes.DEFAULT_HORIZONTAL,
              child: Container(
                decoration: rounded(kPrimaryColor),
                height: 200,
                child: Center(
                  child: MyText(
                    text: 'No items found',
                    size: 18,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: userPlans.length,
            itemBuilder: (context, index) {
              final plan = userPlans[index];
              double profitperday = (plan['amount'] * plan['profit'] / 100);
              double totalprofit = plan['days'] * profitperday;

              DateTime createdAt = plan['createdat'].toDate();
              DateTime currentDate = DateTime.now();

              int daysDifference = currentDate.difference(createdAt).inDays;

              int daysLeftInPlan = plan['days'] - daysDifference;
              String formattedCreatedAt =
                  DateFormat("d-M-yyyy , h:mma").format(createdAt);
              daysLeftInPlan = daysLeftInPlan.clamp(0, plan['days']).toInt();
              double percentageLeft = daysDifference / plan['days'];
              double amountget = totalprofit;
              if (percentageLeft < 1.0) {
                // If percentageLeft is less than 100%
                amountget += plan[
                    'amount']; // Add the initial amount only if the plan is still active
              }
              percentageLeft = percentageLeft.clamp(0.0, 1.0);
              return Padding(
                padding: AppSizes.DEFAULT_PADDING,
                child: Container(
                    decoration: rounded(
                      kPrimaryColor,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                            top: 20,
                            right: 20,
                            child: MyText(
                              size: 30,
                              weight: FontWeight.bold,
                              fontFamily: AppFonts.PLAY,
                              text: '${(percentageLeft * 100).toInt()}%',
                            )),
                        Column(
                          children: [
                            MyText(
                              paddingTop: 10,
                              text: '${plan['name']} Plan',
                              size: 16,
                              weight: FontWeight.bold,
                            ),
                            Row(
                              children: [
                                MyText(
                                  text: 'Range: ${plan['depositLimit']}',
                                  paddingLeft: 20,
                                  paddingTop: 10,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                MyText(
                                  text: 'Number of days ${plan['days']}',
                                  paddingLeft: 20,
                                  paddingTop: 10,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                MyText(
                                  text:
                                      'Profit per day ${profitperday.toString()} ',
                                  paddingLeft: 20,
                                  paddingTop: 10,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                MyText(
                                  text:
                                      'Amount you gave ${plan['amount'].toStringAsFixed(0).toString()} ',
                                  paddingLeft: 20,
                                  paddingTop: 10,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                MyText(
                                  text:
                                      'Amount you will get ${amountget.toStringAsFixed(0).toString()} Rs',
                                  paddingLeft: 20,
                                  paddingTop: 10,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                MyText(
                                  text:
                                      'Days Left: ${daysLeftInPlan.toString()} ',
                                  paddingLeft: 20,
                                  paddingTop: 10,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: MyText(
                                    text:
                                        'Plan Subscription date:\n ${formattedCreatedAt} ',
                                    paddingBottom: 20,
                                    paddingLeft: 20,
                                    paddingTop: 10,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: rounded2(kYellowColor),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: MyText(
                                  weight: FontWeight.bold,
                                  text:
                                      'NOTE: You will be able to see progress change after every 24 hours',
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              );
            },
          );
        }
      },
    );
  }
}
