import 'dart:collection';

class Product {
  String id;
  String name;
  String description;
  String price;

  Product(this.id, this.name, this.description, this.price);

  Product.fromJson(dynamic jsonDynamic) {
    var jsonHashMap = LinkedHashMap.from(jsonDynamic);

    this.id = jsonHashMap["id"].toString();
    this.name = jsonHashMap["name"].toString();
    this.description = jsonHashMap["description"].toString();
    this.price = jsonHashMap["price"].toString();
  }
}
