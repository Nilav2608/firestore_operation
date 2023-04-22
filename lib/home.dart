import 'package:firestore_operation/basket_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Item> basketItems = [];


 //!Initializing fetchRecords in initstate
  @override
  void initState() {
    fetchRecords();
    super.initState();
  }
  
  //* Fetching the records from the firestore database
  fetchRecords() async {
    var records = await FirebaseFirestore.instance.collection("basket").get();
    mapRecords(records);
  }


  //* fetched records are mapped and passed to a
  //* list and appending the list items to the main list
  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var _list = records.docs
        .map((item) =>
            Item(id: item.id, name: item['name'], quantity: item['quantity']))
        .toList();
    setState(() {
      basketItems = _list;
    });
  } 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
        itemCount: basketItems.length,
        itemBuilder: (context, index) {
          return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
                title: Text(basketItems[index].name ?? ''),
                subtitle: Text(basketItems[index].quantity ?? ''),
                tileColor: Colors.amber,
                
              ),
          );
          
        },
      )),
    );
  }
}
