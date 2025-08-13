/**
 * Pomodoro Timer Plugin for Openplanet
 * A beautiful and effective Pomodoro technique timer to boost productivity
 * 
 * Features:
 * - 4 beautiful color themes (Green, Classic Blue, Blue, Purple)
 * - Customizable work and break durations
 * - Auto-start functionality
 * - Position saving
 * - Statistics tracking
 * - Sound and visual notifications
 * 
 * @version 1.0.0
 * @author tomekdot
 * @license MIT
 */

// ===== TIMER SETTINGS =====
[Setting category="Timer" name="Work duration (min)" description="Length of a focused work session" min=5 max=90]
int Setting_WorkDuration = 25;

[Setting category="Timer" name="Short break (min)" description="Quick break between work sessions" min=1 max=20] 
int Setting_ShortBreakDuration = 5;

[Setting category="Timer" name="Long break (min)" description="Extended break after multiple sessions" min=10 max=60]
int Setting_LongBreakDuration = 15;

[Setting category="Timer" name="Sessions before long break" description="How many work sessions before a long break" min=2 max=12]
int Setting_LongBreakInterval = 4;

[Setting category="Timer" name="Auto-start next session" description="Start the next session automatically when the current one ends"]
bool Setting_AutoStart = false;

// ===== NOTIFICATION SETTINGS =====
[Setting category="Notifications" name="Show notifications" description="Show a toast when a session starts or ends"]
bool Setting_PomodoroShowNotifications = true;

[Setting category="Notifications" name="Play sound" description="Play a sound when a session starts or ends"]
bool Setting_PomodoroPlaySounds = true;

[Setting category="Notifications" name="Test sound" description="Click to test the notification sound"]
bool Setting_PomodoroTestSound = false;

[Setting category="Notifications" name="Notification duration (seconds)" description="How long to show notifications" min=1 max=30]
int Setting_PomodoroNotificationSeconds = 5;

[Setting category="Notifications" name="Sound volume" description="Volume for notification sound (0.0 - 1.0)" min=0.0 max=1.0]
float Setting_PomodoroSoundGain = 0.8f;

// ===== INTERFACE SETTINGS =====
[Setting category="Appearance" name="UI scale" description="Scale the whole UI (0.5x–3.0x)" min=0.5 max=3.0]
float Setting_PomodoroOverlayScale = 1.0;

[Setting category="Overlay" name="Show overlay" description="Display the overlay window in-game"]
bool Setting_PomodoroOverlayVisible = true;

[Setting category="Appearance" name="Theme" description="Green (0), Classic Blue (1), Blue (2), Purple (3)" min=0 max=3]
int Setting_PomodoroTheme = 0;

[Setting category="Appearance" name="Use Openplanet theme" description="Use base Openplanet style (no custom colors)"]
bool Setting_PomodoroUseDefaultTheme = true;

[Setting category="Appearance" name="Theme variant" description="Light (0) or Dark (1)" min=0 max=1]
int Setting_PomodoroThemeVariant = 1;

[Setting category="Overlay" name="Auto-resize overlay" description="Automatically size the overlay to fit screen and content"]
bool Setting_PomodoroAutoScale = true;

[Setting category="Overlay" name="Auto-resize min scale" description="Lower bound for auto-resize scale" min=0.5 max=2.5]
float Setting_PomodoroAutoScaleMin = 0.8f;

[Setting category="Overlay" name="Auto-resize max scale" description="Upper bound for auto-resize scale" min=0.5 max=3.0]
float Setting_PomodoroAutoScaleMax = 1.8f;

// Timer text size override
[Setting category="Appearance" name="Custom timer text size" description="Override default font size for the time display"]
bool Setting_PomodoroCustomTimerText = true;

[Setting category="Appearance" name="Timer text size (px)" description="Font size for the time display when custom size is enabled" min=10 max=96]
int Setting_PomodoroTimerTextSize = 52;

// Overlay mode selection in Settings: 0 = Timer, 1 = Tasks, 2 = Compact, 3 = Stats
[Setting category="Overlay" name="Overlay mode" description="Timer (0), Tasks (1), Compact (2), Stats (3)" min=0 max=3]
int Setting_PomodoroOverlayMode = 0;

