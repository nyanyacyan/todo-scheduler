//? 検索ボタン関係を格納するファイル
//? Dart imports ===============================================
import 'package:flutter/material.dart';
import 'package:gm_reviews_search_doctor_app/strings.dart';

//* ------------------------------------------------------------

class SearchBtn extends StatelessWidget {
  // 変数を定義する
  final String btnLabel;  // ボタンのラベル
  final VoidCallback onPressedFunc;  // ボタンが押されたときの処理

  // コンストラクタ
  const SearchBtn({
    super.key,  // このクラスでのkeyを受け渡しするように定義（あることでwidgetの場所などをわかりやすくできる）
    required this.btnLabel,
    required this.onPressedFunc,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size.fromHeight(8),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        onPressed: onPressedFunc,
        child: Text(WidgetStrings.searchButton,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

//* ------------------------------------------------------------
