package com.smoothie.widgetFactory.view

import android.content.Context
import android.graphics.Insets
import android.util.AttributeSet
import android.view.View
import android.widget.FrameLayout
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat

abstract class InsetSizeDistributor : FrameLayout {

    constructor(context: Context) : super(context) {
        applyLayoutParameters()
    }

    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs) {
        applyLayoutParameters()
    }

    constructor(
        context: Context,
        attrs: AttributeSet?,
        defStyleAttr: Int
    ) : super(context, attrs, defStyleAttr) {
        applyLayoutParameters()
    }

    private fun applyLayoutParameters() {
        ViewCompat.setOnApplyWindowInsetsListener(this) { view, insets ->
            val mask = WindowInsetsCompat.Type.systemBars() or WindowInsetsCompat.Type.displayCutout()
            val actualInsets = insets.getInsets(mask)
            applyInsets(view, actualInsets)
            insets
        }
    }

    protected abstract fun applyInsets(view: View, insets: Insets)

}