// ===== COMPACT MODE =====
[Setting category="Compact Mode" name="Show action buttons" description="Show Play/Pause, Reset, Skip buttons"]
bool Setting_CompactShowButtons = true;

[Setting category="Compact Mode" name="Show progress bar" description="Show the progress bar for the current session"]
bool Setting_CompactShowProgress = false;

[Setting category="Compact Mode" name="Show session stats" description="Show completed sessions count"]
bool Setting_CompactShowStats = false;

[Setting category="Compact Mode" name="Show tasks list" description="Show the tasks list panel"]
bool Setting_CompactShowTasks = false;

// ===== TASKS SETTINGS =====
[Setting category="Tasks" name="Prevent unchecking completed tasks" description="Lock tasks that are marked as done"]
bool Setting_PomodoroLockCompletedTasks = false;

// ===== HOTKEY SETTINGS =====
[Setting category="Hotkeys" name="Enable hotkeys" description="Allow controlling the timer with keyboard shortcuts"]
bool Setting_HotkeysEnabled = true;

[Setting category="Hotkeys" name="Show toast on hotkey" description="Show a small notification when a hotkey triggers"]
bool Setting_HotkeysShowToast = true;

[Setting category="Hotkeys" name="Start/Pause timer key"]
VirtualKey Setting_KeyStartPause = VirtualKey::F5;

[Setting category="Hotkeys" name="Reset timer key"]
VirtualKey Setting_KeyReset = VirtualKey::F6;

[Setting category="Hotkeys" name="Skip to next session key"]
VirtualKey Setting_KeySkip = VirtualKey::F8;

[Setting category="Hotkeys" name="Toggle overlay visibility key"]
VirtualKey Setting_KeyToggleOverlay = VirtualKey::F9;

[Setting category="Hotkeys" name="Cycle overlay mode key" description="Cycle between Timer, Tasks, and Compact modes"]
VirtualKey Setting_KeyCycleMode = VirtualKey::F10;

[Setting category="Hotkeys" name="Require Ctrl"]
bool Setting_KeyRequireCtrl = true;
[Setting category="Hotkeys" name="Require Shift"]
bool Setting_KeyRequireShift = false;
[Setting category="Hotkeys" name="Require Alt"]
bool Setting_KeyRequireAlt = false;

// ===== POSITIONING SETTINGS =====
[Setting category="Position" name="Type positions manually" description="Use the typed X/Y fields below instead of sliders"]
bool Setting_PomodoroPositionUseTyped = false;

[Setting category="Position" name="Overlay X" description="Horizontal position in pixels (slider or type)" min=0 max=2000]
int Setting_PomodoroOverlayPositionX = 100;

[Setting category="Position" name="Overlay Y" description="Vertical position in pixels (slider or type)" min=0 max=1500]
int Setting_PomodoroOverlayPositionY = 100;

[Setting category="Position" name="Overlay X (typed)" description="Type any horizontal pixel value"]
int Setting_PomodoroOverlayPositionX_Typed = 100;

[Setting category="Position" name="Overlay Y (typed)" description="Type any vertical pixel value"]
int Setting_PomodoroOverlayPositionY_Typed = 100;

// ===== ADVANCED SETTINGS =====
[Setting category="Advanced" name="Track statistics" description="Track completed sessions and productivity stats"]
bool Setting_PomodoroEnableStatistics = true;

[Setting category="Advanced" name="Allow manual resize" description="Allow manual resizing of the overlay window"]
bool Setting_PomodoroScalableWindow = false;

[Setting category="Advanced" name="Verbose logging" description="Enable detailed logging for debugging"]
bool Setting_VerboseLogging = false;


// Global state variables
bool g_isInitialized = false;
bool g_showOverlay = false;

// Timer settings (loaded from settings)
int g_workDuration = 25 * 60; // 25 minutes in seconds
int g_shortBreakDuration = 5 * 60; // 5 minutes in seconds
int g_longBreakDuration = 15 * 60; // 15 minutes in seconds
int g_longBreakInterval = 4; // Work sessions before long break

