package com.smoothie.widgetFactory

import android.graphics.Insets
import android.graphics.Rect
import android.os.Build
import android.view.View
import android.view.WindowInsets
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

fun getInsets(
    view: View,
    typeMask: Int = WindowInsetsCompat.Type.systemBars() or WindowInsetsCompat.Type.displayCutout()
): Insets {
    // 使用兼容 API 21+ 的方式
    return ViewCompat.getRootWindowInsets(view)?.getInsets(typeMask) 
        ?: Insets.of(0, 0, 0, 0)
}
