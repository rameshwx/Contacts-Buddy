import 'package:get/get.dart';
import 'package:contacts_buddy/database/contact_model.dart';
import 'package:contacts_buddy/database/database_helper.dart';

class ContactController extends GetxController{

  var numberList = <Contact>[].obs;
  var filteredNumberList = <Contact>[].obs;


  @override
  void onInit() {


    _getData();
    super.onInit();
  }

  void _getData() async {
    var contacts = await DatabaseHelper.getAllContacts();
    numberList.assignAll(contacts.map((element) => Contact(
        id: element.id,
        name: element.name,
        phoneNumber: element.phoneNumber,
        email: element.email
    )).toList());
    filteredNumberList.assignAll(numberList);
  }


  void addData(Contact contact) async {
    DatabaseHelper.insertContact(contact.toMap());

    numberList.insert(0,
        Contact(id: numberList.length, phoneNumber: contact.phoneNumber, name: contact.name, email: contact.email));

  }

  void filterNumbers(String query) {
    if (query.isEmpty) {
      // If the search query is empty, show all contacts
      filteredNumberList.assignAll(numberList);
    } else {
      // Filter the list based on the query
      var filteredList = numberList.where((contact) {
        return contact.name!.toLowerCase().contains(query.toLowerCase()) ||
            contact.phoneNumber.toString().toLowerCase().contains(query.toLowerCase());
      }).toList();
      filteredNumberList.assignAll(filteredList);
    }
  }

  void deleteContact(Contact contact) async {
    await DatabaseHelper.deleteContact(contact.id!);
    _getData();
  }


}