import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListDataGenratore extends StatelessWidget {
  const ListDataGenratore({super.key, required this.data});
  final List<dynamic> data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: Get.height - 10,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
              shape:
                  const OutlineInputBorder(borderSide: BorderSide(width: 0.10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data[index].toString().toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        "About User",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        height: 50,
                        width: 330,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 0.20)),
                        child: Text(data[index])),
                  ),
                  
                ],
              ));
        },
      ),
    );
  }
}
