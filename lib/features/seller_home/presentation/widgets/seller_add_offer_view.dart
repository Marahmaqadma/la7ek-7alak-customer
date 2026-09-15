import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';

// نموذج إضافة صورة وعنوان وتفاصيل لعرض جديد.
class SellerAddOfferView extends StatefulWidget {
  final String? imagePath;
  final VoidCallback onBack;
  final ValueChanged<ImageSource> onPickImage;
  final void Function({
    required String title,
    String? details,
  }) onPublish;

  const SellerAddOfferView({
    super.key,
    required this.imagePath,
    required this.onBack,
    required this.onPickImage,
    required this.onPublish,
  });

  @override
  State<SellerAddOfferView> createState() => _SellerAddOfferViewState();
}

// يجمع بيانات العرض ويتحقق من العنوان قبل تمرير طلب النشر.
class _SellerAddOfferViewState extends State<SellerAddOfferView> {
  final titleController = TextEditingController();
  final detailsController = TextEditingController();

  // يحرر متحكمات الحقول والموارد المستخدمة عند إغلاق الواجهة.
  @override
  void dispose() {
    titleController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AddOfferHeader(onBack: widget.onBack),
        SizedBox(height: 46.h),
        UploadOfferImageBox(
          imagePath: widget.imagePath,
          onTap: () => _showImageSourceSheet(context),
        ),
        SizedBox(height: 26.h),
        LabeledOfferTextField(
          label: 'عنوان العرض / الخصم *',
          hint: 'مثال: خصم 20% على طلبات العشاء',
          controller: titleController,
        ),
        SizedBox(height: 18.h),
        // خيارات المدة معروضة فقط؛ نموذج النشر الحالي لا يمرر مدة إلى مدير الحالة.
        const DurationSelector(),
        SizedBox(height: 18.h),
        LabeledOfferTextField(
          label: 'تفاصيل العرض (اختياري)',
          hint: 'اكتب تفاصيل إضافية أو الشروط...',
          controller: detailsController,
          height: 74,
          maxLines: 3,
        ),
        SizedBox(height: 26.h),
        PublishOfferButton(onTap: _publishOffer),
        SizedBox(height: 12.h),
        Text(
          'سيتم خصم 5 شيكل تلقائياً من رصيدك عند تأكيد النشر',
          style: TextStyle(
            color: AppColors.accentLight,
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // يرفض العنوان الفارغ ثم يمرر العنوان والتفاصيل إلى إجراء النشر.
  void _publishOffer() {
    final title = titleController.text.trim();

    // تنبيه المستخدم ومنع النشر عندما يكون العنوان فارغًا.
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اكتب عنوان العرض أولاً')),
      );
      return;
    }

    // تمرير بيانات النموذج إلى الصفحة التي تدير إضافة العرض.
    widget.onPublish(
      title: title,
      details: detailsController.text.trim(),
    );
  }

  // يفتح قائمة سفلية لاختيار الكاميرا أو معرض الصور.
  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImageSourceOption(
                  icon: Icons.photo_library_outlined,
                  title: 'اختيار من المعرض',
                  source: ImageSource.gallery,
                  onSelected: widget.onPickImage,
                ),
                ImageSourceOption(
                  icon: Icons.photo_camera_outlined,
                  title: 'فتح الكاميرا',
                  source: ImageSource.camera,
                  onSelected: widget.onPickImage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// عنوان إضافة العرض مع زر العودة إلى القائمة.
class _AddOfferHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _AddOfferHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButtonBox(onTap: onBack),
        const Spacer(),
        Text(
          'إضافة عرض جديد',
          style: TextStyle(
            color: AppColors.orange,
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const Spacer(),
        SizedBox(width: 36.w),
      ],
    );
  }
}

// مساحة لاختيار صورة العرض ومعاينتها.
class UploadOfferImageBox extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onTap;

  const UploadOfferImageBox({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pickedImage = imagePath == null ? null : File(imagePath!);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 138.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.accentLight, width: 1.5.w),
        ),
        child: pickedImage == null || !pickedImage.existsSync()
            ? const _UploadPlaceholder()
            : ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: Image.file(
                  pickedImage,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}

// رسالة وأيقونة تظهران قبل اختيار صورة العرض.
class _UploadPlaceholder extends StatelessWidget {
  const _UploadPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: AppColors.surfaceWarm,
          child: Icon(
            Icons.add_photo_alternate_outlined,
            color: AppColors.orange,
            size: 20.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'اضغط لرفع صورة العرض',
          style: TextStyle(
            color: AppColors.orange,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'يفضل أن تكون الصورة واضحة وبجودة عالية',
          style: TextStyle(
            color: AppColors.hint,
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
      ],
    );
  }
}

// خيار الكاميرا أو المعرض؛ يغلق القائمة ثم ينفذ الاختيار.
class ImageSourceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final ImageSource source;
  final ValueChanged<ImageSource> onSelected;

  const ImageSourceOption({
    super.key,
    required this.icon,
    required this.title,
    required this.source,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        onSelected(source);
      },
      leading: Icon(icon, color: AppColors.orange, size: 22.sp),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.darkBrown,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// حقل عرض بعنوان واضح ودعم النص متعدد الأسطر.
class LabeledOfferTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final double height;
  final int maxLines;

  const LabeledOfferTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.height = 43,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.darkBrown,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        SizedBox(height: 9.h),
        SizedBox(
          height: height.h,
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.mutedText,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 11.h,
              ),
              enabledBorder: _fieldBorder(),
              focusedBorder: _fieldBorder(color: AppColors.accentLight),
            ),
          ),
        ),
      ],
    );
  }

  // ينشئ حدود الحقل المستديرة بالتنسيق المشترك.
  OutlineInputBorder _fieldBorder({Color color = const Color(0xFFE1D7CC)}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: color),
    );
  }
}

// يعرض خيارات مدة العرض بصريًا؛ الاختيار غير موصول بالحالة حاليًا.
class DurationSelector extends StatelessWidget {
  const DurationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مدة صلاحية العرض *',
          style: TextStyle(
            color: AppColors.darkBrown,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            const Expanded(
              child: DurationChip(
                text: '24 ساعة (يوم كامل)',
                selected: true,
              ),
            ),
            SizedBox(width: 12.w),
            const Expanded(child: DurationChip(text: '12 ساعة فقط')),
          ],
        ),
      ],
    );
  }
}

// شكل خيار مدة العرض مع تمييز الخيار المحدد.
class DurationChip extends StatelessWidget {
  final String text;
  final bool selected;

  const DurationChip({
    super.key,
    required this.text,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFF1E9) : AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: selected ? AppColors.accentLight : const Color(0xFFE1D7CC),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? AppColors.orange : AppColors.hint,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// زر يمرر طلب نشر العرض إلى النموذج.
class PublishOfferButton extends StatelessWidget {
  final VoidCallback onTap;

  const PublishOfferButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 47.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkBrown,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'نشر العرض الآن',
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

// زر رجوع داخل إطار موحد.
class BackButtonBox extends StatelessWidget {
  final VoidCallback onTap;

  const BackButtonBox({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11.r),
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Icon(
          Icons.chevron_left,
          color: AppColors.darkBrown,
          size: 25.sp,
        ),
      ),
    );
  }
}
