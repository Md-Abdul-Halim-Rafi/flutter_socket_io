import 'package:dio/dio.dart';

String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1X2lkIjoxLCJyb2xlX2lkIjoxLCJuYW1lIjoiTXVzaGZpcXVyIFJhaG1hbiIsImVtYWlsIjoibXVzaGZpcXVyLmtldW5hQGdtYWlsLmNvbSIsInN0YXR1cyI6MSwiaWF0IjoxNjM4NDM1NzAyLCJleHAiOjE2NDM2MTk3MDJ9.gtm3jMbUvBlSk7H5WlJKatoM4EGIZkThMmKlmQqnprQ";

BaseOptions options =
    BaseOptions(baseUrl: "https://d5d0-103-216-56-196.ap.ngrok.io/v1");

Dio dio = Dio(options);

Future<List> fetchMessages() async {
  try {
    Response response = await dio.get(
      "/community/chat",
      options: Options(
        headers: <String, dynamic>{"Authorization": "Beader $token"},
      ),
    );

	List messages = response.data["messages"];

	return messages;

  } on DioError catch (e) {
    // print(e.response!.data);
  }

  return [];
}
