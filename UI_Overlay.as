// Overlay and UI rendering extracted from Main.as

// Renders the mode selection buttons (Timer, Tasks, Compact, Stats)
void RenderModeSwitcher(float scale, const vec4 &in activeColor) {
    float buttonSize = 35 * scale;
    vec2 buttonVec = vec2(buttonSize, buttonSize);

    // Timer button
    if (UI::Button(Icons::Clock, buttonVec)) Setting_PomodoroOverlayMode = 0;
    if (UI::IsItemHovered()) UI::SetTooltip("Timer");
    UI::SameLine();

    // Tasks button
    if (UI::Button(Icons::Briefcase, buttonVec)) Setting_PomodoroOverlayMode = 1;
    if (UI::IsItemHovered()) UI::SetTooltip("Tasks");
    UI::SameLine();

    // Compact button
    if (UI::Button(Icons::Sliders, buttonVec)) Setting_PomodoroOverlayMode = 2;
    if (UI::IsItemHovered()) UI::SetTooltip("Compact Mode");
    UI::SameLine();

    // Stats button
    if (UI::Button(Icons::BarChart, buttonVec)) Setting_PomodoroOverlayMode = 3;
    if (UI::IsItemHovered()) UI::SetTooltip("Stats");
}

void RenderOverlay() {
    // Get theme colors based on setting
    vec4 primaryColor = GetPrimaryColor();
    vec4 titleBg, btnColor, btnHover, btnActive, frameBg, windowBg, textCol, checkCol;
    GetThemePalette(titleBg, btnColor, btnHover, btnActive, frameBg, windowBg, textCol, checkCol);
    vec4 textDisabledCol = vec4(textCol.x, textCol.y, textCol.z, Math::Min(textCol.w, 0.6f));

    // Determine effective scale
    float effScale = g_overlayScale;
    if (g_autoScale) {
        float targetW = 360.0f, targetH = 260.0f;
        if (Setting_PomodoroOverlayMode == 1) targetH = 300.0f; // Tasks
        else if (Setting_PomodoroOverlayMode == 2) targetH = 120.0f; // Compact
        else if (Setting_PomodoroOverlayMode == 3) targetH = 280.0f; // Stats
        float fitW = float(Draw::GetWidth()) * 0.30f / targetW;
        float fitH = float(Draw::GetHeight()) * 0.35f / targetH;
        effScale = Math::Clamp(Math::Min(fitW, fitH), g_autoScaleMin, g_autoScaleMax);
    }

    // Detect changes that should trigger auto-fit
    int curScreenW = Draw::GetWidth();
    int curScreenH = Draw::GetHeight();
    bool modeChanged = (Setting_PomodoroOverlayMode != g_lastOverlayMode);
    bool scaleChanged = Math::Abs(effScale - g_lastEffScale) > 0.001f;
    bool resChanged = (curScreenW != g_lastScreenW) || (curScreenH != g_lastScreenH);
    if (modeChanged || scaleChanged || resChanged) {
        g_autoFitFrames = 3;
        g_lastOverlayMode = Setting_PomodoroOverlayMode;
        g_lastEffScale = effScale;
        g_lastScreenW = curScreenW;
        g_lastScreenH = curScreenH;
    }

    // Apply UI scaling and colors
        UI::PushStyleVar(UI::StyleVar::WindowPadding, vec2(12 * effScale, 12 * effScale));
        UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(8 * effScale, 6 * effScale));
        UI::PushStyleVar(UI::StyleVar::FramePadding, vec2(6 * effScale, 4 * effScale));
        int colorsPushed = 0;
        if (!g_useDefaultTheme) {
            UI::PushStyleColor(UI::Col::WindowBg, windowBg); colorsPushed++;
            UI::PushStyleColor(UI::Col::TitleBgActive, titleBg); colorsPushed++;
            UI::PushStyleColor(UI::Col::Button, btnColor); colorsPushed++;
            UI::PushStyleColor(UI::Col::ButtonHovered, btnHover); colorsPushed++;
            UI::PushStyleColor(UI::Col::ButtonActive, btnActive); colorsPushed++;
            UI::PushStyleColor(UI::Col::FrameBg, frameBg); colorsPushed++;
            UI::PushStyleColor(UI::Col::Text, textCol); colorsPushed++;
            UI::PushStyleColor(UI::Col::TextDisabled, textDisabledCol); colorsPushed++;
            UI::PushStyleColor(UI::Col::CheckMark, checkCol); colorsPushed++;
            UI::PushStyleColor(UI::Col::PlotHistogram, primaryColor); colorsPushed++;
        }

    // Set window position
    vec2 desiredPos = Setting_PomodoroPositionUseTyped
        ? vec2(float(Setting_PomodoroOverlayPositionX_Typed), float(Setting_PomodoroOverlayPositionY_Typed))
        : vec2(float(Setting_PomodoroOverlayPositionX), float(Setting_PomodoroOverlayPositionY));
    UI::SetNextWindowPos(int(desiredPos.x), int(desiredPos.y), UI::Cond::FirstUseEver);

    // Set initial window size based on mode
    float defW = 220.0f * effScale;
    float defH = 170.0f * effScale; // Timer mode
    if (Setting_PomodoroOverlayMode == 1) { // Tasks
        defW = 360.0f * effScale;
        defH = 300.0f * effScale;
    } else if (Setting_PomodoroOverlayMode == 2) { // Compact
        defW = 200.0f * effScale;
        defH = 100.0f * effScale;
    } else if (Setting_PomodoroOverlayMode == 3) { // Stats
        defW = 320.0f * effScale;
        defH = 280.0f * effScale;
    }
    UI::SetNextWindowSize(int(defW), int(defH), UI::Cond::FirstUseEver);

    // Set window flags (auto-resize is key)
    UI::WindowFlags windowFlags = UI::WindowFlags::NoCollapse;
    if (g_autoFitFrames > 0 || !Setting_PomodoroScalableWindow) {
        windowFlags = UI::WindowFlags(windowFlags | UI::WindowFlags::AlwaysAutoResize);
    }

    // Begin window
    bool windowOpen = UI::Begin("Pomodoro Timer", g_showOverlay, windowFlags);
    if (windowOpen) {
            g_overlaySize = UI::GetWindowSize();
            g_overlayPos = UI::GetWindowPos();

            // Render mode switcher
            RenderModeSwitcher(effScale, btnActive);
            UI::Separator();

            // Render the correct UI based on mode
            if (Setting_PomodoroOverlayMode == 1) {
                RenderTasksUI(effScale);
            } else if (Setting_PomodoroOverlayMode == 2) {
                RenderCompactUI(effScale);
            } else if (Setting_PomodoroOverlayMode == 3) {
                RenderStatsUI(effScale);
            } else {
                RenderTimerUI(effScale);
            }
        }
        UI::End();
        if (!g_showOverlay) {
            if (colorsPushed > 0) UI::PopStyleColor(colorsPushed);
            UI::PopStyleVar(3);
            return;
        }

        // Pop styles
        if (g_autoFitFrames > 0) g_autoFitFrames--;
        if (colorsPushed > 0) UI::PopStyleColor(colorsPushed);
        UI::PopStyleVar(3);
}

