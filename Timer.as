// Timer and core logic extracted from Main.as

void OnTimerComplete() {
    g_isRunning = false;
    g_currentTime = 0;
    
    if (g_isBreak) {
        // Break finished, start work session
        g_isBreak = false;
        g_currentTime = g_workDuration;
        if (g_showNotifications) {
            UI::ShowNotification(Icons::Briefcase + " Back to work", "Break finished! Starting work session.", GetPrimaryColor(), g_notifyDurationMs);
        }
        PlayNotifySound();
    } else {
        // Work session finished
        g_sessionsCompleted++;
        g_isBreak = true;
        
        // Determine break type
        if (g_sessionsCompleted % g_longBreakInterval == 0) {
            g_currentTime = g_longBreakDuration;
            if (g_showNotifications) {
                UI::ShowNotification(Icons::Bed + " Long break", "Work session complete! Time for a long break.", GetPrimaryColor(), g_notifyDurationMs);
            }
            PlayNotifySound();
        } else {
            g_currentTime = g_shortBreakDuration;
            if (g_showNotifications) {
                UI::ShowNotification(Icons::Bed + " Short break", "Work session complete! Time for a short break.", GetPrimaryColor(), g_notifyDurationMs);
            }
            PlayNotifySound();
        }
    }
    
    // Auto-start next session if enabled
    if (g_autoStart) {
        StartTimer();
    }
}

void StartTimer() {
    if (g_currentTime <= 0) {
        ResetTimer();
    }
    g_isRunning = true;
    g_lastSecondUpdate = Time::Now; // Reset timing for accurate countdown
    print("Pomodoro Timer: Timer started");
}

void PauseTimer() {
    g_isRunning = false;
    print("Pomodoro Timer: Timer paused");
}

void ResetTimer() {
    g_isRunning = false;
    g_isBreak = false;
    g_currentTime = g_workDuration;
    print("Pomodoro Timer: Timer reset to work session");
}

string FormatTime(int totalSeconds) {
    if (totalSeconds < 0) totalSeconds = 0;
    
    int minutes = totalSeconds / 60;
    int seconds = totalSeconds % 60;
    
    string mins_str = "" + minutes;
    if (minutes < 10) mins_str = "0" + mins_str;
    
    string secs_str = "" + seconds;
    if (seconds < 10) secs_str = "0" + secs_str;
    
    return mins_str + ":" + secs_str;
}

void TimerLoop() {
    print("Pomodoro Timer: Starting timer loop...");
    g_lastSecondUpdate = Time::Now;
    
    while (true) {
        // Handle deferred font reload outside of rendering callbacks
        if (g_timerFontNeedsReload) {
            @g_timerFont = UI::LoadFont("DroidSans-Bold.ttf", g_timerFontSizePending);
            g_timerFontSizeCached = g_timerFontSizePending;
            g_timerFontNeedsReload = false;
        }
        // Ensure audio assets are loaded (in case plugin was hot-reloaded before assets were ready)
        if (g_notifySample is null) {
            LoadAudioAssets();
        }
        uint64 now = Time::Now;
        
        // Update timer every second when running
        if (g_isRunning && (now - g_lastSecondUpdate) >= 1000) {
            g_currentTime -= 1;
            g_lastSecondUpdate = now;
            
            // Check if timer finished
            if (g_currentTime <= 0) {
                OnTimerComplete();
            }
        }
        
        sleep(33); // ~30 FPS update rate
    }
}
