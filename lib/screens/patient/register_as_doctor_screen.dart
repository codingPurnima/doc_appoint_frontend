import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../theme/app_theme.dart';

/// Reusable doctor-profile form.
///
/// For creation, pass no [initialData]. For a future edit flow, pass the
/// existing profile in [initialData] and provide an update callback.
class RegisterAsDoctorScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Future<http.Response> Function(Map<String, dynamic> data) onSubmit;

  const RegisterAsDoctorScreen({
    super.key,
    this.initialData,
    required this.onSubmit,
  });

  @override
  State<RegisterAsDoctorScreen> createState() =>
      _DoctorProfileFormScreenState();
}

class _DoctorProfileFormScreenState extends State<RegisterAsDoctorScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _specializationController;
  late final TextEditingController _qualificationController;
  late final TextEditingController _registrationNumberController;
  late final TextEditingController _clinicNameController;
  late final TextEditingController _clinicAddressController;
  late final TextEditingController _consultationFeeController;
  late final TextEditingController _experienceController;
  late final TextEditingController _bioController;
  late final TextEditingController _imageUrlController;

  bool _isSubmitting = false;

  bool get _isEditing => widget.initialData != null;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData ?? {};

    _fullNameController =
        TextEditingController(text: data['full_name']?.toString() ?? '');
    _specializationController =
        TextEditingController(text: data['specialization']?.toString() ?? '');
    _qualificationController =
        TextEditingController(text: data['qualification']?.toString() ?? '');
    _registrationNumberController = TextEditingController(
      text: data['registration_number']?.toString() ?? '',
    );
    _clinicNameController =
        TextEditingController(text: data['clinic_name']?.toString() ?? '');
    _clinicAddressController =
        TextEditingController(text: data['clinic_address']?.toString() ?? '');
    _consultationFeeController = TextEditingController(
      text: data['consultation_fee']?.toString() ?? '',
    );
    _experienceController =
        TextEditingController(text: data['experience_years']?.toString() ?? '');
    _bioController = TextEditingController(text: data['bio']?.toString() ?? '');
    _imageUrlController = TextEditingController(
      text: data['profile_image_url']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _specializationController.dispose();
    _qualificationController.dispose();
    _registrationNumberController.dispose();
    _clinicNameController.dispose();
    _clinicAddressController.dispose();
    _consultationFeeController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  String? _requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  String? _positiveInteger(String? value, String label, {bool allowZero = true}) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    final number = int.tryParse(value.trim());
    if (number == null || number < (allowZero ? 0 : 1)) {
      return allowZero
          ? 'Enter a valid non-negative $label'
          : 'Enter a valid $label greater than zero';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = <String, dynamic>{
      'full_name': _fullNameController.text.trim(),
      'specialization': _specializationController.text.trim(),
      'qualification': _qualificationController.text.trim(),
      'registration_number': _registrationNumberController.text.trim(),
      'clinic_name': _clinicNameController.text.trim(),
      'clinic_address': _clinicAddressController.text.trim(),
      'consultation_fee': int.parse(_consultationFeeController.text.trim()),
      'experience_years': int.parse(_experienceController.text.trim()),
      'bio': _bioController.text.trim().isEmpty
          ? null
          : _bioController.text.trim(),
      'profile_image_url': _imageUrlController.text.trim().isEmpty
          ? null
          : _imageUrlController.text.trim(),
    };

    setState(() => _isSubmitting = true);

    try {
      final response = await widget.onSubmit(payload);
      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Doctor profile updated successfully.'
                  : 'Application submitted. Awaiting verification.',
            ),
          ),
        );
        Navigator.pop(context, true);
      } else {
        String message;
        if (response.statusCode == 409) {
          message =
              'An application already exists or this registration number is already in use.';
        } else if (response.statusCode == 422) {
          message = 'Please check the entered details and try again.';
        } else if (response.statusCode == 401) {
          message = 'Your session has expired. Please log in again.';
        } else {
          message =
              'Unable to submit application (${response.statusCode}). Please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Network error. Please check your connection and retry.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _field({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, size: 21),
          alignLabelWithHint: maxLines > 1,
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Doctor Profile' : 'Doctor Registration'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.availableBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.availableBorder),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.verified_user_outlined,
                        color: AppColors.availableText),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Submit your professional details for verification. '
                        'Your account will receive doctor access only after '
                        'manual approval.',
                        style: TextStyle(
                          color: AppColors.availableText,
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Professional Details',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              _field(
                label: 'Full name',
                hint: 'Name as per medical registration',
                controller: _fullNameController,
                icon: Icons.person_outline,
                validator: (v) => _requiredText(v, 'Full name'),
              ),
              _field(
                label: 'Specialization',
                hint: 'e.g. General Physician',
                controller: _specializationController,
                icon: Icons.medical_services_outlined,
                validator: (v) => _requiredText(v, 'Specialization'),
              ),
              _field(
                label: 'Qualification',
                hint: 'e.g. MBBS, MD',
                controller: _qualificationController,
                icon: Icons.school_outlined,
                validator: (v) => _requiredText(v, 'Qualification'),
              ),
              _field(
                label: 'Medical registration number',
                hint: 'Enter your registration number',
                controller: _registrationNumberController,
                icon: Icons.badge_outlined,
                validator: (v) => _requiredText(v, 'Registration number'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Clinic Details',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              _field(
                label: 'Clinic name',
                hint: 'Enter clinic or hospital name',
                controller: _clinicNameController,
                icon: Icons.local_hospital_outlined,
                validator: (v) => _requiredText(v, 'Clinic name'),
              ),
              _field(
                label: 'Clinic address',
                hint: 'Full clinic address',
                controller: _clinicAddressController,
                icon: Icons.location_on_outlined,
                validator: (v) => _requiredText(v, 'Clinic address'),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              const Text(
                'Consultation Information',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              _field(
                label: 'Consultation fee (₹)',
                hint: 'Enter fee in rupees',
                controller: _consultationFeeController,
                icon: Icons.currency_rupee,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    _positiveInteger(v, 'consultation fee', allowZero: false),
              ),
              _field(
                label: 'Years of experience',
                hint: 'Enter completed years',
                controller: _experienceController,
                icon: Icons.work_outline,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    _positiveInteger(v, 'experience', allowZero: true),
              ),
              _field(
                label: 'Professional bio (optional)',
                hint: 'Briefly describe your practice',
                controller: _bioController,
                icon: Icons.description_outlined,
                validator: (_) => null,
                maxLines: 4,
              ),
              _field(
                label: 'Profile image URL (optional)',
                hint: 'https://...',
                controller: _imageUrlController,
                icon: Icons.image_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return null;
                  final uri = Uri.tryParse(value.trim());
                  if (uri == null ||
                      !uri.hasScheme ||
                      (uri.scheme != 'http' && uri.scheme != 'https') ||
                      uri.host.isEmpty) {
                    return 'Enter a valid image URL';
                  }
                  return null;
                },
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(_isEditing ? 'Save Changes' : 'Submit Application'),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please ensure that all professional information is accurate. '
                'Your application will be reviewed before doctor access is enabled.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
