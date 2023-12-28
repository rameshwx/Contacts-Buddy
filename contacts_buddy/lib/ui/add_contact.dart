import 'package:flutter/material.dart';
import 'package:contacts_buddy/controller/contact_controller.dart';
import 'package:contacts_buddy/database/contact_model.dart';
import 'package:contacts_buddy/database/database_helper.dart';
import 'package:contacts_buddy/ui/home_page.dart';
import 'package:get/get.dart';


class AddContact extends StatelessWidget {
  AddContact({Key? key}) : super(key: key);

  final GlobalKey<FormState> _key = GlobalKey();
  String? name;
  int? phone;
  String? email;

  final ContactController numberController = Get.put(ContactController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Contact"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              _buildTextFormField('Name', false),
              SizedBox(height: 10),
              _buildTextFormField('Phone Number', true, isNumeric: true),
              SizedBox(height: 10),
              _buildTextFormField('Email', false),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () => _saveNumber(context),
                child: Text('Save'),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, bool isRequired, {bool isNumeric = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      onSaved: (value) {
        switch (label) {
          case 'Name':
            name = value;
            break;
          case 'Phone Number':
            phone = value != null ? int.tryParse(value) : null;
            break;
          case 'Email':
            email = value;
            break;
          default:
            break;
        }
      },
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  void _saveNumber(BuildContext context) {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      var number = Contact(
        name: name,
        phoneNumber: phone,
        email: email,
      );
      numberController.addData(number);
      Get.find<ContactController>().onInit();
      Navigator.pop(context);
    }
  }

}

