import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:contacts_buddy/controller/contact_controller.dart';
import 'package:contacts_buddy/database/contact_model.dart';
import 'package:contacts_buddy/database/database_helper.dart';

class EditContactView extends StatelessWidget {
  final Contact contact;
  EditContactView({Key? key, required this.contact}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

  @override
  Widget build(BuildContext context) {
    nameController.text = contact.name ?? '';
    phoneNumberController.text = contact.phoneNumber.toString();
    emailController.text = contact.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact'),
        backgroundColor: Colors.deepPurple, // Example color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextFormField(nameController, 'Name', false),
              SizedBox(height: 10),
              _buildTextFormField(phoneNumberController, 'Phone Number', true),
              SizedBox(height: 10),
              _buildTextFormField(emailController, 'Email', false, isEmail: true),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () => _saveContact(context),
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField(TextEditingController controller, String label, bool isNumeric, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (isEmail) {
            // If it's the email field, allow empty values
            return null;
          }
          return 'Please enter $label';
        }
        // Additional validation for email format can be added here if needed
        return null;
      },
    );
  }


  void _saveContact(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      contact.name = nameController.text;
      contact.phoneNumber = int.tryParse(phoneNumberController.text);
      contact.email = emailController.text;

      DatabaseHelper.updateContact(contact.toMap(), contact.id!);
      Get.find<ContactController>().onInit();
      Navigator.pop(context);
    }
  }
}

