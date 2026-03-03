import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_controller.dart';
import '../../domain/entities/order_entity.dart';

class ManageOrdersView extends GetView<AdminController> {
  const ManageOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Orders'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return const Center(child: Text('No active orders right now.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ExpansionTile(
                title: Text('Order \${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    '\${order.items.length} items • \$\${order.total.toStringAsFixed(2)}'),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE25F38).withAlpha(30),
                  child:
                      const Icon(Icons.receipt_long, color: Color(0xFFE25F38)),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Customer Info',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        const SizedBox(height: 5),
                        Text(
                            'Address: \${order.address ?? "No Address provided"}'),
                        const SizedBox(height: 15),
                        const Text('Items',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        ...order.items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child:
                                  Text('\${item.quantity}× \${item.food.name}'),
                            )),
                        const SizedBox(height: 20),
                        const Text('Update Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          children: OrderStatus.values.map((status) {
                            final isCurrent = order.status == status;
                            return ChoiceChip(
                              label: Text(status.name.toUpperCase()),
                              selected: isCurrent,
                              selectedColor: const Color(0xFFE25F38),
                              labelStyle: TextStyle(
                                  color: isCurrent
                                      ? Colors.white
                                      : Colors.black87),
                              onSelected: (selected) {
                                if (selected && !isCurrent) {
                                  controller.updateOrderStatus(
                                      order.id, status);
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
