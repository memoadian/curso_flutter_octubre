import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Nombre",
                  labelText: "Nombre",
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Descripcion",
                  labelText: "Descripcion",
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Edad",
                  labelText: "Edad",
                ),
              ),
              DropdownButton(
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
              ),
              SwitchListTile(
                title: const Text("¿Esta rescatado?"),
                value: _rescue,
                onChanged: (value) {
                  setState(() {
                    _rescue = value;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
