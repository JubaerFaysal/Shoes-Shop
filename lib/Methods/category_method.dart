// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoes_business/Methods/image_pick.dart';
import 'package:uuid/uuid.dart';


ImagePick controller = Get.put(ImagePick());
final cloudinary = CloudinaryPublic('duoqdpodl', 'Mudi_upload');
final _firestore = FirebaseFirestore.instance;

class CategoryMethod {
  static Future<void> addCategory(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    //dialog box to input product categori
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Category",
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
                 Obx(() {return TextButton(
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
                        const InputDecoration(labelText: "Category Name"),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
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
                    String description = descriptionController.text;
                    if (name.isNotEmpty && description.isNotEmpty) {
                      await addProductCategory(context, name, description);
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

  static Future<void> addProductCategory(
      BuildContext context, String name, String description) async {
    if (controller.image.isEmpty) return;

    try {
      // Generate a unique ID
      String uniqueId = const Uuid().v4();

      // Upload to Cloudinary
      final imageUrl = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(controller.image.toString(),
            resourceType: CloudinaryResourceType.Image),
      );

      // Store metadata in Firestore
      await _firestore.collection('Product_Category').doc(uniqueId).set({
        'id': uniqueId,
        'name': name,
        'description': description,
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

  //delete a product category
  static Future<void> deleteProductCateoriy(String uniqueId) async {
    await _firestore.collection('Product_Category').doc(uniqueId).delete();
  }
}
