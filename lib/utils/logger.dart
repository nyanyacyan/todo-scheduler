//? ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

import 'dart:io';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

//? ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// 実行処理関数
// setupLogger関数は、アプリケーションのロガーを初期化するためのもの
Future<DailyFileLogOutput> setupLogger() async {
  final fileOutput = await DailyFileLogOutput.create();

  // Loggerクラスの各設定にカスタマイズを反映
  // printerは出力のフォーマットを指定
  // outputは出力先を指定
  // ConsoleOutputは、ターミナルなどでの背景色を変更するために使用
  logger = Logger(
    level: Level.debug,
    printer: CustomLogPrinter(),  // CustomLogPrinterクラスを使用
    output: MultiOutput([
      ConsoleOutput(),
      fileOutput,  // DailyFileLogOutputクラスを使用
    ]),
  );
  return fileOutput;
}

//! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//? ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// loggerのカスタマイズ
// 出力ログの色分けなどを追加

//? ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

late final Logger logger;

class CustomLogPrinter extends LogPrinter {
  static const levelColors = {
    Level.debug: '\x1B[90m',
    Level.info: '\x1B[34m',
    Level.warning: '\x1B[33m',
    Level.error: '\x1B[31m',
    Level.fatal: '\x1B[35m',
  };

  static const levelEmojis = {
    Level.debug: '🔍',
    Level.info: '💡',
    Level.warning: '⚠️',
    Level.error: '⛔',
    Level.fatal: '🚨',
  };

  @override
  List<String> log(LogEvent event) {
    final color = levelColors[event.level] ?? '';
    final emoji = levelEmojis[event.level] ?? '';
    final resetColor = '\x1B[0m';
    return ['$color$emoji ${event.message}$resetColor'];
  }
}


//? ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// loggerのカスタマイズ
// ログファイルの指定

//? ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// LogOutputクラスを継承して、ログメッセージをファイルに出力するクラス
// LogOutputはloggerのアウトプットをしようとする際に呼ばれるクラス
class DailyFileLogOutput extends LogOutput {
  // IOSinkはログメッセージをファイルに書き込むためのもの
  // _sinkは変数名
  // IOSinkはメソッド（dart:ioライブラリ）→ファイルに文字を書き込むためのメソッド
  late final IOSink _sink;

  // コンストラクタ(__init__)
  DailyFileLogOutput._(this._sink);

  // createメソッドは、ログファイルを作成し、古いログを削除するためのもの
  static Future<DailyFileLogOutput> create() async {
    final now = DateTime.now();  // 現在の日付と時刻を取得
    final dateStr = DateFormat('yyyy-MM-dd').format(now);  // 日付を文字列にフォーマット
    final directory = await getApplicationDocumentsDirectory();  // アプリのドキュメントディレクトリを取得
    final file = File('${directory.path}/log/app_log_$dateStr.txt');  // ログファイルのパス
    await file.create(recursive: true);  // ディレクトリが存在しない場合は作成
    final sink = file.openWrite(mode: FileMode.append);  // 追記モードで開く

    // 古いログ削除（7日以上前）
    final logDir = Directory('${directory.path}/log');
    if (await logDir.exists()) {
      final files = logDir.listSync();
      for (var file in files) {
        if (file is File) {
          final stat = await file.stat();
          final modified = stat.modified;
          if (now.difference(modified).inDays > 7) {
            await file.delete();
          }
        }
      }
    }

    return DailyFileLogOutput._(sink);
  }

  // LogOutputのoutputメソッドをオーバーライド
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      _sink.writeln(line);
    }
  }

  // LogOutputのcloseメソッドをオーバーライド
  void dispose() {
    _sink.close();
  }
}


