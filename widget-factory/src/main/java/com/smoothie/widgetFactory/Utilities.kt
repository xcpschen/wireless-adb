package com.smoothie.widgetFactory

import android.graphics.Insets
import android.view.View
import androidx.core.graphics.Insets as CoreInsets
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

fun getInsets(
    view: View,
    typeMask: Int = WindowInsetsCompat.Type.systemBars() or WindowInsetsCompat.Type.displayCutout()
): Insets {
    // 使用兼容 API 21+ 的方式
    val coreInsets = ViewCompat.getRootWindowInsets(view)?.getInsets(typeMask) 
        ?: CoreInsets.of(0, 0, 0, 0)
    // 转换为 android.graphics.Insets
    return Insets.of(coreInsets.left, coreInsets.top, coreInsets.right, coreInsets.bottom)
}
