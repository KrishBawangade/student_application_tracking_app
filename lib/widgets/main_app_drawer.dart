import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student_application_tracking_app/models/drawer_item_model.dart';
import 'package:student_application_tracking_app/models/student_data_model.dart';
import 'package:student_application_tracking_app/pages/login_page.dart';
import 'package:student_application_tracking_app/providers/student_data_provider.dart';
import 'package:student_application_tracking_app/providers/user_auth_provider.dart';
import 'package:student_application_tracking_app/utils/functions.dart';

class ActionItemModel {
  final String iconPath;
  final String title;

  ActionItemModel({required this.iconPath, required this.title});
}

class MainAppDrawer extends StatelessWidget {
  const MainAppDrawer({super.key});

String convertDateFormat(String dateStr, String inputFormat, String outputFormat) {
  try {
    DateTime parsedDate = DateFormat(inputFormat).parse(dateStr); // Parse input date
    String formattedDate = DateFormat(outputFormat).format(parsedDate); // Convert to new format
    return formattedDate;
  } catch (e) {
    return 'Invalid date format'; // Handle errors gracefully
  }
}

  @override
  Widget build(BuildContext context) {
    UserAuthProvider authProvider = Provider.of(context);
    StudentDataProvider studentDataProvider = Provider.of(context);
    StudentDataModel? studentData = studentDataProvider.studentData;
    List<DrawerItemModel> drawerItemList = [
      DrawerItemModel(
          title: "Log Out", icon: Icons.logout, onClick: (context) async{
            await authProvider.logoutUser(onSuccess: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
              AppFunctions.showDismissibleSnackBar(context, "Logged Out Successfully!");
            }, onError: (e){
              AppFunctions.showDismissibleSnackBar(context, e);
            });
            
          }),
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withAlpha(100)
                      ]),
                      ),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ListTile(
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            iconColor: Theme.of(context).colorScheme.onPrimary,
                            title: Text(studentData!.name.isEmpty?"N/A": studentData.name,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            leading: Icon(Icons.account_circle, size: 50),
                          )
                        ],
                      ),
                    )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Column(
                                  children: [
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: drawerItemList.length,
                                        itemBuilder: (context, index) {
                                          var drawerItem =
                                              drawerItemList[index];
                                          return ListTile(
                                              onTap: () {
                                                if (drawerItem.onClick !=
                                                    null) {
                                                  drawerItem.onClick!(context);
                                                } else {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              drawerItem
                                                                  .pageWidget!));
                                                }
                                              },
                                              title: Text(drawerItem.title),
                                              leading: Icon(drawerItem.icon));
                                        }),
                                    const SizedBox(height: 16),
                                  ],
                                )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
