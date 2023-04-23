

class Item {
  String? id;
  String? name;
  String? quantity;

  Item({this.id, required this.name, required this.quantity});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['quantity'] = quantity;
    return data;
  }
}