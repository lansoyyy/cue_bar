import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/screens/config_page.dart';
import 'package:cue_bar/screens/new/create_customer_screen.dart';
import 'package:cue_bar/screens/new/items_pages/category_page.dart';
import 'package:cue_bar/screens/new/items_pages/items_page.dart';
import 'package:cue_bar/screens/products_screen.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/drawer_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final searchController = TextEditingController();
  String nameSearched = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Items',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 10, 50, 20),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ItemsPage()));
                  },
                  leading: SizedBox(
                    width: 300,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.list,
                          size: 40,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget(
                          text: 'Items',
                          fontSize: 24,
                          fontFamily: 'Bold',
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_sharp,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 10, 50, 20),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CategoryPage()));
                  },
                  leading: SizedBox(
                    width: 300,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.category,
                          size: 40,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        TextWidget(
                          text: 'Categories',
                          fontSize: 24,
                          fontFamily: 'Bold',
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right_sharp,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
