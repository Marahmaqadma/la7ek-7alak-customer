import 'package:dartz/dartz.dart';
import '../../../../core/error/error_handler.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/customer_profile.dart';
import '../../domain/entities/follow_status.dart';
import '../../domain/entities/home_banner.dart';
import '../../domain/entities/map_store.dart';
import '../../domain/entities/followed_store.dart';
import '../../domain/entities/store_category.dart';
import '../../domain/entities/store_profile.dart';
import '../../domain/entities/store_story.dart';
import '../../domain/entities/suggested_store.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_data_source.dart';
import '../models/categories/save_interests_request_model.dart';

// ينسّق طلبات الزبون ويحوّل الاستثناءات إلى نتائج فشل.
class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<ErrorHandler, List<StoreCategory>>> getCategories() async {
    try {
      final models = await remoteDataSource.getCategories();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, List<int>>> getMyInterests() async {
    try {
      return Right((await remoteDataSource.getMyInterests()).categoryIds);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, List<int>>> saveMyInterests(
    List<int> categoryIds,
  ) async {
    try {
      final saved = await remoteDataSource.saveMyInterests(
        SaveInterestsRequestModel(categoryIds: categoryIds),
      );
      return Right(saved.categoryIds);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  // يحوّل نماذج الخادم إلى ما تعرضه الواجهة.
  @override
  Future<Either<ErrorHandler, List<SuggestedStore>>>
      getRecommendedStores() async {
    try {
      final response = await remoteDataSource.getRecommendedStores();
      return Right(response.items.map((m) => m.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, List<MapStore>>> getMapStores({
    required double south,
    required double north,
    required double west,
    required double east,
  }) async {
    try {
      final response = await remoteDataSource.getMapStores(
        south: south,
        north: north,
        west: west,
        east: east,
      );
      return Right(response.stores);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, List<HomeBanner>>> getBanners() async {
    try {
      final response = await remoteDataSource.getBanners();
      return Right(response.items
          .where((m) => m.imageUrl.isNotEmpty)
          .map((m) => m.toEntity())
          .toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, List<StoreStory>>> getRecommendedStories() async {
    try {
      final response = await remoteDataSource.getRecommendedStories();
      return Right(response.toStoreStories());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, List<StoreStory>>> getFollowingStories() async {
    try {
      final response = await remoteDataSource.getFollowingStories();
      return Right(response.toStoreStories());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, Unit>> viewStory(String storyId) async {
    try {
      await remoteDataSource.viewStory(storyId);
      return const Right(unit);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, Unit>> setStoryLiked(
    String storyId,
    bool liked,
  ) async {
    try {
      liked
          ? await remoteDataSource.likeStory(storyId)
          : await remoteDataSource.unlikeStory(storyId);
      return const Right(unit);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, StoreProfile>> getStoreProfile(
    String storeId,
  ) async {
    try {
      final model = await remoteDataSource.getStoreProfile(storeId);
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, List<StoryItem>>> getStoreStories(
    String storeId,
  ) async {
    try {
      final response = await remoteDataSource.getStoreStories(storeId);
      return Right(response.items.map((m) => m.toItem()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, List<StoreAd>>> getStoreAds(
      String storeId) async {
    try {
      final response = await remoteDataSource.getStoreAds(storeId);
      return Right(response.items.map((m) => m.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, String?>> uploadAvatar(String filePath) async {
    try {
      return Right(await remoteDataSource.uploadAvatar(filePath));
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, Unit>> markNotificationRead(String id) async {
    try {
      await remoteDataSource.markNotificationRead(id);
      return const Right(unit);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, Unit>> reportStore(
    String storeId,
    String reason,
  ) async {
    try {
      await remoteDataSource.reportStore(storeId, reason);
      return const Right(unit);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, bool>> setStoreNotificationsMuted(
    String storeId,
    bool isMuted,
  ) async {
    try {
      return Right(
        await remoteDataSource.setStoreNotificationsMuted(storeId, isMuted),
      );
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  // نرتب من الأحدث احتياطًا حتى لو لم يرتبها الخادم.
  @override
  Future<Either<ErrorHandler, List<AppNotification>>> getNotifications() async {
    try {
      final response = await remoteDataSource.getNotifications();
      // الإشعار يعيش 24 ساعة فقط (التصميم). الخادم يفترض أن يحذفها، لكننا
      // نخفي الأقدم هنا أيضًا احتياطًا حتى لا تبقى أيامًا.
      final cutoff = DateTime.now().subtract(const Duration(hours: 24));
      final items = response.items
          .map((m) => m.toEntity())
          .where((n) => n.createdAt.isAfter(cutoff))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(items);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, int>> getUnreadNotificationsCount() async {
    try {
      return Right(await remoteDataSource.getUnreadNotificationsCount());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, AccountSettings>> getAccountSettings() async {
    try {
      final model = await remoteDataSource.getAccountSettings();
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, AccountSettings>> updateAccountSettings(
    AccountSettings settings,
  ) async {
    try {
      final saved = await remoteDataSource.updateAccountSettings(settings);
      return Right(saved?.toEntity() ?? settings);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, Unit>> sendSupportRequest({
    required String title,
    required String message,
  }) async {
    try {
      await remoteDataSource.sendSupportRequest(title: title, message: message);
      return const Right(unit);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, List<FollowedStore>>> getFollowingStores() async {
    try {
      final response = await remoteDataSource.getFollowingStores();
      return Right(response.items.map((m) => m.toEntity()).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, FollowStatus>> followStore(String storeId) async {
    try {
      final response = await remoteDataSource.followStore(storeId);
      return Right(response.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Either<ErrorHandler, FollowStatus>> unfollowStore(
    String storeId,
  ) async {
    try {
      final response = await remoteDataSource.unfollowStore(storeId);
      return Right(response.toEntity());
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
