import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static final BookmarkService _instance = BookmarkService._internal();
  factory BookmarkService() => _instance;
  BookmarkService._internal();

  List<BookmarkedChapter> _bookmarkedChapters = [];
  List<BookmarkedPage> _bookmarkedPages = [];

  List<BookmarkedChapter> get bookmarkedChapters => _bookmarkedChapters;
  List<BookmarkedPage> get bookmarkedPages => _bookmarkedPages;

  bool isChapterBookmarked(int chapterNumber) {
    return _bookmarkedChapters.any((c) => c.chapterNumber == chapterNumber);
  }

  bool isPageBookmarked(int chapterNumber, int pageNumber) {
    return _bookmarkedPages.any(
      (p) => p.chapterNumber == chapterNumber && p.pageNumber == pageNumber,
    );
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();

    // Load chapters
    final chaptersJson = prefs.getString('bookmarkedChapters');
    if (chaptersJson != null) {
      final List<dynamic> chaptersList = json.decode(chaptersJson);
      _bookmarkedChapters =
          chaptersList
              .map(
                (c) => BookmarkedChapter(
                  chapterNumber: c['chapterNumber'],
                  title: c['title'],
                  subtitle: c['subtitle'],
                  imagePath: c['imagePath'],
                  imagePaths: List<String>.from(c['imagePaths']),
                ),
              )
              .toList();
    }

    // Load pages
    final pagesJson = prefs.getString('bookmarkedPages');
    if (pagesJson != null) {
      final List<dynamic> pagesList = json.decode(pagesJson);
      _bookmarkedPages =
          pagesList
              .map(
                (p) => BookmarkedPage(
                  chapterNumber: p['chapterNumber'],
                  pageNumber: p['pageNumber'],
                  imagePath: p['imagePath'],
                  chapterTitle: p['chapterTitle'],
                ),
              )
              .toList();
    }
  }

  Future<void> saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();

    // Save chapters
    final chaptersJson = json.encode(
      _bookmarkedChapters
          .map(
            (c) => {
              'chapterNumber': c.chapterNumber,
              'title': c.title,
              'subtitle': c.subtitle,
              'imagePath': c.imagePath,
              'imagePaths': c.imagePaths,
            },
          )
          .toList(),
    );
    await prefs.setString('bookmarkedChapters', chaptersJson);

    // Save pages
    final pagesJson = json.encode(
      _bookmarkedPages
          .map(
            (p) => {
              'chapterNumber': p.chapterNumber,
              'pageNumber': p.pageNumber,
              'imagePath': p.imagePath,
              'chapterTitle': p.chapterTitle,
            },
          )
          .toList(),
    );
    await prefs.setString('bookmarkedPages', pagesJson);
  }

  // Update add/remove methods to call saveBookmarks()
  void addChapterBookmark(BookmarkedChapter chapter) {
    if (!_bookmarkedChapters.any(
      (c) => c.chapterNumber == chapter.chapterNumber,
    )) {
      _bookmarkedChapters.add(chapter);
      saveBookmarks();
    }
  }

  void removeChapterBookmark(int chapterNumber) {
    _bookmarkedChapters.removeWhere((c) => c.chapterNumber == chapterNumber);
    saveBookmarks();
  }

  void addPageBookmark(BookmarkedPage page) {
    if (!_bookmarkedPages.any(
      (p) =>
          p.chapterNumber == page.chapterNumber &&
          p.pageNumber == page.pageNumber,
    )) {
      _bookmarkedPages.add(page);
      saveBookmarks();
    }
  }

  void removePageBookmark(int chapterNumber, int pageNumber) {
    _bookmarkedPages.removeWhere(
      (p) => p.chapterNumber == chapterNumber && p.pageNumber == pageNumber,
    );
    saveBookmarks();
  }
}

class BookmarkedChapter {
  final int chapterNumber;
  final String title;
  final String subtitle;
  final String imagePath;
  final List<String> imagePaths;

  BookmarkedChapter({
    required this.chapterNumber,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.imagePaths,
  });
}

class BookmarkedPage {
  final int chapterNumber;
  final int pageNumber;
  final String imagePath;
  final String chapterTitle;

  BookmarkedPage({
    required this.chapterNumber,
    required this.pageNumber,
    required this.imagePath,
    required this.chapterTitle,
  });
}
