import 'package:cloud_firestore/cloud_firestore.dart';

class UploadDermatologists {
  Future<bool> checkIfDermatologistsExist() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('dermatologists').get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> uploadDermatologists() async {
    CollectionReference dermatologists = FirebaseFirestore.instance.collection(
      'dermatologists',
    );

    List<Map<String, dynamic>> dermatologistData = [
      {
        'name': 'Dr. Muhammad Amjad',
        'address': 'Lahore, Pakistan',
        'website':
            'https://www.marham.pk/online-consultation/dermatologist/lahore/dr-muhammad-amjad-34503',
        'imageUrl': 'assets/images/dr-amjad.webp',
      },
      {
        'name': 'Dr. Umer Mushtaq',
        'address': 'Lahore, Pakistan',
        'website':
            'https://www.marham.pk/doctors/lahore/dermatologist/dr-umer-mushtaq',
        'imageUrl': 'assets/images/dr-umer-mushtaq.webp',
      },
      {
        'name': 'Dr. Aisha Ahmad',
        'address': 'Lahore, Pakistan',
        'website':
            'https://www.marham.pk/doctors/lahore/dermatologist/dr-aisha-ahmad',
        'imageUrl': 'assets/images/dr-aisha-ahmad-.webp',
      },
      {
        'name': 'Dr. Batool Rehman',
        'address': 'Karachi, Pakistan',
        'website':
            'https://www.marham.pk/online-consultation/dermatologist/karachi/dr-batool-rehman-41648',
        'imageUrl': 'assets/images/dr-batool-rehman.jpeg',
      },
      {
        'name': 'Dr. Zafar Ahmed',
        'address': 'Karachi, Pakistan',
        'website':
            'https://www.marham.pk/doctors/karachi/dermatologist/dr-zafar-ahmed',
        'imageUrl': 'assets/images/dr-zafar-ahmed.webp',
      },
      {
        'name': 'Dr. Sadaf Mushtaq',
        'address': 'Faisalabad, Pakistan',
        'website':
            'https://www.marham.pk/online-consultation/dermatologist/faisalabad/dr-sadaf-mushtaq-31544',
        'imageUrl': 'assets/images/dr-sadaf-mushtaq.webp',
      },
    ];

    for (var dermatologist in dermatologistData) {
      await dermatologists.add(dermatologist);
    }

    print('Dermatologists uploaded successfully!');
  }
}
