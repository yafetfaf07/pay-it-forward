import 'package:client_donation/components/charity-card.dart';
import 'package:flutter/material.dart';

class Charity extends StatelessWidget {
  const Charity({super.key,});
  static const List<Map<String,dynamic>> data = [
    {
      "name":"Caleb Foundation",
      "phone":"+251943282803"
    },
     {
      "name":"Red Cross",
      "phone":"+251943282803"
    },
     {
      "name":"Amnesty International",
      "phone":"+251943282606"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(202, 115, 64, 255),
        title: Text("List of charity centers",style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: GridView.builder(
          
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2),
          scrollDirection: Axis.vertical,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return CharityCard(name:data[index]['name'], phone: data[index]['phone'],);
        })
      ),
    );
  }
}