import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:la7ek_7alak/core/routing/app_router.dart';
import 'package:video_player/video_player.dart';

import '../cubit/splash/splash_cubit.dart';

// أول شاشة في التطبيق: تعرض فيديو اللوجو، وأثناءه يفحص SplashCubit إن كان
// المستخدم ما زال مسجلًا. بعد الفيديو: المسجل يدخل لرئيسيته مباشرة،
// وغيره لشاشة الترحيب (intro).
// الفيديو 5 ثوانٍ ويُعرض كاملًا تقريبًا وبدون صوت.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const String _videoAsset = 'assets/videos/splash_video.mp4';
  // كان القص ثانيتين من كل طرف فلا يظهر إلا ثانية واحدة من 5.
  static const Duration _skipStart = Duration.zero;
  static const Duration _skipEnd = Duration(milliseconds: 200);
  // إن علق الفيديو لأي سبب لا يبقى الزبون عالقًا على شاشة بيضاء.
  static const Duration _maxWait = Duration(seconds: 8);
  static const double _logoWidthFactor = 0.8;
  // لون خلفية الفيديو نفسه، حتى لا يظهر مستطيل الفيديو على خلفية بيضاء.
  static const Color _videoBackground = Color(0xFFF9F9F9);
  // نقص 12% من أعلى الفيديو وأسفله لإخفاء العلامة المائية في الزاوية.
  static const double _cropFactor = 0.76;

  final VideoPlayerController _controller =
      VideoPlayerController.asset(_videoAsset);
  Timer? _fallbackTimer;
  bool _isInitialized = false;
  bool _videoDone = false;
  // بعد المهلة ننتقل حتى لو لم ينتهِ فحص الجلسة (نعامله كغير مسجل).
  bool _timedOut = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // ملء الشاشة أثناء الفيديو (إخفاء شريط الحالة).
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _fallbackTimer = Timer(_maxWait, () {
      _timedOut = true;
      _goNext();
    });
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _controller.initialize();
      if (!mounted) return;

      await _controller.seekTo(_skipStart);
      if (!mounted) return;

      setState(() => _isInitialized = true);
      _controller.addListener(_onVideoTick);
      // السبلاش بدون صوت حتى لا يزعج من يفتح التطبيق في مكان هادئ.
      await _controller.setVolume(0);
      await _controller.play();
    } catch (e) {
      // فيديو تالف أو غير مدعوم على الجهاز: نكمل بدونه.
      debugPrint('Splash video failed: $e');
      _goNext();
    }
  }

  // ننتقل قبل نهاية الفيديو بـ [_skipEnd]، أو فورًا عند أي خطأ.
  void _onVideoTick() {
    final video = _controller.value;
    if (video.hasError ||
        (video.isInitialized && video.position >= video.duration - _skipEnd)) {
      _goNext();
    }
  }

  // انتهى الفيديو (أو فشل/انتهت المهلة): ننتقل حالما يتقرر فحص الجلسة.
  void _goNext() {
    _videoDone = true;
    _tryNavigate();
  }

  // ينتقل مرة واحدة فقط، بعد الفيديو ونتيجة فحص الجلسة معًا.
  void _tryNavigate() {
    if (_navigated || !mounted || !_videoDone) return;
    final role = context.read<SplashCubit>().state;
    if (role == null && !_timedOut) return;
    _navigated = true;
    _fallbackTimer?.cancel();

    // نرجع أشرطة النظام لوضعها العادي (لا edgeToEdge، وإلا رُسم التطبيق
    // تحت أزرار الرجوع والرئيسية فغطّت شريط التنقل السفلي).
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    final destination = switch (role) {
      'merchant' => AppRouter.sellerHome,
      'consumer' => AppRouter.home,
      _ => AppRouter.intro,
    };
    Navigator.pushReplacementNamed(context, destination);
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _controller.removeListener(_onVideoTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * _logoWidthFactor;

    // لو انتهى الفيديو قبل فحص الجلسة، ننتقل لحظة وصول النتيجة.
    return BlocListener<SplashCubit, String?>(
      listener: (_, __) => _tryNavigate(),
      child: Scaffold(
        backgroundColor: _videoBackground,
        body: Center(
          child: _isInitialized
              // FittedBox.cover يملأ الإطار الأقصر ويقص الزائد من الأعلى والأسفل.
              ? SizedBox(
                  width: width,
                  height: width / _controller.value.aspectRatio * _cropFactor,
                  child: ClipRect(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
