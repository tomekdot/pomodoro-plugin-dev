// Rendering functions for the Statistics UI view

void RenderStatsUI(float scale) {
    UI::Text("Productivity Stats");
    UI::Separator();

    // --- Weekly Chart ---
    auto weeklyData = GetLast7DaysChartData();
    
    UI::PlotHistogram("Last 7 Days", weeklyData, 0, 80 * scale);
    if (UI::IsItemHovered()) {
        UI::SetTooltip("Tasks completed over the last 7 days.\nToday is on the far right.");
    }

    UI::Dummy(vec2(0, 10 * scale));

    // --- Summary Stats ---
    if (UI::BeginTable("stats-summary", 2, UI::TableFlags::SizingStretchProp)) {
        UI::TableSetupColumn("Label", UI::TableColumnFlags::WidthStretch);
        UI::TableSetupColumn("Value", UI::TableColumnFlags::WidthStretch);

        UI::TableNextRow();
        UI::TableNextColumn(); UI::Text("Tasks completed today");
        UI::TableNextColumn(); UI::Text(GetTodayCompletions() + "");

        UI::TableNextRow();
        UI::TableNextColumn(); UI::Text("Tasks completed this week");
        UI::TableNextColumn(); UI::Text(GetLast7DaysCompletions() + "");

        UI::TableNextRow();
        UI::TableNextColumn(); UI::Text("Total tasks completed");
        UI::TableNextColumn(); UI::Text(g_statsTotalCompleted + "");

        UI::EndTable();
    }

    UI::Dummy(vec2(0, 10 * scale));
    UI::Separator();

    // --- Actions ---
    if (UI::Button("Reset All Stats")) {
        ResetTaskStats();
    }
    if (UI::IsItemHovered()) {
        UI::SetTooltip("This will permanently delete all of your recorded statistics.");
    }
}