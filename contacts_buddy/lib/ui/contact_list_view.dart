import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contacts_buddy/controller/contact_controller.dart';
import 'package:contacts_buddy/database/contact_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'edit_contact.dart';


class BuildContactsList extends StatelessWidget {
  BuildContactsList({Key? key}) : super(key: key);

  final ContactController numberController = Get.put(ContactController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My Contacts'),
      //   backgroundColor: Colors.blue, // Example color
      // ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: numberController.filteredNumberList.length,
              itemBuilder: (context, index) {
                final contact = numberController.filteredNumberList[index];
                return _buildContactTile(context, contact);
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: searchController,
        onChanged: (value) => numberController.filterNumbers(value),
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildContactTile(BuildContext context, Contact contact) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue, // Example color
          child: Text(contact.name?.substring(0, 1).toUpperCase() ?? ''), // Safely access the first letter
        ),
        title: Text(contact.name ?? 'No Name'),
        subtitle: Text(contact.phoneNumber?.toString() ?? 'No Number'),
        children: [
          _buildActionButtons(context, contact),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, Contact contact) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue, // Example color
          child: Text(contact.name?.substring(0, 1).toUpperCase() ?? ''), // Safely access the first letter
        ),
        title: Text(contact.name ?? 'No Name'), // Fallback for null
        subtitle: Text(contact.phoneNumber?.toString() ?? 'No Number'), // Fallback for null
        trailing: _buildActionButtons(context, contact),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Contact contact) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.phone, color: Colors.green),
          onPressed: () {
            if (contact.phoneNumber != null) {
              launch('tel:${contact.phoneNumber}');
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.email_outlined, color: Colors.blue),
          onPressed: () {
            if (contact.email != null) {
              launch('mailto:${contact.email}');
            }
          },
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.orange),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditContactView(contact: contact),
              ),
            ).then((_) => numberController.onInit());
          },
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmAndDeleteContact(context, contact, numberController),
        ),
      ],
    );
  }



  void _confirmAndDeleteContact(BuildContext context, Contact contact, ContactController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Contact'),
          content: Text('Are you sure you want to delete this contact?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                controller.deleteContact(contact);
                Navigator.of(context).pop(); // Dismiss the dialog and delete the contact
              },
            ),
          ],
        );
      },
    );
  }


}
