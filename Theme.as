// Theme and color utilities extracted from Main.as

// Primary color selection based on settings
vec4 GetPrimaryColor() {
    // When default theme is on, colors won't be pushed; return a sane value anyway.
    if (g_useDefaultTheme) return vec4(0.26f, 0.59f, 0.98f, 1.0f);
    switch (Setting_PomodoroTheme) {
        case 0: return vec4(0.2f, 0.7f, 0.3f, 1.0f); // Green
        case 1: return vec4(0.26f, 0.59f, 0.98f, 1.0f); // Classic Blue
        case 2: return vec4(0.4f, 0.5f, 0.9f, 1.0f); // Blue
        case 3: return vec4(0.7f, 0.4f, 0.8f, 1.0f); // Purple
        default: return vec4(0.2f, 0.7f, 0.3f, 1.0f); // Default Green
    }
}

// Color helpers for light/dark variants
vec4 _Mix(const vec4 &in a, const vec4 &in b, float t) {
    float it = 1.0f - t;
    return vec4(a.x * it + b.x * t, a.y * it + b.y * t, a.z * it + b.z * t, a.w); // keep original alpha
}

vec4 _Lighten(const vec4 &in c, float t) { // t in [0,1]
    return _Mix(c, vec4(1.0f, 1.0f, 1.0f, c.w), t);
}

vec4 _Darken(const vec4 &in c, float t) { // t in [0,1]
    return _Mix(c, vec4(0.0f, 0.0f, 0.0f, c.w), t);
}

void GetThemePalette(vec4 &out titleBg, vec4 &out button, vec4 &out hover, vec4 &out active, vec4 &out frameBg, vec4 &out windowBg, vec4 &out textCol, vec4 &out checkCol) {
    vec4 base = GetPrimaryColor();
    // Base frame background alpha depending on variant
    if (Setting_PomodoroThemeVariant == 0) { // Light
        // Slightly lighten base for title and buttons
        titleBg = _Lighten(base, 0.10f);
        // Make title bar itself semi-transparent for a lighter look
        titleBg.w = 0.18f;
        button = _Lighten(base, 0.15f);
        hover  = _Lighten(base, 0.25f);
        active = _Lighten(base, 0.05f);
        frameBg = vec4(1.0f, 1.0f, 1.0f, 0.04f); // lighter frame bg
        // White, very transparent window background
        windowBg = vec4(1.0f, 1.0f, 1.0f, 0.02f);
        textCol = vec4(1.0f, 1.0f, 1.0f, 1.0f);
        checkCol = _Darken(base, 0.05f);
    } else { // Dark
        titleBg = _Darken(base, 0.10f);
        button = _Darken(base, 0.05f);
        hover  = _Lighten(button, 0.10f); // slight lift on hover
        active = _Darken(base, 0.20f);
        frameBg = vec4(0.10f, 0.10f, 0.10f, 0.50f); // darker translucent frame bg
        windowBg = vec4(0.06f, 0.06f, 0.06f, 0.94f);
        textCol = vec4(1.0f, 1.0f, 1.0f, 1.0f);
        checkCol = _Lighten(base, 0.10f);
    }
}
