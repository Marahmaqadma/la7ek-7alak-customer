import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/store_story.dart';
import '../widgets/story/story_viewer.dart';
import 'package:la7ek_7alak/core/routing/app_router.dart';

// شاشة القصة: تعرض قصص متجر واحد وتحدد ماذا يحدث عند كل تفاعل.
// الإعجاب وتسجيل المشاهدة يحتاجان الـ API، لذا يُمرَّران كـ callbacks من الـ cubit.
class StoryScreen extends StatelessWidget {
  final StoreStory story;
  final ValueChanged<StoryItem>? onLikeTap;
  final ValueChanged<StoryItem>? onItemShown;
  // قصة محددة يبدأ منها العرض (من شبكة العروض)؛ وإلا أول قصة لم تُشاهد.
  final String? initialItemId;
  // افتراضيًا يفتح صفحة المتجر؛ من صفحة المتجر نفسها يكفي الرجوع.
  final VoidCallback? onStoreTap;

  const StoryScreen({
    super.key,
    required this.story,
    this.onLikeTap,
    this.onItemShown,
    this.initialItemId,
    this.onStoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: StoryViewerWidget(
          story: story,
          onLikeTap: onLikeTap ?? (_) {},
          // لا توجد صفحة ويب للقصة، فنشارك رابط صورة العرض (يفتح بأي متصفح)
          // مع اسم المتجر ونص العرض.
          onShareTap: (item) => Share.share(
            [
              '${story.storeName}: ${item.caption}',
              if (item.imageUrl.startsWith('http')) item.imageUrl,
              'عبر تطبيق لحق حالك',
            ].join('\n'),
            subject: story.storeName,
          ),
          onStoreTap: onStoreTap ??
              () => Navigator.pushNamed(
                    context,
                    AppRouter.storeProfile,
                    arguments: story.storeId,
                  ),
          onFinished: () => Navigator.pop(context),
          onItemShown: onItemShown,
          initialItemId: initialItemId,
        ),
      ),
    );
  }
}
