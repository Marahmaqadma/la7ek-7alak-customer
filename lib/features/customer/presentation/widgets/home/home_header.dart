import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';

// هيدر الرئيسية: صورة المستخدم وتحيته، وزر بحث يفتح حقل كتابة داخل الهيدر.
// حالة فتح البحث ونص الحقل حالة واجهة فقط؛ النص يُرسل للخارج عبر onSearchChanged.
class HomeHeaderWidget extends StatefulWidget {
  final String userName;
  final String greeting;
  final ValueChanged<String> onSearchChanged;

  const HomeHeaderWidget({
    super.key,
    required this.userName,
    this.greeting = 'مسا الخير',
    required this.onSearchChanged,
  });

  @override
  State<HomeHeaderWidget> createState() => _HomeHeaderWidgetState();
}

class _HomeHeaderWidgetState extends State<HomeHeaderWidget> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _closeSearch() {
    setState(() => _isSearching = false);
    _searchController.clear();
    widget.onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.introNavy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 16.h),
          // ارتفاع أدنى وليس ثابتًا، حتى لا يقص الاسم والتحية على الشاشات القصيرة.
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 48.h),
            child: _isSearching ? _buildSearchField() : _buildGreetingRow(),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingRow() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22.r,
          backgroundColor: AppColors.orangeF58B1F,
          backgroundImage: const AssetImage('assets/images/icon_consumer.png'),
        ),
        SizedBox(width: 10.w),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userName,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              widget.greeting,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
          ],
        ),
        const Spacer(),
        // زر البحث داخل دائرة كما في التصميم.
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => setState(() => _isSearching = true),
            child: SizedBox(
              width: 36.w,
              height: 36.w,
              child: Icon(
                Icons.search,
                color: AppColors.introNavy,
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Center(
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(fontFamily: 'Tajawal', fontSize: 12.sp),
          onChanged: widget.onSearchChanged,
          decoration: InputDecoration(
            hintText: 'ابحث هنا...',
            hintStyle: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12.sp,
              color: Colors.grey,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10.h),
            prefixIcon: Icon(
              Icons.search,
              size: 18.sp,
              color: AppColors.introNavy,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.close, size: 18.sp, color: Colors.grey),
              onPressed: _closeSearch,
            ),
          ),
        ),
      ),
    );
  }
}
