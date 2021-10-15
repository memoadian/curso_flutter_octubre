import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
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
                validator:
                    RequiredValidator(errorText: "error campo necesario"),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  icon: Icon(Icons.book),
                  hintText: "Descripcion",
                  labelText: "Descripcion",
                ),
              ),
              TextFormField(
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
                  child: DropdownButton(
                    hint: Text("$_selectedType"),
                    isExpanded: true,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                    items: _types
                        .map(
                          (v) => DropdownMenuItem(
                            value: v,
                            child: Text(v),
                          ),
                        )
                        .toList(),
                  )),
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
    _formKey.currentState?.validate();
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
      final _pickedFile = await _picker.pickImage(source: source);
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
