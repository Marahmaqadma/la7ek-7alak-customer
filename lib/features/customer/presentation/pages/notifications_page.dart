import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/routing/app_router.dart';
import 'package:la7ek_7alak/core/theme/app_colors.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';

import '../../domain/entities/app_notification.dart';
import '../cubit/notifications_cubit/notifications_cubit.dart';
import '../navigation/customer_tabs.dart';
import '../widgets/common/customer_page_header.dart';
import '../widgets/home/bottom_nav_bar.dart';
import '../widgets/notification/notification_card.dart';

// صفحة الإشعارات: تقرأ حالة NotificationsCubit وتزوّد NotificationsView بها.
// الـ cubit يُنشأ في الـ router (AppRouter.notifications).
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();

    // فتح الإشعار أو صورته: يصير مقروءًا ويفتح صفحة المتجر (فيها قصصه).
    void open(AppNotification notification) {
      cubit.markRead(notification);
      if (notification.storeId.isEmpty) return;
      Navigator.pushNamed(
        context,
        AppRouter.storeProfile,
        arguments: notification.storeId,
      );
    }

    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listenWhen: (_, curr) => curr.actionMessage != null,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.actionMessage!, textAlign: TextAlign.right),
        )),
      builder: (context, state) => NotificationsView(
        notifications: state.items,
        isLoading: state.status == NotificationsStatus.loading,
        errorMessage:
            state.status == NotificationsStatus.error ? state.error : null,
        onRetry: cubit.load,
        onNotificationTap: open,
        onStoryTap: open,
        onBellTap: cubit.toggleStoreNotifications,
        onNavTap: (index) =>
            openCustomerTab(context, index, current: CustomerTab.notifications),
      ),
    );
  }
}

// واجهة الإشعارات فقط: تعرض القائمة كما تصلها وتبلّغ عن التفاعلات.
class NotificationsView extends StatelessWidget {
  final List<AppNotification> notifications;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final ValueChanged<AppNotification> onNotificationTap;
  final ValueChanged<AppNotification> onStoryTap;
  final ValueChanged<AppNotification> onBellTap;
  final ValueChanged<int> onNavTap;

  const NotificationsView({
    super.key,
    required this.notifications,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    required this.onNotificationTap,
    required this.onStoryTap,
    required this.onBellTap,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            const CustomerPageHeader(title: 'الإشعارات والتنبيهات'),
            // السحب للأسفل يعيد تحميل القائمة.
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => onRetry?.call(),
                color: AppColors.orangeF58B1F,
                child: _buildContent(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBarWidget(
          currentIndex: CustomerTab.notifications,
          onTap: onNavTap,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!,
                textAlign: TextAlign.center, style: _messageStyle),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(
                  'إعادة المحاولة',
                  style: _messageStyle.copyWith(color: AppColors.introNavy),
                ),
              ),
          ],
        ),
      );
    }
    if (notifications.isEmpty) {
      return Center(
        child: Text('لا توجد إشعارات حالياً', style: _messageStyle),
      );
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 17.h, bottom: 15.h),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationItemCard(
          title: notification.title,
          body: notification.body,
          timeAgo: timeAgoArabic(notification.createdAt),
          imageUrl: notification.imageUrl,
          isRead: notification.isRead,
          hasUnviewedStory: notification.hasUnviewedStory,
          isStoreNotificationsOn: notification.isStoreNotificationsOn,
          onTap: () => onNotificationTap(notification),
          onStoryTap: () => onStoryTap(notification),
          onBellTap: () => onBellTap(notification),
        );
      },
    );
  }

  TextStyle get _messageStyle => TextStyle(
        fontFamily: 'Tajawal',
        color: AppColors.grey,
        fontSize: 14.sp,
      );
}
