import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/seller_home_cubit.dart';
import 'seller_offer_card.dart';

// يجمع معلومات المتجر والإحصاءات وزر إضافة عرض والعروض النشطة.
class SellerHomeView extends StatelessWidget {
  final SellerHomeState state;
  final VoidCallback onAddOffer;

  const SellerHomeView({
    super.key,
    required this.state,
    required this.onAddOffer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SellerHeader(state: state),
        SizedBox(height: 24.h),
        SellerStats(state: state),
        SizedBox(height: 24.h),
        AddOfferButton(onTap: onAddOffer),
        SizedBox(height: 24.h),
        SellerActiveOffers(offers: state.offers),
      ],
    );
  }
}

// ترويسة تعرض اسم المتجر وموقعه وحالته.
class SellerHeader extends StatelessWidget {
  final SellerHomeState state;

  const SellerHeader({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.notifications_none,
            color: AppColors.darkBrown,
            size: 19.sp,
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              state.storeName,
              style: TextStyle(
                color: AppColors.darkBrown,
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              state.storeLocation,
              style: TextStyle(
                color: AppColors.accentLight,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
            SizedBox(height: 7.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.storeStatus,
                  style: TextStyle(
                    color: const Color(0xFF159947),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                SizedBox(width: 5.w),
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF159947),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 12.w),
        Container(
          width: 58.w,
          height: 58.w,
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.orange, width: 2.w),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

// يرتب أعداد المتابعين والعروض والمشاهدات.
class SellerStats extends StatelessWidget {
  final SellerHomeState state;

  const SellerStats({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SellerStatItem(
            value: state.followersCount,
            label: 'المتابعين',
            icon: Icons.group,
          ),
          const _VerticalDivider(),
          SellerStatItem(
            value: state.activeOffersCount,
            label: 'عروض نشطة',
            icon: Icons.local_fire_department,
            highlighted: true,
          ),
          const _VerticalDivider(),
          SellerStatItem(
            value: state.viewsCount,
            label: 'المشاهدات',
            icon: Icons.remove_red_eye,
          ),
        ],
      ),
    );
  }
}

// مربع إحصائي يعرض قيمة وعنوانًا وأيقونة.
class SellerStatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool highlighted;

  const SellerStatItem({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: highlighted ? AppColors.orange : AppColors.darkBrown,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: highlighted ? AppColors.orange : const Color(0xFF5B89A4),
                size: 10.sp,
              ),
              SizedBox(width: 3.w),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.hint,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// يفتح نموذج إضافة عرض من صفحة التاجر الرئيسية.
class AddOfferButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddOfferButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
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
          '+ إضافة عرض جديد (قصة)',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}

// يعرض بطاقات العروض أو رسالة القائمة الفارغة.
class SellerActiveOffers extends StatelessWidget {
  final List<SellerOffer> offers;

  const SellerActiveOffers({
    super.key,
    required this.offers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'العروض النشطة حالياً ⚡',
          style: TextStyle(
            color: AppColors.orange,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        SizedBox(height: 12.h),
        if (offers.isEmpty)
          const _NoOffersCard()
        else
          ...offers.map(
            (offer) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: SellerOfferCard(
                offer: offer,
                onDelete: () {
                  context.read<SellerHomeCubit>().deleteOffer(offer.id);
                },
              ),
            ),
          ),
      ],
    );
  }
}

// رسالة تظهر عندما لا توجد عروض في القائمة.
class _NoOffersCard extends StatelessWidget {
  const _NoOffersCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        'لا توجد عروض نشطة حالياً',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.hint,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

// فاصل بصري بين عناصر الإحصاءات.
class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.w,
      height: 30.h,
      color: const Color(0xFFEDE4DB),
    );
  }
}
