package com.example.pocket_tap

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetLaunchIntent

class PocketTapWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                val balance = widgetData.getString("balance", "₦0.00")
                val burnColor = (widgetData.all["burn_color"] as? Number)?.toInt() ?: android.graphics.Color.DKGRAY
                val isNegative = widgetData.getBoolean("is_negative", false)

                setTextViewText(R.id.tv_balance, balance)
                setTextColor(R.id.tv_balance, if (isNegative) android.graphics.Color.parseColor("#EF4444") else android.graphics.Color.WHITE)
                
                val pendingIntentIncome = HomeWidgetLaunchIntent.getActivity(context,
                    MainActivity::class.java,
                    Uri.parse("pockettap://entry?type=income"))
                setOnClickPendingIntent(R.id.btn_add_income, pendingIntentIncome)

                val pendingIntentExpense = HomeWidgetLaunchIntent.getActivity(context,
                    MainActivity::class.java,
                    Uri.parse("pockettap://entry?type=expense"))
                setOnClickPendingIntent(R.id.btn_add_expense, pendingIntentExpense)
                
                setInt(R.id.burn_indicator, "setBackgroundColor", burnColor)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
