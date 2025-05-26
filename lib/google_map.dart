import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:gm_reviews_search_doctor_app/strings.dart';
import 'package:gm_reviews_search_doctor_app/utils/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';  // envファイルの読み込み
import 'package:http/http.dart' as http;  // APIリクエストするためのライブラリ


//! ------------------------------------------------------------
/// Googleマップへのリンクボタン→アプリがない場合にはブラウザにてGoogleマップを開く
///
//! ------------------------------------------------------------

/// Googleマップを開くボタン
class MapAppSwitchButton extends StatelessWidget {
  final double lat;
  final double lng;
  final String label;

  MapAppSwitchButton({
    super.key,
    required this.lat,
    required this.lng,
    this.label = AppStrings.textMapButton,
  }) {
    logger.d('[生成] MapAppSwitchButton: lat=$lat, lng=$lng');
  }

  /// Googleマップを開く
  void _openGoogleMap(BuildContext context, double lat, double lng) async {
    logger.d('Googleマップを開く処理を開始');
    final messenger = ScaffoldMessenger.of(context);

    logger.d('Googleマップを開く');
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      logger.e('Googleマップを開けませんでした');
      messenger.showSnackBar(const SnackBar(content: Text('地図を開けませんでした')));
    }
  }


  /// Googleマップを開くボタン
  @override
  Widget build(BuildContext context) {
    logger.d('[描画] MapAppSwitchButton: lat=$lat, lng=$lng');

    return SizedBox(
      width: 200,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size.fromHeight(8),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        onPressed: () => _openGoogleMap(context, lat, lng),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MapRequestDetails {}
  Future<Uri> fetchWebsiteOrFallback(String placeId) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId&fields=website&key=$apiKey';

    final res = await http.get(Uri.parse(detailsUrl));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final website = data['result']?['website'];
      if (website != null) return Uri.parse(website);
    }

    // fallback to Google Maps detail page
    return Uri.parse('https://www.google.com/maps/place/?q=place_id=$placeId');
  }
