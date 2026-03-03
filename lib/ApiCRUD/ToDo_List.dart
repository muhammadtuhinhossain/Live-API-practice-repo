import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:live_api_parctice/CardDataList/controller/productcontroller.dart';

import 'model/productModel.dart';

class cardList extends StatefulWidget {
  const cardList({super.key});

  @override
  State<cardList> createState() => _cardListState();
}

class _cardListState extends State<cardList> {
  TextEditingController productTitleController=TextEditingController();
  TextEditingController productDescriptionController=TextEditingController();

  productDialog({ProductModel? product}){
    productTitleController.text = product?.title ?? '';
    productDescriptionController.text = product?.description ?? '';

    showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text(product == null ? 'Add Product' : 'Update Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: productTitleController,
            decoration: InputDecoration(labelText: 'Title'),),
          SizedBox(height: 10,),
          TextField(
            controller: productDescriptionController,
            decoration: InputDecoration(labelText: 'Description'),),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Cancel')),

              ElevatedButton(onPressed: () async {
               if (product == null) {
                 await productController.creatProduct(
                   productTitleController.text,
                   productDescriptionController.text,
                 );
               } else {
                 await productController.updateProduct(
                   product.id.toString(),
                   productTitleController.text,
                   productDescriptionController.text,
                 );
               }
               productTitleController.clear();
               productDescriptionController.clear();

               Navigator.pop(context);
                await fetchData();
              }, child: Text(product == null ? 'Submit' : 'Update')),
            ],
          )
        ],

      ),
    ));
  }

  ProductController productController=ProductController();
  bool isLoading = false;

  Future fetchData() async {
    setState(() {
      isLoading= true;
    });
    await productController.getProduct();
    setState(() {
      isLoading=false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : productController.productList.isEmpty
          ? Center(child: Text("No Data Found"))
          :ListView.builder(
          itemCount: productController.productList.length,
          itemBuilder: (context, index){
            final item=productController.productList[index];
            return Card(
              child: ListTile(
                title: Text(item.title.toString()),
                subtitle: Text(item.description.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: (){
                      productDialog(product: item);
                    }, icon: Icon(Icons.edit,color: Colors.green,)),
                    IconButton(onPressed: (){
                      productController.deleteProduct(item.id.toString()).then((value) {
                        if (value && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Delete successfully'))
                          );
                          setState(() {});
                        }
                      });
                    }, icon: Icon(Icons.delete,color: Colors.red,)),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(onPressed: (){
        productDialog();
      },child: Icon(Icons.add),),
    );
  }
}
