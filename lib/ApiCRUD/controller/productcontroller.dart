import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:live_api_parctice/CardDataList/model/productModel.dart';

import '../utils/Urls.dart';

class ProductController{
  List <ProductModel>productList=[];

  Future<void> getProduct() async {
    final url=Uri.parse(Urls.readProduct);
    final response=await http.get(url);
    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);

      if (jsonResponse is List) {
        productList = jsonResponse.map((e) => ProductModel.fromJson(e)).toList();
      }
      else if (jsonResponse is Map) {
        final List<dynamic> data = jsonResponse['data'] ?? jsonResponse['products'] ?? [];
        productList = data.map((e) => ProductModel.fromJson(e)).toList();
      }
    }
  }

  Future<bool> deleteProduct(String productId) async {
    final url = Uri.parse(Urls.deleteProduct(productId));
    final response = await http.delete(url);

    if (response.statusCode == 200 || response.statusCode == 404) {
      await getProduct();
      return true;
    } else {
      print("Error deleting: ${response.statusCode}");
      return false;
    }
  }

  Future<bool>creatProduct(String title, String description) async {
    final url=Uri.parse(Urls.createProduct);
    final response=await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "title": title,
          "description": description,
        },)
    );
    if(response.statusCode==200 || response.statusCode==2001){
      getProduct();
      return true;
    }else{
      print('Error creating: ${response.statusCode}');
      return false;
    }
  }

  Future<bool>updateProduct(String productId, String title, String description) async {
    final url=Uri.parse(Urls.updateProduct(productId));
    final response=await http.put(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {
            "title": title,
            "description": description,
          },)
    );
    if(response.statusCode==200 || response.statusCode==2001){
      getProduct();
      return true;
    }else{
      print('Error creating: ${response.statusCode}');
      return false;
    }
  }
}
