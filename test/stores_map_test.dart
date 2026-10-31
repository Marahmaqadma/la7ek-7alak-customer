import 'package:flutter_test/flutter_test.dart';
import 'package:la7ek_7alak/core/utils/helpers.dart';
import 'package:la7ek_7alak/features/customer/data/models/stores/map_stores_response.dart';
import 'package:la7ek_7alak/features/customer/domain/entities/map_store.dart';
import 'package:la7ek_7alak/features/customer/domain/entities/store_story.dart';
import 'package:la7ek_7alak/features/customer/domain/entities/suggested_store.dart';
import 'package:la7ek_7alak/features/customer/presentation/cubit/home_cubit/home_cubit.dart';
import 'package:la7ek_7alak/features/customer/presentation/cubit/stores_map_cubit/stores_map_cubit.dart';

void main() {
  test('map response skips stores without coordinates', () {
    final response = MapStoresResponse.fromJson({
      'items': [
        {
          'id': 1,
          'name': 'متجر الأناقة',
          'latitude': 31.45,
          'longitude': 34.39,
          'city': {'area': 'النصيرات'},
          'category': {'id': 1},
          'activeOffersCount': 3,
        },
        {'id': 2, 'name': 'بدون موقع', 'latitude': null, 'longitude': null},
      ],
    });

    expect(response.stores, hasLength(1));
    final store = response.stores.single;
    expect(store.id, '1');
    expect(store.area, 'النصيرات');
    expect(store.categoryId, 1);
    expect(store.hasActiveOffers, isTrue);
  });

  test('home interests filter keeps preferred stores and their stories', () {
    const state = HomeState(
      suggestedStores: [
        SuggestedStore(id: '1', name: 'الأناقة', isPreferred: true),
        SuggestedStore(id: '2', name: 'البشير'),
      ],
      storeStories: [
        StoreStory(
            storeId: '1',
            storeName: 'الأناقة',
            storeImageUrl: '',
            location: '',
            items: []),
        StoreStory(
            storeId: '2',
            storeName: 'البشير',
            storeImageUrl: '',
            location: '',
            items: []),
      ],
    );
    final filtered = state.copyWith(activeFilter: 'interests');
    expect(filtered.visibleStores.map((s) => s.id), ['1']);
    expect(filtered.visibleStories.map((s) => s.storeId), ['1']);
    expect(filtered.copyWith(clearFilter: true).visibleStores, hasLength(2));
  });

  test('arabic search ignores hamza and taa marbuta differences', () {
    expect(arabicContains('متجر الأناقة ستور', 'الاناقه'), isTrue);
    expect(arabicContains('إلكترونيات', 'الكترونيات'), isTrue);
    expect(arabicContains('مطعم البرنس', 'الاناقة'), isFalse);
  });

  test('visible stores filter by category and name or area', () {
    const stores = [
      MapStore(
        id: '1',
        name: 'مطعم البرنس',
        area: 'غزة',
        categoryId: 2,
        latitude: 31.5,
        longitude: 34.4,
      ),
      MapStore(
        id: '2',
        name: 'أناقة سبورت',
        area: 'النصيرات',
        categoryId: 1,
        latitude: 31.4,
        longitude: 34.3,
      ),
    ];

    const state = StoresMapState(stores: stores);
    expect(state.visibleStores, hasLength(2));
    expect(state.copyWith(selectedCategoryId: 2).visibleStores.single.id, '1');
    expect(state.copyWith(query: 'النصيرات').visibleStores.single.id, '2');
    expect(
      state
          .copyWith(selectedCategoryId: 2)
          .copyWith(clearCategory: true)
          .visibleStores,
      hasLength(2),
    );
  });
}
