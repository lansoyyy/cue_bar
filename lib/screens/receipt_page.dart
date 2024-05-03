import 'package:cue_bar/widgets/button_widget.dart';
import 'package:cue_bar/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptScreen extends StatelessWidget {
  int timerate;
  int total;
  List items;

  ReceiptScreen(
      {super.key,
      required this.timerate,
      required this.total,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Receipt',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Receipt',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Bold',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Date: ${DateFormat.yMMMd().add_jm().format(DateTime.now())}',
              style: const TextStyle(
                  fontSize: 16, color: Colors.grey, fontFamily: 'Regular'),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Time rate:',
                    style: TextStyle(
                        fontSize: 24, color: Colors.black, fontFamily: 'Bold'),
                  ),
                  Text(
                    'P$timerate.00',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontFamily: 'Regular'),
                  ),
                ],
              ),
            ),
            const Text(
              'Items:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Bold',
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _buildItem(items[index]['name'], items[index]['price'],
                      items[index]['qty']);
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total: P$total.00',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Bold',
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: ButtonWidget(
                color: Colors.black,
                label: 'Print Receipt',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String name, int price, int qty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$name x $qty',
            style: TextStyle(
                fontSize: 16, color: Colors.grey[800], fontFamily: 'Regular'),
          ),
          Text(
            'P${price * qty}.00',
            style: TextStyle(
                fontSize: 16, color: Colors.grey[800], fontFamily: 'Regular'),
          ),
        ],
      ),
    );
  }
}
