
class DoctorProfile {
  final int id;
  final int doctorId;
  final String fullName;
  final String specialization;
  final String qualification;
  final String registrationNumber;
  final String clinicName;
  final String clinicAddress;
  final int consultationFee;
  final int experienceYears;
  final String? bio;
  final String? profileImageUrl;
  final bool isApproved;

  const DoctorProfile({
    required this.id,
    required this.doctorId,
    required this.fullName,
    required this.specialization,
    required this.qualification,
    required this.registrationNumber,
    required this.clinicName,
    required this.clinicAddress,
    required this.consultationFee,
    required this.experienceYears,
    this.bio,
    this.profileImageUrl,
    required this.isApproved,
  });

  factory DoctorProfile.fromJson(Map<String, dynamic> json) {
    return DoctorProfile(
      id: json['id'] as int,
      doctorId: json['doctor_id'] as int,
      fullName: json['full_name'] as String,
      specialization: json['specialization'] as String,
      qualification: json['qualification'] as String,
      registrationNumber: json['registration_number'] as String,
      clinicName: json['clinic_name'] as String,
      clinicAddress: json['clinic_address'] as String,
      consultationFee: json['consultation_fee'] as int,
      experienceYears: json['experience_years'] as int,
      bio: json['bio'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      isApproved: json['is_approved'] as bool,
    );
  }
}