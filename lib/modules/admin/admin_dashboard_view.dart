import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_controller.dart';
import '../../app/routes/app_routes.dart';

class AdminDashboardView extends GetView<AdminController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Admin Dashboard',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE25F38)));
        }

        final recentOrders = controller.orders.take(5).toList();

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Total Revenue',
                    value:
                        '\$${controller.orders.fold<double>(0, (prev, o) => prev + o.total).toStringAsFixed(2)}',
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _StatCard(
                    title: 'Total Orders',
                    value: '${controller.orders.length}',
                    icon: Icons.shopping_bag_outlined,
                    color: const Color(0xFFE25F38),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text('Quick Links',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    title: 'Manage Menu',
                    icon: Icons.restaurant_menu,
                    onTap: () => Get.toNamed(AppRoutes.adminMenu),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _ActionCard(
                    title: 'Live Orders',
                    icon: Icons.delivery_dining,
                    onTap: () => Get.toNamed(AppRoutes.adminOrders),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text('Recent Orders',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ...recentOrders.map((order) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  title: Text(order.id,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      '${order.items.length} items • \$${order.total.toStringAsFixed(2)}'),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE25F38).withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(order.status.name.toUpperCase(),
                        style: const TextStyle(
                            color: Color(0xFFE25F38),
                            fontWeight: FontWeight.bold,
                            fontSize: 10)),
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 15),
          Text(value,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 5),
          Text(title,
              style: const TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard(
      {required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withAlpha(40)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFE25F38).withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFE25F38), size: 30),
            ),
            const SizedBox(height: 15),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
