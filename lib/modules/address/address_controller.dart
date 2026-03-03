import 'package:get/get.dart';
import '../../domain/entities/address_entity.dart';

class AddressController extends GetxController {
  final addresses = <AddressEntity>[
    const AddressEntity(
      id: 'a1',
      label: 'Home',
      street: '42 Maple Street',
      city: 'Dhaka, Bangladesh',
      isDefault: true,
    ),
    const AddressEntity(
      id: 'a2',
      label: 'Work',
      street: '10 Gulshan Avenue',
      city: 'Dhaka, Bangladesh',
      isDefault: false,
    ),
  ].obs;

  Rx<AddressEntity?> get selectedAddress {
    final def = addresses.firstWhereOrNull((a) => a.isDefault);
    return (def ?? (addresses.isEmpty ? null : addresses.first)).obs;
  }

  AddressEntity? get defaultAddress =>
      addresses.firstWhereOrNull((a) => a.isDefault);

  void setDefault(String id) {
    for (int i = 0; i < addresses.length; i++) {
      addresses[i] = addresses[i].copyWith(isDefault: addresses[i].id == id);
    }
  }

  void addAddress(String label, String street, String city) {
    final newId = 'a${DateTime.now().millisecondsSinceEpoch}';
    final isFirst = addresses.isEmpty;
    addresses.add(AddressEntity(
      id: newId,
      label: label,
      street: street,
      city: city,
      isDefault: isFirst,
    ));
  }

  void deleteAddress(String id) {
    final wasDefault =
        addresses.firstWhereOrNull((a) => a.id == id)?.isDefault ?? false;
    addresses.removeWhere((a) => a.id == id);
    // If deleted was default, set first remaining as default
    if (wasDefault && addresses.isNotEmpty) {
      addresses[0] = addresses[0].copyWith(isDefault: true);
    }
  }
}
