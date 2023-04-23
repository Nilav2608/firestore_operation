import 'package:firestore_operation/models/basket_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

const String collectionName = "basket";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Item> basketItems = [];

  //!Initializing the functions in app startup itself
  @override
  void initState() {
    //*initialising fetch records function
    fetchRecords();
    //* initializing the firestore instance in app starts
    FirebaseFirestore.instance
        .collection(collectionName)
        .snapshots()
        .listen((records) {
      mapRecords(records);
    });
    super.initState();
  }

  //* Fetching the records from the firestore database
  fetchRecords() async {
    var records =
        await FirebaseFirestore.instance.collection(collectionName).get();
    mapRecords(records);
  }

  //* fetched records are mapped and passed to a
  //* list and appending the list items to the basket list
  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var list = records.docs
        .map((item) =>
            Item(id: item.id, name: item['name'], quantity: item['quantity']))
        .toList();
    setState(() {
      basketItems = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("firestore operations"),
            actions: [
              IconButton(onPressed: addDialog, icon: const Icon(Icons.add))
            ],
          ),
          body: ListView.builder(
            itemCount: basketItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Slidable(
                  endActionPane:
                      ActionPane(motion: const DrawerMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        updateDialog(basketItems[index].id!);
                      },
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Update',
                      spacing: 8,
                    ),
                    SlidableAction(
                      onPressed: (context) =>
                          deleteItem(basketItems[index].id!),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                      spacing: 8,
                    ),
                  ]),
                  child: ListTile(
                    title: Text(basketItems[index].name ?? ''),
                    subtitle: Text(basketItems[index].quantity ?? ''),
                    // tileColor: Colors.amber,
                  ),
                ),
              );
            },
          )),
    );
  }

  addDialog() {
    var nameController = TextEditingController();
    var quantityController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                    ),
                    TextField(
                      controller: quantityController,
                    ),
                    TextButton(
                      onPressed: () {
                        var name = nameController.text.trim();
                        var quantity = quantityController.text.trim();
                        addItem(name, quantity);
                        Navigator.pop(context);
                      },
                      child: const Text("Add item"),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  updateDialog(String id) {
    var nameupdateController = TextEditingController();
    var quantityupdateController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameupdateController,
                    ),
                    TextField(
                      controller: quantityupdateController,
                    ),
                    TextButton(
                      onPressed: () {
                        var name = nameupdateController.text.trim();
                        var quantity = quantityupdateController.text.trim();

                        updateItem(id, name, quantity);
                        Navigator.pop(context);
                      },
                      child: const Text("update item"),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  addItem(String name, String quantity) {
    var item = Item(name: name, quantity: quantity);
    FirebaseFirestore.instance.collection(collectionName).add(item.toJson());
  }

  updateItem(String id, String name, String quantity) {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(id)
        .update({'name': name, 'quantity': quantity});
  }

  deleteItem(String id) {
    FirebaseFirestore.instance.collection(collectionName).doc(id).delete();
  }
}
