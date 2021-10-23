import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mi_proyecto/main.dart';
import 'package:mi_proyecto/models_api/pet.dart';
import 'package:mi_proyecto/models_api/pet_key_value.dart';
import 'package:http/http.dart' as http;

class AddPetPage extends StatelessWidget {
  const AddPetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Añadir Mascota"),
      ),
      body: const FormAddPet(),
    );
  }
}

class FormAddPet extends StatefulWidget {
  const FormAddPet({Key? key}) : super(key: key);

  @override
  _FormAddPetState createState() => _FormAddPetState();
}

class _FormAddPetState extends State<FormAddPet> {
  List<String> _types = ["perrito", "gatito"];
  String? _selectedType = "Por favor escoge";
  bool _rescue = false;

  XFile? _imageFile;
  ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  GlobalKey<FormState> _formKey = GlobalKey();

  //Nuevas variables
  String _selectedTypeId = "1";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  final List<PetKeyValue> _data = [
    PetKeyValue(key: "Perrito", value: "1"),
    PetKeyValue(key: "Gatito", value: "2"),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                validator: MultiValidator([
                  RequiredValidator(
                    errorText: "Este campo es requerido",
                  ),
                  MinLengthValidator(
                    8,
                    errorText: "Este campo debe ser un correo",
                  ),
                ]),
                decoration: const InputDecoration(
                  icon: Icon(Icons.pets),
                  hintText: "Nombre",
                  labelText: "Nombre",
                ),
              ),
              TextFormField(
                controller: _descController,
                validator: RequiredValidator(
                  errorText: "error campo necesario",
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.book),
                  hintText: "Descripcion",
                  labelText: "Descripcion",
                ),
              ),
              TextFormField(
                controller: _ageController,
                validator: (v) => _validAge(v, "Edad no es numérica"),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  icon: Icon(Icons.date_range),
                  hintText: "Edad",
                  labelText: "Edad",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButton<PetKeyValue>(
                  hint: Text("$_selectedType"),
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!.key; //nombre
                      _selectedTypeId = value.value!; //id
                    });
                  },
                  items: _data
                      .map(
                        (v) => DropdownMenuItem(
                          value: v,
                          child: Text(v.key!),
                        ),
                      )
                      .toList(),
                ),
              ),
              SwitchListTile(
                title: const Text("¿Esta rescatado?"),
                value: _rescue,
                onChanged: (value) {
                  setState(() {
                    _rescue = value;
                  });
                },
              ),
              _chooseImage(context),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  onPressed: () => _validateForm(),
                  label: const Text("Enviar"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getImage() {
    if (_imageFile == null) return "";

    File _image = File(_imageFile!.path);
    String base64Image = base64Encode(_image.readAsBytesSync());
    return base64Image;
  }

  void showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text("Cargando..."),
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  createPost(String url, Map body) async {
    return http.post(Uri.parse(url), body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        Navigator.of(context).pop();
        throw Exception("Error while fetching data");
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyApp(),
        ),
      );
    });
  }

  String? _validAge(String? value, String message) {
    //validar edad
    String patttern = r'(^[0-9]+$)'; //usamos un regex para 2 digitos
    RegExp regExp = RegExp(patttern); //instanciamos la clase
    if (value!.isEmpty) {
      //validamos primero si no esun input vacío
      return message; //retornamos el mensaje personalizado
    } else if (!regExp.hasMatch(value)) {
      //validamos si el contenido hace match
      return 'La edad debe ser un número'; //retornamos mensaje por defecto
    } else {
      //si todo está bien
      return null; //retornamos null
    }
  }

  String? _validReq(String? v) {
    return (v!.isEmpty) ? "Este campo es obligatorio" : null;
  }

  void _validateForm() {
    showLoaderDialog(context);

    if (_formKey.currentState!.validate()) {
      Pet _newpet = Pet(
        name: _nameController.text,
        age: (_ageController.text != null) ? int.parse(_ageController.text) : 0,
        desc: _descController.text,
        typeId: int.parse(_selectedTypeId),
        image: _getImage(),
        statusId: _rescue ? 2 : 1,
      );

      createPost("https://pets.memoadian.com/api/pets", _newpet.toMap());
    } else {
      Navigator.pop(context);
    }
  }

  Widget _imageDefault() {
    return FutureBuilder<File>(
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: _imageFile == null
              ? const Text("Seleccionar imagen")
              : Image.file(
                  File(_imageFile!.path),
                  width: 300,
                  height: 150,
                ),
        );
      },
    );
  }

  void _pickImage(ImageSource source) async {
    try {
      final _pickedFile =
          await _picker.pickImage(source: source, imageQuality: 25);
      setState(() {
        _imageFile = _pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  Widget _chooseImage(BuildContext context) {
    return Center(
      child: Column(
        children: [
          _imageDefault(),
          ElevatedButton(
            onPressed: () {
              _pickImage(ImageSource.camera);
            },
            child: const Text("Escoger Imagen"),
          ),
        ],
      ),
    );
  }
}
