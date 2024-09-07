import 'package:cue_bar/screens/config_page.dart';
import 'package:cue_bar/screens/home_screen.dart';
import 'package:cue_bar/screens/new/items_screen.dart';
import 'package:cue_bar/screens/new/receipts_screen.dart';
import 'package:cue_bar/screens/new/reports_screen.dart';
import 'package:cue_bar/screens/receipt_page.dart';
import 'package:flutter/material.dart';
import 'package:cue_bar/widgets/text_widget.dart';

import '../utlis/colors.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 250,
      color: Colors.black,
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: primary),
                      shape: BoxShape.circle,
                      color: Colors.white),
                  child: const Padding(
                    padding: EdgeInsets.all(2.5),
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                TextWidget(
                  text: 'POS 1',
                  fontFamily: 'Bold',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
              leading: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
              ),
              title: TextWidget(
                text: 'Sales',
                fontSize: 14,
                fontFamily: 'Bold',
                color: Colors.white,
              ),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ReceiptsScreen()));
              },
              leading: const Icon(
                Icons.receipt,
                color: Colors.white,
              ),
              title: TextWidget(
                text: 'Receipt',
                fontSize: 14,
                fontFamily: 'Bold',
                color: Colors.white,
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ReportScreen()));
              },
              leading: const Icon(
                Icons.report,
                color: Colors.white,
              ),
              title: TextWidget(
                text: 'Reports',
                fontSize: 14,
                fontFamily: 'Bold',
                color: Colors.white,
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ItemsScreen()));
              },
              leading: const Icon(
                Icons.list,
                color: Colors.white,
              ),
              title: TextWidget(
                text: 'Items',
                fontSize: 14,
                fontFamily: 'Bold',
                color: Colors.white,
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ConfigPage()));
              },
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: TextWidget(
                text: 'Settings',
                fontSize: 14,
                fontFamily: 'Bold',
                color: Colors.white,
              ),
            ),
            const Divider(),
          ],
        ),
      )),
    );
  }
}
