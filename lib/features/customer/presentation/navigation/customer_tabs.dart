import 'package:flutter/material.dart';

import 'package:la7ek_7alak/core/routing/app_router.dart';

// فهارس شريط التنقل السفلي لشاشات الزبون.
class CustomerTab {
  CustomerTab._();

  static const int profile = 0;
  static const int followers = 1;
  static const int notifications = 2;
  static const int home = 3;
}

// يتتبع الشاشات المفتوحة في الـ Navigator، حتى نعرف إن كان التبويب مفتوحًا
// مسبقًا فنرجع إليه بدل فتح نسخة جديدة. يُسجَّل في MaterialApp.
// نحفظ الشاشات نفسها لا أسماءها: شاشات الدخول بلا أسماء، والبحث بالاسم كان
// يحذف أو يستبدل الشاشة الخطأ فيظن أن الرئيسية مفتوحة وهي ليست كذلك.
class CustomerNavObserver extends NavigatorObserver {
  final List<Route> _stack = [];

  // isActive يستبعد أي شاشة أُغلقت ولم يصلنا إشعار بها.
  bool contains(String name) =>
      _stack.any((r) => r.isActive && r.settings.name == name);

  @override
  void didPush(Route route, Route? previousRoute) => _stack.add(route);

  @override
  void didPop(Route route, Route? previousRoute) => _stack.remove(route);

  @override
  void didRemove(Route route, Route? previousRoute) => _stack.remove(route);

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final index = oldRoute == null ? -1 : _stack.indexOf(oldRoute);
    if (newRoute == null) {
      if (index != -1) _stack.removeAt(index);
    } else if (index == -1) {
      _stack.add(newRoute);
    } else {
      _stack[index] = newRoute;
    }
  }
}

final customerNavObserver = CustomerNavObserver();

// يفتح تبويب الزبون المطلوب من شريط التنقل مع الاحتفاظ بالتاريخ، فسهم الرجوع
// يعيد لآخر مكان. إن كان التبويب مفتوحًا خلفنا نرجع إليه بدل تكراره.
// [current]: التبويب المفتوح حاليًا؛ الضغط عليه لا يفعل شيئًا.
// يكتمل عند الرجوع للشاشة التي فتحت التبويب (لتحديث بياناتها).
Future<void> openCustomerTab(
  BuildContext context,
  int index, {
  int? current,
}) async {
  if (index == current) return;

  // كل تبويب يُفتح من الـ router الذي ينشئ الـ cubit الخاص به.
  final routeName = switch (index) {
    CustomerTab.profile => AppRouter.profile,
    CustomerTab.followers => AppRouter.followers,
    CustomerTab.notifications => AppRouter.notifications,
    _ => AppRouter.home,
  };

  final navigator = Navigator.of(context);
  if (customerNavObserver.contains(routeName)) {
    // حماية إضافية: إن لم نجد التبويب نتوقف عند أول شاشة ونفتحه فوقها،
    // فلا يبقى الزبون على شاشة الدخول.
    var found = false;
    navigator.popUntil((route) {
      found = route.settings.name == routeName;
      return found || route.isFirst;
    });
    if (!found) await navigator.pushNamed(routeName);
  } else {
    await navigator.pushNamed(routeName);
  }
}
