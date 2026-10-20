package com.example.toktik

import android.content.ComponentName
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channel = "toktik/app_icon"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                if (call.method == "setSeasonIcon") {
                    val season = call.argument<String>("season") ?: "normal"
                    try {
                        applySeasonIcon(season)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("ICON_ERROR", e.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    /// Activa el icono de la temporada y desactiva los demás.
    ///
    /// Solo se tocan los activity-alias (uno por temporada). La MainActivity
    /// NO se deshabilita nunca: `flutter run` la lanza directamente por su
    /// nombre, y si estuviera deshabilitada el arranque fallaría con
    /// "Activity class does not exist".
    ///
    /// En builds de depuración se deja SIEMPRE habilitado `.NormalIcon`
    /// porque `flutter run` lanza el primer activity-alias con filtro
    /// LAUNCHER del manifest (que es `.NormalIcon`), sin importar cuál esté
    /// habilitado en ese momento. Si se deshabilitara, `flutter run` fallaría
    /// con "Activity class does not exist" al probar otra temporada.
    /// En release solo queda habilitado el icono de la temporada activa.
    private fun applySeasonIcon(season: String) {
        val pm = packageManager
        val aliases = mapOf(
            "normal" to ComponentName(this, "com.example.toktik.NormalIcon"),
            "halloween" to ComponentName(this, "com.example.toktik.HalloweenIcon"),
            "christmas" to ComponentName(this, "com.example.toktik.ChristmasIcon"),
            "valentine" to ComponentName(this, "com.example.toktik.ValentineIcon")
        )
        val selected = aliases[season] ?: aliases.getValue("normal")
        val debuggable = (applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0

        aliases.forEach { (key, component) ->
            val enabled = component == selected || (debuggable && key == "normal")
            pm.setComponentEnabledSetting(
                component,
                if (enabled)
                    PackageManager.COMPONENT_ENABLED_STATE_ENABLED
                else
                    PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP
            )
        }
    }
}
