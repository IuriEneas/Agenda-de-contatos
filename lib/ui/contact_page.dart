import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact? contact;
  // ignore: use_key_in_widget_constructors
  const ContactPage({this.contact});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  FocusNode? _nameFocus;

  Contact? _editedContact;

  // ignore: unused_field
  bool _userEdited = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact!.toMap());

      if (_editedContact!.name.toString() == "null") {
        _nameController.text = "";
      } else {
        _nameController.text = _editedContact!.name.toString();
      }

      if (_editedContact!.email.toString() == "null") {
        _emailController.text = "";
      } else {
        _emailController.text = _editedContact!.email.toString();
      }

      if (_editedContact!.phone.toString() == "null") {
        _phoneController.text = "";
      } else {
        _phoneController.text = _editedContact!.phone.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact!.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact!.name != null &&
                _editedContact!.name.toString().isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContact!.img != null
                          ? FileImage(
                              File(
                                _editedContact!.img.toString(),
                              ),
                            )
                          : const AssetImage("images/eukk.jpg")
                              as ImageProvider,
                    ),
                  ),
                ),
                onTap: () {
                  ImagePicker.platform
                      .pickImage(source: ImageSource.gallery)
                      .then((file) {
                    if (file == null) return;
                    setState(() {
                      _editedContact!.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                focusNode: _nameFocus,
                controller: _nameController,
                decoration: const InputDecoration(
                  label: Text("Nome"),
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact!.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  label: Text("Email"),
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact!.email = text;
                  });
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  label: Text("Phone"),
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact!.phone = text;
                  });
                },
                keyboardType: TextInputType.number,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Descartar alterações"),
            content: const Text("Se sair as alterações podem ser perdidadas"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Aceitar'),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
