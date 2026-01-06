import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../db_font_master/data.dart';

class FontMasterSearchLogic extends GetxController {
  final _db = FontMasterDatabase();

  final searchController = TextEditingController();
  final selectedFilter = 'All'.obs;
  final searchQuery = ''.obs;
  final isSearching = false.obs;
  
  final filters = ['All', 'Builtin', 'Custom', 'Local'];
  final recentSearches = <String>[].obs;
  final searchResults = <Map<String, dynamic>>[].obs;
  
  final popularTags = [
    'Handwriting',
    'Cute',
    'Classic',
    'Featured',
    'Modern',
    'Elegant',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSearchHistory();
    
    // Listen to search input changes
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();
    searchQuery.value = query;
    
    if (query.length >= 2) {
      _performSearch(query);
    } else {
      searchResults.clear();
    }
  }

  Future<void> _performSearch(String query) async {
    try {
      isSearching.value = true;
      
      // Search in database
      final results = await _db.searchAllFonts(query);
      
      // Filter by source if needed
      List<Map<String, dynamic>> filteredResults = results;
      if (selectedFilter.value != 'All') {
        final filterSource = selectedFilter.value.toLowerCase();
        filteredResults = results.where((font) {
          final source = font['source'] as String;
          return source == filterSource;
        }).toList();
      }
      
      // Map to display format
      searchResults.value = filteredResults.map((font) {
        String category = '';
        if (font['source'] == 'builtin') {
          category = 'Builtin';
        } else if (font['source'] == 'custom') {
          category = 'Custom';
        } else if (font['source'] == 'local') {
          category = 'Local';
        }
        
        return {
          'font_id': font['font_id'],
          'name': font['font_name'],
          'category': category,
          'source': font['source'],
          'preview_image': font['preview_image'],
        };
      }).toList();
    } catch (e) {
      _showError('Search failed, please try again');
      searchResults.clear();
    } finally {
      isSearching.value = false;
    }
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
    if (searchQuery.value.length >= 2) {
      _performSearch(searchQuery.value);
    }
  }

  void searchByTag(String tag) {
    searchController.text = tag;
    _saveSearchHistory(tag);
  }

  void searchFromHistory(String query) {
    searchController.text = query;
  }

  void clearSearch() {
    searchController.clear();
    searchResults.clear();
    searchQuery.value = '';
  }

  Future<void> _loadSearchHistory() async {
    try {
      final historyJson = await _db.getSetting('search_history');
      if (historyJson != null && historyJson.isNotEmpty) {
        final List<dynamic> history = jsonDecode(historyJson);
        recentSearches.value = history.cast<String>().take(10).toList();
      }
    } catch (e) {
      // Don't show error to user on initial load
    }
  }

  Future<void> _saveSearchHistory(String query) async {
    try {
      if (query.trim().isEmpty) return;
      
      // Remove if already exists
      recentSearches.remove(query);
      
      // Add to beginning
      recentSearches.insert(0, query);
      
      // Keep only last 10
      if (recentSearches.length > 10) {
        recentSearches.removeRange(10, recentSearches.length);
      }
      
      // Save to database
      await _db.setSetting('search_history', jsonEncode(recentSearches));
    } catch (e) {
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      recentSearches.clear();
      await _db.setSetting('search_history', '[]');
      _showSuccess('Search history cleared');
    } catch (e) {
      _showError('Failed to clear search history');
    }
  }

  void openFontDetail(String fontId, String fontName, String source) {
    // Save search query to history if valid
    if (searchQuery.value.length >= 2) {
      _saveSearchHistory(searchQuery.value);
    }
    
    Get.toNamed(
      '/font_detail',
      arguments: {
        'font_id': fontId,
        'font_name': fontName,
        'source': source,
      },
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
    );
  }
}