// Additional settings
bool g_autoStart = false; // Auto-start next session
bool g_showNotifications = true; // Show completion notifications
bool g_playSounds = true; // Play notification sounds
int g_notifyDurationMs = 5000; // Notification display time in ms
float g_soundGain = 0.8f; // Sound volume
float g_overlayScale = 1.0f; // UI scale factor
bool g_enableStatistics = true; // Track session statistics
bool g_lockCompleted = false; // Lock completed tasks from being unchecked
bool g_useDefaultTheme = false; // Force default theme regardless of selection
bool g_autoScale = true; // Auto scale per overlay
float g_autoScaleMin = 0.8f;
float g_autoScaleMax = 1.8f;

// Timer state
int g_currentTime = 0;
bool g_isRunning = false;
bool g_isBreak = false;
int g_sessionsCompleted = 0;

// Timing variables
uint64 g_lastSecondUpdate = 0;
uint64 g_lastSettingsUpdate = 0;

// UI state
vec2 g_overlayPos = vec2(100, 100);
vec2 g_overlaySize = vec2(300, 200);

// Auto-fit tracking for dynamic content/scale/resolution changes
int g_lastOverlayMode = -1;
float g_lastEffScale = 0.0f;
int g_lastScreenW = -1;
int g_lastScreenH = -1;
int g_autoFitFrames = 0; // when > 0, force AlwaysAutoResize for a few frames

// Fonts
UI::Font@ g_timerFont = null;
int g_timerFontSizeCached = 0;
bool g_timerFontNeedsReload = false;
int g_timerFontSizePending = 0;

// Audio
Audio::Sample@ g_notifySample = null;
bool g_notifyAttempted = false; // prevent repeated load attempts/log spam

// Canonical relative path to the bundled notification sound (inside the plugin folder)
const string kNotifySoundRel = "assets/sounds/776181__soundandmelodies__sfx-notification1-interface-gui.wav";

// Keys currently held (for combo detection)
array<VirtualKey> g_keysDown;

// UI confirmations
bool g_clearAllConfirm = false;
uint64 g_clearAllConfirmUntil = 0;


/**
 * Log a message if verbose logging is enabled
 */
void LogVerbose(const string &in message) {
    if (Setting_VerboseLogging) {
        print("[Pomodoro Timer] " + message);
    }
}

/**
 * Plugin entry point - called when plugin loads
 */
void Main() {
    LogVerbose("Initializing plugin...");
    InitializePlugin();
}

/**
 * Initialize plugin
 */
void InitializePlugin() {
    if (g_isInitialized) return;
    
    LogVerbose("Setting up initial state...");
    
    // Load settings from Openplanet
    LoadSettings();
    
    // Reset timer to work session
    ResetTimer();
    
    // Start timer loop coroutine
    startnew(CoroutineFunc(TimerLoop));

    // Load audio assets (outside render callbacks)
    LoadAudioAssets();
    
    // Load tasks from storage
    LoadTasks();
    LoadTaskStats();

    g_isInitialized = true;
    
    LogVerbose("Plugin initialized successfully");
}

/**
 * Load settings from Openplanet settings system
 */
void LoadSettings() {
    g_workDuration = Setting_WorkDuration * 60; // Convert minutes to seconds
    g_shortBreakDuration = Setting_ShortBreakDuration * 60;
    g_longBreakDuration = Setting_LongBreakDuration * 60;
    g_longBreakInterval = Setting_LongBreakInterval;
    g_autoStart = Setting_AutoStart;
    g_showNotifications = Setting_PomodoroShowNotifications;
    g_playSounds = Setting_PomodoroPlaySounds;
    g_notifyDurationMs = Math::Clamp(Setting_PomodoroNotificationSeconds, 1, 30) * 1000;
    g_soundGain = Math::Clamp(Setting_PomodoroSoundGain, 0.0f, 1.0f);
    g_overlayScale = Setting_PomodoroOverlayScale; // manual default; may be overridden by auto in RenderOverlay
    g_autoScale = Setting_PomodoroAutoScale;
    g_autoScaleMin = Setting_PomodoroAutoScaleMin;
    g_autoScaleMax = Setting_PomodoroAutoScaleMax;
    g_enableStatistics = Setting_PomodoroEnableStatistics;
    g_lockCompleted = Setting_PomodoroLockCompletedTasks;
    g_useDefaultTheme = Setting_PomodoroUseDefaultTheme;
    
    // Handle test sound button
    if (Setting_PomodoroTestSound) {
        Setting_PomodoroTestSound = false; // Reset the button
        PlayTestSound();
    }
    
    // Mark font reload if size changed (defer actual load to non-render context)
    if (Setting_PomodoroCustomTimerText) {
        if (g_timerFont is null || Setting_PomodoroTimerTextSize != g_timerFontSizeCached) {
            g_timerFontSizePending = Setting_PomodoroTimerTextSize;
            g_timerFontNeedsReload = true;
        }
    } else {
        @g_timerFont = null; // revert to default font
    }
    
    // Update overlay position (respect chosen input method)
    if (Setting_PomodoroPositionUseTyped) {
        g_overlayPos = vec2(float(Setting_PomodoroOverlayPositionX_Typed), float(Setting_PomodoroOverlayPositionY_Typed));
    } else {
        g_overlayPos = vec2(float(Setting_PomodoroOverlayPositionX), float(Setting_PomodoroOverlayPositionY));
    }
    
    LogVerbose("Settings loaded - Work: " + Setting_WorkDuration + "m, Break: " + Setting_ShortBreakDuration + "m, Theme: " + Setting_PomodoroTheme);
}

