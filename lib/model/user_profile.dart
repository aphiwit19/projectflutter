class UserProfile {
  final String name;
  final String phone;
  final String? gender;
  final String? bloodType;
  final String disease;
  final String allergy;

  UserProfile({
    required this.name,
    required this.phone,
    this.gender,
    this.bloodType,
    required this.disease,
    required this.allergy,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'gender': gender,
      'bloodType': bloodType,
      'disease': disease,
      'allergy': allergy,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'],
      bloodType: map['bloodType'],
      disease: map['disease'] ?? '',
      allergy: map['allergy'] ?? '',
    );
  }
}