import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cue_bar/services/add_table.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductScreen extends StatefulWidget {
  int time;

  ProductScreen({
    super.key,
    required this.time,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    int total = widget.time * 5;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {});
        },
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Products',
          fontSize: 14,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
        actions: [
          TextWidget(
            text: 'Total: P$total.00',
            fontSize: 18,
            fontFamily: 'Bold',
            color: Colors.white,
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 110,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: 'Piattos',
                      fontSize: 15,
                      fontFamily: 'Medium',
                    ),
                    TextWidget(
                      text: 'P15.00',
                      fontSize: 18,
                      fontFamily: 'Bold',
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