// Load bundled audio samples (robust path search + single warning)
void LoadAudioAssets() {
    if (g_notifySample !is null || g_notifyAttempted) return;
    g_notifyAttempted = true;

    // Single canonical relative path
    const string rel = kNotifySoundRel;
    @g_notifySample = Audio::LoadSample(rel);
    if (g_notifySample !is null) {
        LogVerbose("Notification sound loaded: " + rel);
        return;
    }

    // Absolute-path fallback via plugin SourcePath
    auto@ self = Meta::ExecutingPlugin();
    if (self !is null) {
        string base = self.SourcePath;
        if (base.Length > 0) {
            string sep = "/";
            if (!base.EndsWith("/") && !base.EndsWith("\\")) base += sep;
            string absPath = base + rel;
            @g_notifySample = Audio::LoadSampleFromAbsolutePath(absPath);
            if (g_notifySample !is null) {
                LogVerbose("Notification sound loaded (abs): " + absPath);
                return;
            }
        }
    }

}

// Play notification sound if enabled and loaded
void PlayNotifySound() {
    if (!g_playSounds) return;
    if (g_notifySample is null) {
        // attempt a one-time load
        LoadAudioAssets();
    }
    if (g_notifySample !is null) {
        Audio::Play(g_notifySample, g_soundGain);
    }
}

// Force-play test sound regardless of the Play Sounds setting
void PlayTestSound() {
    if (g_notifySample is null) {
        // Allow a forced retry when the user clicks test in Settings
        g_notifyAttempted = false;
        LoadAudioAssets();
    }
    if (g_notifySample !is null) {
        // Ensure an audible test even if gain is set to 0
        float testGain = g_soundGain;
        if (testGain <= 0.0f) testGain = 0.2f;
        Audio::Play(g_notifySample, testGain);
    } else {
        warn("Pomodoro Timer: Test sound failed — sample not loaded.");
    }
}

// Helpers to draw the main timer text with optional custom font size
void PushTimerFont() {
    if (Setting_PomodoroCustomTimerText && g_timerFont !is null) {
        UI::PushFont(g_timerFont);
    } else {
        UI::PushFont(UI::Font::DefaultBold);
    }
}

// Helper to pop the timer font
void PopTimerFont() {
    UI::PopFont();
}

/**
 * Save settings to Openplanet settings system
 */
void SaveSettings() {
    Setting_WorkDuration = g_workDuration / 60; // Convert seconds to minutes
    Setting_ShortBreakDuration = g_shortBreakDuration / 60;
    Setting_LongBreakDuration = g_longBreakDuration / 60;
    Setting_LongBreakInterval = g_longBreakInterval;
    Setting_AutoStart = g_autoStart;
    Setting_PomodoroShowNotifications = g_showNotifications;
    Setting_PomodoroPlaySounds = g_playSounds;
    if (!g_autoScale) {
        // only persist manual scale when auto-scaling is disabled
        Setting_PomodoroOverlayScale = g_overlayScale;
    }
    Setting_PomodoroEnableStatistics = g_enableStatistics;
    Setting_PomodoroLockCompletedTasks = g_lockCompleted;
    Setting_PomodoroOverlayVisible = g_showOverlay;
    // Keep both variants in sync when user moves the window
    int px = int(g_overlayPos.x);
    int py = int(g_overlayPos.y);
    Setting_PomodoroOverlayPositionX = px;
    Setting_PomodoroOverlayPositionY = py;
    Setting_PomodoroOverlayPositionX_Typed = px;
    Setting_PomodoroOverlayPositionY_Typed = py;
    Setting_PomodoroUseDefaultTheme = g_useDefaultTheme;
}

