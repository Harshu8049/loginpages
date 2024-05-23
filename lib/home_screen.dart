import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:loginpages/list_datagenratore.dart';
import 'package:loginpages/login_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.appTitle, required this.data});
  final String? appTitle;
  final List<dynamic> data;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var texteditingcontroller = TextEditingController();

    var last = widget.appTitle!.indexOf('@');
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const LogininScreen());
              },
              icon: const Icon(Icons.logout)),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    height: Get.height - 50,
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2.0, color: Colors.black)),
                          child: TextFormField(
                            controller: texteditingcontroller,
                            onChanged: (value) {
                              texteditingcontroller.text = value;
                            },
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                widget.data.add(texteditingcontroller.text);
                              });
                            
                              Get.close(1);
                            },
                            child: const Text("Save"))
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text('Welcome '),
            Text(
              widget.appTitle!.substring(0, last).toUpperCase(),
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [ListDataGenratore(data: widget.data)],
        ),
      ),
    );
  }
}