// ===== Tasks UI (Mode 1) =====
void RenderTasksUI(float scale) {
    // This is a combination of the timer header and the tasks panel
    RenderCompactTimerHeader(scale);
    UI::Separator();
    RenderTasksPanelOnly(scale);
}

// ===== Compact UI (Mode 2) =====
void RenderCompactUI(float scale) {
    // A highly configurable, minimal view.
    
    // Always show timer text
    PushTimerFont();
    UI::Text(FormatTime(g_currentTime));
    PopTimerFont();

    // Optional: Progress Bar
    if (Setting_CompactShowProgress) {
        UI::Dummy(vec2(0, 2 * scale));
        int totalDuration = g_isBreak ? (g_sessionsCompleted % g_longBreakInterval == 0 ? g_longBreakDuration : g_shortBreakDuration) : g_workDuration;
        float progress = (totalDuration > 0) ? 1.0f - (float(g_currentTime) / float(totalDuration)) : 0.0f;
        bool onlyBar = !Setting_CompactShowStats && !Setting_CompactShowButtons && !Setting_CompactShowTasks;
        float barWidth = onlyBar ? Math::Min(165.0f * scale, UI::GetContentRegionAvail().x) : -1;
        UI::ProgressBar(progress, vec2(barWidth, 5 * scale));
    }

    // Optional: Session Stats
    if (Setting_CompactShowStats) {
        UI::Dummy(vec2(0, 4 * scale));
        string sessionIcon = g_isBreak ? Icons::Bed : Icons::Briefcase;
        string sessionType = g_isBreak ? "Break" : "Work Session";
        UI::Text(sessionIcon + " " + sessionType);

        string sessionsText = Icons::BarChart + " " + g_sessionsCompleted + "/" + g_longBreakInterval;
        UI::Text(sessionsText);
        if (UI::IsItemHovered()) UI::SetTooltip("Sessions completed / Sessions until long break");
    }

    // Optional: Action Buttons
    if (Setting_CompactShowButtons) {
        UI::Dummy(vec2(0, 4 * scale));
        float btn = 40 * scale;
        float itemSpacingX = 8 * scale;
        float totalWidth = btn * 3 + itemSpacingX * 2;
        float avail = UI::GetContentRegionAvail().x;
        float offset = (avail > totalWidth) ? (avail - totalWidth) * 0.5f : 0.0f;
        if (offset > 0.0f) UI::Dummy(vec2(offset, 0));

        if (g_isRunning) {
            if (UI::Button(Icons::Pause, vec2(btn, btn))) PauseTimer();
        } else {
            if (UI::Button(Icons::Play, vec2(btn, btn))) StartTimer();
        }
        UI::SameLine(0, itemSpacingX);
        if (UI::Button(Icons::Refresh, vec2(btn, btn))) ResetTimer();
        UI::SameLine(0, itemSpacingX);
        if (UI::Button(Icons::FastForward, vec2(btn, btn))) OnTimerComplete();
    }

    // Optional: Tasks List
    if (Setting_CompactShowTasks) {
        UI::Separator();
        RenderTasksPanelOnly(scale);
    }
}


