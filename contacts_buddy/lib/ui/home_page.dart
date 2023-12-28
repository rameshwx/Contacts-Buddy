import 'package:flutter/material.dart';
import 'contact_list_view.dart';

import 'add_contact.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts", style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddContact()));
        }, child: const Icon(Icons.add),),

      body: BuildContactsList(),
    );
  }
}

