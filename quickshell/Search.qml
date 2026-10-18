// Search.qml: settings and logic (no visuals).
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // ---- Settings ----
    property string terminal: "ghostty"                // foot, alacritty, kitty...
    property string searchUrl: "https://google.com/search?q="
    property int maxApps: 5

    // Fuzzy match: query letters must appear in order. Returns -1 if no match.
    function fuzzy(q, s) {
        s = s.toLowerCase()
        let qi = 0, score = 0, last = -1
        for (let i = 0; i < s.length && qi < q.length; i++) {
            if (s[i] === q[qi]) {
                score += (last === i - 1) ? 5 : 1   // reward consecutive letters
                if (i === 0) score += 5             // reward matching the start
                last = i
                qi++
            }
        }
        return qi === q.length ? score : -1
    }

    // Build the result list for the typed text.
    function build(text) {
        const q = text.toLowerCase().trim()
        if (q === "") return []

        const apps = DesktopEntries.applications.values
            .filter(e => !e.noDisplay)
            .map(e => ({ e: e, score: fuzzy(q, e.name) }))
            .filter(x => x.score >= 0)
            .sort((a, b) => b.score - a.score)
            .slice(0, maxApps)
            .map(x => ({ kind: "app", label: x.e.name, icon: x.e.icon, entry: x.e }))

        return apps.concat([
            { kind: "web", label: "Search Web for: " + text.trim(), icon: "" },
            { kind: "term", label: "Execute in Terminal: " + text.trim(), icon: "" }
        ])
    }

    // Do what the selected result says.
    function run(item, text) {
        if (!item) return
        const t = text.trim()
        if (item.kind === "app")
            item.entry.execute()
        else if (item.kind === "web")
            Quickshell.execDetached(["xdg-open", searchUrl + encodeURIComponent(t)])
        else if (item.kind === "term")
            Quickshell.execDetached([terminal, "-e", "sh", "-c", t])
    }
}
