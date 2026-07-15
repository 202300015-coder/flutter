package com.example.flutter_application_1

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val channelName = "alazar_notifications"
	private val notificationId = 1001
	private val notificationChannelId = "alazar_music_state"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"updateMusicNotification" -> {
						val title = call.argument<String>("title") ?: "Reproduciendo música"
						val body = call.argument<String>("body") ?: ""
						val state = call.argument<String>("state") ?: "paused"
						showOrUpdateNotification(title, body, state)
						result.success(null)
					}
					"clearMusicNotification" -> {
						clearNotification()
						result.success(null)
					}
					else -> result.notImplemented()
				}
			}

		createNotificationChannel()
	}

	private fun createNotificationChannel() {
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			val channel = NotificationChannel(
				notificationChannelId,
				"Estado de reproducción",
				NotificationManager.IMPORTANCE_LOW
			).apply {
				description = "Notificaciones de estado para reproducción de música"
				setShowBadge(false)
				enableVibration(false)
				enableLights(false)
			}

			val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
			manager.createNotificationChannel(channel)
		}
	}

	private fun showOrUpdateNotification(title: String, body: String, state: String) {
		val contentText = when (state) {
			"playing" -> body.ifBlank { "La música se está reproduciendo." }
			"paused" -> body.ifBlank { "La música está en pausa." }
			"stopped" -> body.ifBlank { "La reproducción se detuvo." }
			else -> body.ifBlank { "Estado de reproducción actualizado." }
		}

		val notification = NotificationCompat.Builder(this, notificationChannelId)
			.setSmallIcon(android.R.drawable.ic_media_play)
			.setContentTitle(title)
			.setContentText(contentText)
			.setStyle(NotificationCompat.BigTextStyle().bigText(contentText))
			.setPriority(NotificationCompat.PRIORITY_LOW)
			.setOngoing(state == "playing")
			.setOnlyAlertOnce(true)
			.setAutoCancel(false)
			.build()

		NotificationManagerCompat.from(this).notify(notificationId, notification)
	}

	private fun clearNotification() {
		NotificationManagerCompat.from(this).cancel(notificationId)
	}
}
