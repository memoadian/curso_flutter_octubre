class Pet {
  int id;
  String name;
  int age;
  String desc;
  String image;
  int typeId;
  String type;
  String status;
  int statusId;

  Pet({
    this.id = 0,
    this.name = "",
    this.age = 0,
    this.desc = "",
    this.image = "",
    this.typeId = 1,
    this.statusId = 1,
    this.status = "",
    this.type = "",
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      age: json['age'],
      image: json['image'] ?? 'logo_flutter.png',
      type: json['type']['name'],
      typeId: json['type']['id'],
      status: json['status']['name'],
      statusId: json['status']['id'],
    );
  }
}
