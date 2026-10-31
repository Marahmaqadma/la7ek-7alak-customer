import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

const Color _reportRed = Color(0xFFDC0000);

// سبب بلاغ: [value] ما يُرسل للخادم، و[label] ما يراه الزبون.
typedef ReportReason = ({String value, String label});

// نافذة الإبلاغ: يختار الزبون سببًا ويرسل قيمته عبر onSubmit.
// السبب المختار حالة واجهة داخل النافذة فقط حتى الضغط على "إرسال البلاغ".
class ReportDialogWidget extends StatefulWidget {
  final String title;
  final List<ReportReason> reasons;
  final ValueChanged<String> onSubmit;

  const ReportDialogWidget({
    super.key,
    this.title = 'الإبلاغ عن عرض',
    // القيم التي يقبلها الخادم (allowedReasons في ads/:id/reports).
    this.reasons = const [
      (value: 'price_mismatch', label: 'السعر غير مطابق للمتجر'),
      (value: 'fake_or_expired', label: 'عرض وهمي / منتهي'),
      (value: 'inappropriate_content', label: 'محتوى غير مريح أو غير لائق'),
    ],
    required this.onSubmit,
  });

  @override
  State<ReportDialogWidget> createState() => _ReportDialogWidgetState();
}

class _ReportDialogWidgetState extends State<ReportDialogWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.introNavy,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'يرجى اختيار سبب البلاغ لإرساله فوراً للإدارة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 11.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20.h),
              for (var i = 0; i < widget.reasons.length; i++) ...[
                _buildOption(widget.reasons[i].label, i),
                SizedBox(height: 10.h),
              ],
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _reportRed,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onSubmit(widget.reasons[_selectedIndex].value);
                        },
                        child: Text(
                          'إرسال البلاغ',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 13.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: SizedBox(
                      height: 44.h,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          side: const BorderSide(color: AppColors.introNavy),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 13.sp,
                            color: AppColors.introNavy,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String text, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? _reportRed : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // زر اختيار دائري؛ المختار بنقطة حمراء داخله.
            Container(
              width: 18.w,
              height: 18.w,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _reportRed : Colors.grey,
                ),
              ),
              child: isSelected
                  ? const DecoratedBox(
                      decoration: BoxDecoration(
                        color: _reportRed,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12.sp,
                  color: AppColors.introNavy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
