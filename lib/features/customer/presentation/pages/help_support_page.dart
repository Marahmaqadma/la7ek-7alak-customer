import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la7ek_7alak/core/constants/app_constants.dart';
import 'package:la7ek_7alak/core/helpers/contact_launcher.dart';

import '../cubit/support_cubit/support_cubit.dart';
import '../widgets/common/customer_page_header.dart';
import '../widgets/common/customer_primary_button.dart';
import '../widgets/help_support/direct_contact_section.dart';
import '../widgets/help_support/support_form_section.dart';

// صفحة المساعدة والدعم: تقرأ حالة SupportCubit وتحدد ماذا يحدث عند كل تفاعل.
// الـ cubit يُنشأ في الـ router (AppRouter.helpSupport).
// واتساب والاتصال يفتحان تطبيقات الجوال برقم الدعم (AppConstants).
class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupportCubit>();

    // فتح تطبيق خارجي شغل الجهاز فيبقى هنا؛ الفشل يظهر كرسالة.
    Future<void> openOrWarn(Future<bool> Function() open, String error) async {
      final messenger = ScaffoldMessenger.of(context);
      if (await open()) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(error, textAlign: TextAlign.right),
        ));
    }

    return BlocConsumer<SupportCubit, SupportState>(
      listenWhen: (_, curr) => curr.actionMessage != null,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.actionMessage!, textAlign: TextAlign.right),
        )),
      builder: (context, state) => HelpAndSupportView(
        isSending: state.isSending,
        sentCount: state.sentCount,
        onWhatsAppTap: () => openOrWarn(
          () => ContactLauncher.openWhatsApp(AppConstants.supportWhatsApp),
          'تعذر فتح واتساب',
        ),
        onPhoneTap: () => openOrWarn(
          () => ContactLauncher.call(AppConstants.supportPhone),
          'تعذر فتح الاتصال',
        ),
        onSend: cubit.send,
      ),
    );
  }
}

// واجهة الدعم: نص الحقول حالة واجهة حتى الضغط على "إرسال الرسالة".
class HelpAndSupportView extends StatefulWidget {
  final VoidCallback onWhatsAppTap;
  final VoidCallback onPhoneTap;
  final void Function(String title, String message) onSend;
  final bool isSending;
  // يتغير بعد كل إرسال ناجح، فتُفرَّغ الحقول.
  final int sentCount;

  const HelpAndSupportView({
    super.key,
    required this.onWhatsAppTap,
    required this.onPhoneTap,
    required this.onSend,
    this.isSending = false,
    this.sentCount = 0,
  });

  @override
  State<HelpAndSupportView> createState() => _HelpAndSupportViewState();
}

class _HelpAndSupportViewState extends State<HelpAndSupportView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void didUpdateWidget(covariant HelpAndSupportView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sentCount != widget.sentCount) {
      _titleController.clear();
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const CustomerPageHeader(title: 'المساعدة والدعم الفني'),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                child: Column(
                  children: [
                    SupportContactSection(
                      onWhatsAppTap: widget.onWhatsAppTap,
                      onPhoneTap: widget.onPhoneTap,
                    ),
                    SizedBox(height: 20.h),
                    SupportFormSection(
                      titleController: _titleController,
                      messageController: _messageController,
                    ),
                    SizedBox(height: 24.h),
                    CustomerPrimaryButton(
                      label: 'إرسال الرسالة',
                      isLoading: widget.isSending,
                      onTap: () => widget.onSend(
                        _titleController.text.trim(),
                        _messageController.text.trim(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
