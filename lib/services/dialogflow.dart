import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class DialogflowService {
  static String? _projectId;
  static AuthClient? _client;

  /// Khởi tạo Service Account + lấy token
  static Future<void> init() async {
    final jsonCredentials = await rootBundle.loadString('assets/credentials.json');
    final accountCredentials = ServiceAccountCredentials.fromJson(jsonCredentials);

    _projectId = json.decode(jsonCredentials)['project_id'];

    final scopes = [
      'https://www.googleapis.com/auth/dialogflow',
      'https://www.googleapis.com/auth/cloud-platform',
    ];

    _client = await clientViaServiceAccount(accountCredentials, scopes);

    print("✅ Authenticated thành công!");
  }

  /// Gửi message tới Dialogflow
  static Future<String> sendMessage(String text) async {
    final url = Uri.parse(
      'https://dialogflow.googleapis.com/v2/projects/$_projectId/agent/sessions/123456789:detectIntent',
    );

    final response = await _client!.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: json.encode({
        "queryInput": {
          "text": {
            "text": text,
            "languageCode": "vi"
          }
        }
      }),
    );

    print("📨 Phản hồi từ Dialogflow: ${response.body}");

    if (response.statusCode != 200) {
      return "❌ Lỗi từ Dialogflow: ${response.body}";
    }

    final result = json.decode(response.body);
    final reply = result['queryResult']?['fulfillmentText'];
    return reply ?? "🤖 Không có phản hồi từ chatbot.";
  }
}
