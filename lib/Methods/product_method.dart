// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:shoes_business/Methods/image_pick.dart';

ImagePick controller = Get.put(ImagePick());
final cloudinary = CloudinaryPublic('duoqdpodl', 'Mudi_upload');
final _firestore = FirebaseFirestore.instance;

class ProductMethod {
  static Future<void> addProduct(
    BuildContext context,
    String categoryId,
  ) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController brandController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController stockController = TextEditingController();
    final sizes = <int>[6, 7, 8, 9, 10];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Add Product",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 8, 174, 14),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  return controller.image.isNotEmpty
                      ? Image.file(File(controller.image.value), height: 120)
                      : Image.network(
                        "https://cdni.iconscout.com/illustration/premium/thumb/product-is-empty-illustration-download-in-svg-png-gif-file-formats--no-records-list-record-emply-data-user-interface-pack-design-development-illustrations-6430781.png",
                        height: 120,
                      );
                }),
                const SizedBox(height: 10),
                Obx(() {
                  return TextButton(
                    onPressed: controller.pickImage,
                    child: Text(
                      controller.image.isNotEmpty
                          ? "Change Image"
                          : "Select Image",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 108, 4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Product Name"),
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
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Stock"),
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
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 8, 174, 14),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final brand = brandController.text.trim();
                final weight = weightController.text.trim();
                final priceText = priceController.text.trim();
                final stockText = stockController.text.trim();

                if (name.isEmpty ||
                    brand.isEmpty ||
                    weight.isEmpty ||
                    priceText.isEmpty ||
                    stockText.isEmpty ||
                    controller.image.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please fill all fields and select an image",
                      ),
                    ),
                  );
                  return;
                }

                try {
                  final double price = double.parse(priceText);
                  final int stock = int.parse(stockText);

                  await addProductDetails(
                    context,
                    categoryId,
                    name,
                    brand,
                    weight,
                    price,
                    stock,
                    sizes,
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Invalid input: $e")));
                }
              },
              child: const Text(
                "Add",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 8, 174, 14),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> addProductDetails(
    BuildContext context,
    String categoryId,
    String name,
    String brand,
    String weight,
    double price,
    int stock,
    List<int> sizes,
  ) async {
    try {
      final imagePath = controller.image.value;
      final imageUrl = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imagePath,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      final productId = const Uuid().v4();

      await _firestore
          .collection('Product_Category')
          .doc(categoryId)
          .collection('Products')
          .doc(productId)
          .set({
            'id': productId,
            'name': name,
            'brand': brand,
            'weight': weight,
            'price': price,
            'stock': stock,
            'sizes': sizes,
            'imageUrl': imageUrl.secureUrl,
            'timestamp': FieldValue.serverTimestamp(),
          });

      controller.image.value = '';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product added successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    }
  }
}
