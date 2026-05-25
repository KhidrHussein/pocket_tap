import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class WidgetService {
  static Future<void> updateWidget(double availableBalance, double dailyBudget) async {
    final currencyFormat = NumberFormat.currency(symbol: '₦', decimalDigits: 2);
    final balanceStr = currencyFormat.format(availableBalance);
    
    int burnColor = 0xFF333333; // dark gray
    if (availableBalance < 0) {
      burnColor = 0xFFEF4444; // red
    } else if (availableBalance < dailyBudget * 0.25) {
      burnColor = 0xFFFBBF24; // yellow
    }

    await HomeWidget.saveWidgetData<String>('balance', balanceStr);
    await HomeWidget.saveWidgetData<bool>('is_negative', availableBalance < 0);
    await HomeWidget.saveWidgetData<int>('burn_color', burnColor);

    await HomeWidget.updateWidget(
      name: 'PocketTapWidgetProvider',
      iOSName: 'PocketTapWidget',
    );
  }
}
