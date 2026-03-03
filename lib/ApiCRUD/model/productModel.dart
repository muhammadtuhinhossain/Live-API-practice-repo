class ProductModel {
  ProductModel({
    this.id,
    required this.title,
    required this.description,
    this.createdDate,
    this.v,
  });

  final String? id;
  final String? title;
  final String? description;
  final DateTime? createdDate;
  final int? v;

  factory ProductModel.fromJson(Map<String, dynamic> json){
    return ProductModel(
      id: json["_id"],
      title: json["title"],
      description: json["description"],
      createdDate: DateTime.tryParse(json["created_date"] ?? ""),
      v: json["__v"],
    );
  }

}
