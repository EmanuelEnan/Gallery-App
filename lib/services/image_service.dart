import 'dart:convert';

import 'package:gallery_app/models/image_model.dart';
import 'package:http/http.dart' as http;

import '../tokens.dart';

class ImageService {
  Tokens tokens = Tokens();

  Future<List<ImageModel>> getApi() async {
    String url =
        'https://api.unsplash.com/photos/?per_page=30&order_by=latest&client_id=${tokens.clientId}';

    Uri uri = Uri.parse(url);

    final response = await http.get(
      uri,
    );

    try {
      if (response.statusCode == 200) {
        final resp = response.body;
        print(resp);
        // Map services = jsonDecode(resp);
        final service = (jsonDecode(resp) as List);
        // final alt = service.map((json) => ImageModel.fromJson(json)).toList();
        final serviceFinal =
            service.map((json) => ImageModel.fromJson(json)).toList();
        return serviceFinal;

        // return ImageModel.fromJson(jsonDecode(resp));
        //
      }
    } catch (e) {
      print(e.toString());
    }

    throw Exception('${response.statusCode}');
  }
}