// ===== Shared Components =====

// Shared compact timer header for Tasks UI
void RenderCompactTimerHeader(float scale) {
    string timeStr = FormatTime(g_currentTime);
    PushTimerFont();
    UI::Text(timeStr);
    PopTimerFont();

    int totalDuration = g_isBreak ? (g_sessionsCompleted % g_longBreakInterval == 0 ? g_longBreakDuration : g_shortBreakDuration) : g_workDuration;
    float progress = (totalDuration > 0) ? 1.0f - (float(g_currentTime) / float(totalDuration)) : 0.0f;
    UI::ProgressBar(progress, vec2(-1, 5 * scale));

    float btn = 40 * scale;
    if (g_isRunning) {
        if (UI::Button(Icons::Pause, vec2(btn, btn))) PauseTimer();
    } else {
        if (UI::Button(Icons::Play, vec2(btn, btn))) StartTimer();
    }
    UI::SameLine();
    if (UI::Button(Icons::Refresh, vec2(btn, btn))) ResetTimer();
    UI::SameLine();
    if (UI::Button(Icons::FastForward, vec2(btn, btn))) OnTimerComplete();
}

// Shared Tasks body (input + list + footer actions)
void RenderTasksPanelOnly(float scale) {
    // Input to add task
    UI::PushItemWidth(-90 * scale);
    bool addClicked = false;
    bool pressedEnter = false;
    if (g_focusNewTaskInput) {
        UI::SetKeyboardFocusHere();
        g_focusNewTaskInput = false;
    }
    string newVal = UI::InputText("##newtask", g_newTaskText, pressedEnter, UI::InputTextFlags::EnterReturnsTrue);
    if (newVal != g_newTaskText) g_newTaskText = newVal;
    UI::SameLine();
    if (UI::Button(Icons::Plus + " Add", vec2(80 * scale, 0))) addClicked = true;
    UI::PopItemWidth();
    if ((addClicked || pressedEnter)) {
        string trimmed = g_newTaskText.Trim();
        if (trimmed.Length > 0) {
            g_tasks.InsertLast(Task(trimmed, false));
            g_newTaskText = "";
            SaveTasks();
            g_focusNewTaskInput = true;
        }
    }

    UI::Dummy(vec2(0, 6 * scale));

    // Tasks list
    if (UI::BeginChild("tasks-list", vec2(-1, 140 * scale))) {
        if (UI::BeginTable("tasks-table", 2, UI::TableFlags::SizingStretchProp)) {
            UI::TableSetupColumn("task", UI::TableColumnFlags::WidthStretch);
            UI::TableSetupColumn("del", UI::TableColumnFlags::WidthFixed, 40 * scale);
            for (int i = int(g_tasks.Length) - 1; i >= 0; i--) {
                UI::PushID(i);
                UI::TableNextRow();
                UI::TableNextColumn();

                bool isDone = g_tasks[i].done;
                string label = g_tasks[i].text;
                
                bool prev = isDone;
                if (g_lockCompleted && isDone) {
                    UI::BeginDisabled();
                    UI::Checkbox((label) + "##task" + i, prev);
                    UI::EndDisabled();
                } else {
                    bool now = UI::Checkbox((label) + "##task" + i, prev);
                    if (now != g_tasks[i].done) {
                        g_tasks[i].done = now;
                        SaveTasks();
                        if (now) RecordTaskCompletedEvent();
                    }
                }

                UI::TableNextColumn();
                if (UI::Button(Icons::Trash)) {
                    g_tasks.RemoveAt(i);
                    SaveTasks();
                    UI::PopID();
                    continue;
                }
                UI::PopID();
            }
            UI::EndTable();
        }
    }
    UI::EndChild();

    // Footer actions
    int doneCount = 0;
    for (uint j = 0; j < g_tasks.Length; j++) if (g_tasks[j].done) doneCount++;
    UI::Text("Completed " + doneCount + "/" + g_tasks.Length +
        "  |  Today: " + GetTodayCompletions() +
        "  |  7d: " + GetLast7DaysCompletions() +
        "  |  Total: " + g_statsTotalCompleted);
    if (UI::IsItemHovered()) UI::SetTooltip("Counts are based on when tasks are checked.");
    UI::SameLine();
    if (UI::Button("Reset stats")) {
        ResetTaskStats();
    }

    if (UI::Button("Clear completed")) {
        for (int i = int(g_tasks.Length) - 1; i >= 0; i--) if (g_tasks[i].done) g_tasks.RemoveAt(i);
        SaveTasks();
    }
    UI::SameLine();
    if (!g_clearAllConfirm) {
        if (UI::Button("Clear all")) {
            g_clearAllConfirm = true;
            g_clearAllConfirmUntil = Time::Now + 3000;
        }
    } else {
        UI::PushStyleColor(UI::Col::Button, vec4(0.8f, 0.2f, 0.2f, 1.0f));
        bool doClear = UI::Button("Confirm clear (3s)");
        UI::PopStyleColor();
        if (doClear) {
            g_tasks.RemoveRange(0, g_tasks.Length);
            SaveTasks();
            g_clearAllConfirm = false;
        } else if (Time::Now > g_clearAllConfirmUntil) {
            g_clearAllConfirm = false;
        }
    }
}

