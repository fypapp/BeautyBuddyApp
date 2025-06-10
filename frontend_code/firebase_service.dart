import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> uploadProducts(List<Map<String, dynamic>> products) async {
    try {
      for (var product in products) {
        await _db.collection('products').add(product);
      }
      print("All products uploaded successfully!");
    } catch (e) {
      print("Error uploading products: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchMatchingProducts({
    required String skinType,
    required String skinTone,
    required String acneSeverity,
  }) async {
    try {
      final productsRef = _db.collection('products');

      final querySnapshot =
          await productsRef
              .where('skin_type', isEqualTo: skinType)
              .where('skin_tone', isEqualTo: skinTone)
              .where('acne_compatible', isEqualTo: acneSeverity)
              .get();

      List<Map<String, dynamic>> products = [];
      for (var doc in querySnapshot.docs) {
        products.add(doc.data());
      }
      return products;
    } catch (e) {
      print("Error fetching matching products: $e");
      return [];
    }
  }
}
