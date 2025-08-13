// Tasks persistence and statistics tracking

// ===== TASK DATA STRUCTURE =====
class Task {
    string text;
    bool done;
    Task() {}
    Task(const string &in t, bool d=false) { text = t; done = d; }
    Json::Value ToJson() {
        Json::Value o = Json::Object();
        o["text"] = text;
        o["done"] = done;
        return o;
    }
}

array<Task@> g_tasks;
string g_newTaskText = "";
const string TASKS_FILE = IO::FromStorageFolder("PomodoroTasks.json");
const string TASKS_STATS_FILE = IO::FromStorageFolder("PomodoroTaskStats.json");

// Auto-focus flag for add-input
bool g_focusNewTaskInput = false;

// ===== STATISTICS DATA STRUCTURE =====
class DailyStat {
    string date; // YYYY-MM-DD format
    int count;
    DailyStat() { count = 0; }
    DailyStat(const string &in d, int c) { date = d; count = c; }

    Json::Value ToJson() {
        Json::Value o = Json::Object();
        o["date"] = date;
        o["count"] = count;
        return o;
    }
}

array<DailyStat@> g_dailyStats;
int g_statsTotalCompleted = 0; // Keep total as a separate, ever-increasing value

const uint64 DAY_S = 24 * 60 * 60; // Day in seconds
const int STATS_HISTORY_DAYS = 14; // Keep 14 days of history

// ===== TASKS PERSISTENCE =====
void LoadTasks() {
    g_tasks.RemoveRange(0, g_tasks.Length);
    Json::Value data = Json::FromFile(TASKS_FILE);
    if (data.GetType() == Json::Type::Array) {
        for (uint i = 0; i < data.Length; i++) {
            string t = data[i].HasKey("text") ? string(data[i]["text"]) : "";
            bool d = data[i].HasKey("done") ? bool(data[i]["done"]) : false;
            g_tasks.InsertLast(Task(t, d));
        }
    }
}

void SaveTasks() {
    Json::Value arr = Json::Array();
    for (uint i = 0; i < g_tasks.Length; i++) {
        arr.Add(g_tasks[i].ToJson());
    }
    Json::ToFile(TASKS_FILE, arr);
}

// ===== STATISTICS PERSISTENCE =====

// Helper to get a date as YYYY-MM-DD string from a unix timestamp
string GetDateString(int64 timestamp) {
    auto info = Time::Parse(timestamp);
    string month = info.Month < 10 ? "0" + info.Month : "" + info.Month;
    string day = info.Day < 10 ? "0" + info.Day : "" + info.Day;
    return info.Year + "-" + month + "-" + day;
}

void LoadTaskStats() {
    g_dailyStats.RemoveRange(0, g_dailyStats.Length);
    Json::Value data = Json::FromFile(TASKS_STATS_FILE);

    if (data.GetType() == Json::Type::Object) {
        // Check for new "daily" key first
        if (data.HasKey("daily") && data["daily"].GetType() == Json::Type::Array) {
            auto dailyData = data["daily"];
            for (uint i = 0; i < dailyData.Length; i++) {
                string date = dailyData[i].HasKey("date") ? string(dailyData[i]["date"]) : "";
                int count = dailyData[i].HasKey("count") ? int(dailyData[i]["count"]) : 0;
                if (date.Length > 0 && count > 0) {
                    g_dailyStats.InsertLast(DailyStat(date, count));
                }
            }
            g_statsTotalCompleted = data.HasKey("total") ? int(data["total"]) : 0;
        } else {
            // Handle migration from old format
            LogVerbose("Migrating old stats format to new daily format.");
            g_statsTotalCompleted = data.HasKey("total") ? int(data["total"]) : 0;
            // We can't reconstruct historical data, so we just start fresh from today.
            // The total is preserved.
        }
    }
    // Prune old stats on load
    PruneOldStats();
    SaveTaskStats(); // Save immediately to prune and/or migrate
}

void SaveTaskStats() {
    Json::Value root = Json::Object();
    Json::Value dailyArr = Json::Array();
    for (uint i = 0; i < g_dailyStats.Length; i++) {
        dailyArr.Add(g_dailyStats[i].ToJson());
    }
    root["daily"] = dailyArr;
    root["total"] = g_statsTotalCompleted;
    Json::ToFile(TASKS_STATS_FILE, root);
}

// Remove stats older than STATS_HISTORY_DAYS
void PruneOldStats() {
    int64 now = Time::Stamp;
    int64 cutoff = now - (STATS_HISTORY_DAYS * DAY_S);
    string cutoffDate = GetDateString(cutoff);

    for (int i = int(g_dailyStats.Length) - 1; i >= 0; i--) {
        if (g_dailyStats[i].date < cutoffDate) {
            LogVerbose("Pruning old stat from " + g_dailyStats[i].date);
            g_dailyStats.RemoveAt(i);
        }
    }
}

void RecordTaskCompletedEvent() {
    string todayStr = GetDateString(Time::Stamp);
    DailyStat@ todayStat = null;

    // Find today's stat entry
    for (uint i = 0; i < g_dailyStats.Length; i++) {
        if (g_dailyStats[i].date == todayStr) {
            @todayStat = g_dailyStats[i];
            break;
        }
    }

    // If not found, create it
    if (todayStat is null) {
        @todayStat = DailyStat(todayStr, 0);
        g_dailyStats.InsertLast(todayStat);
    }

    todayStat.count++;
    g_statsTotalCompleted++;

    // Prune old entries and save
    PruneOldStats();
    SaveTaskStats();
}

void ResetTaskStats() {
    g_dailyStats.RemoveRange(0, g_dailyStats.Length);
    g_statsTotalCompleted = 0;
    SaveTaskStats();
}

// ===== STATISTICS HELPERS (for UI) =====

// Get completions for today
int GetTodayCompletions() {
    string todayStr = GetDateString(Time::Stamp);
    for (uint i = 0; i < g_dailyStats.Length; i++) {
        if (g_dailyStats[i].date == todayStr) {
            return g_dailyStats[i].count;
        }
    }
    return 0;
}

// Get completions for the last 7 days (including today)
int GetLast7DaysCompletions() {
    int64 now = Time::Stamp;
    int total = 0;
    for (int i = 0; i < 7; i++) {
        string dateStr = GetDateString(now - (i * DAY_S));
        for (uint j = 0; j < g_dailyStats.Length; j++) {
            if (g_dailyStats[j].date == dateStr) {
                total += g_dailyStats[j].count;
                break;
            }
        }
    }
    return total;
}

// Get data for the last 7 days for the bar chart
array<float> GetLast7DaysChartData() {
    array<float> data(7, 0.0f);
    int64 now = Time::Stamp;
    // Iterate backwards from today (day 6) to 6 days ago (day 0)
    for (int i = 0; i < 7; i++) {
        int dayIndex = 6 - i;
        string dateStr = GetDateString(now - (i * DAY_S));
        for (uint j = 0; j < g_dailyStats.Length; j++) {
            if (g_dailyStats[j].date == dateStr) {
                data[dayIndex] = float(g_dailyStats[j].count);
                break;
            }
        }
    }
    return data;
}