// Full Timer overlay UI (mode 0)
void RenderTimerUI(float scale) {
    // Time
    string timeStr = FormatTime(g_currentTime);
    PushTimerFont();
    UI::Text(timeStr);
    PopTimerFont();

    // Progress
    int totalDuration = g_isBreak ? (g_sessionsCompleted % g_longBreakInterval == 0 ? g_longBreakDuration : g_shortBreakDuration) : g_workDuration;
    float progress = (totalDuration > 0) ? 1.0f - (float(g_currentTime) / float(totalDuration)) : 0.0f;
    UI::ProgressBar(progress, vec2(-1, 6 * scale));

    UI::Dummy(vec2(0, 10 * scale));

    // Session info
    string sessionIcon = g_isBreak ? Icons::Bed : Icons::Briefcase;
    string sessionType = g_isBreak ? "Break" : "Work Session";
    UI::Text(sessionIcon + " " + sessionType);

    string sessionsText = Icons::BarChart + " " + g_sessionsCompleted + "/" + g_longBreakInterval;
    UI::Text(sessionsText);
    if (UI::IsItemHovered()) UI::SetTooltip("Sessions completed / Sessions until long break");

    UI::Dummy(vec2(0, 10 * scale));

    // Controls
    float buttonWidth = 50 * scale;
    if (g_isRunning) {
        if (UI::Button(Icons::Pause, vec2(buttonWidth, buttonWidth))) PauseTimer();
        if (UI::IsItemHovered()) UI::SetTooltip("Pause");
    } else {
        if (UI::Button(Icons::Play, vec2(buttonWidth, buttonWidth))) StartTimer();
        if (UI::IsItemHovered()) UI::SetTooltip("Start");
    }
    UI::SameLine();
    if (UI::Button(Icons::Refresh, vec2(buttonWidth, buttonWidth))) ResetTimer();
    if (UI::IsItemHovered()) UI::SetTooltip("Reset");
    UI::SameLine();
    if (UI::Button(Icons::FastForward, vec2(buttonWidth, buttonWidth))) OnTimerComplete();
    if (UI::IsItemHovered()) UI::SetTooltip("Skip to next session");
}
