import 'package:cue_bar/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List tables = ['1'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            tables.add('1');
          });
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Cue Bar and Billiards',
          fontSize: 18,
          fontFamily: 'Bold',
          color: Colors.white,
        ),
      ),
      body: GridView.builder(
        itemCount: tables.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/pool-table.png',
                  height: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextWidget(
                  text: 'Table #${index + 1}',
                  fontFamily: 'Bold',
                  fontSize: 18,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
