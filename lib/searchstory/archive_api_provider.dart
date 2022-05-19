import 'models.dart';
import 'repository.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:developer' as developer;
final _metadata = "https://archive.org/metadata/";
final _commonParams =
    "q=collection:(librivoxaudio)&fl=runtime,avg_rating,num_reviews,title,description,identifier,creator,date,downloads,subject,item_size";

final _latestBooksApi =
    "https://archive.org/advancedsearch.php?$_commonParams&sort[]=addeddate desc&output=json";

String _mostDownloaded(int n) {
  return "https://archive.org/advancedsearch.php?$_commonParams&sort[]=downloads desc&rows="+n.toString()+"&page=1&output=json";
}



final query = "title:(secret tomb) AND collection:(librivoxaudio)";

String get_book_query(String title) {
  return "https://archive.org/advancedsearch.php?$_commonParams&title:\\\""+ title +"\\\")&rows=1&page=1&output=json";
}


class ArchiveApiProvider implements Source {
  Client client = Client();

  Future<List<Book>> fetchBooks(int offset, int limit) async {
    final response = await client.get(
        Uri.parse("$_latestBooksApi&rows=$limit&page=${offset / limit + 1}"));
    Map resJson = json.decode(response.body);
    return Book.fromJsonArray(resJson['response']['docs']);
  }

  Future<List<AudioFile>> fetchAudioFiles(String bookId) async {
    final response = await client.get(Uri.parse("$_metadata/$bookId/files"));
    Map resJson = json.decode(response.body);
    List<AudioFile> afiles = [];
    resJson["result"].forEach((item) {
      if (item["source"] == "original" && item["track"] != null) {
        item["book_id"] = bookId;
        afiles.add(AudioFile.fromJson(item));
      }
    });
    return afiles;
  }

  @override
  Future<List<Book>> topBooks(int n) async {
    String uri = _mostDownloaded(n);
    final response = await client.get(Uri.parse("$uri"));
    Map resJson = json.decode(response.body);
    //developer.log(resJson['response']['docs'][0].toString());
    return Book.fromJsonArray(resJson['response']['docs']);
  }

  @override
  Future<Book> book(String title) async {
    final uu = get_book_query(title);
    final response = await client.get(Uri.parse("$uu"));
    Map resJson = json.decode(response.body);
    developer.log(title);
    developer.log(resJson['response']['docs'][0].toString());
    return Book.fromJsonArray(resJson['response']['docs'])[0];
  }
}

final archiveApiProvider = ArchiveApiProvider();