/**
 * Called every frame to render UI
 */
void Render() {
    if (!g_isInitialized) return;
    
    // Refresh settings every frame to pick up changes from settings menu
    if (Time::Now - g_lastSettingsUpdate > 1000) { // Check every second
        LoadSettings();
        g_lastSettingsUpdate = Time::Now;
    }
    
    if (g_showOverlay) {
        RenderOverlay();
        // If overlay was closed via X button, update the setting
        if (!g_showOverlay && Setting_PomodoroOverlayVisible) {
            Setting_PomodoroOverlayVisible = false;
        }
    }

}

/**
 * Render menu items
 */
void RenderMenu() {
    if (UI::MenuItem(Icons::Clock + " Toggle Pomodoro Timer", "", g_showOverlay)) {
        g_showOverlay = !g_showOverlay;
        Setting_PomodoroOverlayVisible = g_showOverlay;
    }
}

// ===== Hotkeys handling =====
void OnKeyPress(bool down, VirtualKey key) {
    if (!Setting_HotkeysEnabled) return;

    // Track keys held for combo detection
    int idx = g_keysDown.Find(key);
    if (down) {
        if (idx < 0) g_keysDown.InsertLast(key);
        return; // only act on key release
    } else {
        if (idx >= 0) g_keysDown.RemoveAt(idx);
    }

    // Only trigger on release of an action key when modifiers match
    if (!ModifiersSatisfied()) return;

    if (key == Setting_KeyStartPause) {
        if (g_isRunning) { PauseTimer(); } else { StartTimer(); }
        HotkeyToast(g_isRunning ? "Start" : "Pause");
        return;
    }
    if (key == Setting_KeyReset) {
        ResetTimer();
        HotkeyToast("Reset");
        return;
    }
    if (key == Setting_KeySkip) {
        OnTimerComplete();
        HotkeyToast("Skip");
        return;
    }
    if (key == Setting_KeyToggleOverlay) {
        g_showOverlay = !g_showOverlay;
        Setting_PomodoroOverlayVisible = g_showOverlay;
        HotkeyToast(g_showOverlay ? "Overlay ON" : "Overlay OFF");
        return;
    }
    if (key == Setting_KeyCycleMode) {
        Setting_PomodoroOverlayMode = (Setting_PomodoroOverlayMode + 1) % 4;
        string modeName = "Unknown";
        if (Setting_PomodoroOverlayMode == 0) modeName = "Timer";
        else if (Setting_PomodoroOverlayMode == 1) modeName = "Tasks";
        else if (Setting_PomodoroOverlayMode == 2) modeName = "Compact";
        else if (Setting_PomodoroOverlayMode == 3) modeName = "Stats";
        HotkeyToast("Mode: " + modeName);
        return;
    }
}

bool ModifiersSatisfied() {
    bool haveCtrl = g_keysDown.Find(VirtualKey::Control) >= 0 || g_keysDown.Find(VirtualKey::LControl) >= 0 || g_keysDown.Find(VirtualKey::RControl) >= 0;
    bool haveShift = g_keysDown.Find(VirtualKey::Shift) >= 0 || g_keysDown.Find(VirtualKey::LShift) >= 0 || g_keysDown.Find(VirtualKey::RShift) >= 0;
    bool haveAlt = g_keysDown.Find(VirtualKey::Menu) >= 0 || g_keysDown.Find(VirtualKey::LMenu) >= 0 || g_keysDown.Find(VirtualKey::RMenu) >= 0;
    if (Setting_KeyRequireCtrl && !haveCtrl) return false;
    if (Setting_KeyRequireShift && !haveShift) return false;
    if (Setting_KeyRequireAlt && !haveAlt) return false;
    // If a modifier is not required, we do not restrict its presence
    return true;
}

void HotkeyToast(const string &in msg) {
    if (!Setting_HotkeysShowToast) return;
    UI::ShowNotification(Icons::KeyboardO + " Pomodoro", msg, 1200);
}