import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_controller.dart';
import '../../app/routes/app_routes.dart';

class ManageMenuView extends GetView<AdminController> {
  const ManageMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Menu'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.foods.isEmpty) {
          return const Center(child: Text('No food items found. Add some!'));
        }

        return ListView.separated(
          itemCount: controller.foods.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final food = controller.foods[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  food.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported)),
                ),
              ),
              title: Text(food.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle:
                  Text('\$${food.price.toStringAsFixed(2)} • ${food.category}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFFE25F38)),
                onPressed: () {
                  // Pass food as argument
                  Get.toNamed(AppRoutes.adminAddFood, arguments: food);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(AppRoutes.adminAddFood);
        },
        backgroundColor: const Color(0xFFE25F38),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Food',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
