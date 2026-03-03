import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/food_entity.dart';
import '../../data/datasources/firebase_food_datasource.dart';
import '../../data/datasources/firebase_storage_datasource.dart';
import 'package:image_picker/image_picker.dart';

class AddEditFoodController extends GetxController {
  final FirebaseFoodDatasource _foodDatasource = FirebaseFoodDatasource();
  final FirebaseStorageDatasource _storageDatasource =
      FirebaseStorageDatasource();

  final FoodEntity? editingFood = Get.arguments as FoodEntity?;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController =
      TextEditingController(); // Simple text input for now, ideally dropdown

  final selectedImageFile = Rx<File?>(null);
  final existingImageUrl = ''.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (editingFood != null) {
      nameController.text = editingFood!.name;
      priceController.text = editingFood!.price.toString();
      descriptionController.text = editingFood!.description;
      categoryController.text = editingFood!.category;
      existingImageUrl.value = editingFood!.imageUrl;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImageFile.value = File(pickedFile.path);
    }
  }

  Future<void> saveFood() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar('Error', 'Name and Price are required.');
      return;
    }

    isLoading.value = true;
    try {
      String imageUrl = existingImageUrl.value;

      // Upload new image if chosen
      if (selectedImageFile.value != null) {
        final fileName = 'food_\${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageUrl = await _storageDatasource.uploadFoodImage(
            selectedImageFile.value!, fileName);
      }

      // Generate random ID if new
      final id =
          editingFood?.id ?? 'FOOD_\${DateTime.now().millisecondsSinceEpoch}';

      final food = FoodEntity(
        id: id,
        name: nameController.text.trim(),
        category: categoryController.text.trim().isEmpty
            ? 'General'
            : categoryController.text.trim(),
        price: double.tryParse(priceController.text) ?? 0.0,
        rating: editingFood?.rating ?? 0.0,
        reviewCount: editingFood?.reviewCount ?? 0,
        imageUrl: imageUrl,
        description: descriptionController.text.trim(),
        isPopular: editingFood?.isPopular ?? false,
        calories: editingFood?.calories ?? 0,
        prepTimeMinutes: editingFood?.prepTimeMinutes ?? 15,
        isFavorite: editingFood?.isFavorite ?? false,
      );

      if (editingFood != null) {
        await _foodDatasource.updateFood(food);
      } else {
        await _foodDatasource.addFood(food);
      }

      Get.back();
      // Optionally reload admin controller foods
      Get.snackbar('Success', 'Food saved successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save food: \$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteFood() async {
    if (editingFood == null) return;

    isLoading.value = true;
    try {
      await _foodDatasource.deleteFood(editingFood!.id);
      if (existingImageUrl.value.isNotEmpty &&
          existingImageUrl.value.contains('firebasestorage')) {
        // Optional: await _storageDatasource.deleteFoodImage(existingImageUrl.value);
      }
      Get.back();
      Get.snackbar('Deleted', 'Food item removed.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete: \$e');
    } finally {
      isLoading.value = false;
    }
  }
}

class AddEditFoodView extends StatelessWidget {
  const AddEditFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    // Injecting controller locally for this view only
    final controller = Get.put(AddEditFoodController());

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.editingFood == null ? 'Add Food' : 'Edit Food'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          if (controller.editingFood != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                Get.defaultDialog(
                    title: 'Delete Food?',
                    middleText:
                        'Are you sure you want to permanently delete this item?',
                    textConfirm: 'Delete',
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () {
                      Get.back(); // close dialog
                      controller.deleteFood();
                    });
              },
            ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GestureDetector(
              onTap: controller.pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: Colors.grey.shade400, style: BorderStyle.solid),
                ),
                child: controller.selectedImageFile.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(controller.selectedImageFile.value!,
                            fit: BoxFit.cover),
                      )
                    : (controller.existingImageUrl.value.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                                controller.existingImageUrl.value,
                                fit: BoxFit.cover),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt,
                                  size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Tap to upload image',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          )),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                  labelText: 'Food Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller.priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                  labelText: 'Price', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller.categoryController,
              decoration: const InputDecoration(
                  labelText: 'Category (e.g. Burgers)',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controller.descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                  labelText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE25F38),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: controller.saveFood,
                child: const Text('Save Food',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      }),
    );
  }
}
