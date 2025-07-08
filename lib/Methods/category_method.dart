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

class CategoryMethod {
  /// Show dialog and handle form UI
  static Future<void> addCategory(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Add Category",
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
                  decoration: const InputDecoration(labelText: "Category Name"),
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
                String name = nameController.text.trim();
                String description = descriptionController.text.trim();
                if (name.isNotEmpty &&
                    description.isNotEmpty &&
                    controller.image.isNotEmpty) {
                  await addProductCategory(context, name, description);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill all fields and select an image',
                      ),
                    ),
                  );
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

  /// Upload image to Cloudinary and save category data to Firestore
  static Future<void> addProductCategory(
    BuildContext context,
    String name,
    String description,
  ) async {
    try {
      final String imagePath = controller.image.value;
      final String uniqueId = const Uuid().v4();

      // Upload to Cloudinary
      final imageUrl = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imagePath,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      // Save to Firestore under `categories`
      await _firestore.collection('Product_Category').doc(uniqueId).set({
        'id': uniqueId,
        'name': name,
        'description': description,
        'imageUrl': imageUrl.secureUrl,
      });

      controller.image.value = ''; // Clear selected image

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  /// Delete category by ID
  static Future<void> deleteProductCategory(String uniqueId) async {
    try {
      await _firestore.collection('categories').doc(uniqueId).delete();
    } catch (e) {
      debugPrint('Delete failed: $e');
    }
  }
}
