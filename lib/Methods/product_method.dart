// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_business/Methods/image_pick.dart';

ImagePick controller = Get.put(ImagePick());
final cloudinary = CloudinaryPublic('duoqdpodl', 'Mudi_upload');
final _firestore = FirebaseFirestore.instance;

class ProductMethod {
  static Future<void> addProduct(BuildContext context, String uniqueId) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController brandController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    //dialog box to input product categori
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Products",
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 8, 174, 14))),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    return Image(
                        image: controller.image.isNotEmpty
                            ? FileImage(File(controller.image.toString()))
                            : const NetworkImage(
                                "https://cdni.iconscout.com/illustration/premium/thumb/product-is-empty-illustration-download-in-svg-png-gif-file-formats--no-records-list-record-emply-data-user-interface-pack-design-development-illustrations-6430781.png"));
                  }),
                   Obx(() { return
                  TextButton(
                      onPressed: controller.pickImage,
                      child: Text(
                        controller.image.isNotEmpty
                            ? "Change Image"
                            : "Select Image",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 108, 4),
                            fontWeight: FontWeight.bold),
                      ));}),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: "Products Name"),
                  ),
                  TextField(
                    controller: brandController,
                    decoration: const InputDecoration(labelText: "Brand"),
                  ),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Price"),
                  ),
                  TextField(
                    controller: weightController,
                    decoration: const InputDecoration(labelText: "Weight"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    controller.image.value = '';
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 8, 174, 14)))),
              TextButton(
                  onPressed: () async {
                    String name = nameController.text;
                    String brand = brandController.text;
                    String weight = weightController.text;
                    String price = priceController.text;
                    if (name.isNotEmpty &&
                        brand.isNotEmpty &&
                        weight.isNotEmpty &&
                        price.isNotEmpty) {
                      await addProductdetais(
                          context, name, brand, weight, price, uniqueId);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 8, 174, 14))))
            ],
          );
        });
  }

  static Future<void> addProductdetais(BuildContext context, String name,
      String brand, String weight, String price, String uniqueId) async {
    if (controller.image.isEmpty) return;

    try {
      // Upload to Cloudinary
      final imageUrl = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(controller.image.toString(),
            resourceType: CloudinaryResourceType.Image),
      );
      // Access the product-Category collection by ID
      final products = _firestore.collection('Product_Category').doc(uniqueId);

      // Store metadata in Firestore
      await products.collection('Products').add({
        'name': name,
        'brand': brand,
        'weight': weight,
        'price': price,
        'imageUrl': imageUrl.secureUrl, // URL from Cloudinary
      });
      controller.image.value = '';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload successful!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
