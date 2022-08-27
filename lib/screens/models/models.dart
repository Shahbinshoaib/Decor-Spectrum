import 'package:flutter/material.dart';

class Customer{
   String invoice;
   String billTo;
   String address;
   String phone;
   String fax;
   String email;
   double subTotal;
   List<Product> product;


  Customer({required this.invoice, required this.billTo, required this.address, required this.phone, required this.fax,
  required this.email, required this.subTotal,required this.product});

}

class Product{
   String description;
   String sku;
   String color;
   double quantity;
   double unitPrice;
   double total;

  Product({required this.description, required this.sku, required this.color, required this.quantity, required this
      .unitPrice,required this.total});
}