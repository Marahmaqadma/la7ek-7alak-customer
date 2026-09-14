import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/store_profile_widgets/store_profile_header.dart';
import '../widgets/store_profile_widgets/store_profile_avatar.dart';
import '../widgets/store_profile_widgets/store_profile_form.dart';
import '../widgets/store_profile_widgets/store_status_toggle.dart';
import '../widgets/store_profile_widgets/store_save_button.dart';
import '../widgets/store_profile_widgets/store_bottom_nav_bar.dart';

class StoreProfilePage extends StatefulWidget {
  const StoreProfilePage({super.key});

  @override
  State<StoreProfilePage> createState() => _StoreProfilePageState();
}

class _StoreProfilePageState extends State<StoreProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: 'بيتزا البرنس');
  final TextEditingController _phoneController = TextEditingController(text: '+970 599 000 000');
  final TextEditingController _bioController = TextEditingController(text: 'أفخم أنواع البيتزا والوجبات السريعة بأفضل الأسعار...');

  String _selectedLocation = 'النصيرات';
  bool _isActive = true;
  int _currentIndex = 3; // تبويب البروفايل

  // لتخزين اسم المتجر الفعلي المعروض في الأعلى
  String _currentStoreTitle = 'بيتزا البرنس';

  // متغير تخزين الصورة المرفوعة
  File? _imageFile;

  // دالة لاختيار الصورة بالكاميرا أو المعرض وتحديث الـ State
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            const StoreProfileHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Column(
                    children: [
                      StoreProfileAvatar(
                        imageFile: _imageFile,
                        storeName: 'بيتزا البرنس',
                        storeAddress: 'النصيرات - الشارع العام',
                        onCameraTap: _pickImage,
                      ),
                      SizedBox(height: 14.h),
                      StoreProfileForm(
                        nameController: _nameController,
                        phoneController: _phoneController,
                        bioController: _bioController,
                        selectedLocation: _selectedLocation,
                        onLocationChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedLocation = value;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 6.h),
                      StoreStatusToggle(
                        isActive: _isActive,
                        onStatusChanged: (status) {
                          setState(() {
                            _isActive = status;
                          });
                        },
                      ),
                      SizedBox(height: 6.h),
                      StoreSaveButton(
                        onPressed: () {
                          setState(() {
                            _currentStoreTitle = _nameController.text.isEmpty ? 'المتجر' : _nameController.text;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
                          );
                        },
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),
            StoreBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}