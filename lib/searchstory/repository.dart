import 'dart:async';

import 'archive_api_provider.dart';
import 'books_db_provider.dart';
import 'models.dart';

class Repository {
  List<Source> sources = <Source>[
    archiveApiProvider,
  ];

  List<Cache> caches = <Cache>[
    DatabaseHelper()
  ];

  Future<List<Book>> fetchBooks(int offset, int limit) async {
    List<Book> books;
    books = await caches[0].getBooks(offset, limit);
    if(books.length <= 0){
      books = await sources[0].fetchBooks(offset,limit);
      caches[0].saveBooks(books);
    }
    return books;
  }
  Future<List<Book>> topBooks(int n) async {
    List<Book> books;
    books = await sources[0].topBooks(n);
    return books;
  }

  Future<Book> getBook(String id ) async {

    return await sources[0].book(id);
  }

  Future<List<AudioFile>> fetchAudioFiles(String bookId) async {
    List<AudioFile> audiofiles;
    audiofiles = await caches[0].fetchAudioFiles(bookId);
    if(audiofiles.length <=0 ) {
      audiofiles = await sources[0].fetchAudioFiles(bookId);
      caches[0].saveAudioFiles(audiofiles);
    }
    return audiofiles;
  }

}

abstract class Source {
  Future<List<Book>> fetchBooks(int offset, int limit);
  Future<List<Book>> topBooks(int n);
  Future<List<AudioFile>> fetchAudioFiles(String bookId);
  Future<Book> book(String bookId);
}

abstract class Cache{
  Future saveBooks(List<Book> books);
  Future saveAudioFiles(List<AudioFile> audiofiles);
  Future<List<Book>> getBooks(int offset, int limit);
  Future<List<AudioFile>> fetchAudioFiles(String bookId);
  Future<Book> getBook(String bookId);
}